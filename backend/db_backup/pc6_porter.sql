-- Pilatus PC-6 Porter / Turbo-Porter
--
-- Photo : PC-6 Switserland (26847417033).jpg
--   licence CC BY-SA 2.0 — Rob Schleiffert from Holland
--   https://commons.wikimedia.org/wiki/File:PC-6_Switserland_(26847417033).jpg

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
    'Pilatus PC-6 Porter',
    'Pilatus PC-6 Porter',
    'Pilatus PC-6 Porter / Turbo-Porter',
    'Pilatus PC-6 Porter / Turbo-Porter',
    'L''utilitaire suisse posé sur un glacier à 5 750 m, des armées alpines aux pistes d''Air America',
    'The Swiss utility aircraft that landed on a glacier at 5,750 m, from Alpine armies to Air America''s strips',
    '/assets/airplanes/pc6-porter.jpg',
    E'## Genèse\nÀ Stans, en Suisse, **Pilatus** conçoit à la fin des années 1950 un monomoteur utilitaire à décollage et atterrissage courts pour les pays de montagne. Le premier prototype vole le 4 mai 1959 avec un moteur à pistons Lycoming de 340 ch. Engagé en 1960 dans l''expédition suisse au **Dhaulagiri**, dans l''Himalaya, le prototype baptisé Yeti se pose sur le glacier à 5 750 m, record jamais battu pour un avion à voilure fixe. La version à turbine, le **Turbo-Porter**, vole en mai 1961 avec un Turbomeca Astazou.\n\n## Conception\nLe PC-6 est un monoplan à aile haute haubanée, de construction semi-monocoque en aluminium, sur un train classique qui tient l''hélice et l''aile loin du sol. Il décolle en 195 m et se pose en 130 m avec 1 200 kg de charge. Après des Astazou jugés peu fiables, la plupart reçoivent un **Pratt & Whitney Canada PT6A**, dont le premier vol a lieu en mai 1966. La cabine, ouverte par deux grandes portes coulissantes, emporte jusqu''à dix passagers et se reconvertit vite pour le transport, le parachutage, la photographie aérienne, la surveillance, l''évacuation sanitaire ou le sauvetage ; une trappe dans le plancher permet les largages. Roues, flotteurs ou skis l''adaptent à tous les terrains.\n\n## Carrière opérationnelle\nFabriqué sous licence aux États-Unis par **Fairchild Hiller**, le Porter part à la **guerre du Vietnam**. La compagnie **Air America**, contrôlée par la CIA, en aligne jusqu''à 23 à la fois pour le parachutage de ravitaillement, le transport, la guerre psychologique, la reconnaissance et le relais radio ; plusieurs sont détruits au Vietnam et au Laos. L''US Air Force essaie une version armée, l''**AU-23A Peacemaker**, à canon rotatif de 20 mm tirant par le flanc, mais la renvoie en stock au bout d''un an ; elle finit en Thaïlande. Les forces aériennes suisses en reçoivent à partir de 1966, l''Autriche en fait en 1976 le pilier de son transport léger, et l''aviation légère de l''armée de Terre française engage les siens au **Sahel** à partir de 2013.\n\n## Place dans l''histoire\nAprès 604 exemplaires en 63 ans, Pilatus livre le dernier PC-6 en décembre 2022. L''avion a été acheté par une trentaine de pays, notamment pour leurs forces armées, et immatriculé dans 76. Comparé par la presse aéronautique à un hélicoptère pour ses performances au décollage, il a fini par servir surtout au parachutisme en Europe, où ce rôle occupait 40 % des appareils au début des années 1990, et remplace en Chine l''Antonov An-2.',
    E'## Genesis\nAt Stans, in Switzerland, **Pilatus** designed a short take-off and landing utility single for mountainous countries in the late 1950s. The first prototype flew on 4 May 1959 with a 340 hp Lycoming piston engine. Sent in 1960 with the Swiss expedition to **Dhaulagiri**, in the Himalaya, the prototype named Yeti landed on the glacier at 5,750 m, a record never beaten by a fixed-wing aircraft. The turbine version, the **Turbo-Porter**, flew in May 1961 with a Turbomeca Astazou.\n\n## Design\nThe PC-6 is a strut-braced high-wing monoplane of semi-monocoque aluminium construction, on a tailwheel undercarriage that keeps propeller and wing well clear of the ground. It takes off in 195 m and lands in 130 m carrying 1,200 kg. After Astazous judged unreliable, most received a **Pratt & Whitney Canada PT6A**, first flown in May 1966. The cabin, opened by two large sliding doors, carries up to ten passengers and is quickly converted for transport, parachuting, aerial photography, surveillance, medical evacuation or search and rescue; a floor hatch allows supply drops. Wheels, floats or skis suit it to any terrain.\n\n## Operational career\nBuilt under licence in the United States by **Fairchild Hiller**, the Porter went to the **Vietnam War**. The CIA-controlled airline **Air America** flew up to 23 at a time for supply drops, transport, psychological warfare, reconnaissance and radio relay; several were destroyed in Vietnam and Laos. The US Air Force tried an armed version, the **AU-23A Peacemaker**, with a side-firing 20 mm rotary cannon, but put it into storage after a single year; it ended up in Thailand. The Swiss Air Force received them from 1966, Austria made it the backbone of its light transport fleet in 1976, and French Army Light Aviation flew its own in the **Sahel** from 2013.\n\n## Place in history\nAfter 604 aircraft in 63 years, Pilatus delivered the last PC-6 in December 2022. The aircraft was bought by some thirty countries, notably for their armed forces, and registered in 76. Compared by the aviation press to a helicopter for its take-off performance, it ended up largely in parachuting work in Europe, where that role took 40% of the fleet in the early 1990s, and in China it replaces the Antonov An-2.',
    (SELECT id FROM countries WHERE code = 'CHE'),
    NULL,
    '1959-05-04',
    '1966-01-01',
    232,
    1612,
    (SELECT id FROM manufacturer WHERE code = 'PIL'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-6 Porter'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-6 Porter'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-6 Porter'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-6 Porter'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-6 Porter'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-6 Porter'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-6 Porter'), (SELECT id FROM wars WHERE name = 'Guerre du Sahel'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.0,
  wingspan          = 15.87,
  height            = 3.2,
  wing_area         = 30.15,
  empty_weight      = 1270,
  mtow              = 2800,
  service_ceiling   = 8197,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-27 (550 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1959,
  production_end    = 2022,
  units_built       = 604,
  unit_cost_usd     = 1900000,
  unit_cost_year    = 2010,
  operators_count   = NULL,
  variants          = E'- **PC-6 Porter** : version initiale à moteur à pistons Lycoming de 340 ch\n- **PC-6/A Turbo-Porter** : premier Turbo-Porter, à turbopropulseur Turbomeca Astazou\n- **PC-6/B2-H2 et B2-H4** : versions à Pratt & Whitney Canada PT6A, les plus répandues, la H4 à structure renforcée et saumons relevés\n- **AU-23A Peacemaker** : version armée de contre-insurrection construite par Fairchild pour l''US Air Force, 15 exemplaires cédés à la Thaïlande\n- **UV-20A Chiricahua** : version de transport de l''US Army, deux exemplaires basés à Berlin-Ouest de 1979 à 1991',
  variants_en       = E'- **PC-6 Porter**: initial version with a 340 hp Lycoming piston engine\n- **PC-6/A Turbo-Porter**: first Turbo-Porter, with a Turbomeca Astazou turboprop\n- **PC-6/B2-H2 and B2-H4**: Pratt & Whitney Canada PT6A versions, the most widespread, the H4 with a strengthened structure and upturned wingtips\n- **AU-23A Peacemaker**: armed counter-insurgency version built by Fairchild for the US Air Force, 15 passed to Thailand\n- **UV-20A Chiricahua**: US Army transport version, two based in West Berlin from 1979 to 1991',

  -- Strate 4 : qualitatif
  nickname          = 'Jeep des airs',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Pilatus_PC-6',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Pilatus_PC-6_Porter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Schleiffert',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Pilatus PC-6 Porter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Pilatus PC-6 Porter';
