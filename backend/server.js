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
    const result = await pool.query('SELECT id, name, complete_name, little_description, image_url FROM airplanes');
    res.json(result.rows);
  } catch (err) {
    console.error('Erreur lors de la récupération des avions', err);
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
    const result = await pool.query(
      `SELECT tech.name, tech.description
       FROM airplanes
       JOIN tech ON airplanes.id_tech = tech.id
       WHERE airplanes.id = $1`, [id]
    );
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

// Lancer le serveur
app.listen(port, () => {
  console.log(`Serveur démarré sur http://localhost:${port}`);
});
