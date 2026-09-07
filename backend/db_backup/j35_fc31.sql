-- Shenyang J-35 / FC-31 Gyrfalcon
--
-- Photo : FC-31 2.0 prototype at SAC Aviation Expo Park 20260401121535.jpg
--   licence CC BY-SA 4.0 — TurnOnTheNight
--   https://commons.wikimedia.org/wiki/File%3AFC-31_2.0_prototype_at_SAC_Aviation_Expo_Park_20260401121535.jpg

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
    'Shenyang J-35',
    'Shenyang J-35',
    'Shenyang J-35 / FC-31 Gyrfalcon',
    'Shenyang J-35 / FC-31 Gyrfalcon',
    'Chasseur furtif chinois de 5e génération, embarqué et terrestre',
    'Chinese fifth-generation stealth fighter, carrier and land based',
    '/assets/airplanes/j35-fc31.jpg',
    E'## Genèse\nContrairement au J-20, développé sur commande d''État, le FC-31 est né d''une initiative propre de **Shenyang**, financée en partie sur fonds industriels et destinée d''abord à l''export. Le premier démonstrateur vole en 2012, quelques mois seulement après le prototype du J-20 — la Chine mène alors deux programmes furtifs en parallèle.\n\n## Conception\nBimoteur de masse moyenne, entrées d''air sans dérivateur de couche limite, double dérive inclinée, soutes internes : la configuration générale est proche de celle du F-35, pour une cellule plus légère et deux moteurs au lieu d''un. La version navalisée reçoit un train renforcé, des ailes repliables et une crosse d''appontage, en vue des porte-avions **Fujian** et suivants.\n\n## Carrière opérationnelle\nLe programme reste largement opaque. Le J-35A, version terrestre, est présenté publiquement au salon de **Zhuhai en novembre 2024**. La version embarquée a été observée en essais sur porte-avions. Aucune donnée officielle de performance n''a été publiée : les chiffres de cette fiche sont des estimations issues de sources ouvertes.\n\n## Place dans l''histoire\nIl fait de la Chine le deuxième pays à mettre en œuvre **deux** chasseurs furtifs distincts, et le premier hors des États-Unis à disposer d''un appareil furtif embarqué. Le couple J-20 / J-35 reproduit explicitement le tandem américain F-22 / F-35 : un intercepteur lourd de supériorité aérienne et un multirôle plus léger produit en nombre.',
    E'## Genesis\nUnlike the J-20, developed under state contract, the FC-31 began as a **Shenyang** company initiative, partly self-funded and aimed first at export. The first demonstrator flew in 2012, only months after the J-20 prototype — China was running two stealth programmes in parallel.\n\n## Design\nA medium-weight twin-engine design with diverterless supersonic intakes, canted twin tails and internal bays: the general layout is close to the F-35’s, on a lighter airframe with two engines instead of one. The navalised version has strengthened gear, folding wings and an arrestor hook, for the **Fujian** and later carriers.\n\n## Operational career\nThe programme remains largely opaque. The land-based J-35A was shown publicly at the **Zhuhai air show in November 2024**. The carrier version has been observed in shipboard trials. No official performance data has been released: the figures on this page are open-source estimates.\n\n## Place in history\nIt makes China the second country to field **two** distinct stealth fighters, and the first outside the United States to operate a carrier-borne stealth aircraft. The J-20 / J-35 pairing explicitly mirrors the American F-22 / F-35 tandem: a heavy air superiority interceptor and a lighter multirole type built in numbers.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2007-01-01',
    '2012-10-31',
    NULL,
    2200.0,
    3000.0,
    (SELECT id FROM manufacturer WHERE code = 'SAC'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM tech WHERE name = 'Soute à armement pressurisée'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM armement WHERE name = 'PL-10')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM armement WHERE name = 'PL-15')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM armement WHERE name = 'LS-6'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-35'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.3,
  wingspan          = 11.5,
  height            = 4.8,
  wing_area         = 40.0,
  empty_weight      = 17600,
  mtow              = 28000,
  service_ceiling   = 16000,
  climb_rate        = NULL,
  g_limit_pos       = 9.0,
  g_limit_neg       = NULL,
  combat_radius     = 1200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Guizhou WS-13E (WS-19 à terme)',
  engine_count      = 2,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 58.0,
  thrust_wet        = 93.0,

  -- Strate 3 : production & service
  production_start  = 2021,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **FC-31** : démonstrateurs 1.0 (2012) et 2.0 (2016), présentés à l''export\n- **J-35** : version embarquée pour porte-avions, train renforcé et crosse d''appontage\n- **J-35A** : version terrestre de l''armée de l''air, révélée à Zhuhai en 2024\n\n*Les caractéristiques publiées restent des estimations : aucune fiche technique officielle n''a été diffusée.*',
  variants_en       = E'- **FC-31** : 1.0 (2012) and 2.0 (2016) demonstrators, offered for export\n- **J-35** : carrier-borne version with strengthened gear and arrestor hook\n- **J-35A** : land-based air force version, revealed at Zhuhai in 2024\n\n*Published figures remain estimates: no official specification has been released.*',

  -- Strate 4 : qualitatif
  nickname          = 'Gyrfalcon',

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Shenyang_FC-31',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Shenyang_J-35',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'TurnOnTheNight',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Shenyang J-35';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'Shenyang J-35';
