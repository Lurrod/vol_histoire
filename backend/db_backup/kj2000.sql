-- KJ-2000 (Mainring)
--
-- Photo : KJ2000 at 2014 Zhuhai Air Show.jpg
--   licence CC BY-SA 4.0 — Danny Yu
--   https://commons.wikimedia.org/wiki/File:KJ2000_at_2014_Zhuhai_Air_Show.jpg

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
    'KJ-2000',
    'KJ-2000',
    'KJ-2000 (Mainring)',
    'KJ-2000 (Mainring)',
    'Privée de radar israélien, la Chine construit seule son grand avion de guet',
    'Denied an Israeli radar, China built its own large early-warning aircraft',
    '/assets/airplanes/kj2000.jpg',
    E'## Genèse\nÀ la fin des années 1990, la Chine négocie avec la Russie et Israël l''achat d''**A-50I** : une cellule **Il-76** russe portant le radar israélien **EL/M-2075 Phalcon**. En juillet 2000, sous la pression de Washington, Israël renonce au contrat. Pékin décide alors de développer seul un guet aérien sur la même cellule, avec une électronique entièrement chinoise.\n\n## Conception\nLe radar, conçu par l''Institut de recherche en électronique de Nankin (NRIET), est à antennes actives à balayage électronique. Ses trois panneaux, disposés en triangle dans un radôme circulaire fixe, couvrent chacun un secteur de 120° : contrairement au radôme tournant de l''**A-50** ou de l''**E-3 Sentry**, rien ne bouge. La portée de détection annoncée atteint environ 470 km contre un chasseur. La cellule, un Il-76 acheté en Russie, est modifiée en Chine ; l''endurance est d''environ sept heures quarante.\n\n## Carrière opérationnelle\nLe premier exemplaire vole en 2003 et l''appareil entre en service vers 2005. Il apparaît publiquement le 1er octobre 2009, en tête du défilé aérien du soixantième anniversaire de la République populaire. La rareté des cellules Il-76 disponibles limite la série à quatre ou cinq exemplaires selon les sources. Il assure la surveillance des approches maritimes chinoises et la coordination des grands exercices aériens. L''OTAN le désigne **Mainring**.\n\n## Place dans l''histoire\nLe KJ-2000 est l''un des premiers grands avions de guet à antennes actives fixes, après le Phalcon israélien qu''il devait initialement porter. Il fait de la Chine l''un des rares pays à maîtriser seul cette technologie. Il ouvre une famille : le **KJ-500**, plus léger, sur cellule **Shaanxi Y-9**, puis le KJ-3000 sur **Xian Y-20**, appelé à lui succéder.',
    E'## Genesis\nIn the late 1990s China negotiated with Russia and Israel to buy the **A-50I**: a Russian **Il-76** airframe carrying the Israeli **EL/M-2075 Phalcon** radar. In July 2000, under pressure from Washington, Israel withdrew from the contract. Beijing then decided to develop an early-warning aircraft on the same airframe on its own, with entirely Chinese electronics.\n\n## Design\nThe radar, designed by the Nanjing Research Institute of Electronics Technology (NRIET), uses active electronically scanned arrays. Its three panels, arranged in a triangle inside a fixed circular radome, each cover a 120° sector: unlike the rotating radome of the **A-50** or the **E-3 Sentry**, nothing moves. Announced detection range reaches about 470 km against a fighter. The airframe, an Il-76 bought from Russia, is modified in China; endurance is about seven hours forty minutes.\n\n## Operational career\nThe first aircraft flew in 2003 and the type entered service around 2005. It appeared publicly on 1 October 2009, leading the flypast for the sixtieth anniversary of the People''s Republic. The scarcity of available Il-76 airframes limited production to four or five aircraft, depending on the source. It watches over China''s maritime approaches and coordinates large air exercises. NATO calls it **Mainring**.\n\n## Place in history\nThe KJ-2000 is one of the first large early-warning aircraft with fixed active arrays, after the Israeli Phalcon it was originally meant to carry. It made China one of the few countries to master this technology alone. It opened a family: the lighter **KJ-500** on the **Shaanxi Y-9** airframe, then the KJ-3000 on the **Xian Y-20**, intended to succeed it.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2000-07-01',
    '2003-01-01',
    '2005-01-01',
    850.0,
    5500.0,
    (SELECT id FROM manufacturer WHERE code = 'XAC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'KJ-2000'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'KJ-2000'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'KJ-2000'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'KJ-2000'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'KJ-2000'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 46.59,
  wingspan          = 50.5,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 175000,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Aviadvigatel D-30KP-2',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 117.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **KJ-2000** : version unique, cellule **Il-76** à radôme circulaire fixe\n- **Radar à trois antennes actives** disposées en triangle, 120° chacune, sans pièce tournante\n- **A-50I** : projet initial russo-israélien à radar Phalcon, abandonné en juillet 2000\n- **KJ-500** : guet plus léger de la même famille, sur cellule **Shaanxi Y-9**\n- Successeur annoncé : **KJ-3000**, sur cellule **Xian Y-20**',
  variants_en       = E'- **KJ-2000** : single version, **Il-76** airframe with a fixed circular radome\n- **Three active-array radar** panels in a triangle, 120° each, no rotating parts\n- **A-50I** : original Russian-Israeli project with Phalcon radar, abandoned in July 2000\n- **KJ-500** : lighter early-warning aircraft of the same family, on the **Shaanxi Y-9** airframe\n- Announced successor: **KJ-3000**, on the **Xian Y-20** airframe',

  -- Strate 4 : qualitatif
  nickname          = 'Mainring',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/KJ-2000',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Shaanxi_KJ-2000',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Danny Yu',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'KJ-2000';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'KJ-2000';
