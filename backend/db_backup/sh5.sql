-- Harbin SH-5 (PS-5)
--
-- Photo : Harbin SH-5.jpg
--   licence CC BY-SA 4.0 — Ronidong
--   https://commons.wikimedia.org/wiki/File:Harbin_SH-5.jpg

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
    'Harbin SH-5',
    'Harbin SH-5',
    'Harbin SH-5 (PS-5)',
    'Harbin SH-5 (PS-5)',
    'Le grand amphibie quadrimoteur de l''aéronavale chinoise, chasseur de sous-marins et sauveteur en mer',
    'The Chinese naval air arm''s big four-engined amphibian, submarine hunter and sea rescuer',
    '/assets/airplanes/harbin-sh5.jpg',
    E'## Genèse\nEn 1968, l''aéronavale chinoise lance l''étude d''un hydravion destiné à remplacer ses **Beriev Be-6**, avec un cahier des charges bien plus large. Les concepteurs sont prélevés sur un projet de chasseur supersonique à plan canard. La **Harbin Aircraft Manufacturing Corporation**, associée à l''institut chinois de conception d''hydravions sous la direction de **Wang Hongzhang**, dessine un quadrimoteur polyvalent baptisé **Shuishang Hongzhaji 5**, « bombardier maritime 5 ». L''instabilité politique de l''époque ralentit tout : l''aile principale n''est achevée qu''en octobre 1972, et les essais au sol ne commencent qu''en 1974.\n\n## Conception\nLe SH-5 est un amphibie à coque, propulsé par quatre turbopropulseurs **Dongan WJ-5A** de 3 150 ch entraînant des hélices quadripales réversibles. Son nez abrite un radar de recherche, et une perche de queue un détecteur d''anomalie magnétique pour traquer les sous-marins. Quatre points d''emport reçoivent jusqu''à 6 tonnes de torpilles anti-sous-marines, de grenades, de mines ou de bombes ; le missile antinavire **C-101** prévu n''a jamais été mis au point. Il décolle de l''eau en 548 m, peut emporter 10 tonnes de fret et franchit 4 756 km avec le plein.\n\n## Carrière opérationnelle\nLe premier prototype décolle le 3 avril 1976 pour un vol de 23 minutes. L''aéronavale de l''Armée populaire de libération reçoit quatre appareils en 1986, tous basés près de **Qingdao**, dans le Shandong, au sein de la flotte du Nord. Ses missions vont de la lutte anti-sous-marine au sauvetage en mer en passant par la patrouille maritime et le transport. En 1988, l''un des appareils est transformé en bombardier d''eau, le **SH-5B**, et une version de renseignement électronique, le SH-5A, est aussi décrite.\n\n## Place dans l''histoire\nConstruit à sept exemplaires seulement, prototypes compris, le SH-5 aura mis près de vingt ans à passer de l''étude à la mise en service. Il reste l''homologue chinois des grands amphibies de patrouille de son temps, le **Be-12** soviétique et les **US-1** japonais, et a donné à la Chine un patrouilleur amphibie de conception nationale pour succéder au Be-6 d''origine soviétique.',
    E'## Genesis\nIn 1968 the Chinese naval air force began work on a seaplane to replace its **Beriev Be-6**s, with a much broader requirement. The designers were reassigned from a supersonic canard fighter project. The **Harbin Aircraft Manufacturing Corporation**, working with the Chinese seaplane design institute under **Wang Hongzhang**, drew up a multi-role four-engined aircraft called **Shuishang Hongzhaji 5**, ''maritime bomber 5''. The political instability of the time slowed everything: the main wing was only completed in October 1972, and ground tests did not begin until 1974.\n\n## Design\nThe SH-5 is a flying-boat amphibian powered by four **Dongan WJ-5A** turboprops of 3,150 hp driving four-bladed reversible propellers. Its nose houses a search radar, and a tail boom a magnetic anomaly detector to track submarines. Four hardpoints carry up to 6 tonnes of anti-submarine torpedoes, depth charges, mines or bombs; the planned **C-101** anti-ship missile was never completed. It takes off from water in 548 m, can carry 10 tonnes of cargo and has a range of 4,756 km with maximum fuel.\n\n## Operational career\nThe first prototype flew on 3 April 1976, a 23-minute flight. The People''s Liberation Army Naval Air Force received four aircraft in 1986, all based near **Qingdao** in Shandong province with the North Sea Fleet. Its missions ranged from anti-submarine warfare to air-sea rescue, by way of maritime patrol and transport. In 1988 one aircraft was converted into a water bomber, the **SH-5B**, and an electronic intelligence version, the SH-5A, has also been described.\n\n## Place in history\nBuilt in only seven examples, prototypes included, the SH-5 took nearly twenty years to go from study to service. It remains the Chinese counterpart of the large patrol amphibians of its day, the Soviet **Be-12** and the Japanese **US-1**, and gave China a home-designed patrol amphibian to succeed the Soviet-built Be-6.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '1968-01-01',
    '1976-04-03',
    '1986-01-01',
    560,
    4756,
    (SELECT id FROM manufacturer WHERE code = 'HAMC'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Harbin SH-5'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion')),
((SELECT id FROM airplanes WHERE name = 'Harbin SH-5'), (SELECT id FROM tech WHERE name = 'Détecteur d''anomalie magnétique')),
((SELECT id FROM airplanes WHERE name = 'Harbin SH-5'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Harbin SH-5'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Harbin SH-5'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'Harbin SH-5'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 38.9,
  wingspan          = 36,
  height            = 9.79,
  wing_area         = 144,
  empty_weight      = 25000,
  mtow              = 45000,
  service_ceiling   = 10250,
  climb_rate        = 9,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 8,

  -- Strate 2 : motorisation
  engine_name       = 'Dongan WJ-5A (3 150 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 7,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **SH-5** : désignation d''origine, trois prototypes et quatre avions de série pour l''aéronavale\n- **PS-5** : appellation de la configuration de lutte anti-sous-marine\n- **SH-5A** : version de renseignement électronique\n- **SH-5B** : bombardier d''eau, un exemplaire converti en 1988',
  variants_en       = E'- **SH-5**: original designation, three prototypes and four production aircraft for the naval air force\n- **PS-5**: name of the anti-submarine configuration\n- **SH-5A**: electronic intelligence version\n- **SH-5B**: water bomber, one aircraft converted in 1988',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Harbin_SH-5',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Harbin_SH-5',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ronidong',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Harbin SH-5';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Harbin SH-5';
