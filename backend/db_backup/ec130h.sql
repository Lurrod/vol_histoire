-- Lockheed EC-130H Compass Call
--
-- Photo : EC-130H 41st EWS taking off Davis-Monthan AFB 2007.jpg
--   licence Public domain — U.S. Air Force photo by Senior Airman Jacqueline Hawkins
--   https://commons.wikimedia.org/wiki/File:EC-130H_41st_EWS_taking_off_Davis-Monthan_AFB_2007.jpg

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
    'EC-130H Compass Call',
    'EC-130H Compass Call',
    'Lockheed EC-130H Compass Call',
    'Lockheed EC-130H Compass Call',
    'Un Hercules transformé en brouilleur pour couper les communications de l''ennemi',
    'A Hercules turned into a jammer to cut the enemy''s communications',
    '/assets/airplanes/ec130h.jpg',
    E'## Genèse\nLe **C-130 Hercules** a déjà donné naissance à une foule de versions spécialisées lorsque l''US Air Force décide d''en faire un outil d''attaque électronique. L''objectif n''est pas de détruire mais de rendre sourd et muet : brouiller les réseaux de commandement et de contrôle adverses, les radars d''alerte et les systèmes de navigation. Le **Compass Call** vole pour la première fois en 1981 ; le premier exemplaire est livré en mars 1982 et la capacité opérationnelle initiale est atteinte en 1983.\n\n## Conception\nLa cellule du transport est lourdement modifiée : l''équipement de mission, fourni par **BAE Systems** et intégré par L3 Communications, occupe à demeure la soute. L''équipage compte treize personnes. Quatre conduisent l''avion, pilote, copilote, navigateur et mécanicien ; neuf servent le système, dont deux officiers de guerre électronique, un superviseur linguiste expérimenté, quatre opérateurs d''analyse linguistes et un technicien de maintenance. Les standards **Block 35** puis **Baseline 2** élargissent la gamme de fréquences, augmentent la puissance rayonnée et ajoutent le traitement numérique du signal, pour ce que l''Air Force décrit comme une capacité d''attaque électronique de cinquième génération.\n\n## Carrière opérationnelle\nBasés à Davis-Monthan, en Arizona, au sein du 55th Electronic Combat Group, les quatorze EC-130H sont prêts à partir à bref délai partout dans le monde. Ils interviennent au **Panama**, en Haïti, en **Yougoslavie**, en Irak et en **Afghanistan**, où ils accumulent de 2002 à 2015 plus de 40 000 heures de vol en 6 900 sorties de combat. Avec l''EA-18G Growler et le F-16CJ, ils forment alors l''un des trois piliers américains de la guerre électronique, capables de neutraliser les défenses aériennes en brouillant radars et communications.\n\n## Place dans l''histoire\nLe Compass Call a fait du brouillage des communications une arme à part entière, conduite par des linguistes autant que par des aviateurs. Le premier appareil retiré, le 15 janvier 2020, est aussi le premier livré en 1982. Son équipement de mission migre vers l''**EA-37B**, bâti sur l''avion d''affaires Gulfstream G550 ; en septembre 2026, le dernier EC-130H effectue son ultime vol sous l''indicatif VOLT1, aux côtés de son remplaçant.',
    E'## Genesis\nThe **C-130 Hercules** had already spawned a host of specialised versions when the US Air Force decided to turn it into an electronic attack tool. The aim was not to destroy but to make the enemy deaf and dumb: jamming command and control networks, early warning radars and navigation systems. **Compass Call** first flew in 1981; the first example was delivered in March 1982 and initial operating capability was reached in 1983.\n\n## Design\nThe transport airframe is heavily modified: the mission equipment, supplied by **BAE Systems** and integrated by L3 Communications, is permanently installed in the hold. The crew numbers thirteen. Four fly the aircraft, pilot, co-pilot, navigator and flight engineer; nine operate the system, including two electronic warfare officers, an experienced cryptologic linguist supervisor, four linguist analysis operators and a maintenance technician. The **Block 35** and later **Baseline 2** standards widened the frequency range, raised radiated power and added digital signal processing, for what the Air Force calls a fifth-generation electronic attack capability.\n\n## Operational career\nBased at Davis-Monthan in Arizona with the 55th Electronic Combat Group, the fourteen EC-130Hs stand ready to deploy anywhere at short notice. They operated over **Panama**, Haiti, **Yugoslavia**, Iraq and **Afghanistan**, where from 2002 to 2015 they logged more than 40,000 flight hours in 6,900 combat sorties. With the EA-18G Growler and the F-16CJ, they formed one of the three American pillars of electronic warfare, able to neutralise air defences by jamming radars and communications.\n\n## Place in history\nCompass Call made communications jamming a weapon in its own right, wielded by linguists as much as by airmen. The first aircraft retired, on 15 January 2020, was also the first delivered in 1982. Its mission equipment is moving to the **EA-37B**, built on the Gulfstream G550 business jet; in September 2026 the last EC-130H made its final flight under the callsign VOLT1, alongside its replacement.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1981-01-01',
    '1983-01-01',
    NULL,
    4250,
    (SELECT id FROM manufacturer WHERE code = 'LOC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Guerre électronique'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'EC-130H Compass Call'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'EC-130H Compass Call'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'EC-130H Compass Call'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'EC-130H Compass Call'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'EC-130H Compass Call'), (SELECT id FROM wars WHERE name = 'Invasion du Panama')),
((SELECT id FROM airplanes WHERE name = 'EC-130H Compass Call'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'EC-130H Compass Call'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.1,
  wingspan          = 40.41,
  height            = 11.66,
  wing_area         = NULL,
  empty_weight      = 45813,
  mtow              = 70307,
  service_ceiling   = 7620,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 13,

  -- Strate 2 : motorisation
  engine_name       = 'Allison T56-A-15 (4 591 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 14,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **EC-130H** : version de série, quatorze appareils dérivés du C-130 Hercules\n- **Block 35 Baseline 1** : brouillage des communications, des radars d''alerte et de la navigation, puissance et gamme de fréquences accrues\n- **Baseline 2** : modifications de mission en grande partie classifiées, précision et capacités d''attaque renforcées\n- **EA-37B** : successeur bâti sur le Gulfstream G550, qui reprend l''équipement de mission',
  variants_en       = E'- **EC-130H**: production version, fourteen aircraft derived from the C-130 Hercules\n- **Block 35 Baseline 1**: jamming of communications, early warning radars and navigation, with greater power and frequency range\n- **Baseline 2**: largely classified mission modifications, improved precision and attack capability\n- **EA-37B**: successor built on the Gulfstream G550, taking over the mission equipment',

  -- Strate 4 : qualitatif
  nickname          = 'Compass Call',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_EC-130H_Compass_Call',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Senior Airman Jacqueline Hawkins, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'EC-130H Compass Call';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'EC-130H Compass Call';
