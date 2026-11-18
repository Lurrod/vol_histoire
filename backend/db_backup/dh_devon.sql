-- de Havilland DH.104 Devon / Sea Devon
--
-- Photo : VP981 D.H. Dove CVT 10-06-2015 (18678779576).jpg
--   licence CC BY-SA 2.0 — Rob Hodgkins
--   https://commons.wikimedia.org/wiki/File:VP981_D.H._Dove_CVT_10-06-2015_(18678779576).jpg

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
    'de Havilland Devon',
    'de Havilland Devon',
    'de Havilland DH.104 Devon / Sea Devon',
    'de Havilland DH.104 Devon / Sea Devon',
    'Le Dove en uniforme, avion de liaison et de personnalités de la RAF pendant plus de trente ans',
    'The Dove in uniform, the RAF''s communications and VIP aircraft for more than thirty years',
    '/assets/airplanes/dh-devon.jpg',
    E'## Genèse\nLe DH.104 Dove répond au type VB défini par le comité Brabazon, qui réclame pour l''après-guerre un court-courrier britannique capable d''alimenter les grandes lignes. Dessiné par l''équipe de **Ronald Bishop**, père du Mosquito et du **Comet**, il doit succéder au biplan Dragon Rapide et concurrencer les nombreux surplus militaires comme le **Douglas DC-3**. Il vole le 25 septembre 1945. Si l''essentiel des 544 exemplaires construits jusqu''en 1967 part aux compagnies, les forces armées en font très tôt un avion de liaison : la version militaire Dove 4 devient le **Devon** dans la Royal Air Force et le **Sea Devon** dans la Royal Navy.\n\n## Conception\nContrairement au Dragon Rapide, le Dove est entièrement métallique ; il apporte des hélices à vitesse constante, des volets et un train tricycle escamotable. Ses deux moteurs **de Havilland Gipsy Queen** à six cylindres en ligne inversés développent 400 ch dans leurs versions récentes. Pensé pour un entretien facile, avec moteurs, gouvernes et ailes démontables et une cellule en partie collée plutôt que rivetée, il accueille huit à onze passagers et se transforme en avion de liaison, ambulance ou salle de cours volante. Le Devon C.2 de la RAF reçoit des Gipsy Queen 175 et un poste de pilotage revu.\n\n## Carrière opérationnelle\nLa RAF reçoit un premier lot de trente Devon C.1 à partir de 1948 et les emploie pendant plus de trente ans au transport de personnalités et à la liaison, notamment au sein de six escadrons et du Queen''s Flight. La Fleet Air Arm prend en 1955 dix anciens appareils civils sous le nom de Sea Devon C.20, puis trois autres. La Royal New Zealand Air Force acquiert trente Devon entre 1948 et 1954 pour le transport de personnalités, l''entraînement des équipages et la liaison jusque dans les années 1970. L''Argentine, plus gros client du Dove avec soixante-dix appareils, en confie la majorité à sa force aérienne ; l''Inde, l''Irak, l''Égypte, l''Afrique du Sud et une vingtaine d''autres armées l''adoptent aussi.\n\n## Place dans l''histoire\nAvec 127 Devon et 13 Sea Devon construits, le Dove militaire a servi dans les forces armées de plus de vingt pays, et sa cellule allongée a donné le quadrimoteur **de Havilland Heron**. Le type reste aussi lié à des drames : en 1966, le président irakien **Abdul Salam Arif** meurt dans l''accident d''un Dove de l''armée de l''air, que l''on soupçonne d''avoir été saboté ; en 1968, un Dove égyptien disparaît au-dessus du Sahara, et ses neuf occupants meurent de faim avant qu''on ne le retrouve en 1971. Quelques Devon rendus à la vie civile volaient encore en 2011.',
    E'## Genesis\nThe DH.104 Dove answered the Brabazon Committee''s Type VB requirement for a British short-haul feeder airliner after the war. Designed by **Ronald Bishop**''s team, creators of the Mosquito and the **Comet**, it was to succeed the Dragon Rapide biplane and compete with the many military surplus transports such as the **Douglas DC-3**. It first flew on 25 September 1945. While most of the 544 built up to 1967 went to airlines, the armed forces soon made it a communications aircraft: the military Dove 4 became the **Devon** in the Royal Air Force and the **Sea Devon** in the Royal Navy.\n\n## Design\nUnlike the Dragon Rapide, the Dove was all-metal; it introduced constant-speed propellers, flaps and a retractable tricycle undercarriage. Its two six-cylinder inverted inline **de Havilland Gipsy Queen** engines delivered 400 hp in their later versions. Designed for easy maintenance, with removable control surfaces, engines and wings and extensive Redux metal bonding instead of riveting, it seated eight to eleven passengers and could be converted into a communications aircraft, air ambulance or flying classroom. The RAF''s Devon C.2 received Gipsy Queen 175 engines and a revised cockpit.\n\n## Operational career\nThe RAF received an initial batch of thirty Devon C.1s from 1948 and used them for more than thirty years as VIP and communications aircraft, notably with six squadrons and the Queen''s Flight. The Fleet Air Arm took ten former civil aircraft in 1955 as the Sea Devon C.20, later buying three more. The Royal New Zealand Air Force acquired thirty Devons between 1948 and 1954 for VIP, crew-training and light transport duties into the 1970s. Argentina, the largest Dove customer with seventy aircraft, assigned most of them to its air force; India, Iraq, Egypt, South Africa and some twenty other armed forces adopted it too.\n\n## Place in history\nWith 127 Devons and 13 Sea Devons built, the military Dove served with the armed forces of more than twenty countries, and its stretched airframe gave rise to the four-engined **de Havilland Heron**. The type is also linked to tragedies: in 1966 Iraqi President **Abdul Salam Arif** was killed in the crash of an air force Dove, suspected of having been sabotaged; in 1968 an Egyptian Dove went missing over the Sahara, and its nine occupants died of starvation before it was found in 1971. A few civilianised Devons were still flying in 2011.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    NULL,
    '1945-09-25',
    '1948-01-01',
    370,
    1416,
    (SELECT id FROM manufacturer WHERE code = 'DH'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Devon'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.96,
  wingspan          = 17.37,
  height            = 4.06,
  wing_area         = 31.1,
  empty_weight      = 2869,
  mtow              = 4060,
  service_ceiling   = 6614,
  climb_rate        = 5.8,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'de Havilland Gipsy Queen 70 Mk.3 (400 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1946,
  production_end    = 1967,
  units_built       = 140,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 24,
  variants          = E'- **Dove 4** : version militaire de transport et de liaison, base des Devon\n- **Devon C.1** : transport et liaison de la RAF, trente exemplaires livrés à partir de 1948 ; la RNZAF en reçoit trente\n- **Devon C.2** : Devon C.1 remotorisés en Gipsy Queen 175 de 400 ch, avec un poste de pilotage revu\n- **Sea Devon C.20** : transport et liaison de la Royal Navy, treize exemplaires dont dix anciens avions civils\n- **Dove 1 à 8** : versions civiles, de l''avion de ligne de onze places à l''avion d''affaires de cinq places',
  variants_en       = E'- **Dove 4**: military transport and communications version, basis of the Devons\n- **Devon C.1**: RAF transport and communications version, thirty delivered from 1948; the RNZAF received thirty\n- **Devon C.2**: Devon C.1s re-engined with 400 hp Gipsy Queen 175s, with a revised cockpit\n- **Sea Devon C.20**: Royal Navy transport and communications version, thirteen aircraft including ten former civil machines\n- **Dove 1 to 8**: civil versions, from the eleven-seat airliner to the five-seat executive aircraft',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_DH.104',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Dove',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Hodgkins',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'de Havilland Devon';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'de Havilland Devon';
