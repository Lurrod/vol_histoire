-- Cessna T-41 Mescalero
--
-- Photo : USAFA Flying Team T-41D.jpg
--   licence Public domain — US Air Force
--   https://commons.wikimedia.org/wiki/File:USAFA_Flying_Team_T-41D.jpg

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
    'Cessna T-41 Mescalero',
    'Cessna T-41 Mescalero',
    'Cessna T-41 Mescalero',
    'Cessna T-41 Mescalero',
    'Le Cessna 172 acheté sur étagère pour trier les futurs pilotes de l''US Air Force avant le réacteur',
    'The off-the-shelf Cessna 172 bought to screen future US Air Force pilots before jet training',
    '/assets/airplanes/t41-mescalero.jpg',
    E'## Genèse\nEn 1964, l''US Air Force décide de ne plus faire débuter ses élèves pilotes directement sur le biréacteur **T-37 Tweet**. Elle veut un avion de sélection, simple et bon marché, pour former et trier des candidats qui n''ont que peu ou pas d''expérience du vol. Plutôt que de lancer un programme, elle achète sur étagère le **Cessna 172F**, avion de tourisme en série, préféré au Piper PA-28. La première commande porte sur 237 appareils, baptisés **T-41A Mescalero**.\n\n## Conception\nLe T-41A est un monomoteur à aile haute entièrement métallique, à train tricycle fixe, presque identique au modèle civil : livrée militaire et double commande mises à part, rien ne l''en distingue. L''élève et l''instructeur sont assis côte à côte, deux passagers peuvent prendre place derrière eux, et un **Continental O-300** de 145 ch entraîne une hélice à pas fixe. Les versions suivantes dérivent du **R172**, plus puissant : le T-41B de l''US Army, le T-41C de l''Air Force Academy et le T-41D d''exportation reçoivent un **Continental IO-360** de 210 ch. L''avion n''est pas conçu pour être armé.\n\n## Carrière opérationnelle\nLa première promotion de l''US Air Force, la 67-A, commence sa formation sur T-41 en août 1965, depuis l''aéroport civil de Big Spring, au Texas. L''US Army commande 255 T-41B pour ses propres élèves, et l''Air Force Academy reçoit 52 T-41C en 1968. Au titre du programme d''aide militaire américain, le T-41D part vers une vingtaine de pays, de la Grèce à la Turquie, de l''Iran aux Philippines, du Cambodge au Pérou ; le premier est livré aux Philippines en 1968. À partir de 1993, l''Air Force le remplace par le **Slingsby T-3A Firefly**, apte à la voltige, ce que le T-41 ne permettait pas.\n\n## Place dans l''histoire\nAvec 836 exemplaires dans ses quatre versions militaires, le T-41 a montré qu''un avion de tourisme acheté tel quel pouvait servir de premier palier à la formation militaire. Quatre exemplaires sont restés à l''Air Force Academy pour son équipe de vol et certains cours, et le type sert encore en petit nombre dans plusieurs pays. D''autres forces aériennes, comme celles d''Arabie saoudite ou de Singapour, ont acheté des Cessna 172 civils pour le même usage, sans qu''il s''agisse techniquement de T-41.',
    E'## Genesis\nIn 1964 the US Air Force decided to stop starting its student pilots directly on the twin-jet **T-37 Tweet**. It wanted a simple, cheap screening aircraft to train and select candidates with little or no flying experience. Rather than launch a programme, it bought the **Cessna 172F**, a production light aircraft, off the shelf, preferring it to the Piper PA-28. The first order covered 237 aircraft, named **T-41A Mescalero**.\n\n## Design\nThe T-41A was an all-metal, high-wing single-engined aircraft with fixed tricycle landing gear, almost identical to the civil model: apart from its military paint and dual controls, nothing set it apart. Pupil and instructor sat side by side, two passengers could sit behind them, and a 145 hp **Continental O-300** drove a fixed-pitch propeller. Later versions were based on the more powerful **R172**: the Army''s T-41B, the Air Force Academy''s T-41C and the export T-41D received a 210 hp **Continental IO-360**. The aircraft was not designed to carry weapons.\n\n## Operational career\nThe first US Air Force class, 67-A, began training on the T-41 in August 1965 from the civil airport at Big Spring, Texas. The US Army ordered 255 T-41Bs for its own students, and the Air Force Academy received 52 T-41Cs in 1968. Under the US Military Aid Program the T-41D went to some twenty countries, from Greece to Turkey, Iran to the Philippines, Cambodia to Peru; the first was delivered to the Philippines in 1968. From 1993 the Air Force replaced it with the **Slingsby T-3A Firefly**, which could perform aerobatics, something beyond the T-41.\n\n## Place in history\nWith 836 built across its four military versions, the T-41 showed that a light aircraft bought as it was could serve as the first step of military training. Four remained at the Air Force Academy for its flying team and certain academic courses, and the type still serves in small numbers in several countries. Other air forces, such as those of Saudi Arabia and Singapore, bought civil Cessna 172s for the same purpose, although these were not technically T-41s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1964-01-01',
    NULL,
    '1965-08-01',
    232,
    1159,
    (SELECT id FROM manufacturer WHERE code = 'CES'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Cessna T-41 Mescalero'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Cessna T-41 Mescalero'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.2,
  wingspan          = 10.92,
  height            = 2.69,
  wing_area         = 14.8,
  empty_weight      = 618,
  mtow              = 1134,
  service_ceiling   = 5200,
  climb_rate        = 4.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Continental IO-360-D (210 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1964,
  production_end    = NULL,
  units_built       = 836,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 21,
  variants          = E'- **T-41A** : Cessna 172F, 172G et 172H de l''US Air Force, moteur Continental O-300 de 145 ch, 230 exemplaires\n- **T-41B** : version de l''US Army sur base R172E, Continental IO-360 de 210 ch et hélice à vitesse constante, 255 exemplaires\n- **T-41C** : version de l''Air Force Academy, deux sièges avant seulement et hélice à pas fixe, 52 exemplaires\n- **T-41D** : version du programme d''aide militaire, quatre places, traitement anticorrosion, 299 exemplaires\n- **B.F.14** : désignation thaïlandaise du T-41D',
  variants_en       = E'- **T-41A**: US Air Force Cessna 172F, 172G and 172H, 145 hp Continental O-300, 230 built\n- **T-41B**: US Army version based on the R172E, 210 hp Continental IO-360 and constant-speed propeller, 255 built\n- **T-41C**: Air Force Academy version, front seats only and fixed-pitch propeller, 52 built\n- **T-41D**: Military Aid Program version, four seats, corrosion-proofing, 299 built\n- **B.F.14**: Thai designation for the T-41D',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Cessna_T-41_Mescalero',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Cessna_T-41_Mescalero',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Cessna T-41 Mescalero';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Cessna T-41 Mescalero';
