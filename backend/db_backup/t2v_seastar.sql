-- Lockheed T2V-1 (T-1A) SeaStar
--
-- Photo : T-1A USMC in flight 1964.jpeg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:T-1A_USMC_in_flight_1964.jpeg

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
    'Lockheed T2V SeaStar',
    'Lockheed T2V SeaStar',
    'Lockheed T2V-1 (T-1A) SeaStar',
    'Lockheed T2V-1 (T-1A) SeaStar',
    'Le T-33 entièrement repensé pour le porte-avions : crosse, train renforcé et siège d''instructeur surélevé',
    'The T-33 fully re-engineered for the carrier: arrester hook, strengthened undercarriage and raised instructor''s seat',
    '/assets/airplanes/t2v-seastar.jpg',
    E'## Genèse\nDepuis 1949, l''**US Navy** forme ses pilotes au vol à réaction sur le **Lockheed T-33**, version biplace du chasseur P-80 Shooting Star, qu''elle désigne d''abord TO-2 puis TV-2. L''avion convient à l''entraînement depuis la terre ferme, mais il ne peut pas opérer depuis un porte-avions. Ce besoin persistant d''un avion d''entraînement embarqué conduit Lockheed à pousser plus loin la famille P-80/T-33 sous la désignation constructeur **L-245**, devenue **T2V** dans la marine. Le démonstrateur vole le 16 décembre 1953, et les livraisons d''appareils de série commencent en 1956.\n\n## Conception\nPar rapport au TV-2, le T2V est presque entièrement redessiné pour l''appontage et la vie en mer. Il reçoit un empennage modifié, une avionique aux normes de la marine, un train renforcé muni de ferrures de catapultage et un bas de fuselage consolidé qui abrite une **crosse d''appontage** escamotable. Des becs de bord d''attaque motorisés augmentent la portance à basse vitesse pour les catapultages et les appontages, et le siège arrière de l''instructeur est surélevé pour lui donner une meilleure vue. Contrairement aux autres dérivés du P-80, il encaisse le choc d''un appontage sur un pont en mouvement et résiste mieux à l''humidité et au sel. Son réacteur Allison J33 de 27 kN le pousse à 933 km/h à 10 670 m d''altitude.\n\n## Carrière opérationnelle\nLe SeaStar entre en service en mai 1957 sous la désignation **T2V-1**, la seule version produite. Il sert dans les groupes d''entraînement de la marine, notamment à Pensacola en Floride, ainsi que dans le **corps des Marines**. En 1962, le système unifié de désignation des trois armées le rebaptise **T-1A SeaStar**, nom sous lequel il passe l''essentiel de sa carrière. Remplacé par le **T-2 Buckeye**, il reste néanmoins en service jusque dans les années 1970.\n\n## Place dans l''histoire\nLe SeaStar est l''aboutissement naval de la lignée née avec le chasseur à réaction **P-80 Shooting Star**, dont il est le dérivé le plus profondément transformé. Il montre combien il faut transformer un avion terrestre pour l''adapter au porte-avions : structure, train, voilure et poste de pilotage ont tous été repris. En 2017, un exemplaire vole encore à Mesa, en Arizona, pour des démonstrations, et deux autres sont exposés à Tucson.',
    E'## Genesis\nFrom 1949 the **US Navy** trained its pilots in jet flying on the **Lockheed T-33**, the two-seat version of the P-80 Shooting Star fighter, which it designated first TO-2 and then TV-2. The aircraft suited land-based training, but it could not operate from an aircraft carrier. That persistent need for a carrier-capable trainer led Lockheed to take the P-80/T-33 family further under the company designation **L-245**, which became the **T2V** in Navy service. The demonstrator flew on 16 December 1953, and production deliveries began in 1956.\n\n## Design\nCompared with the TV-2, the T2V was almost totally re-engineered for carrier landings and life at sea. It received a redesigned tail, Navy-standard avionics, a strengthened undercarriage with catapult fittings and a reinforced lower fuselage housing a retractable **arrester hook**. Power-operated leading-edge flaps increased lift at low speed for catapult launches and recoveries, and the instructor''s rear seat was raised to give him a better view. Unlike other P-80 derivatives, it could withstand the shock of landing on a pitching deck and coped better with humidity and salt. Its 27 kN Allison J33 turbojet drove it to 933 km/h at 10,670 m.\n\n## Operational career\nThe SeaStar entered service in May 1957 as the **T2V-1**, the only version produced. It served with the Navy''s training groups, notably at Pensacola in Florida, and with the **Marine Corps**. In 1962 the unified tri-service designation system renamed it the **T-1A SeaStar**, the name under which it spent most of its career. Replaced by the **T-2 Buckeye**, it nevertheless remained in service into the 1970s.\n\n## Place in history\nThe SeaStar is the naval culmination of the line born with the **P-80 Shooting Star** jet fighter, and its most thoroughly transformed derivative. It shows how much a land aircraft must be transformed to suit the carrier: structure, undercarriage, wing and cockpit were all reworked. In 2017 one example was still flying at Mesa, Arizona, for display purposes, and two more are on show in Tucson.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1953-12-16',
    '1957-05-01',
    933,
    1560,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed T2V SeaStar'), (SELECT id FROM tech WHERE name = 'Système de décollage et d''atterrissage sur porte-avions')),
((SELECT id FROM airplanes WHERE name = 'Lockheed T2V SeaStar'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed T2V SeaStar'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.75,
  wingspan          = 13.06,
  height            = 4.06,
  wing_area         = 22.3,
  empty_weight      = 5427,
  mtow              = 7636,
  service_ceiling   = 12190,
  climb_rate        = 32.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J33-A-24/24A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 27.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **L-245** : démonstrateur Lockheed, premier vol le 16 décembre 1953\n- **T2V-1** : unique version de série, livrée à l''US Navy à partir de 1956\n- **T-1A SeaStar** : désignation du T2V-1 à partir de 1962\n- Dérivé du **T-33 / TV-2**, lui-même issu du chasseur **P-80 Shooting Star**',
  variants_en       = E'- **L-245**: Lockheed demonstrator, first flown on 16 December 1953\n- **T2V-1**: sole production version, delivered to the US Navy from 1956\n- **T-1A SeaStar**: designation of the T2V-1 from 1962\n- Derived from the **T-33 / TV-2**, itself developed from the **P-80 Shooting Star** fighter',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_T2V_SeaStar',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_T2V_SeaStar',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed T2V SeaStar';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed T2V SeaStar';
