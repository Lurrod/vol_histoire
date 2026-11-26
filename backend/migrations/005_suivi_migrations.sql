-- =============================================================================
-- 005 — Suivi des migrations jouées (DEVOPS-003)
-- =============================================================================
-- Crée la table schema_migrations et y inscrit les migrations 001 à 005. Les
-- quatre premières sont déjà en place sur toute base qui arrive ici (le README
-- impose l'ordre 001 → 004). Chaque migration suivante s'inscrira elle-même ;
-- le serveur refuse de démarrer en production s'il en manque une
-- (backend/utils/schema-migrations.js), ce qui déclenche le retour arrière du
-- déploiement.
--
-- Rejouable, additive, compatible avec le code précédent. À jouer en
-- `postgres`, AVANT la fusion du code qui la vérifie :
--   sudo -u postgres psql -d vol_histoire < 005_suivi_migrations.sql
-- =============================================================================

BEGIN;

CREATE TABLE IF NOT EXISTS schema_migrations (
  name       TEXT PRIMARY KEY,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

GRANT SELECT ON schema_migrations TO vol_user;

INSERT INTO schema_migrations (name) VALUES
  ('001_mise_a_niveau'),
  ('002_securite_sessions'),
  ('003_jetons_haches'),
  ('004_codes_email'),
  ('005_suivi_migrations')
ON CONFLICT (name) DO NOTHING;

COMMIT;
