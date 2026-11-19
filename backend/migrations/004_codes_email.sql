-- =============================================================================
-- 004 — Codes à 6 chiffres au lieu des liens envoyés par email
-- =============================================================================
-- Activation du compte, mot de passe oublié et changement d'adresse passent
-- désormais par un code saisi sur le site (page de connexion, réglages) au
-- lieu d'un lien. Le code est court : chaque code n'a droit qu'à un nombre
-- limité d'essais, comptés dans la nouvelle colonne `attempts`.
--
-- Rejouable, additive, compatible avec le code précédent (la colonne a une
-- valeur par défaut ; l'ancien code ne la lit pas). À jouer en `postgres`
-- (les tables appartiennent à postgres en production) :
--   sudo -u postgres psql -d vol_histoire < 004_codes_email.sql
--
-- Ordre de mise en production : migration, puis déploiement. Les liens encore
-- ouverts sont clos ici : ils ne mèneraient plus nulle part (les anciennes
-- pages redirigent vers /login) ; le titulaire redemande un code.
-- =============================================================================

BEGIN;

ALTER TABLE email_tokens ADD COLUMN IF NOT EXISTS attempts SMALLINT NOT NULL DEFAULT 0;

COMMENT ON COLUMN email_tokens.token_hash IS
  'HMAC-SHA256 hex du code (lié au compte et au type) ; le code en clair n''est jamais stocké';
COMMENT ON COLUMN email_tokens.attempts IS
  'Essais manqués sur ce code ; au-delà du plafond, le code est clos';

UPDATE email_tokens SET used_at = NOW() WHERE used_at IS NULL;

COMMIT;
