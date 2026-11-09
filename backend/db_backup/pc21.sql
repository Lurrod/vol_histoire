-- Pilatus PC-21
--
-- Photo : Desfile Aéreo. Día de las Fuerzas Armadas. Gijón. 24-05-2024. (53762545614).jpg
--   licence CC BY 2.0 — David Álvarez López from Gijón, España
--   https://commons.wikimedia.org/wiki/File:Desfile_A%C3%A9reo._D%C3%ADa_de_las_Fuerzas_Armadas._Gij%C3%B3n._24-05-2024._(53762545614).jpg

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
    'Pilatus PC-21',
    'Pilatus PC-21',
    'Pilatus PC-21',
    'Pilatus PC-21',
    'Un turbopropulseur qui enseigne une large part de ce que faisaient les jets d’école',
    'A turboprop that teaches much of what jet trainers used to',
    '/assets/airplanes/pilatus-pc21.jpg',
    E'## Genèse\nEn novembre 1997, Pilatus fait voler un **PC-7 Mk II** modifié pour éprouver les idées d''un futur avion d''entraînement à turbopropulseur. L''entreprise décide en novembre 1998 de financer seule un programme entièrement nouveau, lancé officiellement en janvier 1999. L''objectif est clair : permettre aux élèves de faire l''essentiel de leur formation sur turbopropulseur avant de passer au réacteur, et réduire d''autant le coût de l''heure de vol.\n\n## Conception\nUn **PT6A-68B** de 1 600 ch entraîne une hélice à cinq pales ; l''aile, dessinée pour la vitesse, tient **+8 g** et porte des spoilers qui donnent des taux de roulis de chasseur. Un compensateur automatique de lacet gomme les effets de couple qui rendent délicats les turbopropulseurs puissants à basse vitesse. L''essentiel est ailleurs : le cockpit tout écran, avec affichage tête haute aux deux places, embarque une **simulation de radar, d''armement et de guerre électronique**. Depuis la place arrière, l''instructeur crée des cibles fictives et des pannes.\n\n## Carrière opérationnelle\nPremier vol le 1er juillet 2002 ; le second prototype s''écrase le 13 janvier 2005, tuant son pilote. La Suisse le met en service en 2008, Singapour est le premier client à l''exportation. Suivent l''Arabie saoudite (55), l''Australie (49, qui remplacent ses **PC-9**), les Émirats, le Qatar, la Jordanie, l''Espagne (40, à la place du **C-101**) et la France, qui en commande 17 en 2017 puis 9 en 2021 pour l''école de pilotage de Cognac ; en 2024, ils surveillent le ciel des Jeux olympiques de Paris. En mai 2026, le Canada le retient pour remplacer le **CT-114 Tutor** de la patrouille des Snowbirds.\n\n## Place dans l''histoire\nPlus de deux cents exemplaires livrés, plus de trois cents commandés. Le PC-21 achève le mouvement lancé par le **PC-7** et poursuivi par le **PC-9** : le turbopropulseur prend désormais une part de la formation qui revenait au biréacteur d''école. Il est devenu la référence du genre — c''est sa formule que reprend, sans s''en cacher, le **TAI Hürkuş** turc.',
    E'## Genesis\nIn November 1997 Pilatus flew a modified **PC-7 Mk II** to test ideas for a future turboprop trainer. In November 1998 the company decided to fund an entirely new programme on its own, formally launched in January 1999. The aim was clear: let students do most of their training on a turboprop before moving to jets, and cut the cost of each flying hour accordingly.\n\n## Design\nA 1,600 hp **PT6A-68B** drives a five-bladed propeller; the wing, drawn for speed, is stressed to **+8 g** and carries spoilers that give fighter-like roll rates. An automatic yaw compensator smooths out the torque effects that make powerful turboprops tricky at low speed. The essential feature lies elsewhere: the glass cockpit, with a head-up display in both seats, carries **simulated radar, weapons and electronic warfare**. From the rear seat the instructor creates synthetic targets and failures.\n\n## Operational career\nFirst flight on 1 July 2002; the second prototype crashed on 13 January 2005, killing its pilot. Switzerland brought it into service in 2008 and Singapore was the first export customer. Saudi Arabia (55), Australia (49, replacing its **PC-9s**), the Emirates, Qatar, Jordan, Spain (40, in place of the **C-101**) and France followed, the latter ordering 17 in 2017 and 9 more in 2021 for its flying school at Cognac; in 2024 they watched over the skies of the Paris Olympics. In May 2026 Canada selected it to replace the **CT-114 Tutor** of the Snowbirds display team.\n\n## Place in history\nMore than two hundred delivered, more than three hundred ordered. The PC-21 completes the movement begun by the **PC-7** and continued by the **PC-9**: the turboprop now takes a share of training that used to belong to the twin-jet trainer. It has become the benchmark of its kind — its formula is openly taken up by Turkey''s **TAI Hürkuş**.',
    (SELECT id FROM countries WHERE code = 'CHE'),
    '1999-01-01',
    '2002-07-01',
    '2008-04-01',
    685.0,
    1333.0,
    (SELECT id FROM manufacturer WHERE code = 'PIL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-21'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-21'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-21'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.23,
  wingspan          = 9.11,
  height            = 3.74,
  wing_area         = 15.22,
  empty_weight      = 2270,
  mtow              = 3100,
  service_ceiling   = 11580,
  climb_rate        = 20.3,
  g_limit_pos       = 8.0,
  g_limit_neg       = -4.0,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-68B',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2002,
  production_end    = NULL,
  units_built       = 211,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 10,
  variants          = E'- **Prototypes** : premiers vols en juillet 2002 et juin 2004, le second perdu en janvier 2005\n- **Simulation embarquée** : radar, armement et guerre électronique fictifs générés par l''ordinateur de mission\n- **Cinq points d''emport** sous la voilure et le fuselage, pour l''instruction au tir air-sol\n- **CT-157 Siskin II** : désignation canadienne, retenu en 2026 pour succéder au **CT-114 Tutor**\n- Successeur des **PC-7** et **PC-9** ; sa formule est reprise par le **TAI Hürkuş**',
  variants_en       = E'- **Prototypes** : first flights in July 2002 and June 2004, the second lost in January 2005\n- **Embedded simulation** : synthetic radar, weapons and electronic warfare generated by the mission computer\n- **Five hardpoints** under the wings and fuselage, for air-to-ground weapons training\n- **CT-157 Siskin II** : Canadian designation, chosen in 2026 to succeed the **CT-114 Tutor**\n- Successor to the **PC-7** and **PC-9**; its formula is taken up by the **TAI Hürkuş**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Pilatus_PC-21',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Pilatus_PC-21',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'David Álvarez López from Gijón, España',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Pilatus PC-21';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Pilatus PC-21';
