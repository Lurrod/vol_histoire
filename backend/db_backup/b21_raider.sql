-- Northrop Grumman B-21 Raider
--
-- Photo : B-21-in-flight.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3AB-21-in-flight.jpg

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
    'B-21 Raider',
    'B-21 Raider',
    'Northrop Grumman B-21 Raider',
    'Northrop Grumman B-21 Raider',
    'Bombardier furtif de sixième génération, premier vol en 2023',
    'Sixth-generation stealth bomber, first flight in 2023',
    '/assets/airplanes/b21-raider.jpg',
    E'## Genèse\nLe B-2 Spirit s''est arrêté à **21 exemplaires** au lieu des 132 prévus : la fin de la guerre froide et un coût unitaire dépassant deux milliards de dollars ont eu raison du programme. Le B-21 en tire la leçon inverse : viser un appareil moins ambitieux mais **produit en nombre**, au moins cent exemplaires, à un coût unitaire tenu contractuellement.\n\n## Conception\nAile volante sans dérive, comme le B-2, mais plus petite et aux entrées d''air mieux enterrées. L''architecture logicielle est ouverte, conçue pour être mise à jour comme un système informatique plutôt que refondue tous les vingt ans. L''appareil est prévu pour voler **avec ou sans équipage** selon la mission — une première pour un bombardier stratégique.\n\n## Carrière opérationnelle\nDévoilé publiquement en décembre 2022, premier vol le **10 novembre 2023** depuis Palmdale. Les essais se poursuivent à Edwards ; l''entrée en service est visée pour la fin de la décennie, à la base d''Ellsworth. Aucun engagement opérationnel à ce jour.\n\n## Place dans l''histoire\nPremier bombardier américain conçu depuis trente ans, et premier appareil de combat pensé dès le départ pour un pilotage optionnel. Son enjeu réel n''est pas technique mais industriel : démontrer qu''un programme furtif peut tenir son coût — ce qu''aucun de ses prédécesseurs, du B-2 au F-35, n''a réussi.',
    E'## Genesis\nThe B-2 Spirit stopped at **21 aircraft** instead of the planned 132: the end of the Cold War and a unit cost above two billion dollars killed the programme. The B-21 draws the opposite lesson: aim for a less ambitious aircraft but one **built in numbers**, at least a hundred, at a contractually capped unit cost.\n\n## Design\nA tailless flying wing like the B-2, but smaller and with better-buried intakes. Its software architecture is open, designed to be updated like a computer system rather than rebuilt every twenty years. The aircraft is intended to fly **with or without a crew** depending on the mission — a first for a strategic bomber.\n\n## Operational career\nPublicly unveiled in December 2022, first flight on **10 November 2023** from Palmdale. Testing continues at Edwards; entry into service is targeted for the end of the decade at Ellsworth Air Force Base. No operational commitment to date.\n\n## Place in history\nThe first American bomber designed in thirty years, and the first combat aircraft conceived from the start for optional crewing. Its real stake is industrial rather than technical: proving that a stealth programme can hold its cost — which none of its predecessors, from the B-2 to the F-35, managed.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2011-01-01',
    '2023-11-10',
    NULL,
    1000.0,
    9600.0,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-21 Raider'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'B-21 Raider'), (SELECT id FROM tech WHERE name = 'Soute à armement pressurisée')),
((SELECT id FROM airplanes WHERE name = 'B-21 Raider'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'B-21 Raider'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-21 Raider'), (SELECT id FROM armement WHERE name = 'B61')),
((SELECT id FROM airplanes WHERE name = 'B-21 Raider'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'B-21 Raider'), (SELECT id FROM armement WHERE name = 'AGM-158 JASSM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-21 Raider'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'B-21 Raider'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'B-21 Raider'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney PW9000 (non confirmé)',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux sans postcombustion',
  engine_type_en    = 'Non-afterburning turbofan',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2022,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = 692000000,
  unit_cost_year    = 2010,
  operators_count   = 1,
  variants          = E'- **B-21 Raider** : version unique annoncée, au moins 100 exemplaires prévus\n- Conçu dès l''origine comme plateforme **optionnellement pilotée**\n- Nommé en hommage aux **Doolittle Raiders**, le raid sur Tokyo d''avril 1942\n\n*Programme classifié : dimensions, masses et performances ne sont pas publiées. Les valeurs de vitesse et de portée données ici sont des estimations de sources ouvertes ; les champs non documentés sont laissés vides plutôt qu''estimés.*',
  variants_en       = E'- **B-21 Raider** : the only announced version, at least 100 aircraft planned\n- Designed from the outset as an **optionally crewed** platform\n- Named after the **Doolittle Raiders**, the April 1942 raid on Tokyo\n\n*Classified programme: dimensions, weights and performance are unpublished. The speed and range figures given here are open-source estimates; undocumented fields are left empty rather than estimated.*',

  -- Strate 4 : qualitatif
  nickname          = 'Raider',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_Grumman_B-21_Raider',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_Grumman_B-21_Raider',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'B-21 Raider';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'tres_elevee' WHERE name = 'B-21 Raider';
