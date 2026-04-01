require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cookieParser = require('cookie-parser');
const crypto = require('crypto');
const {
  isValidEmail, isValidName, isValidPassword, validateAirplaneData,
} = require('./validators');
const mailer = require('./mailer');
const authMiddleware = require('./middleware/auth');
const {
  authorize, generateAccessToken, generateRefreshToken,
  storeRefreshToken, isRefreshTokenValid, revokeRefreshToken,
  revokeAllUserRefreshTokens, cleanupExpiredTokens,
  setRefreshCookie, clearRefreshCookie, REFRESH_COOKIE_NAME,
} = authMiddleware;

const app = express();

// -----------------------------------------------------------------------------
// Sécurité : Headers HTTP
// -----------------------------------------------------------------------------
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.setHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
  res.setHeader('Content-Security-Policy', [
    "default-src 'self'",
    "script-src 'self' https://www.googletagmanager.com https://www.google-analytics.com",
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdnjs.cloudflare.com",
    "font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com",
    "img-src 'self' https://i.postimg.cc https://flagcdn.com https://www.googletagmanager.com data:",
    "connect-src 'self' https://www.google-analytics.com https://www.googletagmanager.com",
    "media-src 'self'",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'none'",
  ].join('; '));
  res.removeHeader('X-Powered-By');
  next();
});

// -----------------------------------------------------------------------------
// Sécurité : CORS restreint
// -----------------------------------------------------------------------------
const allowedOrigins = process.env.ALLOWED_ORIGINS
  ? process.env.ALLOWED_ORIGINS.split(',')
  : ['http://localhost:3000', 'https://vol-histoire.titouan-borde.com'];

app.use(cors({
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Origine non autorisée par CORS'));
    }
  },
  credentials: true,
}));

app.use(express.json({ limit: '100kb' }));
app.use(cookieParser());

// -----------------------------------------------------------------------------
// Rate-limiter (express-rate-limit)
// -----------------------------------------------------------------------------
// En production multi-instances, ajouter un store Redis :
//   npm install rate-limit-redis ioredis
//   const RedisStore = require('rate-limit-redis');
//   const Redis = require('ioredis');
//   const redisClient = new Redis(process.env.REDIS_URL);
//   Puis passer { store: new RedisStore({ sendCommand: (...args) => redisClient.call(...args) }) }
//   dans chaque rateLimit() ci-dessous.
// -----------------------------------------------------------------------------
const rateLimit = require('express-rate-limit');

const registerLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  message: { message: "Trop de tentatives d'inscription, réessayez dans 15 minutes." },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
});

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: { message: "Trop de tentatives de connexion, réessayez dans 15 minutes." },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
});

const globalApiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200,
  message: { message: 'Trop de requêtes, réessayez plus tard.' },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
});

const emailLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 3,
  message: { message: 'Trop de demandes, réessayez dans 15 minutes.' },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
  skip: () => process.env.NODE_ENV === 'test',
});

// Appliquer le limiteur global à toutes les routes API
app.use('/api/', globalApiLimiter);

// -----------------------------------------------------------------------------
// Pool PostgreSQL (injectable pour les tests)
// -----------------------------------------------------------------------------
let pool;

app.setPool = (p) => { pool = p; authMiddleware.setPool(p); };
app.getPool = () => pool;

// -----------------------------------------------------------------------------
// Fichiers statiques
// -----------------------------------------------------------------------------
app.use(express.static(path.join(__dirname, '../frontend/')));
app.use('/css', express.static(path.join(__dirname, '../frontend/css')));
app.use('/js', express.static(path.join(__dirname, '../frontend/js')));

// Routes HTML sans extension (utile en dev local — en prod c'est Apache/.htaccess qui gère)
const htmlPages = [
  'verify-email', 'forgot-password', 'reset-password', 'check-email',
  'hangar', 'details', 'timeline', 'favorites', 'login', 'settings',
  'a-propos', 'contact', 'faq', 'support', 'mentions-legales',
  'politique-confidentialite', 'cgu',
];
htmlPages.forEach(page => {
  app.get(`/${page}`, (req, res) => {
    res.sendFile(path.join(__dirname, `../frontend/${page}.html`));
  });
});
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/index.html'));
});

