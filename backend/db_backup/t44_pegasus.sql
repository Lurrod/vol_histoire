-- Beechcraft T-44A Pegasus
--
-- Photo : Beech T-44C Pegasus.jpg
--   licence Public domain — U.S. Navy Photo by Richard Stewart
--   https://commons.wikimedia.org/wiki/File:Beech_T-44C_Pegasus.jpg

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
    'Beechcraft T-44 Pegasus',
    'Beechcraft T-44 Pegasus',
    'Beechcraft T-44A Pegasus',
    'Beechcraft T-44A Pegasus',
    'King Air 90 de l''US Navy sur lequel apprennent à voler sur bimoteur les pilotes de quatre armes américaines',
    'US Navy King Air 90 on which pilots from four US services learn to fly multi-engine aircraft',
    '/assets/airplanes/t44-pegasus.jpg',
    E'## Genèse\nLe T-44 descend du **King Air**, premier biturbopropulseur d''affaires de sa catégorie. Conçu en 1961 sous le nom de Model 120, il dérive du **Queen Air** à pistons : le Model 87, un Queen Air équipé de turbines Pratt & Whitney Canada PT6A, vole le 15 mai 1963, et le prototype définitif le 24 janvier 1964. L''US Army en est l''un des premiers clients. En 1976, l''US Navy commande quinze King Air, avec une option sur 56 autres, dans le cadre du programme **VTAM(X)**, qui doit remplacer ses vieux TS-2A et TS-2B **Tracker** d''entraînement à moteurs à pistons.\n\n## Conception\nDésigné Model H90 par Beechcraft, le T-44A est un King Air C90 adapté à la formation au pilotage des multimoteurs, propulsé par deux PT6A-34B de 750 ch. Il garde la cabine pressurisée du C90 et l''aile allongée de 1,5 m introduite sur cette version en 1971, et il est produit sous le même certificat de type que le Queen Air. En août 2006, après 29 ans de service, la Navy annonce la modernisation de son avionique : 25 appareils reçoivent la suite Rockwell Collins Pro Line 21 et deviennent des **T-44C**.\n\n## Carrière opérationnelle\nLes quinze premiers T-44A sont livrés d''avril à octobre 1977, une seconde commande de 23 appareils ayant été notifiée le 19 janvier 1977 ; au total, 61 exemplaires sont livrés jusqu''en 1980, tandis qu''une commande de cinq T-44B est annulée. Le Pegasus forme les pilotes multimoteurs de la Navy, du Marine Corps, des garde-côtes et de l''Air Force. Il finit même par suffire seul à la tâche : en 2017, quand l''USAF cesse d''envoyer ses élèves, la Navy retire ses TC-12B Huron, car sa flotte de T-44C couvre les besoins de la Navy, du Marine Corps et des garde-côtes.\n\n## Place dans l''histoire\nLe T-44 illustre le passage de la formation multimoteur des pistons aux turbines, avec un avion d''affaires du commerce plutôt qu''un appareil militaire spécialisé. Le King Air, produit sans interruption de 1964 à 2021, s''est vendu davantage que tous ses concurrents à turbopropulseurs réunis, et d''autres armées l''emploient de la même manière : la marine japonaise exploite 34 TC-90 d''entraînement depuis 1973, qui franchissent en 2005 le cap des 500 000 heures de vol sans accident, avant d''en céder deux à la marine philippine en 2017.',
    E'## Genesis\nThe T-44 descends from the **King Air**, the first business twin turboprop in its class. Conceived in 1961 as the Model 120, it was derived from the piston-engined **Queen Air**: the Model 87, a Queen Air fitted with Pratt & Whitney Canada PT6A turbines, flew on 15 May 1963, and the definitive prototype on 24 January 1964. The US Army was one of its first customers. In 1976 the US Navy ordered fifteen King Airs, with an option on 56 more, under the **VTAM(X)** programme to replace its old piston-engined TS-2A and TS-2B **Tracker** trainers.\n\n## Design\nDesignated Model H90 by Beechcraft, the T-44A is a King Air C90 adapted for multi-engine pilot training and powered by two 750 shp PT6A-34Bs. It keeps the C90''s pressurised cabin and the wing lengthened by 1.5 m on that version in 1971, and it was built under the same type certificate as the Queen Air. In August 2006, after 29 years of service, the Navy announced an avionics upgrade: 25 aircraft received the Rockwell Collins Pro Line 21 suite and became **T-44Cs**.\n\n## Operational career\nThe first fifteen T-44As were delivered between April and October 1977, a second order for 23 aircraft having been placed on 19 January 1977; in all, 61 were delivered up to 1980, while an order for five T-44Bs was cancelled. The Pegasus trained multi-engine pilots for the Navy, Marine Corps, Coast Guard and Air Force. It eventually became enough on its own: in 2017, when the USAF stopped sending students, the Navy retired its TC-12B Hurons because its T-44C fleet met the needs of the Navy, Marine Corps and Coast Guard.\n\n## Place in history\nThe T-44 illustrates the move of multi-engine training from pistons to turbines, using a commercial business aircraft rather than a specialised military design. The King Air, built continuously from 1964 to 2021, outsold all its turboprop competitors combined, and other armed forces use it the same way: the Japanese navy has flown 34 TC-90 trainers since 1973, which passed 500,000 accident-free flying hours in 2005, before handing two over to the Philippine Navy in 2017.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1976-01-01',
    NULL,
    '1977-04-01',
    500,
    2446,
    (SELECT id FROM manufacturer WHERE code = 'BEE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft T-44 Pegasus'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft T-44 Pegasus'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.82,
  wingspan          = 15.32,
  height            = 4.34,
  wing_area         = 27.0,
  empty_weight      = 3150,
  mtow              = 4580,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-34B (750 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1977,
  production_end    = 1980,
  units_built       = 61,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **King Air C90** : biturbopropulseur d''affaires pressurisé de 1971, base civile du T-44\n- **T-44A (Model H90)** : école multimoteur de l''US Navy à PT6A-34B de 750 ch, 61 livrés de 1977 à 1980\n- **T-44B** : cinq appareils commandés puis annulés\n- **T-44C** : T-44A modernisés avec l''avionique Rockwell Collins Pro Line 21 à partir de 2006, 25 convertis',
  variants_en       = E'- **King Air C90**: 1971 pressurised business twin turboprop, the civil basis of the T-44\n- **T-44A (Model H90)**: US Navy multi-engine trainer with 750 shp PT6A-34Bs, 61 delivered from 1977 to 1980\n- **T-44B**: five aircraft ordered then cancelled\n- **T-44C**: T-44As upgraded with Rockwell Collins Pro Line 21 avionics from 2006, 25 converted',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beechcraft_King_Air',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beechcraft_King_Air',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Richard Stewart, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Beechcraft T-44 Pegasus';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beechcraft T-44 Pegasus';
