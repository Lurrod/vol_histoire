-- Convair B-58 Hustler
--
-- Photo : Convair B-58 Hustler in flight without weapons-fuel pod.jpg
--   licence Public domain — United States Air Force
--   https://commons.wikimedia.org/wiki/File%3AConvair_B-58_Hustler_in_flight_without_weapons-fuel_pod.jpg

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
    'B-58 Hustler',
    'B-58 Hustler',
    'Convair B-58 Hustler',
    'Convair B-58 Hustler',
    'Premier bombardier supersonique opérationnel au monde',
    'The world’s first operational supersonic bomber',
    '/assets/airplanes/b58-hustler.jpg',
    E'## Genèse\nÀ la fin des années 1940, la doctrine américaine parie sur la vitesse : un bombardier assez rapide traverserait les défenses soviétiques avant qu''elles ne réagissent. Convair propose un delta à quatre réacteurs capable de **Mach 2 en croisière**, deux fois la vitesse du B-52 qui entre en service au même moment.\n\n## Conception\nLe fuselage est trop fin pour loger une soute : l''arme nucléaire et une partie du carburant voyagent dans une **nacelle ventrale largable**, solution unique dans l''histoire du bombardement. Structure en nid d''abeille collé, alliages résistants à l''échauffement cinétique, trois membres d''équipage en tandem dans des capsules d''éjection individuelles pressurisées.\n\n## Carrière opérationnelle\nLe Hustler bat une vingtaine de records de vitesse et de distance entre 1961 et 1963. Mais l''arrivée des missiles sol-air à haute altitude — la même menace qui abat un U-2 en 1960 — ruine sa raison d''être : voler vite et haut n''est plus une protection. Sa conversion au vol à basse altitude, pour laquelle il n''a pas été conçu, use les cellules.\n\n## Place dans l''histoire\nRetiré dès **1970**, après dix ans seulement, avec un coût d''exploitation trois fois supérieur à celui du B-52 — qui, lui, vole toujours. Le B-58 est le contre-exemple canonique : la performance pure ne survit pas à un changement de menace.',
    E'## Genesis\nIn the late 1940s American doctrine bet on speed: a bomber fast enough would cross Soviet defences before they could react. Convair proposed a four-engine delta capable of **Mach 2 in cruise**, twice the speed of the B-52 entering service at the same time.\n\n## Design\nThe fuselage was too slim for a bomb bay: the nuclear weapon and part of the fuel travelled in a **jettisonable ventral pod**, a solution unique in the history of bombing. Bonded honeycomb structure, alloys resistant to kinetic heating, three crew in tandem in individual pressurised escape capsules.\n\n## Operational career\nThe Hustler set some twenty speed and distance records between 1961 and 1963. But the arrival of high-altitude surface-to-air missiles — the same threat that downed a U-2 in 1960 — destroyed its rationale: flying fast and high was no longer protection. Converting it to low-level flight, for which it was never designed, wore the airframes out.\n\n## Place in history\nRetired as early as **1970** after only ten years, with operating costs three times those of the B-52 — which is still flying. The B-58 is the canonical counter-example: raw performance does not survive a change of threat.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1949-01-01',
    '1956-11-11',
    '1960-03-15',
    2128.0,
    7590.0,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM tech WHERE name = 'Matériaux résistants à la chaleur')),
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM armement WHERE name = 'B43')),
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM armement WHERE name = 'B61'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 29.49,
  wingspan          = 17.32,
  height            = 8.89,
  wing_area         = 143.3,
  empty_weight      = 25200,
  mtow              = 80240,
  service_ceiling   = 19300,
  climb_rate        = 88,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3220,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J79-GE-5B',
  engine_count      = 4,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 44.5,
  thrust_wet        = 69.4,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1962,
  units_built       = 116,
  unit_cost_usd     = 12440000,
  unit_cost_year    = 1960,
  operators_count   = 1,
  variants          = E'- **B-58A** : version de série\n- **TB-58A** : version d''entraînement\n- **Nacelle MB-1C** : conteneur ventral largable réunissant carburant et arme nucléaire\n- **Nacelle TCP** : version à deux étages, l''étage supérieur seul étant largué',
  variants_en       = E'- **B-58A** : production version\n- **TB-58A** : training version\n- **MB-1C pod** : jettisonable ventral container combining fuel and nuclear weapon\n- **TCP pod** : two-stage version, only the upper stage being dropped',

  -- Strate 4 : qualitatif
  nickname          = 'Hustler',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_B-58_Hustler',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_B-58_Hustler',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'United States Air Force',
  image_licence     = 'Public domain'
WHERE name = 'B-58 Hustler';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'B-58 Hustler';
