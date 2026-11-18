-- NASA M2-F1
--
-- Photo : M2-F1 in flight over lakebed on tow line (EC63-229).jpg
--   licence Public domain — NASA Armstrong Flight Research Center / NASA
--   https://commons.wikimedia.org/wiki/File:M2-F1_in_flight_over_lakebed_on_tow_line_(EC63-229).jpg

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
    'NASA M2-F1',
    'NASA M2-F1',
    'NASA M2-F1',
    'NASA M2-F1',
    'La « baignoire volante » en contreplaqué qui a prouvé qu''un corps portant sans ailes pouvait se poser',
    'The plywood ''flying bathtub'' that proved a wingless lifting body could land',
    '/assets/airplanes/nasa-m2f1.jpg',
    E'## Genèse\nNé au milieu des années 1950 au laboratoire **Ames** du NACA, le **corps portant** doit ramener un engin spatial sur une piste après la rentrée atmosphérique : sans ailes, il souffre moins de l''échauffement, et sa manœuvrabilité lui ouvre une zone d''atterrissage grande comme la Californie, là où une capsule balistique n''a presque aucune latitude. En février 1962, une série de formes est prête et l''ingénieur **R. Dale Reed**, du Flight Research Center d''Edwards, cherche des soutiens pour un véhicule d''essai. La direction du centre approuve la même année un prototype léger et sans moteur, le M2-F1 : M pour *manned* (piloté), F pour *flight* (version de vol).\n\n## Conception\nLe M2-F1 est bâti avec un budget de 30 000 dollars, avec l''aide d''un fabricant local de planeurs, la **Briegleb Glider Company**. Les ateliers de la NASA réalisent l''armature en tubes d''acier ; **Gus Briegleb** façonne à la main la coque en contreplaqué d''acajou, aidé par **Ernie Lowder**, qui avait travaillé sur l''hydravion géant de Howard Hughes. Sa silhouette lui vaut le surnom de « **baignoire volante** ». Il reçoit ensuite un siège éjectable et, à l''arrière, une petite fusée à poudre, l''« instant L/D », qui prolonge l''arrondi d''environ cinq secondes.\n\n## Essais\nLes premiers essais se font au bout d''un câble tiré par une **Pontiac Catalina** cabriolet sur le lac asséché de Rogers. Le 5 avril 1963, **Milt Thompson** lève le nez à 138 km/h, mais l''engin rebondit : on relie le manche aux élevons plutôt qu''à la gouverne de direction, et la voiture, gonflée par un préparateur, le hisse à 6 m pour une vingtaine de secondes de vol plané. Le 16 août 1963, un **R4D** de la Navy le remorque pour la première fois : largué à 3 700 m, il plane environ deux minutes, pique à 240 km/h à 300 m du sol puis arrondit à 60 m. Jusqu''au 16 août 1966, il totalise plus de 400 remorquages au sol et 77 vols remorqués par avion, pilotés notamment par Thompson, **Bruce Peterson** et **Chuck Yeager**.\n\n## Place dans l''histoire\nLe M2-F1 a démontré qu''un corps portant pouvait se poser à l''horizontale et ouvert la voie aux corps portants « lourds » en métal : le **Northrop M2-F2** et le **Northrop HL-10** de la NASA, puis le **X-24** de l''US Air Force. Le programme a fortement influencé celui de la **navette spatiale**. Il a aussi prouvé qu''un prototype de recherche pouvait donner des résultats rapides pour un coût dérisoire, environ 50 000 dollars hors salaires des agents de l''État. L''unique exemplaire, immatriculé N86652, est exposé au musée des essais en vol de l''US Air Force, sur la base d''Edwards.',
    E'## Genesis\nBorn in the mid-1950s at the NACA''s **Ames** laboratory, the **lifting body** was meant to bring a spacecraft back to a runway after re-entry: without wings it suffered less from heating, and its manoeuvrability gave it a landing footprint the size of California, where a ballistic capsule had almost no latitude. By February 1962 a series of shapes was ready and engineer **R. Dale Reed**, of the Flight Research Center at Edwards, was seeking support for a research vehicle. The centre''s management approved a light, unpowered prototype that same year: the M2-F1, M for ''manned'' and F for ''flight'' version.\n\n## Design\nThe M2-F1 was built on a $30,000 budget with the help of a local glider maker, the **Briegleb Glider Company**. NASA craftsmen made the tubular steel frame; **Gus Briegleb** handmade the mahogany plywood shell, helped by **Ernie Lowder**, who had worked on Howard Hughes''s giant flying boat. Its shape earned it the nickname ''**flying bathtub**''. It later received an ejection seat and, in the tail, a small solid rocket, the ''instant L/D'', which could stretch the landing flare by about five seconds.\n\n## Testing\nThe first tests were made at the end of a rope towed by a **Pontiac Catalina** convertible across Rogers Dry Lake. On 5 April 1963 **Milt Thompson** lifted the nose at 138 km/h, but the craft bounced: the stick was rewired to the elevons rather than the rudder, and the car, hot-rodded by a tuner, pulled it up to 6 m for some twenty seconds of gliding. On 16 August 1963 a Navy **R4D** towed it aloft for the first time: released at 3,700 m, it glided for about two minutes, dived to 240 km/h at 300 m and flared at 60 m. By 16 August 1966 it had made over 400 ground tows and 77 air-tow flights, flown among others by Thompson, **Bruce Peterson** and **Chuck Yeager**.\n\n## Place in history\nThe M2-F1 proved that a lifting body could land horizontally and paved the way for the metal ''heavyweight'' lifting bodies: NASA''s **Northrop M2-F2** and **Northrop HL-10**, then the US Air Force **X-24**. The programme heavily influenced the **Space Shuttle**. It also showed that a research prototype could deliver rapid results at very low cost, about $50,000 excluding the salaries of government staff. The sole example, registered N86652, is displayed at the Air Force Flight Test Museum at Edwards.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1962-01-01',
    '1963-08-16',
    NULL,
    240,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'NASA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'NASA M2-F1'), (SELECT id FROM tech WHERE name = 'Corps portant'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'NASA M2-F1'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 6.1,
  wingspan          = 4.32,
  height            = 2.9,
  wing_area         = 12.9,
  empty_weight      = 454,
  mtow              = 567,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Fusée d''appoint à poudre « instant L/D » (1,1 kN, 5 s)',
  engine_count      = 1,
  engine_type       = 'Planeur à fusée d''appoint',
  engine_type_en    = 'Glider with auxiliary rocket',
  thrust_dry        = 1.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = 50000,
  unit_cost_year    = 1963,
  operators_count   = 1,
  variants          = E'- **M2-F1 (N86652)** : exemplaire unique, coque en contreplaqué d''acajou sur armature en tubes d''acier\n- **Remorquage par automobile** : plus de 400 essais derrière une Pontiac Catalina préparée, sur le lac asséché de Rogers\n- **Remorquage par avion** : 77 vols derrière un R4D de la Navy, largage à 3 700 m\n- **Train Cessna 180** : remplace le train d''origine de Cessna 150\n- **Northrop M2-F2 / M2-F3** : successeurs métalliques « lourds » propulsés par moteur-fusée',
  variants_en       = E'- **M2-F1 (N86652)**: sole example, mahogany plywood shell on a tubular steel frame\n- **Car tow**: more than 400 tests behind a hot-rodded Pontiac Catalina on Rogers Dry Lake\n- **Air tow**: 77 flights behind a Navy R4D, released at 3,700 m\n- **Cessna 180 landing gear**: replaced the original Cessna 150 gear\n- **Northrop M2-F2 / M2-F3**: rocket-powered metal ''heavyweight'' successors',

  -- Strate 4 : qualitatif
  nickname          = 'Flying Bathtub',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/NASA_M2-F1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/NASA_M2-F1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA Armstrong Flight Research Center',
  image_licence     = 'Public domain'
WHERE name = 'NASA M2-F1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'NASA M2-F1';
