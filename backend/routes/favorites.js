const express = require('express');
const { authorize } = require('../middleware/auth');

module.exports = function createFavoritesRouter(getPool) {
  const router = express.Router();

  // Validation des IDs
  router.param('airplaneId', (req, res, next, value) => {
    if (!/^\d+$/.test(value)) {
      return res.status(400).json({ message: 'ID avion invalide' });
    }
    next();
  });

  // -----------------------------------------------------------------------------
  // Favoris
  // -----------------------------------------------------------------------------
  router.get('/favorites', authorize([1, 2, 3]), async (req, res) => {
    const userId = req.user.id;
    try {
      const result = await getPool().query(
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

  router.post('/favorites/:airplaneId', authorize([1, 2, 3]), async (req, res) => {
    const { airplaneId } = req.params;
    const userId = req.user.id;
    try {
      await getPool().query(
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

  router.delete('/favorites/:airplaneId', authorize([1, 2, 3]), async (req, res) => {
    const { airplaneId } = req.params;
    const userId = req.user.id;
    try {
      const result = await getPool().query(
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

  return router;
};
