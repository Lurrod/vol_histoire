-- Boeing E-7 Wedgetail
--
-- Photo : Royal Australian Air Force E-7A at Red Flag Feb 2013.jpg
--   licence Public domain — Lawrence Crespo, U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Royal_Australian_Air_Force_E-7A_at_Red_Flag_Feb_2013.jpg

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
    'Boeing E-7 Wedgetail',
    'Boeing E-7 Wedgetail',
    'Boeing E-7A Wedgetail (737 AEW&C)',
    'Boeing E-7A Wedgetail (737 AEW&C)',
    'Un radar à balayage électronique fixé sur le dos d’un Boeing 737 : le successeur de l’E-3',
    'An electronically scanned radar fixed to the back of a Boeing 737: the E-3’s successor',
    '/assets/airplanes/e7-wedgetail.jpg',
    E'## Genèse\nÀ la fin des années 1990, l''Australie veut se doter d''un avion de guet aérien pour surveiller les immenses approches maritimes et aériennes du pays. Le projet **Wedgetail**, du nom de l''aigle australien, est attribué à **Boeing** en 1999. Plutôt qu''un radar tournant sous un champignon, comme sur l''**E-3 Sentry**, Boeing propose une antenne fixe à balayage électronique montée sur un Boeing 737-700 de ligne, plus économique à l''achat comme à l''usage.\n\n## Conception\nLe radar **MESA** (*Multi-role Electronically Scanned Array*) de Northrop Grumman occupe une poutre dorsale surnommée la « planche de surf ». Ses antennes latérales et son « chapeau » couvrent les quatre secteurs ; le faisceau, orienté électroniquement, peut s''attarder sur une zone ou suivre de nombreuses cibles à la fois, à plus de 600 kilomètres selon le constructeur. Deux réacteurs **CFM56-7B** de 121 kN, un réceptacle de ravitaillement en vol et une cabine de consoles complètent l''ensemble. La cellule est celle du 737 civil, renforcée.\n\n## Carrière opérationnelle\nPremier vol de l''appareil équipé le **20 mai 2004**. Le développement du radar et des logiciels prend des années de retard : les deux premiers avions ne sont livrés à la RAAF qu''en novembre 2009, la capacité opérationnelle initiale est déclarée en novembre 2012 et la capacité complète en mai 2015. L''E-7 est engagé dès octobre 2014 au-dessus de l''Irak puis de la **Syrie** contre l''État islamique. La Turquie (quatre *Peace Eagle*) et la Corée du Sud (quatre *Peace Eye*) l''achètent, puis le Royaume-Uni, qui retire ses E-3 en 2021 et voit arriver ses premiers E-7 au milieu des années 2020. En 2022, l''US Air Force le choisit pour remplacer ses E-3 ; en 2025, le Pentagone propose d''abandonner le programme au profit de l''E-2D, le Congrès s''y oppose, et le développement de deux prototypes américains se poursuit en 2026. La commande de série reste, à la date de rédaction, incertaine.\n\n## Place dans l''histoire\nL''E-7 a montré qu''un avion de ligne de taille moyenne et un radar à antenne fixe pouvaient remplacer la génération des grands radars tournants. Il fait face à l''**A-50** russe et au **Saab GlobalEye** suédois, qui suit la même logique sur un avion d''affaires.',
    E'## Genesis\nIn the late 1990s Australia sought an airborne early warning aircraft to watch the country''s immense sea and air approaches. Project **Wedgetail**, named after the Australian eagle, was awarded to **Boeing** in 1999. Rather than a rotating radar under a mushroom, as on the **E-3 Sentry**, Boeing offered a fixed electronically scanned antenna mounted on a Boeing 737-700 airliner, cheaper both to buy and to operate.\n\n## Design\nNorthrop Grumman''s **MESA** (*Multi-role Electronically Scanned Array*) radar occupies a dorsal beam nicknamed the "surfboard". Its side arrays and "top hat" cover all four sectors; the electronically steered beam can dwell on an area or track many targets at once, at more than 600 kilometres according to the manufacturer. Two 121 kN **CFM56-7B** engines, an air-refuelling receptacle and a cabin of consoles complete the aircraft. The airframe is the civil 737''s, strengthened.\n\n## Operational career\nFirst flight of the equipped aircraft on **20 May 2004**. Development of the radar and software ran years late: the first two aircraft were only delivered to the RAAF in November 2009, initial operational capability was declared in November 2012 and full capability in May 2015. The E-7 was committed from October 2014 over Iraq and then **Syria** against the Islamic State. Turkey (four *Peace Eagle*) and South Korea (four *Peace Eye*) bought it, then the United Kingdom, which retired its E-3s in 2021 and saw its first E-7s arrive in the mid-2020s. In 2022 the US Air Force chose it to replace its E-3s; in 2025 the Pentagon proposed abandoning the programme in favour of the E-2D, Congress opposed it, and development of two American prototypes continued in 2026. A production order remains, at the time of writing, uncertain.\n\n## Place in history\nThe E-7 showed that a medium-sized airliner and a fixed-array radar could replace the generation of large rotating radars. It faces the Russian **A-50** and Sweden''s **Saab GlobalEye**, which follows the same logic on a business jet.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1999-01-01',
    '2004-05-20',
    '2012-11-01',
    NULL,
    6500.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 33.6,
  wingspan          = 35.8,
  height            = 12.5,
  wing_area         = 124.6,
  empty_weight      = 46606,
  mtow              = 77600,
  service_ceiling   = 12500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'CFM International CFM56-7B27A',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 121.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **E-7A Wedgetail** : six appareils de la Royal Australian Air Force\n- **E-7T Peace Eagle** : quatre appareils pour la Turquie\n- **Peace Eye** : quatre appareils pour la Corée du Sud\n- **Wedgetail AEW1** : version britannique, remplaçante de l''**E-3D Sentry** retiré en 2021\n- **E-7A américain** : deux prototypes en développement pour l''US Air Force, commande de série incertaine',
  variants_en       = E'- **E-7A Wedgetail** : six aircraft for the Royal Australian Air Force\n- **E-7T Peace Eagle** : four aircraft for Turkey\n- **Peace Eye** : four aircraft for South Korea\n- **Wedgetail AEW1** : British version, replacing the **E-3D Sentry** retired in 2021\n- **American E-7A** : two prototypes in development for the US Air Force, production order uncertain',

  -- Strate 4 : qualitatif
  nickname          = 'Wedgetail',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_737_AEW%26C',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_E-7_Wedgetail',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Lawrence Crespo, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Boeing E-7 Wedgetail';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing E-7 Wedgetail';
