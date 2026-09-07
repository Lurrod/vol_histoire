-- North American T-28 Trojan
--
-- Photo : North American T-28C Trojan and North American T-28B Trojan flying in formation.jpg
--   licence Public domain — Pseudopanax at English Wikipedia
--   https://commons.wikimedia.org/wiki/File%3ANorth_American_T-28C_Trojan_and_North_American_T-28B_Trojan_flying_in_formation.jpg

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
    'T-28 Trojan',
    'T-28 Trojan',
    'North American T-28 Trojan',
    'North American T-28 Trojan',
    'École de pilotage devenue bombardier de contre-guérilla',
    'A flying school aircraft turned counter-insurgency bomber',
    '/assets/airplanes/t28-trojan.jpg',
    E'## Genèse\nLe T-6 Texan a formé une génération entière, mais il a une roulette de queue et les chasseurs modernes n''en ont plus. L''US Air Force veut un école conçu autour du **train tricycle**, pour que l''élève apprenne d''emblée les bons réflexes au roulage et à l''atterrissage. North American, qui avait construit le Texan, construit son remplaçant.\n\n## Conception\nUn moteur en étoile Wright de 800 chevaux à l''origine, porté à 1 425 sur les versions navales, une verrière en trois parties et une structure taillée large. L''appareil est lourd pour un école — près de quatre tonnes — mais cette robustesse va décider de sa seconde vie : il peut encaisser des points d''emport, des munitions et des atterrissages sur piste sommaire.\n\n## Carrière opérationnelle\nMille neuf cent quarante-huit exemplaires. Après quinze ans d''école, le T-28 est armé et envoyé se battre : au **Laos** et au **Vietnam** sous le nom de T-28D Nomad, au **Congo**, et en **Algérie** sous la désignation française de **Fennec**. Vingt-cinq forces aériennes l''exploitent, souvent comme leur seul appareil d''attaque.\n\n## Place dans l''histoire\nMille neuf cent quarante-huit exemplaires. Il ouvre une lignée qui n''a jamais cessé : l''école armé, bon marché, capable d''opérer d''une piste en terre contre un adversaire sans défense aérienne. L''**A-37 Dragonfly**, l''**OV-10 Bronco** et aujourd''hui le **Super Tucano** occupent exactement la même place.',
    E'## Genesis\nThe T-6 Texan trained an entire generation, but it has a tailwheel and modern fighters do not. The US Air Force wanted a trainer designed around the **tricycle undercarriage**, so pupils would learn the right reflexes for taxiing and landing from the start. North American, which had built the Texan, built its replacement.\n\n## Design\nAn 800-horsepower Wright radial originally, raised to 1,425 on the naval versions, a three-piece canopy and a generously built structure. The aircraft is heavy for a trainer — nearly four tonnes — but that ruggedness would decide its second life: it can carry hardpoints, munitions and rough field landings.\n\n## Operational career\nOne thousand nine hundred and forty-eight built. After fifteen years of training the T-28 was armed and sent to fight: over **Laos** and **Vietnam** as the T-28D Nomad, in the **Congo**, and in **Algeria** under the French designation **Fennec**. Twenty-five air forces flew it, often as their only attack aircraft.\n\n## Place in history\nOne thousand nine hundred and forty-eight built. It opened a line that has never closed: the armed trainer, cheap, able to work from a dirt strip against an enemy with no air defence. The **A-37 Dragonfly**, the **OV-10 Bronco** and today the **Super Tucano** occupy exactly the same place.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1948-01-01',
    '1949-09-24',
    '1950-04-01',
    552.0,
    1706.0,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'T-28 Trojan'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'T-28 Trojan'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'T-28 Trojan'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'T-28 Trojan'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'T-28 Trojan'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'T-28 Trojan'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'T-28 Trojan'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'T-28 Trojan'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'T-28 Trojan'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.06,
  wingspan          = 12.22,
  height            = 3.86,
  wing_area         = 24.9,
  empty_weight      = 2914,
  mtow              = 3856,
  service_ceiling   = 10820,
  climb_rate        = 18.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-1820-86 Cyclone',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1950,
  production_end    = 1957,
  units_built       = 1948,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 25,
  variants          = E'- **T-28A** : version USAF, moteur de 800 ch, hélice bipale\n- **T-28B / C** : versions US Navy, moteur de 1 425 ch ; la C reçoit une **crosse d''appontage**\n- **T-28D Nomad** : version armée de contre-guérilla, six points d''emport\n- **Fennec** : version française remotorisée, engagée en **Algérie** de 1960 à 1962\n- Premier appareil américain conçu avec un **train tricycle** pour la formation',
  variants_en       = E'- **T-28A** : USAF version, 800 hp engine, two-blade propeller\n- **T-28B / C** : US Navy versions, 1,425 hp engine; the C fitted with an **arrestor hook**\n- **T-28D Nomad** : armed counter-insurgency version, six hardpoints\n- **Fennec** : re-engined French version, used in **Algeria** from 1960 to 1962\n- The first American aircraft designed with a **tricycle undercarriage** for training',

  -- Strate 4 : qualitatif
  nickname          = 'Trojan',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_T-28_Trojan',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_T-28_Trojan',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Pseudopanax at English Wikipedia',
  image_licence     = 'Public domain'
WHERE name = 'T-28 Trojan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'T-28 Trojan';
