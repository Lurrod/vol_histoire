-- HAL HPT-32 Deepak
--
-- Photo : HAL HPT-32 Deepak at HAL Museum, Bangalore (Ank Kumar) 04.jpg
--   licence CC BY-SA 4.0 — Ank Kumar
--   https://commons.wikimedia.org/wiki/File:HAL_HPT-32_Deepak_at_HAL_Museum,_Bangalore_(Ank_Kumar)_04.jpg

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
    'HAL HPT-32 Deepak',
    'HAL HPT-32 Deepak',
    'HAL HPT-32 Deepak',
    'HAL HPT-32 Deepak',
    'L''avion d''entraînement de base conçu en Inde, cloué au sol en 2009 après une série d''accidents',
    'The Indian-designed basic trainer, grounded in 2009 after a string of accidents',
    '/assets/airplanes/hal-hpt32-deepak.jpg',
    E'## Genèse\nPour la formation initiale de ses élèves pilotes, l''armée de l''air indienne veut un avion d''entraînement de base conçu et construit dans le pays. **Hindustan Aeronautics Limited** en confie l''étude à son centre de recherche et de développement aéronautique. Le prototype du **HPT-32**, baptisé **Deepak**, c''est-à-dire « lumière », vole le 6 janvier 1977. L''appareil entre en service en 1984, dans l''armée de l''air comme dans l''aéronavale indiennes.\n\n## Conception\nLe Deepak est un monoplan monomoteur à aile basse dont l''élève et l''instructeur sont assis côte à côte. Il est conçu pour enseigner la voltige de base, la navigation et les autres savoir-faire du pilote. Un moteur **Lycoming** à six cylindres à plat de 260 ch lui donne 281 km/h en pointe et 1 400 km de distance franchissable. Quatre points d''emport, pour 255 kg de nacelles de mitrailleuses, de bombes ou de roquettes, permettent l''instruction à l''armement. En vol dos, l''essence provient d''un petit réservoir collecteur du fuselage, ce qui limite la manœuvre à une minute. Une version à turbopropulseur Allison 250, le **HTT-34**, vole le 17 juin 1984.\n\n## Carrière opérationnelle\nOutre la formation initiale, le Deepak sert à l''observation, à la liaison et au remorquage de cibles. Sa carrière est assombrie par des défaillances de son moteur, à l''origine de plusieurs accidents : dix-sept écrasements coûtent la vie à dix-neuf pilotes. En 2009, la flotte est clouée au sol, et le contrôleur général des comptes de l''Inde, le CAG, juge l''avion « technologiquement dépassé et miné par des risques pour la sécurité des vols ». En mai 2010, l''armée de l''air autorise l''installation d''un parachute de sauvetage pour l''avion entier.\n\n## Place dans l''histoire\nL''armée de l''air indienne a aligné 144 Deepak et la marine 8. Conçu et construit en Inde, le HPT-32 a fourni pendant un quart de siècle l''avion de début des pilotes militaires du pays, mais ses problèmes de motorisation ont écourté sa carrière. En 2013, le **Pilatus PC-7** Mk II le remplace comme avion d''entraînement de base de l''armée de l''air, et HAL prépare pour la suite le **HTT-40**, qui en est issu.',
    E'## Genesis\nFor the initial training of its student pilots, the Indian Air Force wanted a basic trainer designed and built in the country. **Hindustan Aeronautics Limited** entrusted the design to its Aircraft Research & Development Center. The prototype **HPT-32**, named **Deepak**, meaning ''light'', flew on 6 January 1977. The aircraft entered service in 1984 with both the Indian Air Force and the Indian Navy.\n\n## Design\nThe Deepak is a single-engined, low-wing monoplane in which pupil and instructor sit side by side. It was designed to teach basic aerobatics, navigation and other flying skills. A 260 hp six-cylinder **Lycoming** flat engine gives it a top speed of 281 km/h and a range of 1,400 km. Four hardpoints, carrying 255 kg of machine gun pods, bombs or rockets, allow weapons instruction. In inverted flight fuel comes from a small collector tank in the fuselage, which limits the manoeuvre to one minute. A turboprop version powered by an Allison 250, the **HTT-34**, flew on 17 June 1984.\n\n## Operational career\nBesides initial training, the Deepak was used for observation, liaison and target towing. Its career was clouded by engine failures that caused several accidents: seventeen crashes cost the lives of nineteen pilots. In 2009 the fleet was grounded, and India''s Comptroller and Auditor General described the aircraft as technologically outdated and beset by flight safety hazards. In May 2010 the air force cleared the installation of a whole-aircraft parachute recovery system.\n\n## Place in history\nThe Indian Air Force fielded 144 Deepaks and the Navy eight. Designed and built in India, the HPT-32 provided the country''s military pilots with their first aircraft for a quarter of a century, but its engine problems cut its career short. In 2013 the **Pilatus PC-7** Mk II replaced it as the air force''s basic trainer, and HAL is preparing the **HTT-40**, developed from it, for the future.',
    (SELECT id FROM countries WHERE code = 'IND'),
    NULL,
    '1977-01-06',
    '1984-01-01',
    281,
    1400,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HPT-32 Deepak'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HPT-32 Deepak'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'HAL HPT-32 Deepak'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.7,
  wingspan          = 9.5,
  height            = 2.9,
  wing_area         = 15.0,
  empty_weight      = 1034,
  mtow              = 1322,
  service_ceiling   = 5500,
  climb_rate        = 5.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming EIO-540-D4B5 (260 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **HPT-32** : version de base à moteur à pistons Lycoming de 260 ch, premier vol le 6 janvier 1977\n- **HTT-34** : version à turbopropulseur Allison 250-B17D de 420 ch, premier vol le 17 juin 1984\n- Flotte de l''armée de l''air indienne : **144** appareils ; aéronavale : **8**\n- Emploi secondaire : observation, liaison et **remorquage de cibles**',
  variants_en       = E'- **HPT-32**: basic version with a 260 hp Lycoming piston engine, first flown on 6 January 1977\n- **HTT-34**: turboprop version with a 420 shp Allison 250-B17D, first flown on 17 June 1984\n- Indian Air Force fleet: **144** aircraft; Indian Navy: **8**\n- Secondary roles: observation, liaison and **target towing**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/HAL_HPT-32_Deepak',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ank Kumar',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'HAL HPT-32 Deepak';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'HAL HPT-32 Deepak';
