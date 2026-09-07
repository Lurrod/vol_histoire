-- General Atomics MQ-1 Predator
--
-- Photo : RQ-1 Predator in flight near USS Carl Vinson (CVN-70) 951205-N-3149J-006.jpg
--   licence Public domain — Petty Officer 3rd Class Jeffrey S. Viano, U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3ARQ-1_Predator_in_flight_near_USS_Carl_Vinson_%28CVN-70%29_951205-N-3149J-006.jpg

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
    'MQ-1 Predator',
    'MQ-1 Predator',
    'General Atomics MQ-1 Predator',
    'General Atomics MQ-1 Predator',
    'Le drone qui a rendu la frappe permanente et le pilote invisible',
    'The drone that made the strike permanent and the pilot invisible',
    '/assets/airplanes/mq1-predator.jpg',
    E'## Genèse\nLe Predator naît d''une commande de la DARPA en 1993, pour la surveillance des Balkans. L''exigence est simple et nouvelle : **rester en l''air vingt-quatre heures** au-dessus d''un point donné, quelque chose qu''aucun appareil piloté ne peut faire. Un moteur d''ULM, une immense aile fine et aucun équipage à ménager suffisent.\n\n## Conception\nUne tonne à pleine charge, quinze mètres d''envergure, un moteur **Rotax** de motoneige et une hélice propulsive. Le trait décisif n''est pas la cellule mais la **liaison satellite** : l''appareil est piloté depuis une base du Nevada, à onze mille kilomètres, par un équipage qui rentre dîner chez lui. En 2001, on lui ajoute deux missiles **Hellfire** — et le drone d''observation devient une arme.\n\n## Carrière opérationnelle\nTrois cent soixante exemplaires. Engagé en Bosnie, au Kosovo, en Afghanistan, en Irak, au Yémen, en Somalie, au Pakistan. La première frappe létale d''un drone armé a lieu le **4 février 2002** en Afghanistan. En quinze ans, le Predator et son successeur transforment la conduite des opérations américaines — et ouvrent un débat juridique et moral qui n''est pas clos.\n\n## Place dans l''histoire\nTrois cent soixante exemplaires, retiré en 2018. Aucun appareil de ce catalogue n''a changé davantage la pratique de la guerre pour un si faible tonnage. Son successeur, le **MQ-9 Reaper**, est deux fois plus lourd et emporte quinze fois plus ; la logique, elle, n''a pas changé.',
    E'## Genesis\nThe Predator came from a 1993 DARPA order for surveillance of the Balkans. The requirement was simple and new: **stay airborne for twenty-four hours** over a given point, something no piloted aircraft can do. A microlight engine, a huge slender wing and no crew to consider were enough.\n\n## Design\nA tonne fully loaded, fifteen metres of span, a **Rotax** snowmobile engine and a pusher propeller. The decisive feature is not the airframe but the **satellite link**: the aircraft is flown from a base in Nevada, eleven thousand kilometres away, by a crew that goes home for dinner. In 2001 two **Hellfire** missiles were added — and the observation drone became a weapon.\n\n## Operational career\nThree hundred and sixty built. Used over Bosnia, Kosovo, Afghanistan, Iraq, Yemen, Somalia and Pakistan. The first lethal strike by an armed drone took place on **4 February 2002** in Afghanistan. In fifteen years the Predator and its successor transformed the conduct of American operations — and opened a legal and moral debate that is not closed.\n\n## Place in history\nThree hundred and sixty built, retired in 2018. No aircraft in this catalogue changed the practice of war more for so little tonnage. Its successor, the **MQ-9 Reaper**, is twice as heavy and carries fifteen times as much; the logic has not changed.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1993-01-01',
    '1994-07-03',
    '1995-07-01',
    217.0,
    1240.0,
    (SELECT id FROM manufacturer WHERE code = 'GA'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-1 Predator'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-1 Predator'), (SELECT id FROM armement WHERE name = 'AGM-114 Hellfire'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-1 Predator'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'MQ-1 Predator'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-1 Predator'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.22,
  wingspan          = 14.8,
  height            = 2.1,
  wing_area         = 11.45,
  empty_weight      = 512,
  mtow              = 1020,
  service_ceiling   = 7620,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 740,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rotax 914F',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1995,
  production_end    = 2011,
  units_built       = 360,
  unit_cost_usd     = 4000000,
  unit_cost_year    = 2011,
  operators_count   = 5,
  variants          = E'- **RQ-1** : version de reconnaissance pure, désignation d''origine\n- **MQ-1B** : version armée de deux **AGM-114 Hellfire**, redésignée en 2002\n- **MQ-1C Gray Eagle** : version agrandie de l''US Army, toujours en service\n- Endurance de **vingt-quatre heures**, pilotée depuis le Nevada par liaison satellite\n- Retiré par l''US Air Force en **2018** au profit du **MQ-9 Reaper**',
  variants_en       = E'- **RQ-1** : pure reconnaissance version, the original designation\n- **MQ-1B** : armed with two **AGM-114 Hellfires**, redesignated in 2002\n- **MQ-1C Gray Eagle** : enlarged US Army version, still in service\n- **Twenty-four hour** endurance, flown from Nevada over a satellite link\n- Retired by the US Air Force in **2018** in favour of the **MQ-9 Reaper**',

  -- Strate 4 : qualitatif
  nickname          = 'Predator',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/General_Atomics_MQ-1_Predator',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/General_Atomics_MQ-1_Predator',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Petty Officer 3rd Class Jeffrey S. Viano, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'MQ-1 Predator';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MQ-1 Predator';
