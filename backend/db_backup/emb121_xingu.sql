-- Embraer EMB 121 Xingu
--
-- Photo : French Navy Embraer EMB121AN Xingu from Lann-Bihoué arriving to pick up some French participants and take them home. (6283028824).jpg
--   licence CC BY 2.0 — Jerry Gunner from Lincoln, UK
--   https://commons.wikimedia.org/wiki/File:French_Navy_Embraer_EMB121AN_Xingu_from_Lann-Bihou%C3%A9_arriving_to_pick_up_some_French_participants_and_take_them_home._(6283028824).jpg

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
    'Embraer EMB 121 Xingu',
    'Embraer EMB 121 Xingu',
    'Embraer EMB 121 Xingu',
    'Embraer EMB 121 Xingu',
    'Biturbopropulseur pressurisé brésilien sur lequel les équipages de transport français apprennent le bimoteur',
    'Brazilian pressurised twin turboprop on which French transport crews learn to fly multi-engine aircraft',
    '/assets/airplanes/emb121-xingu.jpg',
    E'## Genèse\nEn 1975, Embraer lance une famille de trois dérivés pressurisés à empennage en T de son **EMB 110 Bandeirante**. Le plus petit, et le premier à voir le jour, est l''EMB 121 **Xingu**, du nom d''un fleuve amazonien : il reprend l''aile raccourcie et les turbopropulseurs PT6A du Bandeirante sur un fuselage entièrement nouveau, de section circulaire. Le prototype vole à São Paulo le 10 octobre 1976 et le premier avion de série le 20 mai 1977, avant d''être présenté au salon du Bourget. La force aérienne brésilienne en reçoit six en 1978 pour le transport d''autorités.\n\n## Conception\nMonoplan à aile basse et train tricycle escamotable, le Xingu emporte six passagers en configuration type et neuf au maximum. Les essais conduisent à ajouter des saumons en flèche, un amortisseur de lacet et une grande quille ventrale. Le **Xingu II**, qui vole le 4 septembre 1981, reçoit des PT6A-135 de 750 ch et davantage de carburant ; il remplace le Xingu I en production après 29 exemplaires. Un Xingu III allongé est abandonné en 1984, Embraer concentrant ses efforts sur le Tucano, le Brasilia et l''AMX.\n\n## Carrière opérationnelle\nEn septembre 1980, le ministère français de la Défense choisit le Xingu, devant le **King Air** de Beechcraft et le Cessna 425, pour l''entraînement multimoteur de l''armée de l''Air et l''entraînement et les liaisons de l''Aéronavale ; 41 appareils sont livrés avant la fin de 1983. Ils remplacent les **Flamant** et forment, à l''école de l''aviation de transport d''Avord, les pilotes destinés au transport et à la guerre électronique ; la Marine les déploie notamment à Lann-Bihoué. Au Brésil, les VU-9 de transport servent jusqu''en 2010, et des EC-9 calibrent les radars et jouent les cibles de guerre électronique.\n\n## Place dans l''histoire\nProduit à 106 exemplaires jusqu''en 1987, dont 51 exportés, le Xingu marque le passage d''Embraer de l''avion de ligne régional non pressurisé à l''avion d''affaires pressurisé, sur la route qui mène au Brasilia. Sa vraie carrière est pourtant française : en 1998, la Marine verse sept appareils à l''école d''Avord, devenue interarmées, et en 2022 la France aligne encore 22 Xingu dans l''armée de l''Air et 10 dans la Marine, plus de quarante ans après leur commande.',
    E'## Genesis\nIn 1975 Embraer launched a family of three pressurised, T-tailed derivatives of its **EMB 110 Bandeirante**. The smallest, and the first to appear, was the EMB 121 **Xingu**, named after an Amazonian river: it combined the Bandeirante''s shortened wing and PT6A turboprops with an all-new fuselage of circular section. The prototype flew at São Paulo on 10 October 1976 and the first production aircraft on 20 May 1977, before being shown at the Paris Air Show. The Brazilian Air Force received six in 1978 for VIP transport.\n\n## Design\nA low-wing monoplane with retractable tricycle landing gear, the Xingu carries six passengers in a typical layout and nine at most. Flight testing led to swept wingtips, a yaw damper and a large ventral fin. The **Xingu II**, which flew on 4 September 1981, received 750 shp PT6A-135s and more fuel; it replaced the Xingu I in production after 29 had been built. A stretched Xingu III was abandoned by 1984, as Embraer concentrated on the Tucano, the Brasilia and the AMX.\n\n## Operational career\nIn September 1980 the French Ministry of Defence chose the Xingu, ahead of Beechcraft''s **King Air** and the Cessna 425, for multi-engine training in the Air Force and for training and liaison in Naval Aviation; 41 aircraft were delivered by the end of 1983. They replaced the **Flamant** and, at the transport aviation school at Avord, trained pilots bound for transport and electronic warfare aircraft; the Navy based them notably at Lann-Bihoué. In Brazil the VU-9 transports served until 2010, while EC-9s calibrated radars and acted as electronic warfare targets.\n\n## Place in history\nBuilt to 106 examples up to 1987, 51 of them exported, the Xingu took Embraer from the unpressurised regional airliner to the pressurised business aircraft, on the road to the Brasilia. Yet its real career was French: in 1998 the Navy handed seven aircraft over to the Avord school, which became a joint-service unit, and in 2022 France still fielded 22 Xingus in the Air Force and 10 in the Navy, more than forty years after ordering them.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1975-01-01',
    '1976-10-10',
    '1977-05-20',
    467,
    1230,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB 121 Xingu'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB 121 Xingu'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB 121 Xingu'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.25,
  wingspan          = 14.05,
  height            = 4.84,
  wing_area         = 27.5,
  empty_weight      = 3710,
  mtow              = 5670,
  service_ceiling   = 8500,
  climb_rate        = 9.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-135 (750 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1977,
  production_end    = 1987,
  units_built       = 106,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **EMB 121A Xingu I** : version de série initiale à PT6A-28 de 680 ch, 29 construits\n- **EMB 121A1 Xingu II** : PT6A-135 de 750 ch, plus de carburant et jusqu''à neuf passagers, premier vol le 4 septembre 1981\n- **EMB 121B Xingu III** : version allongée à PT6A-42, un prototype converti, abandonnée en 1984\n- **VU-9 / U-9** : transport d''autorités et liaison de la force aérienne brésilienne\n- **EC-9** : calibration radar et cible de guerre électronique de la force aérienne brésilienne',
  variants_en       = E'- **EMB 121A Xingu I**: initial production version with 680 shp PT6A-28s, 29 built\n- **EMB 121A1 Xingu II**: 750 shp PT6A-135s, more fuel and up to nine passengers, first flight on 4 September 1981\n- **EMB 121B Xingu III**: stretched version with PT6A-42s, one prototype converted, abandoned by 1984\n- **VU-9 / U-9**: Brazilian Air Force VIP transport and liaison\n- **EC-9**: Brazilian Air Force radar calibration and electronic warfare target aircraft',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Embraer_EMB-121_Xingu',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Embraer_EMB_121_Xingu',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jerry Gunner',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Embraer EMB 121 Xingu';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Embraer EMB 121 Xingu';
