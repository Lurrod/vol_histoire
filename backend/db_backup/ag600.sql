-- AVIC AG600 Kunlong
--
-- Photo : AG-600 at Airshow China 2016.jpg
--   licence CC BY-SA 4.0 — Alert5
--   https://commons.wikimedia.org/wiki/File:AG-600_at_Airshow_China_2016.jpg

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
    'AVIC AG600',
    'AVIC AG600',
    'AVIC AG600 Kunlong',
    'AVIC AG600 Kunlong',
    'Hydravion géant chinois, bombardier d''eau et sauveteur en mer capable d''atteindre les récifs disputés',
    'Giant Chinese flying boat, water bomber and sea rescuer able to reach disputed reefs',
    '/assets/airplanes/avic-ag600.jpg',
    E'## Genèse\nL''**AG600**, d''abord appelé Dragon 600 puis TA-600, est l''un des trois « grands avions » approuvés par le Conseil des affaires de l''État chinois, aux côtés du transport militaire **Xian Y-20** et de l''avion de ligne Comac C919. Conçu par l''institut de recherche des véhicules spéciaux d''**AVIC** et assemblé par sa filiale CAIGA, il doit lutter contre les feux de forêt et secourir en mer, mais aussi surveiller l''environnement et les ressources maritimes. Après cinq ans d''études, sa construction commence en août 2014 et le prototype est présenté le 23 juillet 2016 à Zhuhai.\n\n## Conception\nC''est un amphibie à **coque unique**, aile haute cantilever et train tricycle escamotable, mû par quatre turbopropulseurs Ivtchenko AI-20 à hélices hexapales. Avec 53,5 tonnes au décollage depuis une piste, AVIC le présente comme le plus grand hydravion amphibie du monde, plus lourd que le Beriev Be-200 et le ShinMaywa US-2. Il opère sur un plan d''eau de 1 500 mètres sur 200, profond de 2,5 mètres, et par creux de 2 mètres. Il **écope 12 tonnes d''eau en 20 secondes** et peut recueillir jusqu''à 50 naufragés ; son autonomie atteint 12 heures.\n\n## Carrière opérationnelle\nLe premier vol a lieu le **24 décembre 2017** depuis l''aéroport de Zhuhai : 64 minutes à 3 000 mètres. Viennent ensuite le premier décollage depuis le réservoir de Zhanghe, à Jingmen, le 20 octobre 2018, puis le premier vol au départ de la mer, au large de Qingdao, le 26 juillet 2020. La version de lutte contre l''incendie **AG600M** vole le 29 août 2022 et réussit ses essais d''écopage et de largage le mois suivant. Commandé à 17 exemplaires par des organismes de l''État chinois, dont les garde-côtes, l''appareil obtient son certificat de type le 20 avril 2025 ; les livraisons commencent en octobre 2025.\n\n## Place dans l''histoire\nAvec l''AG600, la Chine revendique le plus grand hydravion amphibie du monde et rejoint le Japon et la Russie parmi les rares constructeurs de grands amphibies. Sa vocation affichée est civile, mais sa géographie ne l''est pas tout à fait : il peut rallier en quatre heures, depuis Sanya, le banc James, limite sud des revendications chinoises, et desservir les atolls disputés des îles Spratleys en mer de Chine méridionale.',
    E'## Genesis\nThe **AG600**, first called the Dragon 600 and then the TA-600, is one of the three "big aircraft" projects approved by China''s State Council, alongside the **Xian Y-20** military transport and the Comac C919 airliner. Designed by **AVIC**''s Special Vehicle Research Institute and assembled by its subsidiary CAIGA, it is meant to fight forest fires and carry out sea rescue, but also to monitor the environment and maritime resources. After five years of development, construction began in August 2014 and the prototype was rolled out on 23 July 2016 at Zhuhai.\n\n## Design\nIt is a **single-hull** amphibian with a cantilever high wing and retractable tricycle landing gear, powered by four Ivchenko AI-20 turboprops driving six-bladed propellers. At 53.5 tonnes take-off weight from a runway, AVIC presents it as the world''s largest amphibious aircraft, heavier than the Beriev Be-200 and the ShinMaywa US-2. It can operate from a stretch of water 1,500 by 200 metres and 2.5 metres deep, and in 2-metre waves. It **scoops 12 tonnes of water in 20 seconds** and can pick up as many as 50 people at sea; its endurance reaches 12 hours.\n\n## Operational career\nThe first flight took place on **24 December 2017** from Zhuhai airport: 64 minutes at 3,000 metres. Then came the first take-off from the Zhanghe reservoir at Jingmen on 20 October 2018, and the first flight from the sea, off Qingdao, on 26 July 2020. The **AG600M** firefighting version flew on 29 August 2022 and completed its scooping and dropping tests the following month. Ordered in 17 examples by Chinese state bodies, including the coast guard, the aircraft obtained its type certificate on 20 April 2025, with deliveries starting in October 2025.\n\n## Place in history\nWith the AG600, China claims the world''s largest amphibious aircraft and joins Japan and Russia among the few builders of large amphibians. Its stated purpose is civil, but its geography is not entirely so: it can fly in four hours from Sanya to James Shoal, the southern limit of China''s claims, and serve the disputed atolls of the Spratly Islands in the South China Sea.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2009-01-01',
    '2017-12-24',
    '2025-10-01',
    560,
    4500,
    (SELECT id FROM manufacturer WHERE code = 'AVIC'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AVIC AG600'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion')),
((SELECT id FROM airplanes WHERE name = 'AVIC AG600'), (SELECT id FROM tech WHERE name = 'Système d''écopage')),
((SELECT id FROM airplanes WHERE name = 'AVIC AG600'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AVIC AG600'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'AVIC AG600'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 36.9,
  wingspan          = 38.8,
  height            = 12.1,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 53500,
  service_ceiling   = 6000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Ivtchenko AI-20',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2025,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **TA-600 / AG600** : prototype amphibie, présenté en juillet 2016, premier vol le 24 décembre 2017\n- **AG600M** : bombardier d''eau dédié, premier vol le 29 août 2022, essais d''écopage et de largage en septembre 2022\n- **Versions envisagées** : surveillance maritime, prospection des ressources, transport de passagers et de fret',
  variants_en       = E'- **TA-600 / AG600**: amphibious prototype, rolled out in July 2016, first flight on 24 December 2017\n- **AG600M**: dedicated water bomber, first flight on 29 August 2022, scooping and dropping tests in September 2022\n- **Planned versions**: maritime surveillance, resource detection, passenger and cargo transport',

  -- Strate 4 : qualitatif
  nickname          = 'Kunlong',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/AVIC_TA-600',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AVIC_AG600',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alert5',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'AVIC AG600';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AVIC AG600';