// -----------------------------------------------------------------------------
// Validation des IDs
// -----------------------------------------------------------------------------
app.param('id', (req, res, next, value) => {
  if (!/^\d+$/.test(value)) {
    return res.status(400).json({ message: 'ID invalide' });
  }
  next();
});

app.param('airplaneId', (req, res, next, value) => {
  if (!/^\d+$/.test(value)) {
    return res.status(400).json({ message: 'ID avion invalide' });
  }
  next();
});

// -----------------------------------------------------------------------------
// Auth routes (inscription, connexion, refresh, logout, vérification email,
//              mot de passe oublié/réinitialisation)
// -----------------------------------------------------------------------------
const createAuthRouter = require('./routes/auth');
app.use('/api', createAuthRouter(() => pool, { registerLimiter, loginLimiter, emailLimiter, mailer }));

// -----------------------------------------------------------------------------
// Utilisateurs
// -----------------------------------------------------------------------------
app.get('/api/users', authorize([1]), async (req, res) => {
  try {
    const result = await pool.query('SELECT id, name, email, role_id FROM users');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/users/:id', authorize([1, 2, 3]), async (req, res) => {
  const { id } = req.params;
  const requester = req.user;
  if (Number(requester.id) !== Number(id) && requester.role !== 1) {
    return res.status(403).json({ message: 'Accès non autorisé' });
  }

  try {
    const result = await pool.query('SELECT id, name, email, role_id FROM users WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

app.put('/api/users/:id', authorize([1, 2, 3]), async (req, res) => {
  const { id } = req.params;
  const { name, email, password } = req.body;

  if (name !== undefined && !isValidName(name)) {
    return res.status(400).json({ message: 'Nom invalide (2-255 caractères)' });
  }
  if (email !== undefined && !isValidEmail(email)) {
    return res.status(400).json({ message: 'Email invalide' });
  }
  if (password !== undefined && !isValidPassword(password)) {
    return res.status(400).json({ message: 'Mot de passe invalide (8-128 caractères, 1 majuscule, 1 minuscule, 1 chiffre)' });
  }

  const requester = req.user;
  if (Number(requester.id) !== Number(id) && requester.role !== 1) {
    return res.status(403).json({ message: 'Accès non autorisé' });
  }

  try {
    let hashedPassword;
    if (password) {
      hashedPassword = await bcrypt.hash(password, 10);
    }

    const fields = [];
    const values = [];
    let i = 1;

    if (name) { fields.push(`name = $${i++}`); values.push(name); }
    if (email) { fields.push(`email = $${i++}`); values.push(email.trim().toLowerCase()); }
    if (password) { fields.push(`password = $${i++}`); values.push(hashedPassword); }

    if (fields.length === 0) {
      return res.status(400).json({ message: 'Aucune donnée à mettre à jour' });
    }

    values.push(id);
    const query = `UPDATE users SET ${fields.join(', ')} WHERE id = $${i} RETURNING id, name, email, role_id`;
    const result = await pool.query(query, values);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }

    // Révoquer tous les refresh tokens lors d'un changement de mot de passe
    if (password) {
      await revokeAllUserRefreshTokens(id);
    }

    res.json({ message: 'Mise à jour réussie', user: result.rows[0] });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

app.put('/api/admin/users/:id', authorize([1]), async (req, res) => {
  const { id } = req.params;
  const { name, email, role_id } = req.body;

  if (!name || !isValidName(name)) {
    return res.status(400).json({ message: 'Nom invalide (2-255 caractères)' });
  }
  if (email !== undefined && !isValidEmail(email)) {
    return res.status(400).json({ message: 'Email invalide' });
  }
  const validRoles = [1, 2, 3];
  if (role_id === undefined || !validRoles.includes(Number(role_id))) {
    return res.status(400).json({ message: 'Rôle invalide (1 = admin, 2 = éditeur, 3 = membre)' });
  }

  const fields = [];
  const values = [];
  let i = 1;
  if (name !== undefined) { fields.push(`name = $${i++}`); values.push(name.trim()); }
  if (email !== undefined) { fields.push(`email = $${i++}`); values.push(email.trim().toLowerCase()); }
  if (role_id !== undefined) { fields.push(`role_id = $${i++}`); values.push(Number(role_id)); }

  if (fields.length === 0) {
    return res.status(400).json({ message: 'Aucune donnée à mettre à jour' });
  }

  try {
    values.push(id);
    const result = await pool.query(
      `UPDATE users SET ${fields.join(', ')} WHERE id = $${i} RETURNING id, name, email, role_id`,
      values
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    if (error.code === '23505') {
      return res.status(409).json({ message: 'Cet email est déjà utilisé' });
    }
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.delete('/api/users/:id', authorize([1, 2, 3]), async (req, res) => {
  const { id } = req.params;
  const requester = req.user;
  if (Number(requester.id) !== Number(id) && requester.role !== 1) {
    return res.status(403).json({ message: 'Accès non autorisé' });
  }

  try {
    await revokeAllUserRefreshTokens(id);
    const result = await pool.query('DELETE FROM users WHERE id = $1 RETURNING id', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    res.json({ message: 'Compte supprimé avec succès' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// -----------------------------------------------------------------------------
// Sitemap dynamique
// -----------------------------------------------------------------------------
app.get('/sitemap.xml', async (req, res) => {
  const BASE_URL = 'https://vol-histoire.titouan-borde.com';
  const today = new Date().toISOString().split('T')[0];

  const staticPages = [
    { loc: '/',                         changefreq: 'weekly',  priority: '1.0' },
    { loc: '/hangar',                   changefreq: 'weekly',  priority: '0.9' },
    { loc: '/timeline',                 changefreq: 'monthly', priority: '0.8' },
    { loc: '/a-propos',                 changefreq: 'monthly', priority: '0.6' },
    { loc: '/contact',                  changefreq: 'yearly',  priority: '0.5' },
    { loc: '/faq',                      changefreq: 'monthly', priority: '0.5' },
    { loc: '/support',                  changefreq: 'monthly', priority: '0.4' },
    { loc: '/mentions-legales',         changefreq: 'yearly',  priority: '0.2' },
    { loc: '/politique-confidentialite',changefreq: 'yearly',  priority: '0.2' },
    { loc: '/cgu',                      changefreq: 'yearly',  priority: '0.2' },
  ];

  try {
    const result = await pool.query('SELECT id FROM airplanes ORDER BY id ASC');

    const staticUrls = staticPages.map(p => `
  <url>
    <loc>${BASE_URL}${p.loc}</loc>
    <lastmod>${today}</lastmod>
    <changefreq>${p.changefreq}</changefreq>
    <priority>${p.priority}</priority>
  </url>`).join('');

    const airplaneUrls = result.rows.map(row => `
  <url>
    <loc>${BASE_URL}/details?id=${row.id}</loc>
    <lastmod>${today}</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>`).join('');

    const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${staticUrls}${airplaneUrls}
</urlset>`;

    res.set('Content-Type', 'application/xml');
    res.send(xml);
  } catch (error) {
    res.status(500).send('Erreur serveur');
  }
});

// -----------------------------------------------------------------------------
// Avions
// -----------------------------------------------------------------------------
app.get('/api/airplanes', async (req, res) => {
  try {
    const sort = req.query.sort || 'default';
    const country = req.query.country || '';
    const generation = req.query.generation || '';
    const type = req.query.type || '';

    // S4 FIX : Valider que generation est un entier positif s'il est fourni
    if (generation && (!/^\d+$/.test(generation) || Number(generation) < 1 || Number(generation) > 10)) {
      return res.status(400).json({ message: 'Paramètre generation invalide (entier entre 1 et 10)' });
    }

    let query = `
      SELECT a.id, a.name, a.complete_name, a.little_description, a.image_url,
             a.max_speed, c.name as country_name, c.code as country_code,
             g.generation, t.name as type_name,
             a.date_operationel
      FROM airplanes a
      LEFT JOIN countries c ON a.country_id = c.id
      LEFT JOIN generation g ON a.id_generation = g.id
      LEFT JOIN type t ON a.type = t.id
    `;
    const queryParams = [];
    const conditions = [];

    // S4 FIX : Combiner les filtres avec AND au lieu de else if
    if (country) {
      queryParams.push(country);
      conditions.push(`c.name = $${queryParams.length}`);
    }
    if (generation) {
      queryParams.push(Number(generation));
      conditions.push(`g.generation = $${queryParams.length}`);
    }
    if (type) {
      queryParams.push(type);
      conditions.push(`t.name = $${queryParams.length}`);
    }

    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }

    // S4 FIX : Whitelist stricte du tri pour éviter toute injection
    const sortMap = {
      'nation': 'c.name ASC',
      'service-date': 'a.date_operationel DESC',
      'alphabetical': 'a.name ASC',
      'generation': 'g.generation DESC',
      'type': 't.name ASC',
    };
    query += ' ORDER BY ' + (sortMap[sort] || 'a.id ASC');

    const result = await pool.query(query, queryParams);
    res.json({ data: result.rows });
  } catch (err) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/airplanes/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `SELECT airplanes.*, 
              manufacturer.name AS manufacturer_name, 
              generation.generation, 
              type.name AS type_name, 
              countries.name AS country_name
       FROM airplanes
       LEFT JOIN manufacturer ON airplanes.id_manufacturer = manufacturer.id
       LEFT JOIN generation ON airplanes.id_generation = generation.id
       LEFT JOIN type ON airplanes.type = type.id
       LEFT JOIN countries ON airplanes.country_id = countries.id
       WHERE airplanes.id = $1`,
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Avion non trouvé' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/airplanes/:id/armament', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `SELECT armement.name, armement.description
       FROM airplane_armement
       JOIN armement ON airplane_armement.id_armement = armement.id
       WHERE airplane_armement.id_airplane = $1`,
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/airplanes/:id/tech', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `SELECT t.name, t.description 
       FROM airplane_tech at
       JOIN tech t ON at.id_tech = t.id
       WHERE at.id_airplane = $1`,
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/airplanes/:id/missions', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `SELECT missions.name, missions.description
       FROM airplane_missions
       JOIN missions ON airplane_missions.id_mission = missions.id
       WHERE airplane_missions.id_airplane = $1`,
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/airplanes/:id/wars', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `SELECT wars.name, wars.date_start, wars.date_end, wars.description
       FROM airplane_wars
       JOIN wars ON airplane_wars.id_wars = wars.id
       WHERE airplane_wars.id_airplane = $1`,
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/airplanes/:id/related', async (req, res) => {
  const { id } = req.params;
  try {
    const [armamentRes, techRes, missionsRes, warsRes] = await Promise.all([
      pool.query(
        `SELECT armement.name, armement.description FROM airplane_armement
         JOIN armement ON airplane_armement.id_armement = armement.id
         WHERE airplane_armement.id_airplane = $1`, [id]
      ),
      pool.query(
        `SELECT t.name, t.description FROM airplane_tech at
         JOIN tech t ON at.id_tech = t.id
         WHERE at.id_airplane = $1`, [id]
      ),
      pool.query(
        `SELECT missions.name, missions.description FROM airplane_missions
         JOIN missions ON airplane_missions.id_mission = missions.id
         WHERE airplane_missions.id_airplane = $1`, [id]
      ),
      pool.query(
        `SELECT wars.name, wars.date_start, wars.date_end, wars.description FROM airplane_wars
         JOIN wars ON airplane_wars.id_wars = wars.id
         WHERE airplane_wars.id_airplane = $1`, [id]
      )
    ]);
    res.json({
      armament: armamentRes.rows,
      tech: techRes.rows,
      missions: missionsRes.rows,
      wars: warsRes.rows
    });
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/countries', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT id, name FROM countries WHERE id IN (SELECT DISTINCT country_id FROM airplanes WHERE country_id IS NOT NULL) ORDER BY name ASC'
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/generations', async (req, res) => {
  try {
    const result = await pool.query('SELECT DISTINCT generation FROM generation ORDER BY generation ASC');
    res.json(result.rows.map((row) => row.generation));
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/types', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM type');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/manufacturers', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT m.*, c.name as country_name 
      FROM manufacturer m
      JOIN countries c ON m.country_id = c.id
    `);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Vérifie l'existence des clés étrangères d'un avion en une seule requête.
// Retourne un tableau de messages d'erreur (vide si tout est valide).
async function validateAirplaneFKs(pool, { country_id, id_manufacturer, id_generation, type }) {
  const clean = (v) => (v === '' || v === undefined) ? null : v;
  const checks = await pool.query(
    `SELECT
      ($1::integer IS NULL OR EXISTS(SELECT 1 FROM countries    WHERE id = $1)) AS country_ok,
      ($2::integer IS NULL OR EXISTS(SELECT 1 FROM manufacturer WHERE id = $2)) AS manufacturer_ok,
      ($3::integer IS NULL OR EXISTS(SELECT 1 FROM generation   WHERE id = $3)) AS generation_ok,
      ($4::integer IS NULL OR EXISTS(SELECT 1 FROM type         WHERE id = $4)) AS type_ok`,
    [clean(country_id), clean(id_manufacturer), clean(id_generation), clean(type)]
  );
  const { country_ok, manufacturer_ok, generation_ok, type_ok } = checks.rows[0];
  const errors = [];
  if (!country_ok)      errors.push('country_id invalide');
  if (!manufacturer_ok) errors.push('id_manufacturer invalide');
  if (!generation_ok)   errors.push('id_generation invalide');
  if (!type_ok)         errors.push('type invalide');
  return errors;
}

app.post('/api/airplanes', authorize([1, 2]), async (req, res) => {
  const errors = validateAirplaneData(req.body);
  if (errors.length > 0) {
    return res.status(400).json({ message: 'Données invalides', errors });
  }

  const {
    name, complete_name, little_description, image_url, description,
    country_id, date_concept, date_first_fly, date_operationel,
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight,
  } = req.body;

  const clean = (v) => (v === '' || v === undefined) ? null : v;

  try {
    const fkErrors = await validateAirplaneFKs(pool, { country_id, id_manufacturer, id_generation, type });
    if (fkErrors.length > 0) {
      return res.status(400).json({ message: 'Référence invalide', errors: fkErrors });
    }

    const result = await pool.query(
      `INSERT INTO airplanes 
        (name, complete_name, little_description, image_url, description, country_id, 
         date_concept, date_first_fly, date_operationel, max_speed, max_range, 
         id_manufacturer, id_generation, type, status, weight) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16) 
       RETURNING *`,
      [
        name.trim(), clean(complete_name), clean(little_description), clean(image_url),
        clean(description), clean(country_id), clean(date_concept), clean(date_first_fly),
        clean(date_operationel), clean(max_speed), clean(max_range), clean(id_manufacturer),
        clean(id_generation), clean(type), clean(status), clean(weight),
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Erreur lors de l'ajout de l'avion" });
  }
});

app.put('/api/airplanes/:id', authorize([1, 2]), async (req, res) => {
  const { id } = req.params;

  const errors = validateAirplaneData(req.body);
  if (errors.length > 0) {
    return res.status(400).json({ message: 'Données invalides', errors });
  }

  const {
    name, complete_name, little_description, image_url, description,
    country_id, date_concept, date_first_fly, date_operationel,
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight,
  } = req.body;

  const clean = (v) => (v === '' || v === undefined) ? null : v;

  try {
    const fkErrors = await validateAirplaneFKs(pool, { country_id, id_manufacturer, id_generation, type });
    if (fkErrors.length > 0) {
      return res.status(400).json({ message: 'Référence invalide', errors: fkErrors });
    }

    const result = await pool.query(
      `UPDATE airplanes SET 
        name = $1, complete_name = $2, little_description = $3, image_url = $4, 
        description = $5, country_id = $6, date_concept = $7, date_first_fly = $8, 
        date_operationel = $9, max_speed = $10, max_range = $11, 
        id_manufacturer = $12, id_generation = $13, type = $14, status = $15, weight = $16
       WHERE id = $17 RETURNING *`,
      [
        name.trim(), clean(complete_name), clean(little_description), clean(image_url),
        clean(description), clean(country_id), clean(date_concept), clean(date_first_fly),
        clean(date_operationel), clean(max_speed), clean(max_range), clean(id_manufacturer),
        clean(id_generation), clean(type), clean(status), clean(weight), id,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Avion non trouvé' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Erreur lors de la mise à jour de l'avion" });
  }
});

app.delete('/api/airplanes/:id', authorize([1, 2]), async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('DELETE FROM airplanes WHERE id = $1 RETURNING id, name', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Avion non trouvé' });
    }
    res.json({ message: `Avion "${result.rows[0].name}" supprimé avec succès` });
  } catch (error) {
    res.status(500).json({ error: "Erreur lors de la suppression de l'avion" });
  }
});

// -----------------------------------------------------------------------------
// Favoris
// -----------------------------------------------------------------------------
app.get('/api/favorites', authorize([1, 2, 3]), async (req, res) => {
  const userId = req.user.id;
  try {
    const result = await pool.query(
      `SELECT a.id, a.name, a.complete_name, a.little_description, a.image_url,
              a.max_speed, a.date_operationel,
              c.name AS country_name, g.generation, t.name AS type_name,
              f.created_at AS favorited_at
       FROM favorites f
       JOIN airplanes a ON f.airplane_id = a.id
       LEFT JOIN countries c ON a.country_id = c.id
       LEFT JOIN generation g ON a.id_generation = g.id
       LEFT JOIN type t ON a.type = t.id
       WHERE f.user_id = $1
       ORDER BY f.created_at DESC`,
      [userId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.post('/api/favorites/:airplaneId', authorize([1, 2, 3]), async (req, res) => {
  const { airplaneId } = req.params;
  const userId = req.user.id;
  try {
    await pool.query(
      'INSERT INTO favorites (user_id, airplane_id) VALUES ($1, $2) ON CONFLICT (user_id, airplane_id) DO NOTHING',
      [userId, airplaneId]
    );
    res.status(201).json({ message: 'Ajouté aux favoris' });
  } catch (error) {
    // Violation de contrainte FK : l'avion n'existe pas
    if (error.code === '23503') {
      return res.status(404).json({ message: 'Avion introuvable' });
    }
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.delete('/api/favorites/:airplaneId', authorize([1, 2, 3]), async (req, res) => {
  const { airplaneId } = req.params;
  const userId = req.user.id;
  try {
    const result = await pool.query(
      'DELETE FROM favorites WHERE user_id = $1 AND airplane_id = $2',
      [userId, airplaneId]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Pas dans les favoris' });
    }
    res.json({ message: 'Supprimé des favoris' });
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/api/airplanes/:id/favorite', authorize([1, 2, 3]), async (req, res) => {
  const { id } = req.params;
  const userId = req.user.id;
  try {
    const result = await pool.query(
      'SELECT 1 FROM favorites WHERE user_id = $1 AND airplane_id = $2',
      [userId, id]
    );
    res.json({ isFavorite: result.rows.length > 0 });
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// -----------------------------------------------------------------------------
// Statistiques
// -----------------------------------------------------------------------------
app.get('/api/stats', async (req, res) => {
  try {
    const [countRes, datesRes, countriesRes] = await Promise.all([
      pool.query('SELECT COUNT(*)::int AS total FROM airplanes'),
      pool.query(`
        SELECT 
          MIN(EXTRACT(YEAR FROM date_first_fly))::int AS earliest,
          MAX(EXTRACT(YEAR FROM date_first_fly))::int AS latest
        FROM airplanes
        WHERE date_first_fly IS NOT NULL
      `),
      pool.query('SELECT COUNT(DISTINCT country_id)::int AS total FROM airplanes WHERE country_id IS NOT NULL'),
    ]);

    res.json({
      airplanes: countRes.rows[0].total,
      earliest_year: datesRes.rows[0].earliest ?? null,
      latest_year: datesRes.rows[0].latest ?? null,
      countries: countriesRes.rows[0].total,
    });
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// -----------------------------------------------------------------------------
// Clean URLs : /hangar → hangar.html, /a-propos → a-propos.html, etc.
// -----------------------------------------------------------------------------

// Redirection 301 : supprimer .html des URLs (SEO)
app.use((req, res, next) => {
  if (req.path.endsWith('.html') && req.method === 'GET') {
    const clean = req.path.slice(0, -5);
    const query = req.url.includes('?') ? req.url.slice(req.url.indexOf('?')) : '';
    return res.redirect(301, clean + query);
  }
  next();
});

// Servir le fichier .html correspondant à l'URL propre
const fs = require('fs');
const fsPromises = fs.promises;

// Pré-construction de la liste des pages HTML valides au démarrage (évite fs à chaque requête)
const frontendDir = path.join(__dirname, '../frontend');
const validPages = new Set();
try {
  fs.readdirSync(frontendDir).forEach((file) => {
    if (file.endsWith('.html')) {
      validPages.add('/' + file.slice(0, -5)); // /hangar, /details, /a-propos, etc.
    }
  });
} catch { /* Silencieux si le dossier n'existe pas encore (tests) */ }

app.get('*', async (req, res, next) => {
  // Ignorer les requêtes API et les fichiers avec extension
  if (req.path.startsWith('/api/') || path.extname(req.path)) {
    return next();
  }

  // Vérification rapide via le Set pré-construit
  if (validPages.has(req.path)) {
    return res.sendFile(path.join(frontendDir, req.path + '.html'));
  }

  // Fallback async pour les pages ajoutées dynamiquement après le démarrage
  const htmlFile = path.join(frontendDir, req.path + '.html');
  try {
    await fsPromises.access(htmlFile, fs.constants.F_OK);
    return res.sendFile(htmlFile);
  } catch {
    // 404 personnalisé
    const notFoundFile = path.join(frontendDir, '404.html');
    try {
      await fsPromises.access(notFoundFile, fs.constants.F_OK);
      return res.status(404).sendFile(notFoundFile);
    } catch {
      res.status(404).send('Page non trouvée');
    }
  }
});

// -----------------------------------------------------------------------------
// Gestionnaire d'erreurs global
// -----------------------------------------------------------------------------
app.use((err, req, res, next) => {
  console.error('Erreur non gérée:', err.message);
  if (err.message === 'Origine non autorisée par CORS') {
    return res.status(403).json({ message: 'Origine non autorisée' });
  }
  res.status(500).json({ message: 'Erreur interne du serveur' });
});

// -----------------------------------------------------------------------------
// Nettoyage périodique des refresh tokens expirés/révoqués (toutes les heures)
// -----------------------------------------------------------------------------
let tokenCleanupInterval;
if (process.env.NODE_ENV !== 'test') {
  tokenCleanupInterval = setInterval(async () => {
    try {
      await cleanupExpiredTokens();
    } catch (err) {
      console.error('Erreur nettoyage refresh tokens:', err.message);
    }
  }, 60 * 60 * 1000);
}

// Exposé pour les tests et le graceful shutdown
app.stopCleanup = () => {
  if (tokenCleanupInterval) clearInterval(tokenCleanupInterval);
};

// Exposé pour que d'autres routes puissent révoquer les tokens (ex: changement de MDP)
app.revokeAllUserRefreshTokens = revokeAllUserRefreshTokens;

module.exports = app;
