-- Lockheed C-140 JetStar
--
-- Photo : 61-2491 Lockheed VC-140B Jetstar USAF 58 MAS Greenham Common 22.7.83 (55241837384).jpg
--   licence CC BY-SA 4.0 — Colin Cooke Photo
--   https://commons.wikimedia.org/wiki/File:61-2491_Lockheed_VC-140B_Jetstar_USAF_58_MAS_Greenham_Common_22.7.83_(55241837384).jpg

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
    'Lockheed C-140 JetStar',
    'Lockheed C-140 JetStar',
    'Lockheed C-140 JetStar',
    'Lockheed C-140 JetStar',
    'Quadriréacteur d''affaires de Kelly Johnson, devenu avion de contrôle en vol et parfois Air Force One',
    'Kelly Johnson''s four-engined business jet, turned flight-check aircraft and sometimes Air Force One',
    '/assets/airplanes/c140-jetstar.jpg',
    E'## Genèse\nLe JetStar naît d''un projet privé de Lockheed, d''abord pensé pour un besoin de l''US Air Force abandonné faute de budget. Le travail commence le 6 janvier 1957 sous la direction de **Kelly Johnson**, et le premier prototype vole au-dessus de Burbank le 4 septembre 1957, 241 jours plus tard seulement. Propulsé par deux Bristol Siddeley **Orpheus**, il doit changer de moteurs quand Lockheed échoue à en obtenir la licence de production : le second prototype reçoit en 1959 quatre Pratt & Whitney **JT12**. Présenté à la compétition de l''USAF pour un petit quadriréacteur de liaison, il l''emporte et devient le **C-140**.\n\n## Conception\nLe JetStar se reconnaît à ses quatre réacteurs groupés par paires à l''arrière du fuselage, disposition reprise plus tard par le VC10 et l''Il-62, et à ses gros réservoirs « en pantoufle » fixés à mi-envergure, qui emportent chacun 1 800 kg de carburant. L''aile en flèche de 30° porte des volets de bord d''attaque et des volets à double fente, et tout l''empennage pivote pour régler l''équilibre de l''avion. Grand pour sa catégorie, il offre jusqu''à dix places et une cabine où l''on se tient debout grâce à une allée légèrement creusée.\n\n## Carrière opérationnelle\nL''USAF en est l''un des plus gros clients. Cinq C-140A de l''Air Force Communications Service contrôlent en vol, à partir de 1962, les aides à la navigation des aérodromes ; déployés en Asie du Sud-Est pendant la **guerre du Vietnam**, ils servent aussi de relais radio entre le Pentagone et le champ de bataille en tournant au large des côtes. Onze C-140B transportent du personnel pour le Military Airlift Command ; six d''entre eux, aménagés en VC-140B au 89th Military Airlift Wing d''Andrews, portent souvent **Richard Nixon**, **Gerald Ford**, **Jimmy Carter** et **Ronald Reagan**, et prennent alors l''indicatif Air Force One. Carter utilise tant le sien qu''on le surnomme « Peanut One ».\n\n## Place dans l''histoire\nSeul avion d''affaires jamais développé par Lockheed et l''un des tout premiers au monde, le JetStar montre qu''un jet de liaison peut porter un chef d''État : l''Allemagne de l''Ouest, le Canada, l''Indonésie de **Sukarno**, l''Iran ou l''Arabie saoudite l''adoptent. Le 5 janvier 1995, un JetStar iranien s''écrase et tue le commandant de l''armée de l''air, le général Mansour Sattari. Dans l''USAF, le Pentagone décide en 1983 de remplacer les C-140 vieillissants par le **C-20** Gulfstream, et les derniers C-140A quittent le service au début des années 1990.',
    E'## Genesis\nThe JetStar began as a private Lockheed project, first aimed at a US Air Force requirement later dropped for lack of funds. Design work began on 6 January 1957 under **Kelly Johnson**, and the first prototype flew over Burbank on 4 September 1957, only 241 days later. Powered by two Bristol Siddeley **Orpheus** engines, it had to be re-engined when Lockheed failed to obtain a production licence: in 1959 the second prototype received four Pratt & Whitney **JT12s**. Entered in a USAF competition for a compact four-engined utility aircraft, it won and became the **C-140**.\n\n## Design\nThe JetStar is recognisable by its four engines paired at the rear of the fuselage, an arrangement later used on the VC10 and the Il-62, and by its large "slipper" tanks fixed at mid-span, each holding 1,800 kg of fuel. The 30° swept wing carries leading-edge flaps and double-slotted trailing-edge flaps, and the whole tail pivots to trim the aircraft. Large for its class, it seats up to ten and has a cabin in which one can stand upright thanks to a slightly sunken aisle.\n\n## Operational career\nThe USAF was one of its largest customers. From 1962 five C-140As of the Air Force Communications Service flight-checked airfield navigation aids; deployed to Southeast Asia during the **Vietnam War**, they also loitered off the coast as communications relays between the Pentagon and the battlefield. Eleven C-140Bs carried personnel for Military Airlift Command; six of them, fitted out as VC-140Bs with the 89th Military Airlift Wing at Andrews, often carried **Richard Nixon**, **Gerald Ford**, **Jimmy Carter** and **Ronald Reagan**, using the call sign Air Force One on those flights. Carter used his so much that it was nicknamed "Peanut One".\n\n## Place in history\nThe only business jet Lockheed ever developed, and one of the very first anywhere, the JetStar showed that a liaison jet could carry a head of state: West Germany, Canada, **Sukarno**''s Indonesia, Iran and Saudi Arabia adopted it. On 5 January 1995 an Iranian JetStar crashed, killing the air force commander, General Mansour Sattari. In the USAF, the Pentagon decided in 1983 to replace the ageing C-140s with the **C-20** Gulfstream, and the last C-140As left service in the early 1990s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1957-01-06',
    '1957-09-04',
    '1961-01-01',
    883,
    4000,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed C-140 JetStar'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed C-140 JetStar'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed C-140 JetStar'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 18.41,
  wingspan          = 16.59,
  height            = 6.22,
  wing_area         = 50.4,
  empty_weight      = 11226,
  mtow              = 20185,
  service_ceiling   = 13105,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney JT12A-8',
  engine_count      = 4,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 14.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1961,
  production_end    = NULL,
  units_built       = 16,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 7,
  variants          = E'- **C-140A** : contrôle en vol des aides à la navigation pour l''Air Force Communications Service, cinq construits\n- **C-140B** : transport de personnel du Military Airlift Command, cinq construits\n- **VC-140B** : transport de personnalités du 89th Military Airlift Wing, six construits, utilisés comme Air Force One\n- **C-140C** : deux JetStar 6 commandés par la Navy sous le nom d''UV-1, jamais livrés\n- **JetStar II** : version civile tardive à turbosoufflantes Garrett TFE731, 40 construits de 1976 à 1979',
  variants_en       = E'- **C-140A**: navigation aid flight inspection for the Air Force Communications Service, five built\n- **C-140B**: personnel transport for Military Airlift Command, five built\n- **VC-140B**: VIP transport for the 89th Military Airlift Wing, six built, used as Air Force One\n- **C-140C**: two JetStar 6s ordered by the Navy as the UV-1, never delivered\n- **JetStar II**: late civil version with Garrett TFE731 turbofans, 40 built from 1976 to 1979',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_JetStar',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_JetStar',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Colin Cooke',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Lockheed C-140 JetStar';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed C-140 JetStar';
