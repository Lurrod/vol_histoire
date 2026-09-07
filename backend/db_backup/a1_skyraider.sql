-- Douglas A-1 Skyraider
--
-- Photo : Douglas A-1 Skyraider (AD-4NA, 126965) (7911148090).jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany
--   https://commons.wikimedia.org/wiki/File%3ADouglas_A-1_Skyraider_%28AD-4NA%2C_126965%29_%287911148090%29.jpg

-- Entrée de référentiel propre à cette fiche.
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Moteur à pistons en étoile', 'Radial piston engine', 'Motorisation à cylindres disposés en étoile, longue endurance à basse altitude', 'Engine with radially arranged cylinders, long endurance at low altitude'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Moteur à pistons en étoile');

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
    'A-1 Skyraider',
    'A-1 Skyraider',
    'Douglas A-1 Skyraider',
    'Douglas A-1 Skyraider',
    'Avion d’attaque à hélice, increvable au-dessus du Vietnam',
    'Piston-engined attack aircraft, indestructible over Vietnam',
    '/assets/airplanes/a1-skyraider.jpg',
    E'## Genèse\nDessiné en une nuit d''hôtel par **Ed Heinemann** en 1944, après que la marine eut rejeté son projet initial, le Skyraider arrive trop tard pour la Seconde Guerre mondiale. Il volera pourtant en première ligne pendant près de trente ans, à l''âge du réacteur.\n\n## Conception\nUn moteur en étoile de 2 700 chevaux, quinze points d''emport, et une charge utile supérieure à celle d''un bombardier lourd de 1944. Sa lenteur est son atout : il **loiter** au-dessus d''une zone pendant des heures là où un jet repart au bout de quelques minutes, et frappe avec une précision qu''aucun appareil rapide n''atteint alors.\n\n## Carrière opérationnelle\nCorée d''abord, puis le **Vietnam**, où il devient le *Sandy* : l''escorte des hélicoptères de récupération de pilotes abattus, mission où l''endurance et l''encaisse comptent plus que la vitesse. Deux Skyraider abattent même des MiG-17 au canon. La France en engage en **Algérie** et les cède ensuite à plusieurs armées africaines.\n\n## Place dans l''histoire\nLe Skyraider a démontré qu''en appui rapproché, l''endurance et la charge priment sur la vitesse — l''argument même qui justifiera le **A-10 Thunderbolt II** vingt ans plus tard. Son remplaçant immédiat, l''A-7 Corsair II, mettra des années à égaler son temps de présence sur zone.',
    E'## Genesis\nSketched overnight in a hotel room by **Ed Heinemann** in 1944 after the Navy rejected his first proposal, the Skyraider arrived too late for the Second World War. It would nonetheless fly front-line missions for almost thirty years, well into the jet age.\n\n## Design\nA 2,700 hp radial engine, fifteen hardpoints, and a payload greater than a 1944 heavy bomber’s. Its slowness was its strength: it could **loiter** over an area for hours where a jet had to leave after minutes, and struck with an accuracy no fast aircraft could then match.\n\n## Operational career\nKorea first, then **Vietnam**, where it became the *Sandy*: escorting rescue helicopters recovering downed pilots, a mission where endurance and toughness mattered more than speed. Two Skyraiders even shot down MiG-17s with their cannon. France committed them in **Algeria** and later passed them to several African air forces.\n\n## Place in history\nThe Skyraider proved that in close air support, endurance and payload beat speed — the very argument that would justify the **A-10 Thunderbolt II** twenty years later. Its immediate replacement, the A-7 Corsair II, took years to match its time on station.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-01-01',
    '1945-03-18',
    '1946-12-01',
    518.0,
    2115.0,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM armement WHERE name = 'AGM-12 Bullpup')),
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM armement WHERE name = 'Zuni 127 mm')),
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.84,
  wingspan          = 15.25,
  height            = 4.78,
  wing_area         = 37.2,
  empty_weight      = 5429,
  mtow              = 11340,
  service_ceiling   = 8685,
  climb_rate        = 14,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1300,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-3350-26WA Duplex-Cyclone (2 700 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons en étoile, 18 cylindres',
  engine_type_en    = '18-cylinder radial piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1957,
  units_built       = 3180,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **AD-4 / A-1D** : version de la guerre de Corée\n- **A-1H / A-1J** : monoplaces principaux du Vietnam\n- **A-1E** : version côte à côte, souvent en *Sandy*\n- **AD-5W** : version de veille radar aéroportée',
  variants_en       = E'- **AD-4 / A-1D** : Korean War version\n- **A-1H / A-1J** : main Vietnam single-seaters\n- **A-1E** : side-by-side version, often flown as *Sandy*\n- **AD-5W** : airborne early warning version',

  -- Strate 4 : qualitatif
  nickname          = 'Spad',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_A-1_Skyraider',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_A-1_Skyraider',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clemens Vasters from Viersen, Germany',
  image_licence     = 'CC BY 2.0'
WHERE name = 'A-1 Skyraider';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'A-1 Skyraider';
