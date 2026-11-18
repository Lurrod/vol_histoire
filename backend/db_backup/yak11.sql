-- Yakovlev Yak-11
--
-- Photo : Yakolev Let C11 '11 yellow' (G-YCII) (13945778888).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File:Yakolev_Let_C11_%2711_yellow%27_(G-YCII)_(13945778888).jpg

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
    'Yak-11',
    'Yak-11',
    'Yakovlev Yak-11',
    'Yakovlev Yak-11',
    'L''avion d''entraînement avancé du bloc soviétique, tiré du chasseur Yak-3 et produit à plus de 4 500 exemplaires',
    'The Soviet bloc advanced trainer, derived from the Yak-3 fighter and built in more than 4,500 examples',
    '/assets/airplanes/yak11.jpg',
    E'## Genèse\nAu milieu de 1944, alors que la guerre se poursuit, le bureau d''études **Yakovlev** commence l''étude d''un avion d''entraînement avancé dérivé de son chasseur **Yak-3**. Le projet passe après les besoins du front, et le premier prototype, désigné **Yak-UTI** ou Yak-3UTI, ne vole que le 10 novembre 1945. Il reprend la cellule du Yak-3U à moteur en étoile, mais remplace son ASh-82 par un **Shvetsov ASh-21** à sept cylindres. Un second prototype amélioré réussit les essais d''État en octobre 1946, et la production démarre en 1947 à Saratov et à Leningrad.\n\n## Conception\nLe Yak-11 conserve la voilure entièrement métallique du chasseur, avec un fuselage mixte en métal et en bois. L''élève et l''instructeur sont assis en tandem sous une longue verrière, chacun sous son propre capot coulissant. L''avion est armé pour l''instruction au tir : une mitrailleuse **UBS** de 12,7 mm synchronisée, parfois remplacée par une ShKAS de 7,62 mm, et deux râteliers d''aile pour des bombes de 100 kg. En 1951, Yakovlev propose le **Yak-11U** à train tricycle escamotable ; moins endurant et inadapté aux pistes sommaires ou enneigées, il est refusé par l''armée soviétique.\n\n## Carrière opérationnelle\nEntré en service en 1947, le Yak-11 devient l''avion d''entraînement avancé standard des forces aériennes soviétiques et du **DOSAAF**. Il équipe tous les pays du pacte de Varsovie et une vingtaine de forces aériennes au total, jusqu''en Afrique, au Moyen-Orient et en Asie. Pendant la **guerre de Corée**, l''un d''eux devient le 27 juin 1950 le premier avion nord-coréen abattu par les forces américaines, détruit par un **F-82 Twin Mustang** au-dessus de Kimpo. L''Égypte l''arme de roquettes pour l''attaque au sol lors de son intervention au Yémen du Nord, et l''Allemagne de l''Est s''en sert pour intercepter les ballons de reconnaissance américains.\n\n## Place dans l''histoire\nL''URSS en construit 3 859 entre 1947 et 1955, et la Tchécoslovaquie 707 de plus sous licence, sous le nom de **Let C-11**. Souvent comparé au **T-6 Texan** par l''ampleur de son emploi, le Yak-11 a été le dernier palier à hélice des pilotes de chasse de l''Est. Sa parenté avec le Yak-3 lui vaut aujourd''hui une seconde vie chez les collectionneurs, et des versions très modifiées participent aux courses aériennes ; environ 120 exemplaires volent encore.',
    E'## Genesis\nIn mid-1944, with the war still being fought, the **Yakovlev** design bureau began work on an advanced trainer derived from its **Yak-3** fighter. The project came second to the needs of the front, and the first prototype, designated **Yak-UTI** or Yak-3UTI, did not fly until 10 November 1945. It reused the airframe of the radial-engined Yak-3U, but replaced its ASh-82 with a seven-cylinder **Shvetsov ASh-21**. An improved second prototype passed state testing in October 1946, and production began in 1947 at Saratov and Leningrad.\n\n## Design\nThe Yak-11 kept the fighter''s all-metal wing, with a fuselage of mixed metal and wood construction. Pupil and instructor sat in tandem under a long canopy, each beneath a separate sliding hood. The aircraft was armed for gunnery instruction: a synchronised 12.7 mm **UBS** machine gun, sometimes replaced by a 7.62 mm ShKAS, and two wing racks for 100 kg bombs. In 1951 Yakovlev proposed the **Yak-11U** with a retractable tricycle undercarriage; with less fuel and unsuited to rough or snow-covered strips, it was rejected by the Soviet air force.\n\n## Operational career\nEntering service in 1947, the Yak-11 became the standard advanced trainer of the Soviet Air Forces and of **DOSAAF**. It equipped every Warsaw Pact country and some twenty air forces in all, as far afield as Africa, the Middle East and Asia. During the **Korean War**, one of them became, on 27 June 1950, the first North Korean aircraft shot down by US forces, destroyed by an **F-82 Twin Mustang** over Kimpo. Egypt armed it with rockets for ground attack during its intervention in North Yemen, and East Germany used it to intercept American reconnaissance balloons.\n\n## Place in history\nThe USSR built 3,859 between 1947 and 1955, and Czechoslovakia a further 707 under licence as the **Let C-11**. Often compared with the **T-6 Texan** for the scale of its use, the Yak-11 was the last propeller-driven step for Eastern bloc fighter pilots. Its kinship with the Yak-3 has earned it a second life with collectors, and heavily modified examples compete in air races; about 120 are still airworthy.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1944-01-01',
    '1945-11-10',
    '1947-01-01',
    460,
    1250,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-11'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-11'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Yak-11'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-11'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'Yak-11'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.2,
  wingspan          = 9.4,
  height            = 3.28,
  wing_area         = 15.4,
  empty_weight      = 1900,
  mtow              = 2440,
  service_ceiling   = 7100,
  climb_rate        = 8.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Shvetsov ASh-21 (700 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 1955,
  units_built       = 4566,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 22,
  variants          = E'- **Yak-UTI (Yak-3UTI)** : prototypes de 1945-1946 dérivés du Yak-3U, moteur ASh-21\n- **Yak-11** : version de série, 3 859 exemplaires construits à Saratov et à Leningrad de 1947 à 1955\n- **Let C-11** : version construite sous licence en Tchécoslovaquie, 707 exemplaires\n- **Yak-11U** : version de 1951 à train tricycle escamotable, refusée par l''armée soviétique ; quelques C-11U construits en Tchécoslovaquie\n- **Yak-11T** : variante proposée en 1951 pour l''entraînement aux équipements des chasseurs à réaction',
  variants_en       = E'- **Yak-UTI (Yak-3UTI)**: 1945-1946 prototypes derived from the Yak-3U, ASh-21 engine\n- **Yak-11**: production version, 3,859 built at Saratov and Leningrad from 1947 to 1955\n- **Let C-11**: licence-built version from Czechoslovakia, 707 built\n- **Yak-11U**: 1951 version with retractable tricycle undercarriage, rejected by the Soviet air force; a few C-11Us built in Czechoslovakia\n- **Yak-11T**: variant proposed in 1951 for training on jet fighter equipment',

  -- Strate 4 : qualitatif
  nickname          = 'Moose',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-11',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-11',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Yak-11';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-11';
