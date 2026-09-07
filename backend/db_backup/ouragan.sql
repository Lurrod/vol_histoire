-- Dassault MD.450 Ouragan
--
-- Photo : Dassault Ouragan.jpg
--   licence Public domain — Groumfy69
--   https://commons.wikimedia.org/wiki/File%3ADassault_Ouragan.jpg

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
    'Ouragan',
    'Ouragan',
    'Dassault MD.450 Ouragan',
    'Dassault MD.450 Ouragan',
    'Premier avion de combat à réaction français, fondateur de Dassault',
    'First French jet combat aircraft, the founding Dassault design',
    '/assets/airplanes/ouragan.jpg',
    E'## Genèse\nEn 1947, l''industrie aéronautique française est à reconstruire entièrement. **Marcel Dassault**, rentré de Buchenwald deux ans plus tôt, lance sur fonds propres un chasseur à réaction simple, sans commande de l''État. Le premier vol a lieu en 1949 ; la commande suivra.\n\n## Conception\nAile droite, entrée d''air frontale, réacteur Nene britannique construit sous licence : rien d''innovant, et c''est délibéré. L''Ouragan est conçu pour être **fabricable** par une industrie qui repart de zéro, et réparable par des mécaniciens formés sur des avions à hélice. Il vole à 940 km/h quand les meilleurs chasseurs du monde approchent de Mach 1.\n\n## Carrière opérationnelle\nL''armée de l''air l''engage en **Algérie**. Israël en achète 75 et les utilise en 1956 à Suez puis en 1967, où des Ouragan obsolètes détruisent des blindés égyptiens dans le Sinaï. L''Inde en aligne 104 sous le nom de **Toofani**, engagés contre le Pakistan en 1965.\n\n## Place dans l''histoire\nL''Ouragan est le point zéro de la lignée qui mène au Rafale. Il inaugure la méthode Dassault — cellule simple, autofinancement, export précoce, itérations rapides — dont sortiront le **Mystère IV**, le Super Mystère puis le Mirage III en moins de dix ans.',
    E'## Genesis\nIn 1947 the French aviation industry had to be rebuilt from nothing. **Marcel Dassault**, back from Buchenwald two years earlier, privately launched a simple jet fighter with no state order. It first flew in 1949; the order followed.\n\n## Design\nA straight wing, a nose intake, a British Nene engine built under licence: nothing innovative, and deliberately so. The Ouragan was designed to be **manufacturable** by an industry starting from scratch, and repairable by mechanics trained on piston aircraft. It flew at 940 km/h when the world’s best fighters were approaching Mach 1.\n\n## Operational career\nThe French Air Force flew it in **Algeria**. Israel bought 75 and used them at Suez in 1956 and then in 1967, where obsolete Ouragans destroyed Egyptian armour in the Sinai. India fielded 104 as the **Toofani**, committed against Pakistan in 1965.\n\n## Place in history\nThe Ouragan is point zero of the line leading to the Rafale. It established the Dassault method — simple airframe, self-funding, early export, fast iteration — which produced the **Mystère IV**, the Super Mystère and then the Mirage III in under ten years.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1947-01-01',
    '1949-02-28',
    '1952-01-01',
    940.0,
    1000.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie')),
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Ouragan'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.74,
  wingspan          = 13.16,
  height            = 4.15,
  wing_area         = 23.8,
  empty_weight      = 4142,
  mtow              = 7900,
  service_ceiling   = 13000,
  climb_rate        = 38,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 450,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Hispano-Suiza Nene 104B',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 22.3,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1954,
  units_built       = 350,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **MD.450 Ouragan** : version de série de l''armée de l''air française\n- **Toofani** : désignation indienne (« tempête »), 104 exemplaires\n- Revendus par Israël au **Salvador** en 1975, derniers exemplaires en service\n- Motorisé par un **Rolls-Royce Nene** construit sous licence par Hispano-Suiza',
  variants_en       = E'- **MD.450 Ouragan** : French Air Force production version\n- **Toofani** : Indian designation (“storm”), 104 aircraft\n- Resold by Israel to **El Salvador** in 1975, the last examples in service\n- Powered by a **Rolls-Royce Nene** licence-built by Hispano-Suiza',

  -- Strate 4 : qualitatif
  nickname          = 'Toofani',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_Ouragan',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_Ouragan',
  youtube_showcase  = NULL,
  manufacturer_page = 'https://www.dassault-aviation.com/fr/passion/avions/',
  image_credit      = 'Groumfy69',
  image_licence     = 'Public domain'
WHERE name = 'Ouragan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Ouragan';
