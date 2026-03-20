require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cookieParser = require('cookie-parser');
const {
  isValidEmail, isValidName, isValidPassword, validateAirplaneData,
} = require('./validators');

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
// Rate-limiter en mémoire
// -----------------------------------------------------------------------------
const rateLimitStore = new Map();

function rateLimit({ windowMs = 15 * 60 * 1000, max = 100, message = 'Trop de requêtes, réessayez plus tard.' } = {}) {
  return (req, res, next) => {
    const key = req.ip;
    const now = Date.now();
    const record = rateLimitStore.get(key);

    if (!record || now - record.start > windowMs) {
      rateLimitStore.set(key, { start: now, count: 1 });
      return next();
    }

    record.count++;
    if (record.count > max) {
      return res.status(429).json({ message });
    }
    next();
  };
}

// Nettoyage périodique
const cleanupInterval = setInterval(() => {
  const now = Date.now();
  for (const [key, record] of rateLimitStore) {
    if (now - record.start > 15 * 60 * 1000) rateLimitStore.delete(key);
  }
}, 60 * 1000);

// Expose pour cleanup dans les tests
app.getRateLimitStore = () => rateLimitStore;
app.stopCleanup = () => clearInterval(cleanupInterval);

// -----------------------------------------------------------------------------
// Pool PostgreSQL (injectable pour les tests)
// -----------------------------------------------------------------------------
let pool;

app.setPool = (p) => { pool = p; };
app.getPool = () => pool;

// Initialisation par défaut (production)
if (process.env.NODE_ENV !== 'test') {
  const { Pool } = require('pg');
  pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
  });
}

// -----------------------------------------------------------------------------
// Fichiers statiques
// -----------------------------------------------------------------------------
app.use(express.static(path.join(__dirname, '../frontend/')));
app.use('/css', express.static(path.join(__dirname, '../frontend/css')));
app.use('/js', express.static(path.join(__dirname, '../frontend/js')));

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
// Auth: helpers JWT
// -----------------------------------------------------------------------------
const ACCESS_TOKEN_EXPIRY = '15m';
const REFRESH_TOKEN_EXPIRY = '7d';
const REFRESH_COOKIE_NAME = 'refreshToken';
const REFRESH_COOKIE_MAX_AGE = 7 * 24 * 60 * 60 * 1000; // 7 jours en ms

function generateAccessToken(user) {
  return jwt.sign(
    { id: user.id, name: user.name, role: user.role_id ?? user.role, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: ACCESS_TOKEN_EXPIRY }
  );
}

function generateRefreshToken(user) {
  return jwt.sign(
    { id: user.id, role: user.role_id ?? user.role },
    process.env.REFRESH_SECRET,
    { expiresIn: REFRESH_TOKEN_EXPIRY }
  );
}

function setRefreshCookie(res, token) {
  res.cookie(REFRESH_COOKIE_NAME, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: REFRESH_COOKIE_MAX_AGE,
    path: '/api',
  });
}

function clearRefreshCookie(res) {
  res.clearCookie(REFRESH_COOKIE_NAME, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    path: '/api',
  });
}

// -----------------------------------------------------------------------------
// Auth: middleware d'autorisation
// -----------------------------------------------------------------------------
const authorize = (roles) => {
  return (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(403).json({ message: 'Accès interdit' });

    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const coercedRole = Number(decoded.role);
      if (!roles.includes(coercedRole)) {
        return res.status(403).json({ message: 'Accès non autorisé' });
      }
      req.user = { ...decoded, role: coercedRole };
      next();
    } catch (error) {
      // Distinguer token expiré vs token invalide
      if (error.name === 'TokenExpiredError') {
        return res.status(401).json({ message: 'Token expiré', code: 'TOKEN_EXPIRED' });
      }
      return res.status(401).json({ message: 'Token invalide', code: 'TOKEN_INVALID' });
    }
  };
};

