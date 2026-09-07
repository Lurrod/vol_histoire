-- Embraer EMB-110 Bandeirante (C-95)
--
-- Photo : FAU580.jpg
--   licence CC BY 2.0 — Sebastián Laguna
--   https://commons.wikimedia.org/wiki/File%3AFAU580.jpg

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
    'Embraer EMB-110 Bandeirante',
    'Embraer EMB-110 Bandeirante',
    'Embraer EMB-110 Bandeirante (C-95)',
    'Embraer EMB-110 Bandeirante (C-95)',
    'L’appareil qui a fondé Embraer, et avec lui l’industrie brésilienne',
    'The aircraft that founded Embraer, and with it Brazilian industry',
    '/assets/airplanes/bandeirante.jpg',
    E'## Genèse\nLe Brésil des années 1960 est un pays continent aux liaisons intérieures difficiles, et sans industrie aéronautique. L''ingénieur français **Max Holste**, installé à São José dos Campos, dessine à la demande du ministère de l''Air un bimoteur léger capable de relier les villes de l''intérieur. Le premier vol a lieu en 1968 ; la société **Embraer** est créée l''année suivante **pour le produire**.\n\n## Conception\nQuinze mètres de long, six tonnes, deux **PT6** canadiens, un fuselage non pressurisé et une aile basse. Rien d''ambitieux : l''appareil doit être robuste, simple à entretenir loin de tout, et capable d''emporter vingt et une personnes sur des pistes courtes. C''est exactement le cahier des charges d''un pays qui construit son premier avion.\n\n## Carrière opérationnelle\nCinq cent un exemplaires, vingt pays. Sous le nom de **C-95**, il assure le transport léger de la force aérienne brésilienne pendant plus de cinquante ans ; ses versions P-95 et R-95 surveillent le littoral et photographient. Il est aussi vendu aux compagnies régionales américaines et européennes, première exportation aéronautique brésilienne.\n\n## Place dans l''histoire\nCinq cent un exemplaires. Le Bandeirante n''a pas seulement lancé Embraer : il a démontré qu''un pays sans tradition aéronautique pouvait produire et **exporter** un appareil complet. Cinquante ans plus tard, Embraer est le troisième avionneur mondial et ce catalogue compte cinq de ses appareils.',
    E'## Genesis\nBrazil in the 1960s was a continental country with difficult internal links and no aircraft industry. The French engineer **Max Holste**, based at São José dos Campos, drew at the Air Ministry''s request a light twin able to connect the towns of the interior. It first flew in 1968; the company **Embraer** was created the following year **to build it**.\n\n## Design\nFifteen metres long, six tonnes, two Canadian **PT6s**, an unpressurised fuselage and a low wing. Nothing ambitious: the aircraft had to be rugged, simple to maintain far from anywhere, and able to carry twenty-one people from short strips. That is exactly the requirement of a country building its first aircraft.\n\n## Operational career\nFive hundred and one built, twenty countries. As the **C-95** it has flown light transport for the Brazilian air force for more than fifty years; its P-95 and R-95 versions watch the coast and take photographs. It was also sold to American and European regional airlines, Brazil''s first aeronautical export.\n\n## Place in history\nFive hundred and one built. The Bandeirante did not merely launch Embraer: it proved that a country with no aeronautical tradition could build and **export** a complete aircraft. Fifty years later Embraer is the world''s third airframer and this catalogue holds five of its aircraft.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1965-01-01',
    '1968-10-26',
    '1973-02-09',
    417.0,
    1900.0,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-110 Bandeirante'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-110 Bandeirante'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-110 Bandeirante'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.1,
  wingspan          = 15.33,
  height            = 4.92,
  wing_area         = 29.1,
  empty_weight      = 3590,
  mtow              = 5900,
  service_ceiling   = 6860,
  climb_rate        = 8.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 800,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-34',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1968,
  production_end    = 1990,
  units_built       = 501,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 20,
  variants          = E'- **C-95** : désignation militaire brésilienne, transport léger et liaison\n- **P-95 Bandeirulha** : version de patrouille maritime à radar de nez\n- **R-95** : version de reconnaissance photographique\n- *Bandeirante* désigne les **explorateurs** qui ouvrirent l''intérieur du Brésil\n- Premier appareil d''Embraer, société créée **en 1969 pour le produire**',
  variants_en       = E'- **C-95** : Brazilian military designation, light transport and liaison\n- **P-95 Bandeirulha** : maritime patrol version with a nose radar\n- **R-95** : photographic reconnaissance version\n- *Bandeirante* refers to the **explorers** who opened Brazil''s interior\n- Embraer''s first aircraft; the company was created **in 1969 to build it**',

  -- Strate 4 : qualitatif
  nickname          = 'Bandeirante',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Embraer_EMB_110_Bandeirante',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Embraer_EMB_110_Bandeirante',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Sebastián Laguna',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Embraer EMB-110 Bandeirante';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Embraer EMB-110 Bandeirante';
