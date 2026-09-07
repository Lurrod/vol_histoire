-- SIAI-Marchetti SF.260
--
-- Photo : SIAI-Marchetti SF-260 on flight.jpg
--   licence Public domain — Philippine Air Force
--   https://commons.wikimedia.org/wiki/File%3ASIAI-Marchetti_SF-260_on_flight.jpg

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
    'SF.260',
    'SF.260',
    'SIAI-Marchetti SF.260',
    'SIAI-Marchetti SF.260',
    'Dessiné par un ingénieur de voitures de course, vendu à vingt-sept pays',
    'Drawn by a racing-car engineer, sold to twenty-seven countries',
    '/assets/airplanes/sf260.jpg',
    E'## Genèse\n**Stelio Frati** vient de l''automobile de compétition et dessine des avions comme on dessine des voitures de sport : petits, tendus, faits pour être maniés. Son SF.260 naît en 1962 comme un avion de tourisme rapide, sans commande militaire ni cahier des charges — juste la conviction qu''un appareil de deux places peut être agréable à piloter.\n\n## Conception\nSept mètres de long, huit d''envergure, moins de huit cents kilogrammes à vide, et un facteur de charge de **plus six à moins trois g** — inhabituel pour un avion léger. L''aile porte des réservoirs de bout, la verrière est bulle, la visibilité totale. Les forces aériennes y voient ce que Frati n''avait pas prévu : un avion-école capable de faire de la voltige et de tirer.\n\n## Carrière opérationnelle\nEnviron neuf cents exemplaires, **vingt-sept forces aériennes**. Sa version armée SF.260W **Warrior** est engagée pour de bon : Rhodésie, Philippines, Sri Lanka, Tchad, Congo. Aux Philippines, elle sert encore aujourd''hui contre les groupes armés du sud de l''archipel, gueule de requin peinte sur le nez.\n\n## Place dans l''histoire\nNeuf cents exemplaires et une production qui n''a jamais cessé depuis 1966 — soixante ans. Le SF.260 est la démonstration qu''un avion de tourisme bien né peut devenir un outil militaire durable, sans jamais avoir été conçu pour cela.',
    E'## Genesis\n**Stelio Frati** came from competition motoring and drew aircraft as one draws sports cars: small, taut, made to be handled. His SF.260 was born in 1962 as a fast touring aircraft, with no military order and no requirement — just the conviction that a two-seater can be a pleasure to fly.\n\n## Design\nSeven metres long, eight in span, under eight hundred kilogrammes empty, and a load factor of **plus six to minus three g** — unusual for a light aircraft. The wing carries tip tanks, the canopy is a bubble, visibility total. Air forces saw in it what Frati had not intended: a trainer able to do aerobatics and to shoot.\n\n## Operational career\nSome nine hundred built, **twenty-seven air forces**. Its armed SF.260W **Warrior** version has seen real fighting: Rhodesia, the Philippines, Sri Lanka, Chad, the Congo. In the Philippines it still flies today against armed groups in the southern islands, a shark mouth painted on the nose.\n\n## Place in history\nNine hundred built and a production run unbroken since 1966 — sixty years. The SF.260 is the proof that a well-born touring aircraft can become a lasting military tool, without ever having been designed for it.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1962-01-01',
    '1964-07-15',
    '1968-01-01',
    500.0,
    1600.0,
    (SELECT id FROM manufacturer WHERE code = 'SIAI'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'SF.260'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'SF.260'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'SF.260'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'SF.260'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'SF.260'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'SF.260'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.1,
  wingspan          = 8.35,
  height            = 2.41,
  wing_area         = 10.1,
  empty_weight      = 770,
  mtow              = 1300,
  service_ceiling   = 6000,
  climb_rate        = 9.1,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = 550,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming O-540-E4A5',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1966,
  production_end    = NULL,
  units_built       = 900,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 27,
  variants          = E'- **SF.260M** : version militaire d''entraînement, la plus répandue\n- **SF.260W Warrior** : version armée à deux points d''emport, engagée au combat\n- **SF.260TP** : remotorisation en **turbopropulseur**, produite depuis 1980\n- Dessiné par **Stelio Frati**, ingénieur venu de l''automobile de compétition\n- Facteur de charge de **+6 / -3 g** : rare pour un école à moteur à pistons',
  variants_en       = E'- **SF.260M** : military training version, the most widespread\n- **SF.260W Warrior** : armed version with two hardpoints, used in combat\n- **SF.260TP** : **turboprop** conversion, in production since 1980\n- Designed by **Stelio Frati**, an engineer from competition motoring\n- Load factor of **+6 / -3 g**: rare for a piston-engined trainer',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/SIAI-Marchetti_SF.260',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/SIAI-Marchetti_SF.260',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Philippine Air Force',
  image_licence     = 'Public domain'
WHERE name = 'SF.260';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'SF.260';
