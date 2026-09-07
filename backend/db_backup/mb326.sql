-- Aermacchi MB-326
--
-- Photo : Aermacchi MB-326 (Australia) A7-014 & A7-015.jpg
--   licence CC BY-SA 4.0 — Peter Ellis
--   https://commons.wikimedia.org/wiki/File%3AAermacchi_MB-326_%28Australia%29_A7-014_%26_A7-015.jpg

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
    'Aermacchi MB-326',
    'Aermacchi MB-326',
    'Aermacchi MB-326',
    'Aermacchi MB-326',
    'Entraîneur italien à réaction, construit sur quatre continents',
    'Italian jet trainer, built on four continents',
    '/assets/airplanes/mb326.jpg',
    E'## Genèse\nEn 1954, Aermacchi parie que les forces aériennes voudront former leurs pilotes **directement sur réaction**, sans passer par une phase à hélice. L''entreprise développe le MB-326 sur ses fonds propres, sans commande. Le pari est juste : ce sera l''un des entraîneurs les plus vendus de l''histoire.\n\n## Conception\nAile droite, réacteur Viper unique, sièges en tandem. Rien de spectaculaire, mais une cellule **docile, endurante et bon marché à l''heure de vol**, capable d''emporter des armes sur six points d''emport. C''est cette double vocation — école le matin, attaque légère l''après-midi — qui séduit les pays à budget contraint.\n\n## Carrière opérationnelle\nSept cent soixante et un exemplaires en Italie, et surtout des productions sous licence sur quatre continents : **Brésil** (Xavante), **Afrique du Sud** (Impala), **Australie** (CA-30). Les Impala sud-africains combattent en Angola ; les Xavante brésiliens servent trente ans.\n\n## Place dans l''histoire\nLe MB-326 fonde la spécialité italienne de l''entraîneur à réaction, qui se poursuivra sans interruption avec le **MB-339** puis le **M-346 Master**. Peu d''appareils de cette encyclopédie ont été produits dans autant de pays différents.',
    E'## Genesis\nIn 1954 Aermacchi bet that air forces would want to train their pilots **directly on jets**, without a piston phase. The company developed the MB-326 with its own money, with no order. The bet was right: it became one of the best-selling trainers in history.\n\n## Design\nA straight wing, a single Viper engine, tandem seats. Nothing spectacular, but a **docile, durable airframe, cheap per flying hour**, able to carry weapons on six hardpoints. That dual vocation — school in the morning, light attack in the afternoon — is what appealed to budget-constrained countries.\n\n## Operational career\nSeven hundred and sixty-one built in Italy, and above all licence production on four continents: **Brazil** (Xavante), **South Africa** (Impala), **Australia** (CA-30). South African Impalas fought in Angola; Brazilian Xavantes served thirty years.\n\n## Place in history\nThe MB-326 founded the Italian speciality of the jet trainer, continued without a break by the **MB-339** and then the **M-346 Master**. Few aircraft in this encyclopedia have been built in so many different countries.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1954-01-01',
    '1957-12-10',
    '1962-02-01',
    806.0,
    2130.0,
    (SELECT id FROM manufacturer WHERE code = 'LEO'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Viper'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'), (SELECT id FROM armement WHERE name = 'DEFA 553')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.65,
  wingspan          = 10.85,
  height            = 3.72,
  wing_area         = 19.35,
  empty_weight      = 2237,
  mtow              = 5216,
  service_ceiling   = 12500,
  climb_rate        = 32,
  g_limit_pos       = 8.0,
  g_limit_neg       = -4.0,
  combat_radius     = 650,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Viper 20 Mk 540',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 15.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1961,
  production_end    = 1975,
  units_built       = 761,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 12,
  variants          = E'- **MB-326** : entraîneur biplace de base\n- **MB-326K** : monoplace d''attaque légère, canons de 30 mm\n- **Atlas Impala** : production sud-africaine, engagée en Angola\n- **Embraer EMB-326 Xavante** : production brésilienne sous licence, 182 exemplaires\n- **CAC CA-30** : production australienne',
  variants_en       = E'- **MB-326** : baseline two-seat trainer\n- **MB-326K** : single-seat light attack version with 30 mm cannon\n- **Atlas Impala** : South African production, used in Angola\n- **Embraer EMB-326 Xavante** : Brazilian licence production, 182 aircraft\n- **CAC CA-30** : Australian production',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aermacchi_MB-326',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aermacchi_MB-326',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Peter Ellis',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Aermacchi MB-326';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aermacchi MB-326';
