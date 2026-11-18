-- Pilatus P-3
--
-- Photo : Pilatus P-3-05 (c-n 493-42, HB-RBX) 2024-09-13 Andre Gerwing Collection ID 022245.jpg
--   licence CC BY-SA 4.0 — André Gerwing
--   https://commons.wikimedia.org/wiki/File:Pilatus_P-3-05_(c-n_493-42,_HB-RBX)_2024-09-13_Andre_Gerwing_Collection_ID_022245.jpg

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
    'Pilatus P-3',
    'Pilatus P-3',
    'Pilatus P-3',
    'Pilatus P-3',
    'Le biplace d''école des pilotes suisses de l''ère du jet, et l''ancêtre direct de la lignée des PC-7, PC-9 et PC-21',
    'The two-seat school aircraft of Swiss pilots in the jet age, and the direct ancestor of the PC-7, PC-9 and PC-21 line',
    '/assets/airplanes/pilatus-p3.jpg',
    E'## Genèse\nAu début des années 1950, l''aviation militaire suisse entre dans l''ère du jet, et ses écoles doivent suivre. En 1952, **Pilatus** lance l''étude d''un avion capable de former les futurs pilotes de réacteurs, de l''instruction élémentaire jusqu''au vol de nuit, à la voltige et au vol aux instruments. Le premier prototype, le **P-3.01**, vole le 3 septembre 1953 aux mains de **Georg Gyssler**, avec une hélice bipale. Son moteur se révèle trop faible, et un second prototype, militaire celui-là, prend l''air en août 1954 avec une autre motorisation et une hélice tripale.\n\n## Conception\nLe P-3 est un monoplan entièrement métallique, à train tricycle escamotable, où l''élève et l''instructeur sont assis en tandem. Un six-cylindres à plat Lycoming de 260 ch lui donne 310 km/h et 750 km d''autonomie, pour une masse maximale d''une tonne et demie. Des lance-bombes d''exercice ou des roquettes peuvent se fixer sous les ailes, avec une mitrailleuse en nacelle sous l''aile gauche : ces équipements sont achetés, mais jamais employés. Lors de l''évaluation, le prototype affronte un **T-34 Mentor** amené en Suisse, et son pilote d''essai exécute un « huit » vertical qu''il sait hors de portée de l''avion américain.\n\n## Carrière opérationnelle\nLes Troupes d''aviation suisses reçoivent d''abord une présérie de 12 **P-3.03**, puis 60 **P-3.05**, et l''avion entre en service en 1956. Six exemplaires construits sous immatriculation civile, les P-3.04, sont ensuite rachetés par la **Marine brésilienne** : le P-3 devient ainsi le premier avion Pilatus exporté. Après deux accidents provoqués par une vrille à plat, un appareil d''essai reçoit une dérive ventrale, installée ensuite sur toute la flotte. Le P-3 forme les pilotes suisses jusqu''en 1983, puis sert d''avion de liaison pendant encore une décennie, avant la vente de 65 appareils à des particuliers entre 1993 et 1995.\n\n## Place dans l''histoire\nConstruit à 80 exemplaires, le P-3 compte peu par le nombre, mais il fonde une lignée. Le prototype P-3.01, après avoir remorqué des cibles pour la société sœur **Contraves**, revient chez Pilatus et devient en 1966 le prototype du **PC-7**. De ce turbopropulseur sortiront le **PC-9** puis le **PC-21**, qui feront de Pilatus une référence mondiale de l''avion d''entraînement. Plusieurs P-3 volent encore, dont ceux de la patrouille civile **P3 Flyers**, formée en 1996.',
    E'## Genesis\nIn the early 1950s the Swiss military air arm was entering the jet age, and its schools had to follow. In 1952 **Pilatus** began work on an aircraft able to train future jet pilots, from elementary instruction to night flying, aerobatics and instrument flying. The first prototype, the **P-3.01**, flew on 3 September 1953 with **Georg Gyssler** at the controls and a two-blade propeller. Its engine proved underpowered, and a second prototype, this time a military one, took to the air in August 1954 with a different engine and a three-blade propeller.\n\n## Design\nThe P-3 is an all-metal monoplane with a retractable tricycle undercarriage, the student and instructor sitting in tandem. A 260 hp Lycoming flat-six gave it 310 km/h and a range of 750 km, for a maximum weight of one and a half tonnes. Racks for practice bombs or rockets could be fitted under the wings, with a machine gun in a pod under the port wing: the kits were bought but never used. During the evaluation the prototype was pitted against a **T-34 Mentor** brought to Switzerland, and its test pilot flew a vertical figure of eight he knew the American aircraft could not match.\n\n## Operational career\nThe Swiss air arm first received a pre-series of 12 **P-3.03s**, then 60 **P-3.05s**, and the type entered service in 1956. Six aircraft built under civil registration, the P-3.04s, were later bought by the **Brazilian Navy**, making the P-3 the first Pilatus aircraft to be exported. After two crashes caused by flat spins, one test aircraft received a ventral fin, which was then fitted to the whole fleet. The P-3 trained Swiss pilots until 1983, then served as a liaison aircraft for another decade, before 65 aircraft were sold to private owners between 1993 and 1995.\n\n## Place in history\nWith 80 built, the P-3 counts for little in numbers, but it founded a line. The P-3.01 prototype, after towing targets for the sister company **Contraves**, returned to Pilatus and became the prototype of the **PC-7** in 1966. That turboprop led to the **PC-9** and then the **PC-21**, which made Pilatus a world reference in trainer aircraft. Several P-3s still fly, including those of the civilian **P3 Flyers** display team, formed in 1996.',
    (SELECT id FROM countries WHERE code = 'CHE'),
    '1952-01-01',
    '1953-09-03',
    '1956-01-01',
    310,
    750,
    (SELECT id FROM manufacturer WHERE code = 'PIL'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus P-3'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Pilatus P-3'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.75,
  wingspan          = 10.4,
  height            = 3.05,
  wing_area         = 16.55,
  empty_weight      = 1090,
  mtow              = 1500,
  service_ceiling   = 5500,
  climb_rate        = 7.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming GO-435-C2-A2 (260 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1959,
  units_built       = 80,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **P-3.01** : premier prototype, premier vol le 3 septembre 1953, futur prototype du PC-7 en 1966\n- **P-3.02** : prototype militaire à hélice tripale, premier vol en août 1954\n- **P-3.03** : présérie de 12 appareils pour les Troupes d''aviation suisses\n- **P-3.04** : 6 appareils construits sous immatriculation civile, rachetés par la Marine brésilienne (U-3)\n- **P-3.05** : version de série, 60 appareils, dotée ensuite d''une dérive ventrale anti-vrille',
  variants_en       = E'- **P-3.01**: first prototype, first flown on 3 September 1953, later the PC-7 prototype in 1966\n- **P-3.02**: military prototype with a three-blade propeller, first flown in August 1954\n- **P-3.03**: pre-series of 12 aircraft for the Swiss air arm\n- **P-3.04**: 6 aircraft built under civil registration, later bought by the Brazilian Navy (U-3)\n- **P-3.05**: production version, 60 aircraft, later fitted with an anti-spin ventral fin',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Pilatus_P-3',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Pilatus_P-3',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'André Gerwing',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Pilatus P-3';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Pilatus P-3';
