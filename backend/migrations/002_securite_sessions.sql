-- 002_securite_sessions.sql — correctifs de l'audit de sécurité (sessions et comptes)
--
-- Destinée aux bases DÉJÀ installées. Une installation à neuf n'en a pas
-- besoin : db_backup/db.sql contient déjà le résultat.
-- À jouer après 001_mise_a_niveau.sql. Entièrement rejouable.
--
--   1. users.token_version         : invalide les access tokens émis avant un
--                                    changement de rôle, d'email ou de mot de passe
--   2. refresh_tokens.rotated_at   : distingue un jeton remplacé par rotation
--                                    (rejeu = vol probable) d'un jeton révoqué
--   3. email_tokens type 'email'   : changement d'adresse confirmé par un lien
--      + email_tokens.new_email      envoyé à la nouvelle adresse

BEGIN;

ALTER TABLE users ADD COLUMN IF NOT EXISTS token_version INTEGER NOT NULL DEFAULT 0;

ALTER TABLE refresh_tokens ADD COLUMN IF NOT EXISTS rotated_at TIMESTAMPTZ NULL;

ALTER TABLE email_tokens ADD COLUMN IF NOT EXISTS new_email VARCHAR(255) NULL;
ALTER TABLE email_tokens DROP CONSTRAINT IF EXISTS email_tokens_type_check;
ALTER TABLE email_tokens
  ADD CONSTRAINT email_tokens_type_check CHECK (type IN ('verify', 'reset', 'email'));

COMMIT;
