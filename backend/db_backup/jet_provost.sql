-- Hunting / BAC Jet Provost
--
-- Photo : Hunting BAC Jet Provost T5A (40081273000).jpg
--   licence CC BY-SA 2.0 — Hugh Llewelyn from Keynsham, UK
--   https://commons.wikimedia.org/wiki/File%3AHunting_BAC_Jet_Provost_T5A_%2840081273000%29.jpg

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
    'Jet Provost',
    'Jet Provost',
    'Hunting / BAC Jet Provost',
    'Hunting / BAC Jet Provost',
    'Le premier école du monde à envoyer un débutant directement sur réacteur',
    'The world’s first trainer to put an ab initio pupil straight onto a jet',
    '/assets/airplanes/jet-provost.jpg',
    E'## Genèse\nAu début des années 1950, la formation britannique suit une chaîne longue : école élémentaire sur hélices, école de base sur hélices, puis conversion sur réacteur. Chaque étape coûte des mois. Hunting propose une simplification radicale — mettre le débutant **directement** sur un jet, et supprimer une marche entière.\n\n## Conception\nPour aller vite, Hunting greffe un réacteur **Viper** sur la cellule de son Percival Provost à pistons, en allongeant le train pour éloigner la tuyère du sol. La formule est peu élégante mais elle marche : l''appareil est stable, indulgent, et sa faible poussée pardonne les erreurs. Les versions ultérieures redessinent tout, et la **T.5** apporte une cabine pressurisée qui permet de monter à onze mille mètres.\n\n## Carrière opérationnelle\nSept cent trente-quatre exemplaires. La RAF l''utilise de 1955 à **1993** : trente-huit ans, une longévité que peu d''appareils militaires atteignent. Sa version armée, le **Strikemaster**, est vendue à huit pays et se bat réellement — Oman, Yémen du Sud, Nouvelle-Zélande — dans le rôle d''appui léger.\n\n## Place dans l''histoire\nSept cent trente-quatre exemplaires et deux générations de pilotes britanniques. Le Jet Provost a prouvé qu''on peut apprendre à voler sur réacteur sans passer par l''hélice, principe adopté depuis par la plupart des grandes forces aériennes. Il cède la place au **Shorts Tucano**, qui, ironie, ramène l''hélice.',
    E'## Genesis\nIn the early 1950s British training followed a long chain: elementary school on propellers, basic school on propellers, then jet conversion. Each stage cost months. Hunting proposed a radical simplification — put the beginner **straight** onto a jet and delete a whole step.\n\n## Design\nTo move quickly Hunting grafted a **Viper** engine onto the airframe of its piston Percival Provost, lengthening the undercarriage to keep the jet pipe off the ground. The formula is inelegant but it works: the aircraft is stable, forgiving, and its low thrust pardons mistakes. Later versions redrew everything, and the **T.5** brought a pressurised cabin allowing eleven thousand metres.\n\n## Operational career\nSeven hundred and thirty-four built. The RAF used it from 1955 to **1993**: thirty-eight years, a longevity few military aircraft reach. Its armed version, the **Strikemaster**, sold to eight countries and saw real fighting — Oman, South Yemen, New Zealand — in the light attack role.\n\n## Place in history\nSeven hundred and thirty-four built and two generations of British pilots. The Jet Provost proved one can learn to fly on a jet without passing through propellers, a principle since adopted by most major air forces. It gave way to the **Shorts Tucano** which, ironically, brought the propeller back.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1951-01-01',
    '1954-06-26',
    '1955-06-01',
    708.0,
    1450.0,
    (SELECT id FROM manufacturer WHERE code = 'HUN'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Jet Provost'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Jet Provost'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Jet Provost'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Jet Provost'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.36,
  wingspan          = 11.23,
  height            = 3.1,
  wing_area         = 19.85,
  empty_weight      = 2200,
  mtow              = 4173,
  service_ceiling   = 11200,
  climb_rate        = 20.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 450,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Armstrong Siddeley Viper 202',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 11.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1971,
  units_built       = 734,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 8,
  variants          = E'- **T.1 à T.4** : versions d''entraînement successives, cabine non pressurisée\n- **T.5** : cabine **pressurisée** et verrière redessinée, la version définitive\n- **BAC 167 Strikemaster** : dérivé armé, exporté vers huit pays et engagé au combat\n- Dérivé du **Percival Provost** à moteur à pistons, dont il reprend la cellule\n- Forme les pilotes de la RAF pendant **plus de trente ans**, jusqu''en 1993',
  variants_en       = E'- **T.1 to T.4** : successive training versions, unpressurised cabin\n- **T.5** : **pressurised** cabin and redesigned canopy, the definitive version\n- **BAC 167 Strikemaster** : armed derivative, exported to eight countries and used in combat\n- Derived from the piston-engined **Percival Provost**, whose airframe it reuses\n- Trained RAF pilots for **more than thirty years**, until 1993',

  -- Strate 4 : qualitatif
  nickname          = 'JP',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/BAC_Jet_Provost',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/BAC_Jet_Provost',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Hugh Llewelyn from Keynsham, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Jet Provost';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Jet Provost';
