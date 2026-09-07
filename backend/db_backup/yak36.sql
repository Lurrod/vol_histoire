-- Yakovlev Yak-36 (Freehand)
--
-- Photo : Yakovlev Yak-36 Freehand.jpg
--   licence CC BY 2.0 — Maarten
--   https://commons.wikimedia.org/wiki/File%3AYakovlev_Yak-36_Freehand.jpg

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
    'Yak-36',
    'Yak-36',
    'Yakovlev Yak-36 (Freehand)',
    'Yakovlev Yak-36 (Freehand)',
    'Le banc d’essai volant qui a donné à l’URSS son aviation embarquée',
    'The flying testbed that gave the USSR its carrier aviation',
    '/assets/airplanes/yak36.jpg',
    E'## Genèse\nL''Union soviétique n''a pas de porte-avions à catapulte et n''en aura pas avant longtemps. Elle a en revanche des croiseurs porte-aéronefs en projet. Un appareil capable de décoller verticalement réglerait le problème d''un coup. En 1960, le bureau **Yakovlev** est chargé de savoir si c''est possible — pas de construire un chasseur, seulement de comprendre.\n\n## Conception\nDeux réacteurs sont installés côte à côte dans le nez, leurs gaz évacués par des **tuyères orientables communes** placées sous le centre de gravité. Comme sur le Short SC.1, les gouvernes sont inutiles à vitesse nulle : l''appareil est stabilisé par des jets d''air comprimé, dont le plus visible est monté à l''extrémité d''une **perche de nez** longue de plusieurs mètres, la signature visuelle du type.\n\n## Carrière opérationnelle\nAucune. Quatre cellules, deux volantes, un rayon d''action ridicule — trois cent soixante-dix kilomètres — et aucune capacité d''emport. En juillet **1967**, deux Yak-36 exécutent une démonstration de vol stationnaire au meeting de Domodedovo devant la presse occidentale, qui conclut à tort que l''URSS dispose d''un chasseur ADAV opérationnel.\n\n## Place dans l''histoire\nQuatre exemplaires, aucun emploi. Mais contrairement aux programmes allemands, celui-ci a une suite : le **Yak-38** en dérive directement et équipe les quatre porte-aéronefs de classe Kiev à partir de 1976. L''URSS est ainsi le deuxième — et dernier — pays à mettre en service un appareil de combat à décollage vertical.',
    E'## Genesis\nThe Soviet Union had no catapult carriers and would not have any for a long time. It did have aviation cruisers on the drawing board. An aircraft that could take off vertically would settle the matter at a stroke. In 1960 the **Yakovlev** bureau was tasked with finding out whether it was possible — not with building a fighter, only with understanding.\n\n## Design\nTwo engines sit side by side in the nose, their gas exhausted through **common swivelling nozzles** placed under the centre of gravity. As on the Short SC.1, control surfaces are useless at zero airspeed: the aircraft is stabilised by compressed-air jets, the most visible of which is mounted at the end of a **nose boom** several metres long, the type''s visual signature.\n\n## Operational career\nNone. Four airframes, two flying, a derisory range — three hundred and seventy kilometres — and no payload capability. In July **1967** two Yak-36s gave a hovering demonstration at the Domodedovo display before the Western press, which wrongly concluded that the USSR had an operational VTOL fighter.\n\n## Place in history\nFour built, no service use. But unlike the German programmes, this one had a sequel: the **Yak-38** derived directly from it and equipped the four Kiev-class aviation cruisers from 1976. The USSR thus became the second — and last — country to field a vertical take-off combat aircraft.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1960-01-01',
    '1963-01-09',
    NULL,
    1009.0,
    370.0,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-36'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'Yak-36'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-36'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-36'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.0,
  wingspan          = 7.0,
  height            = 4.3,
  wing_area         = 17.0,
  empty_weight      = 5400,
  mtow              = 9400,
  service_ceiling   = 12000,
  climb_rate        = 45.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 180,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Tumansky R-27-300',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à tuyère orientable',
  engine_type_en    = 'Swivelling-nozzle turbojet',
  thrust_dry        = 51.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1962,
  production_end    = 1966,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Yak-36** : quatre exemplaires, dont deux seulement ont volé en stationnaire\n- **Deux réacteurs** côte à côte dans le nez, tuyères communes sous le centre de gravité\n- Longue **perche de nez** portant un jet d''air comprimé de contrôle en tangage\n- Présenté au public au meeting de **Domodedovo en 1967**, choc pour les observateurs\n- Débouche sur le **Yak-38**, seul ADAV soviétique à entrer en service',
  variants_en       = E'- **Yak-36** : four aircraft, only two of which ever hovered\n- **Two engines** side by side in the nose, common nozzles under the centre of gravity\n- A long **nose boom** carrying a compressed-air pitch control jet\n- Shown publicly at the **1967 Domodedovo display**, a shock to Western observers\n- Led to the **Yak-38**, the only Soviet VTOL to enter service',

  -- Strate 4 : qualitatif
  nickname          = 'Freehand',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-36',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-36',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Maarten',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Yak-36';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-36';
