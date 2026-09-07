-- Aero Vodochody L-39 Albatros
--
-- Photo : US Navy 080921-N-4469F-004 Two L-39 Albatross aircraft painted in opposing color schemes fly in formation during the 50th Anniversary Naval Air Station Oceana Air Show.jpg
--   licence CC BY-SA 4.0 — Fahad Faisal
--   https://commons.wikimedia.org/wiki/File%3AAero_L-39_Albatros_Czech_BD.jpg

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
    'Aero L-39 Albatros',
    'Aero L-39 Albatros',
    'Aero Vodochody L-39 Albatros',
    'Aero Vodochody L-39 Albatros',
    'Avion d’entraînement à réaction le plus produit de l’histoire',
    'The most-produced jet trainer in history',
    '/assets/airplanes/l39-albatros.jpg',
    E'## Genèse\nEn 1964, le Pacte de Varsovie cherche un successeur au L-29 Delfín pour former tous ses pilotes de chasse. La Tchécoslovaquie, seul pays du bloc doté d''une industrie aéronautique autonome hors URSS, emporte le marché — et devient l''unique fournisseur d''entraîneurs de l''ensemble du bloc de l''Est.\n\n## Conception\nAile droite à faible allongement, réacteur double flux unique alimenté par des entrées d''air latérales hautes, tandem classique avec siège arrière surélevé. Le parti pris est la **robustesse avant la performance** : train résistant, entretien réduit, tolérance aux pistes sommaires et aux climats extrêmes, du désert syrien à la Sibérie.\n\n## Carrière opérationnelle\nPrès de **2 900 exemplaires** livrés à une trentaine de pays. La plupart des pilotes de chasse soviétiques, est-allemands, vietnamiens, cubains ou algériens de trois générations s''y sont formés. Les versions armées combattent en **Syrie** à partir de 2012, et de nombreuses cellules réformées volent aujourd''hui en collection privée ou comme plastrons d''entraînement contractuels.\n\n## Place dans l''histoire\nAucun autre avion d''entraînement à réaction n''a été produit en si grand nombre. L''Albatros est le pendant oriental du BAE Hawk, et le seul appareil de ce catalogue conçu dans un pays qui n''existe plus.',
    E'## Genesis\nIn 1964 the Warsaw Pact sought a successor to the L-29 Delfín to train all its fighter pilots. Czechoslovakia, the only country in the bloc with an autonomous aviation industry outside the USSR, won the contract — and became the sole trainer supplier for the entire Eastern bloc.\n\n## Design\nA straight low aspect ratio wing, a single turbofan fed by high side intakes, conventional tandem seating with a raised rear seat. The choice was **ruggedness over performance**: strong landing gear, minimal maintenance, tolerance of rough strips and extreme climates, from the Syrian desert to Siberia.\n\n## Operational career\nNearly **2,900 delivered** to some thirty countries. Most Soviet, East German, Vietnamese, Cuban and Algerian fighter pilots of three generations trained on it. The armed versions saw combat in **Syria** from 2012, and many retired airframes now fly in private collections or as contract aggressors.\n\n## Place in history\nNo other jet trainer has been produced in such numbers. The Albatros is the Eastern counterpart of the BAE Hawk, and the only aircraft in this catalogue designed in a country that no longer exists.',
    (SELECT id FROM countries WHERE code = 'CSK'),
    '1966-01-01',
    '1968-11-04',
    '1972-01-01',
    750.0,
    1750.0,
    (SELECT id FROM manufacturer WHERE code = 'AERO'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM armement WHERE name = 'R-3S')),
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM armement WHERE name = 'S-5'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.13,
  wingspan          = 9.46,
  height            = 4.77,
  wing_area         = 18.8,
  empty_weight      = 3455,
  mtow              = 5600,
  service_ceiling   = 11500,
  climb_rate        = 21,
  g_limit_pos       = 8.0,
  g_limit_neg       = -4.0,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko-Progress AI-25TL',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 16.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1971,
  production_end    = 1999,
  units_built       = 2900,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 30,
  variants          = E'- **L-39C** : entraîneur de base, version standard du Pacte de Varsovie\n- **L-39ZO / ZA** : versions armées à quatre points d''emport et canon ventral\n- **L-59 Super Albatros** : évolution à moteur plus puissant\n- **L-159 ALCA** : dérivé monoplace d''attaque légère, encore en service',
  variants_en       = E'- **L-39C** : basic trainer, the Warsaw Pact standard version\n- **L-39ZO / ZA** : armed versions with four hardpoints and a ventral gun\n- **L-59 Super Albatros** : evolution with a more powerful engine\n- **L-159 ALCA** : single-seat light attack derivative, still in service',

  -- Strate 4 : qualitatif
  nickname          = 'Albatros',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aero_L-39_Albatros',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aero_L-39_Albatros',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy photo',
  image_licence     = 'Public domain'
WHERE name = 'Aero L-39 Albatros';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aero L-39 Albatros';
