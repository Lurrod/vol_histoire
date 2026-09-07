-- CASA C-101 Aviojet
--
-- Photo : 240602-F-AX516-2630 Beja Airshow 2024.jpg
--   licence CC BY 2.0 — Ronnie Macdonald from Chelmsford and Largs, United Kingdom
--   https://commons.wikimedia.org/wiki/File%3ACASA_C-101_Aviojet_Spanish_Air_Force_Patrulla_Aguila_%2819945001451%29.jpg

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
    'CASA C-101 Aviojet',
    'CASA C-101 Aviojet',
    'CASA C-101 Aviojet',
    'CASA C-101 Aviojet',
    'Entraîneur espagnol, monture de la Patrulla Águila',
    'Spanish trainer, mount of the Patrulla Águila',
    '/assets/airplanes/c101-aviojet.jpg',
    E'## Genèse\nL''Espagne sort de quarante ans d''isolement industriel. Le C-101 est son premier avion à réaction conçu nationalement, mené par CASA avec l''assistance de **Northrop** pour l''aile et de **Messerschmitt-Bölkow-Blohm** pour le fuselage arrière : une coopération qui vaut autant comme réintégration politique que comme transfert technique.\n\n## Conception\nRéacteur unique à double flux, sans postcombustion, dans une cellule volontairement sobre. La particularité est une **soute ventrale interchangeable** : elle accueille selon la mission un canon, des caméras de reconnaissance, une nacelle de guerre électronique ou un réservoir. Un même appareil change de métier en quelques heures.\n\n## Carrière opérationnelle\nCent soixante-six exemplaires. Le **Chili** en produit une version d''attaque sous licence, l''A-36 Halcón, capable d''emporter des missiles antinavires — le seul C-101 réellement armé pour le combat. Le Honduras et la Jordanie l''ont également adopté.\n\n## Place dans l''histoire\nLe C-101 a formé toutes les promotions de pilotes espagnols depuis 1980 et vole encore aux couleurs de la **Patrulla Águila**. Il a servi de socle industriel à la participation espagnole à l''Eurofighter et à l''A400M, via l''intégration de CASA dans **Airbus Defence and Space**.',
    E'## Genesis\nSpain was emerging from forty years of industrial isolation. The C-101 was its first nationally designed jet, led by CASA with **Northrop** assisting on the wing and **Messerschmitt-Bölkow-Blohm** on the rear fuselage: a cooperation that mattered as much as political reintegration as it did as technology transfer.\n\n## Design\nA single non-afterburning turbofan in a deliberately plain airframe. Its distinguishing feature is an **interchangeable ventral bay**: depending on the mission it takes a gun, reconnaissance cameras, an electronic warfare pod or a fuel tank. One aircraft changes trade in a few hours.\n\n## Operational career\nOne hundred and sixty-six built. **Chile** licence-built an attack version, the A-36 Halcón, able to carry anti-ship missiles — the only C-101 genuinely armed for combat. Honduras and Jordan also adopted it.\n\n## Place in history\nThe C-101 has trained every class of Spanish pilots since 1980 and still flies in **Patrulla Águila** colours. It provided the industrial base for Spain’s participation in the Eurofighter and the A400M, through CASA’s integration into **Airbus Defence and Space**.',
    (SELECT id FROM countries WHERE code = 'ESP'),
    '1975-01-01',
    '1977-06-27',
    '1980-03-01',
    770.0,
    4000.0,
    (SELECT id FROM manufacturer WHERE code = 'CASA'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA C-101 Aviojet'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'CASA C-101 Aviojet'), (SELECT id FROM tech WHERE name = 'Réacteur Honeywell TFE731'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA C-101 Aviojet'), (SELECT id FROM armement WHERE name = 'DEFA 553')),
((SELECT id FROM airplanes WHERE name = 'CASA C-101 Aviojet'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'CASA C-101 Aviojet'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA C-101 Aviojet'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'CASA C-101 Aviojet'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.5,
  wingspan          = 10.6,
  height            = 4.25,
  wing_area         = 20.0,
  empty_weight      = 3350,
  mtow              = 6300,
  service_ceiling   = 12800,
  climb_rate        = 21,
  g_limit_pos       = 7.5,
  g_limit_neg       = -3.9,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett TFE731-5-1J',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 21.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1978,
  production_end    = 1995,
  units_built       = 166,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **C-101EB** : version d''entraînement de l''armée de l''air espagnole\n- **C-101BB / CC** : versions armées d''exportation, moteur plus puissant\n- **A-36 Halcón** : version chilienne d''attaque, engagée avec missiles antinavires\n- Monture de la patrouille acrobatique **Patrulla Águila** depuis 1985',
  variants_en       = E'- **C-101EB** : Spanish Air Force training version\n- **C-101BB / CC** : armed export versions with a more powerful engine\n- **A-36 Halcón** : Chilean attack version, fitted with anti-ship missiles\n- Mount of the **Patrulla Águila** display team since 1985',

  -- Strate 4 : qualitatif
  nickname          = 'Mirlo',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/CASA_C-101',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/CASA_C-101_Aviojet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Photo by Senior Airman Renee Nicole Finona / 48th Fighter Wing',
  image_licence     = 'Public domain'
WHERE name = 'CASA C-101 Aviojet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'CASA C-101 Aviojet';
