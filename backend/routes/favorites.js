const express = require('express');
const { authorize } = require('../middleware/auth');
const asyncHandler = require('../middleware/asyncHandler');

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
  router.get('/favorites', authorize([1, 2, 3]), asyncHandler(async (req, res) => {
    const userId = req.user.id;
    const result = await getPool().query(
      `SELECT a.id, a.name, a.complete_name, a.little_description, a.image_url,
              a.max_speed, a.date_operationel,
              c.name AS country_name, c.name_en AS country_name_en, c.code AS country_code,
              g.generation, t.name AS type_name, t.name_en AS type_name_en,
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
  }));

  router.post('/favorites/:airplaneId', authorize([1, 2, 3]), asyncHandler(async (req, res) => {
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
      throw error;
    }
  }));

  router.delete('/favorites/:airplaneId', authorize([1, 2, 3]), asyncHandler(async (req, res) => {
    const { airplaneId } = req.params;
    const userId = req.user.id;
    const result = await getPool().query(
      'DELETE FROM favorites WHERE user_id = $1 AND airplane_id = $2',
      [userId, airplaneId]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Pas dans les favoris' });
    }
    res.json({ message: 'Supprimé des favoris' });
  }));

  return router;
};
