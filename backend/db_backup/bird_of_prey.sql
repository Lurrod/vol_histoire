-- McDonnell Douglas / Boeing Bird of Prey
--
-- Photo : National Museum of the United States Air Force - 51839703935.jpg
--   licence CC BY 2.0 — loganrickert
--   https://commons.wikimedia.org/wiki/File:National_Museum_of_the_United_States_Air_Force_-_51839703935.jpg

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
    'Boeing Bird of Prey',
    'Boeing Bird of Prey',
    'McDonnell Douglas / Boeing Bird of Prey',
    'McDonnell Douglas / Boeing Bird of Prey',
    'Démonstrateur furtif secret des Phantom Works, baptisé d''après un vaisseau klingon et révélé seulement en 2002',
    'Secret Phantom Works stealth demonstrator, named after a Klingon starship and only revealed in 2002',
    '/assets/airplanes/bird-of-prey.jpg',
    E'## Genèse\nEn 1992, la division des projets spéciaux de **McDonnell Douglas**, les **Phantom Works**, lance en secret à la zone 51 un avion destiné à démontrer de nouvelles techniques de furtivité. Le constructeur finance seul le programme, à hauteur de 67 millions de dollars, une somme modeste pour ce genre de projet. Le nom fait référence au **Bird-of-Prey**, vaisseau des Klingons de la saga **Star Trek**. En 1997, la fusion avec **Boeing** fait passer les Phantom Works dans Boeing Integrated Defense Systems, et l''avion change de nom de constructeur en cours d''essais.\n\n## Conception\nPuisqu''il ne s''agit que d''un démonstrateur, tout est fait pour aller vite et pour pas cher : un turboréacteur double flux civil Pratt & Whitney Canada JT15D et des commandes hydrauliques manuelles au lieu de commandes de vol électriques. La forme, sans empennage horizontal ni gouverne de direction classique, est pourtant assez stable pour voler sans correction par ordinateur, en partie grâce à la portance des arêtes du fuselage, à la manière du SR-71. L''avion est dessiné pour ne pas projeter d''ombre, et l''on pense qu''il a servi à tester un camouflage actif, dont les surfaces changeraient de couleur ou de luminosité pour se fondre dans le décor.\n\n## Essais\nLe Bird of Prey vole pour la première fois le 11 septembre 1996, puis effectue 39 autres vols jusqu''à la fin du programme en 1999. Rien n''en filtre pendant toute cette période : l''appareil porte même une désignation de couverture, YF-118G. Il n''est révélé au public que le 18 octobre 2002, trois ans après son dernier vol, et entre le 16 juillet 2003 au musée national de l''US Air Force, à Dayton, où il est aujourd''hui suspendu au-dessus d''un F-22 Raptor.\n\n## Place dans l''histoire\nLe Bird of Prey n''a jamais été destiné à la production, mais ses techniques et ses matériaux passent sur le drone de combat **Boeing X-45**. Sa configuration sans dérive, stable sans empennage horizontal, devient un standard des drones furtifs qui suivent, du X-45 au **X-47**, dont le lacet est contrôlé par des aérofreins en bout d''aile. Il montre aussi qu''un démonstrateur bon marché, fait de pièces existantes, peut valider des idées que les programmes officiels mettent des années à financer.',
    E'## Genesis\nIn 1992 **McDonnell Douglas**''s special projects division, the **Phantom Works**, secretly began work at Area 51 on an aircraft to demonstrate new stealth techniques. The company funded the programme itself, to the tune of $67 million, a modest sum for such a project. The name alludes to the **Bird-of-Prey**, a Klingon starship from the **Star Trek** franchise. In 1997 the merger with **Boeing** moved the Phantom Works into Boeing Integrated Defense Systems, and the aircraft changed manufacturer in the middle of its test programme.\n\n## Design\nSince it was only a demonstrator, everything was done quickly and cheaply: a commercial off-the-shelf Pratt & Whitney Canada JT15D turbofan and manual hydraulic controls instead of fly-by-wire. Yet the shape, with no horizontal tail and no conventional rudder, was stable enough to fly without computer correction, partly thanks to lift from the fuselage chines, as on the SR-71. The aircraft was designed to prevent shadows, and is believed to have been used to test active camouflage, whose surfaces would change colour or luminosity to blend into the surroundings.\n\n## Testing\nThe Bird of Prey first flew on 11 September 1996, then made 39 more flights until the programme ended in 1999. Nothing leaked throughout: the aircraft even carried a cover designation, YF-118G. It was only made public on 18 October 2002, three years after its last flight, and went on display on 16 July 2003 at the National Museum of the United States Air Force in Dayton, where it now hangs above an F-22 Raptor.\n\n## Place in history\nThe Bird of Prey was never meant for production, but its technology and materials went on to Boeing''s **X-45** unmanned combat air vehicle. Its finless configuration, stable without a horizontal tail, became standard on the stealth drones that followed, from the X-45 to the **X-47**, which control yaw with wingtip airbrakes. It also showed that a cheap demonstrator built from existing parts could validate ideas that official programmes take years to fund.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1992-01-01',
    '1996-09-11',
    NULL,
    482,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing Bird of Prey'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Boeing Bird of Prey'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing Bird of Prey'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.22,
  wingspan          = 6.91,
  height            = 2.82,
  wing_area         = 20.4,
  empty_weight      = NULL,
  mtow              = 3356,
  service_ceiling   = 6100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada JT15D-5C',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 14.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Démonstrateur unique**, conçu par les Phantom Works de McDonnell Douglas à partir de 1992\n- **Premier vol le 11 septembre 1996**, 40 vols au total jusqu''en 1999\n- **YF-118G** : désignation de couverture attribuée pour masquer l''appareil\n- **Révélé le 18 octobre 2002**, exposé à Dayton depuis le 16 juillet 2003',
  variants_en       = E'- **Single demonstrator**, designed by McDonnell Douglas''s Phantom Works from 1992\n- **First flight on 11 September 1996**, 40 flights in all until 1999\n- **YF-118G**: cover designation given to hide the aircraft\n- **Unveiled on 18 October 2002**, on display in Dayton since 16 July 2003',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bird_of_Prey',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_Bird_of_Prey',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Logan Rickert',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Boeing Bird of Prey';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'Boeing Bird of Prey';
