-- Convair F-106 Delta Dart
--
-- Photo : F-106A Chase Dart.JPEG
--   licence Public domain — Staff Sgt. John K. McDowell
--   https://commons.wikimedia.org/wiki/File%3AF-106A_Chase_Dart.JPEG

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
    'F-106 Delta Dart',
    'F-106 Delta Dart',
    'Convair F-106 Delta Dart',
    'Convair F-106 Delta Dart',
    'Intercepteur ultime de la défense aérienne américaine',
    'The ultimate US air defence interceptor',
    '/assets/airplanes/f106-delta-dart.jpg',
    E'## Genèse\nLe F-106 devait s''appeler F-102B : ce n''est au départ qu''une version améliorée du Delta Dagger. Les modifications sont si profondes — moteur, radar, entrées d''air, fuselage — qu''il reçoit une désignation propre. Il sera le **dernier intercepteur pur** de l''US Air Force.\n\n## Conception\nEntrées d''air reculées à mi-fuselage, réacteur J75 nettement plus puissant, système de conduite de tir **MA-1** entièrement intégré au réseau SAGE : au besoin, le sol pouvait piloter l''avion jusqu''à l''interception sans intervention du pilote. L''armement principal reste en soute, dont la roquette nucléaire non guidée **AIR-2 Genie**, conçue pour détruire une formation entière de bombardiers.\n\n## Carrière opérationnelle\nAucun combat en trente ans de service : sa mission, dissuader et intercepter au-dessus du Grand Nord, n''a jamais eu à être exécutée. Le 2 février 1970, un F-106 abandonné en vrille par son pilote se rétablit seul et se pose sur ses ventre dans un champ du Montana — l''appareil, surnommé le **Cornfield Bomber**, est aujourd''hui au musée.\n\n## Place dans l''histoire\nRetiré en 1988, il n''a jamais été remplacé dans son rôle : la défense aérienne du territoire est passée à des chasseurs polyvalents, F-15 puis F-16. Le F-106 clôt l''ère de l''intercepteur spécialisé occidental.',
    E'## Genesis\nThe F-106 was to be called F-102B: it began as no more than an improved Delta Dagger. The changes ran so deep — engine, radar, intakes, fuselage — that it received its own designation. It would be the US Air Force’s **last pure interceptor**.\n\n## Design\nIntakes moved back to mid-fuselage, a far more powerful J75 engine, and an **MA-1** fire control system fully integrated into the SAGE network: if needed, the ground could fly the aircraft to the intercept without pilot input. Its main armament stayed internal, including the unguided nuclear **AIR-2 Genie** rocket, designed to destroy an entire bomber formation.\n\n## Operational career\nNo combat in thirty years of service: its mission — deterring and intercepting over the far north — never had to be carried out. On 2 February 1970 an F-106 abandoned in a spin recovered by itself and belly-landed in a Montana field; the aircraft, nicknamed the **Cornfield Bomber**, is now in a museum.\n\n## Place in history\nRetired in 1988, it was never replaced in its role: homeland air defence passed to multirole fighters, the F-15 and then the F-16. The F-106 closed the era of the Western specialised interceptor.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1955-01-01',
    '1956-12-26',
    '1959-06-01',
    2455.0,
    4300.0,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique')),
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM armement WHERE name = 'AIM-4 Falcon')),
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM armement WHERE name = 'AIR-2 Genie')),
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM armement WHERE name = 'M61 Vulcan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 21.55,
  wingspan          = 11.67,
  height            = 6.18,
  wing_area         = 64.8,
  empty_weight      = 11077,
  mtow              = 17350,
  service_ceiling   = 17000,
  climb_rate        = 152,
  g_limit_pos       = 7.33,
  g_limit_neg       = NULL,
  combat_radius     = 926,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J75-P-17',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 76.5,
  thrust_wet        = 109.0,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1961,
  units_built       = 342,
  unit_cost_usd     = 4700000,
  unit_cost_year    = 1960,
  operators_count   = 1,
  variants          = E'- **F-106A** : monoplace de série\n- **F-106B** : biplace de conversion, pleinement opérationnel\n- **QF-106** : cellules converties en drones-cibles après retrait',
  variants_en       = E'- **F-106A** : single-seat production version\n- **F-106B** : two-seat conversion trainer, fully combat-capable\n- **QF-106** : airframes converted into target drones after retirement',

  -- Strate 4 : qualitatif
  nickname          = 'The Six',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_F-106_Delta_Dart',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_F-106_Delta_Dart',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. John K. McDowell',
  image_licence     = 'Public domain'
WHERE name = 'F-106 Delta Dart';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-106 Delta Dart';
