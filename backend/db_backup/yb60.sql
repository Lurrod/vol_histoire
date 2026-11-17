-- Convair YB-60
--
-- Photo : Convair YB-60 in flight over clouds (SN 49-2676) 061102-F-1234P-005.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Convair_YB-60_in_flight_over_clouds_(SN_49-2676)_061102-F-1234P-005.jpg

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
    'Convair YB-60',
    'Convair YB-60',
    'Convair YB-60',
    'Convair YB-60',
    'Un B-36 à aile en flèche et huit réacteurs, battu de trois jours et de 160 km/h par le B-52',
    'A swept-wing, eight-jet B-36, beaten by three days and 160 km/h by the B-52',
    '/assets/airplanes/yb60.jpg',
    E'## Genèse\nAu début des années 1950, le **B-36 Peacemaker** de Convair, à moteurs mixtes et aile droite, est déjà dépassé par les bombardiers à réaction. Le 25 août 1950, Convair propose à l''US Air Force une version entièrement à réaction et à aile en flèche de son géant. L''armée de l''air se montre assez intéressée pour autoriser, le 15 mars 1951, la conversion de deux B-36F, d''abord désignés B-36G ; l''avion étant radicalement différent, il devient le YB-60. Son concurrent officieux est le **YB-52** de Boeing, mais la proposition de Convair, qui modifie un avion existant au lieu de partir d''une feuille blanche, coûte nettement moins cher.\n\n## Conception\nLe YB-60 partage 72 % de ses pièces avec le B-36, dont il conserve presque à l''identique le fuselage. Une section en coin insérée à l''emplanture accroît la flèche de l''aile, qui réutilise elle aussi de nombreux éléments du Peacemaker, et les empennages sont redessinés en flèche. Comme le YB-52, il est propulsé par huit turboréacteurs **Pratt & Whitney J57** groupés par paires dans quatre nacelles sous la voilure, après que Convair eut étudié une formule à six turbopropulseurs et une autre à douze J47. Radar et systèmes de bombardement sont logés dans un nez amovible, et une roulette de queue orientable empêche l''avion de basculer en arrière.\n\n## Essais\nLe premier YB-60 (49-2676) décolle le 18 avril 1952, aux mains de **Beryl Erickson** ; le YB-52 l''a devancé de trois jours. Le Convair se révèle plus lent d''environ 160 km/h en croisière et souffre de graves problèmes de pilotage, ses commandes ayant été conçues pour des vitesses plus faibles. Il peut certes emporter 33 t de bombes contre 20 t pour le YB-52, mais l''US Air Force juge que ses défauts l''emportent. Les essais s''arrêtent le 20 janvier 1953 après 66 heures de vol, alors que le second prototype, presque terminé, n''a jamais reçu ses moteurs.\n\n## Place dans l''histoire\nConvair remplit néanmoins son contrat, et l''US Air Force accepte les deux YB-60 en 1954, avant de les faire ferrailler dès juillet. Le programme aura coûté 14,3 millions de dollars. Un projet d''avion de ligne dérivé est abandonné, son envergure et sa masse imposant aux aéroports des travaux plus lourds encore que ceux du **Boeing 707** ; Convair se tourne vers le Convair 880. Le YB-60 reste la dernière tentative de prolonger la lignée du B-36, face à un **B-52 Stratofortress** dont la soute agrandie atteindra plus tard 27 t de bombes.',
    E'## Genesis\nBy the early 1950s Convair''s **B-36 Peacemaker**, with its mixed power plant and straight wing, had been overtaken by jet bombers. On 25 August 1950 Convair offered the US Air Force an all-jet, swept-wing version of its giant. The Air Force was interested enough to authorise, on 15 March 1951, the conversion of two B-36Fs, at first designated B-36G; since the aircraft was so radically different, it became the YB-60. Its unofficial competitor was Boeing''s **YB-52**, but the Convair proposal, which modified an existing aircraft rather than starting from scratch, was considerably cheaper.\n\n## Design\nThe YB-60 shared 72 per cent of its parts with the B-36, keeping almost the same fuselage. A wedge-shaped insert at the wing root increased the sweep of the wing, which also reused many Peacemaker parts, and the tail surfaces were swept to match. Like the YB-52, it was powered by eight **Pratt & Whitney J57** turbojets paired in four underwing pods, after Convair had studied a six-turboprop layout and another with twelve J47s. Radar and bombing systems sat in a removable nose, and a steerable tail wheel kept the aircraft from tipping backwards.\n\n## Testing\nThe first YB-60 (49-2676) took off on 18 April 1952 with **Beryl Erickson** at the controls; the YB-52 had beaten it into the air by three days. The Convair proved some 160 km/h slower in the cruise and suffered serious handling problems, its controls having been designed for lower speeds. It could carry 33 tonnes of bombs against the YB-52''s 20, but the Air Force judged that its drawbacks outweighed the benefit. Testing ended on 20 January 1953 after 66 flying hours, while the nearly complete second prototype never received its engines.\n\n## Place in history\nConvair nonetheless fulfilled its contract, and the Air Force accepted both YB-60s in 1954, only to have them scrapped by July. The programme cost $14.3 million. A proposed airliner derivative was dropped, as its span and weight would have demanded even greater airport changes than the **Boeing 707**; Convair turned to the Convair 880 instead. The YB-60 remains the last attempt to extend the B-36 line, against a **B-52 Stratofortress** whose enlarged bomb bay would later reach 27 tonnes.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1950-08-25',
    '1952-04-18',
    NULL,
    818,
    13000,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair YB-60'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair YB-60'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Convair YB-60'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Convair YB-60'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 52,
  wingspan          = 63,
  height            = 18.44,
  wing_area         = 486.7,
  empty_weight      = 69407,
  mtow              = 136078,
  service_ceiling   = 16200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J57-P-3',
  engine_count      = 8,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 38.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **B-36G** : désignation initiale des deux B-36F à convertir, autorisés le 15 mars 1951\n- **YB-60** (49-2676) : premier prototype, cinq hommes d''équipage, seul à avoir volé (66 heures)\n- **YB-60** (49-2684) : second prototype à neuf hommes d''équipage, presque achevé mais jamais motorisé\n- **B-60 de série** : prévu avec neuf hommes et un armement défensif comparable à celui du B-36, jamais commandé\n- **Dérivé civil** : projet d''avion de ligne abandonné au profit du Convair 880',
  variants_en       = E'- **B-36G**: initial designation of the two B-36Fs to be converted, authorised on 15 March 1951\n- **YB-60** (49-2676): first prototype, crew of five, the only one to fly (66 hours)\n- **YB-60** (49-2684): second prototype with a crew of nine, nearly complete but never fitted with engines\n- **Production B-60**: planned with a crew of nine and defensive armament similar to the B-36, never ordered\n- **Civil derivative**: airliner project dropped in favour of the Convair 880',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_YB-60',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_YB-60',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Convair YB-60';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Convair YB-60';
