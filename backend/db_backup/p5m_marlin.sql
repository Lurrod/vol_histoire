-- Martin P5M Marlin
--
-- Photo : Martin P5M-2 Marlin from VP-40 in flight c1960.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Martin_P5M-2_Marlin_from_VP-40_in_flight_c1960.jpg

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
    'P5M Marlin',
    'P5M Marlin',
    'Martin P5M Marlin',
    'Martin P5M Marlin',
    'Dernier hydravion de l''US Navy, chasseur de sous-marins de la crise de Cuba aux côtes du Vietnam',
    'The US Navy''s last flying boat, a submarine hunter from the Cuban crisis to the coast of Vietnam',
    '/assets/airplanes/p5m-marlin.jpg',
    E'## Genèse\nÀ la fin de la Seconde Guerre mondiale, les capteurs du **Martin PBM Mariner** ne suffisent plus aux besoins futurs de la patrouille maritime. La **Glenn L. Martin Company** en tire un successeur conçu pour la lutte anti-sous-marine, plus puissant et plus marin. Le prototype XP5M-1, construit à partir du dernier PBM-5 et armé de tourelles de 20 mm et de 12,7 mm, vole le 30 mai 1948. Le premier des 167 P5M-1 de série vole le 22 juin 1951, avec un poste de pilotage surélevé et le radar AN/APS-44 à la place de la tourelle de nez.\n\n## Conception\nLa grande nouveauté est la coque : au lieu de se relever brusquement vers la queue, l''arrière remonte progressivement, ce qui allonge la base de flottaison, réduit le marsouinage et permet d''amerrir par mer plus forte. Une aile en mouette place les deux moteurs **Wright R-3350 Duplex-Cyclone** et leurs hélices loin des embruns. Un **détecteur d''anomalie magnétique** occupe la queue, et deux soutes creusées dans les nacelles reçoivent grenades, torpilles ou mines, jusqu''à la charge de profondeur nucléaire Mark 90. Le P5M-2 adopte un empennage en T et perd ses canons de queue ; onze hommes forment l''équipage.\n\n## Carrière opérationnelle\nPendant la crise des missiles de **Cuba**, de nombreux Marlin suivent les cargos soviétiques qui font la navette avec l''île ; ailleurs, ils pistent la marine marchande soviétique sur toutes les mers, sans débusquer souvent ses sous-marins. Pendant la **guerre du Vietnam**, la patrouille VP-40 mène à partir de février 1965 les patrouilles de l''opération **Market Time**, traquant au large du delta du Mékong les embarcations qui ravitaillent le Viet Cong. La **Marine nationale** reçoit de son côté dix Marlin pour remplacer ses Short Sunderland, basés à Dakar jusqu''en 1964.\n\n## Place dans l''histoire\nLe 6 novembre 1967, un SP-5B de la VP-40 se pose sur la baie de San Diego : c''est le dernier vol opérationnel d''un hydravion de l''US Navy. Les patrouilleurs terrestres, **P-2 Neptune** puis **P-3 Orion**, volaient plus vite et plus loin, avec plus de charge ; le P-3 l''emporta même sur un Marlin quadrimoteur, le P7M SubMaster, resté à l''état de maquette. Construit à 285 exemplaires, le Marlin referme ainsi l''histoire des hydravions de combat de la marine américaine. Un seul subsiste, au musée de l''aéronavale de Pensacola.',
    E'## Genesis\nBy the end of the Second World War, the sensors of the **Martin PBM Mariner** could no longer meet the future needs of maritime patrol. The **Glenn L. Martin Company** derived from it a successor designed for anti-submarine warfare, more powerful and more seaworthy. The XP5M-1 prototype, built from the last PBM-5 and armed with 20 mm and 12.7 mm turrets, flew on 30 May 1948. The first of 167 production P5M-1s flew on 22 June 1951, with a raised flight deck and an AN/APS-44 radar in place of the nose turret.\n\n## Design\nThe key innovation was the hull: instead of lifting sharply towards the tail, the rear hull rose steadily, lengthening the base of flotation, reducing porpoising and allowing landings in rougher seas. A gull wing placed the two **Wright R-3350 Duplex-Cyclone** engines and their propellers high above the spray. A **magnetic anomaly detector** occupied the tail, and two bomb bays built into the nacelles took depth charges, torpedoes or mines, up to the Mark 90 nuclear depth charge. The P5M-2 introduced a T-tail and dropped the tail guns; the crew numbered eleven.\n\n## Operational career\nDuring the **Cuban** Missile Crisis, numerous Marlins shadowed Soviet freighters travelling to and from the island; elsewhere they tracked Soviet shipping around the globe, though they rarely picked up its submarines. During the **Vietnam War**, Patrol Squadron VP-40 flew **Operation Market Time** patrols from February 1965, hunting off the Mekong Delta for the small craft supplying the Viet Cong. The **French Navy** also received ten Marlins to replace its Short Sunderlands, based at Dakar until 1964.\n\n## Place in history\nOn 6 November 1967 an SP-5B of VP-40 landed on San Diego Bay: the last operational flight of a US Navy flying boat. Land-based patrol aircraft, the **P-2 Neptune** and then the **P-3 Orion**, flew faster and further with heavier loads; the P-3 even beat a four-engined Marlin, the P7M SubMaster, which never went beyond a mock-up. Built in 285 examples, the Marlin closed the story of the American navy''s combat flying boats. A single example survives, at the naval aviation museum in Pensacola.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1948-05-30',
    '1952-01-01',
    404,
    3300,
    (SELECT id FROM manufacturer WHERE code = 'MAR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'P5M Marlin'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion')),
