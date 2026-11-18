-- Canadair CL-89 (AN/USD-501 Midge)
--
-- Photo : Cl-89 NATO AN USD-501.jpg
--   licence CC BY-SA 3.0 — Dirk1981
--   https://commons.wikimedia.org/wiki/File:Cl-89_NATO_AN_USD-501.jpg

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
    'Canadair CL-89',
    'Canadair CL-89',
    'Canadair CL-89 (AN/USD-501 Midge)',
    'Canadair CL-89 (AN/USD-501 Midge)',
    'Drone de reconnaissance de l''OTAN, lancé comme un missile et récupéré sur le dos sous ses coussins gonflables',
    'NATO reconnaissance drone, launched like a missile and recovered upside down on air bags',
    '/assets/airplanes/canadair-cl89.jpg',
    E'## Genèse\nLe CL-89 naît chez **Canadair** d''une étude baptisée **CL-85**, consacrée au transport de dépêches. En juin 1963, le Canada et le Royaume-Uni s''accordent pour financer la conception, l''évaluation et les essais d''un drone de surveillance destiné à l''échelon de la division ; l''Allemagne de l''Ouest rejoint ensuite le projet, tandis que les États-Unis, invités, déclinent. Le premier vol, peu concluant, a lieu à **Yuma**, en Arizona, en mars 1964. Le développement est difficile et le programme manque d''être abandonné : les Britanniques exigent un système « à l''épreuve du soldat » et détachent un officier chez Canadair pour y monter un groupe de conseil à la maintenance.\n\n## Conception\nLe CL-89 ressemble à un missile : un corps cylindrique de 33 cm de diamètre, quatre petites ailes à l''arrière et des plans canards à l''avant. Lancé d''une rampe sur camion par une fusée d''appoint **Wagtail** larguée en vol, il croise ensuite grâce à un petit turboréacteur **Williams WR2-6**. Il ne reçoit aucun ordre en vol : il suit un trajet programmé, limité à quelques « événements » — virages, changements d''altitude, mise en marche des capteurs — et corrigé de la météo. Au retour, le moteur se coupe, un parachute retourne le drone sur le dos et deux coussins pneumatiques amortissent l''arrivée au sol. Il emporte une caméra à film noir et blanc, avec des fusées éclairantes pour la nuit, ou un analyseur infrarouge à balayage linéaire.\n\n## Carrière opérationnelle\nLe premier système complet est livré à l''Allemagne de l''Ouest en 1969 ; la France et l''Italie rejoignent les utilisateurs dans les années 1970, la Turquie plus tard. L''OTAN le désigne **AN/USD-501**, et l''armée britannique le baptise **Midge**, pour Military Intelligence & Data Gathering Equipment. Dans la Royal Artillery, où il remplace le **SD-1 Observer**, une troupe d''environ 70 hommes met en œuvre deux lanceurs pour confirmer la position des batteries adverses. Il est engagé au Koweït en 1991, pendant la **guerre du Golfe**, avec un certain effet lorsqu''il est combiné aux raids d''artillerie.\n\n## Place dans l''histoire\nPendant la guerre froide, le CL-89 a donné aux divisions de l''OTAN un œil au-dessus de la ligne de front sans risquer un pilote. Son descendant, le **CL-289**, plus grand et doté d''un meilleur rayon d''action, est commandé en 1987 par le Canada, l''Allemagne de l''Ouest et la France pour le renseignement du corps d''armée ; il entre en service en 1990, et au moins neuf exemplaires sont abattus au-dessus de la Yougoslavie en 1999. Au Royaume-Uni, le Midge cède la place au **Phoenix**.',
    E'## Genesis\nThe CL-89 grew at **Canadair** out of a study called the **CL-85**, for the carriage of dispatches. In June 1963 Canada and Britain agreed to sponsor the design, evaluation and testing of a surveillance drone for use at divisional level; West Germany later joined the group, while the United States, though invited, declined. The first, less than successful flight took place at **Yuma**, Arizona, in March 1964. Development was difficult and the programme was almost abandoned: the British wanted a ''soldier-proof'' system and sent an army officer to Canadair to set up a maintenance advisory group, with excellent results.\n\n## Design\nThe CL-89 looks like a missile: a cylindrical body 33 cm in diameter, four stub wings at the rear and small canard foreplanes. Launched from a truck-mounted rail by a **Wagtail** booster rocket, jettisoned once flight speed is reached, it then cruises on a small **Williams WR2-6** turbojet. It receives no commands in flight: it follows a pre-programmed course, limited to a handful of ''events'' — turns, changes of altitude, sensor switching — and corrected for the weather. On the way back the engine cuts, a parachute turns the drone on its back and two pneumatic bags cushion the landing. It carries a black and white film camera, with flares for night use, or an infrared linescan, an early form of thermal imaging.\n\n## Operational career\nThe first complete system was supplied to West Germany in 1969; France and Italy joined the users in the 1970s, Turkey later. NATO designated it **AN/USD-501**, and the British Army named it **Midge**, for Military Intelligence & Data Gathering Equipment. In the Royal Artillery a troop of two officers and about 70 soldiers operated two launchers to confirm the positions of enemy guns; there the Midge replaced the **SD-1 Observer**. It was used operationally in Kuwait in 1991, during the **Gulf War**, with some effect when combined with artillery raids.\n\n## Place in history\nThroughout the Cold War the CL-89 gave NATO divisions an eye over the front line without risking a pilot. Its descendant, the larger **CL-289** with greater range, was ordered in 1987 by Canada, West Germany and France to gather corps-level intelligence; it entered service in 1990, and at least nine were shot down over Yugoslavia in 1999. In Britain the Midge gave way to the **Phoenix**.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1959-01-01',
    '1964-03-01',
    '1969-01-01',
    740,
    60,
    (SELECT id FROM manufacturer WHERE code = 'CDR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CL-89'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CL-89'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CL-89'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Canadair CL-89'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 3.71,
  wingspan          = 0.94,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = 78,
  mtow              = 156,
  service_ceiling   = 3000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Williams International WR2-6 (+ fusée d''appoint BAJ Vickers Wagtail largable)',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 0.56,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1969,
  production_end    = 1983,
  units_built       = 500,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **CL-85** : étude de Canadair pour le transport de dépêches, point de départ du programme\n- **CL-89 / AN/USD-501** : drone de surveillance divisionnaire, premier vol en mars 1964\n- **Midge** : nom du système dans l''armée britannique (Royal Artillery)\n- **CL-289 / AN/USD-502** : successeur agrandi, commandé en 1987, en service en novembre 1990',
  variants_en       = E'- **CL-85**: Canadair study for carrying dispatches, the starting point of the programme\n- **CL-89 / AN/USD-501**: divisional surveillance drone, first flight in March 1964\n- **Midge**: name of the system in British Army (Royal Artillery) service\n- **CL-289 / AN/USD-502**: enlarged successor, ordered in 1987, in service in November 1990',

  -- Strate 4 : qualitatif
  nickname          = 'Midge',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Canadair_CL-89',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Canadair_CL-89',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Dirk1981',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Canadair CL-89';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Canadair CL-89';
