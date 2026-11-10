const express = require('express');
const facetsRepo = require('../repositories/facets');

// Compteurs par valeur de filtre pour le hangar (logique de comptage :
// voir repositories/facets.js).
module.exports = function createFacetsRouter(getPool) {
  const router = express.Router();

  router.get('/airplanes/facets', async (req, res, next) => {
    try {
      // Même contrôle de format que GET /airplanes : « abc » ou un nombre hors
      // plage int4 faisaient lever une erreur SQL (500). SEC-003.
      const generation = req.query.generation || '';
      if (generation && !/^[1-9]\d{0,8}$/.test(generation)) {
        return res.status(400).json({ message: 'Paramètre generation invalide' });
      }
      const filters = {
        country: req.query.country || '',
        generation: req.query.generation || '',
        type: req.query.type || '',
        war: req.query.war || '',
        mission: req.query.mission || '',
      };

      const groups = await facetsRepo.countAll(getPool(), filters);

      const toMap = rows =>
        rows.reduce((acc, row) => {
          if (row.k != null) acc[row.k] = row.n;
          return acc;
        }, {});

      res.json({
        countries: toMap(groups.countries),
        generations: toMap(groups.generations),
        types: toMap(groups.types),
        wars: toMap(groups.wars),
        missions: toMap(groups.missions),
      });
    } catch (err) {
      next(err);
    }
  });

  return router;
};
