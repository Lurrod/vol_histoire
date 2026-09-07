-- Douglas A-4 Skyhawk
--
-- Photo : Douglas A-4E Skyhawk of VA-164 in flight over Vietnam on 21 November 1967 (6430101).jpg
--   licence Public domain — Lt.JG Nelson, U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3ADouglas_A-4E_Skyhawk_of_VA-164_in_flight_over_Vietnam_on_21_November_1967_%286430101%29.jpg

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
    'A-4 Skyhawk',
    'A-4 Skyhawk',
    'Douglas A-4 Skyhawk',
    'Douglas A-4 Skyhawk',
    'Chasseur-bombardier léger embarqué, produit pendant 26 ans',
    'Light carrier-borne attack aircraft, built for 26 years',
    '/assets/airplanes/a4-skyhawk.jpg',
    E'## Genèse\nAu début des années 1950, l''US Navy demande un bombardier nucléaire embarqué de 13 tonnes. **Ed Heinemann**, chez Douglas, livre un appareil de **moitié moins lourd** que le cahier des charges, en supprimant tout ce qui n''était pas indispensable. L''aile est si compacte qu''elle ne se replie pas — un gain de poids et de complexité inédit sur un avion embarqué.\n\n## Conception\nLe Skyhawk tient dans un ascenseur de porte-avions sans repliage, coûte une fraction de ses contemporains et se révèle d''une robustesse remarquable. Ses détracteurs le surnomment *Heinemann''s Hot Rod* ; ses pilotes l''appellent **Scooter**. Simple, léger, peu gourmand, il restera 26 ans en production — record pour un avion de combat américain.\n\n## Carrière opérationnelle\nÉpine dorsale de l''attaque embarquée américaine au **Vietnam**, où il effectue le plus grand nombre de sorties d''attaque de la marine. Israël l''utilise massivement lors de la **guerre du Kippour** et au Liban. L''Argentine en engage aux **Malouines** en 1982 : ses Skyhawk coulent plusieurs bâtiments britanniques au prix de pertes très lourdes.\n\n## Place dans l''histoire\nPrès de 3 000 exemplaires, une dizaine d''utilisateurs, et une longévité qui l''a mené jusqu''aux années 2010 comme avion d''entraînement et plastron. Le Skyhawk reste la démonstration la plus citée qu''un cahier des charges tenu en dessous du poids demandé peut produire un chef-d''œuvre.',
    E'## Genesis\nIn the early 1950s the US Navy asked for a 13-tonne carrier-borne nuclear bomber. **Ed Heinemann** at Douglas delivered an aircraft **half the specified weight**, by removing everything that was not essential. The wing is so compact it does not fold — an unheard-of saving in weight and complexity for a carrier aircraft.\n\n## Design\nThe Skyhawk fits a carrier lift without folding, costs a fraction of its contemporaries and proved remarkably rugged. Critics called it *Heinemann’s Hot Rod*; its pilots called it **Scooter**. Simple, light and frugal, it stayed in production for 26 years — a record for an American combat aircraft.\n\n## Operational career\nBackbone of US carrier attack aviation in **Vietnam**, where it flew more Navy attack sorties than any other type. Israel used it heavily in the **Yom Kippur War** and in Lebanon. Argentina committed Skyhawks in the **Falklands** in 1982: they sank several British ships at the cost of very heavy losses.\n\n## Place in history\nNearly 3,000 built, ten operators, and a service life that stretched into the 2010s as a trainer and aggressor. The Skyhawk remains the most-cited proof that coming in under the specified weight can produce a masterpiece.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1952-01-01',
    '1954-06-22',
    '1956-10-01',
    1083.0,
    3220.0,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM armement WHERE name = 'AGM-12 Bullpup')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM armement WHERE name = 'AGM-45 Shrike')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM armement WHERE name = 'Zuni 127 mm')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines')),
((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'), (SELECT id FROM wars WHERE name = 'Guerre du Liban'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.22,
  wingspan          = 8.38,
  height            = 4.57,
  wing_area         = 24.2,
  empty_weight      = 4750,
  mtow              = 11136,
  service_ceiling   = 12880,
  climb_rate        = 43,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = 1000,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J52-P-8A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 41.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1979,
  units_built       = 2960,
  unit_cost_usd     = 860000,
  unit_cost_year    = 1965,
  operators_count   = 10,
  variants          = E'- **A-4E/F** : versions principales de la guerre du Vietnam\n- **A-4M Skyhawk II** : version renforcée du corps des Marines\n- **A-4H / A-4N Ahit** : versions israéliennes\n- **TA-4J** : biplace d''entraînement avancé',
  variants_en       = E'- **A-4E/F** : main Vietnam War versions\n- **A-4M Skyhawk II** : uprated Marine Corps version\n- **A-4H / A-4N Ahit** : Israeli versions\n- **TA-4J** : two-seat advanced trainer',

  -- Strate 4 : qualitatif
  nickname          = 'Scooter',

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_A-4_Skyhawk',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_A-4_Skyhawk',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Lt.JG Nelson, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'A-4 Skyhawk';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'A-4 Skyhawk';
