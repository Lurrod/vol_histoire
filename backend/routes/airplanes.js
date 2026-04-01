const express = require('express');
const { validateAirplaneData } = require('../validators');
const { authorize } = require('../middleware/auth');

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

module.exports = function createAirplanesRouter(getPool) {
  const router = express.Router();

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
  router.get('/airplanes', async (req, res) => {
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

      const result = await getPool().query(query, queryParams);
      res.json({ data: result.rows });
    } catch (err) {
      res.status(500).json({ error: 'Erreur serveur' });
    }
  });

  router.get('/airplanes/:id', async (req, res) => {
    const { id } = req.params;
    try {
      const result = await getPool().query(
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

  router.get('/airplanes/:id/armament', async (req, res) => {
    const { id } = req.params;
    try {
      const result = await getPool().query(
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

  router.get('/airplanes/:id/tech', async (req, res) => {
    const { id } = req.params;
    try {
      const result = await getPool().query(
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

  router.get('/airplanes/:id/missions', async (req, res) => {
    const { id } = req.params;
    try {
      const result = await getPool().query(
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

  router.get('/airplanes/:id/wars', async (req, res) => {
    const { id } = req.params;
    try {
      const result = await getPool().query(
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

  router.get('/airplanes/:id/related', async (req, res) => {
    const { id } = req.params;
    try {
      const [armamentRes, techRes, missionsRes, warsRes] = await Promise.all([
        getPool().query(
          `SELECT armement.name, armement.description FROM airplane_armement
           JOIN armement ON airplane_armement.id_armement = armement.id
           WHERE airplane_armement.id_airplane = $1`, [id]
        ),
        getPool().query(
          `SELECT t.name, t.description FROM airplane_tech at
           JOIN tech t ON at.id_tech = t.id
           WHERE at.id_airplane = $1`, [id]
        ),
        getPool().query(
          `SELECT missions.name, missions.description FROM airplane_missions
           JOIN missions ON airplane_missions.id_mission = missions.id
           WHERE airplane_missions.id_airplane = $1`, [id]
        ),
        getPool().query(
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

  router.get('/airplanes/:id/favorite', authorize([1, 2, 3]), async (req, res) => {
    const { id } = req.params;
    const userId = req.user.id;
    try {
      const result = await getPool().query(
        'SELECT 1 FROM favorites WHERE user_id = $1 AND airplane_id = $2',
        [userId, id]
      );
      res.json({ isFavorite: result.rows.length > 0 });
    } catch (error) {
      res.status(500).json({ error: 'Erreur serveur' });
    }
  });

  router.get('/countries', async (req, res) => {
    try {
      const result = await getPool().query(
        'SELECT id, name FROM countries WHERE id IN (SELECT DISTINCT country_id FROM airplanes WHERE country_id IS NOT NULL) ORDER BY name ASC'
      );
      res.json(result.rows);
    } catch (error) {
      res.status(500).json({ error: 'Erreur serveur' });
    }
  });

  router.get('/generations', async (req, res) => {
    try {
      const result = await getPool().query('SELECT DISTINCT generation FROM generation ORDER BY generation ASC');
      res.json(result.rows.map((row) => row.generation));
    } catch (error) {
      res.status(500).json({ error: 'Erreur serveur' });
    }
  });

  router.get('/types', async (req, res) => {
    try {
      const result = await getPool().query('SELECT * FROM type');
      res.json(result.rows);
    } catch (error) {
      res.status(500).json({ error: 'Erreur serveur' });
    }
  });

  router.get('/manufacturers', async (req, res) => {
    try {
      const result = await getPool().query(`
        SELECT m.*, c.name as country_name
        FROM manufacturer m
        JOIN countries c ON m.country_id = c.id
      `);
      res.json(result.rows);
    } catch (error) {
      res.status(500).json({ error: 'Erreur serveur' });
    }
  });

  router.post('/airplanes', authorize([1, 2]), async (req, res) => {
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

      res.status(201).json(result.rows[0]);
    } catch (error) {
      res.status(500).json({ error: "Erreur lors de l'ajout de l'avion" });
    }
  });

  router.put('/airplanes/:id', authorize([1, 2]), async (req, res) => {
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

      res.json(result.rows[0]);
    } catch (error) {
      res.status(500).json({ error: "Erreur lors de la mise à jour de l'avion" });
    }
  });

  router.delete('/airplanes/:id', authorize([1, 2]), async (req, res) => {
    const { id } = req.params;
    try {
      const result = await getPool().query('DELETE FROM airplanes WHERE id = $1 RETURNING id, name', [id]);
      if (result.rows.length === 0) {
        return res.status(404).json({ message: 'Avion non trouvé' });
      }
      res.json({ message: `Avion "${result.rows[0].name}" supprimé avec succès` });
    } catch (error) {
      res.status(500).json({ error: "Erreur lors de la suppression de l'avion" });
    }
  });

  return router;
};
