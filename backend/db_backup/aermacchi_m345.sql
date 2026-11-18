-- Aermacchi M-345 HET
--
-- Photo : Aermacchi M-345.jpg
--   licence CC BY-SA 4.0 — Clement2569
--   https://commons.wikimedia.org/wiki/File:Aermacchi_M-345.jpg

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
    'Aermacchi M-345',
    'Aermacchi M-345',
    'Aermacchi M-345 HET',
    'Aermacchi M-345 HET',
    'Le petit jet d''école italien qui remplace le MB-339, au coût d''exploitation d''un turbopropulseur',
    'The small Italian jet trainer replacing the MB-339, at the operating cost of a turboprop',
    '/assets/airplanes/aermacchi-m345.jpg',
    E'## Genèse\nEn 1997, Aermacchi rachète SIAI-Marchetti et, avec elle, les droits du **S.211**, un petit avion-école à réaction. En 2004, le constructeur annonce une version améliorée, le **M-311**, capable de couvrir l''entraînement de base et avancé ainsi que la formation tactique, en alternative aux monoturbopropulseurs concurrents. Le premier prototype vole le 1er juin 2005, mais aucune commande ne suit. En 2012, Alenia Aermacchi révise le projet et le rebaptise **M-345 HET**, pour High Efficiency Trainer.\n\n## Conception\nLe M-345 est un biplace compact à aile haute et sièges en tandem, propulsé par un turboréacteur double flux **Williams FJ44-4M** de 15,4 kN, préféré en 2014 aux offres de Honeywell et de Pratt & Whitney. Sa cabine, aux dimensions proches de celle du **BAE Hawk**, reçoit des sièges éjectables zéro-zéro Martin-Baker, trois écrans multifonctions, un collimateur tête haute et une centrale inertielle couplée au GPS. Un système de simulation embarqué, le même que celui du **M-346 Master**, peut recréer menaces, cibles et capteurs. Quatre points d''emport, pour plus de 1 000 kg, lui donnent une capacité secondaire d''appui aérien rapproché.\n\n## Carrière opérationnelle\nLe M-345 vole le 29 décembre 2016, et l''Aeronautica Militare en commande cinq dès janvier 2017, puis treize de plus en juin 2019. Le premier exemplaire de série décolle de Venegono Superiore en décembre 2018, la certification militaire est obtenue en mai 2020 et les deux premiers appareils sont acceptés en décembre 2020. Désigné T-345A, il entre officiellement en service en juin 2025 au 61e Stormo de Lecce-Galatina. Prévu pour les **Frecce Tricolori**, il leur est finalement retiré en 2024 au profit du M-346, le M-345 étant jugé peu adapté au vol en grande formation.\n\n## Place dans l''histoire\nLe M-345 remplace l''**Aermacchi MB-339**, en service depuis le début des années 1980, et l''armée de l''air italienne prévoit d''en acquérir au moins 45. Il incarne le pari de son constructeur : un petit jet dont le coût d''exploitation reste proche de celui des turbopropulseurs, pour garder l''élève sur réacteur de la formation de base jusqu''à l''avancé. Avec le M-346, il forme désormais la filière d''entraînement de l''armée de l''air italienne.',
    E'## Genesis\nIn 1997 Aermacchi bought SIAI-Marchetti and with it the rights to the **S.211**, a small jet trainer. In 2004 the company announced an improved version, the **M-311**, able to cover basic and advanced training as well as tactical training, as an alternative to single-engined turboprop rivals. The first prototype flew on 1 June 2005, but no orders followed. In 2012 Alenia Aermacchi revised the design and renamed it the **M-345 HET**, for High Efficiency Trainer.\n\n## Design\nThe M-345 is a compact two-seat, shoulder-wing aircraft with tandem seating, powered by a 15.4 kN **Williams FJ44-4M** turbofan, chosen in 2014 over bids from Honeywell and Pratt & Whitney. Its cockpit, broadly the size of the **BAE Hawk**''s, has Martin-Baker zero-zero ejection seats, three multi-function displays, a head-up display and a GPS-coupled inertial navigation unit. An embedded simulation system, the same as the **M-346 Master**''s, can recreate threats, targets and sensors. Four hardpoints, for more than 1,000 kg, give it a secondary close air support capability.\n\n## Operational career\nThe M-345 flew on 29 December 2016, and the Italian Air Force ordered five in January 2017, then thirteen more in June 2019. The first production aircraft took off from Venegono Superiore in December 2018, military certification followed in May 2020 and the first two aircraft were accepted in December 2020. Designated T-345A, it formally entered service in June 2025 with the 61st Stormo at Lecce-Galatina. Planned for the **Frecce Tricolori**, it was dropped for them in 2024 in favour of the M-346, being judged unsuited to large-formation display flying.\n\n## Place in history\nThe M-345 replaces the **Aermacchi MB-339**, in service since the early 1980s, and the Italian Air Force plans to acquire at least 45. It embodies its maker''s wager: a small jet whose operating cost stays close to that of turboprops, keeping the student on jets from basic to advanced training. Together with the M-346, it now forms the Italian Air Force''s training pipeline.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '2012-01-01',
    '2016-12-29',
    '2020-12-01',
    740,
    1410,
    (SELECT id FROM manufacturer WHERE code = 'LEO'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi M-345'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi M-345'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi M-345'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi M-345'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.85,
  wingspan          = 8.47,
  height            = 3.74,
  wing_area         = 12.6,
  empty_weight      = 3300,
  mtow              = 4500,
  service_ceiling   = 12190,
  climb_rate        = 24.0,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.5,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Williams FJ44-4M-34',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 15.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2018,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **S.211** : avion-école de SIAI-Marchetti, dont Aermacchi rachète les droits en 1997\n- **M-311** : S.211 modernisé à réacteur Pratt & Whitney Canada JT15D-5C, deux prototypes, premier vol le 1er juin 2005\n- **M-345 HET** : nouvelle désignation du M-311 à partir de 2012, réacteur Williams FJ44-4M\n- **T-345A** : désignation militaire italienne ; 18 commandés en 2017 et 2019, au moins 45 prévus',
  variants_en       = E'- **S.211**: SIAI-Marchetti trainer whose rights Aermacchi bought in 1997\n- **M-311**: modernised S.211 with a Pratt & Whitney Canada JT15D-5C, two prototypes, first flown on 1 June 2005\n- **M-345 HET**: redesignation of the M-311 from 2012, Williams FJ44-4M engine\n- **T-345A**: Italian military designation; 18 ordered in 2017 and 2019, at least 45 planned',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aermacchi_M-345_HET',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aermacchi_M-345',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clement2569',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Aermacchi M-345';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aermacchi M-345';
