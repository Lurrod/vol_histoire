-- Ikarus S-49C
--
-- Photo : BAM-46-Ikarus S-49C.jpg
--   licence CC BY 3.0 — Belgrade Aviation Museum Photo Archive
--   https://commons.wikimedia.org/wiki/File:BAM-46-Ikarus_S-49C.jpg

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
    'Ikarus S-49',
    'Ikarus S-49',
    'Ikarus S-49C',
    'Ikarus S-49C',
    'Chasseur à hélice conçu en urgence par la Yougoslavie après la rupture entre Tito et Staline',
    'Piston-engined fighter designed in haste by Yugoslavia after the split between Tito and Stalin',
    '/assets/airplanes/ikarus-s49.jpg',
    E'## Genèse\nEn 1948, la résolution du Kominform consacre la **rupture entre Tito et Staline**. L''aviation yougoslave, équipée pour l''essentiel d''avions soviétiques, ne peut plus obtenir ni appareils neufs ni pièces de rechange. Elle se tourne vers sa propre industrie. Les ingénieurs **Kosta Sivčev**, **Slobodan Zrnić** et **Svetozar Popović**, dont les deux premiers avaient conçu avant la guerre le chasseur **Rogožarski IK-3**, reprennent la documentation technique de cet appareil pour dessiner un nouveau chasseur. Le premier prototype du **S-49A** vole en juin 1949, et les premiers avions rejoignent les unités de combat au début de 1950.\n\n## Conception\nLe S-49A, de construction mixte, est propulsé par le moteur soviétique **Klimov VK-105**, que la rupture rend lui aussi introuvable. Une nouvelle version, le **S-49C**, reçoit donc un moteur français proche, le **Hispano-Suiza 12Z-17** de 1 480 ch. Plus gros et plus lourd, il impose une construction entièrement métallique et un nez nettement allongé. L''usine **Ikarus** de Zemun assemble l''avion, tandis que les ailes et l''empennage viennent de **SOKO**, à Mostar. L''armement ne change pas : un canon allemand **MG 151/20** de 20 mm tirant à travers le moyeu de l''hélice, deux mitrailleuses Browning de 12,7 mm, et sous les ailes deux bombes de 50 kg ou quatre roquettes de 127 mm.\n\n## Carrière opérationnelle\nLe S-49C entre dans les unités de l''aviation yougoslave au début de 1952. Au total, 45 S-49A et 113 S-49C sont produits. Ils équipent huit régiments de chasse et deux escadrilles d''entraînement : le S-49A sert de 1950 à 1957, le S-49C de 1952 à 1961. Les derniers sont retirés en 1960-1961, remplacés par des avions à réaction plus modernes. Les deux versions sont aujourd''hui exposées au musée de l''Aviation de Belgrade.\n\n## Place dans l''histoire\nLe S-49 est un chasseur de transition, né d''une urgence politique plus que technique : quand l''Europe passe au réacteur, la Yougoslavie doit encore construire seule un avion à hélice. Il prolonge une lignée d''avant-guerre et prouve la capacité du pays à concevoir et produire ses propres avions de combat. Et c''est **SOKO**, qui en fabriquait les ailes, qui produira ensuite les **G-2 Galeb**, **J-21 Jastreb** et **J-22 Orao**.',
    E'## Genesis\nIn 1948 the Cominform resolution sealed the **split between Tito and Stalin**. The Yugoslav Air Force, equipped mostly with Soviet aircraft, could no longer obtain new aircraft or spare parts. It turned to its own industry. The engineers **Kosta Sivčev**, **Slobodan Zrnić** and **Svetozar Popović**, the first two of whom had designed the **Rogožarski IK-3** fighter before the war, took the technical documentation of that aircraft to design a new fighter. The first prototype **S-49A** flew in June 1949, and the first aircraft reached combat units at the beginning of 1950.\n\n## Design\nThe S-49A, of mixed construction, was powered by the Soviet **Klimov VK-105** engine, which the split also made unobtainable. A new version, the **S-49C**, therefore received a similar French engine, the 1,480 hp **Hispano-Suiza 12Z-17**. Bigger and heavier, it required all-metal construction and a much longer nose. The **Ikarus** factory in Zemun assembled the aircraft, while the wings and tail came from **SOKO** in Mostar. The armament was unchanged: a German 20 mm **MG 151/20** cannon firing through the propeller hub, two 12.7 mm Browning machine guns, and under the wings two 50 kg bombs or four 127 mm rockets.\n\n## Operational career\nThe S-49C entered Yugoslav Air Force units at the beginning of 1952. In all, 45 S-49As and 113 S-49Cs were produced. They equipped eight fighter regiments and two training squadrons: the S-49A served from 1950 to 1957, the S-49C from 1952 to 1961. The last were retired in 1960-1961, replaced by more modern jet aircraft. Both versions are now on display at the Museum of Aviation in Belgrade.\n\n## Place in history\nThe S-49 was a transitional fighter, born of a political rather than a technical emergency: as Europe moved to the jet, Yugoslavia still had to build a propeller-driven aircraft on its own. It extended a pre-war lineage and proved the country''s ability to design and produce its own combat aircraft. And it was **SOKO**, which built its wings, that would go on to produce the **G-2 Galeb**, **J-21 Jastreb** and **J-22 Orao**.',
    (SELECT id FROM countries WHERE code = 'YUG'),
    '1948-01-01',
    '1949-06-01',
    '1950-01-01',
    628,
    690,
    (SELECT id FROM manufacturer WHERE code = 'IKA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Ikarus S-49'), (SELECT id FROM armement WHERE name = 'MG 151/20'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Ikarus S-49'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Ikarus S-49'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.06,
  wingspan          = 10.3,
  height            = 2.9,
  wing_area         = 16.65,
  empty_weight      = 2818,
  mtow              = 3568,
  service_ceiling   = 10000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Hispano-Suiza 12Z-17 (1 480 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en V',
  engine_type_en    = 'V engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = NULL,
  units_built       = 158,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **S-49A** : construction mixte et moteur soviétique Klimov VK-105, 45 exemplaires\n- **S-49B** : version prévue avec un moteur Daimler-Benz, jamais construite\n- **S-49C** : construction entièrement métallique et moteur Hispano-Suiza 12Z-17, 113 exemplaires',
  variants_en       = E'- **S-49A**: mixed construction and Soviet Klimov VK-105 engine, 45 built\n- **S-49B**: planned version with a Daimler-Benz engine, never built\n- **S-49C**: all-metal construction and Hispano-Suiza 12Z-17 engine, 113 built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ikarus_S-49',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Belgrade Aviation Museum Photo Archive',
  image_licence     = 'CC BY 3.0'
WHERE name = 'Ikarus S-49';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Ikarus S-49';
