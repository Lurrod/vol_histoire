-- General Atomics MQ-1C Gray Eagle
--
-- Photo : MFEW-AL.jpg
--   licence Public domain — John Higgins
--   https://commons.wikimedia.org/wiki/File:MFEW-AL.jpg

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
    'MQ-1C Gray Eagle',
    'MQ-1C Gray Eagle',
    'General Atomics MQ-1C Gray Eagle',
    'General Atomics MQ-1C Gray Eagle',
    'Le Predator de l’armée de terre américaine, au service direct des troupes au sol',
    'The US Army’s Predator, working directly for the troops on the ground',
    '/assets/airplanes/mq1c-gray-eagle.jpg',
    E'## Genèse\nAu début des années 2000, l''US Army veut ses propres drones armés de longue endurance, plutôt que de dépendre des **MQ-1 Predator** de l''US Air Force, dont l''emploi se négocie loin du terrain. En 2002, elle lance le programme ERMP (*Extended Range Multi-Purpose*) pour remplacer ses RQ-5 Hunter. En août 2005, **General Atomics** l''emporte avec le Warrior, un Predator agrandi, devant un dérivé du Hunter proposé par IAI et Northrop Grumman. L''appareil devient le MQ-1C Gray Eagle.\n\n## Conception\nLa silhouette est celle du Predator — fuselage effilé, longue aile droite de 17 mètres, hélice propulsive —, mais l''appareil est plus lourd, avec une masse maximale de 1 633 kg. Il reçoit un moteur diesel **Thielert Centurion** de 123 kW fonctionnant au carburant lourd, le même que celui des véhicules et hélicoptères de l''armée, ce qui simplifie la logistique sur le terrain. L''endurance atteint vingt-cinq heures et le plafond 8 800 mètres. Le décollage et l''atterrissage sont automatiques, ce qui permet de confier la mise en œuvre à des soldats plutôt qu''à des pilotes. Il emporte quatre missiles **AGM-114 Hellfire**.\n\n## Carrière opérationnelle\nLes premiers exemplaires sont déployés en **Irak** en 2009, puis en **Afghanistan**, sous forme de détachements d''urgence avant même la fin des essais. Chaque division de l''armée reçoit ensuite une compagnie de Gray Eagle, intégrée à sa brigade d''aviation, qui travaille directement pour les commandants au sol et les hélicoptères d''attaque AH-64 Apache. Environ deux cents appareils sont construits. En avril 2025, le secrétaire à la Défense ordonne à l''armée de cesser d''acheter des systèmes jugés dépassés ; l''US Army annonce dans la foulée l''arrêt des commandes de Gray Eagle.\n\n## Place dans l''histoire\nLe Gray Eagle a fait passer le drone armé d''outil stratégique, piloté de loin par l''aviation, à arme organique d''une division terrestre. Il est le dernier représentant de la lignée du **MQ-1 Predator** en service américain, l''US Air Force étant passée au **MQ-9 Reaper**, plus lourd. Sa fin de commande illustre le doute qui pèse désormais sur les drones MALE lents face à un adversaire équipé.',
    E'## Genesis\nIn the early 2000s the US Army wanted its own long-endurance armed drones, rather than depend on US Air Force **MQ-1 Predators**, whose use was negotiated far from the field. In 2002 it launched the ERMP (*Extended Range Multi-Purpose*) programme to replace its RQ-5 Hunters. In August 2005 **General Atomics** won with the Warrior, an enlarged Predator, ahead of a Hunter derivative offered by IAI and Northrop Grumman. The aircraft became the MQ-1C Gray Eagle.\n\n## Design\nThe silhouette is the Predator''s — slender fuselage, long 17-metre straight wing, pusher propeller — but the aircraft is heavier, with a maximum weight of 1,633 kg. It received a 123 kW **Thielert Centurion** diesel engine running on heavy fuel, the same fuel as the army''s vehicles and helicopters, which simplifies logistics in the field. Endurance reaches twenty-five hours and the ceiling 8,800 metres. Take-off and landing are automatic, so operation can be entrusted to soldiers rather than pilots. It carries four **AGM-114 Hellfire** missiles.\n\n## Operational career\nThe first aircraft were deployed to **Iraq** in 2009, then to **Afghanistan**, as urgent detachments even before testing was complete. Each army division then received a Gray Eagle company, integrated into its aviation brigade, working directly for ground commanders and AH-64 Apache attack helicopters. Around two hundred were built. In April 2025 the Secretary of Defense ordered the army to stop buying systems deemed obsolete; the US Army then announced it would stop ordering Gray Eagles.\n\n## Place in history\nThe Gray Eagle turned the armed drone from a strategic tool, flown remotely by the air force, into an organic weapon of a land division. It is the last member of the **MQ-1 Predator** line in American service, the US Air Force having moved on to the heavier **MQ-9 Reaper**. The end of its procurement illustrates the doubt now hanging over slow MALE drones facing a well-equipped opponent.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2002-01-01',
    NULL,
    '2009-01-01',
    309.0,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'GA'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-1C Gray Eagle'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'MQ-1C Gray Eagle'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'MQ-1C Gray Eagle'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-1C Gray Eagle'), (SELECT id FROM armement WHERE name = 'AGM-114 Hellfire'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-1C Gray Eagle'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'MQ-1C Gray Eagle'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'MQ-1C Gray Eagle'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-1C Gray Eagle'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'MQ-1C Gray Eagle'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.53,
  wingspan          = 17.0,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 1633,
  service_ceiling   = 8840,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Thielert Centurion 1.7 HFE',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Warrior** : proposition de General Atomics retenue en août 2005 pour le programme ERMP\n- **MQ-1C Gray Eagle** : version de série de l''US Army, quatre **AGM-114 Hellfire**\n- **Gray Eagle ER** : version à endurance et distance franchissable accrues\n- Moteur diesel au **carburant lourd**, commun aux véhicules de l''armée\n- Commandes arrêtées par l''US Army en **2025**',
  variants_en       = E'- **Warrior** : General Atomics proposal selected in August 2005 for the ERMP programme\n- **MQ-1C Gray Eagle** : US Army production version, four **AGM-114 Hellfires**\n- **Gray Eagle ER** : version with greater endurance and range\n- **Heavy-fuel** diesel engine, shared with the army''s vehicles\n- Orders stopped by the US Army in **2025**',

  -- Strate 4 : qualitatif
  nickname          = 'Gray Eagle',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/General_Atomics_MQ-1C_Gray_Eagle',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'John Higgins',
  image_licence     = 'Public domain'
WHERE name = 'MQ-1C Gray Eagle';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MQ-1C Gray Eagle';
