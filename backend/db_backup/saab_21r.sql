-- Saab 21R (J 21R / A 21R)
--
-- Photo : Saab J 21R (cn 21286, 7-N) 2013-08-31 Andre Gerwing Collection ID 015214.jpg
--   licence CC BY-SA 4.0 — André Gerwing
--   https://commons.wikimedia.org/wiki/File:Saab_J_21R_(cn_21286,_7-N)_2013-08-31_Andre_Gerwing_Collection_ID_015214.jpg

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
    'Saab 21R',
    'Saab 21R',
    'Saab 21R (J 21R / A 21R)',
    'Saab 21R (J 21R / A 21R)',
    'Un chasseur à hélice propulsive devenu avion à réaction : le premier jet suédois',
    'A pusher-propeller fighter turned jet: Sweden’s first jet aircraft',
    '/assets/airplanes/saab-21r.jpg',
    E'## Genèse\nÀ la fin de la guerre, la Suède neutre constate que ses chasseurs à hélice sont dépassés et qu''elle ne dispose d''aucun réacteur national. Le **Saab 21**, chasseur à hélice propulsive mis en service en 1945, offre une issue rapide : son moteur est logé à l''arrière d''une nacelle centrale, entre deux poutres de queue. À l''automne 1945, la Flygvapnet décide de remplacer le moteur à pistons par un réacteur britannique **de Havilland Goblin**. À la même époque, Moscou tient le même raisonnement en tirant le **Yak-15** du Yak-3.\n\n## Conception\nLe Goblin prend la place du moteur à pistons et sa tuyère débouche entre les deux poutres. L''empennage horizontal, qui aurait reçu le jet chaud, est remonté au sommet des dérives. Le siège éjectable du Saab 21, l''un des premiers montés sur un avion de série, est conservé, tout comme l''armement de nez : un canon de 20 mm et quatre mitrailleuses lourdes. Mais la cellule reste celle d''un avion à hélice : le Goblin, qui fournit environ 13 kN, la propulse vers 800 km/h, et les réservoirs ne donnent qu''une autonomie courte.\n\n## Carrière opérationnelle\nPremier vol le **10 mars 1947**. La même année, soixante appareils sont commandés, trente avec des Goblin britanniques et trente avec le réacteur produit sous licence par Svenska Flygmotor. Les livraisons commencent en 1949 à l''escadre **F 10 d''Ängelholm**. Entre-temps, la Suède a acheté le **de Havilland Vampire**, plus rapide, comme chasseur d''attente. Au début des années 1950, le 21R est reclassé en avion d''attaque, **A 21R**, armé de roquettes, aux escadres F 7 et F 17. Les derniers exemplaires quittent le service en 1957.\n\n## Place dans l''histoire\nSoixante-quatre exemplaires. Le 21R fait partie des très rares appareils produits en série d''abord à hélice, puis à réaction, comme le Yak-15. Son intérêt n''est pas dans ses performances, vite dépassées, mais dans l''expérience qu''il donne à **Saab** : le bureau d''études maîtrise l''intégration d''un réacteur au moment même où il dessine le **Saab 29 Tunnan**, qui vole en 1948 et le remplace. De là part la lignée Lansen, Draken, Viggen et Gripen.',
    E'## Genesis\nAt the end of the war, neutral Sweden found its piston fighters outclassed and had no jet engine of its own. The **Saab 21**, a pusher-propeller fighter that entered service in 1945, offered a quick way out: its engine sat at the rear of a central nacelle, between two tail booms. In autumn 1945 the Flygvapnet decided to replace the piston engine with a British **de Havilland Goblin** jet. At the same time Moscow reasoned the same way, deriving the **Yak-15** from the Yak-3.\n\n## Design\nThe Goblin took the place of the piston engine and its jet pipe exhausted between the two booms. The tailplane, which would have sat in the hot exhaust, was raised to the top of the fins. The Saab 21’s ejection seat, one of the first fitted to a production aircraft, was retained, as was the nose armament: one 20 mm cannon and four heavy machine guns. But the airframe remained that of a propeller aircraft: the Goblin, rated at about 13 kN, pushed it to around 800 km/h, and the tanks gave only a short range.\n\n## Operational career\nFirst flight on **10 March 1947**. The same year sixty aircraft were ordered, thirty with British Goblins and thirty with the engine licence-built by Svenska Flygmotor. Deliveries began in 1949 to wing **F 10 at Ängelholm**. In the meantime Sweden had bought the faster **de Havilland Vampire** as an interim fighter. In the early 1950s the 21R was reclassified as an attack aircraft, the **A 21R**, armed with rockets, with wings F 7 and F 17. The last examples left service in 1957.\n\n## Place in history\nSixty-four built. The 21R is one of the very few aircraft produced in series first with a propeller and then with a jet, like the Yak-15. Its value lies not in its performance, soon overtaken, but in the experience it gave **Saab**: the design office mastered jet integration at the very moment it was drawing the **Saab 29 Tunnan**, which flew in 1948 and replaced it. From there runs the Lansen, Draken, Viggen and Gripen line.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    '1945-01-01',
    '1947-03-10',
    '1949-08-01',
    800.0,
    900.0,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 21R'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 21R'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Saab 21R'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 21R'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.55,
  wingspan          = 11.37,
  height            = 2.9,
  wing_area         = 22.1,
  empty_weight      = 3090,
  mtow              = 5615,
  service_ceiling   = 12000,
  climb_rate        = 17,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'de Havilland Goblin 2 (RM 1)',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 13.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 64,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **J 21RA** : première série de chasseurs, réacteur Goblin 2 importé\n- **J 21RB** : seconde série, réacteur Goblin 3 produit sous licence (RM 1A)\n- **A 21RA / A 21RB** : reclassement en avion d''attaque au début des années 1950, roquettes sous voilure\n- **Saab 21** : version d''origine à moteur à pistons et hélice propulsive (1943)',
  variants_en       = E'- **J 21RA** : first fighter batch, imported Goblin 2 engine\n- **J 21RB** : second batch, licence-built Goblin 3 engine (RM 1A)\n- **A 21RA / A 21RB** : reclassified as attack aircraft in the early 1950s, underwing rockets\n- **Saab 21** : original piston-engined version with pusher propeller (1943)',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Saab_21R',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saab_21R',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'André Gerwing',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Saab 21R';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saab 21R';
