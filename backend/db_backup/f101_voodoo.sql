-- McDonnell F-101 Voodoo
--
-- Photo : F-101B New York ANG in flight 1978.jpeg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3AF-101B_New_York_ANG_in_flight_1978.jpeg

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
    'F-101 Voodoo',
    'F-101 Voodoo',
    'McDonnell F-101 Voodoo',
    'McDonnell F-101 Voodoo',
    'Intercepteur et avion de reconnaissance de la série des Century',
    'Interceptor and reconnaissance aircraft of the Century series',
    '/assets/airplanes/f101-voodoo.jpg',
    E'## Genèse\nLe Voodoo naît d''un besoin abandonné : escorter les bombardiers du Strategic Air Command jusqu''en URSS. Quand les ravitailleurs rendent l''escorte inutile, l''appareil est déjà conçu. L''US Air Force le reverse à deux métiers qu''il n''avait pas prévus — la reconnaissance et l''interception.\n\n## Conception\nDeux J57 accolés, un empennage en T haut perché, une aile fine à forte flèche. Cette configuration lui vaut un défaut redouté : le **pitch-up**, une cabrée incontrôlable à forte incidence, l''empennage sortant du flux de l''aile. Plusieurs appareils sont perdus avant qu''un avertisseur mécanique ne soit installé.\n\n## Carrière opérationnelle\nLe **RF-101C** est l''appareil de reconnaissance le plus engagé du début de la guerre du Vietnam, et c''est un Voodoo qui rapporte les clichés confirmant le retrait des missiles soviétiques de Cuba en 1962. Le F-101B tient l''alerte de défense aérienne nord-américaine jusqu''en 1982 ; le Canada en conserve jusqu''en 1984.\n\n## Place dans l''histoire\nLe Voodoo illustre un cas fréquent de la guerre froide : un avion dont le rôle disparaît avant sa mise en service et qui trouve sa carrière ailleurs. Le **F-4 Phantom II**, également de McDonnell, le remplacera dans les trois métiers à la fois.',
    E'## Genesis\nThe Voodoo was born of an abandoned requirement: escorting Strategic Air Command bombers all the way to the USSR. By the time tankers made escort unnecessary, the aircraft was already designed. The US Air Force redirected it to two roles it had never been meant for — reconnaissance and interception.\n\n## Design\nTwo J57s side by side, a high T-tail, a thin highly swept wing. That configuration gave it a dreaded flaw: **pitch-up**, an uncontrollable nose-rise at high angle of attack as the tailplane left the wing’s airflow. Several aircraft were lost before a mechanical warning device was fitted.\n\n## Operational career\nThe **RF-101C** was the most heavily committed reconnaissance aircraft of the early Vietnam War, and it was a Voodoo that brought back the photographs confirming the withdrawal of Soviet missiles from Cuba in 1962. The F-101B stood North American air defence alert until 1982; Canada kept its until 1984.\n\n## Place in history\nThe Voodoo illustrates a common Cold War case: an aircraft whose role vanished before it entered service and which found its career elsewhere. The **F-4 Phantom II**, also from McDonnell, would replace it in all three roles at once.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1946-01-01',
    '1954-09-29',
    '1957-05-01',
    1965.0,
    2450.0,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM armement WHERE name = 'M39')),
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM armement WHERE name = 'AIM-4 Falcon')),
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM armement WHERE name = 'AIR-2 Genie'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-101 Voodoo'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.55,
  wingspan          = 12.09,
  height            = 5.49,
  wing_area         = 34.2,
  empty_weight      = 12925,
  mtow              = 23770,
  service_ceiling   = 17800,
  climb_rate        = 254,
  g_limit_pos       = 6.33,
  g_limit_neg       = NULL,
  combat_radius     = 1200,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J57-P-55',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 46.7,
  thrust_wet        = 74.7,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1961,
  units_built       = 807,
  unit_cost_usd     = 1754000,
  unit_cost_year    = 1960,
  operators_count   = 2,
  variants          = E'- **F-101A / C** : chasseur-bombardier monoplace du Tactical Air Command\n- **RF-101C** : version de reconnaissance photographique, la plus employée au combat\n- **F-101B** : intercepteur biplace de la défense aérienne, roquette nucléaire Genie\n- **CF-101** : version canadienne, en service jusqu''en 1984',
  variants_en       = E'- **F-101A / C** : single-seat fighter-bomber of Tactical Air Command\n- **RF-101C** : photographic reconnaissance version, the most used in combat\n- **F-101B** : two-seat air defence interceptor with the nuclear Genie rocket\n- **CF-101** : Canadian version, in service until 1984',

  -- Strate 4 : qualitatif
  nickname          = 'One-Oh-Wonder',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_F-101_Voodoo',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_F-101_Voodoo',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'F-101 Voodoo';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-101 Voodoo';
