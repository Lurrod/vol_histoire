-- Boeing X-45
--
-- Photo : X-45 AV2 first flight from Edwards AFB (EC02-0267-01).jpg
--   licence Public domain — Jim Ross, NASA
--   https://commons.wikimedia.org/wiki/File:X-45_AV2_first_flight_from_Edwards_AFB_(EC02-0267-01).jpg

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
    'Boeing X-45',
    'Boeing X-45',
    'Boeing X-45 (J-UCAS)',
    'Boeing X-45 (J-UCAS)',
    'Le démonstrateur qui a prouvé qu’un drone furtif pouvait frapper, abandonné en pleine course',
    'The demonstrator that proved a stealth drone could strike, abandoned in mid-race',
    '/assets/airplanes/x45.jpg',
    E'## Genèse\nÀ la fin des années 1990, la DARPA et l''US Air Force veulent savoir si un avion sans pilote peut mener la mission la plus dangereuse de toutes : la **suppression des défenses aériennes ennemies**, au-dessus des missiles sol-air. En 1999, Boeing est retenu pour construire deux démonstrateurs dans ses ateliers Phantom Works. Le premier X-45A est achevé en septembre 2000.\n\n## Conception\nUne aile en flèche sans dérive de dix mètres d''envergure pour huit mètres de long, avec une entrée d''air dorsale et deux soutes internes. Le contrôle en lacet, sans gouverne verticale, passe par les surfaces du bord de fuite. Le réacteur est un **Honeywell F124** de 28 kN. Le X-45A pèse 3,6 tonnes à vide. Mais l''essentiel est ailleurs : dans le logiciel, qui permet à un seul opérateur au sol de diriger plusieurs appareils et de leur confier une part croissante des décisions.\n\n## Carrière opérationnelle\nPremier vol le **22 mai 2002** à Edwards. Le **18 avril 2004**, un X-45A largue une bombe guidée inerte de 250 livres et touche sa cible au sol : le drone de combat furtif passe du concept à l''arme. Le 1er août 2004, les deux appareils volent ensemble sous le contrôle d''un seul pilote ; en février 2005, ils répartissent eux-mêmes une attaque simulée. Le programme commun J-UCAS, qui devait aboutir au X-45C plus grand, est abandonné en mars 2006. Boeing poursuit sur ses fonds propres le **Phantom Ray**, dérivé du X-45C, qui vole le 27 avril 2011 sans suite.\n\n## Place dans l''histoire\nLe X-45 a été parmi les premiers à démontrer qu''un drone furtif pouvait voler en formation et frapper. Sa disparition a laissé le champ libre à Northrop Grumman, son concurrent dans le programme J-UCAS, et à son **X-47B**, puis aux ailiers sans pilote des années 2020. Les deux X-45A sont exposés au musée national de l''Air et de l''Espace et au musée national de l''US Air Force.',
    E'## Genesis\nIn the late 1990s DARPA and the US Air Force wanted to know whether an uncrewed aircraft could perform the most dangerous mission of all: the **suppression of enemy air defences**, over the surface-to-air missiles. In 1999 Boeing was chosen to build two demonstrators in its Phantom Works shops. The first X-45A was completed in September 2000.\n\n## Design\nA tailless swept wing of ten metres span and eight metres length, with a dorsal intake and two internal bays. Yaw control, with no vertical surface, is provided by the trailing-edge surfaces. The engine is a 28 kN **Honeywell F124**. The X-45A weighs 3.6 tonnes empty. But the essential part lies elsewhere: in the software, which lets a single ground operator direct several aircraft and hand them a growing share of the decisions.\n\n## Operational career\nFirst flight on **22 May 2002** at Edwards. On **18 April 2004** an X-45A dropped a 250-pound inert guided bomb and hit its ground target: the stealth combat drone moved from concept to weapon. On 1 August 2004 both aircraft flew together under the control of a single pilot; in February 2005 they shared out a simulated attack between themselves. The joint J-UCAS programme, which was to lead to the larger X-45C, was abandoned in March 2006. Boeing pursued with its own funds the **Phantom Ray**, derived from the X-45C, which flew on 27 April 2011 without follow-on.\n\n## Place in history\nThe X-45 was among the first to demonstrate that a stealth drone could fly in formation and strike. Its disappearance left the field open to Northrop Grumman, its competitor in the J-UCAS programme, and its **X-47B**, then to the uncrewed wingmen of the 2020s. Both X-45As are displayed at the National Air and Space Museum and the National Museum of the US Air Force.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1999-01-01',
    '2002-05-22',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing X-45'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Boeing X-45'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing X-45'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Boeing X-45'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.08,
  wingspan          = 10.31,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = 3629,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Honeywell F124-GA-100',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 28.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **X-45A** : deux démonstrateurs, premier vol le **22 mai 2002**\n- **X-45C** : version agrandie du programme J-UCAS, jamais construite\n- **Phantom Ray** : dérivé du X-45C financé par Boeing, un exemplaire, premier vol le **27 avril 2011**\n- **18 avril 2004** : largage d''une bombe guidée inerte sur une cible au sol\n- Les deux X-45A sont exposés au **NASM** et au **musée de l''US Air Force**',
  variants_en       = E'- **X-45A** : two demonstrators, first flight on **22 May 2002**\n- **X-45C** : enlarged version for the J-UCAS programme, never built\n- **Phantom Ray** : Boeing-funded X-45C derivative, one built, first flight on **27 April 2011**\n- **18 April 2004** : release of an inert guided bomb on a ground target\n- Both X-45As are displayed at the **NASM** and the **US Air Force museum**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_X-45',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_X-45',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jim Ross, NASA',
  image_licence     = 'Public domain'
WHERE name = 'Boeing X-45';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'Boeing X-45';
