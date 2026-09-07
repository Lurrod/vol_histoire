-- Hawker Hunter
--
-- Photo : Hunter - Shuttleworth Military Pageant June 2013 (9187713516).jpg
--   licence CC BY-SA 2.0 — Tim Felce (Airwolfhound)
--   https://commons.wikimedia.org/wiki/File%3AHunter_-_Shuttleworth_Military_Pageant_June_2013_%289187713516%29.jpg

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
    'Hawker Hunter',
    'Hawker Hunter',
    'Hawker Hunter',
    'Hawker Hunter',
    'Chasseur britannique le plus exporté, vingt et un pays utilisateurs',
    'Most-exported British fighter, twenty-one operator countries',
    '/assets/airplanes/hawker-hunter.jpg',
    E'## Genèse\nSydney Camm, qui avait dessiné le Hurricane, livre avec le Hunter le premier chasseur britannique réellement moderne de l''après-guerre : aile en flèche, réacteur puissant, et une élégance de lignes qui en fera l''un des avions les plus admirés de son temps.\n\n## Conception\nAile à 35° de flèche, Avon unique, et un armement concentré : **quatre canons ADEN de 30 mm** logés dans un pack ventral amovible qu''on remplace en quelques minutes, munitions comprises. Les premiers tirs révèlent un défaut spectaculaire — les gaz des canons éteignent le réacteur en altitude — corrigé par des déflecteurs.\n\n## Carrière opérationnelle\nPrès de **2 000 exemplaires** et vingt et un pays. L''Inde l''engage massivement contre le Pakistan en 1965 et 1971 ; la Suisse le conserve jusqu''en 1994 ; le Liban, le Chili, la Rhodésie, Singapour et l''Irak l''utilisent au combat. Le 22 novembre 1963, un Hunter suisse est le premier appareil à se poser sur un glacier — anecdote parmi d''autres d''une carrière exceptionnellement longue.\n\n## Place dans l''histoire\nLe Hunter est le dernier grand succès commercial de l''aviation de chasse britannique avant les programmes en coopération. Sa cellule, jugée agréable à piloter par des générations d''équipages, vole encore aujourd''hui en collection et comme plastron privé.',
    E'## Genesis\nSydney Camm, who had designed the Hurricane, delivered in the Hunter the first genuinely modern post-war British fighter: swept wing, powerful engine, and a purity of line that made it one of the most admired aircraft of its time.\n\n## Design\nA 35° swept wing, a single Avon, and concentrated armament: **four 30 mm ADEN cannon** in a removable ventral pack that can be swapped in minutes, ammunition included. Early firing trials revealed a spectacular flaw — gun gas extinguished the engine at altitude — cured with deflectors.\n\n## Operational career\nNearly **2,000 built** and twenty-one countries. India used it heavily against Pakistan in 1965 and 1971; Switzerland kept it until 1994; Lebanon, Chile, Rhodesia, Singapore and Iraq flew it in combat. On 22 November 1963 a Swiss Hunter became the first aircraft to land on a glacier — one anecdote among many from an exceptionally long career.\n\n## Place in history\nThe Hunter was the last great commercial success of British fighter aviation before the era of collaborative programmes. Its airframe, judged a delight to fly by generations of crews, still flies today in private collections and as a contract aggressor.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1946-01-01',
    '1951-07-20',
    '1954-07-01',
    1150.0,
    3060.0,
    (SELECT id FROM manufacturer WHERE code = 'HS'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Avon'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971')),
((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'), (SELECT id FROM wars WHERE name = 'Guerre du Liban'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.98,
  wingspan          = 10.26,
  height            = 4.01,
  wing_area         = 32.42,
  empty_weight      = 6405,
  mtow              = 11158,
  service_ceiling   = 15240,
  climb_rate        = 87,
  g_limit_pos       = 7.5,
  g_limit_neg       = NULL,
  combat_radius     = 715,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Avon 207',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 45.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1966,
  units_built       = 1972,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 21,
  variants          = E'- **F.6** : version de chasse définitive de la RAF\n- **FGA.9** : version d''appui au sol, la plus exportée\n- **FR.10** : reconnaissance tactique\n- **T.7 / T.8** : biplaces côte à côte d''entraînement',
  variants_en       = E'- **F.6** : definitive RAF fighter version\n- **FGA.9** : ground attack version, the most exported\n- **FR.10** : tactical reconnaissance\n- **T.7 / T.8** : side-by-side two-seat trainers',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hawker_Hunter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hawker_Hunter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Tim Felce (Airwolfhound)',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Hawker Hunter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Hawker Hunter';
