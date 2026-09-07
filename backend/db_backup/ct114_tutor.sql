-- Canadair CT-114 Tutor
--
-- Photo : CT-114 Tutors with 431st Air Demonstration Squadron, perform aerial maneuvers.jpg
--   licence Public domain — Airman Jacob B. Wrightsman
--   https://commons.wikimedia.org/wiki/File%3ACT-114_Tutors_with_431st_Air_Demonstration_Squadron%2C_perform_aerial_maneuvers.jpg

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
    'Canadair CT-114 Tutor',
    'Canadair CT-114 Tutor',
    'Canadair CT-114 Tutor',
    'Canadair CT-114 Tutor',
    'Retiré de l’école en 2000, il vole encore avec les Snowbirds',
    'Retired from training in 2000, it still flies with the Snowbirds',
    '/assets/airplanes/ct114-tutor.jpg',
    E'## Genèse\nEn 1957, le Canada forme ses pilotes sur des **T-33** américains construits sous licence par Canadair. La firme estime pouvoir faire mieux et lance, **sur fonds propres**, l''étude d''un avion-école national. Elle fait voler le prototype avant même que les Forces canadiennes n''aient exprimé un besoin.\n\n## Conception\nDeux places **côte à côte** sous une verrière en bulle, un réacteur J85 construit au Canada, une aile droite épaisse. Le pari pédagogique est le même que celui du T-37 américain, et le résultat est comparable : un appareil sûr, indulgent, capable de voltige à sept g mais impardonnant de rien.\n\n## Carrière opérationnelle\nDeux cent douze exemplaires. Il forme les pilotes canadiens de 1963 à **2000**, trente-sept ans. Vingt exemplaires armés sont vendus à la **Malaisie** sous le nom de Tebuan pour la lutte anti-guérilla. Depuis 1971, il est la monture des **Snowbirds**, dont les neuf appareils volent encore aujourd''hui — soixante-cinq ans après le premier vol du type.\n\n## Place dans l''histoire\nDeux cent douze exemplaires. Le Tutor est aujourd''hui **le plus vieil avion à réaction encore en service actif dans une force aérienne occidentale**. Son remplacement est repoussé depuis quinze ans, faute d''appareil aussi économique à l''heure de vol pour un usage exclusivement acrobatique.',
    E'## Genesis\nIn 1957 Canada trained its pilots on American **T-33s** licence-built by Canadair. The firm judged it could do better and launched, **at its own expense**, the study of a national trainer. It flew the prototype before the Canadian Forces had even stated a requirement.\n\n## Design\nTwo **side-by-side** seats under a bubble canopy, a Canadian-built J85 engine, a thick straight wing. The teaching bet is the same as the American T-37''s, and the result comparable: a safe, forgiving aircraft, capable of seven-g aerobatics but unforgiving of nothing.\n\n## Operational career\nTwo hundred and twelve built. It trained Canadian pilots from 1963 to **2000**, thirty-seven years. Twenty armed aircraft were sold to **Malaysia** as the Tebuan for counter-insurgency. Since 1971 it has been the mount of the **Snowbirds**, whose nine aircraft still fly today — sixty-five years after the type''s first flight.\n\n## Place in history\nTwo hundred and twelve built. The Tutor is today **the oldest jet aircraft still in active service with a Western air force**. Its replacement has been postponed for fifteen years, for want of an aircraft as cheap per flight hour for purely aerobatic use.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1957-01-01',
    '1960-01-13',
    '1963-12-01',
    790.0,
    1380.0,
    (SELECT id FROM manufacturer WHERE code = 'CDR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CT-114 Tutor'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CT-114 Tutor'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CT-114 Tutor'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CT-114 Tutor'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.75,
  wingspan          = 11.13,
  height            = 2.84,
  wing_area         = 20.4,
  empty_weight      = 2260,
  mtow              = 3600,
  service_ceiling   = 13100,
  climb_rate        = 22.4,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.0,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J85-CAN-40',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 12.3,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1961,
  production_end    = 1966,
  units_built       = 212,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **CL-41A / CT-114** : version d''entraînement des Forces canadiennes\n- **CL-41G Tebuan** : version d''attaque légère, vingt exemplaires pour la **Malaisie**\n- Places **côte à côte**, comme sur le T-37 américain et pour la même raison\n- Monture des **Snowbirds**, patrouille acrobatique canadienne, depuis **1971**\n- Retiré de l''instruction en 2000 : les Snowbirds sont son dernier emploi',
  variants_en       = E'- **CL-41A / CT-114** : Canadian Forces training version\n- **CL-41G Tebuan** : light attack version, twenty aircraft for **Malaysia**\n- **Side-by-side** seating, as on the American T-37 and for the same reason\n- Mount of the **Snowbirds**, Canada''s display team, since **1971**\n- Retired from training in 2000: the Snowbirds are its last employment',

  -- Strate 4 : qualitatif
  nickname          = 'Tutor',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Canadair_CT-114_Tutor',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Canadair_CT-114_Tutor',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Airman Jacob B. Wrightsman',
  image_licence     = 'Public domain'
WHERE name = 'Canadair CT-114 Tutor';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Canadair CT-114 Tutor';
