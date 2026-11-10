-- 003_jetons_haches.sql — jetons envoyés par email stockés hachés (SEC-008)
--
-- Destinée aux bases DÉJÀ installées. Une installation à neuf n'en a pas
-- besoin : db_backup/db.sql contient déjà le résultat.
-- À jouer après 002_securite_sessions.sql, en `postgres` (les tables
-- appartiennent à postgres en production). Entièrement rejouable.
--
-- email_tokens.token (jeton en clair, 64 hex) devient email_tokens.token_hash
-- (SHA-256 hexadécimal du jeton). Le code n'écrit et ne compare plus que
-- l'empreinte : une fuite de la table, ou d'une sauvegarde pg_dump, ne permet
-- plus de réinitialiser un mot de passe ni de confirmer un changement d'email.
--
-- Jetons en cours de validité : ils sont HACHÉS sur place, pas invalidés. Le
-- calcul SQL encode(sha256(convert_to(token, 'UTF8')), 'hex') donne exactement
-- l'empreinte que calcule le code (repositories/email-tokens.js, hashToken) :
-- un lien envoyé avant la migration reste donc utilisable jusqu'à son
-- expiration (15 à 30 minutes). sha256() existe depuis PostgreSQL 11.
-- Si l'on préfère les invalider, jouer avant la migration :
--   UPDATE email_tokens SET used_at = NOW() WHERE used_at IS NULL;
--
-- Mise en garde : les sauvegardes pg_dump antérieures à cette migration
-- contiennent encore des jetons en clair (tous expirés depuis).

BEGIN;

ALTER TABLE email_tokens ADD COLUMN IF NOT EXISTS token_hash CHAR(64);

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_schema = current_schema()
               AND table_name = 'email_tokens' AND column_name = 'token') THEN
    UPDATE email_tokens
       SET token_hash = encode(sha256(convert_to(token, 'UTF8')), 'hex')
     WHERE token_hash IS NULL;
    -- Emporte la contrainte UNIQUE et l'index idx_email_tokens_token.
    ALTER TABLE email_tokens DROP COLUMN token;
  END IF;
END $$;

ALTER TABLE email_tokens ALTER COLUMN token_hash SET NOT NULL;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint
                 WHERE conname = 'email_tokens_token_hash_key'
                   AND conrelid = 'email_tokens'::regclass) THEN
    ALTER TABLE email_tokens ADD CONSTRAINT email_tokens_token_hash_key UNIQUE (token_hash);
  END IF;
END $$;

DROP INDEX IF EXISTS idx_email_tokens_token;

COMMIT;
