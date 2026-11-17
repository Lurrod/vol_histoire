-- de Havilland Canada DHC-1 Chipmunk
--
-- Photo : De Havilland DHC-1 Chipmunk flying slightly overhead.jpg
--   licence Public domain — Pseudopanax at English Wikipedia
--   https://commons.wikimedia.org/wiki/File:De_Havilland_DHC-1_Chipmunk_flying_slightly_overhead.jpg

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
    'DHC-1 Chipmunk',
    'DHC-1 Chipmunk',
    'de Havilland Canada DHC-1 Chipmunk',
    'de Havilland Canada DHC-1 Chipmunk',
    'Le successeur canadien du Tiger Moth, première école de la RAF pendant quarante ans et avion espion à Berlin',
    'The Canadian successor to the Tiger Moth, the RAF''s first trainer for forty years and a spy plane over Berlin',
    '/assets/airplanes/dhc1-chipmunk.jpg',
    E'## Genèse\nAu lendemain de la Seconde Guerre mondiale, l''industrie aéronautique canadienne, gonflée par la guerre, cherche de nouveaux marchés. **de Havilland Canada** décide de dessiner son premier avion bien à elle : un avion d''école moderne pour succéder au biplan **Tiger Moth**, construit par milliers pendant le conflit. L''équipe est dirigée par **Wsiewołod Jakimiuk**, ingénieur polonais d''avant-guerre. Le prototype vole le 22 mai 1946 à Downsview, près de Toronto, piloté par **Pat Fillingham**, prêté par la maison mère britannique.\n\n## Conception\nLe Chipmunk est un monoplan à aile basse, biplace en tandem, à train classique et moteur **de Havilland Gipsy Major** de 145 ch. Sa cellule à revêtement travaillant en alliage d''aluminium permet une aile plus fine que celle des écoles de l''époque. Tout est pensé pour l''instruction : verrière coulissante qui offre une vue dégagée à l''instructeur assis derrière, bandes de décrochage qui font décrocher l''emplanture avant le bout d''aile, ailettes anti-vrille, volets, freins à disque et radio. Les versions britanniques, construites à la demande de la RAF, sont entièrement voltigeables, et il reste réputé pour son pilotage doux et précis.\n\n## Carrière opérationnelle\nAprès évaluation à Boscombe Down, le ministère de l''Air britannique rédige autour de lui la spécification T.8/48 : la **RAF** en reçoit 735, construits en Angleterre, pour former ses débutants, ses escadrons universitaires et ses cadets. En 1958, quelques Chipmunk acheminés en soute de **Blackburn Beverley** assurent des patrouilles de sécurité à Chypre. Surtout, de 1956 à 1990, ceux de RAF Gatow mènent des missions de reconnaissance discrète au-dessus de Berlin pour la mission militaire BRIXMIS. Le Canada l''emploie jusqu''en 1972, le Portugal en construit 66 sous licence et en vole encore en 2018 ; la RAF le remplace par le **Bulldog** en 1996.\n\n## Place dans l''histoire\nConstruit à 1 284 exemplaires, dont 1 000 au Royaume-Uni, le Chipmunk est le premier avion conçu au Canada à être produit sous licence à l''étranger. Il a donné leur premier vol à des générations de pilotes militaires de la guerre froide, dont le **prince Philip** en 1952. Des centaines volent encore dans le monde, en voltige, en remorquage de planeurs ou au sein des escadrilles historiques britanniques.',
    E'## Genesis\nIn the aftermath of the Second World War, Canada''s aircraft industry, swollen by the war, was looking for new markets. **de Havilland Canada** decided to design its very own first aircraft: a modern trainer to succeed the **Tiger Moth** biplane, built by the thousands during the conflict. The team was led by **Wsiewołod Jakimiuk**, a pre-war Polish engineer. The prototype flew on 22 May 1946 at Downsview, near Toronto, flown by **Pat Fillingham**, seconded from the British parent company.\n\n## Design\nThe Chipmunk was a low-wing tandem two-seat monoplane with a tailwheel undercarriage and a 145 hp **de Havilland Gipsy Major** engine. Its stressed-skin aluminium alloy airframe allowed a thinner wing than the trainers of the day. Everything was designed for instruction: a sliding canopy giving the instructor in the rear seat a clear view, stall-breaker strips that made the wing root stall before the tip, anti-spin strakes, flaps, disc brakes and a radio. The British-built versions, made to RAF requirements, were fully aerobatic, and the type remains renowned for its gentle and precise handling.\n\n## Operational career\nAfter evaluation at Boscombe Down, the British Air Ministry wrote specification T.8/48 around it: the **RAF** received 735, built in England, to train its beginners, university air squadrons and cadets. In 1958 a few Chipmunks, carried in the holds of **Blackburn Beverley** transports, flew internal security patrols in Cyprus. Above all, from 1956 to 1990 those of RAF Gatow flew covert reconnaissance missions over Berlin for the BRIXMIS military mission. Canada used it until 1972, Portugal built 66 under licence and was still flying it in 2018; the RAF replaced it with the **Bulldog** in 1996.\n\n## Place in history\nBuilt to 1,284 aircraft, including 1,000 in the United Kingdom, the Chipmunk was the first Canadian-designed aircraft to be built under licence abroad. It gave generations of Cold War military pilots their first flight, including **Prince Philip** in 1952. Hundreds still fly around the world, for aerobatics, glider towing or with the British historic flights.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1945-01-01',
    '1946-05-22',
    '1948-01-01',
    222,
    417,
    (SELECT id FROM manufacturer WHERE code = 'DHC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-1 Chipmunk'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'DHC-1 Chipmunk'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-1 Chipmunk'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.75,
  wingspan          = 10.46,
  height            = 2.16,
  wing_area         = 16.0,
  empty_weight      = 688,
  mtow              = 998,
  service_ceiling   = 4800,
  climb_rate        = 4.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'de Havilland Gipsy Major 1C (145 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 1961,
  units_built       = 1284,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **DHC-1A et DHC-1B** : versions canadiennes, semi-voltigeables puis entièrement voltigeables, Gipsy Major 1C ou 10\n- **Chipmunk T.2** : version canadienne de l''ARC pour l''entraînement de rappel des réservistes\n- **Chipmunk T.10** : version britannique de la RAF à Gipsy Major 8, 735 exemplaires\n- **Chipmunk Mk 20** : version militaire d''exportation, dont 66 construits au Portugal par OGMA\n- **Mk 21 à Mk 23** : versions civiles et conversions, dont cinq appareils d''épandage agricole',
  variants_en       = E'- **DHC-1A and DHC-1B**: Canadian versions, semi-aerobatic then fully aerobatic, Gipsy Major 1C or 10\n- **Chipmunk T.2**: Canadian RCAF version for reservist refresher training\n- **Chipmunk T.10**: British RAF version with Gipsy Major 8, 735 built\n- **Chipmunk Mk 20**: military export version, including 66 built in Portugal by OGMA\n- **Mk 21 to Mk 23**: civil versions and conversions, including five crop-spraying aircraft',

  -- Strate 4 : qualitatif
  nickname          = 'Chippie',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Canada_DHC-1_Chipmunk',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Canada_DHC-1_Chipmunk',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Pseudopanax',
  image_licence     = 'Public domain'
WHERE name = 'DHC-1 Chipmunk';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'DHC-1 Chipmunk';
