-- Elbit Hermes 450 (Zik)
--
-- Photo : NGP DSC 0364.jpg
--   licence CC BY-SA 3.0 — Nehemia Gershuni-Aylho
--   https://commons.wikimedia.org/wiki/File:NGP_DSC_0364.jpg

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
    'Elbit Hermes 450',
    'Elbit Hermes 450',
    'Elbit Systems Hermes 450 (Zik)',
    'Elbit Systems Hermes 450 (Zik)',
    'Le drone tactique israélien exporté dans le monde entier, base du Watchkeeper britannique',
    'The Israeli tactical drone exported worldwide, basis of the British Watchkeeper',
    '/assets/airplanes/hermes-450.jpg',
    E'## Genèse\nDans les années 1990, **Elbit Systems**, jusque-là spécialiste de l''électronique militaire, entre sur le marché des drones dominé en Israël par IAI. Le Hermes 450 est un drone tactique de moyenne endurance, conçu pour rester plus d''une quinzaine d''heures au-dessus d''un champ de bataille. Il entre en service en 1998 et devient, sous le nom de **Zik**, l''un des drones les plus employés de l''aviation israélienne.\n\n## Conception\nUne cellule de six mètres de long et de 10,5 mètres d''envergure, un empennage en V et un moteur rotatif **UEL R902** de 52 kW entraînant une hélice propulsive. La masse au décollage atteint 550 kg, dont 180 kg de charge utile : boule optronique, désignateur laser, capteurs électroniques ou radar. L''endurance est d''environ dix-sept heures, le plafond de 5 500 mètres. Selon plusieurs sources, des versions israéliennes emportent des missiles légers ; Israël n''a reconnu officiellement l''emploi de drones armés qu''en 2022.\n\n## Carrière opérationnelle\nLe Zik est engagé au **Liban** en 2006, où trois exemplaires sont perdus, puis dans toutes les opérations israéliennes à **Gaza** depuis 2008. Le 20 avril 2008, un Hermes 450 géorgien est abattu au-dessus de l''Abkhazie par un MiG-29 russe, scène filmée par le drone lui-même ; deux autres sont abattus par les forces russes la même année. L''armée britannique loue des Hermes 450 pour l''**Afghanistan** avant d''en tirer le **Thales Watchkeeper WK450**, construit au Royaume-Uni. Plus d''une quinzaine de pays l''ont acquis, du Brésil aux Philippines.\n\n## Place dans l''histoire\nLe Hermes 450 a fait d''Elbit l''un des grands exportateurs mondiaux de drones et installé le modèle israélien du drone tactique bon marché, robuste et polyvalent. Sa version agrandie, l''**Elbit Hermes 900**, en reprend l''architecture pour emporter davantage. Il est, avec l''**IAI Heron**, l''un des deux piliers de la flotte de drones israélienne.',
    E'## Genesis\nIn the 1990s **Elbit Systems**, until then a military electronics specialist, entered the drone market dominated in Israel by IAI. The Hermes 450 is a medium-endurance tactical drone, designed to stay more than fifteen hours over a battlefield. It entered service in 1998 and became, under the name **Zik**, one of the most heavily used drones of the Israeli air force.\n\n## Design\nA six-metre airframe with a 10.5-metre span, a V-tail and a 52 kW **UEL R902** rotary engine driving a pusher propeller. Take-off weight reaches 550 kg, including 180 kg of payload: electro-optical turret, laser designator, electronic sensors or radar. Endurance is about seventeen hours and the ceiling 5,500 metres. According to several sources, Israeli versions carry light missiles; Israel only officially acknowledged the use of armed drones in 2022.\n\n## Operational career\nThe Zik was used over **Lebanon** in 2006, where three were lost, then in every Israeli operation in **Gaza** since 2008. On 20 April 2008 a Georgian Hermes 450 was shot down over Abkhazia by a Russian MiG-29, a scene filmed by the drone itself; two more were shot down by Russian forces the same year. The British Army leased Hermes 450s for **Afghanistan** before deriving from them the **Thales Watchkeeper WK450**, built in the United Kingdom. More than fifteen countries have acquired it, from Brazil to the Philippines.\n\n## Place in history\nThe Hermes 450 made Elbit one of the world''s great drone exporters and established the Israeli model of the cheap, robust and versatile tactical drone. Its enlarged version, the **Elbit Hermes 900**, takes up its architecture to carry more. Together with the **IAI Heron**, it is one of the two pillars of the Israeli drone fleet.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    NULL,
    NULL,
    '1998-01-01',
    176.0,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'ELB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 450'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 450'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 450'), (SELECT id FROM tech WHERE name = 'Pod désignateur laser'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 450'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 450'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 450'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 450'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 450'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 6.1,
  wingspan          = 10.5,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 550,
  service_ceiling   = 5500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'UEL R902(W)',
  engine_count      = 1,
  engine_type       = 'Moteur rotatif',
  engine_type_en    = 'Rotary engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Hermes 450** : version de base, endurance d''environ **dix-sept heures**\n- **Hermes 450LE** : version à endurance allongée, jusqu''à trente heures annoncées\n- **Zik** : désignation dans l''aviation israélienne, versions armées selon plusieurs sources\n- **Thales Watchkeeper WK450** : dérivé britannique construit au Royaume-Uni\n- **Hermes 900** : version agrandie, premier vol en 2009',
  variants_en       = E'- **Hermes 450** : basic version, endurance of about **seventeen hours**\n- **Hermes 450LE** : long-endurance version, up to thirty hours quoted\n- **Zik** : Israeli air force designation, armed versions according to several sources\n- **Thales Watchkeeper WK450** : British derivative built in the United Kingdom\n- **Hermes 900** : enlarged version, first flight in 2009',

  -- Strate 4 : qualitatif
  nickname          = 'Zik',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Elbit_Hermes_450',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Nehemia Gershuni-Aylho',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Elbit Hermes 450';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Elbit Hermes 450';
