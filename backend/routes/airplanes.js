const express = require('express');
const { validateAirplaneData } = require('../validators');
const { authorize } = require('../middleware/auth');
const asyncHandler = require('../middleware/asyncHandler');
const { pickLang, pickLangMany } = require('../i18n');
const { slugify } = require('../utils/url');
const airplanesRepo = require('../repositories/airplanes');
const referentialsRepo = require('../repositories/referentials');
const favoritesRepo = require('../repositories/favorites');
const { idParam, cleanSearch } = require('../middleware/input-guards');

// Vérifie l'existence des clés étrangères d'un avion en une seule requête.
// Retourne un tableau de messages d'erreur (vide si tout est valide).
async function validateAirplaneFKs(pool, body) {
  const { country_ok, manufacturer_ok, generation_ok, type_ok } = await airplanesRepo.checkForeignKeys(pool, body);
  const errors = [];
  if (!country_ok)      errors.push('country_id invalide');
  if (!manufacturer_ok) errors.push('id_manufacturer invalide');
  if (!generation_ok)   errors.push('id_generation invalide');
  if (!type_ok)         errors.push('type invalide');
  return errors;
}

module.exports = function createAirplanesRouter(getPool, { onAirplaneChange } = {}) {
  const router = express.Router();

  // -----------------------------------------------------------------------------
  // Cache des valeurs valides (whitelist) pour les filtres /airplanes
  // Chargé en lazy depuis la BD au premier appel, puis conservé en mémoire.
  // Les référentiels (generations, types) sont gérés via fichiers SQL — aucune
  // route ne les modifie à l'exécution, donc pas besoin d'invalidation.
  // -----------------------------------------------------------------------------
  let referentialCache = null;
  async function getValidReferentials() {
    if (referentialCache) return referentialCache;
    const values = await airplanesRepo.loadFilterValues(getPool());
    referentialCache = {
      generations: new Set(values.generations),
      typeNames: new Set(values.typeNames),
      warNames: new Set(values.warNames),
      missionNames: new Set(values.missionNames),
    };
    return referentialCache;
  }
  // Exposé pour les tests + invalidation manuelle si besoin
  router.invalidateReferentialCache = () => { referentialCache = null; };

  // Validation des IDs : entier int4 positif, sinon 400 avant toute requête
  // (« 2147483648 » faisait lever « integer out of range » → 500). SEC-003.
  router.param('id', idParam());

  // -----------------------------------------------------------------------------
  // Avions
  // -----------------------------------------------------------------------------
  router.get('/airplanes', asyncHandler(async (req, res) => {
    const sort = req.query.sort || 'default';
    const country = req.query.country || '';
    const generation = req.query.generation || '';
    const type = req.query.type || '';
    // Conflit et mission : nom FR canonique, comme `country` et `type`.
    const war = (req.query.war || '').toString();
    const mission = (req.query.mission || '').toString();
    // Full-text search : caractères de contrôle neutralisés, trimé, max 100
    // chars (websearch_to_tsquery ignore les autres caractères bizarres). Un
    // paramètre répété (tableau) compte comme absent. SEC-003.
    const search = cleanSearch(req.query.search);

    // Validation format (sans DB) — rejette texte, 0, négatif
    if (generation && !/^[1-9]\d*$/.test(generation)) {
      return res.status(400).json({ message: 'Paramètre generation invalide' });
    }

    // Validation stricte contre la whitelist BD (chargée lazy en mémoire)
    if (generation || type || war || mission) {
      const valid = await getValidReferentials();
      if (generation && !valid.generations.has(Number(generation))) {
        return res.status(400).json({ message: 'Paramètre generation invalide' });
      }
      if (type && !valid.typeNames.has(type)) {
        return res.status(400).json({ message: 'Paramètre type invalide' });
      }
      if (war && !valid.warNames.has(war)) {
        return res.status(400).json({ message: 'Paramètre war invalide' });
      }
      if (mission && !valid.missionNames.has(mission)) {
        return res.status(400).json({ message: 'Paramètre mission invalide' });
      }
    }

    // Pagination
    const page = Math.max(1, parseInt(req.query.page, 10) || 1);
    const limit = Math.min(100, Math.max(1, parseInt(req.query.limit, 10) || 100));
    const offset = (page - 1) * limit;

    const { total, rows } = await airplanesRepo.findPage(getPool(), {
      country, generation, type, war, mission, search, sort, limit, offset,
    });
    // i18n : noms propres (name, complete_name, country_name) fallback FR ;
    // little_description → "Translation needed" si name_en NULL
    // On capture les noms FR canoniques AVANT pickLang pour les exposer
    // comme clés stables côté client (type_name_fr, country_name_fr).
    const typeFr = rows.map(r => r.type_name);
    const countryFr = rows.map(r => r.country_name);
    const data = pickLangMany(
      rows,
      req.lang,
      ['name', 'complete_name', 'little_description', 'country_name', 'type_name'],
      ['name', 'complete_name', 'country_name'] // noms propres → fallback FR
    ).map((row, i) => ({
      ...row,
      type_name_fr: typeFr[i],
      country_name_fr: countryFr[i],
    }));
    res.json({ data, total, page, limit });
  }));

  router.get('/airplanes/:id', asyncHandler(async (req, res) => {
    const airplane = await airplanesRepo.findById(getPool(), req.params.id);
    if (!airplane) {
      return res.status(404).json({ message: 'Avion non trouvé' });
    }
    const row = pickLang(
      airplane,
      req.lang,
      ['name', 'complete_name', 'little_description', 'description', 'status',
       'manufacturer_name', 'type_name', 'country_name', 'generation_description',
       'predecessor_name', 'successor_name', 'rival_name',
       'variants', 'engine_type'],
      ['name', 'complete_name', 'manufacturer_name', 'country_name',
       'predecessor_name', 'successor_name', 'rival_name'] // noms propres
    );
    res.json(row);
  }));

  router.get('/airplanes/:id/armament', asyncHandler(async (req, res) => {
    const rows = await airplanesRepo.findArmament(getPool(), req.params.id);
    res.json(pickLangMany(rows, req.lang, ['name', 'description'], ['name']));
  }));

  router.get('/airplanes/:id/tech', asyncHandler(async (req, res) => {
    const rows = await airplanesRepo.findTech(getPool(), req.params.id);
    res.json(pickLangMany(rows, req.lang, ['name', 'description'], ['name']));
  }));

  router.get('/airplanes/:id/missions', asyncHandler(async (req, res) => {
    const rows = await airplanesRepo.findMissions(getPool(), req.params.id);
    res.json(pickLangMany(rows, req.lang, ['name', 'description']));
  }));

  router.get('/airplanes/:id/wars', asyncHandler(async (req, res) => {
    const rows = await airplanesRepo.findWars(getPool(), req.params.id);
    res.json(pickLangMany(rows, req.lang, ['name', 'description']));
  }));

  router.get('/airplanes/:id/related', asyncHandler(async (req, res) => {
    const related = await airplanesRepo.findRelated(getPool(), req.params.id);
    // Nom FR canonique (clé du filtre du hangar) et slug (page du conflit),
    // capturés avant la traduction par pickLangMany.
    const withKeys = (rows, translated, withSlug) => translated.map((r, i) => ({
      ...r,
      name_fr: rows[i].name,
      ...(withSlug ? { slug: slugify(rows[i].name) } : {}),
    }));
    res.json({
      armament: pickLangMany(related.armament, req.lang, ['name', 'description'], ['name']),
      tech: pickLangMany(related.tech, req.lang, ['name', 'description'], ['name']),
      missions: withKeys(related.missions, pickLangMany(related.missions, req.lang, ['name', 'description']), false),
      wars: withKeys(related.wars, pickLangMany(related.wars, req.lang, ['name', 'description']), true),
    });
  }));

  // ---------------------------------------------------------------------------
  // Filiation : chaîne complète predecessor → … → appareil → … → successor
  // (deux CTE récursives bornées, voir repositories/airplanes.js#findLineage).
  // ---------------------------------------------------------------------------
  const MAX_LINEAGE_DEPTH = 6;

  router.get('/airplanes/:id/lineage', asyncHandler(async (req, res) => {
    const rows = await airplanesRepo.findLineage(getPool(), req.params.id, MAX_LINEAGE_DEPTH);
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Avion non trouvé' });
    }
    res.json({
      chain: pickLangMany(rows, req.lang, ['name'], ['name']),
      truncated: rows.length >= MAX_LINEAGE_DEPTH * 2 + 1,
    });
  }));

  router.get('/airplanes/:id/favorite', authorize([1, 2, 3]), asyncHandler(async (req, res) => {
    const isFavorite = await favoritesRepo.exists(getPool(), req.user.id, req.params.id);
    res.json({ isFavorite });
  }));

  // Cache-Control commun aux référentiels (rarement modifiés)
  // public : cacheable par CDN/proxies + navigateur
  // max-age=300 (5 min) côté client + s-maxage=3600 (1h) côté CDN
  // stale-while-revalidate=600 : sert l'ancien en arrière-plan pendant le refresh
  const REFERENTIALS_CACHE = 'public, max-age=300, s-maxage=3600, stale-while-revalidate=600';

  router.get('/countries', asyncHandler(async (req, res) => {
    const rows = await referentialsRepo.listCountriesWithAirplanes(getPool());
    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json(pickLangMany(rows, req.lang, ['name'], ['name']));
  }));

  // Nations de conception + nombre de fiches — alimente la carte de l'accueil.
  // `name` (FR canonique) est renvoyé en plus du nom traduit : c'est la valeur
  // qu'attend le filtre `country` de GET /airplanes, qui compare sur countries.name.
  router.get('/nations', asyncHandler(async (req, res) => {
    const nations = await referentialsRepo.listNations(getPool());
    const nameFr = nations.map((r) => r.name);
    const rows = pickLangMany(nations, req.lang, ['name'], ['name'])
      .map((row, i) => ({ ...row, name_fr: nameFr[i] }));
    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json(rows);
  }));

  router.get('/generations', asyncHandler(async (req, res) => {
    const rows = await referentialsRepo.listGenerations(getPool());
    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json(rows.map((row) => row.generation));
  }));

  router.get('/types', asyncHandler(async (req, res) => {
    const rows = await referentialsRepo.listTypes(getPool());
    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json(pickLangMany(rows, req.lang, ['name', 'description']));
  }));

  router.get('/manufacturers', asyncHandler(async (req, res) => {
    const rows = await referentialsRepo.listManufacturers(getPool());
    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json(pickLangMany(rows, req.lang, ['name', 'country_name'], ['name', 'country_name']));
  }));

  // Endpoint combiné : récupère tous les référentiels en 1 seul round-trip.
  // Permet au frontend de loader filtres + dropdowns en parallèle (Promise.all SQL)
  // au lieu de 4 requêtes HTTP séquentielles.
  router.get('/referentials', asyncHandler(async (req, res) => {
    const { countries, generations, types, manufacturers, wars, missions } =
      await referentialsRepo.loadAll(getPool());

    res.set('Cache-Control', REFERENTIALS_CACHE);
    res.json({
      // On expose le nom canonique FR (name_fr) en plus du nom traduit (name),
      // pour que le frontend puisse utiliser le FR comme clé d'URL stable
      // (indépendante de la langue d'affichage).
      countries: pickLangMany(countries, req.lang, ['name'], ['name']).map((c, i) => ({
        ...c,
        name_fr: countries[i].name,
      })),
      generations: generations.map((row) => row.generation),
      types: pickLangMany(types, req.lang, ['name', 'description']).map((t, i) => ({
        ...t,
        name_fr: types[i].name,
      })),
      manufacturers: pickLangMany(manufacturers, req.lang, ['name', 'country_name'], ['name', 'country_name']),
      wars: pickLangMany(wars, req.lang, ['name'], ['name']).map((w, i) => ({
        ...w,
        name_fr: wars[i].name,
        slug: slugify(wars[i].name),
      })),
      missions: pickLangMany(missions, req.lang, ['name'], ['name']).map((m, i) => ({
        ...m,
        name_fr: missions[i].name,
      })),
    });
  }));

  // Création et modification : les colonnes écrites sont celles de
  // utils/airplane-fields.js (source unique), dans le même ordre.
  router.post('/airplanes', authorize([1, 2]), asyncHandler(async (req, res) => {
    const errors = validateAirplaneData(req.body);
    if (errors.length > 0) {
      return res.status(400).json({ message: 'Données invalides', errors });
    }

    const fkErrors = await validateAirplaneFKs(getPool(), req.body);
    if (fkErrors.length > 0) {
      return res.status(400).json({ message: 'Référence invalide', errors: fkErrors });
    }

    const created = await airplanesRepo.insert(getPool(), req.body);
    onAirplaneChange?.();
    res.status(201).json(created);
  }));

  router.put('/airplanes/:id', authorize([1, 2]), asyncHandler(async (req, res) => {
    const { id } = req.params;

    const errors = validateAirplaneData(req.body);
    if (errors.length > 0) {
      return res.status(400).json({ message: 'Données invalides', errors });
    }

    const fkErrors = await validateAirplaneFKs(getPool(), req.body);
    if (fkErrors.length > 0) {
      return res.status(400).json({ message: 'Référence invalide', errors: fkErrors });
    }

    // Sanity : un avion ne peut pas se référencer lui-même comme predecessor/successor/rival
    const { predecessor_id, successor_id, rival_id } = req.body;
    const selfRefIds = [predecessor_id, successor_id, rival_id]
      .map(v => v == null || v === '' ? null : Number(v))
      .filter(v => v != null && v === Number(id));
    if (selfRefIds.length > 0) {
      return res.status(400).json({ message: "Un avion ne peut pas se référencer lui-même (prédécesseur / successeur / rival)." });
    }

    const updated = await airplanesRepo.update(getPool(), id, req.body);
    if (!updated) {
      return res.status(404).json({ message: 'Avion non trouvé' });
    }

    onAirplaneChange?.();
    res.json(updated);
  }));

  router.delete('/airplanes/:id', authorize([1, 2]), asyncHandler(async (req, res) => {
    const removed = await airplanesRepo.remove(getPool(), req.params.id);
    if (!removed) {
      return res.status(404).json({ message: 'Avion non trouvé' });
    }
    onAirplaneChange?.();
    res.json({ message: `Avion "${removed.name}" supprimé avec succès` });
  }));

  return router;
};
