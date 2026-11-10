const express = require('express');
const { authorize } = require('../middleware/auth');
const asyncHandler = require('../middleware/asyncHandler');
const favoritesRepo = require('../repositories/favorites');
const { idParam } = require('../middleware/input-guards');

module.exports = function createFavoritesRouter(getPool) {
  const router = express.Router();

  // Validation des IDs : entier int4 positif, sinon 400 (SEC-003).
  router.param('airplaneId', idParam('ID avion invalide'));

  // -----------------------------------------------------------------------------
  // Favoris
  // -----------------------------------------------------------------------------
  router.get('/favorites', authorize([1, 2, 3]), asyncHandler(async (req, res) => {
    res.json(await favoritesRepo.listForUser(getPool(), req.user.id));
  }));

  router.post('/favorites/:airplaneId', authorize([1, 2, 3]), asyncHandler(async (req, res) => {
    try {
      await favoritesRepo.add(getPool(), req.user.id, req.params.airplaneId);
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
    const removed = await favoritesRepo.remove(getPool(), req.user.id, req.params.airplaneId);
    if (!removed) {
      return res.status(404).json({ message: 'Pas dans les favoris' });
    }
    res.json({ message: 'Supprimé des favoris' });
  }));

  return router;
};
