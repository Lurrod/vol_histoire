-- North American X-15
--
-- Photo : X-15 in flight.jpg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File%3AX-15_in_flight.jpg

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
    'X-15',
    'X-15',
    'North American X-15',
    'North American X-15',
    'Mach 6,7 et cent sept kilomètres d’altitude : les records tiennent toujours',
    'Mach 6.7 and one hundred and seven kilometres up: the records still stand',
    '/assets/airplanes/x15.jpg',
    E'## Genèse\nEn 1954, personne ne sait ce qui arrive à un avion — et à son pilote — au-delà de Mach 5. La chaleur, la stabilité, le pilotage là où l''air ne porte plus : tout est théorique. La NACA, l''US Air Force et l''US Navy commandent ensemble un appareil dont l''unique fonction est d''aller voir. North American le construit en trois exemplaires.\n\n## Conception\nUne cellule en **Inconel X**, alliage de nickel capable de tenir à 650 °C, une aile minuscule inutile en haute altitude, et un moteur-fusée XLR99 de vingt-cinq tonnes de poussée qui brûle son carburant en **quatre-vingts secondes**. Là où l''air se raréfie, les gouvernes ne mordent plus : l''appareil se pilote par des **jets de réaction** aux extrémités, technique inaugurée ici et reprise sur toutes les navettes spatiales.\n\n## Carrière opérationnelle\nAucune, au sens militaire. Cent quatre-vingt-dix-neuf vols entre 1959 et 1968, chacun débutant sous l''aile d''un B-52. Le 3 octobre 1967, William Knight atteint **Mach 6,70**, soit 7 274 km/h ; le 22 août 1963, Joseph Walker monte à **107 960 mètres**. Treize vols franchissent la limite des 80 km et valent à huit pilotes le titre d''astronaute. Un appareil est détruit en 1967, tuant Michael Adams.\n\n## Place dans l''histoire\nTrois exemplaires, deux records intacts après soixante ans. Le X-15 a fourni les données de rentrée atmosphérique, de protection thermique et de pilotage hors atmosphère dont **Mercury**, **Gemini**, **Apollo** et la navette ont tous eu besoin. Neil Armstrong y a volé sept fois avant d''aller sur la Lune.',
    E'## Genesis\nIn 1954 nobody knew what happens to an aircraft — or its pilot — beyond Mach 5. Heat, stability, control where the air no longer bites: it was all theory. NACA, the US Air Force and the US Navy jointly ordered an aircraft whose only function was to go and find out. North American built three.\n\n## Design\nAn **Inconel X** airframe, a nickel alloy able to hold at 650 °C, a tiny wing useless at high altitude, and an XLR99 rocket engine of twenty-five tonnes thrust that burns its propellant in **eighty seconds**. Where the air thins the control surfaces stop working: the aircraft is flown by **reaction jets** at its extremities, a technique introduced here and used on every space shuttle since.\n\n## Operational career\nNone, in the military sense. One hundred and ninety-nine flights between 1959 and 1968, each beginning under the wing of a B-52. On 3 October 1967 William Knight reached **Mach 6.70**, or 7,274 km/h; on 22 August 1963 Joseph Walker climbed to **107,960 metres**. Thirteen flights crossed the 80 km line and earned eight pilots astronaut status. One aircraft was destroyed in 1967, killing Michael Adams.\n\n## Place in history\nThree built, two records intact after sixty years. The X-15 supplied the re-entry, thermal protection and exo-atmospheric control data that **Mercury**, **Gemini**, **Apollo** and the shuttle all needed. Neil Armstrong flew it seven times before going to the Moon.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1954-12-01',
    '1959-06-08',
    NULL,
    7274.0,
    450.0,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'X-15'), (SELECT id FROM tech WHERE name = 'Moteur-fusée')),
((SELECT id FROM airplanes WHERE name = 'X-15'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'X-15'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.45,
  wingspan          = 6.8,
  height            = 4.12,
  wing_area         = 18.6,
  empty_weight      = 6620,
  mtow              = 15420,
  service_ceiling   = 30000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Reaction Motors XLR99-RM-2',
  engine_count      = 1,
  engine_type       = 'Moteur-fusée à ergols liquides',
  engine_type_en    = 'Liquid-fuel rocket engine',
  thrust_dry        = 254.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1960,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **X-15A / X-15A-2** : trois cellules, cent quatre-vingt-dix-neuf vols de 1959 à 1968\n- **Mach 6,70** le 3 octobre 1967 : record de vitesse d''un avion piloté, jamais battu\n- **107 960 m** le 22 août 1963 : plafond d''un avion, dépassé seulement par le SpaceShipOne\n- Treize vols au-dessus de 80 km valent à huit pilotes les **ailes d''astronaute**\n- Largué en vol par un **B-52** modifié, ne décollant jamais par ses propres moyens',
  variants_en       = E'- **X-15A / X-15A-2** : three airframes, one hundred and ninety-nine flights, 1959–1968\n- **Mach 6.70** on 3 October 1967: piloted aircraft speed record, never beaten\n- **107,960 m** on 22 August 1963: aircraft altitude ceiling, passed only by SpaceShipOne\n- Thirteen flights above 80 km earned eight pilots their **astronaut wings**\n- Air-launched from a modified **B-52**, never taking off under its own power',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_X-15',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_X-15',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'X-15';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'X-15';
