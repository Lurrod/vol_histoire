-- Air Tractor / L3Harris OA-1K Skyraider II
--
-- Photo : OA-1K testing (2).jpg
--   licence Public domain — (Courtesy image)
--   https://commons.wikimedia.org/wiki/File:OA-1K_testing_(2).jpg

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
    'L3Harris OA-1K Skyraider II',
    'L3Harris OA-1K Skyraider II',
    'Air Tractor / L3Harris OA-1K Skyraider II',
    'Air Tractor / L3Harris OA-1K Skyraider II',
    'Un avion agricole blindé et armé, choisi par les forces spéciales américaines pour veiller sur leurs équipes',
    'An armoured, armed crop-duster chosen by US special forces to watch over their teams on the ground',
    '/assets/airplanes/oa1k-skyraider-2.jpg',
    E'## Genèse\nLe commandement des opérations spéciales américain, le **SOCOM**, lance le programme **Armed Overwatch** pour se doter d''un avion d''attaque légère et de reconnaissance armée. L''**AT-802U Sky Warden**, proposé par **Air Tractor** et **L3Harris**, remporte la compétition : en août 2022, un contrat de 3 milliards de dollars prévoit 75 appareils d''ici 2029. Désigné **OA-1K** à la fin de 2022, l''avion doit remplacer l''U-28A Draco, un appareil de surveillance non armé souvent engagé en contre-insurrection.\n\n## Conception\nL''avion dérive de l''**Air Tractor AT-802**, un monomoteur d''épandage agricole et de lutte contre les incendies. Une version servait déjà à détruire les cultures de coca et en avait hérité une « baignoire » de blindage composite autour du moteur et du poste, un pare-brise en verre balistique et une cage en tubes d''acier capable de porter l''avion entier. Pas de siège éjectable, mais des réservoirs auto-obturants et des harnais à airbags. Le turbopropulseur **PT6A-67F** de 1 600 ch entraîne une hélice à cinq pales ; dix points d''emport reçoivent missiles **Hellfire**, roquettes guidées APKWS, bombes **GBU-12** et deux tourelles optroniques. Le train classique vise les pistes sommaires, et l''avion se démonte en un jour pour tenir dans un seul C-17. Air Tractor construit la cellule à Olney, au Texas, L3Harris ajoute blindage et armement à Tulsa.\n\n## Carrière opérationnelle\nEn décembre 2023, le **GAO**, l''organe de contrôle des dépenses fédérales, juge la flotte trop nombreuse et demande de ralentir le programme ; la commande est ramenée à 62 appareils en mars 2024. Deux AT-802U non modifiés arrivent à Hurlburt Field en juin 2024 pour former les premiers équipages, et le premier OA-1K complet est livré au commandement des opérations spéciales de l''Air Force en avril 2025. Le 17th Special Operations Squadron, à Oklahoma City, en devient l''unité de formation. Le 24 octobre 2025, un appareil est détruit dans un atterrissage forcé : l''élève avait fermé le robinet principal de carburant au lieu de changer de réservoir. Dix-huit appareils étaient construits en mai 2026.\n\n## Place dans l''histoire\nEn février 2025, l''Air Force le baptise **Skyraider II**, en hommage à l''**A-1 Skyraider**, autre avion d''attaque à train classique de ses commandos pendant la guerre du Vietnam. La désignation OA-1K n''a pourtant rien de systématique : l''avion n''a aucun lien technique avec l''appareil de Douglas. Il marque le retour d''un avion d''appui lent, robuste et bon marché dans l''aviation américaine, pensé pour la contre-insurrection et la surveillance armée.',
    E'## Genesis\nUS Special Operations Command, **SOCOM**, launched the **Armed Overwatch** programme to acquire a light attack and armed reconnaissance aircraft. The **AT-802U Sky Warden**, offered by **Air Tractor** and **L3Harris**, won the competition: in August 2022 a $3 billion contract called for 75 aircraft by 2029. Designated **OA-1K** in late 2022, it is to replace the U-28A Draco, an unarmed surveillance aircraft often used in counter-insurgency.\n\n## Design\nThe aircraft derives from the **Air Tractor AT-802**, a single-engined crop-spraying and firefighting type. One version was already used to destroy coca crops and had gained a composite armoured ''bathtub'' around the engine and cockpit, a ballistic glass windscreen and a steel-tube cage able to bear the weight of the whole aircraft. There are no ejection seats, but self-sealing tanks, airbag harnesses and flight controls in both seats. The 1,600 hp **PT6A-67F** turboprop drives a five-blade propeller; ten hardpoints carry **Hellfire** missiles, APKWS guided rockets, **GBU-12** bombs and two electro-optical turrets. The tailwheel undercarriage is meant for rough strips, and the aircraft can be dismantled in a day to fit inside a single C-17. Air Tractor builds the airframe at Olney, Texas, and L3Harris adds armour and weapons at Tulsa.\n\n## Operational career\nIn December 2023 the **GAO**, the federal spending watchdog, judged the fleet too large and urged the programme be slowed; the order was cut to 62 aircraft in March 2024. Two unmodified AT-802Us reached Hurlburt Field in June 2024 to train the first crews, and the first complete OA-1K was delivered to Air Force Special Operations Command in April 2025. The 17th Special Operations Squadron, at Oklahoma City, became its training unit. On 24 October 2025 one aircraft was written off in a forced landing shortly after take-off: the trainee had closed the main fuel valve instead of switching tanks. Eighteen had been built by May 2026.\n\n## Place in history\nIn February 2025 the Air Force named it **Skyraider II**, in tribute to the **A-1 Skyraider**, another tailwheel attack aircraft flown by its commandos during the Vietnam War. The OA-1K designation is nonetheless non-systematic: the aircraft has no technical link with the Douglas type. It marks the return of a slow, rugged and cheap support aircraft to American air power, intended for counter-insurgency and armed surveillance.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    NULL,
    '2025-04-01',
    394,
    2413,
    (SELECT id FROM manufacturer WHERE code = 'L3H'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'L3Harris OA-1K Skyraider II'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'L3Harris OA-1K Skyraider II'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'L3Harris OA-1K Skyraider II'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'L3Harris OA-1K Skyraider II'), (SELECT id FROM armement WHERE name = 'AGM-114 Hellfire')),
