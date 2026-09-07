-- Atlas Impala Mk I / Mk II
--
-- Photo : Atlas Impala Mk.II '1045' (15726051215).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs UK
--   https://commons.wikimedia.org/wiki/File%3AAtlas_Impala_Mk.II_%271045%27_%2815726051215%29.jpg

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
    'Atlas Impala',
    'Atlas Impala',
    'Atlas Impala Mk I / Mk II',
    'Atlas Impala Mk I / Mk II',
    'Un Aermacchi italien construit sous embargo en Afrique du Sud',
    'An Italian Aermacchi built under embargo in South Africa',
    '/assets/airplanes/atlas-impala.jpg',
    E'## Genèse\nL''Afrique du Sud de 1964 est sous embargo croissant en raison de l''apartheid, et sait que ses sources d''approvisionnement vont se fermer une à une. Elle négocie donc, tant qu''elle le peut, des **licences de fabrication** plutôt que des appareils : l''italien Aermacchi accepte de céder les droits du MB-326.\n\n## Conception\nL''Impala Mk I est un MB-326 d''entraînement ; le Mk II est sa version d''attaque monoplace, à structure renforcée et deux canons **ADEN** de 30 mm. Les premiers exemplaires arrivent en caisses d''Italie ; les suivants sont fabriqués intégralement à Kempton Park, y compris les réacteurs Viper. À la fin, l''appareil est sud-africain de bout en bout.\n\n## Carrière opérationnelle\nDeux cent soixante-seize exemplaires. Ils constituent l''essentiel de l''aviation d''appui sud-africaine pendant la **guerre de la frontière** en Angola et en Namibie, de 1975 à 1989. Le 27 septembre 1985, un Impala Mk II abat **deux hélicoptères Mi-8 angolais** au canon — l''une des rares victoires aériennes d''un avion-école armé.\n\n## Place dans l''histoire\nDeux cent soixante-seize exemplaires. L''Impala montre ce que produit un embargo : non pas la privation, mais une industrie nationale forcée. L''Afrique du Sud en tirera le **Cheetah**, modernisation locale du Mirage III, et le Rooivalk. Ce catalogue compte trois appareils sud-africains.',
    E'## Genesis\nSouth Africa in 1964 was under growing embargo over apartheid and knew its supply sources would close one by one. So it negotiated, while it still could, **manufacturing licences** rather than aircraft: Italy''s Aermacchi agreed to sell the rights to the MB-326.\n\n## Design\nThe Impala Mk I is an MB-326 trainer; the Mk II is its single-seat attack version, with a strengthened structure and two 30 mm **ADEN** cannon. The first aircraft arrived in crates from Italy; the rest were built entirely at Kempton Park, including the Viper engines. By the end the aircraft was South African throughout.\n\n## Operational career\nTwo hundred and seventy-six built. They made up the bulk of South African support aviation during the **Border War** in Angola and Namibia from 1975 to 1989. On 27 September 1985 an Impala Mk II shot down **two Angolan Mi-8 helicopters** with its cannon — one of the rare air victories by an armed trainer.\n\n## Place in history\nTwo hundred and seventy-six built. The Impala shows what an embargo produces: not deprivation but a forced national industry. South Africa would draw from it the **Cheetah**, a local Mirage III upgrade, and the Rooivalk. This catalogue holds three South African aircraft.',
    (SELECT id FROM countries WHERE code = 'ZAF'),
    '1964-01-01',
    '1966-05-11',
    '1967-01-01',
    890.0,
    1665.0,
    (SELECT id FROM manufacturer WHERE code = 'ATL'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Atlas Impala'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Atlas Impala'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Atlas Impala'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'Atlas Impala'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Atlas Impala'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Atlas Impala'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Atlas Impala'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Atlas Impala'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.67,
  wingspan          = 10.85,
  height            = 3.72,
  wing_area         = 19.35,
  empty_weight      = 2237,
  mtow              = 4211,
  service_ceiling   = 12000,
  climb_rate        = 32.5,
  g_limit_pos       = 8.0,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Viper 540',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 15.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1966,
  production_end    = 1991,
  units_built       = 276,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Impala Mk I** : biplace d''entraînement, dérivé de l''**Aermacchi MB-326**\n- **Impala Mk II** : monoplace d''attaque, dérivé du MB-326K, à deux canons de 30 mm\n- Premiers exemplaires livrés d''Italie, puis **fabrication intégrale** en Afrique du Sud\n- Engagé dans la **guerre de la frontière** en Angola et en Namibie, 1975-1989\n- Un Impala abat deux hélicoptères angolais en 1985 : rare victoire d''un avion d''école',
  variants_en       = E'- **Impala Mk I** : two-seat trainer, derived from the **Aermacchi MB-326**\n- **Impala Mk II** : single-seat attack version from the MB-326K, with two 30 mm cannon\n- First aircraft delivered from Italy, then **wholly manufactured** in South Africa\n- Used in the **Border War** in Angola and Namibia, 1975–1989\n- An Impala downed two Angolan helicopters in 1985: a rare victory for a trainer',

  -- Strate 4 : qualitatif
  nickname          = 'Impala',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Atlas_Impala',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Atlas_Impala',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Peterborough, Cambs UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Atlas Impala';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Atlas Impala';
