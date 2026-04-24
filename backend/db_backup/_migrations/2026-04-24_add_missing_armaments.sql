-- =============================================================================
-- Migration : 2026-04-24 — ajout des armements manquants dans `armement`
-- Contexte  : 33 nouveaux avions (Suède, Inde, Japon, Brésil, Israël) nécessitent
--             des armements nationaux qui n'étaient pas présents dans la seed.
-- Idempotence : ON CONFLICT (name) DO NOTHING — ré-exécutable sans erreur.
-- =============================================================================

-- Pré-requis : la table `armement` possède une contrainte UNIQUE sur `name`.
-- Si ce n'est pas le cas en prod, créer l'index avant exécution :
--   CREATE UNIQUE INDEX IF NOT EXISTS ux_armement_name ON armement (name);

INSERT INTO armement (name, name_en, description, description_en) VALUES
('Shafrir 2', NULL,
  'Missile air-air courte portée israélien, guidage infrarouge, 5 km',
  'Israeli short-range air-to-air missile, infrared guidance, 5 km'),
('Rampage', NULL,
  'Missile air-sol supersonique stand-off israélien, portée 150 km',
  'Israeli supersonic stand-off air-to-surface missile, 150 km range'),
('Delilah', NULL,
  'Missile de croisière israélien air-sol/antinavire, portée 250 km',
  'Israeli air-to-surface/anti-ship cruise missile, 250 km range'),
('Rb 04E', NULL,
  'Missile antinavire suédois subsonique, portée 32 km',
  'Swedish subsonic anti-ship missile, 32 km range'),
('Rb 05A', NULL,
  'Missile air-sol suédois, guidage radio, portée 9 km',
  'Swedish air-to-surface missile, radio guidance, 9 km range'),
('Rb 15F', NULL,
  'Missile antinavire suédois turbo, portée 200 km',
  'Swedish turbojet anti-ship missile, 200 km range'),
('Astra Mk1', NULL,
  'Missile air-air BVR indien à guidage radar actif, portée 110 km',
  'Indian BVR air-to-air missile with active radar guidance, 110 km range'),
('BrahMos-A', NULL,
  'Missile de croisière supersonique indo-russe air-sol/antinavire, portée 450 km',
  'Indo-Russian supersonic air-to-surface/anti-ship cruise missile, 450 km range'),
('ASM-3', NULL,
  'Missile antinavire supersonique japonais, portée 200 km',
  'Japanese supersonic anti-ship missile, 200 km range'),
('Popeye Turbo', NULL,
  'Missile de croisière israélien à longue portée, 1500 km',
  'Israeli long-range cruise missile, 1500 km range')
ON CONFLICT (name) DO NOTHING;

-- Associations nouvelles (airplane_armement) — relier les nouveaux armements
-- aux avions concernés. Protégé par ON CONFLICT si un index unique couvre
-- (id_airplane, id_armement).

-- Suède --------------------------------------------------------------------
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Saab 37 Viggen' AND r.name IN ('Rb 04E', 'Rb 05A', 'Rb 15F')
ON CONFLICT DO NOTHING;

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Saab JAS 39 Gripen' AND r.name IN ('Rb 15F')
ON CONFLICT DO NOTHING;

-- Inde ---------------------------------------------------------------------
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'HAL Tejas Mk1A' AND r.name IN ('Astra Mk1')
ON CONFLICT DO NOTHING;

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'HAL Tejas Mk2' AND r.name IN ('Astra Mk1', 'BrahMos-A')
ON CONFLICT DO NOTHING;

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'HAL AMCA' AND r.name IN ('Astra Mk1')
ON CONFLICT DO NOTHING;

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Su-30MKI' AND r.name IN ('Astra Mk1', 'BrahMos-A')
ON CONFLICT DO NOTHING;

-- Japon --------------------------------------------------------------------
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Mitsubishi F-2' AND r.name IN ('ASM-3')
ON CONFLICT DO NOTHING;

-- Israël -------------------------------------------------------------------
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Mirage IIICJ Shahak' AND r.name IN ('Shafrir 2')
ON CONFLICT DO NOTHING;

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'IAI Nesher' AND r.name IN ('Shafrir 2')
ON CONFLICT DO NOTHING;

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'IAI Kfir' AND r.name IN ('Shafrir 2', 'Delilah')
ON CONFLICT DO NOTHING;

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-15I Ra''am' AND r.name IN ('Rampage', 'Popeye Turbo')
ON CONFLICT DO NOTHING;

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-16I Sufa' AND r.name IN ('Rampage', 'Delilah')
ON CONFLICT DO NOTHING;

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-35I Adir' AND r.name IN ('Rampage')
ON CONFLICT DO NOTHING;
