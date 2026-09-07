-- Yakovlev Yak-25 Flashlight
--
-- Photo : Yakolev Yak-25M 03 red (10086207286).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File%3AYakolev_Yak-25M_03_red_%2810086207286%29.jpg

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
    'Yak-25',
    'Yak-25',
    'Yakovlev Yak-25 Flashlight',
    'Yakovlev Yak-25 Flashlight',
    'Premier intercepteur tout-temps soviétique à long rayon d’action',
    'First Soviet long-range all-weather interceptor',
    '/assets/airplanes/yak25.jpg',
    E'## Genèse\nAu début des années 1950, l''URSS n''a aucun intercepteur capable de tenir l''air longtemps au-dessus de ses immenses frontières nord. Les MiG-15 et MiG-17 ont un rayon d''action de chasseur de jour. Yakovlev propose un **biplace bimoteur** conçu autour de son radar, pas autour de ses performances.\n\n## Conception\nAile en flèche montée haut, deux réacteurs en nacelles sous voilure, et le train en **tandem** dans le fuselage avec des balancines en bout d''aile — architecture que Yakovlev conservera sur toute la lignée jusqu''au Yak-28. Le pilote et l''opérateur radar sont en tandem sous une longue verrière.\n\n## Carrière opérationnelle\nSix cent trente-huit exemplaires, exclusivement soviétiques. Jamais engagé en combat, il assure quinze ans la veille des approches arctiques. Sa version **Yak-25RV**, à envergure très allongée, est développée spécifiquement pour intercepter les ballons et les U-2 américains à très haute altitude — sans jamais y parvenir.\n\n## Place dans l''histoire\nLe Yak-25 fonde une famille entière : le **Yak-28** bombardier supersonique en descend directement, et avec lui la dernière génération d''appareils de combat du bureau Yakovlev avant son basculement vers l''entraînement et le décollage vertical.',
    E'## Genesis\nIn the early 1950s the USSR had no interceptor able to stay airborne for long over its vast northern frontiers. The MiG-15 and MiG-17 had a day fighter’s radius. Yakovlev proposed a **two-seat twin-engine** aircraft designed around its radar rather than its performance.\n\n## Design\nA high-mounted swept wing, two engines in underwing nacelles, and **tandem** landing gear in the fuselage with outriggers at the wingtips — an architecture Yakovlev kept across the whole line through to the Yak-28. Pilot and radar operator sit in tandem under a long canopy.\n\n## Operational career\nSix hundred and thirty-eight built, all Soviet. Never committed to combat, it stood watch over the Arctic approaches for fifteen years. Its long-span **Yak-25RV** version was developed specifically to intercept balloons and American U-2s at very high altitude — without ever succeeding.\n\n## Place in history\nThe Yak-25 founded an entire family: the supersonic **Yak-28** bomber descends directly from it, and with it the Yakovlev bureau’s last generation of combat aircraft before it turned to trainers and vertical take-off.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1951-01-01',
    '1952-06-19',
    '1955-01-01',
    1090.0,
    2700.0,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-25'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Yak-25'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-25'), (SELECT id FROM armement WHERE name = 'NR-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-25'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Yak-25'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Yak-25'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-25'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.67,
  wingspan          = 11.0,
  height            = 4.32,
  wing_area         = 28.94,
  empty_weight      = 5720,
  mtow              = 10890,
  service_ceiling   = 14000,
  climb_rate        = 45,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1100,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Mikulin AM-5A',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 26.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1958,
  units_built       = 638,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Yak-25M** : intercepteur de série à radar Sokol\n- **Yak-25R** : version de reconnaissance tactique\n- **Yak-25RV** : version de très haute altitude à grande envergure, réponse au U-2\n- **Yak-26 / Yak-27 / Yak-28** : lignée de bombardiers et intercepteurs qui en dérive',
  variants_en       = E'- **Yak-25M** : production interceptor with Sokol radar\n- **Yak-25R** : tactical reconnaissance version\n- **Yak-25RV** : very high altitude, long-span version, the answer to the U-2\n- **Yak-26 / Yak-27 / Yak-28** : the line of bombers and interceptors derived from it',

  -- Strate 4 : qualitatif
  nickname          = 'Flashlight',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-25',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-25',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Yak-25';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-25';
