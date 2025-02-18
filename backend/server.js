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

// Lancer le serveur
app.listen(port, () => {
  console.log(`Serveur démarré sur http://localhost:${port}`);
});
