-- Chengdu Wing Loong I (GJ-1, Pterodactyl I)
--
-- Photo : Wing Loong (2).jpg
--   licence CC BY-SA 4.0 — Kalabaha1969
--   https://commons.wikimedia.org/wiki/File:Wing_Loong_(2).jpg

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
    'CAIG Wing Loong',
    'CAIG Wing Loong',
    'Chengdu Wing Loong I (GJ-1, Pterodactyl I)',
    'Chengdu Wing Loong I (GJ-1, Pterodactyl I)',
    'Le premier drone armé chinois vendu à l''étranger, engagé au Yémen et en Libye',
    'The first Chinese armed drone sold abroad, used in combat over Yemen and Libya',
    '/assets/airplanes/wing-loong.jpg',
    E'## Genèse\nLe programme **Wing Loong** est lancé en mai 2005 par l''institut de conception aéronautique de **Chengdu**, filiale d''**AVIC**, pour doter la Chine d''un drone de moyenne altitude et longue endurance. Un premier modèle, le **Pterosaur I**, vole en octobre 2007 et achève ses essais de charge utile un an plus tard. La version suivante, le **Pterodactyl I**, s''en distingue par une bosse sur le nez qui abrite une antenne satellite. Une maquette est exposée au salon de Zhuhai en 2010, première reconnaissance publique du programme, et le drone entre en service en 2011.\n\n## Conception\nLa ressemblance avec la famille **Predator** et **Reaper** américaine est frappante : fuselage effilé, boule de capteurs sous le nez, empennage en V et hélice tripale propulsive entraînée par un moteur **Rotax 914** turbocompressé de 100 ch. L''appareil pèse 1,1 t, vole à 280 km/h et tient une vingtaine d''heures. Il décolle et atterrit de façon entièrement automatique. Sa charge de 200 kg peut combiner capteurs infrarouges, radar à synthèse d''ouverture, désignateur laser, petites bombes guidées et missiles air-sol légers ; les versions militaires chinoises WJ-1 et GJ-1 sont dévoilées en 2014.\n\n## Carrière opérationnelle\nVendu environ un million de dollars pièce, le Wing Loong s''exporte vers les Émirats arabes unis dès 2011, puis vers l''Arabie saoudite, l''Égypte, le Kazakhstan, le Nigeria et d''autres. Au **Yémen**, les drones émiratis et saoudiens sont engagés contre les Houthis : en avril 2018, l''un d''eux tue Saleh Ali al-Sammad, haut dirigeant houthi, mais beaucoup sont abattus. En **Libye**, à partir de 2019, l''Armée nationale libyenne du maréchal Haftar emploie massivement des Wing Loong fournis par les Émirats ; le 6 août 2019, l''un d''eux détruit au sol un Il-76 à Misrata. L''Égypte, elle, l''utilise dès 2017 contre les militants armés du Nord-Sinaï.\n\n## Place dans l''histoire\nLe Wing Loong a mis à la portée des armées du Moyen-Orient et d''Afrique des drones armés à un prix nettement inférieur à celui de ses concurrents : dès 2013, AVIC disait négocier avec cinq ou six pays d''Afrique et d''Asie. Il a fait de la Chine un acteur majeur de la guerre par drones et donné naissance au **Wing Loong II**, plus lourd, en service dans l''armée de l''air chinoise depuis novembre 2018, ainsi qu''à des versions améliorées, le Wing Loong ID choisi par l''Égypte et le Wing Loong 1E.',
    E'## Genesis\nThe **Wing Loong** programme was launched in May 2005 by the **Chengdu** aircraft design institute, a subsidiary of **AVIC**, to give China a medium-altitude long-endurance drone. A first model, the **Pterosaur I**, flew in October 2007 and completed its payload trials a year later. The following version, the **Pterodactyl I**, is distinguished by a bulge on the nose housing a satellite antenna. A model was shown at the 2010 Zhuhai air show, the first public acknowledgement of the programme, and the drone entered service in 2011.\n\n## Design\nThe resemblance to the American **Predator** and **Reaper** family is striking: slender fuselage, sensor ball under the nose, V-tail and a three-blade pusher propeller driven by a 100 hp turbocharged **Rotax 914** engine. The aircraft weighs 1.1 t, flies at 280 km/h and stays aloft for around twenty hours. It takes off and lands fully automatically. Its 200 kg payload can combine infrared sensors, synthetic aperture radar, a laser designator, small guided bombs and light air-to-surface missiles; the Chinese military WJ-1 and GJ-1 versions were unveiled in 2014.\n\n## Operational career\nSold for about one million dollars apiece, the Wing Loong was exported to the United Arab Emirates from 2011, then to Saudi Arabia, Egypt, Kazakhstan, Nigeria and others. In **Yemen**, Emirati and Saudi drones were used against the Houthis: in April 2018 one of them killed the senior Houthi leader Saleh Ali al-Sammad, but many were shot down. In **Libya**, from 2019, Marshal Haftar''s Libyan National Army made heavy use of Wing Loongs supplied by the Emirates; on 6 August 2019 one destroyed an Il-76 on the ground at Misrata. Egypt, for its part, used it from 2017 against militants in North Sinai.\n\n## Place in history\nThe Wing Loong put armed drones within reach of Middle Eastern and African forces at a price well below that of its competitors: as early as 2013, AVIC said it was negotiating with five or six countries in Africa and Asia. It made China a major player in drone warfare and gave rise to the heavier **Wing Loong II**, in Chinese air force service since November 2018, as well as improved versions, the Wing Loong ID chosen by Egypt and the Wing Loong 1E.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2005-05-01',
    '2007-10-01',
    '2011-01-01',
    280,
    4000,
    (SELECT id FROM manufacturer WHERE code = 'CAC'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'CAIG Wing Loong'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'CAIG Wing Loong'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'CAIG Wing Loong'), (SELECT id FROM tech WHERE name = 'Pod désignateur laser'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'CAIG Wing Loong'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'CAIG Wing Loong'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'CAIG Wing Loong'), (SELECT id FROM wars WHERE name = 'Guerre civile yéménite')),
