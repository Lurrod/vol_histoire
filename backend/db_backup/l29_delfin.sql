-- Aero L-29 Delfín
--
-- Photo : CF15 L-29 ZK-SSU 040415 03.jpg
--   licence CC BY-SA 3.0 — Oren Rozen
--   https://commons.wikimedia.org/wiki/File%3ACF15_L-29_ZK-SSU_040415_03.jpg

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
    'Aero L-29 Delfín',
    'Aero L-29 Delfín',
    'Aero L-29 Delfín',
    'Aero L-29 Delfín',
    'Avion-école standard de tout le pacte de Varsovie',
    'The standard training aircraft of the entire Warsaw Pact',
    '/assets/airplanes/l29-delfin.jpg',
    E'## Genèse\nAu début des années 1960, chaque armée du bloc de l''Est forme ses pilotes sur ce qu''elle a sous la main, souvent des MiG-15 biplaces usés. Moscou décide d''imposer un avion-école unique et organise un **concours** entre la Tchécoslovaquie, la Pologne et l''URSS. En 1961, à Monino, le L-29 tchécoslovaque bat le TS-11 Iskra polonais et le Yak-30 soviétique. Tout le pacte de Varsovie l''adopte — sauf la Pologne, qui gardera son Iskra par fierté nationale.\n\n## Conception\nLe cahier des charges tient en un mot : **robustesse**. Aile droite, empennage en T, entrées d''air hautes placées loin du sol, train renforcé — l''appareil doit décoller de terrains en herbe, de pistes en sable, être réparé par des mécaniciens peu formés et pardonner les fautes d''élèves débutants. Le réacteur M-701 est volontairement peu puissant et très simple. Le résultat est lent mais quasiment indestructible.\n\n## Carrière opérationnelle\nTrois mille six cent soixante-cinq exemplaires, exportés dans quinze pays au-delà du bloc : Égypte, Syrie, Irak, Ouganda, Nigeria, Indonésie. Des L-29 égyptiens et syriens ont volé en appui au sol lors des **guerres israélo-arabes**, et des L-29 nigérians pendant la guerre du Biafra — un avion-école devenu bombardier léger faute de mieux.\n\n## Place dans l''histoire\nIl a formé la quasi-totalité des pilotes de chasse du bloc de l''Est pendant vingt ans, comme le **T-33** l''a fait à l''Ouest, et il est le premier avion à réaction entièrement conçu et produit en Tchécoslovaquie. Son successeur, l''**Aero L-39 Albatros**, sera diffusé plus largement encore et vole toujours.',
    E'## Genesis\nIn the early 1960s each Eastern Bloc air force trained its pilots on whatever it had, often worn-out two-seat MiG-15s. Moscow decided to impose a single training aircraft and organised a **competition** between Czechoslovakia, Poland and the USSR. In 1961, at Monino, the Czechoslovak L-29 beat Poland''s TS-11 Iskra and the Soviet Yak-30. The whole Warsaw Pact adopted it — except Poland, which kept its Iskra out of national pride.\n\n## Design\nThe specification came down to one word: **ruggedness**. A straight wing, a T-tail, high intakes set well clear of the ground, reinforced gear — the aircraft had to operate from grass fields and sand strips, be repaired by lightly trained mechanics and forgive beginners'' mistakes. The M-701 engine was deliberately modest and very simple. The result is slow but very nearly indestructible.\n\n## Operational career\nThree thousand six hundred and sixty-five built, exported to fifteen countries beyond the bloc: Egypt, Syria, Iraq, Uganda, Nigeria, Indonesia. Egyptian and Syrian L-29s flew ground attack in the **Arab-Israeli wars**, and Nigerian ones during the Biafran war — a trainer turned light bomber for want of anything better.\n\n## Place in history\nIt trained almost every Eastern Bloc fighter pilot for twenty years, as the **T-33** did in the West, and it is the first jet aircraft designed and built entirely in Czechoslovakia. Its successor, the **Aero L-39 Albatros**, would spread wider still and is flying yet.',
    (SELECT id FROM countries WHERE code = 'CSK'),
    '1955-01-01',
    '1959-04-05',
    '1963-04-01',
    655.0,
    894.0,
    (SELECT id FROM manufacturer WHERE code = 'AERO'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín'), (SELECT id FROM armement WHERE name = 'S-5'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.81,
  wingspan          = 10.29,
  height            = 3.13,
  wing_area         = 19.8,
  empty_weight      = 2280,
  mtow              = 3540,
  service_ceiling   = 11000,
  climb_rate        = 14.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 350,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Motorlet M-701',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 8.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1974,
  units_built       = 3665,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 15,
  variants          = E'- **L-29 Delfín** : version d''entraînement de base, la très grande majorité des exemplaires\n- **L-29A Akrobat** : monoplace de voltige, produit à une trentaine d''exemplaires\n- **L-29R** : version de reconnaissance tactique et d''attaque légère\n- **Aero L-39 Albatros** : successeur direct, à turbofan et cellule entièrement nouvelle\n- Choisi en 1961 devant le **PZL TS-11 Iskra** polonais lors du concours du pacte de Varsovie',
  variants_en       = E'- **L-29 Delfín** : basic training version, the vast majority of aircraft built\n- **L-29A Akrobat** : single-seat aerobatic version, about thirty built\n- **L-29R** : tactical reconnaissance and light attack version\n- **Aero L-39 Albatros** : direct successor, with a turbofan and an all-new airframe\n- Chosen in 1961 over Poland''s **PZL TS-11 Iskra** in the Warsaw Pact competition',

  -- Strate 4 : qualitatif
  nickname          = 'Maya',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aero_L-29_Delfín',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aero_L-29_Delfín',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Oren Rozen',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Aero L-29 Delfín';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aero L-29 Delfín';
