-- Canadair CL-84 Dynavert (CX-131)
--
-- Photo : 23 0071283 Convair Negative Image - CL-84 hovering 09-11-1968 (54235044857).jpg
--   licence Public domain — San Diego Air & Space Museum Archives
--   https://commons.wikimedia.org/wiki/File:23_0071283_Convair_Negative_Image_-_CL-84_hovering_09-11-1968_(54235044857).jpg

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
    'Canadair CL-84 Dynavert',
    'Canadair CL-84 Dynavert',
    'Canadair CL-84 Dynavert (CX-131)',
    'Canadair CL-84 Dynavert (CX-131)',
    'Une aile qui pivote d’un bloc : le convertible canadien que personne n’a commandé',
    'A wing that tilts as one piece: the Canadian convertiplane nobody ordered',
    '/assets/airplanes/cl84-dynavert.jpg',
    E'## Genèse\nÀ la fin des années 1950, Canadair consacre plusieurs années de recherche au décollage vertical. Sous la direction de son ingénieur en chef **Frederick Phillips**, l''entreprise écarte les réacteurs de sustentation au profit d''une **aile basculante** portant moteurs et hélices : l''avion décolle aile relevée, puis l''abaisse progressivement pour voler comme un appareil classique. Le gouvernement canadien participe au financement d''un prototype.\n\n## Conception\nL''aile et ses deux turbopropulseurs **Lycoming T53** de 1 500 ch pivotent d''un bloc sur 100°, par commande hydromécanique. Les deux hélices sont reliées par un arbre de transmission, pour qu''une panne de moteur ne fasse pas chavirer l''appareil ; deux petits rotors horizontaux contrarotatifs dans la queue contrôlent le tangage en vol stationnaire. L''avion peut emporter douze passagers ; il se pilote comme un hélicoptère à basse vitesse et comme un avion au-delà.\n\n## Carrière opérationnelle\nLe prototype effectue son premier vol stationnaire le 7 mai 1965, aux mains de **Bill Longhurst**. Il est perdu le 12 septembre 1967 à la suite d''une défaillance mécanique ; l''équipage s''éjecte sain et sauf. Trois CL-84-1 améliorés sont construits ; des pilotes canadiens, américains et britanniques les évaluent à Patuxent River, et en 1973 l''un d''eux opère depuis le porte-hélicoptères **USS Guam**. Un second appareil s''écrase le 8 août 1973, là encore sans victime. Aucune commande ne suit et le programme s''arrête en 1974.\n\n## Place dans l''histoire\nComme le **LTV XC-142** américain contemporain, le CL-84 a montré que la voilure basculante pouvait être maîtrisée en vol de transition, avec des évaluations militaires largement favorables. Il est arrivé avant que le besoin ne soit formulé : la mission dont il rêvait sera remplie trente ans plus tard par le **V-22 Osprey**, à rotors basculants. Deux exemplaires sont conservés, à Ottawa et à Winnipeg.',
    E'## Genesis\nIn the late 1950s Canadair devoted several years of research to vertical take-off. Under its chief engineer **Frederick Phillips**, the company set aside lift jets in favour of a **tilt wing** carrying engines and propellers: the aircraft takes off with the wing raised, then gradually lowers it to fly like a conventional aeroplane. The Canadian government helped fund a prototype.\n\n## Design\nThe wing and its two 1,500 shp **Lycoming T53** turboprops pivot as a single unit through 100°, under hydro-mechanical control. The two propellers are linked by a drive shaft so that an engine failure cannot roll the aircraft over; two small contra-rotating horizontal rotors in the tail control pitch in the hover. The aircraft can carry twelve passengers; it flies like a helicopter at low speed and like an aeroplane beyond.\n\n## Operational career\nThe prototype made its first hover on 7 May 1965, flown by **Bill Longhurst**. It was lost on 12 September 1967 after a mechanical failure; the crew ejected safely. Three improved CL-84-1s were built; Canadian, American and British pilots evaluated them at Patuxent River, and in 1973 one operated from the helicopter carrier **USS Guam**. A second aircraft crashed on 8 August 1973, again without loss of life. No order followed and the programme ended in 1974.\n\n## Place in history\nLike the contemporary American **LTV XC-142**, the CL-84 showed that the tilt wing could be mastered through transition, with largely favourable military evaluations. It arrived before the requirement had been written: the mission it was built for would be filled thirty years later by the tiltrotor **V-22 Osprey**. Two examples are preserved, in Ottawa and Winnipeg.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1957-01-01',
    '1965-05-07',
    NULL,
    517.0,
    678.0,
    (SELECT id FROM manufacturer WHERE code = 'CDR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CL-84 Dynavert'), (SELECT id FROM tech WHERE name = 'Aile à incidence variable'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CL-84 Dynavert'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Canadair CL-84 Dynavert'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CL-84 Dynavert'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.41,
  wingspan          = 10.46,
  height            = 4.34,
  wing_area         = NULL,
  empty_weight      = 3818,
  mtow              = 6577,
  service_ceiling   = NULL,
  climb_rate        = 21.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming T53-LTC1K-4A',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur à voilure basculante',
  engine_type_en    = 'Tilt-wing turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1964,
  production_end    = 1972,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **CL-84** : prototype, premier vol stationnaire le 7 mai 1965, perdu le 12 septembre 1967\n- **CL-84-1 (CX-131)** : trois exemplaires améliorés destinés à l''évaluation militaire\n- **Aile basculante sur 100°**, hélices interconnectées par arbre de transmission\n- **Essais embarqués** sur le porte-hélicoptères **USS Guam** en 1973\n- Deux survivants, au Musée de l''aviation et de l''espace du Canada (Ottawa) et à Winnipeg',
  variants_en       = E'- **CL-84** : prototype, first hover on 7 May 1965, lost on 12 September 1967\n- **CL-84-1 (CX-131)** : three improved aircraft for military evaluation\n- **Wing tilting through 100°**, propellers cross-linked by a drive shaft\n- **Shipboard trials** on the helicopter carrier **USS Guam** in 1973\n- Two survivors, at the Canada Aviation and Space Museum (Ottawa) and in Winnipeg',

  -- Strate 4 : qualitatif
  nickname          = 'Dynavert',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Canadair_CL-84',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Canadair_CL-84_Dynavert',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'San Diego Air & Space Museum Archives',
  image_licence     = 'Public domain'
WHERE name = 'Canadair CL-84 Dynavert';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Canadair CL-84 Dynavert';
