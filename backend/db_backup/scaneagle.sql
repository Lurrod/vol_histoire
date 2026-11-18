-- Boeing Insitu ScanEagle (MQ-27)
--
-- Photo : US Navy 110226-N-RC734-147 A Scan Eagle unmanned aerial vehicle in flight during launch and recovery exercises aboard the amphibious dock landing s.jpg
--   licence Public domain — MC2 Joseph M. Buliavac, U.S. Navy
--   https://commons.wikimedia.org/wiki/File:US_Navy_110226-N-RC734-147_A_Scan_Eagle_unmanned_aerial_vehicle_in_flight_during_launch_and_recovery_exercises_aboard_the_amphibious_dock_landing_s.jpg

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
    'Boeing Insitu ScanEagle',
    'Boeing Insitu ScanEagle',
    'Boeing Insitu ScanEagle (MQ-27)',
    'Boeing Insitu ScanEagle (MQ-27)',
    'Né pour repérer les bancs de thon, ce drone de 20 kg sans piste veille vingt heures au-dessus des navires et des troupes',
    'Born to spot schools of tuna, this 20 kg runway-free drone keeps watch for twenty hours over ships and troops',
    '/assets/airplanes/scaneagle.jpg',
    E'## Genèse\nLe ScanEagle descend d''un drone civil, le **SeaScan** d''**Insitu**, imaginé pour recueillir des données météorologiques et aider les pêcheurs à suivre les bancs de thon. Une alliance stratégique entre **Boeing** et Insitu, qui deviendra sa filiale, en fait un système de surveillance du champ de bataille portable et autonome. Le premier vol a lieu le 20 juin 2002 ; dès août 2004, le drone est déployé dans la **guerre d''Irak**, et l''US Navy le met en service en 2005.\n\n## Conception\nL''appareil tient dans les bras : 3,1 m d''envergure, à peine plus de 1,5 m de long et une vingtaine de kilos. Un petit moteur deux-temps de 1,5 ch lui donne plus de vingt heures d''autonomie ; un Block D a tenu 22 h 8 min. Sous le nez, une tourelle stabilisée porte une caméra optique ou infrarouge, reliée au sol à plus de 100 km. Surtout, il se passe de piste : une catapulte pneumatique, la **SuperWedge**, le lance, et le **Skyhook** le récupère, un crochet en bout d''aile saisissant un filin suspendu à un mât de 9 à 15 m, guidé par GPS différentiel. Un système de quatre drones avec sa station sol coûtait 3,2 millions de dollars en 2006.\n\n## Carrière opérationnelle\nEn juillet 2011, Insitu revendique 500 000 heures de vol en opérations et plus de 56 000 sorties. En avril 2009, un ScanEagle de l''US Navy surveille le canot où des pirates retiennent le capitaine du **Maersk Alabama** dans l''océan Indien. En 2011, lancé par le destroyer **USS Mahan** pendant l''opération **Unified Protector** en Libye, il localise des contacts que personne d''autre ne trouvait. Les garde-côtes américains l''emploient en 2013 contre une vedette chargée de cocaïne. En décembre 2012, l''Iran affirme en avoir capturé plusieurs et en produit une copie, le **Yasir**.\n\n## Place dans l''histoire\nLe ScanEagle a fait du drone tactique un outil de marine ordinaire, lancé et récupéré depuis le pont d''un petit navire. Il est l''un des premiers drones certifiés par la FAA, en 2013, pour un usage commercial, au service d''un pétrolier en Alaska. Désigné **MQ-27** dans l''armée américaine, il sert dans près de trente pays, et sa formule a engendré un frère plus lourd, le **RQ-21 Blackjack**, qui partage sa catapulte et son crochet.',
    E'## Genesis\nThe ScanEagle descends from a civil drone, **Insitu**''s **SeaScan**, conceived to gather weather data and help fishermen track schools of tuna. A strategic alliance between **Boeing** and Insitu, which would become its subsidiary, turned it into a portable, autonomous battlefield surveillance system. It first flew on 20 June 2002; from August 2004 it was deployed in the **Iraq War**, and the US Navy brought it into service in 2005.\n\n## Design\nThe aircraft can be carried in one''s arms: a 3.1 m span, barely more than 1.5 m long and about twenty kilos. A small 1.5 hp two-stroke engine gives it more than twenty hours of endurance; a Block D stayed aloft for 22 hours 8 minutes. Under the nose, a stabilised turret carries an optical or infrared camera, linked to the ground over more than 100 km. Above all, it needs no runway: a pneumatic catapult, the **SuperWedge**, launches it, and the **Skyhook** recovers it, a wingtip hook catching a rope hanging from a 9 to 15 m pole, guided by differential GPS. A system of four drones with its ground station cost $3.2 million in 2006.\n\n## Operational career\nBy July 2011 Insitu claimed 500,000 combat flight hours and more than 56,000 sorties. In April 2009 a US Navy ScanEagle watched over the lifeboat in which pirates held the captain of the **Maersk Alabama** in the Indian Ocean. In 2011, launched by the destroyer **USS Mahan** during Operation **Unified Protector** over Libya, it located contacts of interest that no one else could find. The US Coast Guard used it in 2013 against a fast boat loaded with cocaine. In December 2012 Iran claimed to have captured several and went on to produce a copy, the **Yasir**.\n\n## Place in history\nThe ScanEagle made the tactical drone an everyday naval tool, launched and recovered from the deck of a small ship. In 2013 it became one of the first drones certified by the FAA for commercial use, serving an oil company in Alaska. Designated **MQ-27** in the US armed forces, it serves in nearly thirty countries, and its formula produced a heavier sibling, the **RQ-21 Blackjack**, which shares its catapult and hook.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '2002-06-20',
    '2004-08-01',
    148,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'INS'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing Insitu ScanEagle'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'Boeing Insitu ScanEagle'), (SELECT id FROM tech WHERE name = 'Lancement par catapulte et récupération par crochet'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing Insitu ScanEagle'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing Insitu ScanEagle'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'Boeing Insitu ScanEagle'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 1.55,
  wingspan          = 3.11,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 26.5,
  service_ceiling   = 5950,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = '3W International deux-temps (1,5 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2002,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 29,
  variants          = E'- **ScanEagle Block D** : caméra à plus haute résolution, transpondeur mode C, record d''endurance de 22 h 8 min\n- **NightEagle** : Block E à caméra infrarouge pour les opérations de nuit, annoncé en 2009\n- **ScanEagle 2** : présenté en octobre 2014, moteur à carburant lourd, nez agrandi portant capteurs jour et nuit, endurance ramenée à 16 h\n- **MQ-27A / MQ-27B** : désignations militaires américaines ; **CU-169** au Canada, **ScanEagle RM1** dans la Royal Navy\n- **ScanEagle X200** : version civile certifiée par la FAA en catégorie restreinte',
  variants_en       = E'- **ScanEagle Block D**: higher-resolution camera, Mode C transponder, endurance record of 22 h 8 min\n- **NightEagle**: Block E with an infrared camera for night operations, announced in 2009\n- **ScanEagle 2**: unveiled in October 2014, heavy-fuel engine, larger nose carrying day and night sensors, endurance reduced to 16 h\n- **MQ-27A / MQ-27B**: US military designations; **CU-169** in Canada, **ScanEagle RM1** in the Royal Navy\n- **ScanEagle X200**: civil version with an FAA restricted-category certificate',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_ScanEagle',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_Insitu_MQ-27_ScanEagle',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'MC2 Joseph M. Buliavac, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Boeing Insitu ScanEagle';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing Insitu ScanEagle';
