-- AIDC F-CK-1 Ching-kuo
--
-- Photo : F-CK-1A.jpg
--   licence CC BY-SA 4.0 — RudolphChen
--   https://commons.wikimedia.org/wiki/File%3AF-CK-1A.jpg

-- Entrée de référentiel propre à cette fiche.
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'TC-1 Tien Chien I', NULL, 'Missile air-air courte portée à guidage infrarouge, portée 8 km', 'Short-range infrared-guided air-to-air missile, 8 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'TC-1 Tien Chien I');

-- Entrée de référentiel propre à cette fiche.
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'TC-2 Tien Chien II', NULL, 'Missile air-air moyenne portée à guidage radar actif, portée 60 km', 'Medium-range active radar-guided air-to-air missile, 60 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'TC-2 Tien Chien II');

-- Insertion dans airplanes
INSERT INTO airplanes (
    name,
    name_en,
    complete_name,
    complete_name_en,
    little_description,
    little_description_en,
    image_url,
    description,
    description_en,
    country_id,
    date_concept,
    date_first_fly,
    date_operationel,
    max_speed,
    max_range,
    id_manufacturer,
    id_generation,
    type,
    status,
    status_en
) VALUES (
    'AIDC F-CK-1 Ching-kuo',
    'AIDC F-CK-1 Ching-kuo',
    'AIDC F-CK-1 Ching-kuo',
    'AIDC F-CK-1 Ching-kuo',
    'Chasseur taïwanais né d’un embargo américain',
    'Taiwanese fighter born of an American embargo',
    '/assets/airplanes/fck1-ching-kuo.jpg',
    E'## Genèse\nEn 1982, le communiqué conjoint sino-américain engage Washington à réduire progressivement ses ventes d''armes à Taïwan. Privée de F-16 et de F-20, l''île n''a d''autre choix que de concevoir son propre chasseur — avec l''assistance technique discrète de General Dynamics, Garrett et Lear Siegler.\n\n## Conception\nLa filiation avec le F-16 et le F-18 est visible : entrées d''air latérales, aile à emplantures prolongées, commandes de vol électriques. Faute d''accès à un réacteur puissant, l''appareil en reçoit **deux petits** F125 développés conjointement avec Honeywell — d''où une masse contenue et un rayon d''action limité, conçu pour la défense d''un espace aérien large de 200 kilomètres.\n\n## Carrière opérationnelle\nCent trente et un appareils, tous taïwanais. La commande initiale de 250 est réduite de moitié en 1992, lorsque les États-Unis autorisent finalement la vente de 150 F-16 — l''embargo qui avait justifié le programme se relâchant avant même sa fin. Le Ching-kuo assure depuis l''interception permanente face aux incursions dans la zone d''identification taïwanaise.\n\n## Place dans l''histoire\nLe F-CK-1 est le seul chasseur supersonique conçu et produit par Taïwan. Comme le IAI Lavi israélien ou le Tejas indien, il illustre ce qu''un embargo produit : une industrie nationale née d''une contrainte politique, et un appareil dont la raison d''être disparaît avec elle.',
    E'## Genesis\nIn 1982 the Sino-American joint communiqué committed Washington to gradually reducing arms sales to Taiwan. Denied the F-16 and the F-20, the island had no choice but to design its own fighter — with discreet technical assistance from General Dynamics, Garrett and Lear Siegler.\n\n## Design\nThe F-16 and F-18 lineage is visible: side intakes, a wing with extended root leading edges, fly-by-wire controls. Lacking access to a powerful engine, the aircraft received **two small** F125s developed jointly with Honeywell — hence a contained mass and a limited radius, designed to defend an airspace 200 kilometres wide.\n\n## Operational career\nOne hundred and thirty-one aircraft, all Taiwanese. The initial order for 250 was halved in 1992 when the United States finally authorised the sale of 150 F-16s — the embargo that had justified the programme easing before it even ended. The Ching-kuo has since flown standing interception against incursions into the Taiwanese identification zone.\n\n## Place in history\nThe F-CK-1 is the only supersonic fighter designed and built by Taiwan. Like the Israeli IAI Lavi or the Indian Tejas, it illustrates what an embargo produces: a national industry born of a political constraint, and an aircraft whose rationale disappears along with it.',
    (SELECT id FROM countries WHERE code = 'TWN'),
    '1982-01-01',
    '1989-05-28',
    '1994-01-01',
    1275.0,
    1100.0,
    (SELECT id FROM manufacturer WHERE code = 'AIDC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'), (SELECT id FROM armement WHERE name = 'TC-1 Tien Chien I')),
((SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'), (SELECT id FROM armement WHERE name = 'TC-2 Tien Chien II'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.21,
  wingspan          = 9.46,
  height            = 4.42,
  wing_area         = 24.2,
  empty_weight      = 6500,
  mtow              = 12250,
  service_ceiling   = 16760,
  climb_rate        = 254,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = 550,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Honeywell/ITEC F125-GA-100',
  engine_count      = 2,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 26.8,
  thrust_wet        = 42.1,

  -- Strate 3 : production & service
  production_start  = 1989,
  production_end    = 1999,
  units_built       = 131,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **F-CK-1A / B** : monoplace et biplace de série\n- **F-CK-1C / D Hsiang Sheng** : modernisation à mi-vie, capacité d''emport doublée\n- Nommé d''après **Tchang Ching-kuo**, président de la République de Chine (Taïwan) au lancement du programme',
  variants_en       = E'- **F-CK-1A / B** : single- and two-seat production versions\n- **F-CK-1C / D Hsiang Sheng** : mid-life upgrade with doubled weapons load\n- Named after **Chiang Ching-kuo**, President of the Republic of China (Taiwan) when the programme was launched',

  -- Strate 4 : qualitatif
  nickname          = 'Ching-kuo',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/AIDC_F-CK-1_Ching-kuo',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AIDC_F-CK-1_Ching-kuo',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'RudolphChen',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'AIDC F-CK-1 Ching-kuo';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AIDC F-CK-1 Ching-kuo';
