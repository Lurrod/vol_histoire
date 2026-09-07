-- Lockheed U-2 Dragon Lady
--
-- Photo : Usaf.u2.750pix.jpg
--   licence Public domain — United States Department of the Air Force
--   https://commons.wikimedia.org/wiki/File%3AUsaf.u2.750pix.jpg

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
    'U-2 Dragon Lady',
    'U-2 Dragon Lady',
    'Lockheed U-2 Dragon Lady',
    'Lockheed U-2 Dragon Lady',
    'Avion espion de très haute altitude, en service depuis 1956',
    'Very high altitude spy plane, in service since 1956',
    '/assets/airplanes/u2-dragon-lady.jpg',
    E'## Genèse\nEn 1953, les États-Unis ne savent presque rien de l''arsenal soviétique. Lockheed **Skunk Works** propose à la CIA un appareil conçu autour d''une seule idée : voler à **21 000 mètres**, au-dessus de la portée de tout intercepteur et de tout missile connu. Le projet passe du contrat au premier vol en huit mois.\n\n## Conception\nC''est un planeur motorisé : 31 mètres d''envergure pour un fuselage étroit, un train d''atterrissage réduit à deux roues en ligne et des balancines largables sous les ailes. À l''altitude de croisière, l''écart entre vitesse de décrochage et vitesse critique se réduit à quelques nœuds — le domaine que les pilotes appellent le *coffin corner*. Le pilote porte une combinaison spatiale intégrale.\n\n## Carrière opérationnelle\nLe **1er mai 1960**, un U-2 piloté par Francis Gary Powers est abattu au-dessus de Sverdlovsk : la crise diplomatique fait capoter le sommet de Paris. Deux ans plus tard, ce sont des clichés d''U-2 qui révèlent les missiles soviétiques à **Cuba** et ouvrent la crise la plus dangereuse de la guerre froide. Il sert ensuite au Vietnam, dans le Golfe, dans les Balkans, en Afghanistan et en Irak.\n\n## Place dans l''histoire\nSept décennies de service, une longévité qu''aucun autre appareil de reconnaissance n''approche. Il a survécu au SR-71 Blackbird, censé le remplacer, et aux drones qui devaient le rendre inutile : son retrait, régulièrement annoncé, est régulièrement repoussé.',
    E'## Genesis\nIn 1953 the United States knew almost nothing about the Soviet arsenal. Lockheed **Skunk Works** offered the CIA an aircraft built around a single idea: fly at **21,000 metres**, above the reach of every known interceptor and missile. The project went from contract to first flight in eight months.\n\n## Design\nIt is a powered glider: a 31-metre span on a narrow fuselage, landing gear reduced to two wheels in line, and jettisonable outrigger pogos under the wings. At cruise altitude the gap between stall speed and critical Mach narrows to a few knots — the regime pilots call *coffin corner*. The pilot wears a full pressure suit.\n\n## Operational career\nOn **1 May 1960** a U-2 flown by Francis Gary Powers was shot down over Sverdlovsk; the ensuing diplomatic crisis wrecked the Paris summit. Two years later U-2 photographs revealed the Soviet missiles in **Cuba** and opened the most dangerous crisis of the Cold War. It went on to serve in Vietnam, the Gulf, the Balkans, Afghanistan and Iraq.\n\n## Place in history\nSeven decades of service, a longevity no other reconnaissance aircraft comes close to. It outlived the SR-71 Blackbird meant to replace it and the drones meant to make it redundant: its retirement, regularly announced, is regularly postponed.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1953-01-01',
    '1955-08-01',
    '1956-06-01',
    805.0,
    10300.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), (SELECT id FROM tech WHERE name = 'Conception aérodynamique pour haute altitude')),
((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.2,
  wingspan          = 31.4,
  height            = 4.88,
  wing_area         = 92.9,
  empty_weight      = 6760,
  mtow              = 18144,
  service_ceiling   = 21300,
  climb_rate        = 46,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4600,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F118-GE-101',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 84.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1989,
  units_built       = 104,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **U-2A/C** : premières versions, moteur J57 puis J75\n- **U-2R** : cellule agrandie de 40 %\n- **U-2S** : version actuelle, moteur F118 et capteurs numériques\n- **TU-2S** : biplace d''entraînement',
  variants_en       = E'- **U-2A/C** : early versions, J57 then J75 engine\n- **U-2R** : 40% larger airframe\n- **U-2S** : current version, F118 engine and digital sensors\n- **TU-2S** : two-seat trainer',

  -- Strate 4 : qualitatif
  nickname          = 'Dragon Lady',

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_U-2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_U-2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'United States Department of the Air Force',
  image_licence     = 'Public domain'
WHERE name = 'U-2 Dragon Lady';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'U-2 Dragon Lady';
