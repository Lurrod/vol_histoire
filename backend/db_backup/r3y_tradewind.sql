-- Convair R3Y Tradewind
--
-- Photo : Convair R3Y-2 Tradewind 127-gr-2-18-A351859 001-ac.jpg
--   licence Public domain — Unknown authorUnknown author or not provided
--   https://commons.wikimedia.org/wiki/File:Convair_R3Y-2_Tradewind_127-gr-2-18-A351859_001-ac.jpg

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
    'Convair R3Y Tradewind',
    'Convair R3Y Tradewind',
    'Convair R3Y Tradewind',
    'Convair R3Y Tradewind',
    'L''hydravion à turbopropulseurs qui voulut débarquer sur les plages, trahi par ses moteurs',
    'The turboprop flying boat that tried to land troops on beaches, betrayed by its engines',
    '/assets/airplanes/r3y-tradewind.jpg',
    E'## Genèse\nEn 1945, l''US Navy demande à **Convair** un grand hydravion tirant parti des techniques nées pendant la guerre, en particulier l''aile à écoulement laminaire et le turbopropulseur, encore en développement. Le Model 117 qui en résulte est commandé à deux prototypes de patrouilleur le 27 mai 1946. Le premier **XP5Y-1** vole le 18 avril 1950 à San Diego et établit en août un record d''endurance pour un turbopropulseur, huit heures et six minutes. La marine renonce pourtant au patrouilleur et fait transformer le projet en transport de passagers et de fret.\n\n## Conception\nLe Tradewind est un hydravion à aile haute, à coque fine à un seul redan et flotteurs fixes. Ses quatre turbopropulseurs **Allison T40** entraînent chacun deux hélices contrarotatives à six pales. Le **R3Y-1** perd tout armement, reçoit une porte latérale de trois mètres, des nacelles redessinées pour le T40-A-10 et une cabine pressurisée et climatisée pour 103 passagers ou 24 tonnes de fret. Le **R3Y-2** va plus loin : son nez se relève, comme plus tard celui du C-5 Galaxy, pour débarquer véhicules et soldats directement sur une plage, à la manière d''un engin de débarquement volant.\n\n## Carrière opérationnelle\nLe R3Y-1 vole en février 1954 et la même année un Tradewind relie les deux côtes américaines à 649 km/h de moyenne en profitant du courant-jet, un record d''hydravion toujours debout. Les onze appareils rejoignent l''escadron de transport VR-2 le 31 mars 1956. Le débarquement sur plage déçoit : les pilotes ne parviennent presque pas à maintenir l''avion immobile, nez à la plage, pendant le chargement. Les R3Y-2 deviennent donc des ravitailleurs à quatre postes, et en septembre 1956 l''un d''eux est le premier avion à ravitailler simultanément quatre autres, des F9F Cougar.\n\n## Place dans l''histoire\nLe programme bute sur le manque de fiabilité de l''Allison T40, comme la plupart des avions qui en sont équipés, dont l''avion d''attaque **A2D Skyshark**. Après la perte d''un XP5Y-1 et trois autres accidents dus aux moteurs, les appareils sont cloués au sol ; VR-2 est dissous le 16 avril 1958 et tous les Tradewind sont ensuite démolis. Son record transcontinental, jamais battu, montre ce que le turbopropulseur pouvait apporter à l''hydravion ; ses moteurs, eux, n''ont jamais tenu leurs promesses, et la Navy a abandonné le T40 et tous les avions qui l''utilisaient.',
    E'## Genesis\nIn 1945 the US Navy asked **Convair** for a large flying boat exploiting technologies born during the war, in particular the laminar-flow wing and the still-developing turboprop. The resulting Model 117 was ordered as two patrol prototypes on 27 May 1946. The first **XP5Y-1** flew on 18 April 1950 at San Diego and in August set a turboprop endurance record of eight hours six minutes. The Navy nevertheless gave up on the patroller and had the design turned into a passenger and cargo transport.\n\n## Design\nThe Tradewind was a high-wing flying boat with a slender single-step hull and fixed floats. Its four **Allison T40** turboprops each drove two six-bladed contra-rotating propellers. The **R3Y-1** lost all armament and received a three-metre side hatch, nacelles redesigned for the T40-A-10 and a pressurised, air-conditioned cabin for 103 passengers or 24 tonnes of cargo. The **R3Y-2** went further: its nose lifted, like the C-5 Galaxy''s later, to land vehicles and troops straight onto a beach, as a flying landing ship.\n\n## Operational career\nThe R3Y-1 flew in February 1954, and that year a Tradewind crossed the United States at an average 649 km/h by riding the jet stream, a seaplane record that still stands. The eleven aircraft joined transport squadron VR-2 on 31 March 1956. Beach landing proved disappointing: pilots found it almost impossible to hold the aircraft steady, nose to the beach, while it was loaded. The R3Y-2s therefore became four-point tankers, and in September 1956 one became the first aircraft to refuel four others at once, F9F Cougars.\n\n## Place in history\nThe programme foundered on the unreliability of the Allison T40, like most aircraft powered by it, including the **A2D Skyshark** attack aircraft. After the loss of an XP5Y-1 and three further engine-related accidents, the aircraft were grounded; VR-2 was disbanded on 16 April 1958 and all the Tradewinds were subsequently broken up. Its unbeaten transcontinental record shows what the turboprop could bring to the flying boat; its engines, however, never lived up to their promise, and the Navy gave up on the T40 and every aircraft that used it.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-01-01',
    '1954-02-22',
    '1956-03-31',
    570,
    4480,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair R3Y Tradewind'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion')),
((SELECT id FROM airplanes WHERE name = 'Convair R3Y Tradewind'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Convair R3Y Tradewind'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair R3Y Tradewind'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Convair R3Y Tradewind'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 42.6,
  wingspan          = 44.4,
  height            = 14.94,
  wing_area         = 195.16,
  empty_weight      = NULL,
  mtow              = 74843,
  service_ceiling   = 9200,
  climb_rate        = 9.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 7,

  -- Strate 2 : motorisation
  engine_name       = 'Allison T40-A-10 (5 332 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 11,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XP5Y-1** : prototype de patrouilleur armé, deux construits, premier vol le 18 avril 1950\n- **R3Y-1** : transport à porte latérale de trois mètres, cinq construits\n- **R3Y-2** : transport d''assaut à nez relevable et poste de pilotage surélevé, six construits, convertis en ravitailleurs à quatre postes\n- **Motorisation Allison T40-A-10** : 5 332 ch par moteur, hélices Aeroproducts contrarotatives à six pales de 4,6 m',
  variants_en       = E'- **XP5Y-1**: armed patrol prototype, two built, first flight on 18 April 1950\n- **R3Y-1**: transport with a three-metre side hatch, five built\n- **R3Y-2**: assault transport with a lifting nose and raised cockpit, six built, converted into four-point tankers\n- **Allison T40-A-10 powerplant**: 5,332 shp per engine, six-bladed Aeroproducts contra-rotating propellers of 4.6 m',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_R3Y_Tradewind',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_R3Y_Tradewind',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Convair R3Y Tradewind';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Convair R3Y Tradewind';
