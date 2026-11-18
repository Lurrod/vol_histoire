-- L3Harris EA-37B Compass Call (ex-EC-37B)
--
-- Photo : Disruptive Duo- EA-37B Compass Call, Growlers add electronic edge (9384933).jpg
--   licence Public domain — U.S. Air Force photo by Senior Airman Melany Bermudez
--   https://commons.wikimedia.org/wiki/File:Disruptive_Duo-_EA-37B_Compass_Call,_Growlers_add_electronic_edge_(9384933).jpg

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
    'EA-37B Compass Call',
    'EA-37B Compass Call',
    'L3Harris EA-37B Compass Call (ex-EC-37B)',
    'L3Harris EA-37B Compass Call (formerly EC-37B)',
    'Gulfstream G550 bardé d''antennes latérales, qui brouille radars et transmissions ennemis à la place de l''EC-130H',
    'Gulfstream G550 lined with side antennas that jams enemy radars and communications in place of the EC-130H',
    '/assets/airplanes/ea37b-compass-call.jpg',
    E'## Genèse\nL''US Air Force brouille les réseaux de commandement adverses avec l''**EC-130H Compass Call**, un Hercules à turbopropulseurs. Le 7 septembre 2017, elle confie à **L3 Technologies**, future L3Harris, le remplacement de cette flotte par un avion tiré du **Gulfstream G550**, qui doit reprendre jusqu''à 70 % des équipements de mission de l''EC-130H. Le 23 octobre 2018, la secrétaire à l''Air Force **Heather Wilson** approuve le remplacement des appareils du 55th Electronic Combat Group, basé à Davis-Monthan, en Arizona. L''avion s''appelle alors **EC-37B**, version de guerre électronique du transport C-37B.\n\n## Conception\nL3Harris et **BAE Systems** transforment des cellules de G550. Le trait le plus visible est une paire de grands réseaux d''antennes conformes, plaqués sur chaque flanc du fuselage et dérivés des panneaux radar du G550 CAEW. Le système, plusieurs fois mis à jour jusqu''au standard « Baseline 4 », intègre la technologie SABER de BAE Systems et des récepteurs, des radios logicielles et un ensemble de brouillage radar. Sa mission : perturber les communications de commandement, les radars et les systèmes de navigation adverses, et participer à la neutralisation des défenses aériennes. Jusqu''à neuf personnes sont à bord, dont des officiers de guerre électronique et des linguistes cryptologues.\n\n## Carrière opérationnelle\nLe premier appareil est livré en septembre 2023 pour évaluation, et la désignation devient officiellement **EA-37B** le 14 novembre 2023, pour mieux refléter son rôle d''attaque électronique. Le 23 août 2024, le premier avion opérationnel, le 19-5591, rejoint Davis-Monthan pour la formation des pilotes ; la première sortie d''entraînement en mission a lieu le 2 mai 2025, depuis Offutt, dans le Nebraska. En mai 2025, cinq des dix appareils commandés sont livrés. Les observateurs le relient à l''intervention américaine au Venezuela de 2026, mais son premier déploiement au combat confirmé a lieu au Moyen-Orient, pendant la guerre contre l''Iran de la même année.\n\n## Place dans l''histoire\nL''EA-37B fait passer la guerre électronique américaine d''un cargo à hélices à un jet d''affaires, sans rien perdre de l''essentiel de ses équipements de mission, repris de l''EC-130H. Il prolonge la lignée des Gulfstream militaires à antennes conformes ouverte par le G550 CAEW, et trouve un premier client à l''export : l''Italie commande deux ensembles de mission pour transformer deux de ses G550.',
    E'## Genesis\nThe US Air Force jammed enemy command networks with the **EC-130H Compass Call**, a turboprop Hercules. On 7 September 2017 it awarded **L3 Technologies**, the future L3Harris, a contract to replace that fleet with an aircraft derived from the **Gulfstream G550**, re-hosting up to 70% of the EC-130H''s mission equipment. On 23 October 2018 Secretary of the Air Force **Heather Wilson** approved replacing the aircraft of the 55th Electronic Combat Group, based at Davis-Monthan, Arizona. The aircraft was then called **EC-37B**, an electronic warfare version of the C-37B transport.\n\n## Design\nL3Harris and **BAE Systems** convert G550 airframes. The most visible feature is a pair of large conformal antenna arrays mounted on each side of the fuselage, derived from the radar panels of the G550 CAEW. The system, updated several times up to the "Baseline 4" standard, incorporates BAE Systems'' SABER technology along with receivers, software-defined radios and a counter-radar assembly. Its mission: disrupt enemy command communications, radars and navigation systems, and take part in suppressing air defences. Up to nine people fly aboard, including electronic warfare officers and cryptologic linguists.\n\n## Operational career\nThe first airframe was delivered in September 2023 for evaluation, and the designation officially became **EA-37B** on 14 November 2023 to better reflect its electronic attack role. On 23 August 2024 the first ready aircraft, 19-5591, joined Davis-Monthan for pilot training; the first mission training sortie was flown on 2 May 2025 from Offutt, Nebraska. By May 2025 five of the ten aircraft ordered had been delivered. Observers linked it to the 2026 US intervention in Venezuela, but its first confirmed combat deployment came in the Middle East, during the Iran war of the same year.\n\n## Place in history\nThe EA-37B moves American electronic warfare from a propeller-driven freighter to a business jet, while keeping most of its mission equipment, carried over from the EC-130H. It extends the line of military Gulfstreams with conformal antennas begun by the G550 CAEW, and has found a first export customer: Italy ordered two mission packages to convert two of its G550s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2017-09-07',
    NULL,
    '2024-08-23',
    871,
    7100,
    (SELECT id FROM manufacturer WHERE code = 'L3H'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Guerre électronique'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'EA-37B Compass Call'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'EA-37B Compass Call'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'EA-37B Compass Call'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'EA-37B Compass Call'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'EA-37B Compass Call'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 29.39,
  wingspan          = 28.5,
  height            = 7.87,
  wing_area         = NULL,
  empty_weight      = 21909,
  mtow              = 44452,
  service_ceiling   = 13716,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 9,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce BR700-710C4-11',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 68.44,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **EC-37B** : désignation d''origine, version de guerre électronique du transport C-37B, remplacée le 14 novembre 2023\n- **EA-37B** : désignation définitive, dix appareils commandés pour le 55th Electronic Combat Group, cinq livrés en mai 2025\n- **Baseline 4** : dernier standard du système de mission, intégrant la technologie SABER de BAE Systems\n- **EA-37B italien** : deux ensembles de mission commandés par l''Aeronautica Militare pour transformer deux G550',
  variants_en       = E'- **EC-37B**: original designation, electronic warfare version of the C-37B transport, replaced on 14 November 2023\n- **EA-37B**: definitive designation, ten aircraft ordered for the 55th Electronic Combat Group, five delivered by May 2025\n- **Baseline 4**: latest mission system standard, incorporating BAE Systems'' SABER technology\n- **Italian EA-37B**: two mission packages ordered by the Italian Air Force to convert two G550s',

  -- Strate 4 : qualitatif
  nickname          = 'Compass Call',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/L3Harris_EA-37B_Compass_Call',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Senior Airman Melany Bermudez, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'EA-37B Compass Call';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'EA-37B Compass Call';
