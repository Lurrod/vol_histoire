'use strict';

/**
 * Suivi des migrations (DEVOPS-003). Les scripts de backend/migrations/ se
 * jouent à la main ; chacun s'inscrit dans la table schema_migrations, et une
 * installation neuve (db_backup/db.sql) les y inscrit tous. Au démarrage, le
 * serveur compare la table à la liste ci-dessous : en production, une
 * migration manquante l'empêche de démarrer, ce qui fait échouer les tests de
 * fumée du déploiement et déclenche le retour arrière automatique — au lieu
 * d'un code qui lit une colonne absente.
 *
 * Toute nouvelle migration s'ajoute ici (un test compare cette liste aux
 * fichiers du dossier) et se joue AVANT la fusion du code qui l'attend.
 */
const REQUIRED_MIGRATIONS = Object.freeze([
  '001_mise_a_niveau',
  '002_securite_sessions',
  '003_jetons_haches',
  '004_codes_email',
  '005_suivi_migrations',
]);

/** Migrations requises absentes de la base (toutes si la table n'existe pas). */
async function missingMigrations(pool) {
  let rows;
  try {
    ({ rows } = await pool.query('SELECT name FROM schema_migrations'));
  } catch (err) {
    if (err && err.code === '42P01') return [...REQUIRED_MIGRATIONS]; // table absente
    throw err;
  }
  const applied = new Set(rows.map((r) => r.name));
  return REQUIRED_MIGRATIONS.filter((name) => !applied.has(name));
}

/**
 * Vérifie le schéma au démarrage. En production, rejette si une migration
 * manque (le serveur ne démarre pas) ; ailleurs, avertit seulement.
 * @returns {Promise<string[]>} migrations manquantes
 */
async function checkSchema(pool, { env = process.env, logger } = {}) {
  const missing = await missingMigrations(pool);
  if (missing.length) {
    const details = { missing: missing.join(', ') };
    if (env.NODE_ENV === 'production') {
      if (logger) logger.error('Migrations non jouées : démarrage refusé', details);
      throw new Error(`Migrations non jouées : ${missing.join(', ')}`);
    }
    if (logger) logger.warn('Migrations non jouées sur cette base', details);
  }
  return missing;
}

module.exports = { REQUIRED_MIGRATIONS, missingMigrations, checkSchema };
