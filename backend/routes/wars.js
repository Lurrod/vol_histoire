'use strict';

const express = require('express');
const asyncHandler = require('../middleware/asyncHandler');
const { pickLang, pickLangMany } = require('../i18n');
const { slugify } = require('../utils/url');
const warsRepo = require('../repositories/wars');

// Conflits : liste et page dédiée.
//
// Le slug est dérivé du nom FR canonique (« Guerre d'Indochine » →
// « guerre-d-indochine ») plutôt que stocké : la table compte quelques
// dizaines de lignes, et une colonne de plus serait une source de
// désynchronisation entre la base, le sitemap et les liens des fiches.
// Les slugs/URL sont construits au même endroit que ceux des fiches
// (utils/url.js).

const LIST_CACHE = 'public, max-age=300, s-maxage=3600, stale-while-revalidate=600';

module.exports = function createWarsRouter(getPool) {
  const router = express.Router();

  async function loadWars() {
    const rows = await warsRepo.listWithCounts(getPool());
    return rows.map((r) => ({ ...r, slug: slugify(r.name) }));
  }

  // Tous les conflits rattachés à au moins un appareil.
  router.get('/wars', asyncHandler(async (req, res) => {
    const wars = (await loadWars()).filter((w) => w.count > 0);
    res.set('Cache-Control', LIST_CACHE);
    res.json(pickLangMany(wars, req.lang, ['name', 'description']).map((w, i) => ({
      slug: w.slug,
      name: w.name,
      name_fr: wars[i].name,
      date_start: w.date_start,
      date_end: w.date_end,
      description: w.description,
      count: w.count,
    })));
  }));

  // Un conflit et ses appareils, du plus ancien au plus récent.
  router.get('/wars/:slug', asyncHandler(async (req, res) => {
    const slug = String(req.params.slug || '');
    if (!/^[a-z0-9-]{1,120}$/.test(slug)) {
      return res.status(400).json({ message: 'Slug invalide' });
    }
    const war = (await loadWars()).find((w) => w.slug === slug && w.count > 0);
    if (!war) return res.status(404).json({ message: 'Conflit introuvable' });

    const rows = await warsRepo.findAirplanes(getPool(), war.id);

    const translated = pickLang(war, req.lang, ['name', 'description']);
    res.set('Cache-Control', LIST_CACHE);
    res.json({
      slug: war.slug,
      name: translated.name,
      name_fr: war.name,
      date_start: war.date_start,
      date_end: war.date_end,
      description: translated.description,
      count: war.count,
      airplanes: pickLangMany(
        rows, req.lang,
        ['name', 'little_description', 'country_name', 'type_name'],
        ['name', 'country_name']
      ).map((a, i) => ({ ...a, type_name_fr: rows[i].type_name })),
    });
  }));

  return router;
};
