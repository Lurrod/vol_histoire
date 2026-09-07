-- Northrop Grumman E-2 Hawkeye
--
-- Photo : E-2D Advanced Hawkeye aircraft conduct a test flight.jpg
--   licence Public domain — US Navy
--   https://commons.wikimedia.org/wiki/File%3AE-2D_Advanced_Hawkeye_aircraft_conduct_a_test_flight.jpg

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
    'E-2 Hawkeye',
    'E-2 Hawkeye',
    'Northrop Grumman E-2 Hawkeye',
    'Northrop Grumman E-2 Hawkeye',
    'Radar volant embarqué, les yeux du groupe aéronaval',
    'Carrier-borne flying radar, the eyes of the carrier group',
    '/assets/airplanes/e2-hawkeye.jpg',
    E'## Genèse\nUn radar de navire ne voit pas au-delà de l''horizon : une attaque à basse altitude arrive sans préavis. La seule réponse est d''élever le radar. Grumman conçoit dans les années 1950 un appareil entièrement organisé autour de cette contrainte, avec la difficulté supplémentaire de devoir tenir sur un pont de porte-avions.\n\n## Conception\nUn **radôme rotatif de 7,3 mètres** de diamètre monté sur pylône au-dessus du fuselage. Pour rester sous la hauteur des hangars, le radôme s''abaisse ; pour tenir sur l''ascenseur, les ailes se replient en pivotant vers l''arrière le long du fuselage. Quatre dérives compensent la perturbation aérodynamique du radôme tout en limitant la hauteur totale.\n\n## Carrière opérationnelle\nSoixante ans de service continu, de **1964 au Vietnam** — où il dirige les interceptions au-dessus du Tonkin — jusqu''aux opérations actuelles. La France est le seul autre pays à l''exploiter depuis un porte-avions, sur le Charles de Gaulle ; le Japon, Taïwan, l''Égypte et le Mexique l''utilisent depuis la terre.\n\n## Place dans l''histoire\nAucun autre appareil de guet aérien avancé n''a jamais été conçu pour opérer depuis un porte-avions. Le Hawkeye est resté sans concurrent pendant soixante ans, et le E-2D est aujourd''hui le nœud central de la défense antimissile du groupe aéronaval américain.',
    E'## Genesis\nA ship’s radar cannot see beyond the horizon: a low-level attack arrives without warning. The only answer is to raise the radar. In the 1950s Grumman designed an aircraft built entirely around that constraint, with the added difficulty of having to fit on a carrier deck.\n\n## Design\nA **7.3-metre rotating radome** on a pylon above the fuselage. To clear hangar height the radome lowers; to fit the lift the wings fold by pivoting back along the fuselage. Four fins offset the radome’s aerodynamic disturbance while keeping overall height down.\n\n## Operational career\nSixty years of continuous service, from **1964 over Vietnam** — where it directed interceptions over the Gulf of Tonkin — to current operations. France is the only other country to fly it from a carrier, aboard the Charles de Gaulle; Japan, Taiwan, Egypt and Mexico operate it from land.\n\n## Place in history\nNo other airborne early warning aircraft has ever been designed to operate from a carrier. The Hawkeye stood without a competitor for sixty years, and the E-2D is today the central node of the US carrier group’s missile defence.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1956-01-01',
    '1960-10-21',
    '1964-01-19',
    648.0,
    2708.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM tech WHERE name = 'Système de décollage et d''atterrissage sur porte-avions'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.6,
  wingspan          = 24.56,
  height            = 5.58,
  wing_area         = 65.03,
  empty_weight      = 19536,
  mtow              = 26083,
  service_ceiling   = 10576,
  climb_rate        = 13,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1500,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Allison T56-A-427',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1960,
  production_end    = NULL,
  units_built       = 300,
  unit_cost_usd     = 232000000,
  unit_cost_year    = 2019,
  operators_count   = 6,
  variants          = E'- **E-2A / B** : versions initiales, radar APS-96 puis APS-120\n- **E-2C** : version principale, quarante ans de service\n- **E-2D Advanced Hawkeye** : radar APY-9 à balayage électronique, ravitaillable en vol\n- Seul appareil de guet aérien avancé **embarqué** en service dans le monde',
  variants_en       = E'- **E-2A / B** : initial versions with APS-96 then APS-120 radar\n- **E-2C** : main version, forty years of service\n- **E-2D Advanced Hawkeye** : APY-9 electronically scanned radar, air-refuellable\n- The only **carrier-borne** airborne early warning aircraft in service anywhere',

  -- Strate 4 : qualitatif
  nickname          = 'Hummer',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_E-2_Hawkeye',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_Grumman_E-2_Hawkeye',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'US Navy',
  image_licence     = 'Public domain'
WHERE name = 'E-2 Hawkeye';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'E-2 Hawkeye';
