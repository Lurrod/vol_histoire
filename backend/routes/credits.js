'use strict';

const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const creditsRepo = require('../repositories/credits');

// Crédits photo : source de la page /credits (attribution exigée par les
// licences Creative Commons). Le tri par fiche et la mise en forme des
// licences se font côté client (frontend/js/credits.js).

const CREDITS_CACHE = 'public, max-age=300, s-maxage=3600, stale-while-revalidate=600';

module.exports = function createCreditsRouter(getPool) {
  const router = express.Router();

  router.get('/credits', asyncHandler(async (req, res) => {
    const rows = await creditsRepo.listImageCredits(getPool());
    res.set('Cache-Control', CREDITS_CACHE);
    res.json(rows.map(({ id, name, name_en, image_credit, image_licence }) => (
      { id, name, name_en, image_credit, image_licence }
    )));
  }));

  return router;
};
