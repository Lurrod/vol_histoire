-- Martin Marietta X-24A / X-24B
--
-- Photo : Lifting Body Aircraft DVIDS856272.jpg
--   licence Public domain — Glenn Research Center
--   https://commons.wikimedia.org/wiki/File:Lifting_Body_Aircraft_DVIDS856272.jpg

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
    'Martin Marietta X-24',
    'Martin Marietta X-24',
    'Martin Marietta X-24A / X-24B',
    'Martin Marietta X-24A / X-24B',
    'Corps portant sans ailes, largué d''un B-52, qui prouva qu''un engin revenu de l''espace pouvait se poser en planant',
    'A wingless lifting body dropped from a B-52, which proved a craft returning from space could glide to a landing',
    '/assets/airplanes/x24b.jpg',
    E'## Genèse\nDe 1963 à 1975, le centre de recherche en vol de la NASA et l''US Air Force mènent à Edwards un programme commun de **corps portants** : des engins sans ailes, dont la portance vient de la forme même du fuselage, conçus pour revenir de l''espace et se poser comme un avion sur un terrain choisi. Le X-24, désigné **SV-5P** par **Martin Marietta**, est le quatrième à voler, après le **M2-F1**, le **HL-10** et le **M2-F2**. Il est conçu dans le cadre du programme commun PILOT, qui étudie la rentrée atmosphérique et l''atterrissage sans moteur.\n\n## Conception\nLe X-24A est une goutte d''eau courte et ventrue, contrôlée par trois dérives : une verticale au centre, deux légèrement inclinées vers l''extérieur. Un bombardier **B-52** modifié l''emporte vers 13 700 m et le largue ; le pilote plane ou allume son moteur-fusée **Reaction Motors XLR11** à quatre chambres pour monter plus haut, puis revient se poser sans moteur. Pour économiser la construction d''un nouvel engin, l''US Air Force fait ensuite rebâtir l''appareil par Martin en **X-24B** : un « fer à repasser volant » au dos arrondi, au ventre plat et à la voilure en double delta terminée par un nez pointu, à la finesse bien meilleure.\n\n## Essais\nLe major **Jerauld Gentry** effectue le premier vol plané du X-24A le 17 avril 1969, puis le premier vol propulsé le 19 mars 1970. En 28 vols, le X-24A atteint Mach 1,6, soit 1 667 km/h, et 21 800 m. **John Manke** fait voler le X-24B le 1er août 1973 ; en 36 vols, celui-ci monte à 1 873 km/h et 22 590 m. **Bill Dana**, qui avait conduit le dernier vol du X-15, pilote son dernier vol propulsé, et deux atterrissages de précision sur la piste en dur d''Edwards, par Manke et **Mike Love**, figurent parmi ses derniers vols ; le programme s''achève le 26 novembre 1975.\n\n## Place dans l''histoire\nAvec le HL-10, le X-24 a validé l''idée qu''une navette pouvait se poser sans moteur, et le X-24B a montré que de tels atterrissages précis étaient possibles en exploitation : il a aidé à écrire le plan de vol de la **navette spatiale**. Dernier engin du programme des corps portants de Dryden, il est exposé au musée de l''US Air Force. La forme du X-24A sera reprise pour le démonstrateur X-38, véhicule de secours prévu pour la Station spatiale internationale.',
    E'## Genesis\nFrom 1963 to 1975 NASA''s flight research centre and the US Air Force ran a joint **lifting body** programme at Edwards: wingless craft whose lift came from the shape of the fuselage itself, designed to return from space and land like an aircraft at a chosen site. The X-24, designated **SV-5P** by **Martin Marietta**, was the fourth to fly, after the **M2-F1**, the **HL-10** and the **M2-F2**. It was designed under the joint PILOT programme, which studied unpowered re-entry and landing.\n\n## Design\nThe X-24A was a short, fat teardrop controlled by three fins: a vertical one in the centre and two canted slightly outward. A modified **B-52** bomber carried it to around 13,700 m and dropped it; the pilot then glided or lit the four-chamber **Reaction Motors XLR11** rocket engine to climb higher, before returning to an unpowered landing. To avoid building a new vehicle, the US Air Force later had Martin rebuild it as the **X-24B**: a flying flatiron with a rounded top, a flat bottom and a double-delta planform ending in a pointed nose, with a much better lift-to-drag ratio.\n\n## Testing\nMajor **Jerauld Gentry** made the X-24A''s first glide flight on 17 April 1969, then its first powered flight on 19 March 1970. In 28 flights the X-24A reached Mach 1.6, or 1,667 km/h, and 21,800 m. **John Manke** first flew the X-24B on 1 August 1973; in 36 flights it reached 1,873 km/h and 22,590 m. **Bill Dana**, who had flown the last X-15 flight, made its last powered flight, and two precision landings on the Edwards concrete runway, by Manke and **Mike Love**, were among its final flights; the programme ended on 26 November 1975.\n\n## Place in history\nAlongside the HL-10, the X-24 validated the idea that a shuttle could land unpowered, and the X-24B showed that such precise landings were operationally feasible: it helped write the flight plan for the **Space Shuttle**. The last vehicle of Dryden''s lifting body programme, it is displayed at the US Air Force museum. The X-24A shape was later borrowed for the X-38 demonstrator, a crew return vehicle planned for the International Space Station.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1963-01-01',
    '1969-04-17',
    NULL,
    1873,
    72,
    (SELECT id FROM manufacturer WHERE code = 'MAR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin Marietta X-24'), (SELECT id FROM tech WHERE name = 'Corps portant')),
((SELECT id FROM airplanes WHERE name = 'Martin Marietta X-24'), (SELECT id FROM tech WHERE name = 'Moteur-fusée')),
((SELECT id FROM airplanes WHERE name = 'Martin Marietta X-24'), (SELECT id FROM tech WHERE name = 'Configuration aérodynamique en double delta'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin Marietta X-24'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.43,
  wingspan          = 5.84,
  height            = 3.15,
  wing_area         = 30.7,
  empty_weight      = 3538,
  mtow              = 6260,
  service_ceiling   = 22590,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Reaction Motors XLR11-RM-13',
  engine_count      = 1,
  engine_type       = 'Moteur-fusée à ergols liquides',
  engine_type_en    = 'Liquid-fuel rocket engine',
  thrust_dry        = 35.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **X-24A** (SV-5P, 66-13551) : corps portant en goutte d''eau à trois dérives, 28 vols dont 18 propulsés à partir de 1969\n- **X-24B** : le même appareil reconstruit en « fer à repasser volant » à double delta, 36 vols dont 24 propulsés, de 1973 à 1975\n- **SV-5J** : deux versions à réacteur J60 construites par Martin pour l''entraînement, jamais pilotées ; l''une figure le X-24A au musée\n- **X-24C** : projets de 1972 à 1978, dont le Lockheed L-301 à superstatoréacteurs visant Mach 8, jamais construits',
  variants_en       = E'- **X-24A** (SV-5P, 66-13551): teardrop lifting body with three fins, 28 flights including 18 powered from 1969 onwards\n- **X-24B**: the same aircraft rebuilt as a double-delta flying flatiron, 36 flights including 24 powered, from 1973 to 1975\n- **SV-5J**: two J60 jet-powered versions built by Martin for training, never flown; one now represents the X-24A at the museum\n- **X-24C**: proposals from 1972 to 1978, including the scramjet-powered Lockheed L-301 aimed at Mach 8, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Martin_Marietta_X-24',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Martin_Marietta_X-24',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'Martin Marietta X-24';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Martin Marietta X-24';
