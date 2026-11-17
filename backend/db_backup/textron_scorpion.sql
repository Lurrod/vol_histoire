-- Textron AirLand Scorpion
--
-- Photo : Textron AirLand Scorpion ‘N531TA’ (46072263322).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Textron_AirLand_Scorpion_%E2%80%98N531TA%E2%80%99_(46072263322).jpg

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
    'Textron AirLand Scorpion',
    'Textron AirLand Scorpion',
    'Textron AirLand Scorpion',
    'Textron AirLand Scorpion',
    'Un biréacteur d''attaque légère conçu en secret et en vingt-trois mois, resté sans client',
    'A light-attack twinjet designed in secret in twenty-three months, still without a customer',
    '/assets/airplanes/textron-scorpion.jpg',
    E'## Genèse\nEn octobre 2011, un groupe d''investisseurs, **AirLand Enterprises**, propose à **Textron** de construire « l''avion tactique à réaction le plus abordable du monde ». Les deux sociétés fondent la coentreprise **Textron AirLand** et lancent le développement en janvier 2012, sans aucune demande militaire : ce sont leurs propres études de marché qui définissent le besoin, celui de forces qui veulent mieux qu''un turbopropulseur sans pouvoir s''offrir un F-35. Parmi une douzaine de configurations étudiées, l''équipe retient un biplace en tandem et biréacteur.\n\n## Conception\nLe projet, nom de code SCV12-1, est mené dans le secret à Wichita par environ 200 personnes de Textron, **Cessna** et Bell, réunies dans un même bâtiment. Pour réduire les coûts, il reprend des équipements des avions d''affaires Citation : le mécanisme des volets vient des Citation XLS et Mustang, celui des ailerons du Citation X. Hors train et attaches moteurs, la cellule est entièrement en composites, prévue pour 20 000 heures. Deux réacteurs **Honeywell TFE731** de 18 kN, une aile peu flèchée à six points d''emport et une soute interne modulable de 1 400 kg reçoivent capteurs ou armes. Pas de commandes de vol électriques, pour rester simple : l''heure de vol est annoncée à 3 000 dollars.\n\n## Essais\nDévoilé le 16 septembre 2013, le prototype N531TA vole le 12 décembre 2013, vingt-trois mois après la naissance du projet. En avril 2014, il a atteint 9 100 m, encaissé de +3,7 à −0,5 g et intercepté un Cessna 182 ; il se montre à Farnborough en juillet. Démonstrations auprès de la Garde nationale aérienne et en Colombie, discussions avec les Émirats, le Nigeria ou l''Inde : aucun contrat ne suit. Un appareil au standard de série, à flèche accentuée et commandes HOTAS, vole le 22 décembre 2016. En février 2018, l''US Air Force l''écarte de son évaluation d''avion d''attaque légère au profit du **Beechcraft AT-6** et de l''**Embraer A-29 Super Tucano**.\n\n## Place dans l''histoire\nLe Scorpion tente de rouvrir un marché disparu dans les années 1980, celui de l''avion d''attaque léger à réaction, quand les pays riches choisissaient des appareils plus capables et les pays pauvres des turbopropulseurs et des hélicoptères. Développé aux risques de l''industriel plutôt que commandé par un État, il a prouvé qu''un avion de combat pouvait voler moins de deux ans après sa conception ; il n''a pas trouvé de client. Quatre exemplaires ont été construits.',
    E'## Genesis\nIn October 2011 a group of investors, **AirLand Enterprises**, approached **Textron** with the idea of building ''the world''s most affordable tactical jet aircraft''. The two companies formed the **Textron AirLand** joint venture and began development in January 2012 with no military requirement at all: their own market studies defined the need, that of forces wanting more than a turboprop but unable to afford an F-35. From a dozen configurations studied, the team chose a tandem two-seat twinjet.\n\n## Design\nThe project, codenamed SCV12-1, was run in secret at Wichita by some 200 people from Textron, **Cessna** and Bell, gathered in a single building. To cut costs it reused equipment from the Citation business jets: the flap drive comes from the Citation XLS and Mustang, the aileron drive from the Citation X. Apart from the landing gear and engine mounts, the airframe is all-composite, designed for 20,000 hours. Two 18 kN **Honeywell TFE731** turbofans, a lightly swept wing with six hardpoints and a reconfigurable 1,400 kg internal bay carry sensors or weapons. There is no fly-by-wire, to keep it simple: the flying hour was quoted at $3,000.\n\n## Testing\nUnveiled on 16 September 2013, the prototype N531TA flew on 12 December 2013, twenty-three months after the project began. By April 2014 it had reached 9,100 m, pulled from +3.7 to −0.5 g and intercepted a Cessna 182; it appeared at Farnborough in July. Demonstrations to the Air National Guard and in Colombia, talks with the Emirates, Nigeria or India: no contract followed. A production-standard aircraft, with increased sweep and hands-on-throttle-and-stick controls, flew on 22 December 2016. In February 2018 the US Air Force dropped it from its light attack evaluation in favour of the **Beechcraft AT-6** and the **Embraer A-29 Super Tucano**.\n\n## Place in history\nThe Scorpion tried to reopen a market that had vanished in the 1980s, that of the light attack jet, when rich countries chose more capable aircraft and poorer ones turboprops and helicopters. Developed at the manufacturer''s own risk rather than ordered by a state, it proved that a combat aircraft could fly less than two years after its conception; it did not find a customer. Four have been built.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2012-01-01',
    '2013-12-12',
    NULL,
    830,
    4100,
    (SELECT id FROM manufacturer WHERE code = 'TXT'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Textron AirLand Scorpion'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Textron AirLand Scorpion'), (SELECT id FROM tech WHERE name = 'Réacteur Honeywell TFE731'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Textron AirLand Scorpion'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Textron AirLand Scorpion'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Textron AirLand Scorpion'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Textron AirLand Scorpion'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.87,
  wingspan          = 14.58,
  height            = 4.06,
  wing_area         = 16.29,
  empty_weight      = 5761,
  mtow              = 9979,
  service_ceiling   = 13716,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Honeywell TFE731',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 17.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Prototype N531TA** : démonstrateur désigné Cessna E530, premier vol le 12 décembre 2013\n- **Scorpion de série** : train simplifié, flèche accentuée et nouvelle avionique, premier vol le 22 décembre 2016\n- **Version d''entraînement** : variante envisagée pour le programme T-X de l''US Air Force, abandonnée en septembre 2015',
  variants_en       = E'- **Prototype N531TA**: demonstrator designated Cessna E530, first flown on 12 December 2013\n- **Production-standard Scorpion**: simplified landing gear, increased sweep and new avionics, first flown on 22 December 2016\n- **Trainer version**: variant considered for the US Air Force T-X programme, dropped in September 2015',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Textron_AirLand_Scorpion',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Textron AirLand Scorpion';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Textron AirLand Scorpion';
