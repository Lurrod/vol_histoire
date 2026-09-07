-- Iliouchine Il-28 Beagle
--
-- Photo : Ilyushin Il-28 ’16 red’ (37995220605).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3AIlyushin_Il-28_%E2%80%9916_red%E2%80%99_%2837995220605%29.jpg

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
    'Il-28',
    'Il-28',
    'Iliouchine Il-28 Beagle',
    'Ilyushin Il-28 Beagle',
    'Bombardier tactique à réaction, exporté dans vingt pays',
    'Jet tactical bomber, exported to twenty countries',
    '/assets/airplanes/il28-beagle.jpg',
    E'## Genèse\nEn 1947, Staline exige un bombardier tactique à réaction. Iliouchine et Tupolev s''affrontent ; l''Il-28, plus simple et moins cher, l''emporte. Il vole avec des **Rolls-Royce Nene** achetés au Royaume-Uni puis copiés sous le nom de Klimov VK-1 — une décision britannique de 1946 dont Londres mesurera longtemps les conséquences.\n\n## Conception\nAile droite à faible allongement, deux réacteurs en nacelles sous les ailes, un équipage de trois avec une tourelle de queue. Rien de révolutionnaire, mais un ensemble d''une fiabilité et d''une facilité de maintenance qui expliquent sa diffusion massive.\n\n## Carrière opérationnelle\nPlus de **6 300 exemplaires** et vingt utilisateurs, de l''Égypte à la Corée du Nord en passant par la Chine, le Vietnam, l''Afghanistan et le Nigeria. Il est au cœur de la **crise des missiles de Cuba** : les Il-28 acheminés sur l''île, capables d''emporter une arme nucléaire tactique, figurent parmi les matériels dont Washington exige le retrait.\n\n## Place dans l''histoire\nLe Beagle est le premier avion de combat à réaction réellement banalisé, exporté à une échelle qui préfigure celle du MiG-21. Sa version chinoise, le **Harbin H-5**, a volé jusqu''aux années 1990.',
    E'## Genesis\nIn 1947 Stalin demanded a jet tactical bomber. Ilyushin and Tupolev competed; the simpler, cheaper Il-28 won. It flew on **Rolls-Royce Nene** engines bought from Britain and then copied as the Klimov VK-1 — a 1946 British decision whose consequences London measured for a long time.\n\n## Design\nA straight, low aspect ratio wing, two engines in underwing nacelles, a crew of three with a tail turret. Nothing revolutionary, but a combination of reliability and ease of maintenance that explains its massive spread.\n\n## Operational career\nMore than **6,300 built** and twenty operators, from Egypt to North Korea by way of China, Vietnam, Afghanistan and Nigeria. It stood at the centre of the **Cuban Missile Crisis**: the Il-28s shipped to the island, able to carry a tactical nuclear weapon, were among the systems Washington demanded be withdrawn.\n\n## Place in history\nThe Beagle was the first jet combat aircraft to become genuinely commonplace, exported on a scale that prefigured the MiG-21’s. Its Chinese version, the **Harbin H-5**, flew into the 1990s.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1947-01-01',
    '1948-07-08',
    '1950-09-01',
    902.0,
    2180.0,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM tech WHERE name = 'Réacteur Klimov VK-1')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM armement WHERE name = 'NR-23')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM armement WHERE name = 'FAB-1000'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971')),
((SELECT id FROM airplanes WHERE name = 'Il-28'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.65,
  wingspan          = 21.45,
  height            = 6.7,
  wing_area         = 60.8,
  empty_weight      = 12890,
  mtow              = 21200,
  service_ceiling   = 12300,
  climb_rate        = 15,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1100,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Klimov VK-1A',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 26.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1960,
  units_built       = 6316,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 20,
  variants          = E'- **Il-28** : bombardier tactique de base\n- **Il-28R** : reconnaissance photographique\n- **Il-28T** : porteur de torpilles pour l''aéronavale\n- **Harbin H-5** : production sous licence chinoise, plus de 2 000 exemplaires',
  variants_en       = E'- **Il-28** : baseline tactical bomber\n- **Il-28R** : photographic reconnaissance\n- **Il-28T** : torpedo carrier for naval aviation\n- **Harbin H-5** : Chinese licence production, more than 2,000 built',

  -- Strate 4 : qualitatif
  nickname          = 'Beagle',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-28',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-28',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Il-28';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Il-28';
