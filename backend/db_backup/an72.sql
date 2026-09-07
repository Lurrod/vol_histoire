-- Antonov An-72 / An-74 (Coaler)
--
-- Photo : 949 Antonov An.72 Russian Airforce (7382507234).jpg
--   licence CC BY-SA 3.0 — Aeroprints.com
--   https://commons.wikimedia.org/wiki/File%3A949_Antonov_An.72_Russian_Airforce_%287382507234%29.jpg

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
    'Antonov An-72',
    'Antonov An-72',
    'Antonov An-72 / An-74 (Coaler)',
    'Antonov An-72 / An-74 (Coaler)',
    'Ses réacteurs soufflent sur l’aile : décollage en six cents mètres',
    'Its engines blow over the wing: take-off in six hundred metres',
    '/assets/airplanes/an72.jpg',
    E'## Genèse\nL''URSS a besoin, au début des années 1970, d''un remplaçant à l''**An-26** qui puisse se poser sur les pistes de l''Arctique et de l''Asie centrale. La contrainte est double : la charge d''un bimoteur à réaction, mais les performances au décollage d''un turbopropulseur. Antonov choisit une solution aérodynamique connue et rarement appliquée.\n\n## Conception\nLes deux réacteurs **D-36** sont montés **au-dessus et en avant de l''aile**, de sorte que leur souffle passe sur l''extrados et sur les volets déployés : c''est l''**effet Coandă**, qui augmente fortement la portance à basse vitesse. L''appareil décolle en six cents mètres avec dix tonnes. La même idée avait été essayée sur le **YC-14** américain, qui n''a jamais été produit.\n\n## Carrière opérationnelle\nEnviron deux cents exemplaires, vingt pays. La version **An-74** arctique dessert les stations polaires soviétiques puis russes ; d''autres servent en Angola, au Soudan, en Libye, au Kazakhstan. Un An-72 a évacué les scientifiques d''une station dérivante en perdition en 2004.\n\n## Place dans l''histoire\nDeux cents exemplaires. L''An-72 est le seul appareil de série au monde à exploiter l''effet Coandă sur l''aile — le Boeing **YC-14** et le McDonnell Douglas YC-15 qui l''avaient tenté sont restés prototypes. Antonov, bureau de Kiev, est devenu ukrainien en 1991 : ce catalogue lui compte quatre appareils.',
    E'## Genesis\nIn the early 1970s the USSR needed a replacement for the **An-26** able to work from Arctic and Central Asian strips. The constraint was twofold: the payload of a twin jet with the take-off performance of a turboprop. Antonov chose a known and rarely applied aerodynamic solution.\n\n## Design\nThe two **D-36** engines are mounted **above and ahead of the wing**, so their exhaust passes over the upper surface and the extended flaps: this is the **Coandă effect**, which sharply increases lift at low speed. The aircraft takes off in six hundred metres with ten tonnes. The same idea had been tried on the American **YC-14**, which was never built.\n\n## Operational career\nSome two hundred built, twenty countries. The Arctic **An-74** version serves Soviet and then Russian polar stations; others fly in Angola, Sudan, Libya and Kazakhstan. An An-72 evacuated the scientists of a foundering drift station in 2004.\n\n## Place in history\nTwo hundred built. The An-72 is the only production aircraft in the world exploiting the Coandă effect over the wing — the Boeing **YC-14** and McDonnell Douglas YC-15 that tried it stayed prototypes. Antonov, a Kyiv bureau, became Ukrainian in 1991: this catalogue holds four of its aircraft.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1972-01-01',
    '1977-08-31',
    '1986-01-01',
    700.0,
    4325.0,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-72'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-72'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-72'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-72'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-72'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 28.07,
  wingspan          = 31.89,
  height            = 8.65,
  wing_area         = 98.62,
  empty_weight      = 19050,
  mtow              = 34500,
  service_ceiling   = 10100,
  climb_rate        = 17.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1300,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Lotarev D-36',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 63.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1979,
  production_end    = NULL,
  units_built       = 200,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 20,
  variants          = E'- **An-72** : version de transport tactique d''origine\n- **An-74** : version **arctique**, à skis, radar météo et équipement de dégivrage renforcé\n- **An-71** : version de guet aérien à radôme sur la dérive, trois prototypes\n- Réacteurs montés **au-dessus de l''aile** : le souffle sur l''extrados augmente la portance\n- Surnommé *Cheburashka* en russe, d''après un personnage de dessin animé aux grandes oreilles',
  variants_en       = E'- **An-72** : original tactical transport version\n- **An-74** : **Arctic** version, with skis, weather radar and enhanced de-icing\n- **An-71** : airborne early warning version with a fin-mounted radome, three prototypes\n- Engines mounted **above the wing**: the exhaust over the upper surface increases lift\n- Nicknamed *Cheburashka* in Russian, after a big-eared cartoon character',

  -- Strate 4 : qualitatif
  nickname          = 'Coaler',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-72',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-72',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Aeroprints.com',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Antonov An-72';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-72';