((SELECT id FROM airplanes WHERE name = 'P5M Marlin'), (SELECT id FROM tech WHERE name = 'Détecteur d''anomalie magnétique')),
((SELECT id FROM airplanes WHERE name = 'P5M Marlin'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'P5M Marlin'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'P5M Marlin'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'P5M Marlin'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'P5M Marlin'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.66,
  wingspan          = 35.71,
  height            = 9.98,
  wing_area         = 130.6,
  empty_weight      = 22900,
  mtow              = 35380,
  service_ceiling   = 7300,
  climb_rate        = 6.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 11,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-3350-32WA Duplex-Cyclone (3 450 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = NULL,
  units_built       = 285,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **XP5M-1** : prototype tiré d''un PBM Mariner, à coque et empennage modifiés, tourelles de nez, de queue et dorsale\n- **P5M-1 (P-5A)** : première série, poste surélevé, radar AN/APS-44 en nez, soutes dans les nacelles, 160 exemplaires pour l''US Navy\n- **P5M-1S (SP-5A)** : 80 P5M-1 modernisés en électronique et équipements anti-sous-marins\n- **P5M-2 (P-5B)** : empennage en T, perche MAD en queue, canons de queue supprimés, 108 exemplaires pour l''US Navy et 12 pour la Marine nationale\n- **P5M-2S (SP-5B)** : P5M-2 modernisés, derniers hydravions opérationnels de l''US Navy\n- **P5M-1G et P5M-2G** : sept et quatre avions destinés aux garde-côtes, reversés à la marine comme avions d''entraînement',
  variants_en       = E'- **XP5M-1**: prototype converted from a PBM Mariner, with modified hull and tail, nose, tail and dorsal turrets\n- **P5M-1 (P-5A)**: first production model, raised flight deck, AN/APS-44 nose radar, nacelle bomb bays, 160 built for the US Navy\n- **P5M-1S (SP-5A)**: 80 P5M-1s upgraded with new electronics and anti-submarine equipment\n- **P5M-2 (P-5B)**: T-tail, MAD boom in the tail, tail guns deleted, 108 built for the US Navy and 12 for the French Navy\n- **P5M-2S (SP-5B)**: upgraded P5M-2s, the US Navy''s last operational flying boats\n- **P5M-1G and P5M-2G**: seven and four aircraft for the Coast Guard, returned to the Navy as trainers',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Martin_P5M_Marlin',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Martin_P5M_Marlin',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'P5M Marlin';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'P5M Marlin';
