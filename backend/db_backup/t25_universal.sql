-- Neiva N621 Universal (T-25)
--
-- Photo : T-25A Universal (14410411514).jpg
--   licence CC BY-SA 2.0 — Rob Schleiffert from Holland
--   https://commons.wikimedia.org/wiki/File:T-25A_Universal_(14410411514).jpg

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
    'Neiva T-25 Universal',
    'Neiva T-25 Universal',
    'Neiva N621 Universal (T-25)',
    'Neiva N621 Universal (T-25)',
    'L''école brésilienne à sièges côte à côte qui forme depuis un demi-siècle les cadets de l''Académie de l''air',
    'The Brazilian side-by-side trainer that has taught Air Force Academy cadets for half a century',
    '/assets/airplanes/t25-universal.jpg',
    E'## Genèse\nAu début des années 1960, la **force aérienne brésilienne** forme encore ses pilotes sur des **T-6 Texan** nord-américains et des Fokker S-11 et S-12 hérités de l''après-guerre. Pour les remplacer, l''ingénieur **Joseph Kovács** dessine en 1963 un avion d''école de base national, réalisé par l''industriel **Neiva**. Le prototype, immatriculé PP-ZTW, vole le 29 avril 1966. La force aérienne en commande 150 exemplaires sous la désignation **T-25 Universal**, puis 28 de plus en 1978.\n\n## Conception\nL''Universal est un monoplan à aile basse cantilever, entièrement métallique, à train escamotable. Élève et instructeur sont assis **côte à côte**, l''équipage pouvant compter un troisième occupant. Un moteur à plat **Lycoming IO-540** de 300 ch entraîne une hélice bipale à vitesse constante et lui donne 300 km/h au niveau de la mer et 1 500 km de distance franchissable. Deux points d''emport sous les ailes peuvent recevoir des nacelles de mitrailleuses de 7,62 mm : le nom d''Universal dit bien cette double vocation d''école et d''avion d''appui léger. Une version améliorée, le **YT-25B Universal II**, vole le 22 octobre 1978 mais n''est pas produite.\n\n## Carrière opérationnelle\nOutre l''instruction, le T-25 est employé comme avion de contre-insurrection par la force aérienne brésilienne. L''arrivée de l''**EMB-312 Tucano** d''Embraer lui retire ensuite l''entraînement avancé et l''attaque, mais il reste l''avion d''école primaire et de base de l''**Académie de la force aérienne**, à Pirassununga, où il vole aux côtés du Tucano. L''armée de terre chilienne en commande dix, transférés ensuite à la force aérienne du Chili, qui en cède cinq au Paraguay en 1983. En 2005, le Brésil en offre encore six au Paraguay et six à la Bolivie.\n\n## Place dans l''histoire\nConstruit à 189 exemplaires, l''Universal est l''un des jalons de l''industrie aéronautique militaire brésilienne, entre les avions d''après-guerre achetés à l''étranger et le Tucano d''Embraer qui lui succède. Il a fait passer la formation initiale des pilotes brésiliens à un avion conçu au pays. Plus d''un demi-siècle après son premier vol, il initie toujours les cadets de l''Académie au pilotage.',
    E'## Genesis\nIn the early 1960s the **Brazilian Air Force** was still training its pilots on North American **T-6 Texan**s and Fokker S-11s and S-12s inherited from the post-war years. To replace them, engineer **Joseph Kovács** designed a domestic basic trainer in 1963, produced by the manufacturer **Neiva**. The prototype, registered PP-ZTW, flew on 29 April 1966. The air force ordered 150 under the designation **T-25 Universal**, then 28 more in 1978.\n\n## Design\nThe Universal was a cantilever low-wing monoplane of all-metal construction with a retractable undercarriage. Student and instructor sat **side by side**, with room for a third occupant. A 300 hp **Lycoming IO-540** flat engine drove a two-blade constant-speed propeller, giving 300 km/h at sea level and a range of 1,500 km. Two underwing hardpoints could carry 7.62 mm machine gun pods: the name Universal reflects this dual role as trainer and light support aircraft. An improved version, the **YT-25B Universal II**, flew on 22 October 1978 but was not put into production.\n\n## Operational career\nBesides training, the T-25 was used as a counter-insurgency aircraft by the Brazilian Air Force. The arrival of Embraer''s **EMB-312 Tucano** later took over advanced training and attack, but it remains the primary and basic trainer of the **Air Force Academy** at Pirassununga, where it flies alongside the Tucano. The Chilean Army ordered ten, later transferred to the Chilean Air Force, which passed five to Paraguay in 1983. In 2005 Brazil donated six more to Paraguay and six to Bolivia.\n\n## Place in history\nBuilt to 189 aircraft, the Universal is one of the milestones of Brazil''s military aircraft industry, between the post-war aircraft bought abroad and the Embraer Tucano that succeeded it. It moved the initial training of Brazilian pilots onto a domestically designed aircraft. More than half a century after its first flight, it still introduces Academy cadets to flying.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1963-01-01',
    '1966-04-29',
    NULL,
    300,
    1500,
    (SELECT id FROM manufacturer WHERE code = 'NEI'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Neiva T-25 Universal'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Neiva T-25 Universal'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Neiva T-25 Universal'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.6,
  wingspan          = 11.0,
  height            = 3.0,
  wing_area         = 17.2,
  empty_weight      = 1150,
  mtow              = 1700,
  service_ceiling   = 6100,
  climb_rate        = 6.66,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming IO-540-K1D5 (300 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 189,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **N621 Universal (prototype)** : immatriculé PP-ZTW, premier vol le 29 avril 1966\n- **T-25 Universal** : version de série de la force aérienne brésilienne, 150 commandés puis 28 de plus en 1978\n- **T-25 armé** : deux points d''emport pour nacelles de mitrailleuses de 7,62 mm, employé en contre-insurrection\n- **YT-25B Universal II** : version améliorée, premier vol le 22 octobre 1978, non produite',
  variants_en       = E'- **N621 Universal (prototype)**: registered PP-ZTW, first flight on 29 April 1966\n- **T-25 Universal**: Brazilian Air Force production version, 150 ordered then 28 more in 1978\n- **Armed T-25**: two hardpoints for 7.62 mm machine gun pods, used for counter-insurgency\n- **YT-25B Universal II**: improved version, first flight on 22 October 1978, not produced',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Neiva_Universal',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Schleiffert',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Neiva T-25 Universal';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Neiva T-25 Universal';
