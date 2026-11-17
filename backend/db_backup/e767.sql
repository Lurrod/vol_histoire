-- Boeing E-767 AWACS
--
-- Photo : JASDF E-767 in Alaska, 2011(USAF photo 110706-F-HA566-194).jpg
--   licence Public domain — U.S. Air Force photo/Staff Sgt. Christopher Boitz
--   https://commons.wikimedia.org/wiki/File:JASDF_E-767_in_Alaska,_2011(USAF_photo_110706-F-HA566-194).jpg

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
    'Boeing E-767',
    'Boeing E-767',
    'Boeing E-767 AWACS',
    'Boeing E-767 AWACS',
    'Le radar de l''AWACS américain greffé sur un Boeing 767, pour le seul ciel japonais',
    'The American AWACS radar grafted onto a Boeing 767, for Japanese skies alone',
    '/assets/airplanes/e767.jpg',
    E'## Genèse\nLe 6 septembre 1976, le pilote soviétique **Viktor Belenko** fait défection à bord de son **MiG-25** et se pose à Hakodate : volant bas, il a échappé aux radars japonais. Tokyo veut aussitôt un guet aérien. L''**E-3 Sentry**, alors à la veille de son déploiement, ne sera pas disponible avant longtemps, et le Japon se rabat sur l''**E-2C Hawkeye**, en service à Misawa en janvier 1987. Quand l''Agence de défense revient à l''E-3 en 1991, sa production sur cellule de 707 vient de s''arrêter. Boeing propose alors en 1992 un AWACS bâti sur le **767**.\n\n## Conception\nL''E-767 reprend sur un **767-200ER** le radar et le système de contrôle des derniers E-3. La cellule offre environ moitié plus de surface au sol et près de deux fois le volume du 707 ; l''électronique est installée à l''avant pour équilibrer le poids du radôme rotatif de 9,14 m de diamètre, monté sur deux mâts au-dessus du fuselage arrière. Le radar **AN/APY-2**, à impulsions Doppler, voit à 360° au-delà de 320 km et distingue les cibles du fouillis de la mer et du sol. Les hublots sont supprimés pour protéger l''équipage du rayonnement radar, et deux **CF6-80C2** de 273,6 kN alimentent des génératrices portées de 90 à 150 kW.\n\n## Carrière opérationnelle\nLe budget, plus de cent milliards de yens pour chaque paire d''appareils, est justifié politiquement par le souci d''apaiser la tension commerciale avec les États-Unis, d''autant que l''industrie japonaise fabrique 15 % de la cellule du 767. Le premier E-767 vole le 4 octobre 1994 à Paine Field, puis avec son radôme le 9 août 1996. Les quatre appareils, livrés en 1998 et 1999, entrent en service le 10 mai 2000 à Hamamatsu, dont il a fallu renforcer les pistes. Entre 2006 et 2012, le programme RSIP accroît la sensibilité du radar pour suivre des cibles plus petites.\n\n## Place dans l''histoire\nL''E-767 transpose sur un biréacteur moderne le système de l''AWACS américain : c''est la réponse directe d''un pays à une intrusion qui avait pris sa défense aérienne en défaut. Fabriqué à quatre exemplaires pour un seul client, il garde une limite notable : il ne peut pas être ravitaillé en vol, son endurance plafonnant à 13 heures à 556 km de sa base.',
    E'## Genesis\nOn 6 September 1976 Soviet pilot **Viktor Belenko** defected in his **MiG-25** and landed at Hakodate: flying low, he had slipped past Japanese radar. Tokyo at once wanted airborne early warning. The **E-3 Sentry**, then on the verge of deployment, would not be available for a long time, so Japan settled for the **E-2C Hawkeye**, in service at Misawa in January 1987. When the Defense Agency returned to the E-3 in 1991, production of the 707-based airframe had just ended. In 1992 Boeing proposed an AWACS built on the **767**.\n\n## Design\nThe E-767 carries the radar and control system of the later E-3s on a **767-200ER**. The airframe offers about half as much floor space again and nearly twice the volume of the 707; the electronics sit forward to balance the weight of the 9.14 m rotodome, mounted on two struts above the rear fuselage. The **AN/APY-2** pulse-Doppler radar sees through 360 degrees beyond 320 km and separates targets from sea and ground clutter. The windows were deleted to protect the crew from the radar''s emissions, and two 273.6 kN **CF6-80C2** engines drive generators upgraded from 90 to 150 kW.\n\n## Operational career\nThe budget, over one hundred billion yen for each pair of aircraft, was justified politically as a way to ease trade tension with the United States, all the more since Japanese industry builds 15% of the 767 airframe. The first E-767 flew on 4 October 1994 at Paine Field, then with its rotodome on 9 August 1996. The four aircraft, delivered in 1998 and 1999, entered service on 10 May 2000 at Hamamatsu, whose runways had to be strengthened. Between 2006 and 2012 the RSIP programme increased the radar''s sensitivity to track smaller targets.\n\n## Place in history\nThe E-767 transferred the American AWACS system to a modern twinjet: it was a country''s direct answer to an intrusion that had caught its air defence out. Built in four examples for a single customer, it keeps one notable limitation: it cannot be refuelled in flight, its endurance topping out at 13 hours at 556 km from base.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1992-01-01',
    '1994-10-04',
    '2000-05-10',
    NULL,
    10370,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-767'), (SELECT id FROM tech WHERE name = 'Radôme rotatif')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-767'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-767'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-767'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-767'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-767'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 48.5,
  wingspan          = 47.6,
  height            = 15.8,
  wing_area         = NULL,
  empty_weight      = 85595,
  mtow              = 175000,
  service_ceiling   = 12200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 12,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CF6-80C2B6FA',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 273.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **E-767** : quatre appareils bâtis sur le Boeing 767-200ER (désignation Boeing 767-27C), livrés en 1998 et 1999\n- **Radôme rotatif** de 9,14 m abritant dos à dos le radar AN/APY-2 et l''antenne IFF Mk XII\n- **RSIP** (2006-2012) : nouveau calculateur radar et logiciels, détection de cibles plus petites\n- **Sans perche ni réceptacle** : aucune capacité de ravitaillement en vol',
  variants_en       = E'- **E-767**: four aircraft built on the Boeing 767-200ER (Boeing designation 767-27C), delivered in 1998 and 1999\n- **Rotodome** 9.14 m across, housing the AN/APY-2 radar and the IFF Mk XII antenna back to back\n- **RSIP** (2006-2012): new radar computer and software, detection of smaller targets\n- **No probe or receptacle**: no in-flight refuelling capability',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_E-767',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_E-767',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. Christopher Boitz, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Boeing E-767';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing E-767';
