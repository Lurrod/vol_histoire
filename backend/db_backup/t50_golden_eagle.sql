-- Korea Aerospace Industries T-50 Golden Eagle
--
-- Photo : Philippine Air Force FA-50PH.jpg
--   licence Public domain — Senior Airman Mitchell Corley
--   https://commons.wikimedia.org/wiki/File%3APhilippine_Air_Force_FA-50PH.jpg

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
    'KAI T-50 Golden Eagle',
    'KAI T-50 Golden Eagle',
    'Korea Aerospace Industries T-50 Golden Eagle',
    'Korea Aerospace Industries T-50 Golden Eagle',
    'Premier avion supersonique conçu en Corée du Sud',
    'First supersonic aircraft designed in South Korea',
    '/assets/airplanes/t50-golden-eagle.jpg',
    E'## Genèse\nLa Corée du Sud avait assemblé des F-16 sous licence dans les années 1980 ; elle voulait concevoir. Le programme **KTX-2**, lancé en 1992 avec Lockheed Martin comme partenaire technique, vise un entraîneur supersonique national. Les crises budgétaires successives repoussent le premier vol à 2002, dix ans après le lancement.\n\n## Conception\nLa parenté avec le F-16 est assumée : entrée d''air ventrale, aile trapézoïdale à emplantures prolongées, commandes de vol entièrement électriques, réacteur F404. Le T-50 est **supersonique**, ce qui le distingue de tous ses concurrents européens — Hawk, M-346, Alpha Jet — et lui permet de couvrir la formation jusqu''au seuil du chasseur opérationnel.\n\n## Carrière opérationnelle\nDeux cent cinquante appareils livrés. Les Philippines engagent leurs **FA-50** au combat contre les insurgés de Marawi en 2017 ; la Pologne en commande 48 en 2022 pour combler le retrait de ses MiG-29 cédés à l''Ukraine. L''Irak, l''Indonésie, la Thaïlande et la Malaisie l''ont également adopté.\n\n## Place dans l''histoire\nLe T-50 fait entrer la Corée du Sud dans le cercle très restreint des pays capables de concevoir un avion de combat supersonique. Il fonde l''expérience industrielle qui donnera, vingt ans plus tard, le **KF-21 Boramae**.',
    E'## Genesis\nSouth Korea had assembled F-16s under licence in the 1980s; it wanted to design. The **KTX-2** programme, launched in 1992 with Lockheed Martin as technical partner, aimed at a national supersonic trainer. Successive budget crises pushed the first flight to 2002, ten years after launch.\n\n## Design\nThe F-16 kinship is openly acknowledged: ventral intake, trapezoidal wing with extended root leading edges, full fly-by-wire controls, F404 engine. The T-50 is **supersonic**, which sets it apart from all its European competitors — Hawk, M-346, Alpha Jet — and lets it cover training right up to the operational fighter threshold.\n\n## Operational career\nTwo hundred and fifty delivered. The Philippines committed their **FA-50s** against the Marawi insurgents in 2017; Poland ordered 48 in 2022 to cover the withdrawal of its MiG-29s handed to Ukraine. Iraq, Indonesia, Thailand and Malaysia have also adopted it.\n\n## Place in history\nThe T-50 brought South Korea into the very small circle of countries able to design a supersonic combat aircraft. It built the industrial experience that would produce, twenty years later, the **KF-21 Boramae**.',
    (SELECT id FROM countries WHERE code = 'ROK'),
    '1992-01-01',
    '2002-08-20',
    '2005-02-22',
    1837.0,
    2592.0,
    (SELECT id FROM manufacturer WHERE code = 'KAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric F404')),
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM armement WHERE name = 'GBU-38 JDAM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.14,
  wingspan          = 9.45,
  height            = 4.94,
  wing_area         = 23.69,
  empty_weight      = 6470,
  mtow              = 12300,
  service_ceiling   = 14630,
  climb_rate        = 198,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = 1000,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F404-GE-102',
  engine_count      = 1,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 53.0,
  thrust_wet        = 78.7,

  -- Strate 3 : production & service
  production_start  = 2003,
  production_end    = NULL,
  units_built       = 250,
  unit_cost_usd     = 30000000,
  unit_cost_year    = 2020,
  operators_count   = 6,
  variants          = E'- **T-50** : entraîneur avancé de base\n- **TA-50** : version d''entraînement au combat, canon et missiles\n- **FA-50 Fighting Eagle** : chasseur léger à radar, exporté aux Philippines et en Pologne\n- **T-50B** : monture de la patrouille acrobatique **Black Eagles**',
  variants_en       = E'- **T-50** : baseline advanced trainer\n- **TA-50** : lead-in fighter training version with gun and missiles\n- **FA-50 Fighting Eagle** : radar-equipped light fighter, exported to the Philippines and Poland\n- **T-50B** : mount of the **Black Eagles** display team',

  -- Strate 4 : qualitatif
  nickname          = 'Golden Eagle',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/KAI_T-50_Golden_Eagle',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/KAI_T-50_Golden_Eagle',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Senior Airman Mitchell Corley',
  image_licence     = 'Public domain'
WHERE name = 'KAI T-50 Golden Eagle';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'KAI T-50 Golden Eagle';
