-- Guizhou JL-9 Shanying (Mountain Eagle)
--
-- Photo : JL-9 releasing flares at CCAS2023 (20230724095500).jpg
--   licence CC BY-SA 4.0 — N509FZ
--   https://commons.wikimedia.org/wiki/File%3AJL-9_releasing_flares_at_CCAS2023_%2820230724095500%29.jpg

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
    'Guizhou JL-9',
    'Guizhou JL-9',
    'Guizhou JL-9 Shanying (Mountain Eagle)',
    'Guizhou JL-9 Shanying (Mountain Eagle)',
    'Un MiG-21 des années 1950 recyclé en école de chasse moderne',
    'A 1950s MiG-21 recycled into a modern fighter trainer',
    '/assets/airplanes/jl9.jpg',
    E'## Genèse\nLa Chine forme ses pilotes de chasse sur des **JJ-7**, versions biplaces du J-7 — c''est-à-dire sur un MiG-21 de 1955. L''appareil est rapide mais approche à trois cent trente kilomètres-heure, vitesse qui tue les élèves. Guizhou reçoit une mission ingrate : moderniser cette cellule sans avoir les moyens d''en concevoir une neuve.\n\n## Conception\nLe nez à entrée d''air frontale du MiG-21 est supprimé, remplacé par un **nez plein** abritant un radar et deux entrées d''air latérales — la modification la plus visible. L''aile reçoit des extensions d''emplanture qui abaissent nettement la vitesse d''approche. Le cockpit passe au **tout-écran**, pour préparer aux J-10 et J-11 que les élèves piloteront ensuite.\n\n## Carrière opérationnelle\nEnviron cent exemplaires. Sa version navalisée **JL-9G** forme les pilotes embarqués chinois à l''appontage, préalable indispensable au J-15 sur les porte-avions *Liaoning* et *Shandong*. La version d''attaque FTC-2000G est vendue au Soudan.\n\n## Place dans l''histoire\nCent exemplaires. Le JL-9 illustre la contrainte chinoise des années 2000 : moderniser l''existant faute de pouvoir tout reconstruire. Le **L-15** de Hongdu, conçu de zéro avec l''aide de Yakovlev, représente l''étape suivante — et le JL-9, la dernière descendance vivante du MiG-21.',
    E'## Genesis\nChina trained its fighter pilots on **JJ-7s**, two-seat versions of the J-7 — that is, on a 1955 MiG-21. The aircraft is fast but approaches at three hundred and thirty kilometres an hour, a speed that kills students. Guizhou was given a thankless task: modernise that airframe without the means to design a new one.\n\n## Design\nThe MiG-21''s nose intake is deleted, replaced by a **solid nose** housing a radar and two side intakes — the most visible change. The wing gains root extensions that markedly lower the approach speed. The cockpit goes **all-glass**, to prepare pupils for the J-10s and J-11s they will fly next.\n\n## Operational career\nSome one hundred built. Its navalised **JL-9G** version trains Chinese carrier pilots in deck landing, an indispensable step before the J-15 aboard *Liaoning* and *Shandong*. The FTC-2000G attack version has been sold to Sudan.\n\n## Place in history\nOne hundred built. The JL-9 illustrates the Chinese constraint of the 2000s: modernise what exists for want of rebuilding everything. Hongdu''s **L-15**, designed from scratch with Yakovlev''s help, is the next step — and the JL-9 the last living descendant of the MiG-21.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2001-01-01',
    '2003-12-13',
    '2011-01-01',
    1500.0,
    2400.0,
    (SELECT id FROM manufacturer WHERE code = 'GAIC'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'), (SELECT id FROM armement WHERE name = 'PL-8')),
((SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.55,
  wingspan          = 8.32,
  height            = 4.1,
  wing_area         = 24.88,
  empty_weight      = 4842,
  mtow              = 9800,
  service_ceiling   = 16000,
  climb_rate        = 155.0,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = 650,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Guizhou WP-13F',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 44.1,
  thrust_wet        = 64.7,

  -- Strate 3 : production & service
  production_start  = 2006,
  production_end    = NULL,
  units_built       = 100,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **JL-9** : version de l''armée de l''air, entraînement avancé\n- **JL-9G Haiying** : version navalisée, crosse d''appontage et cellule renforcée\n- **FTC-2000G** : version d''attaque légère proposée à l''export, vendue au **Soudan**\n- Dérivé du **JJ-7**, lui-même version biplace du **J-7**, copie du **MiG-21**\n- *Shanying* signifie « **aigle des montagnes** » en chinois',
  variants_en       = E'- **JL-9** : air force version, advanced training\n- **JL-9G Haiying** : navalised version with arrestor hook and strengthened airframe\n- **FTC-2000G** : light attack export version, sold to **Sudan**\n- Derived from the **JJ-7**, itself the two-seat **J-7**, a **MiG-21** copy\n- *Shanying* means ''**mountain eagle**'' in Chinese',

  -- Strate 4 : qualitatif
  nickname          = 'Shanying',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Guizhou_JL-9',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Guizhou_JL-9',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'N509FZ',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Guizhou JL-9';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Guizhou JL-9';
