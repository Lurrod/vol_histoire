require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');


const app = express();
const port = process.env.PORT || 3000;
const jwtSecret = process.env.JWT_SECRET;

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

// Servir les fichiers statiques
app.use(express.static(path.join(__dirname, '../frontend')));
app.use('/css', express.static(path.join(__dirname, '../frontend/css')));
app.use('/js', express.static(path.join(__dirname, '../frontend/js')));

// Route d'inscription
app.post('/api/register', async (req, res) => {
  const { name, email, password } = req.body;

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
});

// Route de connexion
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;

  try {
      // Vérifier si l'utilisateur existe
      const user = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
      if (user.rows.length === 0) {
          return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
      }

      // Vérifier le mot de passe
      const validPassword = await bcrypt.compare(password, user.rows[0].password);
      if (!validPassword) {
          return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
      }

      // Générer un token JWT avec le rôle
      const token = jwt.sign(
          { 
              id: user.rows[0].id, 
              name: user.rows[0].name, 
              role: user.rows[0].role_id 
          },
          process.env.JWT_SECRET,
          { expiresIn: '2h' }
      );

      res.json({ message: 'Connexion réussie', token });

  } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Routes API
app.get('/api/airplanes', async (req, res) => {
  try {
      const sort = req.query.sort || 'default';
      const country = req.query.country || '';
      const generation = req.query.generation || '';
      const type = req.query.type || '';
      const page = parseInt(req.query.page) || 1;
      const limit = 8;
      const offset = (page - 1) * limit;

      // Requête pour le nombre total
      let countQuery = `SELECT COUNT(*) FROM airplanes a`;
      let countParams = [];
      
      if (country) {
          countQuery += ` LEFT JOIN countries c ON a.country_id = c.id WHERE c.name = $1`;
          countParams.push(country);
      } else if (generation) {
          countQuery += ` LEFT JOIN generation g ON a.id_generation = g.id WHERE g.generation = $1`;
          countParams.push(generation);
      } else if (type) {
          countQuery += ` LEFT JOIN type t ON a.type = t.id WHERE t.name = $1`;
          countParams.push(type);
      }

      // Requête principale
      let query = `
          SELECT a.id, a.name, a.complete_name, a.little_description, a.image_url, 
                 c.name as country_name, g.generation, t.name as type_name,
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

      // Appliquer le tri
      switch (sort) {
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

      query += ` LIMIT $${queryParams.length + 1} OFFSET $${queryParams.length + 2}`;
      queryParams.push(limit, offset);

      const result = await pool.query(query, queryParams);
      const totalResult = await pool.query(countQuery, countParams);
      const total = parseInt(totalResult.rows[0].count);
      const totalPages = Math.ceil(total / limit);

      res.json({
          data: result.rows,
          pagination: {
              currentPage: page,
              totalPages,
              totalItems: total
          }
      });
  } catch (err) {
      console.error('Erreur serveur:', err.stack);
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
      const result = await pool.query('SELECT id, name FROM countries ORDER BY name ASC');
      res.json(result.rows);
  } catch (error) {
      console.error("Erreur serveur:", error);
      res.status(500).json({ error: "Erreur serveur" });
  }
});

app.get('/api/generations', async (req, res) => {
  try {
    const result = await pool.query('SELECT DISTINCT generation FROM generation ORDER BY generation ASC');
    res.json(result.rows.map(row => row.generation));
  } catch (error) {
    res.status(500).json({ error: "Erreur serveur" });
  }
});

app.get('/api/types', async (req, res) => {
  try {
      const result = await pool.query('SELECT * FROM type');
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

// CRUD ADMIN
const authorize = (roles) => {
  return (req, res, next) => {
      const token = req.headers.authorization?.split(" ")[1];
      if (!token) return res.status(403).json({ message: "Accès interdit" });

      try {
          const decoded = jwt.verify(token, process.env.JWT_SECRET);
          
          if (!roles.includes(decoded.role)) {
              return res.status(403).json({ message: "Accès non autorisé" });
          }

          req.user = decoded;
          next();
      } catch (error) {
          res.status(401).json({ message: "Token invalide" });
      }
  };
};

app.post('/api/airplanes', authorize([1, 2]), async (req, res) => {
  const {
      name, complete_name, little_description, image_url, description,
      country_id, date_concept, date_first_fly, date_operationel,
      max_speed, max_range, id_manufacturer, id_generation, type, status, weight
  } = req.body;

  try {
      const result = await pool.query(
          `INSERT INTO airplanes 
          (name, complete_name, little_description, image_url, description, country_id, 
          date_concept, date_first_fly, date_operationel, max_speed, max_range, 
          id_manufacturer, id_generation, type, status, weight) 
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16) 
          RETURNING *`,
          [name, complete_name, little_description, image_url, description, country_id, 
          date_concept, date_first_fly, date_operationel, max_speed, max_range, 
          id_manufacturer, id_generation, type, status, weight]
      );

      res.status(201).json(result.rows[0]);
  } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erreur lors de l’ajout de l’avion' });
  }
});

app.put('/api/airplanes/:id', authorize([1, 2]), async (req, res) => {
  const { id } = req.params;
  console.log("Données reçues :", req.body);

  const {
      name, complete_name, little_description, image_url, description,
      date_concept, date_first_fly, date_operationel,
      max_speed, max_range, weight, status
  } = req.body;

  // Convertir les dates vides en NULL
  const cleanDateConcept = date_concept === "" ? null : date_concept;
  const cleanDateFirstFly = date_first_fly === "" ? null : date_first_fly;
  const cleanDateOperationel = date_operationel === "" ? null : date_operationel;

  try {
      const result = await pool.query(
          `UPDATE airplanes SET 
              name = $1, complete_name = $2, little_description = $3, image_url = $4, 
              description = $5, date_concept = $6, date_first_fly = $7, 
              date_operationel = $8, max_speed = $9, max_range = $10, 
              weight = $11, status = $12
          WHERE id = $13 RETURNING *`,
          [name, complete_name, little_description, image_url, description, 
           cleanDateConcept, cleanDateFirstFly, cleanDateOperationel, max_speed, 
           max_range, weight, status, id]
      );

      if (result.rows.length === 0) {
          return res.status(404).json({ message: "Avion non trouvé" });
      }

      res.json(result.rows[0]);
  } catch (error) {
      console.error("Erreur lors de la mise à jour :", error);
      res.status(500).json({ error: 'Erreur lors de la mise à jour de l’avion' });
  }
});

app.delete('/api/airplanes/:id', authorize([1, 2]), async (req, res) => {
  const { id } = req.params;

  try {
      const result = await pool.query('DELETE FROM airplanes WHERE id = $1 RETURNING *', [id]);

      if (result.rows.length === 0) {
          return res.status(404).json({ message: "Avion non trouvé" });
      }

      res.json({ message: "Avion supprimé avec succès" });
  } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erreur lors de la suppression de l’avion' });
  }
});

// Lancer le serveur
app.listen(port, () => {
  console.log(`Serveur démarré sur http://localhost:${port}`);
});