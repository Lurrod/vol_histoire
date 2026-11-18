-- Zlín Z 26 Trenér
--
-- Photo : OK-MFX Zlin Z-126T (3570112315).jpg
--   licence CC BY 2.0 — Jerry Gunner from Lincoln, UK
--   https://commons.wikimedia.org/wiki/File:OK-MFX_Zlin_Z-126T_(3570112315).jpg

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
    'Zlín Z 26 Trenér',
    'Zlín Z-26 Trenér',
    'Zlín Z 26 Trenér',
    'Zlín Z-26 Trenér',
    'L''avion de début tchécoslovaque, décliné pendant trente ans de l''école militaire à la voltige de compétition',
    'The Czechoslovak primary trainer, developed over thirty years from military school to competition aerobatics',
    '/assets/airplanes/zlin-z26-trener.jpg',
    E'## Genèse\nAu lendemain de la guerre, les écoles de pilotage tchécoslovaques volent encore sur des **Bücker Jungmann** et **Bestmann** d''origine allemande. Pour les remplacer, l''usine de Zlín, à Otrokovice, conçoit un avion d''entraînement de base biplace, le **Z-26 Trenér**, c''est-à-dire « l''entraîneur ». Le prototype vole au début de 1947, se montre supérieur au **Praga E-112** concurrent et remporte la compétition ; la production démarre en 1948.\n\n## Conception\nLe Z-26 est un monoplan à aile basse de construction mixte : aile en bois, fuselage en tubes d''acier soudés, et un petit moteur **Walter Minor 4-III** à quatre cylindres. L''élève et l''instructeur sont assis en tandem. La formule évolue ensuite par petites étapes : le **Z-126** de 1953 reçoit une aile métallique, le **Z-226** un Walter Minor 6-III à six cylindres, et le **Z-326** de 1959 un train d''atterrissage escamotable à commande électrique. La dernière version, le **Z-726**, a une envergure réduite et un moteur Avia M 137 de 180 ch.\n\n## Carrière opérationnelle\nSous les désignations militaires C-105, C-205 et C-305, cette dernière équipée pour le vol de nuit, le Trenér forme les élèves pilotes de l''armée de l''air tchécoslovaque. Il part aussi à l''étranger : une soixantaine à Cuba dans les années 1960, vingt en Allemagne de l''Est, repris par la Luftwaffe à la réunification, quarante en Irak, d''autres au Yémen, en Autriche et au Mozambique, où sept Z-326 sont encore en service vers 2010. Les versions monoplaces **Akrobat** remportent plusieurs titres de voltige dans les années 1960 et séduisent de nombreux pilotes privés.\n\n## Place dans l''histoire\nProduite de 1948 à 1977, dont 163 Z-26 de la première série, la famille Trenér a tiré d''une même cellule un avion d''école militaire, un remorqueur de planeurs et un monoplace de compétition. Elle a donné aux forces aériennes du bloc de l''Est et à leurs clients un avion de début simple et durable, et a valu à la marque Zlín une solide réputation dans le monde de la voltige aérienne.',
    E'## Genesis\nIn the years after the war, Czechoslovak flying schools were still using German-designed **Bücker Jungmann** and **Bestmann** trainers. To replace them, the Zlín works at Otrokovice designed a two-seat basic trainer, the **Z-26 Trenér**, meaning simply ''trainer''. The prototype flew in early 1947, proved superior to the competing **Praga E-112** and won the competition; production began in 1948.\n\n## Design\nThe Z-26 was a low-wing monoplane of mixed construction: a wooden wing, a welded steel tube fuselage and a small four-cylinder **Walter Minor 4-III** engine. Pupil and instructor sat in tandem. The formula then evolved in small steps: the 1953 **Z-126** received an all-metal wing, the **Z-226** a six-cylinder Walter Minor 6-III, and the 1959 **Z-326** an electrically retractable undercarriage. The final version, the **Z-726**, had a reduced span and a 180 hp Avia M 137 engine.\n\n## Operational career\nUnder the military designations C-105, C-205 and C-305, the last equipped for night flying, the Trenér trained the student pilots of the Czechoslovak Air Force. It was also exported: some sixty to Cuba in the 1960s, twenty to East Germany, taken over by the Luftwaffe at reunification, forty to Iraq, and others to Yemen, Austria and Mozambique, where seven Z-326s were still in service around 2010. The single-seat **Akrobat** versions won several aerobatic titles in the 1960s and appealed to many private pilots.\n\n## Place in history\nBuilt from 1948 to 1977, including 163 first-series Z-26s, the Trenér family drew a military school aircraft, a glider tug and a single-seat competition aircraft from the same airframe. It gave the air forces of the Eastern bloc and their customers a simple, durable primary trainer, and earned the Zlín name a solid reputation in the world of aerobatics.',
    (SELECT id FROM countries WHERE code = 'CSK'),
    '1946-01-01',
    '1947-01-01',
    NULL,
    236,
    440,
    (SELECT id FROM manufacturer WHERE code = 'ZLIN'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Zlín Z 26 Trenér'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.98,
  wingspan          = 9.88,
  height            = 2.06,
  wing_area         = 14.89,
  empty_weight      = 700,
  mtow              = 1000,
  service_ceiling   = 4500,
  climb_rate        = 5.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Avia M 137AZ (180 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1948,
  production_end    = 1977,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 8,
  variants          = E'- **Z-26** : version d''origine, aile en bois et moteur Walter Minor 4-III, 163 exemplaires\n- **Z-126 (C-105)** : version de 1953 à aile entièrement métallique\n- **Z-226 (C-205)** : moteur Walter Minor 6-III à six cylindres ; déclinée en monoplace de voltige Z-226A Akrobat et en remorqueur de planeurs Z-226B\n- **Z-326 (C-305)** : version de 1959 à train escamotable électrique ; la C-305 militaire est équipée pour le vol de nuit\n- **Z-526 et Z-726** : dernières versions ; le Z-726, à envergure et fuselage réduits, ferme la production dans les années 1970 (caractéristiques de cette fiche)',
  variants_en       = E'- **Z-26**: original version, wooden wing and Walter Minor 4-III engine, 163 built\n- **Z-126 (C-105)**: 1953 version with an all-metal wing\n- **Z-226 (C-205)**: six-cylinder Walter Minor 6-III engine; developed into the Z-226A Akrobat single-seat aerobatic aircraft and the Z-226B glider tug\n- **Z-326 (C-305)**: 1959 version with electrically retractable undercarriage; the military C-305 was equipped for night flying\n- **Z-526 and Z-726**: final versions; the Z-726, with shortened wings and fuselage, ended production in the 1970s (figures given in this entry)',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Zlín_Z_26_Trener',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Zlín_Z-26',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jerry Gunner from Lincoln, UK',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Zlín Z 26 Trenér';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Zlín Z 26 Trenér';
