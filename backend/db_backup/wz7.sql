-- Guizhou WZ-7 Xianglong (Soaring Dragon)
--
-- Photo : WZ-7 at Changchun Airshow 20250921.jpg
--   licence CC BY-SA 4.0 — 颐园居
--   https://commons.wikimedia.org/wiki/File:WZ-7_at_Changchun_Airshow_20250921.jpg

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
    'Guizhou WZ-7',
    'Guizhou WZ-7',
    'Guizhou WZ-7 Xianglong (Soaring Dragon)',
    'Guizhou WZ-7 Xianglong (Soaring Dragon)',
    'Le drone espion chinois de haute altitude à ailes jointes, qui surveille Taïwan, le Japon et la mer de Chine',
    'China''s high-altitude joined-wing spy drone, watching over Taiwan, Japan and the South China Sea',
    '/assets/airplanes/wz7-soaring-dragon.jpg',
    E'## Genèse\nLe **WZ-7**, ou *Wuzhen-7*, répond au besoin chinois d''un drone de haute altitude et longue endurance comparable au **RQ-4 Global Hawk** américain. Il est conçu par le groupe aéronautique de **Chengdu** et construit par **Guizhou**. Une maquette apparaît dès le salon de Zhuhai en 2006, mais le programme avance lentement : en 2011, l''appareil n''a toujours pas volé et subit des essais de signature radar. La production en série commence en 2015-2016, et la version opérationnelle n''est officiellement présentée qu''au salon de Zhuhai en 2021.\n\n## Conception\nLe trait le plus original du WZ-7 est sa voilure à **ailes jointes** en tandem : l''aile arrière rejoint l''aile avant. Cette architecture, plus rigide qu''une aile classique de grand allongement, doit améliorer la finesse et simplifier les commandes de vol. L''entrée d''air est posée sur le dos du fuselage, le réacteur à l''arrière. Le prototype volait avec un turboréacteur **WP-13**, copie du Toumanski R-13 soviétique ; l''appareil de série, redessiné avec deux dérives inclinées, reçoit un turboréacteur double flux **WS-13**. Le prototype annonçait 18 000 m de plafond et 7 000 km de distance franchissable.\n\n## Carrière opérationnelle\nLe WZ-7 entre en service dans l''armée de l''air chinoise en 2018, puis dans l''aéronavale, et il est déployé au Tibet, sur l''île de Hainan et près de la Corée du Nord. Le 24 juillet 2019, il suit le croiseur américain **USS Antietam** dans le détroit de Taïwan. On le signale près de la frontière indienne fin 2022, au-dessus de la mer de Chine méridionale à partir de 2022, puis en mars 2024 au-dessus de la mer du Japon. En avril 2024, il survole la partie philippine de la mer de Chine méridionale, sans doute pour observer le lanceur de missiles américain Typhon installé à Luçon.\n\n## Place dans l''histoire\nLe WZ-7 donne à la Chine une surveillance persistante loin de ses côtes, jusqu''aux zones où croisent les flottes américaines. Il pourrait aussi fournir des données de ciblage aux missiles balistiques antinavires et aux missiles de croisière chinois, ce qui en ferait l''œil de leurs frappes à longue distance contre des navires. Une vingtaine d''exemplaires sont en service : douze dans l''armée de l''air en 2022, huit dans l''aéronavale en 2018.',
    E'## Genesis\nThe **WZ-7**, or *Wuzhen-7*, meets China''s need for a high-altitude long-endurance drone comparable to the American **RQ-4 Global Hawk**. It was designed by the **Chengdu** aircraft group and built by **Guizhou**. A model appeared at the Zhuhai air show as early as 2006, but the programme moved slowly: in 2011 the aircraft had still not flown and was undergoing radar cross-section testing. Series production began in 2015-2016, and the operational version was only officially unveiled at the 2021 Zhuhai air show.\n\n## Design\nThe WZ-7''s most original feature is its tandem **joined-wing** layout: the rear wing joins the front wing. This architecture, stiffer than a conventional high-aspect-ratio wing, is meant to improve the lift-to-drag ratio and simplify the flight controls. The air intake sits on top of the fuselage, with the engine at the rear. The prototype flew with a **WP-13** turbojet, a copy of the Soviet Tumansky R-13; the production aircraft, redesigned with twin canted fins, received a **WS-13** turbofan. The prototype was credited with an 18,000 m ceiling and a 7,000 km range.\n\n## Operational career\nThe WZ-7 entered service with the Chinese air force in 2018, then with naval aviation, and was deployed to Tibet, Hainan Island and near North Korea. On 24 July 2019 it shadowed the American cruiser **USS Antietam** through the Taiwan Strait. It was reported near the Indian border in late 2022, over the South China Sea from 2022, then in March 2024 over the Sea of Japan. In April 2024 it flew over the Philippine part of the South China Sea, probably to watch the American Typhon missile launcher deployed on Luzon.\n\n## Place in history\nThe WZ-7 gives China persistent surveillance far from its coasts, out to the areas where American fleets sail. It could also provide targeting data for Chinese anti-ship ballistic missiles and cruise missiles, which would make it the eye of their long-range strikes against ships. Around twenty are in service: twelve with the air force in 2022 and eight with naval aviation in 2018.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    NULL,
    NULL,
    '2018-01-01',
    NULL,
    7000,
    (SELECT id FROM manufacturer WHERE code = 'GAIC'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Guizhou WZ-7'), (SELECT id FROM tech WHERE name = 'Aile jointe')),
((SELECT id FROM airplanes WHERE name = 'Guizhou WZ-7'), (SELECT id FROM tech WHERE name = 'Conception aérodynamique pour haute altitude')),
((SELECT id FROM airplanes WHERE name = 'Guizhou WZ-7'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Guizhou WZ-7'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.33,
  wingspan          = 24.86,
  height            = 5.41,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = 18000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2000,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Guizhou WS-13 (WP-13 sur le prototype)',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2015,
  production_end    = NULL,
  units_built       = 20,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Prototype « Soaring Dragon »** : dérive unique, turboréacteur WP-13 de 43,1 kN, dix heures d''endurance annoncées, maquette montrée en 2006\n- **WZ-7 de série** : cellule redessinée avec deux dérives inclinées, tuyère modifiée et turboréacteur double flux WS-13, observée en 2020 et en service depuis 2018 dans l''armée de l''air et l''aéronavale chinoises',
  variants_en       = E'- **"Soaring Dragon" prototype**: single fin, 43.1 kN WP-13 turbojet, ten hours'' advertised endurance, model shown in 2006\n- **Production WZ-7**: redesigned airframe with twin canted fins, modified nozzle and WS-13 turbofan, observed in 2020 and in service since 2018 with the Chinese air force and naval aviation',

  -- Strate 4 : qualitatif
  nickname          = 'Soaring Dragon',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Guizhou_WZ-7',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Guizhou_WZ-7_Soaring_Dragon',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '颐园居',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Guizhou WZ-7';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Guizhou WZ-7';
