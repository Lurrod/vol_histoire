-- Percival P.56 Provost
--
-- Photo : Percival Provost NL.jpg
--   licence CC BY 2.0 — neillanwarne
--   https://commons.wikimedia.org/wiki/File:Percival_Provost_NL.jpg

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
    'Percival Provost',
    'Percival Provost',
    'Percival P.56 Provost',
    'Percival P.56 Provost',
    'L''école à moteur en étoile de la RAF, élève et instructeur côte à côte, dont est né le Jet Provost',
    'The RAF''s radial-engined trainer, pupil and instructor side by side, from which the Jet Provost was born',
    '/assets/airplanes/percival-provost.jpg',
    E'## Genèse\nLe 11 septembre 1948, le ministère de l''Air britannique publie la spécification T.16/48 : un avion d''école de base pour remplacer les **Percival Prentice** de la RAF. L''objectif est de mieux surveiller les élèves pour réduire les abandons tardifs en cours de formation. Plus de trente projets sont reçus ; deux sont retenus, le **Percival P.56**, dessiné par l''ingénieur d''origine polonaise **Henry Millicer**, et le Handley Page H.P.R.2. Le premier prototype, à moteur Armstrong Siddeley Cheetah, vole le 24 février 1950, et les deux concurrents s''affrontent à Boscombe Down.\n\n## Conception\nLe Provost est un monoplan tout métal à aile basse et train classique fixe. Élève et instructeur sont assis **côte à côte**, pour que le second voie et montre chaque geste. La version de série reçoit un moteur en étoile **Alvis Leonides** de 550 ch, deux fois la puissance du Prentice : taux de roulis et vitesse de montée le rapprochent des meilleurs chasseurs du moment, tandis que décrochage et sortie de vrille restent doux. La verrière en trois parties permet l''entraînement au vol aux instruments de jour grâce à des écrans ambrés, et une radio VHF autorise les approches guidées depuis le sol. Le poste est volontairement complexe, pour habituer d''emblée les débutants à un environnement d''avion d''arme.\n\n## Carrière opérationnelle\nLa RAF commande 200 Provost T.1 le 29 mai 1951 et les met en service en 1953 à la Central Flying School. Plus capable que le Prentice, il permet aux élèves de passer directement sur le **Vampire** à réaction ; dès septembre 1954, il a remplacé le Prentice dans toutes les écoles. À l''exportation, la Rhodésie, l''Irlande, la Birmanie, le Soudan, l''Irak, Oman et la Malaisie l''achètent, souvent en versions armées T.52 et T.53 avec deux mitrailleuses, des bombes ou des roquettes. Remplacé au début des années 1960, le dernier Provost de la RAF est retiré en 1969.\n\n## Place dans l''histoire\nConstruit à 461 exemplaires, le Provost a surtout engendré son successeur : en lui greffant un réacteur, Hunting en tire le **Jet Provost**, qui fait passer la RAF à la formation sur jet dès le premier vol. Son principe de l''instructeur assis à côté de l''élève sera repris par le Jet Provost. Plusieurs exemplaires volent encore, dont celui de la Shuttleworth Collection.',
    E'## Genesis\nOn 11 September 1948 the British Air Ministry issued specification T.16/48: a basic trainer to replace the RAF''s **Percival Prentice** fleet. The aim was to supervise students more closely to cut late-stage dropouts. More than thirty proposals were received; two were chosen, the **Percival P.56**, designed by the Polish-born engineer **Henry Millicer**, and the Handley Page H.P.R.2. The first prototype, with an Armstrong Siddeley Cheetah engine, flew on 24 February 1950, and the two contenders went head to head at Boscombe Down.\n\n## Design\nThe Provost was an all-metal low-wing monoplane with a fixed tailwheel undercarriage. Student and instructor sat **side by side**, so the instructor could watch and demonstrate every move. The production version received a 550 hp **Alvis Leonides** radial, twice the power of the Prentice: its roll rate and climb were close to the best fighters of the day, while its stall and spin recovery remained gentle. The three-piece canopy allowed daytime instrument training thanks to amber screens, and a VHF radio enabled ground-controlled approaches. The cockpit was deliberately complex, to accustom beginners from the start to a combat aircraft environment.\n\n## Operational career\nThe RAF ordered 200 Provost T.1s on 29 May 1951 and brought them into service in 1953 at the Central Flying School. More capable than the Prentice, it allowed students to move straight on to the jet **Vampire**; by September 1954 it had replaced the Prentice in every school. For export, Rhodesia, Ireland, Burma, Sudan, Iraq, Oman and Malaysia bought it, often in the armed T.52 and T.53 versions with two machine guns, bombs or rockets. Replaced in the early 1960s, the last RAF Provost was retired in 1969.\n\n## Place in history\nBuilt to 461 aircraft, the Provost above all gave rise to its successor: by grafting a jet engine onto it, Hunting produced the **Jet Provost**, which moved the RAF to jet training from the very first flight. Its principle of the instructor seated beside the student was carried over to the Jet Provost. Several examples still fly, including that of the Shuttleworth Collection.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1948-09-11',
    '1950-02-24',
    '1953-01-01',
    320,
    1050,
    (SELECT id FROM manufacturer WHERE code = 'HUN'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Percival Provost'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte')),
((SELECT id FROM airplanes WHERE name = 'Percival Provost'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Percival Provost'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Percival Provost'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.69,
  wingspan          = 10.67,
  height            = 3.66,
  wing_area         = 19.9,
  empty_weight      = 1520,
  mtow              = 1995,
  service_ceiling   = 7600,
  climb_rate        = 11,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Alvis Leonides 126 (550 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1950,
  production_end    = 1961,
  units_built       = 461,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 8,
  variants          = E'- **P.56 Mk 1 et Mk 2** : trois prototypes d''évaluation, deux à moteur Cheetah puis un à moteur Leonides\n- **Provost T.1** : version d''école de base de la RAF à moteur Alvis Leonides\n- **Provost T.51** : version d''exportation non armée, notamment pour l''Irlande et la Malaisie\n- **Provost T.52** : version armée pour la Rhodésie et Oman\n- **Provost T.53** : version armée pour la Birmanie, l''Irak, l''Irlande et le Soudan',
  variants_en       = E'- **P.56 Mk 1 and Mk 2**: three evaluation prototypes, two Cheetah-powered then one Leonides-powered\n- **Provost T.1**: RAF basic trainer version with Alvis Leonides engine\n- **Provost T.51**: unarmed export version, notably for Ireland and Malaysia\n- **Provost T.52**: armed version for Rhodesia and Oman\n- **Provost T.53**: armed version for Burma, Iraq, Ireland and Sudan',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hunting_Percival_Provost',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Percival_Provost',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'neillanwarne',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Percival Provost';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Percival Provost';