((SELECT id FROM airplanes WHERE name = 'CAIG Wing Loong'), (SELECT id FROM wars WHERE name = 'Guerre civile libyenne (2014-2020)'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.05,
  wingspan          = 14,
  height            = 2.77,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 1100,
  service_ceiling   = 5000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rotax 914 turbocompressé (100 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = 1000000,
  unit_cost_year    = 2011,
  operators_count   = 12,
  variants          = E'- **Pterosaur I** : premier modèle, sans antenne satellite, portée de contrôle limitée à environ 200 km, premier vol en octobre 2007\n- **Pterodactyl I** : version d''exportation la plus diffusée, antenne satellite sous un carénage de nez\n- **WJ-1 / GJ-1** : versions armées de l''armée chinoise, dévoilées à Zhuhai en novembre 2014\n- **Sky Saker** : dérivé de Norinco, reconnaissance ou frappe mais pas les deux à la fois\n- **Wing Loong ID / 1E** : versions améliorées, premiers vols le 23 décembre 2018 et le 20 janvier 2022',
  variants_en       = E'- **Pterosaur I**: first model, without satellite antenna, control range limited to about 200 km, first flight in October 2007\n- **Pterodactyl I**: most widely exported version, satellite antenna under a nose fairing\n- **WJ-1 / GJ-1**: armed versions for the Chinese military, unveiled at Zhuhai in November 2014\n- **Sky Saker**: Norinco derivative, reconnaissance or strike but not both at once\n- **Wing Loong ID / 1E**: improved versions, first flights on 23 December 2018 and 20 January 2022',

  -- Strate 4 : qualitatif
  nickname          = 'Pterodactyl',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Wing_Loong',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/CAIG_Wing_Loong',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Kalabaha1969',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'CAIG Wing Loong';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'CAIG Wing Loong';
