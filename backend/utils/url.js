'use strict';

/**
 * Helpers URL partagés — source de vérité backend pour les slugs d'avion.
 * Utilisé par routes/details-ssr.js et routes/sitemap.js pour garantir
 * que toute URL `/details/<slug>-<id>` est générée au même endroit.
 */

/**
 * Convertit un texte libre en slug URL-safe.
 *  - Minuscules
 *  - Supprime les diacritiques (é → e, à → a, ñ → n)
 *  - Remplace tout non-alphanumérique par "-"
 *  - Trim les "-" de début/fin
 *
 * Exemples :
 *  - "F-22 Raptor" → "f-22-raptor"
 *  - "Mirage 2000 D" → "mirage-2000-d"
 *  - "Sukhoï Su-27 «Flanker»" → "sukhoi-su-27-flanker"
 */
function slugify(text) {
  return String(text || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

/**
 * Construit le chemin canonique pour une fiche avion.
 *  - Si le nom est présent : `/details/<slug>-<id>` (SEO-friendly + unique grâce à l'id)
 *  - Sinon (fallback) : `/details/<id>` (rare, si name absent en BDD)
 */
function buildDetailsPath(id, name) {
  const slug = slugify(name);
  return slug ? `/details/${slug}-${id}` : `/details/${id}`;
}

/**
 * Extrait l'id numérique depuis un slug "f-22-raptor-12" → 12
 * Retourne null si aucun nombre en fin de slug (URL invalide).
 */
function idFromSlug(slug) {
  if (!slug) return null;
  const m = String(slug).match(/-?(\d+)$/);
  return m ? Number(m[1]) : null;
}

module.exports = { slugify, buildDetailsPath, idFromSlug };
