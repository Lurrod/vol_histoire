-- General Atomics YFQ-42A Dark Merlin
--
-- Photo : A YFQ-42A lifts off during a flight test at a range in California 250827-F-AF000-9001 (cropped).jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:A_YFQ-42A_lifts_off_during_a_flight_test_at_a_range_in_California_250827-F-AF000-9001_(cropped).jpg

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
    'General Atomics YFQ-42A Dark Merlin',
    'General Atomics YFQ-42A Dark Merlin',
    'General Atomics YFQ-42A Dark Merlin',
    'General Atomics YFQ-42A Dark Merlin',
    'Le premier « avion de combat collaboratif » de l’US Air Force à voler : un ailier sans pilote',
    'The first US Air Force "collaborative combat aircraft" to fly: an uncrewed wingman',
    '/assets/airplanes/yfq42-dark-merlin.jpg',
    E'## Genèse\nAu début des années 2020, l''US Air Force constate qu''elle ne pourra jamais aligner assez de F-35 et de chasseurs de nouvelle génération face à la Chine. Elle lance le programme **CCA** (*Collaborative Combat Aircraft*) : des drones de combat assez bon marché pour être achetés par centaines et risqués au combat, chacun accompagnant un avion piloté. Le 25 avril 2024, **General Atomics** et Anduril sont retenus pour le premier incrément, devant Boeing, Lockheed Martin et Northrop Grumman. Les désignations YFQ-42A et YFQ-44A sont attribuées en mars 2025 : pour la première fois, des drones reçoivent le préfixe F des chasseurs.\n\n## Conception\nL''appareil dérive du **XQ-67A**, un démonstrateur construit par General Atomics pour le laboratoire de recherche de l''US Air Force et qui avait volé le 28 février 2024. La formule est celle d''un petit avion de combat subsonique à réacteur unique. L''architecture est pensée pour la production en série et le partage de composants entre versions. Le constructeur et l''US Air Force n''ont publié ni dimensions, ni masses, ni performances.\n\n## Carrière opérationnelle\nLe **27 août 2025**, le YFQ-42A est le premier avion du programme CCA à voler ; son concurrent, l''**Anduril YFQ-44A Fury**, le suit à l''automne. En février 2026, General Atomics le baptise **Dark Merlin**, du nom d''un faucon. Le 6 avril 2026, un prototype est perdu peu après le décollage ; l''accident est attribué à une erreur de calcul de la masse et du centrage par le pilote automatique. En juin 2026, l''US Air Force retient les deux concurrents pour une première commande de série ; elle annonce en septembre que la version de production s''appellera FQ-42 Vengeance. Aucune mise en service n''est intervenue à la date de rédaction.\n\n## Place dans l''histoire\nLe YFQ-42A est l''aboutissement américain de l''idée d''ailier sans pilote explorée par le **XQ-58 Valkyrie** de Kratos, et menée en parallèle par l''Australie avec le **MQ-28 Ghost Bat**. Il marque un changement d''échelle : le drone de combat n''est plus un démonstrateur unique, mais un appareil de série commandé pour accompagner la flotte de chasse.',
    E'## Genesis\nIn the early 2020s the US Air Force recognised that it could never field enough F-35s and new-generation fighters against China. It launched the **CCA** (*Collaborative Combat Aircraft*) programme: combat drones cheap enough to be bought by the hundred and risked in combat, each accompanying a crewed aircraft. On 25 April 2024 **General Atomics** and Anduril were chosen for the first increment, ahead of Boeing, Lockheed Martin and Northrop Grumman. The YFQ-42A and YFQ-44A designations were given in March 2025: for the first time, drones received the F prefix of fighters.\n\n## Design\nThe aircraft derives from the **XQ-67A**, a demonstrator built by General Atomics for the US Air Force Research Laboratory, which had flown on 28 February 2024. The layout is that of a small single-engined subsonic combat aircraft. The architecture is designed for series production and for sharing components between versions. Neither the manufacturer nor the US Air Force has published dimensions, weights or performance.\n\n## Operational career\nOn **27 August 2025** the YFQ-42A became the first aircraft of the CCA programme to fly; its competitor, the **Anduril YFQ-44A Fury**, followed in the autumn. In February 2026 General Atomics named it **Dark Merlin**, after a falcon. On 6 April 2026 a prototype was lost shortly after take-off; the accident was attributed to the autopilot miscalculating weight and centre of gravity. In June 2026 the US Air Force selected both competitors for an initial production order; in September it announced that the production version would be called FQ-42 Vengeance. No entry into service had taken place at the time of writing.\n\n## Place in history\nThe YFQ-42A is the American culmination of the uncrewed-wingman idea explored by Kratos''s **XQ-58 Valkyrie**, and pursued in parallel by Australia with the **MQ-28 Ghost Bat**. It marks a change of scale: the combat drone is no longer a one-off demonstrator but a production aircraft ordered to accompany the fighter fleet.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2024-04-25',
    '2025-08-27',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'GA'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'General Atomics YFQ-42A Dark Merlin'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'General Atomics YFQ-42A Dark Merlin'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'General Atomics YFQ-42A Dark Merlin'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'General Atomics YFQ-42A Dark Merlin'), (SELECT id FROM missions WHERE name = 'Escorte'));

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
  engine_name       = NULL,
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XQ-67A** : démonstrateur du laboratoire de recherche de l''US Air Force, premier vol le **28 février 2024**\n- **YFQ-42A** : prototype de l''incrément 1 du programme **CCA**, premier vol le **27 août 2025**\n- **FQ-42 Vengeance** : nom annoncé en septembre 2026 pour la version de série\n- Concurrent et partenaire de série : l''**Anduril YFQ-44A Fury**\n\n*Programme en cours : dimensions, masses et performances ne sont pas publiées, les valeurs manquantes sont laissées vides plutôt qu''estimées.*',
  variants_en       = E'- **XQ-67A** : US Air Force Research Laboratory demonstrator, first flight on **28 February 2024**\n- **YFQ-42A** : prototype for Increment 1 of the **CCA** programme, first flight on **27 August 2025**\n- **FQ-42 Vengeance** : name announced in September 2026 for the production version\n- Competitor and production partner: the **Anduril YFQ-44A Fury**\n\n*Programme in progress: dimensions, weights and performance are not published; missing values are left blank rather than estimated.*',

  -- Strate 4 : qualitatif
  nickname          = 'Dark Merlin',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/General_Atomics_YFQ-42_Dark_Merlin',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'General Atomics YFQ-42A Dark Merlin';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'General Atomics YFQ-42A Dark Merlin';
