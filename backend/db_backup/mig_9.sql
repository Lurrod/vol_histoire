-- Mikoyan-Gourevitch MiG-9
--
-- Photo : MiG-9 VVS museum.jpg
--   licence CC BY-SA 3.0 — Mike1979 Russia
--   https://commons.wikimedia.org/wiki/File%3AMiG-9_VVS_museum.jpg

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
    'MiG-9',
    'MiG-9',
    'Mikoyan-Gourevitch MiG-9',
    'Mikoyan-Gurevich MiG-9',
    'Premier avion à réaction soviétique à entrer en service',
    'First Soviet jet aircraft to enter service',
    '/assets/airplanes/mig9.jpg',
    E'## Genèse\nEn 1945, l''URSS s''empare des usines allemandes et de leurs réacteurs **BMW 003** et Junkers Jumo. Copiés sous les désignations RD-20 et RD-10, ils permettent de faire voler un chasseur à réaction sans attendre un moteur national. Le MiG-9 et le Yak-15 décollent le **même jour**, le 24 avril 1946 ; un tirage au sort décide lequel volera en premier.\n\n## Conception\nAile droite, deux réacteurs côte à côte dans le fuselage, entrée d''air frontale unique séparée par une cloison. Le canon de **57 mm** logé dans cette cloison pose un problème inattendu : ses gaz de tir provoquent l''extinction des réacteurs en altitude, défaut jamais entièrement résolu.\n\n## Carrière opérationnelle\nSix cent deux exemplaires, en service à peine trois ans. Le MiG-15, dont le réacteur britannique Nene est bien plus puissant, le rend obsolète avant même qu''il n''ait équipé toutes les unités. Presque tous les appareils sont cédés à la **Chine** en 1950, où ils forment les premiers pilotes de chasse de l''aviation populaire.\n\n## Place dans l''histoire\nLe MiG-9 n''a jamais combattu et n''a été exporté qu''une fois. Son importance est ailleurs : il installe le bureau **Mikoyan** comme constructeur de chasseurs à réaction, position qu''il ne quittera plus. Le MiG-15 lui succède moins de deux ans plus tard.',
    E'## Genesis\nIn 1945 the USSR seized German factories and their **BMW 003** and Junkers Jumo engines. Copied as the RD-20 and RD-10, they made it possible to fly a jet fighter without waiting for a national engine. The MiG-9 and the Yak-15 took off on **the same day**, 24 April 1946; a draw decided which would fly first.\n\n## Design\nA straight wing, two engines side by side in the fuselage, a single nose intake split by a divider. The **57 mm** cannon housed in that divider caused an unexpected problem: its firing gases flamed the engines out at altitude, a flaw never fully cured.\n\n## Operational career\nSix hundred and two built, in service barely three years. The MiG-15, with its far more powerful British Nene engine, made it obsolete before it had even equipped every unit. Almost all aircraft were transferred to **China** in 1950, where they trained the first fighter pilots of the People’s air force.\n\n## Place in history\nThe MiG-9 never fought and was exported only once. Its importance lies elsewhere: it established the **Mikoyan** bureau as a builder of jet fighters, a position it never gave up. The MiG-15 succeeded it less than two years later.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1945-01-01',
    '1946-04-24',
    '1948-01-01',
    911.0,
    800.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-9'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-9'), (SELECT id FROM armement WHERE name = 'NR-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-9'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-9'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-9'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.83,
  wingspan          = 10.0,
  height            = 3.22,
  wing_area         = 18.2,
  empty_weight      = 3420,
  mtow              = 5500,
  service_ceiling   = 13500,
  climb_rate        = 22,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 350,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'RD-20 (copie du BMW 003)',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 7.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1946,
  production_end    = 1948,
  units_built       = 602,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **MiG-9 (I-300)** : version initiale, canon de 57 mm dans la cloison d''entrée d''air\n- **MiG-9M** : cockpit pressurisé et siège éjectable\n- **MiG-9UTI** : biplace d''entraînement\n- La quasi-totalité des survivants a été cédée à la **Chine** en 1950',
  variants_en       = E'- **MiG-9 (I-300)** : initial version with a 57 mm cannon in the intake splitter\n- **MiG-9M** : pressurised cockpit and ejection seat\n- **MiG-9UTI** : two-seat trainer\n- Almost all survivors were transferred to **China** in 1950',

  -- Strate 4 : qualitatif
  nickname          = 'Fargo',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_MiG-9',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mikoyan-Gurevich_MiG-9',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mike1979 Russia',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'MiG-9';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MiG-9';
