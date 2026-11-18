-- Grob G 120A
--
-- Photo : Grob G120A (cropped).jpg
--   licence CC BY-SA 4.0 — Ridernation
--   https://commons.wikimedia.org/wiki/File:Grob_G120A_(cropped).jpg

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
    'Grob G 120',
    'Grob G 120',
    'Grob G 120A',
    'Grob G 120A',
    'L''avion-école allemand tout en composite carbone, souvent exploité par des sociétés privées pour les armées',
    'The all-carbon-composite German trainer, often supplied to military schools by contractors',
    '/assets/airplanes/grob-g120.jpg',
    E'## Genèse\nÀ la fin des années 1990, le constructeur allemand **Grob Aircraft** conçoit un avion spécialement destiné à la formation des pilotes militaires et civils. Il part de son **G 115TA**, un avion-école déjà en service, et le transforme en un appareil plus puissant, apte à la voltige, avec un train tricycle escamotable et un empennage bas. Le **G 120** vole pour la première fois en 1999 et entre aussitôt en production.\n\n## Conception\nLe G 120A est un monoplan biplace à aile basse dont la cellule est faite de plastique renforcé de fibres de carbone. Calculée pour +6 et −4 g, elle offre une durée de vie minimale d''un peu plus de 15 000 heures de vol. La cabine est assez large pour des élèves portant l''équipement et le casque militaires, avec sièges et palonniers réglables, climatisation et seconde manette de puissance. Un moteur à six cylindres à plat **Lycoming AEIO-540** de 260 ch entraîne une hélice tripale Hartzell ; l''avion atteint 319 km/h et tient l''air plus de six heures. Une version à turbopropulseur Rolls-Royce 250, le **G 120TP**, avec sièges éjectables Martin-Baker, vole en 2010.\n\n## Carrière opérationnelle\nLe G 120A est souvent mis en œuvre par des sociétés privées pour le compte des forces armées. Au Canada, KF Defence Programs en exploite quatorze pour former les pilotes des Forces armées canadiennes, puis de l''Aviation royale canadienne, qui le désigne **CT-102A Astra**. En France, dix-huit G 120A-F livrés en 2007 et exploités par Airbus Flight Academy Europe remplacent les **TB-30 Epsilon** à l''école de pilotage de l''armée de l''air de Cognac. Israël l''utilise dans son école de pilotage sous le nom de **Snunit**, le Kenya en aligne six, et Lufthansa Flight Training en emploie six en Arizona pour former des pilotes de la compagnie et de la Luftwaffe.\n\n## Place dans l''histoire\nLe G 120 illustre l''évolution de la formation initiale militaire : un avion certifié selon les normes civiles, construit en composite, souvent exploité et entretenu par un prestataire plutôt que par l''armée elle-même. Sa version à turbopropulseur a prolongé la formule auprès de nouvelles forces aériennes, dont celles de l''Argentine, de l''Indonésie et du Mexique.',
    E'## Genesis\nIn the late 1990s the German manufacturer **Grob Aircraft** designed an aircraft specifically for training military and civil pilots. It started from its **G 115TA**, a trainer already in service, and turned it into a more powerful, aerobatic aircraft with a retractable tricycle undercarriage and a low-set tailplane. The **G 120** first flew in 1999 and went straight into production.\n\n## Design\nThe G 120A is a two-seat low-wing monoplane whose airframe is made of carbon-fibre reinforced plastic. Stressed to +6/-4 g, it has a minimum service life of just over 15,000 flight hours. The cockpit is roomy enough for students wearing military equipment and helmets, with adjustable seats and rudder pedals, air conditioning and a second throttle. A 260 hp six-cylinder **Lycoming AEIO-540** flat engine drives a three-blade Hartzell propeller; the aircraft reaches 319 km/h and can stay aloft for more than six hours. A turboprop version powered by a Rolls-Royce 250, the **G 120TP**, with Martin-Baker ejection seats, flew in 2010.\n\n## Operational career\nThe G 120A is often operated by private companies on behalf of the armed forces. In Canada, KF Defence Programs runs fourteen to train pilots for the Canadian Armed Forces, and later the Royal Canadian Air Force, which designates it the **CT-102A Astra**. In France, eighteen G 120A-Fs delivered in 2007 and operated by Airbus Flight Academy Europe replaced the **TB-30 Epsilon** at the air force pilot school at Cognac. Israel uses it at its flight school as the **Snunit**, Kenya fields six, and Lufthansa Flight Training flies six in Arizona to train airline and Luftwaffe pilots.\n\n## Place in history\nThe G 120 reflects a change in initial military flight training: an aircraft certified to civil standards, built in composites and often operated and maintained by a contractor rather than by the armed forces themselves. Its turboprop version carried the formula to new air forces, including those of Argentina, Indonesia and Mexico.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    NULL,
    '1999-01-01',
    NULL,
    319,
    1540,
    (SELECT id FROM manufacturer WHERE code = 'GROB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Grob G 120'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Grob G 120'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.61,
  wingspan          = 10.19,
  height            = 2.57,
  wing_area         = 13.29,
  empty_weight      = 960,
  mtow              = 1490,
  service_ceiling   = 5500,
  climb_rate        = 6.5,
  g_limit_pos       = 6.0,
  g_limit_neg       = -4.0,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming AEIO-540-D4D5 (260 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1999,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **G 120A** : version à moteur à pistons Lycoming AEIO-540 de 260 ch, cellule en composite carbone\n- **G 120A-F** : version de l''armée de l''air française, dix-huit exemplaires livrés en 2007 à Cognac\n- **G 120A-I Snunit** : version de l''école de pilotage israélienne\n- **CT-102A Astra** : désignation canadienne des appareils de KF Defence Programs\n- **G 120TP** : version à turbopropulseur Rolls-Royce 250-B17F de 456 ch et sièges éjectables, premier vol en 2010',
  variants_en       = E'- **G 120A**: piston version with a 260 hp Lycoming AEIO-540, carbon-composite airframe\n- **G 120A-F**: French Air Force version, eighteen delivered in 2007 to Cognac\n- **G 120A-I Snunit**: Israeli flight school version\n- **CT-102A Astra**: Canadian designation of the KF Defence Programs aircraft\n- **G 120TP**: turboprop version with a 456 shp Rolls-Royce 250-B17F and ejection seats, first flown in 2010',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grob_G_120A',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grob_G_120',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ridernation',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Grob G 120';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Grob G 120';
