-- Douglas C-54 Skymaster
--
-- Photo : Douglas R5D-3 of VR-724 over NAS Patuxent River in 1958.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Douglas_R5D-3_of_VR-724_over_NAS_Patuxent_River_in_1958.jpg

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
    'Douglas C-54 Skymaster',
    'Douglas C-54 Skymaster',
    'Douglas C-54 Skymaster',
    'Douglas C-54 Skymaster',
    'L''avion de ligne DC-4 passé sous l''uniforme, colonne vertébrale américaine du pont aérien de Berlin',
    'The DC-4 airliner put into uniform, backbone of the American effort in the Berlin Airlift',
    '/assets/airplanes/c54-skymaster.jpg',
    E'## Genèse\nEn 1941, Douglas prépare le **DC-4**, un quadrimoteur de ligne commandé par les compagnies américaines. L''entrée en guerre imminente des États-Unis change la donne : en juin 1941, le département de la Guerre reprend ces commandes et les attribue à l''US Army Air Forces sous la désignation **C-54 Skymaster**. Le premier exemplaire décolle de Clover Field, à Santa Monica, le 14 février 1942. Comme le C-47 né du DC-3, le Skymaster est un avion de ligne passé sous l''uniforme.\n\n## Conception\nLes premiers appareils gardent l''aménagement civil, alourdi de quatre réservoirs supplémentaires en cabine qui ramènent la capacité à 26 passagers. Le **C-54A**, disponible en février 1943, reçoit un plancher renforcé, une porte cargo, un palan et un treuil ; le C-54B loge son carburant dans les ailes et accepte des civières. La version la plus nombreuse, le **C-54D**, adopte des moteurs R-2000-11, et le C-54E passe rapidement du fret à 44 sièges. Ses quatre moteurs en étoile Pratt & Whitney Twin Wasp lui donnent 6 400 km d''autonomie. La Navy reçoit les siens sous le nom de **R5D**.\n\n## Carrière opérationnelle\nPendant la guerre, le C-54 est l''un des transports à long rayon d''action les plus employés par les forces américaines ; **Franklin D. Roosevelt**, **Douglas MacArthur** et **Winston Churchill** y voyagent. C''est à bord du VC-54C présidentiel *Sacred Cow* que **Harry S. Truman** signe en 1947 la loi qui crée l''US Air Force. En 1948, plus de 300 C-54 et R5D forment l''ossature de la contribution américaine au **pont aérien de Berlin**, acheminant charbon et vivres vers la ville. Ils assurent encore l''essentiel du transport aérien de la **guerre de Corée** : le 25 juin 1950, au premier jour de l''invasion, l''un d''eux est détruit au sol à Kimpo.\n\n## Place dans l''histoire\nRemplacé après la Corée par le **C-124 Globemaster II**, le Skymaster reste dans l''US Air Force jusqu''en 1972 ; le dernier de la Navy, un appareil de l''école des pilotes d''essai de Patuxent River, est retiré le 2 avril 1974. Construit à 1 170 exemplaires à Santa Monica et près de Chicago, il a servi plus de trente pays, transporté chefs d''État et blessés, participé au suivi des missiles, puis s''est reconverti en avion de ligne transatlantique et en bombardier d''eau jusqu''à la fin des années 1990.',
    E'## Genesis\nIn 1941 Douglas was preparing the **DC-4**, a four-engined airliner ordered by American airlines. The looming entry of the United States into the war changed everything: in June 1941 the War Department took over those orders and allocated them to the US Army Air Forces as the **C-54 Skymaster**. The first aircraft took off from Clover Field, Santa Monica, on 14 February 1942. Like the C-47 born of the DC-3, the Skymaster was an airliner put into uniform.\n\n## Design\nThe first aircraft kept their civil layout, weighed down by four extra cabin fuel tanks that cut capacity to 26 passengers. The **C-54A**, available from February 1943, gained a stronger floor, a cargo door, a hoist and a winch; the C-54B moved its fuel into the wings and took stretchers. The most numerous version, the **C-54D**, used R-2000-11 engines, and the C-54E could switch quickly from freight to 44 seats. Four Pratt & Whitney Twin Wasp radial engines gave it a range of 6,400 km. The Navy received its own as the **R5D**.\n\n## Operational career\nDuring the war the C-54 was one of the most widely used long-range transports of the American forces; **Franklin D. Roosevelt**, **Douglas MacArthur** and **Winston Churchill** all flew in it. It was aboard the presidential VC-54C *Sacred Cow* that **Harry S. Truman** signed the 1947 act creating the US Air Force. In 1948 more than 300 C-54s and R5Ds formed the backbone of the American contribution to the **Berlin Airlift**, hauling coal and food into the city. They again provided the main airlift of the **Korean War**: on 25 June 1950, the first day of the invasion, one was destroyed on the ground at Kimpo.\n\n## Place in history\nReplaced after Korea by the **C-124 Globemaster II**, the Skymaster stayed with the US Air Force until 1972; the Navy''s last, an aircraft of the Test Pilot School at Patuxent River, was retired on 2 April 1974. Built in 1,170 examples at Santa Monica and near Chicago, it served more than thirty countries, carried heads of state and wounded, took part in missile tracking, then found new lives as a transatlantic airliner and as a firefighting tanker until the late 1990s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1941-06-01',
    '1942-02-14',
    NULL,
    443,
    6400,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-54 Skymaster'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-54 Skymaster'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-54 Skymaster'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Douglas C-54 Skymaster'), (SELECT id FROM wars WHERE name = 'Guerre de Corée'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 28.6,
  wingspan          = 35.81,
  height            = 8.38,
  wing_area         = 136,
  empty_weight      = 17658,
  mtow              = 33112,
  service_ceiling   = 6800,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2000-9 Twin Wasp',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1942,
  production_end    = 1947,
  units_built       = 1170,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **C-54** : première version de série adaptée du DC-4, 24 exemplaires\n- **C-54A** : cellule renforcée, porte cargo et carburant accru, 252 exemplaires (R5D-1 dans la Navy)\n- **C-54B** : réservoirs intégrés aux ailes et fixations pour civières, 220 exemplaires\n- **C-54D** : C-54B à moteurs R-2000-11, version la plus nombreuse avec 380 exemplaires\n- **C-54E / C-54G** : carburant entièrement dans les ailes, conversion rapide fret-passagers, 125 et 162 exemplaires\n- **VC-54C *Sacred Cow*** : avion présidentiel à bord duquel Truman signe la loi de 1947 créant l''US Air Force',
  variants_en       = E'- **C-54**: first production version adapted from the DC-4, 24 built\n- **C-54A**: strengthened airframe, cargo door and more fuel, 252 built (R5D-1 in the Navy)\n- **C-54B**: integral wing tanks and stretcher fittings, 220 built\n- **C-54D**: C-54B with R-2000-11 engines, the most numerous version with 380 built\n- **C-54E / C-54G**: all fuel in the wings, rapid freight-to-passenger conversion, 125 and 162 built\n- **VC-54C *Sacred Cow***: presidential aircraft aboard which Truman signed the 1947 act creating the US Air Force',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_C-54_Skymaster',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Douglas C-54 Skymaster';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Douglas C-54 Skymaster';
