-- PZL TS-8 Bies
--
-- Photo : TS-8 Bies.JPG
--   licence CC BY-SA 4.0 — Cezary p
--   https://commons.wikimedia.org/wiki/File:TS-8_Bies.JPG

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
    'PZL TS-8 Bies',
    'PZL TS-8 Bies',
    'PZL TS-8 Bies',
    'PZL TS-8 Bies',
    'Le premier avion moderne conçu en Pologne après la guerre, école des pilotes militaires avant l''Iskra',
    'The first modern aircraft designed in post-war Poland, training military pilots before the Iskra',
    '/assets/airplanes/pzl-ts8-bies.jpg',
    E'## Genèse\nAu début des années 1950, l''armée de l''air polonaise forme ses pilotes sur des **Junak 3** et des **Yak-11** soviétiques. Elle réclame un avion d''entraînement moderne à moteur à pistons, doté d''un train tricycle escamotable. Le projet est confié à l''ingénieur **Tadeusz Sołtyk**, dont les initiales donnent la désignation TS ; l''avion est baptisé **Bies**, nom populaire du diable. Les travaux commencent en 1953 et le premier prototype vole le 23 juillet 1955.\n\n## Conception\nLe TS-8 est un monoplan à aile basse entièrement métallique, au fuselage semi-monocoque de section ovale. Son aile monolongeron en trois parties dessine, vue de face, un W en mouette inversée. L''élève, à l''avant, et l''instructeur, à l''arrière, sont assis en tandem sous des panneaux de verrière coulissants, avec double commande. Le moteur est polonais : un **Narkiewicz WN-3** en étoile à sept cylindres, de 330 ch au décollage, entraînant une hélice bipale en bois à pas variable. L''avion n''est pas armé, sauf la première série, dotée d''une mitrailleuse de 12,7 mm et de deux petits lance-bombes.\n\n## Carrière opérationnelle\nEn 1956 et 1957, le Bies bat trois records internationaux dans sa catégorie, et le second prototype est présenté au Salon de Paris en 1957. Une série expérimentale de dix TS-8 BI sort cette année-là de l''usine WSK-Okęcie ; la version principale, le TS-8 BII, est ensuite produite par WSK Mielec jusqu''en 1960. Les pilotes apprécient sa maniabilité et ses performances, son moteur bruyant étant l''un de ses rares défauts. Le retrait commence au milieu des années 1960, au profit de l''avion-école à réaction **PZL TS-11 Iskra** ; plus d''une centaine d''appareils passent alors aux aéroclubs, et l''Indonésie en reçoit deux, basés à Bandung.\n\n## Place dans l''histoire\nPremier avion vraiment moderne conçu en Pologne après la guerre, et propulsé par un moteur polonais, le TS-8 a montré que l''industrie du pays savait de nouveau concevoir un appareil militaire complet. Construit à 251 exemplaires, dont 229 TS-8 BII, il a formé les pilotes militaires polonais jusqu''à l''arrivée du réacteur. Les aéroclubs l''utilisent jusqu''en 1978, et trois exemplaires sont encore en état de vol.',
    E'## Genesis\nIn the early 1950s the Polish Air Force trained its pilots on **Junak 3s** and Soviet **Yak-11s**. It called for a modern piston-engined trainer with a retractable tricycle undercarriage. The project was entrusted to engineer **Tadeusz Sołtyk**, whose initials gave the designation TS; the aircraft was named **Bies**, a folk name for the devil. Work began in 1953 and the first prototype flew on 23 July 1955.\n\n## Design\nThe TS-8 was an all-metal low-wing monoplane with a semi-monocoque fuselage of oval cross-section. Its three-part single-spar wing formed, seen from the front, an inverted gull W. The pupil in front and the instructor behind sat in tandem beneath sliding canopy sections, with dual controls. The engine was Polish: a seven-cylinder **Narkiewicz WN-3** radial rated at 330 hp for take-off, driving a two-blade wooden variable-pitch propeller. The aircraft was unarmed, except for the first series, fitted with a 12.7 mm machine gun and two small bomb racks.\n\n## Operational career\nIn 1956 and 1957 the Bies set three international records in its class, and the second prototype was shown at the Paris Air Show in 1957. An experimental series of ten TS-8 BIs came from the WSK-Okęcie works that year; the main version, the TS-8 BII, was then built by WSK Mielec until 1960. Pilots liked its handling and performance, its noisy engine being one of its few flaws. Withdrawal began in the mid-1960s in favour of the **PZL TS-11 Iskra** jet trainer; more than a hundred aircraft then went to aero clubs, and Indonesia received two, based at Bandung.\n\n## Place in history\nThe first truly modern aircraft designed in Poland after the war, and powered by a Polish engine, the TS-8 showed that the country''s industry could once again design a complete military aircraft. Built in 251 examples, 229 of them TS-8 BIIs, it trained Polish military pilots until the arrival of the jet. Aero clubs flew it until 1978, and three are still airworthy.',
    (SELECT id FROM countries WHERE code = 'POL'),
    '1953-01-01',
    '1955-07-23',
    '1957-01-01',
    312,
    800,
    (SELECT id FROM manufacturer WHERE code = 'PZL'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL TS-8 Bies'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL TS-8 Bies'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.5,
  wingspan          = 10.5,
  height            = 3.0,
  wing_area         = 19.1,
  empty_weight      = 1070,
  mtow              = 1600,
  service_ceiling   = 6000,
  climb_rate        = 6.8,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Narkiewicz WN-3 (330 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1960,
  units_built       = 251,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **TS-8** : trois prototypes, premier vol le 23 juillet 1955\n- **TS-8 BI** : série expérimentale de dix exemplaires construite par WSK-Okęcie en 1957, armée d''une mitrailleuse de 12,7 mm et de deux lance-bombes\n- **TS-8 BII** : version principale, légèrement améliorée, 229 exemplaires construits à Mielec jusqu''en 1960\n- **TS-8 BIII** : dix derniers exemplaires, à l''avionique améliorée',
  variants_en       = E'- **TS-8**: three prototypes, first flight on 23 July 1955\n- **TS-8 BI**: experimental series of ten built by WSK-Okęcie in 1957, armed with a 12.7 mm machine gun and two bomb racks\n- **TS-8 BII**: slightly improved main version, 229 built at Mielec until 1960\n- **TS-8 BIII**: the last ten aircraft, with improved avionics',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/PZL_TS-8',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/PZL_TS-8_Bies',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Cezary p',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'PZL TS-8 Bies';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'PZL TS-8 Bies';
