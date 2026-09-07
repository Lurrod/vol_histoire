-- Kratos XQ-58A Valkyrie
--
-- Photo : XQ-58A Valkyrie demonstrator first flight.jpg
--   licence Public domain — 88 Air Base Wing Public Affairs
--   https://commons.wikimedia.org/wiki/File%3AXQ-58A_Valkyrie_demonstrator_first_flight.jpg

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
    'XQ-58 Valkyrie',
    'XQ-58 Valkyrie',
    'Kratos XQ-58A Valkyrie',
    'Kratos XQ-58A Valkyrie',
    'Un drone furtif à deux millions de dollars, assumé jetable',
    'A two-million-dollar stealth drone, deliberately expendable',
    '/assets/airplanes/xq58-valkyrie.jpg',
    E'## Genèse\nUn **F-35** coûte quatre-vingt millions de dollars et un pilote formé bien davantage : on ne les envoie pas là où la défense est la plus dense. L''idée de l''**ailier fidèle** répond à cela — accompagner le chasseur habité d''appareils sans pilote assez bon marché pour être **perdus**. En 2016, l''AFRL demande un démonstrateur à moins de trois millions de dollars.\n\n## Conception\nTout le dessin découle du prix. Pas de train d''atterrissage : le Valkyrie décolle d''une **rampe** poussé par une fusée et se récupère au **parachute**. Pas d''infrastructure : il tient dans un conteneur. La cellule est furtive et emporte deux petites bombes ou des missiles en soute, mais l''électronique est volontairement modeste. À deux tonnes sept, il vole trois mille kilomètres.\n\n## Carrière opérationnelle\nPas encore. Une vingtaine d''exemplaires en essais depuis 2019. Le **25 juillet 2023**, un XQ-58A effectue un vol de trois heures **entièrement piloté par une intelligence artificielle** — première mondiale sur un appareil de combat. Les Marines l''évaluent depuis 2024 comme accompagnateur du F-35B.\n\n## Place dans l''histoire\nUne vingtaine d''exemplaires, aucun engagement. Le Valkyrie n''est pas un progrès technique mais un **renversement économique** : après soixante-dix ans de course au plus capable et au plus cher, il propose de gagner par le nombre. Le programme **CCA** de l''US Air Force, qui vise plus de mille appareils, en découle directement.',
    E'## Genesis\nAn **F-35** costs eighty million dollars and a trained pilot far more: neither is sent where the defences are thickest. The **loyal wingman** idea answers that — escort the manned fighter with unmanned aircraft cheap enough to be **lost**. In 2016 the AFRL asked for a demonstrator under three million dollars.\n\n## Design\nEverything follows from the price. No undercarriage: the Valkyrie launches from a **rail** pushed by a rocket and is recovered by **parachute**. No infrastructure: it fits in a container. The airframe is stealthy and carries two small bombs or missiles internally, but the electronics are deliberately modest. At two point seven tonnes it flies three thousand kilometres.\n\n## Operational career\nNot yet. Some twenty aircraft in testing since 2019. On **25 July 2023** an XQ-58A flew a three-hour sortie **entirely under artificial-intelligence control** — a world first for a combat aircraft. The Marines have been evaluating it since 2024 as an F-35B escort.\n\n## Place in history\nSome twenty built, none committed. The Valkyrie is not a technical advance but an **economic reversal**: after seventy years of chasing the most capable and most expensive, it proposes to win by numbers. The US Air Force''s **CCA** programme, aiming at more than a thousand aircraft, follows directly from it.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2016-07-01',
    '2019-03-05',
    NULL,
    1050.0,
    5556.0,
    (SELECT id FROM manufacturer WHERE code = 'KRA'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'XQ-58 Valkyrie'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'XQ-58 Valkyrie'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'XQ-58 Valkyrie'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'XQ-58 Valkyrie'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'XQ-58 Valkyrie'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'XQ-58 Valkyrie'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.8,
  wingspan          = 6.7,
  height            = 2.2,
  wing_area         = 15.0,
  empty_weight      = 1134,
  mtow              = 2722,
  service_ceiling   = 13700,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2775,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Williams FJ33-5A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 8.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2018,
  production_end    = NULL,
  units_built       = 20,
  unit_cost_usd     = 4000000,
  unit_cost_year    = 2023,
  operators_count   = 1,
  variants          = E'- **XQ-58A** : version de démonstration, une vingtaine d''exemplaires\n- Décolle d''une **rampe à propulseur-fusée**, sans piste ni train d''atterrissage\n- Se récupère au **parachute** : rien à bord ne coûte assez cher pour le regretter\n- Le 25 juillet 2023, un XQ-58A vole **piloté par une intelligence artificielle**\n- Cœur du concept d''**ailier fidèle** : accompagner un F-35 et prendre les risques',
  variants_en       = E'- **XQ-58A** : demonstration version, some twenty aircraft\n- Takes off from a **rocket-boosted rail**, with no runway and no undercarriage\n- Recovered by **parachute**: nothing aboard costs enough to regret\n- On 25 July 2023 an XQ-58A flew **under artificial-intelligence control**\n- Core of the **loyal wingman** concept: escort an F-35 and take the risks',

  -- Strate 4 : qualitatif
  nickname          = 'Valkyrie',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Kratos_XQ-58_Valkyrie',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Kratos_XQ-58_Valkyrie',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '88 Air Base Wing Public Affairs',
  image_licence     = 'Public domain'
WHERE name = 'XQ-58 Valkyrie';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'XQ-58 Valkyrie';
