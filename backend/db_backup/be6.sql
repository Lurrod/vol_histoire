-- Beriev Be-6
--
-- Photo : Бе-6.JPG
--   licence CC BY 3.0 — Михаил Фетисов
--   https://commons.wikimedia.org/wiki/File:%D0%91%D0%B5-6.JPG

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
    'Beriev Be-6',
    'Beriev Be-6',
    'Beriev Be-6',
    'Beriev Be-6',
    'Grand hydravion de patrouille soviétique de l''après-guerre, à aile en mouette et tourelles de 23 mm',
    'The great Soviet post-war patrol flying boat, with a gull wing and 23 mm turrets',
    '/assets/airplanes/beriev-be6.jpg',
    E'## Genèse\nEn 1945, le bureau d''études de **Gueorgui Beriev** entreprend un hydravion de reconnaissance et de bombardement. Le prototype, baptisé LL-143, reçoit deux moteurs en étoile **Chvetsov ASh-72** et un armement défensif en tourelles. Mis en production sous le nom de Be-6, l''appareil sort de l''usine Beriev de Taganrog à partir de 1949, année où vole la première machine de série. L''OTAN le baptise **Madge** ; le Pentagone l''a d''abord désigné « Type 34 ».\n\n## Conception\nLe Be-6 est un hydravion à coque entièrement métallique, hormis les gouvernes de direction et les ailerons entoilés. Son aile en mouette porte les deux moteurs **ASh-73TK** dans ses coudes et des flotteurs fixés sous la voilure, chacun divisé en quatre compartiments étanches ; deux dérives ovales coiffent un fuselage profond. Cinq canons **NR-23** de 23 mm sont répartis dans trois tourelles télécommandées, et l''avion peut emporter deux torpilles de 1 000 kg, huit mines ou des bombes. La série reçoit un radôme escamotable sous la coque, puis une perche de **détecteur d''anomalie magnétique** à la place de la tourelle de queue.\n\n## Carrière opérationnelle\nPolyvalent, le Be-6 assure la reconnaissance maritime lointaine, la surveillance des côtes et des lignes de ravitaillement, les attaques à la torpille ou à la bombe, le minage et le transport. Les besoins de l''aéronavale soviétique évoluant lentement, cet avion fiable patrouille jusqu''à la fin des années 1960, avant de finir comme transport désarmé dans l''Arctique ou pour la surveillance des pêches. La **marine chinoise**, qui l''apprécie pour surveiller son immense littoral, remotorise plusieurs exemplaires de turbopropulseurs dans les années 1970, sous le nom de Qing-6.\n\n## Place dans l''histoire\nConstruit à 123 exemplaires jusqu''en 1957 et décliné en 19 variantes, le Be-6 est le grand hydravion de patrouille soviétique de l''après-guerre. Au 977e régiment de reconnaissance navale à long rayon d''action, en Crimée, il cède d''abord la place à l''hydravion à réaction Be-10, puis l''amphibie à turbopropulseurs **Be-12 Chaïka**, qui en dérive directement, prend la relève. Un exemplaire est préservé au musée d''État de l''aviation de Kiev, en Ukraine.',
    E'## Genesis\nIn 1945 **Georgy Beriev**''s design bureau began work on a reconnaissance and bomber flying boat. The prototype, named LL-143, was fitted with two **Shvetsov ASh-72** radial engines and defensive armament in turrets. Put into production as the Be-6, the aircraft was built at Beriev''s Taganrog plant from 1949, the year the first production machine flew. NATO named it **Madge**; the Pentagon had first designated it "Type 34".\n\n## Design\nThe Be-6 was an all-metal flying boat, apart from its fabric-covered rudders and ailerons. Its gull wing carried the two **ASh-73TK** engines in its bends and floats mounted beneath the wing, each divided into four watertight compartments; twin oval fins topped a deep fuselage. Five 23 mm **NR-23** cannon were spread across three remotely controlled turrets, and the aircraft could carry two 1,000 kg torpedoes, eight mines or bombs. Production aircraft received a retractable radome under the hull, and later a **magnetic anomaly detector** boom in place of the tail turret.\n\n## Operational career\nVersatile, the Be-6 flew long-range maritime reconnaissance, coastal and supply-line patrols, torpedo and bombing strikes, mine-laying and transport missions. As Soviet naval requirements changed slowly, the reliable aircraft kept patrolling until the late 1960s, before ending its days as an unarmed transport in the Arctic or on fishery surveillance. The Chinese **People''s Liberation Army Navy**, which found it valuable for patrolling its long coastline, re-engined several examples with turboprops in the 1970s under the name Qing-6.\n\n## Place in history\nBuilt in 123 examples up to 1957 and produced in 19 variants, the Be-6 was the great Soviet patrol flying boat of the post-war years. In the 977th long-range naval reconnaissance regiment, in Crimea, it first gave way to the Be-10 jet flying boat, before the turboprop **Be-12 Chaika** amphibian, developed directly from it, took over. One example is preserved at the State Aviation Museum in Kyiv, Ukraine.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1945-01-01',
    '1949-01-01',
    NULL,
    414,
    4800,
    (SELECT id FROM manufacturer WHERE code = 'BER'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev Be-6'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-6'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-6'), (SELECT id FROM tech WHERE name = 'Détecteur d''anomalie magnétique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev Be-6'), (SELECT id FROM armement WHERE name = 'NR-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev Be-6'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-6'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-6'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev Be-6'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.5,
  wingspan          = 33.0,
  height            = 7.64,
  wing_area         = 120,
  empty_weight      = 18827,
  mtow              = 29000,
  service_ceiling   = 6100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 8,

  -- Strate 2 : motorisation
  engine_name       = 'Chvetsov ASh-73TK (2 400 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1957,
  units_built       = 123,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **LL-143** : prototype à moteurs Chvetsov ASh-72, armé en tourelles de nez, de flanc, ventrale et de queue\n- **Be-6** : version de série à moteurs ASh-73TK, tourelle de nez supprimée, radôme escamotable sous la coque\n- **Be-6 de lutte anti-sous-marine** : perche de détecteur d''anomalie magnétique à la place de la tourelle de queue\n- **Qing-6** : Be-6 de la marine chinoise remotorisés de turbopropulseurs dans les années 1970',
  variants_en       = E'- **LL-143**: prototype with Shvetsov ASh-72 engines, armed with nose, beam, ventral and tail positions\n- **Be-6**: production version with ASh-73TK engines, nose turret deleted, retractable radome under the hull\n- **Anti-submarine Be-6**: magnetic anomaly detector boom in place of the tail turret\n- **Qing-6**: Chinese Navy Be-6s re-engined with turboprops in the 1970s',

  -- Strate 4 : qualitatif
  nickname          = 'Madge',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beriev_Be-6',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beriev_Be-6',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Михаил Фетисов',
  image_licence     = 'CC BY 3.0'
WHERE name = 'Beriev Be-6';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beriev Be-6';
