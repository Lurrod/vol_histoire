-- General Dynamics F-16XL
--
-- Photo : F-16XL 75-0747 refuels in flight (EC96-43548-12).jpg
--   licence Public domain — NASA/Carla Thomas
--   https://commons.wikimedia.org/wiki/File%3AF-16XL_75-0747_refuels_in_flight_%28EC96-43548-12%29.jpg

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
    'F-16XL',
    'F-16XL',
    'General Dynamics F-16XL',
    'General Dynamics F-16XL',
    'Le F-16 à aile delta, deux fois plus d’emport, battu par le F-15E',
    'The delta-winged F-16, twice the load, beaten by the F-15E',
    '/assets/airplanes/f16xl.jpg',
    E'## Genèse\nLe F-16 est un excellent chasseur et un médiocre bombardier : son aile est trop petite pour emporter beaucoup et son rayon d''action trop court. General Dynamics propose en 1980 de corriger les deux d''un seul geste, en remplaçant la voilure par une **aile delta à double flèche** deux fois plus grande.\n\n## Conception\nLe gain est spectaculaire : surface portante augmentée de cent vingt pour cent, fuselage allongé d''un mètre quarante, **vingt-sept points d''emport** au lieu de neuf, et un rayon d''action supérieur de moitié à charge égale. L''aile delta réduit aussi la traînée supersonique, si bien que le F-16XL vole plus vite et plus loin **tout en emportant davantage** — un cas rare où l''on ne perd rien.\n\n## Carrière opérationnelle\nAucune. Deux exemplaires, plus de quatre cents vols. En 1984, l''Air Force doit choisir un bombardier tactique à long rayon d''action : elle prend le **F-15E Strike Eagle**, biplace et bimoteur, plus cher mais plus lourd et déjà pourvu du radar adéquat. Le F-16XL est remisé.\n\n## Place dans l''histoire\nDeux exemplaires, aucun de série. Les deux appareils sont tirés de leur hangar en 1988 par la **NASA**, qui les emploie onze ans à étudier l''écoulement laminaire sur aile delta à vitesse supersonique — recherches destinées à un successeur du Concorde qui n''a jamais vu le jour. Ils dorment aujourd''hui à Edwards, en réserve.',
    E'## Genesis\nThe F-16 is an excellent fighter and a mediocre bomber: its wing is too small to carry much and its range too short. In 1980 General Dynamics proposed to fix both at a stroke by replacing the wing with a **cranked-arrow delta** twice the size.\n\n## Design\nThe gain is spectacular: lifting area up by a hundred and twenty per cent, fuselage stretched by one metre forty, **twenty-seven hardpoints** instead of nine, and half again the range at equal load. The delta also cuts supersonic drag, so the F-16XL flies faster and further **while carrying more** — a rare case where nothing is given up.\n\n## Operational career\nNone. Two aircraft, more than four hundred flights. In 1984 the Air Force had to choose a long-range tactical bomber: it took the **F-15E Strike Eagle**, two-seat and twin-engined, more expensive but heavier and already fitted with the right radar. The F-16XL was shelved.\n\n## Place in history\nTwo built, none in production. Both were pulled out of storage in 1988 by **NASA**, which used them for eleven years to study laminar flow over a delta wing at supersonic speed — research aimed at a Concorde successor that never appeared. They sleep today at Edwards, in reserve.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1980-01-01',
    '1982-07-03',
    NULL,
    2124.0,
    4600.0,
    (SELECT id FROM manufacturer WHERE code = 'GD'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16XL'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'F-16XL'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16XL'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-16XL'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-16XL'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-16XL'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16XL'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-16XL'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-16XL'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.51,
  wingspan          = 10.44,
  height            = 5.36,
  wing_area         = 59.0,
  empty_weight      = 9980,
  mtow              = 21800,
  service_ceiling   = 15240,
  climb_rate        = NULL,
  g_limit_pos       = 9.0,
  g_limit_neg       = NULL,
  combat_radius     = 1200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F110-GE-129',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 76.3,
  thrust_wet        = 128.9,

  -- Strate 3 : production & service
  production_start  = 1980,
  production_end    = 1982,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **F-16XL-1 et XL-2** : deux cellules de F-16 de série profondément remaniées\n- Aile **delta à double flèche** de 120 % plus grande, fuselage allongé de 1,40 m\n- **Vingt-sept points d''emport** contre neuf sur un F-16 classique\n- Perd la compétition **Enhanced Tactical Fighter** face au **F-15E** en 1984\n- Repris par la **NASA** de 1988 à 1999 pour l''étude de l''écoulement laminaire supersonique',
  variants_en       = E'- **F-16XL-1 and XL-2** : two production F-16 airframes deeply rebuilt\n- **Cranked-arrow delta** wing 120% larger, fuselage stretched by 1.40 m\n- **Twenty-seven hardpoints** against nine on a standard F-16\n- Lost the **Enhanced Tactical Fighter** competition to the **F-15E** in 1984\n- Taken over by **NASA** from 1988 to 1999 to study supersonic laminar flow',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/General_Dynamics_F-16XL',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/General_Dynamics_F-16XL',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA/Carla Thomas',
  image_licence     = 'Public domain'
WHERE name = 'F-16XL';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-16XL';
