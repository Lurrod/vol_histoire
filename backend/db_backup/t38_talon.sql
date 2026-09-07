-- Northrop T-38 Talon
--
-- Photo : A three-ship formation of T-38C Talon aircraft flies over Texas during a non-standard airspace training exercise, August 7, 2025.jpg
--   licence Public domain — Airman 1st Class Harrison Sullivan
--   https://commons.wikimedia.org/wiki/File%3AA_three-ship_formation_of_T-38C_Talon_aircraft_flies_over_Texas_during_a_non-standard_airspace_training_exercise%2C_August_7%2C_2025.jpg

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
    'T-38 Talon',
    'T-38 Talon',
    'Northrop T-38 Talon',
    'Northrop T-38 Talon',
    'Premier avion d’entraînement supersonique au monde, encore en service',
    'The world’s first supersonic trainer, still in service',
    '/assets/airplanes/t38-talon.jpg',
    E'## Genèse\nNorthrop développe sur fonds propres, à la fin des années 1950, un chasseur léger d''exportation baptisé N-156. L''US Air Force n''en veut pas comme avion de combat, mais reconnaît dans sa version biplace l''entraîneur supersonique qui lui manque. Le T-38 sera commandé avant son cousin le F-5.\n\n## Conception\nAile minuscule à faible allongement, deux J85 légers avec postcombustion, structure ramenée au strict nécessaire : à vide, le Talon pèse **trois tonnes**, moins qu''une voiture blindée. La conséquence est recherchée : il coûte peu à l''heure de vol tout en reproduisant fidèlement le comportement d''un chasseur de combat, y compris ses défauts à haute incidence.\n\n## Carrière opérationnelle\nPresque tous les pilotes de chasse américains des soixante dernières années sont passés par lui. La **NASA** l''utilise depuis 1964 pour l''entraînement des astronautes et le maintien de leurs qualifications ; les équipages de la navette spatiale s''y sont formés. La patrouille des **Thunderbirds** l''a volé de 1974 à 1982.\n\n## Place dans l''histoire\nPlus de soixante ans de service continu, un record pour un avion d''entraînement. Son remplaçant, le **T-7A Red Hawk**, accumule les retards : les cellules du Talon, prolongées à plusieurs reprises, doivent tenir jusqu''aux années 2030.',
    E'## Genesis\nIn the late 1950s Northrop privately developed a light export fighter called the N-156. The US Air Force did not want it as a combat aircraft but recognised in its two-seat version the supersonic trainer it lacked. The T-38 was ordered before its cousin the F-5.\n\n## Design\nA tiny low aspect ratio wing, two light afterburning J85s, structure cut to the bare minimum: empty, the Talon weighs **three tonnes**, less than an armoured car. The consequence was deliberate: it costs little per flight hour while faithfully reproducing a combat fighter’s behaviour, including its high-angle-of-attack vices.\n\n## Operational career\nAlmost every American fighter pilot of the last sixty years has flown it. **NASA** has used it since 1964 for astronaut training and currency; Space Shuttle crews trained on it. The **Thunderbirds** display team flew it from 1974 to 1982.\n\n## Place in history\nMore than sixty years of continuous service, a record for a training aircraft. Its replacement, the **T-7A Red Hawk**, keeps slipping: the Talon’s airframes, extended several times, must last into the 2030s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1956-01-01',
    '1959-04-10',
    '1961-03-17',
    1381.0,
    1835.0,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'T-38 Talon'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'T-38 Talon'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'T-38 Talon'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'T-38 Talon'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.14,
  wingspan          = 7.7,
  height            = 3.92,
  wing_area         = 15.79,
  empty_weight      = 3270,
  mtow              = 5485,
  service_ceiling   = 15200,
  climb_rate        = 170,
  g_limit_pos       = 7.33,
  g_limit_neg       = -3.0,
  combat_radius     = 700,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J85-GE-5',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 10.9,
  thrust_wet        = 17.1,

  -- Strate 3 : production & service
  production_start  = 1961,
  production_end    = 1972,
  units_built       = 1189,
  unit_cost_usd     = 756000,
  unit_cost_year    = 1961,
  operators_count   = 8,
  variants          = E'- **T-38A** : version d''entraînement de base\n- **AT-38B** : version armée pour l''entraînement au tir\n- **T-38C** : cockpit numérique, cellules prolongées jusqu''aux années 2030\n- **F-5 Freedom Fighter** : dérivé de combat, développé en parallèle',
  variants_en       = E'- **T-38A** : basic training version\n- **AT-38B** : armed version for weapons training\n- **T-38C** : digital cockpit, airframes extended into the 2030s\n- **F-5 Freedom Fighter** : combat derivative developed in parallel',

  -- Strate 4 : qualitatif
  nickname          = 'White Rocket',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_T-38_Talon',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_T-38_Talon',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Airman 1st Class Harrison Sullivan',
  image_licence     = 'Public domain'
WHERE name = 'T-38 Talon';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'T-38 Talon';
