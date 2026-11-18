-- AeroVironment Switchblade 300 / 600
--
-- Photo : Switchblade 300 in flight (200902-M-EU630-1102).jpg
--   licence Public domain — U.S. Marine Corps/Lance Cpl. Tyler Forti
--   https://commons.wikimedia.org/wiki/File:Switchblade_300_in_flight_(200902-M-EU630-1102).jpg

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
    'AeroVironment Switchblade',
    'AeroVironment Switchblade',
    'AeroVironment Switchblade 300 / 600',
    'AeroVironment Switchblade 300 / 600',
    'La munition rôdeuse qui tient dans un sac à dos, née en Afghanistan et éprouvée en Ukraine',
    'The backpack-sized loitering munition, born in Afghanistan and proven in Ukraine',
    '/assets/airplanes/aerovironment-switchblade.jpg',
    E'## Genèse\nLe Switchblade naît d''un besoin apparu en **Afghanistan** : riposter vite à une embuscade. L''appui aérien tarde, coûte cher et risque des dommages collatéraux en ville ; les missiles portables comme le **Javelin** sont lourds et coûteux ; les petits drones comme le **Raven** ou le **Puma** repèrent la menace sans pouvoir la frapper. Conçu par le commandement des opérations spéciales de l''US Air Force et développé par l''**US Army**, le Switchblade d''**AeroVironment** comble ce vide : une munition rôdeuse qui tient dans un sac à dos. Le 29 juillet 2011, l''Army commande sa mise en service rapide pour 4,9 millions de dollars.\n\n## Conception\nLancé depuis un tube, le Switchblade déploie ses ailes à ressort une fois sorti, d''où son nom de « couteau à cran d''arrêt ». Dans sa version d''origine, rebaptisée Switchblade 300, l''ensemble mesure 61 cm et pèse 2,7 kg avec sa mallette et son lanceur ; un moteur électrique le pousse à 157 km/h, il vole 10 minutes et se commande jusqu''à 10 km. Ses caméras couleur et infrarouge servent à viser, et sa charge, équivalente à une grenade de 40 mm, projette ses éclats vers l''avant. L''opérateur peut annuler l''attaque jusqu''à quatre secondes de l''impact. Dévoilé en 2020, le **Switchblade 600** antichar emporte une charge dérivée de celle du Javelin, vole 40 km en 20 minutes puis rôde encore 20 minutes.\n\n## Carrière opérationnelle\nFin 2012, 75 Switchblade sont livrés aux soldats en Afghanistan ; jugés « très efficaces », ils sont redemandés en bien plus grand nombre, et plus de 4 000 y sont déployés jusqu''à la fin de l''opération Enduring Freedom. La possibilité d''annuler une frappe y a évité des victimes civiles plus d''une dizaine de fois. Après l''**invasion russe de l''Ukraine**, les États-Unis en envoient 700 en 2022, dont le premier emploi est signalé début mai dans la région de Kharkiv ; les Switchblade 600, livrés fin 2022, combattent au printemps 2023. Le brouillage russe fait reculer l''emploi du modèle 300, mais le 11 juin 2024, un Switchblade, sans doute un 600, détruit un lanceur **Buk** dans la région de Donetsk.\n\n## Place dans l''histoire\nLe Switchblade a donné aux plus petites unités d''infanterie une frappe de précision au-delà de leur portée habituelle ; l''US Army le range d''ailleurs parmi les munitions, non parmi les drones. En août 2024, l''Army signe un contrat de près d''un milliard de dollars sur cinq ans ; le Royaume-Uni, la Lituanie, la Nouvelle-Zélande et l''Ukraine l''emploient, et l''Australie, le Canada, la France, la Grèce, la Roumanie, la Suède et Taïwan l''ont commandé ou en prévoient l''achat.',
    E'## Genesis\nThe Switchblade grew out of a need felt in **Afghanistan**: to strike back quickly at an ambush. Air support took time to arrive, was costly and risked collateral damage in towns; man-portable missiles such as the **Javelin** were heavy and expensive; small drones such as the **Raven** or the **Puma** could spot the threat but not hit it. Designed by US Air Force Special Operations Command and developed by the **US Army**, **AeroVironment**''s Switchblade filled the gap: a loitering munition that fits in a backpack. On 29 July 2011 the Army ordered its rapid fielding for $4.9 million.\n\n## Design\nLaunched from a tube, the Switchblade flips out its spring-loaded wings once clear, hence its name. In its original version, later renamed Switchblade 300, the unit is 61 cm long and weighs 2.7 kg with its carrying case and launcher; an electric motor drives it at 157 km/h, it flies for 10 minutes and can be controlled out to 10 km. Its colour and infrared cameras are used for aiming, and its warhead, equivalent to a 40 mm grenade, throws its fragments forward. The operator can abort the attack until four seconds before impact. Unveiled in 2020, the anti-armour **Switchblade 600** carries a warhead based on the Javelin''s, flies 40 km in 20 minutes and then loiters for 20 more.\n\n## Operational career\nIn late 2012, 75 Switchblades were supplied to soldiers in Afghanistan; judged ''very effective'', they were requested in far greater numbers, and more than 4,000 were deployed there by the end of Operation Enduring Freedom. The ability to wave off a strike prevented civilian casualties more than a dozen times. After the **Russian invasion of Ukraine**, the United States sent 700 in 2022, first reported in use in early May in Kharkiv Oblast; the Switchblade 600s, delivered by the end of 2022, saw combat in the spring of 2023. Russian jamming reduced the use of the 300, but on 11 June 2024 a Switchblade, probably a 600, destroyed a **Buk** launcher in Donetsk Oblast.\n\n## Place in history\nThe Switchblade gave the smallest infantry units precision firepower beyond their usual reach; the US Army in fact classes it as a munition rather than a drone. In August 2024 the Army signed a contract worth nearly $1 billion over five years; the United Kingdom, Lithuania, New Zealand and Ukraine operate it, and Australia, Canada, France, Greece, Romania, Sweden and Taiwan have ordered it or plan to buy it.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    NULL,
    '2011-01-01',
    157,
    10,
    (SELECT id FROM manufacturer WHERE code = 'AV'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment Switchblade'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'AeroVironment Switchblade'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment Switchblade'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'AeroVironment Switchblade'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment Switchblade'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'AeroVironment Switchblade'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

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
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Moteur électrique',
  engine_count      = 1,
  engine_type       = 'Moteur électrique',
  engine_type_en    = 'Electric motor',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **Switchblade (300)** : version d''origine de 2011, charge équivalente à une grenade de 40 mm, 10 minutes de vol\n- **Block 10C** : liaison de données numérique chiffrée, plusieurs engins dans la même zone sans interférence\n- **Block 20** : 20 minutes de vol, tourelle électro-optique et infrarouge orientable\n- **Switchblade 600** : version antichar dévoilée en 2020, charge dérivée du Javelin, 40 km de rayon d''action\n- **Blackwing** : version non armée de renseignement pour l''US Navy, lançable depuis un sous-marin en plongée\n- **Multi-Pack Launcher** : lanceur télécommandé de 2 à 20 munitions, déployé en 2019 pour la défense des bases',
  variants_en       = E'- **Switchblade (300)**: original 2011 version, warhead equivalent to a 40 mm grenade, 10 minutes'' flight\n- **Block 10C**: encrypted digital data link, several munitions in the same area without interference\n- **Block 20**: 20 minutes'' flight, panning electro-optical and infrared camera\n- **Switchblade 600**: anti-armour version unveiled in 2020, Javelin-derived warhead, 40 km reach\n- **Blackwing**: unarmed reconnaissance version for the US Navy, launchable from a submerged submarine\n- **Multi-Pack Launcher**: remotely operated launcher for 2 to 20 rounds, fielded in 2019 for base defence',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/AeroVironment_Switchblade',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AeroVironment_Switchblade',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Lance Cpl. Tyler Forti, U.S. Marine Corps',
  image_licence     = 'Public domain'
WHERE name = 'AeroVironment Switchblade';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AeroVironment Switchblade';
