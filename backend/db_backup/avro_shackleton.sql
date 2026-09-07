-- Avro Shackleton
--
-- Photo : Avro Shackleton MR3 in flight c1955.jpg
--   licence Public domain — RAF
--   https://commons.wikimedia.org/wiki/File%3AAvro_Shackleton_MR3_in_flight_c1955.jpg

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
    'Avro Shackleton',
    'Avro Shackleton',
    'Avro Shackleton',
    'Avro Shackleton',
    'Descendant à hélices du Lancaster, en service jusqu’en 1991',
    'Propeller-driven descendant of the Lancaster, in service until 1991',
    '/assets/airplanes/shackleton.jpg',
    E'## Genèse\nEn 1946, la Royal Air Force doit remplacer ses Liberator américains prêtés pendant la guerre et qu''il faut rendre. Avro propose la solution la plus économique possible : reprendre l''aile et les moteurs du **Lincoln**, lui-même dérivé du Lancaster, et poser dessus un fuselage neuf conçu pour la patrouille maritime. L''appareil naît donc déjà démodé, et il le restera quarante ans.\n\n## Conception\nQuatre moteurs **Griffon** à douze cylindres entraînant des hélices contrarotatives : un vacarme légendaire, qui vaut à l''avion son surnom de *Growler*, le grondeur, et une réputation de faire vibrer les dents de ses équipages. Dix hommes, des postes de veille vitrés, un radar ventral rétractable et une soute longue. Les missions durent quinze heures ; le confort à bord est considéré, encore aujourd''hui, comme le pire de l''aviation britannique.\n\n## Carrière opérationnelle\nIl traque les sous-marins soviétiques dans l''Atlantique Nord, opère à Aden, à Suez et à Chypre, et assure d''innombrables sauvetages en mer. Quand le radar embarqué du **Fairey Gannet** disparaît en 1978, la RAF bricole douze Shackleton en avions de guet aérien avec des radars récupérés sur des Gannet — solution provisoire qui durera **dix-neuf ans**, jusqu''en 1991.\n\n## Place dans l''histoire\nCent quatre-vingt-cinq exemplaires et quarante ans de service, dont les vingt dernières années passées comme le dernier avion militaire à moteur à pistons de la RAF. Son successeur en patrouille maritime, le **Nimrod**, entre en service en 1969 ; le Shackleton lui survivra pourtant de vingt-deux ans dans son rôle de guet aérien improvisé.',
    E'## Genesis\nIn 1946 the Royal Air Force had to replace the American Liberators lent during the war and now due back. Avro proposed the cheapest possible solution: take the wing and engines of the **Lincoln**, itself derived from the Lancaster, and put a new fuselage on them designed for maritime patrol. The aircraft was thus born already dated, and it stayed that way for forty years.\n\n## Design\nFour twelve-cylinder **Griffon** engines driving contra-rotating propellers: a legendary din, which earned the aircraft its nickname *The Growler* and a reputation for rattling its crews'' teeth. Ten men, glazed observation stations, a retractable belly radar and a long bay. Missions lasted fifteen hours; comfort aboard is still reckoned the worst in British aviation.\n\n## Operational career\nIt hunted Soviet submarines in the North Atlantic, operated at Aden, Suez and Cyprus, and carried out countless sea rescues. When the **Fairey Gannet**''s airborne radar disappeared in 1978, the RAF improvised twelve Shackletons into airborne early warning aircraft using radars salvaged from Gannets — a stopgap that lasted **nineteen years**, until 1991.\n\n## Place in history\nOne hundred and eighty-five built and forty years of service, the last twenty of them as the RAF''s final piston-engined military aircraft. Its maritime patrol successor, the **Nimrod**, entered service in 1969; the Shackleton nevertheless outlived it by twenty-two years in its improvised early warning role.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1946-01-01',
    '1949-03-09',
    '1951-04-01',
    480.0,
    4800.0,
    (SELECT id FROM manufacturer WHERE code = 'AVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Shackleton'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Avro Shackleton'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Shackleton'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'Avro Shackleton'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Shackleton'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Avro Shackleton'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Avro Shackleton'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Shackleton'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 26.59,
  wingspan          = 36.58,
  height            = 5.1,
  wing_area         = 132.0,
  empty_weight      = 23360,
  mtow              = 39000,
  service_ceiling   = 6200,
  climb_rate        = 4.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1900,
  crew              = 10,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Griffon 57A',
  engine_count      = 4,
  engine_type       = 'Moteur en V',
  engine_type_en    = 'V engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1958,
  units_built       = 185,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Shackleton MR.1 / MR.2** : patrouille maritime, radar ventral rétractable\n- **Shackleton MR.3** : train tricycle et ailerons de bout d''aile, version définitive\n- **Shackleton AEW.2** : guet aérien improvisé en 1972, retiré seulement en **1991**\n- **Avro Shackleton MR.3 sud-africaine** : huit exemplaires, en service jusqu''en 1984\n- Dérivé du bombardier **Lancaster** par l''intermédiaire du Lincoln',
  variants_en       = E'- **Shackleton MR.1 / MR.2** : maritime patrol, with a retractable belly radar\n- **Shackleton MR.3** : tricycle gear and wingtip tanks, the definitive version\n- **Shackleton AEW.2** : airborne early warning improvised in 1972, retired only in **1991**\n- **South African Shackleton MR.3** : eight aircraft, in service until 1984\n- Derived from the **Lancaster** bomber by way of the Lincoln',

  -- Strate 4 : qualitatif
  nickname          = 'The Growler',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Avro_Shackleton',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Avro_Shackleton',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'RAF',
  image_licence     = 'Public domain'
WHERE name = 'Avro Shackleton';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Avro Shackleton';
