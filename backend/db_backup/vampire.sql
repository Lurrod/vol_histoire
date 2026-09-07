-- de Havilland DH.100 Vampire
--
-- Photo : De Havilland DH115 Vampire banking with the sun reflecting off its silver wings (cropped).jpg
--   licence Public domain — Pseudopanax
--   https://commons.wikimedia.org/wiki/File%3ADe_Havilland_DH115_Vampire_banking_with_the_sun_reflecting_off_its_silver_wings_%28cropped%29.jpg

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
    'de Havilland Vampire',
    'de Havilland Vampire',
    'de Havilland DH.100 Vampire',
    'de Havilland DH.100 Vampire',
    'Deuxième avion à réaction britannique, premier jet de trente forces aériennes',
    'Britain’s second jet, and the first jet of thirty air forces',
    '/assets/airplanes/vampire.jpg',
    E'## Genèse\nLe Goblin de de Havilland est un réacteur centrifuge court et large : impossible à loger dans un fuselage classique sans tuyauterie interminable. La solution est radicale — un **fuselage court en nacelle** avec le réacteur juste derrière le pilote, et l''empennage reporté sur deux poutres.\n\n## Conception\nLa structure emprunte au Mosquito : nacelle en **contreplaqué et balsa**, poutres et ailes métalliques. Ce mélange, hérité d''une industrie de guerre habituée au bois, donne un appareil léger et peu coûteux. Quatre canons de 20 mm dans le nez, et une visibilité excellente.\n\n## Carrière opérationnelle\nLe **3 décembre 1945**, un Sea Vampire apponte sur le HMS Ocean : c''est le premier appontage d''un avion à réaction de l''histoire. Trente et un pays l''adopteront, souvent comme **premier appareil à réaction** : Suède, Suisse, Inde, Australie, Égypte, Rhodésie, Chili. L''Inde l''engage en 1971.\n\n## Place dans l''histoire\nPlus de **3 200 exemplaires** et une diffusion mondiale sans équivalent pour un jet de première génération. Le Vampire a fait entrer dans l''ère de la réaction des forces aériennes qui n''avaient jamais rien construit — un rôle de passeur que reprendront le MiG-15 à l''Est et le T-33 aux États-Unis.',
    E'## Genesis\nDe Havilland’s Goblin was a short, wide centrifugal engine: impossible to fit in a conventional fuselage without endless ducting. The solution was radical — a **short pod fuselage** with the engine directly behind the pilot, and the tail carried on twin booms.\n\n## Design\nThe structure borrowed from the Mosquito: a **plywood and balsa** pod, metal booms and wings. That mixture, inherited from a wartime industry used to wood, produced a light and cheap aircraft. Four 20 mm cannon in the nose, and excellent visibility.\n\n## Operational career\nOn **3 December 1945** a Sea Vampire landed on HMS Ocean: the first carrier landing by a jet in history. Thirty-one countries adopted it, often as their **first jet aircraft**: Sweden, Switzerland, India, Australia, Egypt, Rhodesia, Chile. India committed it in 1971.\n\n## Place in history\nMore than **3,200 built** and a worldwide spread unmatched for a first-generation jet. The Vampire brought into the jet age air forces that had never built anything — a gateway role later played by the MiG-15 in the East and the T-33 in the United States.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1941-01-01',
    '1943-09-20',
    '1946-04-01',
    882.0,
    1960.0,
    (SELECT id FROM manufacturer WHERE code = 'DH'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.37,
  wingspan          = 11.58,
  height            = 2.69,
  wing_area         = 24.34,
  empty_weight      = 3290,
  mtow              = 5606,
  service_ceiling   = 12500,
  climb_rate        = 21,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'de Havilland Goblin 3',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 14.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1961,
  units_built       = 3268,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 31,
  variants          = E'- **Vampire FB.5** : chasseur-bombardier, version la plus produite\n- **Vampire NF.10** : chasseur de nuit biplace à radar\n- **Vampire T.11** : biplace d''entraînement, le plus diffusé à l''export\n- **Sea Vampire** : premier avion à réaction à apponter sur un porte-avions, en 1945\n- **de Havilland Venom** : évolution à aile plus fine et réacteur Ghost',
  variants_en       = E'- **Vampire FB.5** : fighter-bomber, the most produced version\n- **Vampire NF.10** : two-seat radar night fighter\n- **Vampire T.11** : two-seat trainer, the most widely exported\n- **Sea Vampire** : first jet aircraft to land on an aircraft carrier, in 1945\n- **de Havilland Venom** : evolution with a thinner wing and Ghost engine',

  -- Strate 4 : qualitatif
  nickname          = 'Spider Crab',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Vampire',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Vampire',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Pseudopanax',
  image_licence     = 'Public domain'
WHERE name = 'de Havilland Vampire';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'de Havilland Vampire';
