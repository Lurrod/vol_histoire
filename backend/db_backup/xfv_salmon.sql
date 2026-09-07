-- Lockheed XFV-1 Salmon
--
-- Photo : Lockheed L-081-40-01 XFV-1 (USN BuNo 138657, cn 081-1001) (4-9-2024).jpg
--   licence CC BY-SA 4.0 — ZLEA
--   https://commons.wikimedia.org/wiki/File%3ALockheed_L-081-40-01_XFV-1_%28USN_BuNo_138657%2C_cn_081-1001%29_%284-9-2024%29.jpg

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
    'Lockheed XFV',
    'Lockheed XFV',
    'Lockheed XFV-1 Salmon',
    'Lockheed XFV-1 Salmon',
    'Le tail-sitter qui n’a jamais osé décoller à la verticale',
    'The tail-sitter that never dared take off vertically',
    '/assets/airplanes/xfv-salmon.jpg',
    E'## Genèse\nLe XFV répond au même appel d''offres de 1950 que le **XFY Pogo**, avec la même formule et le même turbopropulseur Allison. Les deux programmes avancent en parallèle, chacun surveillant l''autre. Là où Convair adopte une aile delta et deux dérives, Lockheed choisit une aile droite et un empennage **cruciforme** à quatre plans identiques, chacun portant une roulette.\n\n## Conception\nLa difficulté n''est pas de faire voler l''appareil mais de le faire décoller. Le moteur XT40 tarde, et sa puissance disponible reste inférieure à ce qu''exige une montée verticale à pleine masse. Lockheed prend alors une décision qui décide de tout : équiper l''appareil d''un **train d''atterrissage temporaire**, encombrant et fixe, pour qu''il puisse au moins décoller horizontalement d''une piste et commencer les essais.\n\n## Carrière opérationnelle\nAucune. Trente-deux vols entre 1954 et 1955, tous commencés et terminés sur une piste. Le pilote Herman Salmon parvient à basculer l''appareil à la verticale **en altitude**, à s''y maintenir quelques secondes puis à repartir, mais jamais à décoller ni à se poser sur sa queue. Le XFY, lui, y était arrivé.\n\n## Place dans l''histoire\nDeux exemplaires, dont un seul volant. Le programme est annulé en juin 1955, un an avant celui du Pogo, sans avoir jamais accompli la manœuvre qui justifiait son existence. Il reste le plus abouti des tail-sitters à n''avoir rien prouvé du tout.',
    E'## Genesis\nThe XFV answered the same 1950 requirement as the **XFY Pogo**, with the same formula and the same Allison turboprop. The two programmes advanced in parallel, each watching the other. Where Convair chose a delta wing and two fins, Lockheed chose a straight wing and a **cruciform** tail of four identical surfaces, each carrying a castor.\n\n## Design\nThe difficulty was not flying the aircraft but getting it off the ground. The XT40 engine was late, and the power available stayed below what a vertical climb at full weight demanded. Lockheed then took the decision that settled everything: fit the aircraft with a **temporary undercarriage**, bulky and fixed, so that it could at least take off horizontally from a runway and begin testing.\n\n## Operational career\nNone. Thirty-two flights between 1954 and 1955, every one begun and ended on a runway. Pilot Herman Salmon managed to pitch the aircraft to the vertical **at altitude**, hold it there for a few seconds and fly away again, but never to take off or land on its tail. The XFY had done it.\n\n## Place in history\nTwo built, only one of them flying. The programme was cancelled in June 1955, a year before the Pogo''s, without ever performing the manoeuvre that justified its existence. It remains the most accomplished of the tail-sitters to have proved nothing at all.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1950-01-01',
    '1954-06-16',
    NULL,
    933.0,
    1000.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed XFV'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed XFV'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Lockheed XFV'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.23,
  wingspan          = 9.4,
  height            = 11.23,
  wing_area         = 22.85,
  empty_weight      = 5260,
  mtow              = 7360,
  service_ceiling   = 13000,
  climb_rate        = 54.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 380,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison XT40-A-14',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur à hélices contrarotatives',
  engine_type_en    = 'Contra-rotating turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1954,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XFV-1** : un exemplaire volant, un second jamais achevé\n- Surnommé **Salmon** d''après son pilote d''essai Herman « Fish » Salmon\n- N''a volé **qu''avec un train temporaire** ajouté pour décoller horizontalement\n- Trente-deux vols, quelques bascules à la verticale en altitude, jamais au sol\n- Empennage cruciforme à quatre dérives, chacune terminée par une roulette',
  variants_en       = E'- **XFV-1** : one flying aircraft, a second never completed\n- Nicknamed **Salmon** after its test pilot Herman ''Fish'' Salmon\n- Flew **only with a temporary undercarriage** added for horizontal take-off\n- Thirty-two flights, a few pitch-ups to the vertical at altitude, never off the ground\n- Cruciform tail with four fins, each ending in a castor',

  -- Strate 4 : qualitatif
  nickname          = 'Salmon',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_XFV',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_XFV',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'ZLEA',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Lockheed XFV';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed XFV';
