-- Dassault nEUROn
--
-- Photo : Dassault Neuron.jpg
--   licence CC BY-SA 3.0 — Tangopaso
--   https://commons.wikimedia.org/wiki/File%3ADassault_Neuron_at_Paris_Air_Show_2013_1.jpg

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
    'nEUROn',
    'nEUROn',
    'Dassault nEUROn',
    'Dassault nEUROn',
    'Démonstrateur européen de drone de combat furtif',
    'European stealth combat drone demonstrator',
    '/assets/airplanes/neuron.jpg',
    E'## Genèse\nEn 2003, la France lance un démonstrateur destiné à maintenir en Europe les compétences de conception d''un **avion de combat furtif sans pilote**, alors que les États-Unis avancent seuls sur le sujet. Cinq pays partenaires rejoignent Dassault : Suède, Italie, Espagne, Grèce et Suisse.\n\n## Conception\nAile volante en losange, sans dérive, entièrement en composites. L''entrée d''air est enterrée sur l''extrados et la tuyère masquée : la signature radar et infrarouge est traitée dans toutes les directions. Les armes partent d''une **soute interne**. Le nEUROn est capable de mener une mission complète en autonomie — navigation, détection, identification, demande de tir — sans liaison permanente avec un opérateur.\n\n## Carrière opérationnelle\nIl n''entrera jamais en service : c''est un démonstrateur, pas un prototype de série. Cent vingt-trois vols entre 2012 et 2016, dont des essais de furtivité face à des radars sol et aéroportés, et un largage de bombe guidée depuis la soute.\n\n## Place dans l''histoire\nLe programme a rempli son objectif réel : entretenir un bureau d''études européen capable de dessiner une cellule furtive. Ses résultats alimentent directement le **SCAF / FCAS** franco-germano-espagnol et son volet drones accompagnateurs, attendus pour les années 2040.',
    E'## Genesis\nIn 2003 France launched a demonstrator intended to keep the skills for designing a **stealthy unmanned combat aircraft** alive in Europe, at a time when the United States was advancing alone on the subject. Five partner countries joined Dassault: Sweden, Italy, Spain, Greece and Switzerland.\n\n## Design\nA diamond-shaped flying wing with no fin, entirely in composites. The intake is buried on the upper surface and the exhaust shielded: radar and infrared signatures are treated in every direction. Weapons are released from an **internal bay**. The nEUROn can carry out a complete mission autonomously — navigation, detection, identification, firing request — without a permanent link to an operator.\n\n## Operational career\nIt will never enter service: it is a demonstrator, not a production prototype. One hundred and twenty-three flights between 2012 and 2016, including stealth trials against ground and airborne radars, and a guided bomb release from the internal bay.\n\n## Place in history\nThe programme met its real objective: sustaining a European design office capable of drawing a stealth airframe. Its results feed directly into the Franco-German-Spanish **SCAF / FCAS** and its loyal wingman component, expected in the 2040s.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '2003-01-01',
    '2012-12-01',
    NULL,
    980.0,
    800.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'nEUROn'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'nEUROn'), (SELECT id FROM tech WHERE name = 'Soute à armement pressurisée')),
((SELECT id FROM airplanes WHERE name = 'nEUROn'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'nEUROn'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'nEUROn'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'nEUROn'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'nEUROn'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'nEUROn'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.0,
  wingspan          = 12.5,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = 4900,
  mtow              = 7000,
  service_ceiling   = 14000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce/Turbomeca Adour Mk 951',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 29.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2006,
  production_end    = 2012,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Démonstrateur unique** : un seul exemplaire construit\n- Programme européen mené par **Dassault** avec Saab, Leonardo, Airbus Espagne, HAI et RUAG\n- Campagnes d''essais en France (2012-2015), en Italie (2015) et en Suède (2016)\n\n*Plusieurs caractéristiques restent non publiées : les valeurs manquantes sont laissées vides plutôt qu''estimées.*',
  variants_en       = E'- **Single demonstrator** : only one aircraft built\n- European programme led by **Dassault** with Saab, Leonardo, Airbus Spain, HAI and RUAG\n- Flight test campaigns in France (2012-2015), Italy (2015) and Sweden (2016)\n\n*Several characteristics remain unpublished: missing values are left empty rather than estimated.*',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_nEUROn',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_nEUROn',
  youtube_showcase  = NULL,
  manufacturer_page = 'https://www.dassault-aviation.com/fr/defense/neuron/',
  image_credit      = 'Tangopaso',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'nEUROn';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'nEUROn';
