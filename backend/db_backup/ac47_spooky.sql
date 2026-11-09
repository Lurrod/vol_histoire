-- Douglas AC-47 Spooky
--
-- Photo : Douglas AC-47D 4SOS in flight 1968.jpeg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Douglas_AC-47D_4SOS_in_flight_1968.jpeg

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
    'AC-47 Spooky',
    'AC-47 Spooky',
    'Douglas AC-47 Spooky',
    'Douglas AC-47 Spooky',
    'Un DC-3, trois Minigun et une orbite : la première canonnière volante',
    'A DC-3, three Miniguns and an orbit: the first flying gunship',
    '/assets/airplanes/ac47-spooky.jpg',
    E'## Genèse\nAu début des années 1960, plusieurs officiers de l''US Air Force reprennent une idée géométrique simple : un avion qui décrit un virage incliné autour d''un point garde ses armes braquées sur ce point aussi longtemps qu''il tourne. Le capitaine **John C. Simons** fait valider le principe en 1964. Reste à trouver une cellule : ce sera celle qui ne manque pas, le **C-47**, version militaire du DC-3, disponible par centaines dans les parcs de l''armée.\n\n## Conception\nTrois mitrailleuses rotatives **GAU-2/A Minigun** de 7,62 mm tirent par les fenêtres et la porte du flanc gauche, chacune capable de 6 000 coups par minute. Le pilote vise au moyen d''un simple collimateur fixé à sa vitre latérale et tient l''orbite ; l''avion emporte aussi des fusées éclairantes pour illuminer le terrain la nuit. Pour le reste, rien ne change : deux moteurs en étoile **Pratt & Whitney Twin Wasp**, une vitesse modeste, sept hommes à bord.\n\n## Carrière opérationnelle\nLa première mission de combat a lieu dans la nuit du 23 au 24 décembre 1964, au secours d''un poste assiégé du delta du Mékong. Cinquante-trois appareils sont convertis ; quarante et un servent au Vietnam, dix-neuf sont perdus, dont douze au combat. Le ruban continu de ses balles traçantes lui vaut le surnom de **Puff the Magic Dragon**. Le 24 février 1969, l''aviateur **John L. Levitow**, blessé de quarante éclats, jette hors de l''avion une fusée éclairante amorcée tombée dans la soute, et reçoit la Medal of Honor. Relayé dès 1968 par l''AC-119 puis par l''**AC-130**, l''appareil est cédé aux forces sud-vietnamiennes, laotiennes et cambodgiennes.\n\n## Place dans l''histoire\nUn avion de ligne des années 1930, trois mitrailleuses et une idée de géométrie : l''AC-47 fonde la lignée des canonnières volantes. L''**AC-130 Spectre**, qui lui succède, en reprend exactement le principe à une tout autre échelle. La Colombie en exploite encore une descendance, l''**AC-47T Fantasma**, bâtie sur des cellules remotorisées en turbopropulseurs.',
    E'## Genesis\nIn the early 1960s several US Air Force officers took up a simple geometric idea: an aircraft flying a banked turn around a point keeps its weapons trained on that point for as long as it circles. Captain **John C. Simons** had the principle validated in 1964. An airframe was still needed, and the choice fell on the one that was never in short supply: the **C-47**, military version of the DC-3, available by the hundred in service inventories.\n\n## Design\nThree **GAU-2/A Minigun** 7.62 mm rotary machine guns fire through the windows and door of the left side, each capable of 6,000 rounds a minute. The pilot aims through a simple sight fixed to his side window and holds the orbit; the aircraft also carries flares to light up the ground at night. Nothing else changes: two **Pratt & Whitney Twin Wasp** radial engines, a modest speed, seven men on board.\n\n## Operational career\nThe first combat mission was flown on the night of 23–24 December 1964, in support of a besieged outpost in the Mekong Delta. Fifty-three aircraft were converted; forty-one served in Vietnam and nineteen were lost, twelve of them in combat. The unbroken ribbon of its tracer fire earned it the nickname **Puff the Magic Dragon**. On 24 February 1969 Airman **John L. Levitow**, wounded by forty fragments, threw an armed flare that had fallen into the cabin out of the aircraft, and received the Medal of Honor. Supplemented from 1968 by the AC-119 and then the **AC-130**, the type was handed over to the South Vietnamese, Laotian and Cambodian forces.\n\n## Place in history\nA 1930s airliner, three machine guns and a geometric idea: the AC-47 founded the line of flying gunships. Its successor, the **AC-130 Spectre**, applies exactly the same principle on an entirely different scale. Colombia still operates a descendant, the **AC-47T Fantasma**, built on airframes re-engined with turboprops.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1964-01-01',
    '1964-12-23',
    370.0,
    3500.0,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AC-47 Spooky'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'AC-47 Spooky'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'AC-47 Spooky'), (SELECT id FROM armement WHERE name = 'M134 Minigun'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AC-47 Spooky'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'AC-47 Spooky'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'AC-47 Spooky'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'AC-47 Spooky'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.63,
  wingspan          = 28.96,
  height            = 5.16,
  wing_area         = 91.7,
  empty_weight      = 8201,
  mtow              = 14969,
  service_ceiling   = 7450,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 7,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-1830 Twin Wasp',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 53,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **FC-47** : désignation initiale des premiers C-47 armés, fin 1964\n- **AC-47D** : version de série, trois Minigun **GAU-2/A** de 7,62 mm tirant par le flanc gauche\n- **Armement de transition** : dix mitrailleuses de 7,62 mm classiques sur certains appareils, faute de Minigun en nombre suffisant\n- **AC-47T Fantasma** : version colombienne sur cellule Basler BT-67 à turbopropulseurs\n- Relayé dans l''US Air Force par l''**AC-119G/K**, puis par l''**AC-130**',
  variants_en       = E'- **FC-47** : initial designation of the first armed C-47s, late 1964\n- **AC-47D** : production version, three **GAU-2/A** 7.62 mm Miniguns firing from the left side\n- **Interim armament** : ten conventional 7.62 mm machine guns on some aircraft, Miniguns being in short supply\n- **AC-47T Fantasma** : Colombian version on a turboprop Basler BT-67 airframe\n- Succeeded in US Air Force service by the **AC-119G/K**, then the **AC-130**',

  -- Strate 4 : qualitatif
  nickname          = 'Puff the Magic Dragon',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_AC-47_Spooky',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_AC-47_Spooky',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'AC-47 Spooky';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AC-47 Spooky';
