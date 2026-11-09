-- Shaanxi Y-9
--
-- Photo : Y-9.jpg
--   licence CC BY-SA 4.0 — Alert5
--   https://commons.wikimedia.org/wiki/File:Y-9.jpg

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
    'Shaanxi Y-9',
    'Shaanxi Y-9',
    'Shaanxi Y-9',
    'Shaanxi Y-9',
    'Le Y-8 refait à neuf, devenu la plateforme de presque tous les avions spéciaux chinois',
    'The Y-8 rebuilt from scratch, now the platform for almost every Chinese special-mission aircraft',
    '/assets/airplanes/y9.jpg',
    E'## Genèse\nLe **Shaanxi Y-8**, version chinoise de l''**Antonov An-12**, est depuis les années 1970 le pilier du transport tactique de l''Armée populaire de libération. Au début des années 2000, Shaanxi engage une refonte profonde du modèle, d''abord connue sous le nom de Y-8X et menée selon plusieurs sources avec le concours d''Antonov, avec pour cible les performances du **C-130J** américain. La désignation Y-9 est adoptée en 2005.\n\n## Conception\nLa silhouette rappelle celle du Y-8, mais l''essentiel est neuf : soute allongée, rampe arrière de chargement, poste de pilotage à écrans, quatre turbopropulseurs **WJ-6C** entraînant des hélices à six pales. L''appareil emporte 20 tonnes de fret ou 106 parachutistes, et franchit 2 200 km avec 15 tonnes à bord. Sa cellule sert surtout de plateforme : la plupart des avions spéciaux chinois de la décennie 2010 en dérivent.\n\n## Carrière opérationnelle\nLe Y-9 vole pour la première fois en novembre 2010 et entre en service en 2012 dans l''armée de l''air chinoise. Le transport proprement dit n''est qu''une part de son activité : la même cellule porte l''avion de guet **KJ-500**, le patrouilleur anti-sous-marin Y-9Q et plusieurs versions de renseignement et de guerre électroniques, en service dans l''armée de l''air comme dans l''aéronavale. La version d''exportation Y-9E a été livrée à la Namibie fin 2024.\n\n## Place dans l''histoire\nLe Y-9 achève la transformation d''une copie d''Antonov des années 1950 en plateforme moderne et polyvalente. Moins spectaculaire que le **Xian Y-20**, il est pourtant l''appareil qui a donné à la Chine, en un peu plus d''une décennie, une flotte complète d''avions spéciaux — guet aérien, lutte anti-sous-marine, renseignement — sur une base industrielle unique.',
    E'## Genesis\nThe **Shaanxi Y-8**, the Chinese version of the **Antonov An-12**, had been the mainstay of People''s Liberation Army tactical transport since the 1970s. In the early 2000s Shaanxi began a thorough redesign, first known as the Y-8X and conducted, according to several sources, with Antonov''s assistance, targeting the performance of the American **C-130J**. The Y-9 designation was adopted in 2005.\n\n## Design\nThe silhouette recalls the Y-8, but what matters is new: a lengthened hold, a rear loading ramp, a glass cockpit and four **WJ-6C** turboprops driving six-blade propellers. The aircraft carries 20 tonnes of freight or 106 paratroops, and covers 2,200 km with 15 tonnes on board. Above all its airframe is a platform: most Chinese special-mission aircraft of the 2010s derive from it.\n\n## Operational career\nThe Y-9 first flew in November 2010 and entered Chinese air force service in 2012. Transport proper is only part of its work: the same airframe carries the **KJ-500** early-warning aircraft, the Y-9Q anti-submarine patrol aircraft and several electronic intelligence and electronic warfare versions, serving with both the air force and naval aviation. The Y-9E export version was delivered to Namibia at the end of 2024.\n\n## Place in history\nThe Y-9 completes the transformation of a 1950s Antonov copy into a modern, versatile platform. Less spectacular than the **Xian Y-20**, it is nonetheless the aircraft that gave China, in little more than a decade, a complete special-mission fleet — early warning, anti-submarine warfare, intelligence — on a single industrial base.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    NULL,
    '2010-11-01',
    '2012-01-01',
    660.0,
    5700.0,
    (SELECT id FROM manufacturer WHERE code = 'SHX'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shaanxi Y-9'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shaanxi Y-9'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Shaanxi Y-9'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Shaanxi Y-9'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 36.07,
  wingspan          = 38.0,
  height            = 11.3,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 65000,
  service_ceiling   = 10400,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Zhuzhou WJ-6C',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Y-9** : transport tactique de base, 20 t de fret ou 106 parachutistes\n- **KJ-500** : guet aérien à antennes actives fixes\n- **Y-9Q** : patrouille maritime et lutte anti-sous-marine\n- **Y-9JZ / Y-9G** : renseignement électronique et guerre électronique\n- **Y-9E** : version d''exportation, livrée à la Namibie',
  variants_en       = E'- **Y-9** : basic tactical transport, 20 t of freight or 106 paratroops\n- **KJ-500** : early warning with fixed active arrays\n- **Y-9Q** : maritime patrol and anti-submarine warfare\n- **Y-9JZ / Y-9G** : electronic intelligence and electronic warfare\n- **Y-9E** : export version, delivered to Namibia',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Shaanxi_Y-9',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Shaanxi_Y-9',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alert5',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Shaanxi Y-9';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Shaanxi Y-9';
