-- Convair F2Y Sea Dart
--
-- Photo : Convair XF2Y-1 Sea Dart taking off c1954.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3AConvair_XF2Y-1_Sea_Dart_taking_off_c1954.jpg

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
    'F2Y Sea Dart',
    'F2Y Sea Dart',
    'Convair F2Y Sea Dart',
    'Convair F2Y Sea Dart',
    'Seul hydravion supersonique de l’histoire, monté sur hydro-skis',
    'The only supersonic seaplane in history, riding on hydro-skis',
    '/assets/airplanes/f2y-sea-dart.jpg',
    E'## Genèse\nÀ la fin des années 1940, un doute sérieux traverse l''aéronavale américaine : les chasseurs à réaction deviennent trop rapides et trop lourds pour les ponts d''envol existants. Si le porte-avions ne suit pas, il faut se passer de lui. D''où l''idée : un chasseur qui **décolle de la mer**, dispensé de catapulte, de brins d''arrêt et de piste.\n\n## Conception\nUne aile delta, deux réacteurs alimentés par des entrées d''air placées **très haut** sur le dos pour échapper aux embruns, et une coque étanche. Le trait de génie est ailleurs : au lieu de flotteurs, deux **hydro-skis** rétractables sortent du ventre au décollage et soulèvent l''appareil au-dessus de l''eau, réduisant la traînée. Les vibrations à l''accélération étaient si violentes que les pilotes ne pouvaient plus lire les instruments.\n\n## Carrière opérationnelle\nAucune. Cinq exemplaires volent depuis la baie de San Diego. Le **3 août 1954**, l''un d''eux franchit Mach 1 en piqué : seul hydravion de l''histoire à y être parvenu. Trois mois plus tard, un YF2Y-1 se désintègre en vol lors d''une démonstration devant la presse et des officiels, tuant son pilote. Le programme ne s''en relèvera pas.\n\n## Place dans l''histoire\nCinq exemplaires. Sa disparition tient moins à l''accident qu''à une évolution parallèle : la **catapulte à vapeur** britannique et le pont oblique, adoptés au même moment, ont permis aux porte-avions d''absorber les chasseurs supersoniques. Le problème que le Sea Dart devait résoudre avait cessé d''exister.',
    E'## Genesis\nBy the late 1940s a serious doubt ran through American naval aviation: jet fighters were becoming too fast and too heavy for existing flight decks. If the carrier could not keep up, it would have to be done without. Hence the idea: a fighter that **takes off from the sea**, needing no catapult, no arrestor wires and no runway.\n\n## Design\nA delta wing, two engines fed by intakes set **high** on the spine to escape the spray, and a watertight hull. The stroke of genius lies elsewhere: instead of floats, two retractable **hydro-skis** extend from the belly on take-off and lift the aircraft clear of the water, cutting drag. The vibration during acceleration was so violent that pilots could no longer read their instruments.\n\n## Operational career\nNone. Five aircraft flew from San Diego Bay. On **3 August 1954** one passed Mach 1 in a dive: the only seaplane in history to do so. Three months later a YF2Y-1 disintegrated in flight during a demonstration before the press and officials, killing its pilot. The programme never recovered.\n\n## Place in history\nFive built. Its disappearance owes less to the accident than to a parallel development: the British **steam catapult** and the angled deck, adopted at the same moment, let carriers absorb supersonic fighters after all. The problem the Sea Dart was meant to solve had ceased to exist.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1948-01-01',
    '1953-04-09',
    NULL,
    1325.0,
    1330.0,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F2Y Sea Dart'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'F2Y Sea Dart'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F2Y Sea Dart'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F2Y Sea Dart'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.6,
  wingspan          = 10.26,
  height            = 4.9,
  wing_area         = 52.3,
  empty_weight      = 5730,
  mtow              = 9752,
  service_ceiling   = 16700,
  climb_rate        = 87.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse J46-WE-2',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 27.6,
  thrust_wet        = 42.3,

  -- Strate 3 : production & service
  production_start  = 1952,
  production_end    = 1955,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XF2Y-1** : prototype, hydro-ski unique puis double\n- **YF2Y-1** : version de présérie à réacteurs J46, quatre exemplaires\n- Franchit **Mach 1 en piqué le 3 août 1954** — seul hydravion à y être parvenu\n- Un YF2Y-1 se désintègre en vol le 4 novembre 1954 devant la presse, pilote tué\n- Programme abandonné en 1957 : les porte-avions à catapulte vapeur avaient tranché',
  variants_en       = E'- **XF2Y-1** : prototype, first with a single then a twin hydro-ski\n- **YF2Y-1** : pre-production version with J46 engines, four built\n- Passed **Mach 1 in a dive on 3 August 1954** — the only seaplane ever to do so\n- A YF2Y-1 disintegrated in flight on 4 November 1954 before the press, killing the pilot\n- Programme abandoned in 1957: steam-catapult carriers had settled the question',

  -- Strate 4 : qualitatif
  nickname          = 'Sea Dart',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_F2Y_Sea_Dart',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_F2Y_Sea_Dart',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'F2Y Sea Dart';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F2Y Sea Dart';
