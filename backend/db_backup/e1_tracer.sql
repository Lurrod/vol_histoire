-- Grumman E-1 Tracer (WF-2)
--
-- Photo : 330-ps-8251-usn-1009028 16377901236 o.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:330-ps-8251-usn-1009028_16377901236_o.jpg

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
    'E-1 Tracer',
    'E-1 Tracer',
    'Grumman E-1 Tracer (WF-2)',
    'Grumman E-1 Tracer (WF-2)',
    'Un radôme en goutte sur un avion de pont : le premier guet embarqué conçu comme tel',
    'A teardrop radome on a carrier aircraft: the first purpose-built carrier early-warning plane',
    '/assets/airplanes/e1-tracer.jpg',
    E'## Genèse\nAu milieu des années 1950, le guet aérien des porte-avions américains repose sur des **Skyraider** AD-5W, dont le radar APS-20 arrive à ses limites. En 1955, Grumman étudie comment loger sur un appareil de pont l''antenne d''un nouveau radar plus puissant, le **Hazeltine AN/APS-82**. Plutôt que de dessiner un avion neuf, le bureau d''études part de la cellule déjà éprouvée du transport embarqué **C-1 Trader**, de la famille de l''avion anti-sous-marin **S-2 Tracker**.\n\n## Conception\nLe trait distinctif est un radôme fixe en forme de goutte aplatie, posé sur le fuselage, à l''intérieur duquel tourne une antenne parabolique de 5,2 m sur 1,5 m. Le radôme interdisant le repliage habituel des ailes vers le haut, celles-ci se replient vers l''arrière le long du fuselage, pour que l''appareil passe les ascenseurs et tienne dans les hangars. Le radar dispose d''un indicateur de cibles mobiles qui distingue un avion du retour de la mer. Deux moteurs en étoile **Wright R-1820 Cyclone** de 1 525 ch, quatre hommes à bord : deux pilotes et deux contrôleurs.\n\n## Carrière opérationnelle\nLe prototype aérodynamique vole le 17 décembre 1956 ; quatre-vingt-huit exemplaires suivent. Le Tracer équipe à partir de 1960 les escadrilles VAW-11 et VAW-12, puis VAW-121. Au **Vietnam**, ses détachements embarqués accomplissent cinquante-six déploiements : ils guident les chasseurs vers leurs cibles et signalent l''approche des MiG dans un rayon de 400 à 480 km. Les équipages le surnomment **Willy Fudd**, d''après sa désignation d''origine WF-2. Le dernier quitte le service en 1977.\n\n## Place dans l''histoire\nLe Tracer est le premier avion de guet aérien de l''US Navy conçu pour cette mission, et non adapté d''un avion d''attaque. Il n''est qu''une transition : dès 1964, l''**E-2 Hawkeye** et son radôme rotatif prennent le relais. Mais il fixe la silhouette de tous les guets embarqués qui suivront, un disque posé au-dessus du fuselage. Son pendant britannique contemporain est la version de guet du **Fairey Gannet**.',
    E'## Genesis\nIn the mid-1950s airborne early warning on American carriers relied on AD-5W **Skyraiders**, whose APS-20 radar was reaching its limits. In 1955 Grumman studied how to fit a carrier aircraft with the antenna of a new, more powerful radar, the **Hazeltine AN/APS-82**. Rather than draw a new aircraft, the design office started from the proven airframe of the **C-1 Trader** carrier transport, a member of the **S-2 Tracker** anti-submarine family.\n\n## Design\nIts signature is a fixed, flattened teardrop radome mounted above the fuselage, inside which a 5.2 m by 1.5 m parabolic antenna rotates. Since the radome ruled out the usual upward wing fold, the wings fold rearward along the fuselage so the aircraft fits the elevators and hangars. The radar has a moving target indicator that separates an aircraft from sea clutter. Two **Wright R-1820 Cyclone** radial engines of 1,525 hp, four men on board: two pilots and two controllers.\n\n## Operational career\nThe aerodynamic prototype flew on 17 December 1956; eighty-eight aircraft followed. From 1960 the Tracer equipped squadrons VAW-11 and VAW-12, then VAW-121. Over **Vietnam**, its embarked detachments made fifty-six deployments, vectoring fighters onto their targets and warning of approaching MiGs within a radius of 400 to 480 km. Crews nicknamed it **Willy Fudd**, after its original WF-2 designation. The last one left service in 1977.\n\n## Place in history\nThe Tracer was the US Navy''s first early-warning aircraft designed for the mission rather than adapted from an attack aircraft. It was only a transition: from 1964 the **E-2 Hawkeye** and its rotating radome took over. But it set the silhouette of every carrier early-warning aircraft to come, a disc above the fuselage. Its contemporary British counterpart was the early-warning version of the **Fairey Gannet**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1955-01-01',
    '1956-12-17',
    '1960-01-01',
    383.0,
    1666.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'E-1 Tracer'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'E-1 Tracer'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'E-1 Tracer'), (SELECT id FROM tech WHERE name = 'Système de décollage et d''atterrissage sur porte-avions'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'E-1 Tracer'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'E-1 Tracer'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'E-1 Tracer'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'E-1 Tracer'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.82,
  wingspan          = 22.05,
  height            = 5.13,
  wing_area         = NULL,
  empty_weight      = 9361,
  mtow              = 12065,
  service_ceiling   = 4816,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-1820-82A Cyclone 9',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 88,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **WF-2** : désignation d''origine jusqu''en 1962, d''où le surnom **Willy Fudd**\n- **E-1B** : désignation unifiée de 1962, unique version de série\n- **Radar Hazeltine AN/APS-82** à indicateur de cibles mobiles, sous radôme fixe\n- Dérivé du transport embarqué **C-1 Trader**, famille du **S-2 Tracker**\n- Remplacé par l''**E-2 Hawkeye** à partir de 1964',
  variants_en       = E'- **WF-2** : original designation until 1962, hence the nickname **Willy Fudd**\n- **E-1B** : unified 1962 designation, the only production version\n- **Hazeltine AN/APS-82 radar** with moving target indicator, under a fixed radome\n- Derived from the **C-1 Trader** carrier transport, of the **S-2 Tracker** family\n- Replaced by the **E-2 Hawkeye** from 1964',

  -- Strate 4 : qualitatif
  nickname          = 'Willy Fudd',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_E-1_Tracer',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_E-1_Tracer',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'E-1 Tracer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'E-1 Tracer';
