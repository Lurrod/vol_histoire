-- Kawasaki T-4
--
-- Photo : 76-5753 Kawasaki T-4 trainer of 32 Kyoiku Hikotai in 13 Hikotai marks (5215108225).jpg
--   licence CC BY 2.0 — Jerry Gunner from Lincoln, UK
--   https://commons.wikimedia.org/wiki/File%3A76-5753_Kawasaki_T-4_trainer_of_32_Kyoiku_Hikotai_in_13_Hikotai_marks_%285215108225%29.jpg

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
    'Kawasaki T-4',
    'Kawasaki T-4',
    'Kawasaki T-4',
    'Kawasaki T-4',
    'Entraîneur intermédiaire japonais, entièrement de conception nationale',
    'Japanese intermediate trainer, entirely of national design',
    '/assets/airplanes/kawasaki-t4.jpg',
    E'## Genèse\nAu début des années 1980, la force aérienne d''autodéfense japonaise vole encore sur des entraîneurs T-33 américains vieux de trente ans. Plutôt que d''acheter sur étagère, le Japon lance un programme **entièrement national** : cellule Kawasaki, réacteur Ishikawajima-Harima, avionique japonaise.\n\n## Conception\nAile haute à légère flèche, deux petits turboréacteurs **F3** développés spécifiquement — le premier moteur d''avion à réaction conçu et produit au Japon depuis 1945. Le T-4 n''est pas armé et ne prétend pas l''être : il occupe le créneau intermédiaire entre l''entraîneur de base à hélice et le T-2 supersonique.\n\n## Carrière opérationnelle\nDeux cent douze exemplaires, tous japonais — le T-4 n''a jamais été exporté. Outre l''instruction, il assure la liaison entre bases et l''accompagnement des escadrons de chasse. Depuis 1996, c''est la monture de la patrouille acrobatique **Blue Impulse**.\n\n## Place dans l''histoire\nSa vraie portée est industrielle : en concevant seul un avion et son moteur, le Japon a reconstitué une chaîne de compétences interrompue en 1945. Cette capacité alimentera ensuite le **F-2**, le démonstrateur **X-2 Shinshin** et le programme de chasseur de sixième génération mené avec le Royaume-Uni et l''Italie.',
    E'## Genesis\nIn the early 1980s the Japan Air Self-Defense Force was still flying thirty-year-old American T-33 trainers. Rather than buy off the shelf, Japan launched an **entirely national** programme: Kawasaki airframe, Ishikawajima-Harima engine, Japanese avionics.\n\n## Design\nA modestly swept high wing and two small **F3** turbofans developed specifically for it — the first jet engine designed and produced in Japan since 1945. The T-4 is not armed and does not pretend to be: it fills the intermediate slot between the basic propeller trainer and the supersonic T-2.\n\n## Operational career\nTwo hundred and twelve built, all Japanese — the T-4 was never exported. Beyond instruction it handles liaison between bases and fighter squadron support. Since 1996 it has been the mount of the **Blue Impulse** display team.\n\n## Place in history\nIts real significance is industrial: by designing an aircraft and its engine alone, Japan rebuilt a chain of skills broken in 1945. That capability went on to feed the **F-2**, the **X-2 Shinshin** demonstrator and the sixth-generation fighter programme run with the United Kingdom and Italy.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1981-01-01',
    '1985-07-29',
    '1988-09-01',
    1038.0,
    1670.0,
    (SELECT id FROM manufacturer WHERE code = 'KHI'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki T-4'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki T-4'), (SELECT id FROM tech WHERE name = 'Réacteur Ishikawajima-Harima F3-IHI-30'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki T-4'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.0,
  wingspan          = 9.94,
  height            = 4.6,
  wing_area         = 21.0,
  empty_weight      = 3790,
  mtow              = 7500,
  service_ceiling   = 15240,
  climb_rate        = 51,
  g_limit_pos       = 7.33,
  g_limit_neg       = -3.0,
  combat_radius     = 700,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Ishikawajima-Harima F3-IHI-30',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 16.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1988,
  production_end    = 2003,
  units_built       = 212,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **T-4** : version d''entraînement intermédiaire\n- Version de liaison et d''accompagnement des unités de chasse\n- Monture de la patrouille acrobatique **Blue Impulse** depuis 1996\n- Successeur en cours de sélection depuis 2021',
  variants_en       = E'- **T-4** : intermediate training version\n- Liaison and fighter squadron support version\n- Mount of the **Blue Impulse** display team since 1996\n- A successor has been under selection since 2021',

  -- Strate 4 : qualitatif
  nickname          = 'Dolphin',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Kawasaki_T-4',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Kawasaki_T-4',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jerry Gunner from Lincoln, UK',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Kawasaki T-4';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Kawasaki T-4';
