-- PZL-Mielec TS-11 Iskra
--
-- Photo : PZL TS-11 Iskrai (cropped).jpg
--   licence CC BY-SA 4.0 — Leafnode , original by Lukas skywalker
--   https://commons.wikimedia.org/wiki/File%3APZL_TS-11_Iskrai_%28cropped%29.jpg

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
    'PZL TS-11 Iskra',
    'PZL TS-11 Iskra',
    'PZL-Mielec TS-11 Iskra',
    'PZL-Mielec TS-11 Iskra',
    'Entraîneur polonais qui a tenu tête au choix soviétique',
    'Polish trainer that stood up to the Soviet choice',
    '/assets/airplanes/ts11-iskra.jpg',
    E'## Genèse\nEn 1961, le Pacte de Varsovie organise un concours pour doter tous ses membres d''un entraîneur à réaction commun. Le TS-11 polonais affronte le **L-29 Delfín** tchécoslovaque. Le L-29 l''emporte — mais la Pologne refuse le verdict et produit son Iskra pour ses propres besoins, seule dérogation du bloc à la standardisation soviétique.\n\n## Conception\nAile droite, entrées d''air latérales, réacteur **SO-3 de conception polonaise** — un cas rare dans le bloc de l''Est, où la motorisation venait presque toujours d''URSS. Les points d''emport permettent l''entraînement au tir réel, ce dont l''Iskra tire l''essentiel de sa longévité.\n\n## Carrière opérationnelle\nQuatre cent vingt-quatre exemplaires, en service polonais pendant **cinquante-cinq ans**, jusqu''en 2020. Tous les pilotes de chasse polonais, y compris ceux qui volent aujourd''hui sur F-16, y ont été formés. L''**Inde** en a acheté 76, retirés en 2004.\n\n## Place dans l''histoire\nL''Iskra est un objet politique autant qu''industriel : la démonstration qu''un pays du Pacte de Varsovie pouvait concevoir, motoriser et produire seul un avion militaire, contre l''avis de Moscou. Il a volé plus longtemps que le concurrent qui l''avait battu.',
    E'## Genesis\nIn 1961 the Warsaw Pact ran a competition to give all its members a common jet trainer. Poland’s TS-11 faced Czechoslovakia’s **L-29 Delfín**. The L-29 won — but Poland rejected the verdict and built its Iskra for its own needs, the bloc’s only departure from Soviet standardisation.\n\n## Design\nA straight wing, side intakes, and a **Polish-designed SO-3 engine** — a rare case in the Eastern bloc, where powerplants almost always came from the USSR. Hardpoints allow live weapons training, from which the Iskra drew most of its longevity.\n\n## Operational career\nFour hundred and twenty-four built, in Polish service for **fifty-five years**, until 2020. Every Polish fighter pilot, including those flying F-16s today, trained on it. **India** bought 76, retired in 2004.\n\n## Place in history\nThe Iskra is a political object as much as an industrial one: proof that a Warsaw Pact country could design, power and build a military aircraft alone, against Moscow’s advice. It flew longer than the competitor that had beaten it.',
    (SELECT id FROM countries WHERE code = 'POL'),
    '1957-01-01',
    '1960-02-05',
    '1963-03-01',
    720.0,
    1250.0,
    (SELECT id FROM manufacturer WHERE code = 'PZL'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'), (SELECT id FROM armement WHERE name = 'NR-23')),
((SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.15,
  wingspan          = 10.06,
  height            = 3.5,
  wing_area         = 17.5,
  empty_weight      = 2560,
  mtow              = 3840,
  service_ceiling   = 11000,
  climb_rate        = 15,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'PZL SO-3W',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 10.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1987,
  units_built       = 424,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **TS-11 Iskra bis** : versions successives à armement et points d''emport\n- **TS-11R Iskra** : version de reconnaissance photographique\n- **Iskra 100** : version d''exportation livrée à l''**Inde**, 76 exemplaires\n- Monture de la patrouille acrobatique polonaise **Biało-Czerwone Iskry**',
  variants_en       = E'- **TS-11 Iskra bis** : successive versions with armament and hardpoints\n- **TS-11R Iskra** : photographic reconnaissance version\n- **Iskra 100** : export version delivered to **India**, 76 aircraft\n- Mount of the Polish display team **Biało-Czerwone Iskry**',

  -- Strate 4 : qualitatif
  nickname          = 'Iskra',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/PZL_TS-11_Iskra',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/PZL_TS-11_Iskra',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Leafnode , original by Lukas skywalker',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'PZL TS-11 Iskra';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'PZL TS-11 Iskra';
