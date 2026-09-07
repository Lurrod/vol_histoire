-- North American Rockwell OV-10 Bronco
--
-- Photo : NASA OV-10.jpg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File%3ANASA_OV-10.jpg

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
    'OV-10 Bronco',
    'OV-10 Bronco',
    'North American Rockwell OV-10 Bronco',
    'North American Rockwell OV-10 Bronco',
    'Avion de contre-insurrection à double poutre, conçu pour les terrains sommaires',
    'Twin-boom counter-insurgency aircraft designed for rough strips',
    '/assets/airplanes/ov10-bronco.jpg',
    E'## Genèse\nAu début des années 1960, les forces américaines découvrent au Vietnam qu''elles n''ont **aucun avion adapté à la contre-insurrection** : les jets vont trop vite pour voir, les hélicoptères sont trop vulnérables. Le programme LARA demande un appareil lent, endurant, capable de décoller de 300 mètres de piste sommaire.\n\n## Conception\nDouble poutre pour dégager la vue et libérer une soute arrière, deux turbopropulseurs, verrière immense offrant une visibilité quasi totale. Le Bronco peut emporter cinq parachutistes ou une civière, se poser sur une route, et voler cinq heures. Sa vitesse — 450 km/h — est un choix, pas une limite subie.\n\n## Carrière opérationnelle\nAu **Vietnam**, il assure le contrôle aérien avancé : repérer les cibles, marquer à la roquette fumigène, guider les chasseurs. Rôle discret et extrêmement exposé — soixante-quatre appareils sont perdus. Il sert ensuite au Golfe en 1991, puis en Colombie, aux Philippines, au Maroc et au Venezuela.\n\n## Place dans l''histoire\nLe Bronco a validé une catégorie que les grandes forces aériennes abandonnent puis redécouvrent régulièrement : l''appareil léger d''appui, lent et bon marché. En 2015, l''US Central Command en a réengagé deux exemplaires au Moyen-Orient pour évaluer, quarante ans plus tard, la pertinence du concept.',
    E'## Genesis\nIn the early 1960s American forces discovered in Vietnam that they had **no aircraft suited to counter-insurgency**: jets flew too fast to see, helicopters were too vulnerable. The LARA programme asked for a slow, long-endurance aircraft able to take off from 300 metres of rough strip.\n\n## Design\nTwin booms to clear the view and free a rear cargo bay, two turboprops, and a vast canopy giving almost total visibility. The Bronco can carry five paratroopers or a stretcher, land on a road, and fly for five hours. Its speed — 450 km/h — is a choice, not an accepted limitation.\n\n## Operational career\nOver **Vietnam** it flew forward air control: finding targets, marking them with smoke rockets, guiding the fighters in. A discreet and extremely exposed role — sixty-four aircraft were lost. It went on to serve in the Gulf in 1991, then in Colombia, the Philippines, Morocco and Venezuela.\n\n## Place in history\nThe Bronco validated a category that major air forces abandon and rediscover in turn: the light, slow, cheap support aircraft. In 2015 US Central Command redeployed two of them to the Middle East to assess, forty years on, whether the concept still held.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1962-01-01',
    '1965-07-16',
    '1968-02-23',
    452.0,
    2224.0,
    (SELECT id FROM manufacturer WHERE code = 'ROC'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM armement WHERE name = 'Hydra 70')),
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM armement WHERE name = 'Zuni 127 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.67,
  wingspan          = 12.19,
  height            = 4.62,
  wing_area         = 27.03,
  empty_weight      = 3127,
  mtow              = 6552,
  service_ceiling   = 7315,
  climb_rate        = 13,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 370,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett T76-G-420/421',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1967,
  production_end    = 1976,
  units_built       = 360,
  unit_cost_usd     = 480000,
  unit_cost_year    = 1970,
  operators_count   = 8,
  variants          = E'- **OV-10A** : version initiale, contrôle aérien avancé et appui léger\n- **OV-10D NOGS** : version de nuit à caméra infrarouge et canon en tourelle\n- **OV-10B** : version allemande de remorquage de cibles\n- Encore utilisé aujourd''hui par des agences civiles pour la **lutte contre les incendies**',
  variants_en       = E'- **OV-10A** : initial version for forward air control and light attack\n- **OV-10D NOGS** : night version with infrared camera and turreted gun\n- **OV-10B** : German target-towing version\n- Still used today by civilian agencies for **firefighting**',

  -- Strate 4 : qualitatif
  nickname          = 'Bronco',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_Rockwell_OV-10_Bronco',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_Rockwell_OV-10_Bronco',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'OV-10 Bronco';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'OV-10 Bronco';
