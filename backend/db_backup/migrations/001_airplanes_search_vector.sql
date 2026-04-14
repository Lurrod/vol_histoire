-- =============================================================================
-- Migration 001 — Full-text search sur airplanes
-- =============================================================================
-- Ajoute une colonne search_vector (tsvector) calculée automatiquement depuis
-- name / complete_name / descriptions (FR + EN), puis un index GIN.
--
-- Config 'simple' = pas de stemming (garde intacts "F-16", "MiG-29", "Rafale").
-- Poids : A=nom (match prioritaire), B=nom complet, C=résumé, D=description.
--
-- Idempotent : ADD COLUMN IF NOT EXISTS + CREATE INDEX IF NOT EXISTS.
--
-- Exécution : psql $DATABASE_URL -f backend/db_backup/migrations/001_airplanes_search_vector.sql
-- =============================================================================

ALTER TABLE airplanes
  ADD COLUMN IF NOT EXISTS search_vector tsvector
  GENERATED ALWAYS AS (
    setweight(to_tsvector('simple', coalesce(name, '')),                'A') ||
    setweight(to_tsvector('simple', coalesce(name_en, '')),             'A') ||
    setweight(to_tsvector('simple', coalesce(complete_name, '')),       'B') ||
    setweight(to_tsvector('simple', coalesce(complete_name_en, '')),    'B') ||
    setweight(to_tsvector('simple', coalesce(little_description, '')),  'C') ||
    setweight(to_tsvector('simple', coalesce(little_description_en, '')),'C') ||
    setweight(to_tsvector('simple', coalesce(description, '')),         'D') ||
    setweight(to_tsvector('simple', coalesce(description_en, '')),      'D')
  ) STORED;

CREATE INDEX IF NOT EXISTS idx_airplanes_search_vector
  ON airplanes USING GIN (search_vector);
