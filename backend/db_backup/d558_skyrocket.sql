-- Douglas D-558-2 Skyrocket
--
-- Photo : Skyrocket In Flight With F-86 Chase Plane - GPN-2000-000107.jpg
--   licence Public domain — NACA
--   https://commons.wikimedia.org/wiki/File%3ASkyrocket_In_Flight_With_F-86_Chase_Plane_-_GPN-2000-000107.jpg

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
    'D-558-2 Skyrocket',
    'D-558-2 Skyrocket',
    'Douglas D-558-2 Skyrocket',
    'Douglas D-558-2 Skyrocket',
    'Premier appareil à voler à Mach 2, en 1953',
    'First aircraft to fly at Mach 2, in 1953',
    '/assets/airplanes/d558-skyrocket.jpg',
    E'## Genèse\nL''US Navy mène son propre programme de recherche transsonique, en parallèle de celui de l''Air Force et de son X-1. La première phase, le D-558-1 Skystreak à aile droite, décolle d''une piste. La seconde, le **Skyrocket**, adopte l''aile en flèche et la fusée, et vise franchement l''au-delà du mur du son.\n\n## Conception\nL''appareil naît avec deux motorisations : un turboréacteur J34 pour décoller et monter, un moteur-fusée LR8 pour la pointe. La configuration se révèle lourde et lente à monter. Les ingénieurs finissent par **retirer le réacteur**, condamner les entrées d''air et faire larguer l''appareil par un bombardier — le carburant ainsi économisé est ce qui rendra le record possible.\n\n## Carrière opérationnelle\nAucune. Trois cent treize vols entre 1948 et 1956. Le **20 novembre 1953**, **Scott Crossfield** pique depuis vingt-sept mille mètres et atteint **Mach 2,005**, soit 2 172 km/h : personne n''avait jamais volé deux fois plus vite que le son. Le vol est préparé en secret, pour devancer le vol record que Chuck Yeager s''apprête à tenter sur X-1A.\n\n## Place dans l''histoire\nTrois exemplaires. Yeager reprendra le record trois semaines plus tard à Mach 2,44 — mais le premier Mach 2 de l''histoire reste au Skyrocket. Crossfield, lui, sera ensuite le premier pilote d''essai du **X-15**, qui multipliera ce record par trois.',
    E'## Genesis\nThe US Navy ran its own transonic research programme alongside the Air Force''s X-1. The first phase, the straight-winged D-558-1 Skystreak, took off from a runway. The second, the **Skyrocket**, adopted a swept wing and a rocket, and aimed squarely beyond the sound barrier.\n\n## Design\nThe aircraft was born with two powerplants: a J34 turbojet to take off and climb, an LR8 rocket for the dash. The arrangement proved heavy and slow to climb. Engineers ended up **removing the turbojet**, sealing the intakes and having the aircraft air-launched from a bomber — the propellant thus saved is what made the record possible.\n\n## Operational career\nNone. Three hundred and thirteen flights between 1948 and 1956. On **20 November 1953** **Scott Crossfield** dived from twenty-seven thousand metres and reached **Mach 2.005**, or 2,172 km/h: nobody had ever flown at twice the speed of sound. The flight was prepared in secret, to forestall the record attempt Chuck Yeager was about to make in the X-1A.\n\n## Place in history\nThree built. Yeager would take the record back three weeks later at Mach 2.44 — but history''s first Mach 2 belongs to the Skyrocket. Crossfield went on to be the first test pilot of the **X-15**, which would triple that record.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-01-01',
    '1948-02-04',
    NULL,
    2172.0,
    400.0,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket'), (SELECT id FROM tech WHERE name = 'Moteur-fusée')),
((SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.79,
  wingspan          = 7.62,
  height            = 3.86,
  wing_area         = 16.2,
  empty_weight      = 4530,
  mtow              = 7160,
  service_ceiling   = 25370,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 180,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Reaction Motors LR8-RM-6',
  engine_count      = 1,
  engine_type       = 'Moteur-fusée à ergols liquides',
  engine_type_en    = 'Liquid-fuel rocket engine',
  thrust_dry        = 26.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1946,
  production_end    = 1949,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **D-558-2** : trois exemplaires, trois cent treize vols de 1948 à 1956\n- Premier appareil au monde à atteindre **Mach 2**, le 20 novembre 1953\n- Configuration mixte à l''origine : un turboréacteur **et** une fusée dans la même cellule\n- Largué d''un **P2B-1S**, version navalisée du B-29, pour économiser le carburant\n- **Scott Crossfield** aux commandes du vol record, qu''il pilote sans combinaison pressurisée',
  variants_en       = E'- **D-558-2** : three aircraft, three hundred and thirteen flights, 1948–1956\n- First aircraft in the world to reach **Mach 2**, on 20 November 1953\n- Originally a mixed layout: a turbojet **and** a rocket in the same airframe\n- Air-launched from a **P2B-1S**, the Navy''s B-29, to save propellant\n- **Scott Crossfield** flew the record flight, without a pressure suit',

  -- Strate 4 : qualitatif
  nickname          = 'Skyrocket',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_D-558-2_Skyrocket',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_D-558-2_Skyrocket',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NACA',
  image_licence     = 'Public domain'
WHERE name = 'D-558-2 Skyrocket';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'D-558-2 Skyrocket';
