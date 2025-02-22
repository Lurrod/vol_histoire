require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Connexion à PostgreSQL
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

// Vérification de la connexion
pool.connect()
  .then(() => console.log('Connecté à PostgreSQL'))
  .catch(err => console.error('Erreur de connexion à PostgreSQL', err));

// Route de test
app.get('/', (req, res) => {
  res.send('Bienvenue sur l\'API de vol d\'histoire');
});

// Route pour récupérer tous les avions
app.get('/airplanes', async (req, res) => {
  try {
    const sort = req.query.sort || 'default';
    let query = `
      SELECT a.id, a.name, a.complete_name, a.little_description, a.image_url, 
             c.name as country_name, g.generation, t.name as type_name,
             a.date_operationel
      FROM airplanes a
      LEFT JOIN countries c ON a.country_id = c.id
      LEFT JOIN generation g ON a.id_generation = g.id
      LEFT JOIN type t ON a.type = t.id
    `;

    switch(sort) {
      case 'nation':
        query += ' ORDER BY c.name ASC';
        break;
      case 'service-date':
        query += ' ORDER BY a.date_operationel DESC';
        break;
      case 'alphabetical':
        query += ' ORDER BY a.name ASC';
        break;
      case 'generation':
        query += ' ORDER BY g.generation DESC';
        break;
      case 'type':
        query += ' ORDER BY t.name ASC';
        break;
      default:
        query += ' ORDER BY a.id ASC';
    }

    const result = await pool.query(query);
    res.json(result.rows);
  } catch (err) {
    console.error('Erreur:', err);
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
           WHERE airplanes.id = $1`, [id]
      );
      if (result.rows.length === 0) {
          return res.status(404).json({ message: "Avion non trouvé" });
      }
      res.json(result.rows[0]);
  } catch (error) {
      res.status(500).json({ error: "Erreur serveur" });
  }
});

// Route pour récupérer l'armement d'un avion
app.get('/api/airplanes/:id/armament', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `SELECT armement.name, armement.description
       FROM airplane_armement
       JOIN armement ON airplane_armement.id_armement = armement.id
       WHERE airplane_armement.id_airplane = $1`, [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Route pour récupérer les technologies d'un avion
app.get('/api/airplanes/:id/tech', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(`
      SELECT t.name, t.description 
      FROM airplane_tech at
      JOIN tech t ON at.id_tech = t.id
      WHERE at.id_airplane = $1
    `, [id]);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Route pour récupérer les guerres auxquelles l'avion a participé
app.get('/api/airplanes/:id/wars', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `SELECT wars.name, wars.date_start, wars.date_end, wars.description
       FROM airplane_wars
       JOIN wars ON airplane_wars.id_wars = wars.id
       WHERE airplane_wars.id_airplane = $1`, [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Route corrigée pour les technologies (many-to-many)
app.get('/api/airplanes/:id/tech', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `SELECT tech.name, tech.description
       FROM airplane_tech
       JOIN tech ON airplane_tech.id_tech = tech.id
       WHERE airplane_tech.id_airplane = $1`, [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Route pour les missions
app.get('/api/airplanes/:id/missions', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `SELECT missions.name, missions.description
       FROM airplane_missions
       JOIN missions ON airplane_missions.id_mission = missions.id
       WHERE airplane_missions.id_airplane = $1`, [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Route pour les pays
app.get('/api/countries', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM countries');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Route pour les constructeurs
app.get('/api/manufacturers', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT m.*, c.name as country_name 
      FROM manufacturer m
      JOIN countries c ON m.country_id = c.id
    `);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Lancer le serveur
app.listen(port, () => {
  console.log(`Serveur démarré sur http://localhost:${port}`);
});
