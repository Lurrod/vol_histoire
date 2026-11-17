-- General Atomics MQ-20 Avenger (Predator C)
--
-- Photo : MQ-20 at El Mirage Airfield.jpg
--   licence Public domain — U.S. Air Force photo by Staff Sgt. Tabatha Arellano
--   https://commons.wikimedia.org/wiki/File:MQ-20_at_El_Mirage_Airfield.jpg

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
    'MQ-20 Avenger',
    'MQ-20 Avenger',
    'General Atomics MQ-20 Avenger (Predator C)',
    'General Atomics MQ-20 Avenger (Predator C)',
    'Le Predator à réacteur et soute interne, plus rapide et plus discret, que l''US Air Force n''a pas voulu en série',
    'The jet-powered Predator with an internal bay, faster and stealthier, that the US Air Force chose not to buy in series',
    '/assets/airplanes/mq20-avenger.jpg',
    E'## Genèse\nAprès le **MQ-1 Predator** et le **MQ-9 Reaper**, **General Atomics** prépare à la fin des années 2000 un troisième membre de la famille, le **Predator C**, baptisé Avenger. L''objectif est de garder l''infrastructure au sol et les armes du Reaper tout en volant plus vite et en se faisant moins voir, pour des espaces aériens où un drone à hélice serait une proie facile. Le premier prototype décolle le 4 avril 2009 du terrain de Grey Butte, près de Palmdale en Californie, et revole dès les 13 et 14 avril.\n\n## Conception\nRupture avec ses aînés à turbopropulseur, l''Avenger reçoit un turboréacteur double flux **Pratt & Whitney Canada PW545B** de 17,75 kN. Sa voilure est en flèche de 17°, ses armes sont logées dans une soute interne de 1 600 kg et sa tuyère en S réduit les signatures radar et infrarouge. Six points d''emport externes portent la charge totale à environ 2,9 t, des missiles **Hellfire** aux bombes **JDAM** de 900 kg. Il emporte le radar à synthèse d''ouverture Lynx et un dérivé du système de visée électro-optique du **F-35**. L''Avenger ER de 2016 porte l''envergure à 23,2 m et l''endurance de 15 à 20 heures.\n\n## Essais\nLe deuxième prototype, au fuselage allongé de 1,2 m, vole le 12 janvier 2012. Fin 2011, l''US Air Force en commande un exemplaire comme banc d''essai ; l''annonce, tombée deux semaines après la capture d''un RQ-170 par l''Iran, fait croire à un déploiement en Afghanistan, ce que l''Air Force dément. Après évaluation, elle juge que l''Avenger n''apporte que des gains modestes sur le Reaper et ne survivrait pas dans un espace aérien défendu. En janvier 2018, un Avenger ER tient l''air 23,4 heures d''affilée, et le 28 novembre 2023 un Avenger largue un petit drone depuis sa soute.\n\n## Place dans l''histoire\nL''Avenger est resté le drone de l''occasion manquée : l''annulation du programme MQ-X de l''Air Force en février 2012 et celle de l''UCLASS de la Navy, pour laquelle General Atomics proposait un Sea Avenger embarqué, l''ont privé de grande commande. Neuf exemplaires ont été construits, un pour l''Air Force et sept pour un client gouvernemental américain non identifié. L''Inde s''est dite intéressée par une centaine d''appareils, et le Canada a finalement préféré le MQ-9B. L''Avenger sert surtout de banc d''essai, pour de nouveaux capteurs et de nouvelles armes.',
    E'## Genesis\nAfter the **MQ-1 Predator** and the **MQ-9 Reaper**, **General Atomics** prepared a third member of the family in the late 2000s, the **Predator C**, named Avenger. The aim was to keep the Reaper''s ground infrastructure and weapons while flying faster and being harder to see, for airspace where a propeller-driven drone would be easy prey. The first prototype took off on 4 April 2009 from Grey Butte field, near Palmdale in California, and flew again on 13 and 14 April.\n\n## Design\nBreaking with its turboprop elders, the Avenger received a 17.75 kN **Pratt & Whitney Canada PW545B** turbofan. Its wing is swept at 17°, its weapons sit in a 1,600 kg internal bay and its S-shaped exhaust reduces radar and infrared signatures. Six external hardpoints raise the total load to about 2.9 t, from **Hellfire** missiles to 900 kg **JDAM** bombs. It carries the Lynx synthetic aperture radar and a derivative of the **F-35**''s electro-optical targeting system. The 2016 Avenger ER extended the span to 23.2 m and endurance from 15 to 20 hours.\n\n## Testing\nThe second prototype, with a fuselage stretched by 1.2 m, flew on 12 January 2012. In late 2011 the US Air Force ordered one as a test asset; the announcement, two weeks after Iran captured an RQ-170, fuelled talk of a deployment to Afghanistan, which the Air Force denied. After evaluation it judged that the Avenger offered only modest gains over the Reaper and would not survive in defended airspace. In January 2018 an Avenger ER stayed aloft for 23.4 hours straight, and on 28 November 2023 an Avenger released a small drone from its bay.\n\n## Place in history\nThe Avenger remained the drone of missed opportunity: the cancellation of the Air Force''s MQ-X programme in February 2012 and of the Navy''s UCLASS, for which General Atomics offered a carrier-based Sea Avenger, deprived it of a large order. Nine were built, one for the Air Force and seven for an unidentified US government customer. India expressed interest in around a hundred, and Canada eventually preferred the MQ-9B. The Avenger serves mainly as a test bed, for new sensors and new weapons.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '2009-04-04',
    NULL,
    740,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'GA'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM armement WHERE name = 'AGM-114 Hellfire')),
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB')),
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM armement WHERE name = 'GBU-38 JDAM')),
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM armement WHERE name = 'GBU-16 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM armement WHERE name = 'GBU-32 JDAM')),
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'MQ-20 Avenger'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13,
  wingspan          = 20,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 8255,
  service_ceiling   = 15240,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PW545B',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 17.75,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 9,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Avenger (Predator C)** : premier prototype, premier vol le 4 avril 2009\n- **Avenger « Tail 2 »** : fuselage allongé de 1,2 m pour plus de carburant et de charge utile, premier vol le 12 janvier 2012\n- **Sea Avenger** : projet embarqué à ailes repliables pour le programme UCLASS de l''US Navy, présenté en 2010\n- **Avenger ER** : envergure portée à 23,2 m, 4,6 t de carburant, record d''endurance de 23,4 heures en 2018\n- **MQ-20** : désignation militaire américaine de l''Avenger',
  variants_en       = E'- **Avenger (Predator C)**: first prototype, first flight on 4 April 2009\n- **Avenger "Tail 2"**: fuselage stretched by 1.2 m for more fuel and payload, first flight on 12 January 2012\n- **Sea Avenger**: carrier-based project with folding wings for the US Navy''s UCLASS programme, unveiled in 2010\n- **Avenger ER**: span extended to 23.2 m, 4.6 t of fuel, 23.4-hour endurance record in 2018\n- **MQ-20**: US military designation of the Avenger',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/General_Atomics_MQ-20_Avenger',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/General_Atomics_MQ-20_Avenger',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. Tabatha Arellano, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'MQ-20 Avenger';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'MQ-20 Avenger';
