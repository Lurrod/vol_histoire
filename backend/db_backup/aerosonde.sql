-- AAI / Textron Aerosonde (MQ-19)
--
-- Photo : USS Higgins (DDG 76) Aerosonde Flight (8432266).jpg
--   licence Public domain — U.S. Navy photo by Petty Officer 1st Class Hannah Fry
--   https://commons.wikimedia.org/wiki/File:USS_Higgins_(DDG_76)_Aerosonde_Flight_(8432266).jpg

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
    'AAI Aerosonde',
    'AAI Aerosonde',
    'AAI / Textron Aerosonde (MQ-19)',
    'AAI / Textron Aerosonde (MQ-19)',
    'Drone météo devenu éclaireur des forces spéciales, premier aéronef sans pilote à traverser l''Atlantique',
    'Weather drone turned special forces scout, the first unmanned aircraft to fly the Atlantic',
    '/assets/airplanes/aerosonde.jpg',
    E'## Genèse\nL''Aerosonde est d''abord un instrument scientifique : un petit drone conçu pour recueillir des données météorologiques — température, pression atmosphérique, humidité, vent — au-dessus des océans et des régions isolées, pour des sondages de l''atmosphère économiques en tout point du globe. Développé par **Insitu**, il est ensuite produit par Aerosonde Ltd, une activité d''**AAI Corporation**, elle-même rattachée à Textron. Il emporte un petit ordinateur, des instruments météorologiques et un récepteur GPS pour la navigation, le tout mû par un moteur de modélisme **Enya R120** modifié.\n\n## Conception\nLe Mk 1 n''a pas de train d''atterrissage : 2,9 m d''envergure, 13 kg au décollage, un moteur à essence de 20 cm³ et jusqu''à 30 heures de vol. Le 21 août 1998, l''un d''eux, surnommé **Laima** d''après une déesse lettone de la fortune, est lancé depuis la galerie de toit d''une voiture en mouvement à Terre-Neuve. Il se pose 26 heures et 45 minutes plus tard à **Benbecula**, au large de l''Écosse, après 3 270 km parcourus seul, hors décollage et atterrissage, à 1 680 m d''altitude et dans une météo orageuse, en consommant environ 5,7 litres d''essence. C''est la première traversée de l''Atlantique par un drone, et alors le plus petit aéronef à l''avoir accomplie.\n\n## Carrière opérationnelle\nEn 2001, des Aerosonde sont les premiers aéronefs sans pilote à pénétrer dans un cyclone tropical, et ils atteignent l''œil de tempêtes en 2005. Les versions militaires s''alourdissent : l''**Aerosonde-G**, lancé par catapulte, pèse de 34 à 36 kg selon le moteur, vole plus de 10 heures et emporte une caméra électro-optique et infrarouge avec un pointeur laser. Le 5 mars 2012, le commandement des opérations spéciales américain, le **SOCOM**, le retient pour son programme Mid-Endurance UAS II ; il est employé sous la désignation **MQ-19** par le SOCOM et par le NAVAIR. Un système type compte quatre appareils et deux stations sol logées sous tente ou dans un véhicule.\n\n## Place dans l''histoire\nL''Aerosonde a inauguré un autre modèle économique : au lieu d''acheter des drones, ses clients achètent des **heures de capteur**, et c''est le constructeur qui décide du nombre d''appareils à produire. En novembre 2015, Textron Systems l''exploite ainsi dans huit ou neuf pays, pour les Marines, l''US Air Force, le SOCOM et un client pétrolier, à raison de 4 000 heures facturées par mois et plus de 110 000 heures de vol cumulées. Laima, la pionnière de l''Atlantique, est exposée au Museum of Flight de Seattle.',
    E'## Genesis\nThe Aerosonde started life as a scientific instrument: a small drone designed to collect weather data — temperature, atmospheric pressure, humidity and wind — over oceans and remote areas, for economical atmospheric soundings anywhere on the globe. Developed by **Insitu**, it was later built by Aerosonde Ltd, a business of **AAI Corporation**, itself part of Textron. It carries a small computer, meteorological instruments and a GPS receiver for navigation, and is powered by a modified **Enya R120** model aircraft engine.\n\n## Design\nThe Mk 1 has no undercarriage: a 2.9 m span, 13 kg at take-off, a 20 cc petrol engine and up to 30 hours in the air. On 21 August 1998 one of them, nicknamed **Laima** after the ancient Latvian deity of good fortune, was launched from the roof rack of a moving car in Newfoundland. It landed 26 hours and 45 minutes later on **Benbecula**, off the coast of Scotland, after 3,270 km flown on its own apart from take-off and landing, at 1,680 m and in stormy weather, on about 5.7 litres of petrol. It was the first crossing of the Atlantic by an unmanned aircraft, and at the time the smallest aircraft ever to make it.\n\n## Operational career\nIn 2001 Aerosondes became the first unmanned aircraft to penetrate a tropical cyclone, and they reached the eye of storms in 2005. The military versions grew heavier: the catapult-launched **Aerosonde-G** weighs 34 to 36 kg depending on the engine, flies for more than 10 hours and carries an electro-optical and infrared camera with a laser pointer. On 5 March 2012 US Special Operations Command, **SOCOM**, chose it for its Mid-Endurance UAS II programme; SOCOM and NAVAIR have operated it as the **MQ-19**. A typical system has four air vehicles and two ground control stations housed in tents or vehicles.\n\n## Place in history\nThe Aerosonde pioneered a different business model: instead of buying drones, its customers buy **sensor hours**, and the manufacturer decides how many aircraft to build. By November 2015 Textron Systems was operating it in eight or nine countries, for the Marine Corps, the US Air Force, SOCOM and an oil and gas customer, at 4,000 fee-for-service hours a month and more than 110,000 flight hours in total. Laima, the Atlantic pioneer, is on display at the Museum of Flight in Seattle.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'AAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AAI Aerosonde'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = 2.9,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = 8,
  mtow              = 13,
  service_ceiling   = 4000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Enya R120 modifié (moteur à essence de 20 cm³)',
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
  variants          = E'- **Aerosonde Mk 1** : version météorologique de 2,9 m d''envergure, jusqu''à 30 heures de vol ; Laima traverse l''Atlantique en 1998\n- **Aerosonde Mk 3** : liaison par satellites Iridium\n- **Aerosonde Mk 4.3 / Mk 4.4** : versions du programme de sciences aéroportées de la NASA\n- **Aerosonde Mk 4.7G (Aerosonde-G, MQ-19)** : version militaire à aile renforcée de 3,8 m, 16 heures de vol\n- **Aerosonde Mk 4.7 HQ** : version à décollage et atterrissage verticaux\n- **Aerosonde Mk 4.8 HQ (YRQ-10A)** : prototypes pour l''US Army, essais à partir d''avril 2025',
  variants_en       = E'- **Aerosonde Mk 1**: 2.9 m span weather version, up to 30 hours'' flight; Laima crossed the Atlantic in 1998\n- **Aerosonde Mk 3**: Iridium satellite communication\n- **Aerosonde Mk 4.3 / Mk 4.4**: versions used by the NASA Airborne Science Program\n- **Aerosonde Mk 4.7G (Aerosonde-G, MQ-19)**: military version with a strengthened 3.8 m wing, 16 hours'' flight\n- **Aerosonde Mk 4.7 HQ**: vertical take-off and landing version\n- **Aerosonde Mk 4.8 HQ (YRQ-10A)**: prototypes for the US Army, testing from April 2025',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AAI_Aerosonde',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Petty Officer 1st Class Hannah Fry, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'AAI Aerosonde';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AAI Aerosonde';
