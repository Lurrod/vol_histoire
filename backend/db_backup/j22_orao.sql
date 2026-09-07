-- Soko J-22 Orao
--
-- Photo : J-22 Orao 25121 241 LBAE 98 (cropped).jpg
--   licence CC BY-SA 4.0 — Srđan Popović
--   https://commons.wikimedia.org/wiki/File%3AJ-22_Orao_25121_241_LBAE_98_%28cropped%29.jpg

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
    'Soko J-22 Orao',
    'Soko J-22 Orao',
    'Soko J-22 Orao',
    'Soko J-22 Orao',
    'Avion d’attaque yougoslavo-roumain, seul programme commun du bloc non aligné',
    'Yugoslav-Romanian attack aircraft, the bloc’s only joint programme',
    '/assets/airplanes/j22-orao.jpg',
    E'## Genèse\nEn 1970, la Yougoslavie de Tito et la Roumanie de Ceaușescu — les deux États socialistes les plus distants de Moscou — lancent le programme **YuRom**. Objectif : un avion d''attaque conçu et produit sans dépendre ni de l''URSS ni de l''OTAN. C''est le seul programme d''armement commun jamais mené entre deux pays du bloc de l''Est en dehors du cadre soviétique.\n\n## Conception\nSilhouette proche du SEPECAT Jaguar, dont il partage la vocation. Deux réacteurs **Rolls-Royce Viper** construits sous licence — achetés à l''Ouest, ce que seule la position non alignée de Belgrade permettait. La postcombustion, absente des premières versions, sera développée localement faute d''accord britannique.\n\n## Carrière opérationnelle\nEngagé dans les **guerres de Yougoslavie** à partir de 1991 par plusieurs des forces issues de l''éclatement du pays — la même cellule se retrouvant des deux côtés du front. Les derniers Orao serbes volent jusqu''en 2020 ; les IAR-93 roumains sont retirés en 1998.\n\n## Place dans l''histoire\nCent soixante-cinq exemplaires pour un programme mené par deux pays de taille moyenne, sans transfert de technologie majeur. L''Orao est le témoin d''une **troisième voie industrielle** de la guerre froide, disparue avec les États qui l''avaient portée.',
    E'## Genesis\nIn 1970 Tito’s Yugoslavia and Ceaușescu’s Romania — the two socialist states furthest from Moscow — launched the **YuRom** programme. The goal: an attack aircraft designed and built without depending on either the USSR or NATO. It is the only joint armament programme ever run between two Eastern bloc countries outside the Soviet framework.\n\n## Design\nA silhouette close to the SEPECAT Jaguar, whose role it shares. Two licence-built **Rolls-Royce Viper** engines — bought in the West, which only Belgrade’s non-aligned position allowed. Afterburning, absent from the first versions, was developed locally for want of British agreement.\n\n## Operational career\nCommitted in the **Yugoslav Wars** from 1991 by several of the forces that emerged from the country’s break-up — the same airframe appearing on both sides of the front. The last Serbian Oraos flew until 2020; the Romanian IAR-93s were retired in 1998.\n\n## Place in history\nOne hundred and sixty-five aircraft for a programme run by two medium-sized countries with no major technology transfer. The Orao is the witness of a Cold War **third industrial way**, gone along with the states that carried it.',
    (SELECT id FROM countries WHERE code = 'YUG'),
    '1970-01-01',
    '1974-10-31',
    '1978-01-01',
    1160.0,
    1320.0,
    (SELECT id FROM manufacturer WHERE code = 'SOKO'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Viper'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM armement WHERE name = 'S-5'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Soko J-22 Orao'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.9,
  wingspan          = 9.3,
  height            = 4.45,
  wing_area         = 26.0,
  empty_weight      = 5700,
  mtow              = 11080,
  service_ceiling   = 13500,
  climb_rate        = 89,
  g_limit_pos       = 8.0,
  g_limit_neg       = NULL,
  combat_radius     = 450,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Viper Mk 633-41',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 17.8,
  thrust_wet        = 22.2,

  -- Strate 3 : production & service
  production_start  = 1978,
  production_end    = 1992,
  units_built       = 165,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **J-22 Orao** : version yougoslave monoplace d''attaque\n- **IAR-93 Vultur** : version roumaine, développée en parallèle sur le même dessin\n- **NJ-22** : biplace d''entraînement et de conversion\n- Chaînes de production **séparées** en Yougoslavie et en Roumanie, pièces interchangeables',
  variants_en       = E'- **J-22 Orao** : Yugoslav single-seat attack version\n- **IAR-93 Vultur** : Romanian version, developed in parallel from the same design\n- **NJ-22** : two-seat trainer and conversion version\n- **Separate** production lines in Yugoslavia and Romania, with interchangeable parts',

  -- Strate 4 : qualitatif
  nickname          = 'Orao',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soko_J-22_Orao',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Soko_J-22_Orao',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Srđan Popović',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Soko J-22 Orao';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Soko J-22 Orao';
