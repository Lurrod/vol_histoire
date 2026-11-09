-- Boeing Australia MQ-28 Ghost Bat
--
-- Photo : MQ-28 Ghost Bat performs a flyover during Exercise Valiant Shield 2026.jpg
--   licence Public domain — Senior Airman Adrien Tran, U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:MQ-28_Ghost_Bat_performs_a_flyover_during_Exercise_Valiant_Shield_2026.jpg

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
    'MQ-28 Ghost Bat',
    'MQ-28 Ghost Bat',
    'Boeing Australia MQ-28A Ghost Bat',
    'Boeing Australia MQ-28A Ghost Bat',
    'L’ailier sans pilote australien, premier avion de combat conçu au pays depuis un demi-siècle',
    'Australia’s uncrewed wingman, the first combat aircraft designed there in half a century',
    '/assets/airplanes/mq28-ghost-bat.jpg',
    E'## Genèse\nÀ la fin des années 2010, l''aviation australienne cherche à multiplier ses capteurs et ses armes sans multiplier ses pilotes, ressource la plus rare d''une petite force aérienne chargée d''un immense espace. **Boeing Australia** présente le 27 février 2019, au salon d''Avalon, la maquette d''un « ailier fidèle » (*loyal wingman*) développé avec la Royal Australian Air Force : un appareil sans équipage, peu coûteux, destiné à voler aux côtés des F-35, des Super Hornet et des E-7.\n\n## Conception\nUne cellule de 11,7 mètres aux formes de chasseur, un turboréacteur double flux d''origine civile et un **nez modulaire** que l''on remplace en quelques minutes pour changer de mission : capteurs de renseignement, guerre électronique ou armement. Boeing annonce une distance franchissable de plus de 2 000 milles nautiques (3 700 km) et des performances proches de celles d''un chasseur, sans publier de vitesse précise. L''appareil se commande par liaison de données depuis un avion piloté ou une station au sol, avec une large part d''autonomie.\n\n## Carrière opérationnelle\nPremier vol le **27 février 2021** au champ de tir de Woomera, deux ans jour pour jour après sa présentation. La désignation **MQ-28A Ghost Bat**, du nom d''une chauve-souris australienne, est officialisée en mars 2022. Huit exemplaires du Block 1 accumulent les essais, y compris en équipe avec des avions pilotés. Le 8 décembre 2025, selon le ministère australien de la Défense, un Ghost Bat tire un missile **AIM-120 AMRAAM** qui détruit un drone-cible. Le même mois, Canberra commande six appareils Block 2 de série ; la capacité opérationnelle est visée pour 2028.\n\n## Place dans l''histoire\nSelon la RAAF, le Ghost Bat est le premier avion de combat conçu et construit en Australie depuis plus de cinquante ans ; il renoue, à une tout autre échelle, avec la tradition australienne de l''avion sans pilote ouverte par le drone-cible **GAF Jindivik**. Avec le **XQ-58 Valkyrie** américain et le **Bayraktar Kızılelma** turc, il incarne la doctrine de l''ailier sans pilote, dont aucune armée n''a encore prouvé la valeur au combat.',
    E'## Genesis\nIn the late 2010s the Australian air force sought to multiply its sensors and weapons without multiplying its pilots, the scarcest resource of a small air arm responsible for an immense area. On 27 February 2019, at the Avalon air show, **Boeing Australia** unveiled the mock-up of a "loyal wingman" developed with the Royal Australian Air Force: an uncrewed, low-cost aircraft meant to fly alongside F-35s, Super Hornets and E-7s.\n\n## Design\nAn 11.7-metre airframe with fighter-like lines, a turbofan of civil origin and a **modular nose** that can be swapped in minutes to change mission: intelligence sensors, electronic warfare or weapons. Boeing quotes a range of more than 2,000 nautical miles and fighter-like performance, without publishing a precise speed. The aircraft is controlled over a data link from a crewed aircraft or a ground station, with a large degree of autonomy.\n\n## Operational career\nFirst flight on **27 February 2021** at the Woomera range, two years to the day after its unveiling. The designation **MQ-28A Ghost Bat**, after an Australian bat, was made official in March 2022. Eight Block 1 aircraft carried out the trials, including teaming with crewed aircraft. On 8 December 2025, according to the Australian Department of Defence, a Ghost Bat fired an **AIM-120 AMRAAM** missile that destroyed a target drone. The same month Canberra ordered six production Block 2 aircraft; operational capability is targeted for 2028.\n\n## Place in history\nAccording to the RAAF, the Ghost Bat is the first combat aircraft designed and built in Australia in more than fifty years; on an entirely different scale, it revives the Australian tradition of pilotless aircraft begun by the **GAF Jindivik** target drone. With the American **XQ-58 Valkyrie** and the Turkish **Bayraktar Kızılelma**, it embodies the doctrine of the uncrewed wingman, whose worth no air force has yet proved in combat.',
    (SELECT id FROM countries WHERE code = 'AUS'),
    '2019-02-27',
    '2021-02-27',
    NULL,
    NULL,
    3700.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-28 Ghost Bat'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'MQ-28 Ghost Bat'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'MQ-28 Ghost Bat'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-28 Ghost Bat'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-28 Ghost Bat'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'MQ-28 Ghost Bat'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'MQ-28 Ghost Bat'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'MQ-28 Ghost Bat'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.7,
  wingspan          = 7.3,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = NULL,
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Loyal Wingman** : maquette présentée à Avalon le **27 février 2019**\n- **MQ-28A Block 1** : huit appareils d''essais, premier vol le **27 février 2021**\n- **MQ-28A Block 2** : six appareils de série commandés en décembre 2025\n- **Block 3** : prototype amélioré inscrit au même contrat\n- **Nez modulaire** interchangeable selon la mission',
  variants_en       = E'- **Loyal Wingman** : mock-up unveiled at Avalon on **27 February 2019**\n- **MQ-28A Block 1** : eight test aircraft, first flight on **27 February 2021**\n- **MQ-28A Block 2** : six production aircraft ordered in December 2025\n- **Block 3** : improved prototype included in the same contract\n- **Modular nose** swapped according to the mission',

  -- Strate 4 : qualitatif
  nickname          = 'Ghost Bat',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_MQ-28_Ghost_Bat',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_MQ-28_Ghost_Bat',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Senior Airman Adrien Tran, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'MQ-28 Ghost Bat';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'MQ-28 Ghost Bat';
