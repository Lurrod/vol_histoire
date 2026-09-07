-- Supermarine Scimitar
--
-- Photo : Scimitars 62.jpg
--   licence CC BY-SA 3.0 — TSRL
--   https://commons.wikimedia.org/wiki/File%3AScimitars_62.jpg

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
    'Supermarine Scimitar',
    'Supermarine Scimitar',
    'Supermarine Scimitar',
    'Supermarine Scimitar',
    'Dernier avion de combat conçu par Supermarine',
    'The last combat aircraft designed by Supermarine',
    '/assets/airplanes/scimitar.jpg',
    E'## Genèse\nLe Scimitar est l''aboutissement d''une décennie de tâtonnements : Supermarine, la maison du Spitfire, enchaîne quatre prototypes très différents entre 1948 et 1956, passant de l''aile droite sans train d''atterrissage — un projet d''appontage sur tapis souple — à un chasseur embarqué conventionnel.\n\n## Conception\nBimoteur massif de quinze tonnes, il est à sa sortie l''avion embarqué le plus lourd de la Royal Navy. Il inaugure sur un appareil britannique le **soufflage de la couche limite** sur les volets, qui abaisse nettement la vitesse d''appontage. Sa mission principale est la frappe nucléaire tactique à basse altitude, contre les navires du Pacte de Varsovie.\n\n## Carrière opérationnelle\nSoixante-seize exemplaires seulement, et une carrière courte : sept ans de première ligne. Le taux d''attrition est sévère — **trente-neuf appareils perdus sur soixante-seize**, plus de la moitié — dans une époque où l''aviation embarquée à réaction se paie encore très cher. Il finit ravitailleur des Buccaneer qui l''ont remplacé.\n\n## Place dans l''histoire\nC''est le dernier avion à porter le nom **Supermarine**, absorbé dans British Aircraft Corporation en 1960. Le Scimitar clôt une lignée qui remonte aux hydravions de course des années 1920 et au Spitfire.',
    E'## Genesis\nThe Scimitar was the outcome of a decade of trial and error: Supermarine, the house of the Spitfire, ran through four very different prototypes between 1948 and 1956, moving from a straight-winged aircraft with no landing gear — a project for landing on a flexible deck — to a conventional carrier fighter.\n\n## Design\nA massive fifteen-tonne twin-engine machine, it was on entry the heaviest carrier aircraft in the Royal Navy. It introduced **boundary layer blowing** over the flaps on a British aircraft, markedly lowering approach speed. Its primary mission was low-level tactical nuclear strike against Warsaw Pact shipping.\n\n## Operational career\nOnly seventy-six built, and a short career: seven years on the front line. Attrition was severe — **thirty-nine aircraft lost out of seventy-six**, more than half — in an era when carrier jet aviation still came at a very high price. It ended its days as a tanker for the Buccaneers that replaced it.\n\n## Place in history\nIt is the last aircraft to carry the **Supermarine** name, absorbed into the British Aircraft Corporation in 1960. The Scimitar closes a line running back to the racing seaplanes of the 1920s and the Spitfire.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1945-01-01',
    '1956-01-19',
    '1958-06-01',
    1143.0,
    2288.0,
    (SELECT id FROM manufacturer WHERE code = 'SUP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Avon')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.87,
  wingspan          = 11.33,
  height            = 4.65,
  wing_area         = 45.06,
  empty_weight      = 10869,
  mtow              = 15513,
  service_ceiling   = 14000,
  climb_rate        = 63,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 970,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Avon 202',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 50.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1960,
  units_built       = 76,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Scimitar F.1** : unique version de série\n- Quatre prototypes successifs (**Type 508, 525, 529, 544**) auront exploré l''empennage papillon puis l''aile en flèche avant d''aboutir\n- Utilisé en fin de carrière comme **ravitailleur** pour les Buccaneer',
  variants_en       = E'- **Scimitar F.1** : the only production version\n- Four successive prototypes (**Types 508, 525, 529, 544**) explored a butterfly tail then a swept wing before the final shape\n- Used late in its career as a **tanker** for the Buccaneer',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Supermarine_Scimitar',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Supermarine_Scimitar',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'TSRL',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Supermarine Scimitar';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Supermarine Scimitar';
