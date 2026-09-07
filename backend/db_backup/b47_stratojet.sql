-- Boeing B-47 Stratojet
--
-- Photo : Strategic Air Command B-47 Stratojets - 020903-o-9999r-001.jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany
--   https://commons.wikimedia.org/wiki/File%3ABoeing_WB-47E_%28B-47%29_%287279851188%29_%282%29.jpg

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
    'B-47 Stratojet',
    'B-47 Stratojet',
    'Boeing B-47 Stratojet',
    'Boeing B-47 Stratojet',
    'Bombardier à réaction qui a fixé la formule de tous les jets modernes',
    'Jet bomber that set the formula for every modern jet aircraft',
    '/assets/airplanes/b47-stratojet.jpg',
    E'## Genèse\nLe projet démarre en 1943 avec une aile droite. En 1945, les ingénieurs de Boeing découvrent en Allemagne les travaux sur l''**aile en flèche** ; ils redessinent l''appareil de fond en comble. Le résultat n''a aucun précédent : un bombardier aussi rapide que les chasseurs de l''époque.\n\n## Conception\nAile à 35° de flèche, très fine et si souple qu''elle bat de plus de cinq mètres en turbulence. Les **six réacteurs sont suspendus sous l''aile en nacelles**, disposition inédite qui allège la structure et facilite l''entretien. Le train est en tandem dans le fuselage, avec des balancines en bout d''aile. C''est cette architecture exacte que Boeing reprendra pour le B-52, puis pour le 707 et tous les avions de ligne qui suivront.\n\n## Carrière opérationnelle\nPlus de **2 000 exemplaires** : à son apogée, le Strategic Air Command en aligne 1 800, en alerte permanente. Aucun n''a jamais largué son arme. Les **RB-47** de reconnaissance électronique longent les frontières soviétiques ; plusieurs sont abattus, dont un au-dessus de la mer de Barents en 1960.\n\n## Place dans l''histoire\nLe B-47 est probablement l''avion le plus influent de cette encyclopédie sans avoir jamais combattu : l''aile en flèche associée à des réacteurs en nacelles sous voilure est devenue **la configuration de presque tous les avions à réaction construits depuis**, militaires comme civils.',
    E'## Genesis\nThe project began in 1943 with a straight wing. In 1945 Boeing’s engineers discovered German research on the **swept wing** and redrew the aircraft from scratch. The result had no precedent: a bomber as fast as the fighters of its day.\n\n## Design\nA 35° swept wing, very thin and so flexible it flexes more than five metres in turbulence. The **six engines hang under the wing in pods**, an unprecedented arrangement that lightens the structure and eases maintenance. The landing gear is tandem in the fuselage with outriggers at the wingtips. That exact architecture is what Boeing reused for the B-52, then the 707 and every airliner that followed.\n\n## Operational career\nMore than **2,000 built**: at its peak Strategic Air Command fielded 1,800 on permanent alert. None ever dropped its weapon. The **RB-47** electronic reconnaissance aircraft skirted Soviet borders; several were shot down, including one over the Barents Sea in 1960.\n\n## Place in history\nThe B-47 is probably the most influential aircraft in this encyclopedia never to have fought: a swept wing with podded engines beneath it became **the configuration of almost every jet aircraft built since**, military and civil alike.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1943-01-01',
    '1947-12-17',
    '1951-10-23',
    977.0,
    6500.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'), (SELECT id FROM armement WHERE name = 'B28')),
((SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'), (SELECT id FROM armement WHERE name = 'B43'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 32.6,
  wingspan          = 35.4,
  height            = 8.5,
  wing_area         = 132.7,
  empty_weight      = 35900,
  mtow              = 100000,
  service_ceiling   = 10100,
  climb_rate        = 24,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3240,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J47-GE-25',
  engine_count      = 6,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 32.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 1956,
  units_built       = 2032,
  unit_cost_usd     = 1900000,
  unit_cost_year    = 1952,
  operators_count   = 1,
  variants          = E'- **B-47B / E** : bombardiers de série, les plus nombreux\n- **RB-47** : reconnaissance électronique, missions le long des frontières soviétiques\n- **WB-47** : reconnaissance météorologique, dernière version en service\n- Retiré du bombardement dès **1965**, remplacé par le B-52 et les missiles balistiques',
  variants_en       = E'- **B-47B / E** : production bombers, the most numerous\n- **RB-47** : electronic reconnaissance, flying along the Soviet borders\n- **WB-47** : weather reconnaissance, the last version in service\n- Withdrawn from bombing as early as **1965**, replaced by the B-52 and ballistic missiles',

  -- Strate 4 : qualitatif
  nickname          = 'Stratojet',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_B-47_Stratojet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_B-47_Stratojet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'US Air Force photo',
  image_licence     = 'Public domain'
WHERE name = 'B-47 Stratojet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'B-47 Stratojet';
