-- General Atomics MQ-9 Reaper
--
-- Photo : MQ-9 Reaper UAV (cropped).jpg
--   licence Public domain — Lt. Col. Leslie Pratt
--   https://commons.wikimedia.org/wiki/File%3AMQ-9_Reaper_UAV_%28cropped%29.jpg

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
    'MQ-9 Reaper',
    'MQ-9 Reaper',
    'General Atomics MQ-9 Reaper',
    'General Atomics MQ-9 Reaper',
    'Drone armé de moyenne altitude et longue endurance',
    'Armed medium-altitude, long-endurance drone',
    '/assets/airplanes/mq9-reaper.jpg',
    E'## Genèse\nLe MQ-1 Predator, drone de surveillance, avait reçu des missiles Hellfire en 2001 dans l''urgence. Le Reaper est la première machine **conçue dès l''origine pour frapper** : moteur huit fois plus puissant, charge utile quinze fois supérieure, structure prévue pour l''emport externe.\n\n## Conception\nAile de vingt mètres pour une masse de moins de cinq tonnes, turbopropulseur en configuration propulsive, empennage en V inversé. Il n''y a personne à bord : deux opérateurs le pilotent depuis une station au sol, souvent située sur un autre continent, via une liaison satellite. L''endurance atteint **quinze heures** en configuration armée, sans commune mesure avec un appareil habité.\n\n## Carrière opérationnelle\nAfghanistan, Irak, Libye, Syrie, Sahel, Yémen : le Reaper devient l''outil central des campagnes de frappes ciblées des années 2010. Une dizaine de pays l''exploitent, dont la France, le Royaume-Uni et l''Italie. Sa vulnérabilité en espace aérien contesté est apparue crûment lors des pertes face aux défenses sol-air en Libye et au Yémen.\n\n## Place dans l''histoire\nLe Reaper a déplacé la question du combat aérien du domaine technique au domaine juridique et politique : qui décide, depuis où, avec quelle responsabilité. Aucun appareil de cette encyclopédie n''a suscité autant de débat public pour aussi peu de performances.',
    E'## Genesis\nThe MQ-1 Predator, a surveillance drone, had been given Hellfire missiles in 2001 as an emergency measure. The Reaper is the first machine **designed from the outset to strike**: eight times the engine power, fifteen times the payload, a structure built for external carriage.\n\n## Design\nA twenty-metre wing for a mass under five tonnes, a pusher turboprop, an inverted V-tail. There is nobody aboard: two operators fly it from a ground station, often on another continent, over a satellite link. Endurance reaches **fifteen hours** when armed, beyond anything a manned aircraft can offer.\n\n## Operational career\nAfghanistan, Iraq, Libya, Syria, the Sahel, Yemen: the Reaper became the central tool of the targeted strike campaigns of the 2010s. Around ten countries operate it, including France, the United Kingdom and Italy. Its vulnerability in contested airspace showed starkly in losses to surface-to-air defences in Libya and Yemen.\n\n## Place in history\nThe Reaper moved the question of air combat from the technical domain to the legal and political one: who decides, from where, with what accountability. No aircraft in this encyclopedia has provoked so much public debate for so little performance.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1998-01-01',
    '2001-02-02',
    '2007-05-01',
    482.0,
    1900.0,
    (SELECT id FROM manufacturer WHERE code = 'GA'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM tech WHERE name = 'Pod désignateur laser'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM armement WHERE name = 'AGM-114 Hellfire')),
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM armement WHERE name = 'GBU-38 JDAM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.0,
  wingspan          = 20.12,
  height            = 3.81,
  wing_area         = NULL,
  empty_weight      = 2223,
  mtow              = 4760,
  service_ceiling   = 15420,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1850,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Honeywell TPE331-10',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2001,
  production_end    = NULL,
  units_built       = 400,
  unit_cost_usd     = 32000000,
  unit_cost_year    = 2021,
  operators_count   = 8,
  variants          = E'- **MQ-9A** : version de base, quinze heures d''endurance en configuration armée\n- **MQ-9B SkyGuardian / SeaGuardian** : certifié pour l''espace aérien civil, endurance portée à 40 heures\n- **MQ-1 Predator** : prédécesseur plus léger, retiré en 2018\n\n*Aucun équipage embarqué : l''appareil est piloté depuis une station au sol.*',
  variants_en       = E'- **MQ-9A** : baseline version, fifteen hours endurance when armed\n- **MQ-9B SkyGuardian / SeaGuardian** : certified for civil airspace, endurance raised to 40 hours\n- **MQ-1 Predator** : lighter predecessor, retired in 2018\n\n*No onboard crew: the aircraft is flown from a ground station.*',

  -- Strate 4 : qualitatif
  nickname          = 'Reaper',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/General_Atomics_MQ-9_Reaper',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/General_Atomics_MQ-9_Reaper',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Lt. Col. Leslie Pratt',
  image_licence     = 'Public domain'
WHERE name = 'MQ-9 Reaper';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MQ-9 Reaper';
