-- Yakovlev Yak-17 (Feather)
--
-- Photo : Yakolev Yak-17 ’02 blue’ (38369445244).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Yakolev_Yak-17_%E2%80%9902_blue%E2%80%99_(38369445244).jpg

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
    'Yak-17',
    'Yak-17',
    'Yakovlev Yak-17 (Feather)',
    'Yakovlev Yak-17 (Feather)',
    'Le Yak-15 mis sur train tricycle : l’école de jet du bloc de l’Est',
    'The Yak-15 on a tricycle undercarriage: the Eastern bloc’s jet school',
    '/assets/airplanes/yak17.jpg',
    E'## Genèse\nLe 24 avril 1946, le **Yak-15** et le **MiG-9** prennent l''air le même jour ; un tirage au sort désigne le MiG pour décoller le premier. Le Yak est un expédient : le fuselage du chasseur à hélice **Yak-3**, un réacteur allemand **Jumo 004** copié sous le nom de RD-10 et logé sous le nez, une tôle d''acier pour protéger le ventre des gaz chauds. Il garde le train classique à roulette de queue, que le jet du réacteur malmène. Deux cent quatre-vingts exemplaires sont construits en 1947.\n\n## Conception\nLes essais d''État de mai 1947 réclament un train adapté au réacteur. Le **Yak-17**, qui vole en juin 1947, reçoit un **train tricycle** : les jambes principales, reportées derrière le centre de gravité, prennent la place d''une partie des réservoirs, d''où deux réservoirs largables en bout d''aile. Moteur **RD-10A**, dérive agrandie, canons de 23 mm : pour le reste, l''avion change peu. Il demeure lent et son moteur peu fiable, mais il se pilote comme un Yak-3 — c''est sa qualité principale.\n\n## Carrière opérationnelle\nProduit à Tbilissi en 1948 et 1949, présenté au public à Touchino en 1949, il est vite surclassé par le **MiG-15**, qui le remplace à partir de 1950. La plupart des appareils de série sont des **Yak-17UTI** biplaces à double commande : ce sont eux qui forment les premiers pilotes de jet d''URSS, de Pologne, de Roumanie, de Bulgarie et de Chine, où 43 exemplaires arrivent en 1950-1951. La Roumanie s''en sert jusqu''en 1958 pour préparer ses pilotes au **Yak-23** ; la Tchécoslovaquie en évalue un.\n\n## Place dans l''histoire\nLe Yak-15 et le Yak-17 réunis totalisent 717 exemplaires. Leur rôle a été celui d''une passerelle entre l''hélice et le réacteur, dans des forces aériennes qui n''avaient encore jamais formé de pilote de jet. La fiche du **MiG-9** raconte le même départ vu depuis l''autre bureau d''études ; le **Yak-23**, qui reprend l''architecture du Yak-17 avec un moteur bien plus puissant, prend ensuite le relais chez Yakovlev.',
    E'## Genesis\nOn 24 April 1946 the **Yak-15** and the **MiG-9** took to the air on the same day; a draw decided that the MiG would take off first. The Yak was a stopgap: the fuselage of the **Yak-3** piston fighter, a German **Jumo 004** engine copied as the RD-10 and mounted under the nose, a steel sheet to protect the belly from the hot exhaust. It kept the conventional tailwheel undercarriage, which the jet blast punished. Two hundred and eighty were built in 1947.\n\n## Design\nThe state trials of May 1947 called for an undercarriage suited to a jet. The **Yak-17**, which flew in June 1947, received a **tricycle undercarriage**: the main legs, moved behind the centre of gravity, took the place of part of the fuel tanks, hence two drop tanks at the wingtips. An **RD-10A** engine, an enlarged fin, 23 mm cannon: otherwise the aircraft changed little. It remained slow and its engine unreliable, but it flew like a Yak-3 — its main virtue.\n\n## Operational career\nBuilt in Tbilisi in 1948 and 1949 and shown to the public at Tushino in 1949, it was soon outclassed by the **MiG-15**, which replaced it from 1950. Most production aircraft were two-seat dual-control **Yak-17UTIs**: they trained the first jet pilots of the USSR, Poland, Romania, Bulgaria and China, where 43 arrived in 1950-1951. Romania used them until 1958 to prepare its pilots for the **Yak-23**; Czechoslovakia evaluated one.\n\n## Place in history\nThe Yak-15 and Yak-17 together totalled 717 aircraft. Their role was that of a bridge between propeller and jet, in air forces that had never yet trained a jet pilot. The **MiG-9** entry tells the same start as seen from the other design bureau; the **Yak-23**, which took up the Yak-17''s layout with a far more powerful engine, then took over at Yakovlev.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1947-05-01',
    '1947-06-01',
    '1948-01-01',
    744.0,
    710.0,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-17'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-17'), (SELECT id FROM armement WHERE name = 'NS-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-17'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Yak-17'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Yak-17'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-17'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.78,
  wingspan          = 9.2,
  height            = NULL,
  wing_area         = 14.85,
  empty_weight      = 2081,
  mtow              = 3323,
  service_ceiling   = 11900,
  climb_rate        = 17.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Klimov RD-10A (copie du Jumo 004)',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1948,
  production_end    = 1949,
  units_built       = 430,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **Yak-15** : version d''origine à train classique, 280 exemplaires en 1947\n- **Yak-15U** : prototype à train tricycle et réservoirs de bout d''aile, devenu le Yak-17\n- **Yak-17** : chasseur monoplace de série, *Feather* pour l''OTAN\n- **Yak-17UTI** : biplace d''école à double commande, la version la plus produite, *Magnet* pour l''OTAN\n- **717 exemplaires** de Yak-15 et de Yak-17 au total',
  variants_en       = E'- **Yak-15** : original version with tailwheel undercarriage, 280 built in 1947\n- **Yak-15U** : prototype with tricycle undercarriage and wingtip tanks, which became the Yak-17\n- **Yak-17** : single-seat production fighter, NATO *Feather*\n- **Yak-17UTI** : two-seat dual-control trainer, the most produced version, NATO *Magnet*\n- **717 aircraft** of the Yak-15 and Yak-17 in all',

  -- Strate 4 : qualitatif
  nickname          = 'Feather',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-17',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-17',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Yak-17';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-17';
