-- Martin P4M Mercator
--
-- Photo : Martin P4M-1 Mercator of VP-21 in flight in the early 1950s (NH 101801-KN).jpg
--   licence Public domain — Commander Richard Timm, U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Martin_P4M-1_Mercator_of_VP-21_in_flight_in_the_early_1950s_(NH_101801-KN).jpg

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
    'Martin P4M Mercator',
    'Martin P4M Mercator',
    'Martin P4M Mercator',
    'Martin P4M Mercator',
    'Patrouilleur à hélices et réacteurs mêlés, recyclé en espion électronique nocturne au large de la Chine et de l''URSS',
    'A mixed piston-and-jet patrol bomber turned night-time electronic spy off China and the Soviet Union',
    '/assets/airplanes/p4m-mercator.jpg',
    E'## Genèse\nEn 1944, la **Glenn L. Martin Company** commence l''étude du **Model 219**, destiné à remplacer le **PB4Y Privateer** dans la patrouille maritime à long rayon d''action, avec une spécialité : le mouillage de mines loin des côtes. Le prototype **XP4M-1** vole pour la première fois le 20 octobre 1946. Mais l''US Navy lui préfère le **P2V Neptune**, plus petit, plus simple, moins cher et plus performant. Elle commande malgré tout dix-neuf Mercator en 1947, pour le mouillage rapide de mines.\n\n## Conception\nGrand et complexe, le Mercator repose sur deux moteurs en étoile **Pratt & Whitney R-4360 Wasp Major** de 28 cylindres. Pour le décollage et le combat, un turboréacteur **Allison J33** est logé à l''arrière de chaque nacelle agrandie, son entrée d''air placée sous le moteur à pistons ; comme sur la plupart des hybrides de l''époque, il brûle l''essence de l''avion, ce qui évite un second carburant. L''armement défensif est lourd : canons de 20 mm en tourelles de nez et de queue, mitrailleuses de 12,7 mm en tourelle dorsale. La soute, longue et peu profonde à la manière britannique, accepte jusqu''à 5 400 kg de bombes, mines, grenades sous-marines, torpilles ou réservoirs supplémentaires.\n\n## Carrière opérationnelle\nLe P4M entre en service en 1950 au **Patrol Squadron 21**, déployé à Port-Lyautey, au Maroc, jusqu''en février 1953. Dès 1951, les dix-huit appareils survivants deviennent des **P4M-1Q** de renseignement électronique : l''équipage passe à 14, puis 16 hommes, et la cellule se hérisse d''antennes. Depuis les Philippines puis le Japon, une unité secrète, future **VQ-1**, longe de nuit, feux éteints, les côtes du Vietnam, de la Chine, de la Corée du Nord et de l''Extrême-Orient soviétique, à une cinquantaine de kilomètres du rivage ; les avions se font passer à la radio pour des Neptune et portent de faux numéros. Le 22 août 1956, un Mercator est abattu près de Shanghai par des chasseurs chinois, avec ses seize hommes ; le 16 juin 1959, un autre revient criblé par deux MiG-17 nord-coréens.\n\n## Place dans l''histoire\nPerdant d''une compétition, le Mercator a trouvé sa vraie mission dans l''ombre de la **guerre froide** : écouter les radars adverses, au prix de pertes que Washington taisait. Il est remplacé par l''**EA-3B Skywarrior**, embarqué sur porte-avions et donc plus souple, et par le **WV-2Q Warning Star**, plus grand. Les derniers sont retirés en 1960 puis ferraillés. Sa formule hybride, piston et réaction réunis dans une même nacelle, résume une époque où l''aviation navale hésitait encore entre deux âges.',
    E'## Genesis\nIn 1944 the **Glenn L. Martin Company** began work on the **Model 219**, intended to replace the **PB4Y Privateer** in long-range maritime patrol, with one speciality: laying mines far from the coast. The **XP4M-1** prototype first flew on 20 October 1946. But the US Navy preferred the **P2V Neptune**, smaller, simpler, cheaper and better performing. It nevertheless ordered nineteen Mercators in 1947 for high-speed minelaying.\n\n## Design\nLarge and complicated, the Mercator relied on two 28-cylinder **Pratt & Whitney R-4360 Wasp Major** radial engines. For take-off and combat, an **Allison J33** turbojet sat at the rear of each enlarged nacelle, its intake beneath and behind the piston engine; like most hybrids of the time, it burned the aircraft''s gasoline, removing the need for a second fuel. The defensive armament was heavy: 20 mm cannon in nose and tail turrets, 12.7 mm machine guns in a dorsal turret. The long, shallow bomb bay, in the British manner, could take up to 5,400 kg of bombs, mines, depth charges, torpedoes or extra fuel tanks.\n\n## Operational career\nThe P4M entered service in 1950 with **Patrol Squadron 21**, deployed to Port Lyautey in French Morocco until February 1953. From 1951 the eighteen surviving aircraft became **P4M-1Q** electronic intelligence aircraft: the crew grew to 14, then 16, and the airframe sprouted antennas. From the Philippines and then Japan, a secretive unit, the future **VQ-1**, flew at night with no lights along the coasts of Vietnam, China, North Korea and the Soviet Far East, some 56 km offshore; on the radio the aircraft posed as Neptunes and carried false serial numbers. On 22 August 1956 a Mercator was shot down near Shanghai by Chinese fighters, killing all sixteen aboard; on 16 June 1959 another came home badly damaged by two North Korean MiG-17s.\n\n## Place in history\nThe loser of a competition, the Mercator found its true mission in the shadows of the **Cold War**: listening to enemy radars, at the cost of losses that Washington kept quiet. It was replaced by the **EA-3B Skywarrior**, carrier-based and therefore more flexible, and by the larger **WV-2Q Warning Star**. The last ones were withdrawn in 1960 and scrapped. Its hybrid formula, piston and jet combined in a single nacelle, sums up an era when naval aviation still hesitated between two ages.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-01-01',
    '1946-10-20',
    '1950-01-01',
    660,
    4570,
    (SELECT id FROM manufacturer WHERE code = 'MAR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin P4M Mercator'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin P4M Mercator'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin P4M Mercator'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Martin P4M Mercator'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin P4M Mercator'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 26.28,
  wingspan          = 34.75,
  height            = 8.89,
  wing_area         = 121.8,
  empty_weight      = 22016,
  mtow              = 37820,
  service_ceiling   = 10546,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 9,

  -- Strate 2 : motorisation
  engine_name       = '2 × Pratt & Whitney R-4360-20A Wasp Major (3 250 ch) + 2 × Allison J33-A-10A (20,5 kN)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 21,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XP4M-1** : deux prototypes à moteurs R-4360-4 et réacteurs J33-A-17, premier vol le 20 octobre 1946\n- **P4M-1** : version de série de patrouille et de mouillage de mines, dix-neuf construits, au Patrol Squadron 21 de 1950 à 1953\n- **P4M-1Q** : les dix-huit survivants convertis dès 1951 au renseignement électronique, équipage de 14 puis 16 hommes',
  variants_en       = E'- **XP4M-1**: two prototypes with R-4360-4 engines and J33-A-17 jets, first flight on 20 October 1946\n- **P4M-1**: production patrol and minelaying version, nineteen built, flown by Patrol Squadron 21 from 1950 to 1953\n- **P4M-1Q**: the eighteen survivors converted from 1951 to electronic intelligence, with a crew of 14 and later 16',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Martin_P4M_Mercator',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Martin_P4M_Mercator',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Commander Richard Timm, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Martin P4M Mercator';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Martin P4M Mercator';
