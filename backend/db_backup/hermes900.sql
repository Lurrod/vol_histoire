-- Elbit Systems Hermes 900 Kochav
--
-- Photo : Hermes 900 at Paris Air Show 2013 1.jpg
--   licence CC BY-SA 3.0 — Tangopaso
--   https://commons.wikimedia.org/wiki/File%3AHermes_900_at_Paris_Air_Show_2013_1.jpg

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
    'Elbit Hermes 900',
    'Elbit Hermes 900',
    'Elbit Systems Hermes 900 Kochav',
    'Elbit Systems Hermes 900 Kochav',
    'Trente-six heures de vol, adopté par une vingtaine de pays',
    'Thirty-six hours aloft, adopted by some twenty countries',
    '/assets/airplanes/hermes900.jpg',
    E'## Genèse\nIsraël exploite des drones depuis les années 1970 et en a fait une industrie d''exportation. Le **Hermes 450** d''Elbit est un succès mondial mais plafonne en charge utile : impossible d''emporter à la fois un radar, des caméras et des capteurs électroniques. Le Hermes 900 est sa version agrandie, conçue pour tout emporter à la fois.\n\n## Conception\nQuinze mètres d''envergure pour une tonne deux, un moteur Rotax et une hélice propulsive : l''architecture est celle du **Predator** en plus petit. La différence tient au **décollage et à l''atterrissage automatiques**, qui suppriment le besoin d''un opérateur qualifié sur le terrain, et à une charge utile modulaire de trois cents kilogrammes.\n\n## Carrière opérationnelle\nUne vingtaine de forces armées : Israël, Suisse, Brésil, Chili, Mexique, Philippines, Thaïlande, Islande, Canada. Sa version **StarLiner** est la première à obtenir une certification permettant de voler dans l''espace aérien civil européen, ce qui lui ouvre les missions de garde-côtes et de secours.\n\n## Place dans l''histoire\nLe Hermes 900 illustre la spécialisation israélienne : plutôt que de concurrencer le Reaper américain sur la frappe, Elbit vend de l''**endurance et du capteur** à des pays qui n''ont ni le budget ni le besoin d''un drone armé. C''est aujourd''hui le drone de surveillance le plus exporté au monde.',
    E'## Genesis\nIsrael has flown drones since the 1970s and has made an export industry of them. Elbit''s **Hermes 450** is a worldwide success but limited in payload: it cannot carry radar, cameras and electronic sensors at once. The Hermes 900 is its enlarged version, designed to carry everything simultaneously.\n\n## Design\nFifteen metres of span for one point two tonnes, a Rotax engine and a pusher propeller: the architecture is the **Predator''s** on a smaller scale. The difference lies in **automatic take-off and landing**, which removes the need for a skilled operator in the field, and in a modular three-hundred-kilogramme payload.\n\n## Operational career\nSome twenty armed forces: Israel, Switzerland, Brazil, Chile, Mexico, the Philippines, Thailand, Iceland, Canada. Its **StarLiner** version was the first to obtain certification allowing flight in European civil airspace, opening coastguard and rescue missions to it.\n\n## Place in history\nThe Hermes 900 illustrates the Israeli speciality: rather than compete with the American Reaper on strike, Elbit sells **endurance and sensors** to countries with neither the budget nor the need for an armed drone. It is today the most exported surveillance drone in the world.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '2009-01-01',
    '2009-12-09',
    '2014-07-01',
    220.0,
    1000.0,
    (SELECT id FROM manufacturer WHERE code = 'ELB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 900'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 900'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 900'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.3,
  wingspan          = 15.0,
  height            = 2.3,
  wing_area         = 13.0,
  empty_weight      = 700,
  mtow              = 1180,
  service_ceiling   = 9100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 250,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rotax 914F',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2012,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 20,
  variants          = E'- **Hermes 900** : version d''origine, dérivée du **Hermes 450** plus léger\n- **Hermes 900 StarLiner** : version certifiée pour l''**espace aérien civil** européen\n- **Hermes 900 Maritime Patrol** : version de surveillance côtière, à radar ventral\n- *Kochav* signifie « **étoile** » en hébreu\n- Endurance de **trente-six heures**, décollage et atterrissage entièrement automatiques',
  variants_en       = E'- **Hermes 900** : original version, derived from the lighter **Hermes 450**\n- **Hermes 900 StarLiner** : version certified for European **civil airspace**\n- **Hermes 900 Maritime Patrol** : coastal surveillance version with a belly radar\n- *Kochav* means ''**star**'' in Hebrew\n- **Thirty-six hour** endurance, with fully automatic take-off and landing',

  -- Strate 4 : qualitatif
  nickname          = 'Kochav',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Elbit_Hermes_900',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Elbit_Hermes_900',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Tangopaso',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Elbit Hermes 900';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Elbit Hermes 900';
