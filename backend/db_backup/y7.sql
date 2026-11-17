-- Xi'an Y-7 (Yunshuji-7)
--
-- Photo : B-3453 Xian Yunshuji Y-7-100C China Eastern (11565080645).jpg
--   licence CC BY-SA 3.0 — Aeroprints.com
--   https://commons.wikimedia.org/wiki/File:B-3453_Xian_Yunshuji_Y-7-100C_China_Eastern_(11565080645).jpg

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
    'Xian Y-7',
    'Xian Y-7',
    'Xi''an Y-7 (Yunshuji-7)',
    'Xi''an Y-7 (Yunshuji-7)',
    'L''An-24 fabriqué sous licence en Chine, dix-huit ans après l''accord, puis décliné jusqu''au MA60',
    'The An-24 built under licence in China, eighteen years after the deal, then developed into the MA60',
    '/assets/airplanes/xian-y7.jpg',
    E'## Genèse\nLa Chine importe l''**Antonov An-24** dès le début de sa production et négocie les licences de l''avion et de ses moteurs. En 1966, l''usine aéronautique de **Xi''an** lance la fabrication locale. Le premier An-24T assemblé en Chine vole le 25 décembre 1970, mais la **Révolution culturelle** freine tout : la production n''est lancée qu''en 1977, un avion de présérie n''est montré au public que le 17 avril 1982 sur la base de Nanyuan, près de Pékin, et le premier appareil de série ne vole qu''en février 1984. Dix-huit ans séparent la licence de la production.\n\n## Conception\nLe Y-7 correspond à l''**An-24RV**, avec ses hublots au complet et son réacteur d''appoint ; il est propulsé par deux turbopropulseurs **Dongan WJ-5A** entraînant des hélices quadripales. La version **Y-7-100**, mise au point avec la société HAECO de Hong Kong, reçoit un poste de pilotage et une cabine redessinés, des winglets et une avionique occidentale : trois navigants suffisent et 52 passagers prennent place. Elle atteint 503 km/h et franchit près de 2 000 km avec le plein.\n\n## Carrière opérationnelle\nLes premières livraisons vont surtout à l''armée de l''air chinoise, essentiellement comme transports, et quelques exemplaires de 52 places à la compagnie nationale CAAC. L''aviation de l''armée de terre et l''aéronavale chinoises l''adoptent à leur tour, tout comme les forces aériennes iranienne, laotienne et mauritanienne. L''armée de l''air reçoit aussi le **Y-7H**, copie sans licence de l''**An-26** avec sa rampe arrière, produite à partir de 1992, et le **HYJ-7**, avion-école des équipages de bombardiers **H-6** doté d''un viseur stabilisé et d''un radar de bombardement.\n\n## Place dans l''histoire\nAprès la série sous licence, le Y-7 évolue indépendamment de l''An-24, au fil d''améliorations successives, jusqu''au **Xian MA60**, version occidentalisée destinée à séduire davantage de clients occidentaux. Sa cellule sert même de banc d''essai : le **JZY-01**, version de guet aérien embarqué à quatre dérives comme l''E-2, prépare le **KJ-600** destiné aux porte-avions chinois.',
    E'## Genesis\nChina imported the **Antonov An-24** from early in its production run and negotiated licences for the aircraft and its engines. In 1966 the **Xi''an** aircraft factory began the local production project. The first Chinese-assembled An-24T flew on 25 December 1970, but the **Cultural Revolution** slowed everything: production was only launched in 1977, a pre-production aircraft was not shown to the public until 17 April 1982 at Nanyuan air base near Beijing, and the first production aircraft did not fly until February 1984. Eighteen years separated licence and production.\n\n## Design\nThe Y-7 equated to the **An-24RV**, with a full set of windows and the booster jet; it was powered by two **Dongan WJ-5A** turboprops driving four-bladed propellers. The **Y-7-100**, developed with HAECO of Hong Kong, received a redesigned cockpit and cabin, winglets and Western avionics: a crew of three sufficed and 52 passengers could be carried. It reached 503 km/h and had a range of nearly 2,000 km with maximum fuel.\n\n## Operational career\nMost early deliveries went to the People''s Liberation Army Air Force, mostly as transports, with a few 52-seat airliners for the national carrier CAAC. Chinese Army aviation and naval aviation adopted it in turn, as did the Iranian, Laotian and Mauritanian air forces. The air force also received the **Y-7H**, an unlicensed copy of the **An-26** with its rear ramp, produced from 1992, and the **HYJ-7**, a crew trainer for **H-6** bombers fitted with a stabilised bombsight and bomb-aiming radar.\n\n## Place in history\nAfter the licensed production run, the Y-7 was developed separately from the An-24 through a series of upgrades culminating in the **Xian MA60**, a Westernised version meant to attract more Western customers. Its airframe even served as a test bed: the **JZY-01**, a carrier-borne early warning version with four fins like the E-2, is being used to prepare the **KJ-600** for Chinese aircraft carriers.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '1966-01-01',
    '1970-12-25',
    NULL,
    503,
    1982,
    (SELECT id FROM manufacturer WHERE code = 'XAC'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Xian Y-7'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Xian Y-7'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 24.218,
  wingspan          = 29.666,
  height            = 8.553,
  wing_area         = 75.26,
  empty_weight      = 14988,
  mtow              = 21800,
  service_ceiling   = 8750,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Dongan WJ-5A (2 400 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1977,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Y-7** : An-24RV construit sous licence, premières livraisons à l''armée de l''air chinoise\n- **Y-7-100** : version modernisée avec HAECO, winglets et avionique occidentale, 52 passagers\n- **Y-7H** : copie sans licence de l''An-26 à rampe arrière, produite à partir de 1992\n- **HYJ-7** : avion-école des équipages de bombardiers H-6, avec viseur et radar de bombardement\n- **JZY-01** : banc d''essai de guet aérien embarqué à quatre dérives, préparant le KJ-600',
  variants_en       = E'- **Y-7**: licence-built An-24RV, first deliveries to the Chinese air force\n- **Y-7-100**: upgraded version with HAECO, winglets and Western avionics, 52 passengers\n- **Y-7H**: unlicensed copy of the An-26 with a rear ramp, produced from 1992\n- **HYJ-7**: crew trainer for H-6 bombers, with bombsight and bomb-aiming radar\n- **JZY-01**: four-finned carrier-borne early warning test bed, preparing the KJ-600',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Xi''an_Y-7',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Aeroprints.com',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Xian Y-7';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Xian Y-7';
