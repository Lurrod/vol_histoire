-- Beechcraft MC-12W Liberty
--
-- Photo : MC-12W Liberty and U-28A Draco (7050055).jpg
--   licence Public domain — Andrew LaMoreaux
--   https://commons.wikimedia.org/wiki/File:MC-12W_Liberty_and_U-28A_Draco_(7050055).jpg

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
    'Beechcraft MC-12W Liberty',
    'Beechcraft MC-12W Liberty',
    'Beechcraft MC-12W Liberty',
    'Beechcraft MC-12W Liberty',
    'King Air bourré de capteurs, jeté en 2009 dans les guerres d''Irak et d''Afghanistan pour traquer les insurgés',
    'Sensor-packed King Air rushed into the Iraq and Afghanistan wars in 2009 to hunt insurgents',
    '/assets/airplanes/mc12w-liberty.jpg',
    E'## Genèse\nDepuis 1974, les forces armées américaines achètent sous la désignation **C-12 Huron** des King Air de **Beechcraft**, d''abord pour la liaison et le transport de personnel, puis comme porteurs de systèmes d''écoute, à l''image du **RC-12 Guardrail**. À la fin des années 2000, les guerres d''Irak et d''Afghanistan réclament toujours plus de renseignement, de surveillance et de reconnaissance (ISR). L''US Air Force lance alors **Project Liberty** : un King Air 350 militarisé, envoyé au combat dans l''urgence comme moyen d''appoint de surveillance et de renseignement d''origine électromagnétique.\n\n## Conception\nBeechcraft construit l''avion de base, puis l''envoie à Greenville, au Texas, où **L-3 Communications Missions Integration** installe l''équipement de renseignement, de surveillance et de reconnaissance. La flotte compte d''abord huit King Air 350 et vingt-neuf 350ER, la version à autonomie accrue, avant de finir à 42 appareils, tous des 350ER. Le MC-12W reste un biturbopropulseur de série : plutôt qu''un avion conçu pour la mission, l''Air Force choisit une cellule existante, transformée par un intégrateur, pour combler au plus vite un besoin du front.\n\n## Carrière opérationnelle\nLe MC-12W effectue sa première mission de combat le 10 juin 2009 ; il sert en Irak et en Afghanistan, et ailleurs dans le monde pour le commandement des opérations spéciales. En 2013, le programme Liberty dépasse déjà 300 000 heures de vol en opérations. Au total, la flotte vole 400 000 heures de combat en 79 000 sorties, contribue à la mort ou à la capture de « plus de 8 000 terroristes » et à la découverte de 650 caches d''armes ; un appareil est perdu au combat. Ses missions reprises par la flotte croissante de **MQ-9 Reaper**, l''Air Force cède ses 41 Liberty à l''**USSOCOM**, à l''US Army et à d''autres agences ; son dernier déploiement, au profit d''Enduring Freedom, s''achève le 13 octobre 2015.\n\n## Place dans l''histoire\nLe Liberty montre qu''un avion d''affaires militarisé peut fournir une part du renseignement réclamé par la contre-insurrection, aux côtés des drones. Sa carrière se poursuit hors de l''Air Force : l''US Army le rebaptise **MC-12S** une fois doté du système EMARSS-S, et l''Aviation royale canadienne commande trois appareils similaires pour ses forces spéciales. Le commandement des opérations spéciales de l''Air Force envisage même de remplacer par lui ses **U-28A Draco**, avant que le Congrès ne s''y oppose. Son dernier MC-12W est retiré en septembre 2025.',
    E'## Genesis\nSince 1974 the US armed forces have bought Beechcraft King Airs under the designation **C-12 Huron**, first for liaison and personnel transport, then as carriers for eavesdropping systems such as the **RC-12 Guardrail**. In the late 2000s the wars in Iraq and Afghanistan demanded ever more intelligence, surveillance and reconnaissance (ISR). The US Air Force launched **Project Liberty**: a militarised King Air 350, rushed into combat as a supplemental surveillance and signals intelligence asset.\n\n## Design\nBeechcraft built the basic aircraft, then sent it to Greenville, Texas, where **L-3 Communications Missions Integration** installed the intelligence, surveillance and reconnaissance equipment. The fleet first comprised eight King Air 350s and twenty-nine 350ERs, the extended-range version, before ending up at 42 aircraft, all 350ERs. The MC-12W remained a production twin turboprop: rather than an aircraft designed for the mission, the Air Force chose an existing airframe, converted by an integrator, to meet a front-line need as fast as possible.\n\n## Operational career\nThe MC-12W flew its first combat mission on 10 June 2009; it served in Iraq and Afghanistan, and elsewhere in the world for Special Operations Command. By 2013 the Liberty programme had already exceeded 300,000 combat flying hours. In all the fleet flew 400,000 combat hours in 79,000 sorties, helped kill or capture "more than 8,000 terrorists" and uncovered 650 weapons caches; one aircraft was lost in combat. With its roles taken over by the growing **MQ-9 Reaper** fleet, the Air Force handed its 41 Liberty aircraft to **USSOCOM**, the US Army and other agencies; its last deployment, for Enduring Freedom, ended on 13 October 2015.\n\n## Place in history\nThe Liberty showed that a militarised business aircraft could provide part of the intelligence demanded by counter-insurgency, alongside drones. Its career continued outside the Air Force: the US Army renamed it **MC-12S** once fitted with the EMARSS-S system, and the Royal Canadian Air Force ordered three similar aircraft for its special forces. Air Force Special Operations Command even planned to replace its **U-28A Dracos** with it, before Congress objected. Its last MC-12W was retired in September 2025.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    NULL,
    '2009-06-10',
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BEE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft MC-12W Liberty'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft MC-12W Liberty'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft MC-12W Liberty'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'Beechcraft MC-12W Liberty'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = NULL,
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 42,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **MC-12W (King Air 350)** : huit premiers appareils, militarisés à Greenville par L-3 Communications Missions Integration\n- **MC-12W (King Air 350ER)** : version à autonomie accrue, 29 puis 42 exemplaires au total, dont un perdu au combat\n- **MC-12S EMARSS-S** : désignation de l''US Army pour les MC-12W repris et dotés du système EMARSS-S\n- **Version canadienne** : trois appareils similaires commandés par l''Aviation royale canadienne pour soutenir ses forces spéciales',
  variants_en       = E'- **MC-12W (King Air 350)**: first eight aircraft, militarised in Greenville by L-3 Communications Missions Integration\n- **MC-12W (King Air 350ER)**: extended-range version, 29 then 42 aircraft in all, one of them lost in combat\n- **MC-12S EMARSS-S**: US Army designation for MC-12Ws taken over and fitted with the EMARSS-S system\n- **Canadian version**: three similar aircraft ordered by the Royal Canadian Air Force to support its special forces',

  -- Strate 4 : qualitatif
  nickname          = 'Liberty',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beechcraft_C-12_Huron',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beechcraft_C-12_Huron',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Andrew LaMoreaux',
  image_licence     = 'Public domain'
WHERE name = 'Beechcraft MC-12W Liberty';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beechcraft MC-12W Liberty';
