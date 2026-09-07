-- Short SC.1
--
-- Photo : Farnborough 9 1958 (51178087161).jpg
--   licence CC BY 2.0 — wilford peloquin
--   https://commons.wikimedia.org/wiki/File%3AFarnborough_9_1958_%2851178087161%29.jpg

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
    'Short SC.1',
    'Short SC.1',
    'Short SC.1',
    'Short SC.1',
    'Cinq réacteurs, dont quatre ne servent qu’à monter',
    'Five engines, four of which serve only to go up',
    '/assets/airplanes/sc1.jpg',
    E'## Genèse\nEn 1954, le ministère de l''Air britannique veut comprendre une chose précise : que se passe-t-il **entre** le vol stationnaire et le vol sur voilure ? Personne ne le sait, car personne n''a encore fait la transition en entier. Short reçoit le contrat de recherche, sans exigence opérationnelle : c''est un laboratoire volant, pas un prototype de chasseur.\n\n## Conception\nLa formule est brutalement simple. Quatre réacteurs **RB.108** montés verticalement au centre du fuselage soulèvent l''appareil ; un cinquième, horizontal à l''arrière, le propulse. En croisière, les quatre premiers sont du poids mort. À vitesse nulle, les gouvernes ne servent à rien, si bien que l''appareil se pilote par des **jets d''air comprimé** en bout d''aile et de fuselage — commandés par un système **électrique à triple redondance**, une première britannique.\n\n## Carrière opérationnelle\nAucune : deux exemplaires, un programme de recherche. Le 6 avril 1960, le XG900 réussit la **première transition complète** de l''histoire, dans les deux sens. Trois ans plus tard, le XG905 s''écrase à Belfast : deux voies du système de commandes avaient été **câblées à l''envers** lors d''une révision, et le pilote J.R. Green est tué.\n\n## Place dans l''histoire\nDeux exemplaires. Le SC.1 a répondu à la question posée — la transition est faisable et pilotable — tout en démontrant l''impasse de la formule : emporter quatre moteurs inutiles en vol coûte plus cher que tout ce qu''on gagne. C''est le **P.1127** et son moteur unique orientable qui hérite de la leçon.',
    E'## Genesis\nIn 1954 the British Air Ministry wanted to understand one precise thing: what happens **between** hovering and wing-borne flight? Nobody knew, because nobody had yet made the transition all the way through. Short received the research contract, with no operational requirement: this was a flying laboratory, not a fighter prototype.\n\n## Design\nThe formula is brutally simple. Four **RB.108** engines mounted vertically in the centre fuselage lift the aircraft; a fifth, horizontal at the rear, propels it. In cruise the first four are dead weight. At zero airspeed the control surfaces do nothing, so the aircraft is flown by **compressed air jets** at the wingtips and fuselage ends — commanded by a **triply redundant electrical** system, a British first.\n\n## Operational career\nNone: two aircraft, a research programme. On 6 April 1960 XG900 achieved the **first complete transition** in history, in both directions. Three years later XG905 crashed at Belfast: two channels of the control system had been **wired in reverse** during an overhaul, and the pilot J.R. Green was killed.\n\n## Place in history\nTwo built. The SC.1 answered the question it was asked — the transition is feasible and flyable — while demonstrating the dead end of the formula: carrying four useless engines in flight costs more than anything it gains. It is the **P.1127**, with its single swivelling engine, that inherited the lesson.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1954-01-01',
    '1957-04-02',
    NULL,
    396.0,
    240.0,
    (SELECT id FROM manufacturer WHERE code = 'SHO'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Short SC.1'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Short SC.1'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Short SC.1'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.62,
  wingspan          = 7.16,
  height            = 3.2,
  wing_area         = 13.4,
  empty_weight      = 2810,
  mtow              = 3630,
  service_ceiling   = 2440,
  climb_rate        = 15.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 100,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce RB.108',
  engine_count      = 5,
  engine_type       = 'Turboréacteur de sustentation et de propulsion',
  engine_type_en    = 'Lift and propulsion turbojet',
  thrust_dry        = 10.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1958,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XG900 / XG905** : les deux seuls exemplaires construits\n- **Quatre réacteurs de sustentation** verticaux plus un de propulsion horizontal\n- Premier appareil à réussir la **transition complète** stationnaire ↔ vol, en 1960\n- Premières **commandes de vol électriques** britanniques, à triple redondance\n- XG905 s''écrase en 1963 à la suite d''une inversion de câblage : le pilote est tué',
  variants_en       = E'- **XG900 / XG905** : the only two aircraft built\n- **Four vertical lift engines** plus one horizontal propulsion engine\n- First aircraft to achieve a **full transition** from hover to wing-borne flight, in 1960\n- Britain''s first **fly-by-wire** controls, with triple redundancy\n- XG905 crashed in 1963 after a wiring reversal, killing its pilot',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Short_SC.1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Short_SC.1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'wilford peloquin',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Short SC.1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Short SC.1';
