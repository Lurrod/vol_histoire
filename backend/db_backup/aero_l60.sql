-- Aero L-60A Brigadýr (K-60)
--
-- Photo : L60 1955.jpg
--   licence CC BY-SA 4.0 — Pysiekm
--   https://commons.wikimedia.org/wiki/File:L60_1955.jpg

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
    'Aero L-60 Brigadýr',
    'Aero L-60 Brigadýr',
    'Aero L-60A Brigadýr (K-60)',
    'Aero L-60A Brigadýr (K-60)',
    'Le successeur tchécoslovaque du Fieseler Storch, avion d''observation et de liaison de l''armée',
    'Czechoslovakia''s successor to the Fieseler Storch, an army observation and liaison aircraft',
    '/assets/airplanes/aero-l60-brigadyr.jpg',
    E'## Genèse\nAu sortir de la guerre, la Tchécoslovaquie produit sous licence le **Fieseler Fi 156 Storch**, devenu chez elle le **K-65 Čáp**. Pour le remplacer, et après l''échec de l''Aero Ae 50, le ministère de la Défense demande à **Aero** un appareil plus classique, dont la silhouette doit beaucoup au Storch. Le prototype XL-60, propulsé par un moteur Argus As 10C, vole le 24 décembre 1953 mais déçoit ; l''avion est entièrement redessiné, et un second prototype, doté du moteur à plat Praga Doris M 208-B, vole le 8 juin 1954.\n\n## Conception\nLe Brigadýr — le « brigadier » — est un monoplan à aile haute contreventée et train classique fixe, conçu pour le décollage court et pouvant emporter un pilote et trois passagers. Son six-cylindres à plat de 190 ch entraîne une hélice bipale en bois à pas variable ; l''appareil décolle en 240 m sur herbe et se pose en moins de 200 m. La version militaire **L-60A**, qui vole le 24 juin 1955, reçoit un empennage et une verrière arrière modifiés, et peut emporter une mitrailleuse **MG 15** de 7,92 mm tirée depuis l''arrière de la cabine, ainsi que deux bombes légères sous voilure.\n\n## Carrière opérationnelle\nL''armée de l''air tchécoslovaque reçoit une cinquantaine de L-60A sous la désignation **K-60** pour l''observation du champ de bataille et la liaison ; ils remplacent les K-65 à partir de 1958 et quittent le service en 1968. L''armée est-allemande en reçoit vingt en 1960 pour l''entraînement et la liaison, l''aviation bulgare en exploite sept de 1963 à 1983, et des exemplaires partent pour l''Égypte, Cuba, la Roumanie et la Yougoslavie. Le reste de la production sert à l''épandage agricole, au remorquage de planeurs et aux évacuations sanitaires.\n\n## Place dans l''histoire\nLorsque la production s''arrête en 1960, Aero a construit 273 Brigadýr, dont la version L-160 à empennage entièrement métallique. Faute de pièces pour leur moteur, beaucoup sont remotorisés au milieu des années 1970 avec le moteur en étoile Ivchenko AI-14R construit par PZL, sous le nom de **L-60S**. Dernier héritier direct du Storch, il incarne la transition entre l''avion d''observation de la Seconde Guerre mondiale et les utilitaires à décollage court de la guerre froide.',
    E'## Genesis\nAfter the war Czechoslovakia licence-built the **Fieseler Fi 156 Storch**, which it knew as the **K-65 Čáp**. To replace it, and after the failure of the Aero Ae 50, the Ministry of Defence asked **Aero** for a more conventional aircraft whose shape owed much to the Storch. The XL-60 prototype, powered by an Argus As 10C, flew on 24 December 1953 but disappointed; the aircraft was thoroughly redesigned, and a second prototype with the Praga Doris M 208-B flat engine flew on 8 June 1954.\n\n## Design\nThe Brigadýr — ''brigadier'' — is a strut-braced high-wing monoplane with fixed tailwheel landing gear, designed for short take-off and carrying a pilot and three passengers. Its 190 hp flat-six drives a two-blade wooden variable-pitch propeller; the aircraft takes off in 240 m on grass and lands in under 200 m. The military **L-60A**, first flown on 24 June 1955, received a modified tail and rear canopy and could carry a 7.92 mm **MG 15** machine gun firing from the rear of the cabin, along with two light bombs under the wings.\n\n## Operational career\nThe Czechoslovak Air Force received some fifty L-60As as the **K-60** for battlefield observation and liaison; they replaced the K-65 from 1958 and left service in 1968. The East German army received twenty in 1960 for training and liaison, the Bulgarian air arm flew seven from 1963 to 1983, and examples went to Egypt, Cuba, Romania and Yugoslavia. The rest of production served for crop spraying, glider towing and air ambulance work.\n\n## Place in history\nWhen production ended in 1960, Aero had built 273 Brigadýrs, including the L-160 with an all-metal tail. With spares for their engine running short, many were re-engined in the mid-1970s with the PZL-built Ivchenko AI-14R radial as the **L-60S**. The last direct heir of the Storch, it bridges the gap between the observation aircraft of the Second World War and the short take-off utility aircraft of the Cold War.',
    (SELECT id FROM countries WHERE code = 'CSK'),
    NULL,
    '1953-12-24',
    '1958-01-01',
    193,
    720,
    (SELECT id FROM manufacturer WHERE code = 'AERO'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-60 Brigadýr'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Aero L-60 Brigadýr'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.54,
  wingspan          = 13.96,
  height            = 2.72,
  wing_area         = 24.3,
  empty_weight      = 968,
  mtow              = 1560,
  service_ceiling   = 4200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Praga Doris M 208-B (190 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1960,
  units_built       = 273,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 8,
  variants          = E'- **XL-60** : prototype à moteur Argus As 10C, premier vol le 24 décembre 1953\n- **L-60A (K-60)** : version militaire d''observation et de liaison, mitrailleuse MG 15 à l''arrière de la cabine\n- **L-60B / L-60D / L-60E** : épandage agricole, remorquage de planeurs, ambulance aérienne\n- **L-160** : version à empennage entièrement métallique\n- **L-60S** : appareils remotorisés avec le moteur en étoile Ivchenko AI-14R construit par PZL',
  variants_en       = E'- **XL-60**: prototype with an Argus As 10C engine, first flight on 24 December 1953\n- **L-60A (K-60)**: military observation and liaison version, MG 15 machine gun at the rear of the cabin\n- **L-60B / L-60D / L-60E**: crop spraying, glider towing, air ambulance\n- **L-160**: version with an all-metal tail\n- **L-60S**: aircraft re-engined with the PZL-built Ivchenko AI-14R radial',

  -- Strate 4 : qualitatif
  nickname          = 'Brigadýr',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aero_L-60_Brigadyr',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aero_L-60_Brigadýr',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Pysiekm',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Aero L-60 Brigadýr';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aero L-60 Brigadýr';