((SELECT id FROM airplanes WHERE name = 'L3Harris OA-1K Skyraider II'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'L3Harris OA-1K Skyraider II'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'L3Harris OA-1K Skyraider II'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.4,
  wingspan          = 18.06,
  height            = 4.0,
  wing_area         = 37.3,
  empty_weight      = 3554,
  mtow              = 7257,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-67F (1 600 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 18,
  unit_cost_usd     = 18000000,
  unit_cost_year    = 2025,
  operators_count   = 1,
  variants          = E'- **Air Tractor AT-802** : monomoteur agricole et bombardier d''eau dont dérive la cellule\n- **AT-802U Sky Warden** : version militaire blindée et armée, nom commercial de L3Harris\n- **OA-1K Skyraider II** : désignation dans l''US Air Force, commande ramenée de 75 à 62 appareils',
  variants_en       = E'- **Air Tractor AT-802**: agricultural and firefighting single from which the airframe derives\n- **AT-802U Sky Warden**: armoured and armed military version, L3Harris''s commercial name\n- **OA-1K Skyraider II**: US Air Force designation, order cut from 75 to 62 aircraft',

  -- Strate 4 : qualitatif
  nickname          = 'Sky Warden',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/L3Harris_OA-1K_Skyraider_II',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/L3Harris_OA-1K_Skyraider_II',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'L3Harris OA-1K Skyraider II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'L3Harris OA-1K Skyraider II';
