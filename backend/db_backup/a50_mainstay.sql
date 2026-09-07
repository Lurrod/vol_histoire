-- Beriev A-50 Mainstay
--
-- Photo : MoscowVictoryDayParade2020 A-50 010 3420.jpg
--   licence CC BY-SA 4.0 — Ludvig14
--   https://commons.wikimedia.org/wiki/File%3AMoscowVictoryDayParade2020_A-50_010_3420.jpg

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
    'Beriev A-50',
    'Beriev A-50',
    'Beriev A-50 Mainstay',
    'Beriev A-50 Mainstay',
    'L’œil volant soviétique, réponse directe à l’E-3 Sentry',
    'The Soviet flying eye, a direct answer to the E-3 Sentry',
    '/assets/airplanes/a50-mainstay.jpg',
    E'## Genèse\nL''URSS possède depuis les années 1960 un guet aérien avancé, le Tu-126, mais il est mauvais : son radar, monté sur une cellule à hélices, est aveuglé par les échos de sol et par les propres moteurs de l''avion. Quand l''Amérique met en service l''**E-3 Sentry**, l''écart devient intenable. Beriev reprend alors la cellule du transporteur **Il-76** et y installe un radar rotatif de neuf mètres.\n\n## Conception\nLe radar Chpil-M tourne dans une soucoupe portée par deux mâts au-dessus du fuselage arrière. L''aile haute de l''Il-76 dégage le champ vers le bas, et l''ensemble suit environ **cinquante cibles simultanément** en dirigeant une dizaine d''intercepteurs. Le compartiment opérationnel accueille dix opérateurs sur un total de quinze hommes d''équipage. Les conditions de travail à bord sont rudes — bruit, chaleur, absence de toilettes sur les premières versions.\n\n## Carrière opérationnelle\nIl surveille les approches soviétiques puis russes pendant toute la fin de la guerre froide, opère au-dessus de la **Syrie** à partir de 2015, et devient une pièce maîtresse au-dessus de l''**Ukraine** après 2022, où il dirige les tirs à longue portée. Deux appareils y sont abattus ou gravement endommagés en janvier et février 2024 — une perte considérable pour une flotte qui ne compte qu''une poignée d''exemplaires en état de vol.\n\n## Place dans l''histoire\nQuarante exemplaires construits contre soixante-huit E-3, et un radar longtemps inférieur : le A-50 n''a jamais rattrapé son modèle. Il a néanmoins donné à Moscou la capacité qui manquait à toute sa défense aérienne, celle de voir bas et loin sans dépendre du sol. Son successeur, l''A-100, accumule les retards depuis quinze ans.',
    E'## Genesis\nSince the 1960s the USSR had an airborne early warning aircraft, the Tu-126, but it was poor: its radar, mounted on a propeller-driven airframe, was blinded by ground returns and by the aircraft''s own engines. When America brought the **E-3 Sentry** into service the gap became untenable. Beriev then took the **Il-76** transport airframe and fitted a nine-metre rotating radar to it.\n\n## Design\nThe Shmel radar turns inside a saucer carried on two pylons above the rear fuselage. The Il-76''s high wing clears the downward field of view, and the whole tracks about **fifty targets at once** while directing a dozen interceptors. The operations compartment seats ten operators out of a fifteen-man crew. Working conditions aboard were harsh — noise, heat, and no lavatory on the early versions.\n\n## Operational career\nIt watched Soviet and then Russian approaches through the end of the Cold War, operated over **Syria** from 2015, and became a central asset over **Ukraine** after 2022, where it directs long-range engagements. Two aircraft were shot down or badly damaged there in January and February 2024 — a considerable loss for a fleet numbering only a handful of airworthy examples.\n\n## Place in history\nForty built against sixty-eight E-3s, and for a long time an inferior radar: the A-50 never caught its model. It did nevertheless give Moscow the capability its whole air defence lacked, that of seeing low and far without depending on the ground. Its successor, the A-100, has been accumulating delays for fifteen years.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1969-01-01',
    '1978-12-19',
    '1985-01-01',
    800.0,
    7500.0,
    (SELECT id FROM manufacturer WHERE code = 'BER'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev A-50'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-50'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-50'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-50'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev A-50'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-50'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-50'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev A-50'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-50'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-50'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 46.59,
  wingspan          = 50.5,
  height            = 14.76,
  wing_area         = 300.0,
  empty_weight      = 75000,
  mtow              = 190000,
  service_ceiling   = 12000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1000,
  crew              = 15,

  -- Strate 2 : motorisation
  engine_name       = 'Aviadvigatel D-30KP',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 117.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1984,
  production_end    = 1992,
  units_built       = 40,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **A-50** : version initiale à radar Chpil-M, mise en service en 1985\n- **A-50U** : modernisation russe à électronique numérique, portée et endurance accrues\n- **A-50EI** : version livrée à l''**Inde**, radar israélien Phalcon sur cellule russe\n- **A-100 Premier** : successeur à radar à antenne active, programme en cours\n- Cellule dérivée du transport **Iliouchine Il-76**, dont il conserve la soute et les moteurs',
  variants_en       = E'- **A-50** : initial version with the Shmel radar, entering service in 1985\n- **A-50U** : Russian upgrade with digital electronics, increased range and endurance\n- **A-50EI** : version delivered to **India**, Israeli Phalcon radar on a Russian airframe\n- **A-100 Premier** : successor with an active array radar, programme under way\n- Airframe derived from the **Ilyushin Il-76** transport, whose hold and engines it keeps',

  -- Strate 4 : qualitatif
  nickname          = 'Mainstay',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beriev_A-50',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beriev_A-50',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ludvig14',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Beriev A-50';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beriev A-50';
