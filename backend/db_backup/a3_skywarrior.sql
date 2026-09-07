-- Douglas A-3 Skywarrior
--
-- Photo : EA-3B VQ-1 in flight South China Sea 1974.jpeg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3AEA-3B_VQ-1_in_flight_South_China_Sea_1974.jpeg

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
    'A-3 Skywarrior',
    'A-3 Skywarrior',
    'Douglas A-3 Skywarrior',
    'Douglas A-3 Skywarrior',
    'Le plus lourd appareil jamais mis en service sur porte-avions',
    'The heaviest aircraft ever put into carrier service',
    '/assets/airplanes/a3-skywarrior.jpg',
    E'## Genèse\nEn 1948, l''US Navy veut sa part de la dissuasion nucléaire, monopole de l''Air Force et de ses bombardiers terrestres. Il lui faut un avion capable d''emporter une bombe atomique **depuis un porte-avions** — donc trente et une tonnes sur un pont de deux cent cinquante mètres. Ed Heinemann, chez Douglas, parie sur un appareil bien plus léger que le cahier des charges ne le laisse craindre et gagne le marché.\n\n## Conception\nAile en flèche haute, deux réacteurs J57 en nacelles sous voilure, soute ventrale dimensionnée pour les premières armes nucléaires — massives. Le pari du poids conduit à un choix qui restera controversé : **pas de sièges éjectables**. L''équipage de trois hommes doit évacuer par une goulotte ventrale, ce qui vaudra à l''avion un second surnom au sein des équipages, « All Three Dead », jeu de mots amer sur sa désignation A3D.\n\n## Carrière opérationnelle\nSa mission nucléaire s''évapore avec l''arrivée des sous-marins **Polaris**, plus discrets et plus sûrs. L''avion se réinvente alors complètement : bombardier conventionnel au Vietnam, puis ravitailleur, puis plateforme de guerre électronique et de renseignement. Un EA-3B écoutera encore les communications irakiennes pendant la **guerre du Golfe**, trente-cinq ans après le premier vol.\n\n## Place dans l''histoire\nTrente-sept tonnes au décollage : aucun avion plus lourd n''a jamais été mis en service opérationnel à bord d''un porte-avions, et le record tient toujours. Sa vraie leçon est ailleurs — conçu pour une mission qui a disparu en dix ans, il a servi trente-cinq ans de plus en faisant tout autre chose. Le **A-5 Vigilante** reprendra la mission nucléaire embarquée, et la perdra encore plus vite.',
    E'## Genesis\nIn 1948 the US Navy wanted its share of nuclear deterrence, then the monopoly of the Air Force and its land-based bombers. It needed an aircraft able to carry an atomic bomb **from a carrier** — thirty-one tonnes on a two-hundred-and-fifty-metre deck. At Douglas, Ed Heinemann gambled on an aircraft far lighter than the specification implied, and won the contract.\n\n## Design\nA high swept wing, two J57 engines in underwing pods, and a belly bay sized for the first nuclear weapons — which were huge. The weight gamble led to a choice that stayed controversial: **no ejection seats**. The three-man crew had to bail out through a belly chute, which earned the aircraft a second nickname among crews, “All Three Dead”, a bitter pun on its A3D designation.\n\n## Operational career\nIts nuclear mission evaporated with the arrival of **Polaris** submarines, quieter and safer. The aircraft then reinvented itself completely: conventional bomber over Vietnam, then tanker, then electronic warfare and intelligence platform. An EA-3B was still listening to Iraqi communications during the **Gulf War**, thirty-five years after the first flight.\n\n## Place in history\nThirty-seven tonnes at take-off: no heavier aircraft has ever entered operational service aboard a carrier, and the record still stands. Its real lesson lies elsewhere — built for a mission that vanished within ten years, it served thirty-five more doing something else entirely. The **A-5 Vigilante** would take up the carrier nuclear mission, and lose it faster still.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1948-01-01',
    '1952-10-28',
    '1956-03-31',
    982.0,
    3380.0,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg')),
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM armement WHERE name = 'B43'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.27,
  wingspan          = 22.1,
  height            = 6.95,
  wing_area         = 75.43,
  empty_weight      = 17876,
  mtow              = 37195,
  service_ceiling   = 12500,
  climb_rate        = 18.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1690,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J57-P-10',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 46.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1961,
  units_built       = 282,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **A3D-1 / A-3B** : versions de bombardement stratégique embarqué\n- **EA-3B** : renseignement électronique, sept opérateurs en soute\n- **KA-3B** : version de ravitaillement en vol, son rôle final au Vietnam\n- **ERA-3B** : brouillage et simulation de menace pour l''entraînement\n- **B-66 Destroyer** : version terrestre pour l''US Air Force, largement remaniée',
  variants_en       = E'- **A3D-1 / A-3B** : carrier-based strategic bombing versions\n- **EA-3B** : signals intelligence, with seven operators in the bay\n- **KA-3B** : aerial refuelling version, its final role over Vietnam\n- **ERA-3B** : jamming and threat simulation for training\n- **B-66 Destroyer** : land-based version for the US Air Force, extensively reworked',

  -- Strate 4 : qualitatif
  nickname          = 'The Whale',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_A-3_Skywarrior',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_A-3_Skywarrior',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'A-3 Skywarrior';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'A-3 Skywarrior';