// -----------------------------------------------------------------------------
// Auth: inscription & connexion
// -----------------------------------------------------------------------------
app.post('/api/register',
  rateLimit({ windowMs: 15 * 60 * 1000, max: 10, message: "Trop de tentatives d'inscription, réessayez dans 15 minutes." }),
  async (req, res) => {
    const { name, email, password } = req.body;

    if (!name || !isValidName(name)) {
      return res.status(400).json({ message: 'Nom invalide (2-255 caractères)' });
    }
    if (!email || !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }
    if (!password || !isValidPassword(password)) {
      return res.status(400).json({ message: 'Mot de passe invalide (4-128 caractères)' });
    }

    try {
      const userExists = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
      if (userExists.rows.length > 0) {
        return res.status(400).json({ message: 'Email déjà utilisé' });
      }

      const hashedPassword = await bcrypt.hash(password, 10);
      const defaultRole = 3;

      await pool.query(
        'INSERT INTO users (name, email, password, role_id) VALUES ($1, $2, $3, $4)',
        [name, email, hashedPassword, defaultRole]
      );

      res.status(201).json({ message: 'Utilisateur créé avec succès' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erreur serveur' });
    }
  }
);

app.post('/api/login',
  rateLimit({ windowMs: 15 * 60 * 1000, max: 20, message: "Trop de tentatives de connexion, réessayez dans 15 minutes." }),
  async (req, res) => {
    const { email, password } = req.body;

    if (!email || !isValidEmail(email)) {
      return res.status(400).json({ message: 'Email invalide' });
    }
    if (!password || typeof password !== 'string') {
      return res.status(400).json({ message: 'Mot de passe requis' });
    }

    try {
      const user = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
      if (user.rows.length === 0) {
        return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
      }

      const validPassword = await bcrypt.compare(password, user.rows[0].password);
      if (!validPassword) {
        return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
      }

      const userData = user.rows[0];
      const accessToken = generateAccessToken(userData);
      const refreshToken = generateRefreshToken(userData);

      setRefreshCookie(res, refreshToken);

      res.json({ message: 'Connexion réussie', token: accessToken });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erreur serveur' });
    }
  }
);

// -----------------------------------------------------------------------------
// Auth: refresh & logout
// -----------------------------------------------------------------------------
app.post('/api/refresh', async (req, res) => {
  const refreshToken = req.cookies[REFRESH_COOKIE_NAME];
  if (!refreshToken) {
    return res.status(401).json({ message: 'Aucun refresh token', code: 'NO_REFRESH_TOKEN' });
  }

  try {
    const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET);

    // Récupérer les données fraîches de l'utilisateur en DB
    const result = await pool.query(
      'SELECT id, name, email, role_id FROM users WHERE id = $1',
      [decoded.id]
    );
    if (result.rows.length === 0) {
      clearRefreshCookie(res);
      return res.status(401).json({ message: 'Utilisateur introuvable', code: 'USER_NOT_FOUND' });
    }

    const user = result.rows[0];
    const newAccessToken = generateAccessToken(user);

    res.json({ token: newAccessToken });
  } catch (error) {
    clearRefreshCookie(res);
    return res.status(401).json({ message: 'Refresh token invalide', code: 'REFRESH_INVALID' });
  }
});

app.post('/api/logout', (req, res) => {
  clearRefreshCookie(res);
  res.json({ message: 'Déconnexion réussie' });
});

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
    return res.status(400).json({ message: 'Mot de passe invalide (4-128 caractères)' });
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
    if (email) { fields.push(`email = $${i++}`); values.push(email); }
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

    res.json({ message: 'Mise à jour réussie', user: result.rows[0] });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

app.put('/api/admin/users/:id', authorize([1]), async (req, res) => {
  const { id } = req.params;
  const { name, role_id } = req.body;

  try {
    const result = await pool.query(
      'UPDATE users SET name = $1, role_id = $2 WHERE id = $3 RETURNING id, name, email, role_id',
      [name, role_id, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
    res.json(result.rows[0]);
  } catch (error) {
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
// Avions
// -----------------------------------------------------------------------------
app.get('/api/airplanes', async (req, res) => {
  try {
    const sort = req.query.sort || 'default';
    const country = req.query.country || '';
    const generation = req.query.generation || '';
    const type = req.query.type || '';

    let query = `
      SELECT a.id, a.name, a.complete_name, a.little_description, a.image_url, 
             a.max_speed, c.name as country_name, g.generation, t.name as type_name,
             a.date_operationel
      FROM airplanes a
      LEFT JOIN countries c ON a.country_id = c.id
      LEFT JOIN generation g ON a.id_generation = g.id
      LEFT JOIN type t ON a.type = t.id
    `;
    const queryParams = [];

    if (country) {
      query += ` WHERE c.name = $${queryParams.length + 1}`;
      queryParams.push(country);
    } else if (generation) {
      query += ` WHERE g.generation = $${queryParams.length + 1}`;
      queryParams.push(generation);
    } else if (type) {
      query += ` WHERE t.name = $${queryParams.length + 1}`;
      queryParams.push(type);
    }

    switch (sort) {
      case 'nation': query += ' ORDER BY c.name ASC'; break;
      case 'service-date': query += ' ORDER BY a.date_operationel DESC'; break;
      case 'alphabetical': query += ' ORDER BY a.name ASC'; break;
      case 'generation': query += ' ORDER BY g.generation DESC'; break;
      case 'type': query += ' ORDER BY t.name ASC'; break;
      default: query += ' ORDER BY a.id ASC';
    }

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

app.get('/api/countries', async (req, res) => {
  try {
    const result = await pool.query('SELECT id, name FROM countries ORDER BY name ASC');
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
      'INSERT INTO favorites (user_id, airplane_id) VALUES ($1, $2) ON CONFLICT DO NOTHING',
      [userId, airplaneId]
    );
    res.json({ message: 'Ajouté aux favoris' });
  } catch (error) {
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
      earliest_year: datesRes.rows[0].earliest,
      latest_year: datesRes.rows[0].latest,
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
app.get('*', (req, res, next) => {
  // Ignorer les requêtes API et les fichiers avec extension
  if (req.path.startsWith('/api/') || path.extname(req.path)) {
    return next();
  }

  const htmlFile = path.join(__dirname, '../frontend', req.path + '.html');
  if (fs.existsSync(htmlFile)) {
    return res.sendFile(htmlFile);
  }

  // 404 personnalisé
  const notFoundFile = path.join(__dirname, '../frontend/404.html');
  if (fs.existsSync(notFoundFile)) {
    return res.status(404).sendFile(notFoundFile);
  }
  res.status(404).send('Page non trouvée');
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

module.exports = app;
