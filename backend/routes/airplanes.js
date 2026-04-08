const express = require('express');
const { validateAirplaneData } = require('../validators');
const { authorize } = require('../middleware/auth');
const asyncHandler = require('../middleware/asyncHandler');
const { pickLang, pickLangMany } = require('../i18n');

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

module.exports = function createAirplanesRouter(getPool, { onAirplaneChange } = {}) {
  const router = express.Router();

  // -----------------------------------------------------------------------------
  // Cache des valeurs valides (whitelist) pour les filtres /airplanes
  // Chargé en lazy depuis la BD au premier appel, puis conservé en mémoire.
  // Les référentiels (generations, types) sont gérés via fichiers SQL — aucune
  // route ne les modifie à l'exécution, donc pas besoin d'invalidation.
  // -----------------------------------------------------------------------------
  let referentialCache = null;
  async function getValidReferentials() {
    if (referentialCache) return referentialCache;
    const pool = getPool();
    const [gens, types] = await Promise.all([
      pool.query('SELECT DISTINCT generation FROM generation'),
      pool.query('SELECT name FROM type'),
    ]);
    referentialCache = {
      generations: new Set(gens.rows.map((r) => Number(r.generation))),
      typeNames: new Set(types.rows.map((r) => r.name)),
    };
    return referentialCache;
  }
  // Exposé pour les tests + invalidation manuelle si besoin
  router.invalidateReferentialCache = () => { referentialCache = null; };

  // Validation des IDs
  router.param('id', (req, res, next, value) => {
    if (!/^\d+$/.test(value)) {
      return res.status(400).json({ message: 'ID invalide' });
    }
    next();
  });

  // -----------------------------------------------------------------------------
  // Avions
  // -----------------------------------------------------------------------------
  router.get('/airplanes', asyncHandler(async (req, res) => {
    const sort = req.query.sort || 'default';
    const country = req.query.country || '';
    const generation = req.query.generation || '';
    const type = req.query.type || '';

    // Validation format (sans DB) — rejette texte, 0, négatif
    if (generation && !/^[1-9]\d*$/.test(generation)) {
      return res.status(400).json({ message: 'Paramètre generation invalide' });
    }

    // Validation stricte contre la whitelist BD (chargée lazy en mémoire)
    if (generation || type) {
      const valid = await getValidReferentials();
      if (generation && !valid.generations.has(Number(generation))) {
        return res.status(400).json({ message: 'Paramètre generation invalide' });
      }
      if (type && !valid.typeNames.has(type)) {
        return res.status(400).json({ message: 'Paramètre type invalide' });
      }
    }

    let query = `
      SELECT a.id, a.name, a.name_en, a.complete_name, a.complete_name_en,
             a.little_description, a.little_description_en, a.image_url,
             a.max_speed, c.name as country_name, c.name_en as country_name_en,
             c.code as country_code,
             g.generation, t.name as type_name, t.name_en as type_name_en,
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

    // Pagination
    const page = Math.max(1, parseInt(req.query.page, 10) || 1);
    const limit = Math.min(100, Math.max(1, parseInt(req.query.limit, 10) || 100));
    const offset = (page - 1) * limit;

    // Compter le total avant pagination
    const countQuery = `SELECT COUNT(*) FROM airplanes a
      LEFT JOIN countries c ON a.country_id = c.id
      LEFT JOIN generation g ON a.id_generation = g.id
      LEFT JOIN type t ON a.type = t.id` + (conditions.length > 0 ? ' WHERE ' + conditions.join(' AND ') : '');
    const countResult = await getPool().query(countQuery, queryParams);
    const total = parseInt(countResult.rows[0].count, 10);

    queryParams.push(limit, offset);
    query += ` LIMIT $${queryParams.length - 1} OFFSET $${queryParams.length}`;

    const result = await getPool().query(query, queryParams);
    // i18n : noms propres (name, complete_name, country_name) fallback FR ;
    // little_description → "Translation needed" si name_en NULL
    // On capture les noms FR canoniques AVANT pickLang pour les exposer
    // comme clés stables côté client (type_name_fr, country_name_fr).
    const typeFr = result.rows.map(r => r.type_name);
    const countryFr = result.rows.map(r => r.country_name);
    const data = pickLangMany(
      result.rows,
      req.lang,
      ['name', 'complete_name', 'little_description', 'country_name', 'type_name'],
      ['name', 'complete_name', 'country_name'] // noms propres → fallback FR
    ).map((row, i) => ({
      ...row,
      type_name_fr: typeFr[i],
      country_name_fr: countryFr[i],
    }));
    res.json({ data, total, page, limit });
  }));

  router.get('/airplanes/:id', asyncHandler(async (req, res) => {
    const { id } = req.params;
    const result = await getPool().query(
      `SELECT airplanes.*,
              manufacturer.name AS manufacturer_name, manufacturer.name_en AS manufacturer_name_en,
              generation.generation,
              generation.description AS generation_description, generation.description_en AS generation_description_en,
              type.name AS type_name, type.name_en AS type_name_en,
              countries.name AS country_name, countries.name_en AS country_name_en
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
    const row = pickLang(
      result.rows[0],
      req.lang,
      ['name', 'complete_name', 'little_description', 'description', 'status',
       'manufacturer_name', 'type_name', 'country_name', 'generation_description'],
      ['name', 'complete_name', 'manufacturer_name', 'country_name'] // noms propres
    );
    res.json(row);
  }));

  router.get('/airplanes/:id/armament', asyncHandler(async (req, res) => {
    const { id } = req.params;
    const result = await getPool().query(
      `SELECT armement.name, armement.name_en, armement.description, armement.description_en
       FROM airplane_armement
       JOIN armement ON airplane_armement.id_armement = armement.id
       WHERE airplane_armement.id_airplane = $1`,
      [id]
    );
    res.json(pickLangMany(result.rows, req.lang, ['name', 'description'], ['name']));
  }));

  router.get('/airplanes/:id/tech', asyncHandler(async (req, res) => {
    const { id } = req.params;
    const result = await getPool().query(
      `SELECT t.name, t.name_en, t.description, t.description_en
       FROM airplane_tech at
       JOIN tech t ON at.id_tech = t.id
       WHERE at.id_airplane = $1`,
      [id]
    );
    res.json(pickLangMany(result.rows, req.lang, ['name', 'description'], ['name']));
  }));

  router.get('/airplanes/:id/missions', asyncHandler(async (req, res) => {
    const { id } = req.params;
    const result = await getPool().query(
      `SELECT missions.name, missions.name_en, missions.description, missions.description_en
       FROM airplane_missions
       JOIN missions ON airplane_missions.id_mission = missions.id
       WHERE airplane_missions.id_airplane = $1`,
      [id]
    );
    res.json(pickLangMany(result.rows, req.lang, ['name', 'description']));
  }));

  router.get('/airplanes/:id/wars', asyncHandler(async (req, res) => {
    const { id } = req.params;
    const result = await getPool().query(
      `SELECT wars.name, wars.name_en, wars.date_start, wars.date_end, wars.description, wars.description_en
       FROM airplane_wars
       JOIN wars ON airplane_wars.id_wars = wars.id
       WHERE airplane_wars.id_airplane = $1`,
      [id]
    );
    res.json(pickLangMany(result.rows, req.lang, ['name', 'description']));
  }));

  router.get('/airplanes/:id/related', asyncHandler(async (req, res) => {
    const { id } = req.params;
    const [armamentRes, techRes, missionsRes, warsRes] = await Promise.all([
      getPool().query(
        `SELECT armement.name, armement.name_en, armement.description, armement.description_en
         FROM airplane_armement
         JOIN armement ON airplane_armement.id_armement = armement.id
         WHERE airplane_armement.id_airplane = $1`, [id]
      ),
      getPool().query(
        `SELECT t.name, t.name_en, t.description, t.description_en FROM airplane_tech at
         JOIN tech t ON at.id_tech = t.id
         WHERE at.id_airplane = $1`, [id]
      ),
      getPool().query(
        `SELECT missions.name, missions.name_en, missions.description, missions.description_en
         FROM airplane_missions
         JOIN missions ON airplane_missions.id_mission = missions.id
         WHERE airplane_missions.id_airplane = $1`, [id]
      ),
      getPool().query(
        `SELECT wars.name, wars.name_en, wars.date_start, wars.date_end, wars.description, wars.description_en
         FROM airplane_wars
         JOIN wars ON airplane_wars.id_wars = wars.id
         WHERE airplane_wars.id_airplane = $1`, [id]
      )
    ]);
    res.json({
      armament: pickLangMany(armamentRes.rows, req.lang, ['name', 'description'], ['name']),
      tech: pickLangMany(techRes.rows, req.lang, ['name', 'description'], ['name']),
      missions: pickLangMany(missionsRes.rows, req.lang, ['name', 'description']),
      wars: pickLangMany(warsRes.rows, req.lang, ['name', 'description']),
    });
  }));

  router.get('/airplanes/:id/favorite', authorize([1, 2, 3]), asyncHandler(async (req, res) => {
    const { id } = req.params;
    const userId = req.user.id;
    const result = await getPool().query(
      'SELECT 1 FROM favorites WHERE user_id = $1 AND airplane_id = $2',
      [userId, id]
    );
    res.json({ isFavorite: result.rows.length > 0 });
  }));

  // Cache-Control commun aux référentiels (rarement modifiés)
  // public : cacheable par CDN/proxies + navigateur
  // max-age=300 (5 min) côté client + s-maxage=3600 (1h) côté CDN
  // stale-while-revalidate=600 : sert l'ancien en arrière-plan pendant le refresh
  const REFERENTIALS_CACHE = 'public, max-age=300, s-maxage=3600, stale-while-revalidate=600';

  router.get('/countries', asyncHandler(async (req, res) => {
    const result = await getPool().query(
      'SELECT id, name, name_en FROM countries WHERE id IN (SELECT DISTINCT country_id FROM airplanes WHERE country_id IS NOT NULL) ORDER BY name ASC'
    );
    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json(pickLangMany(result.rows, req.lang, ['name'], ['name']));
  }));

  router.get('/generations', asyncHandler(async (req, res) => {
    const result = await getPool().query('SELECT DISTINCT generation FROM generation ORDER BY generation ASC');
    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json(result.rows.map((row) => row.generation));
  }));

  router.get('/types', asyncHandler(async (req, res) => {
    const result = await getPool().query(
      'SELECT id, name, name_en, description, description_en FROM type ORDER BY name ASC'
    );
    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json(pickLangMany(result.rows, req.lang, ['name', 'description']));
  }));

  router.get('/manufacturers', asyncHandler(async (req, res) => {
    const result = await getPool().query(`
      SELECT m.id, m.name, m.name_en, m.code, m.country_id,
             c.name AS country_name, c.name_en AS country_name_en
      FROM manufacturer m
      JOIN countries c ON m.country_id = c.id
      ORDER BY m.name ASC
    `);
    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json(pickLangMany(result.rows, req.lang, ['name', 'country_name'], ['name', 'country_name']));
  }));

  // Endpoint combiné : récupère tous les référentiels en 1 seul round-trip.
  // Permet au frontend de loader filtres + dropdowns en parallèle (Promise.all SQL)
  // au lieu de 4 requêtes HTTP séquentielles.
  router.get('/referentials', asyncHandler(async (req, res) => {
    const pool = getPool();
    const [countries, generations, types, manufacturers] = await Promise.all([
      pool.query(
        'SELECT id, name, name_en FROM countries WHERE id IN (SELECT DISTINCT country_id FROM airplanes WHERE country_id IS NOT NULL) ORDER BY name ASC'
      ),
      pool.query('SELECT DISTINCT generation FROM generation ORDER BY generation ASC'),
      pool.query('SELECT id, name, name_en, description, description_en FROM type ORDER BY name ASC'),
      pool.query(`
        SELECT m.id, m.name, m.name_en, m.code, m.country_id,
               c.name AS country_name, c.name_en AS country_name_en
        FROM manufacturer m
        JOIN countries c ON m.country_id = c.id
        ORDER BY m.name ASC
      `),
    ]);

    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json({
      // On expose le nom canonique FR (name_fr) en plus du nom traduit (name),
      // pour que le frontend puisse utiliser le FR comme clé d'URL stable
      // (indépendante de la langue d'affichage).
      countries: pickLangMany(countries.rows, req.lang, ['name'], ['name']).map((c, i) => ({
        ...c,
        name_fr: countries.rows[i].name,
      })),
      generations: generations.rows.map((row) => row.generation),
      types: pickLangMany(types.rows, req.lang, ['name', 'description']).map((t, i) => ({
        ...t,
        name_fr: types.rows[i].name,
      })),
      manufacturers: pickLangMany(manufacturers.rows, req.lang, ['name', 'country_name'], ['name', 'country_name']),
    });
  }));

  router.post('/airplanes', authorize([1, 2]), asyncHandler(async (req, res) => {
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

    const fkErrors = await validateAirplaneFKs(getPool(), { country_id, id_manufacturer, id_generation, type });
    if (fkErrors.length > 0) {
      return res.status(400).json({ message: 'Référence invalide', errors: fkErrors });
    }

    const result = await getPool().query(
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

    onAirplaneChange?.();
    res.status(201).json(result.rows[0]);
  }));

  router.put('/airplanes/:id', authorize([1, 2]), asyncHandler(async (req, res) => {
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

    const fkErrors = await validateAirplaneFKs(getPool(), { country_id, id_manufacturer, id_generation, type });
    if (fkErrors.length > 0) {
      return res.status(400).json({ message: 'Référence invalide', errors: fkErrors });
    }

    const result = await getPool().query(
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

    onAirplaneChange?.();
    res.json(result.rows[0]);
  }));

  router.delete('/airplanes/:id', authorize([1, 2]), asyncHandler(async (req, res) => {
    const { id } = req.params;
    const result = await getPool().query('DELETE FROM airplanes WHERE id = $1 RETURNING id, name', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Avion non trouvé' });
    }
    onAirplaneChange?.();
    res.json({ message: `Avion "${result.rows[0].name}" supprimé avec succès` });
  }));

  return router;
};
