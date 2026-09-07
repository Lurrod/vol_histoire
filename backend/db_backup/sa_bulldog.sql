-- Scottish Aviation Bulldog T.1
--
-- Photo : Scottish Aviation Bulldog (XX522) arrives RIAT Fairford 7July2016 arp.jpg
--   licence Public domain — Adrian Pingstone
--   https://commons.wikimedia.org/wiki/File%3AScottish_Aviation_Bulldog_%28XX522%29_arrives_RIAT_Fairford_7July2016_arp.jpg

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
    'Scottish Aviation Bulldog',
    'Scottish Aviation Bulldog',
    'Scottish Aviation Bulldog T.1',
    'Scottish Aviation Bulldog T.1',
    'L’avion sur lequel des générations d’étudiants britanniques ont volé',
    'The aircraft on which generations of British students first flew',
    '/assets/airplanes/sa-bulldog.jpg',
    E'## Genèse\nLe constructeur britannique **Beagle** fait faillite en 1969 en laissant sur le carreau un bon petit biplace, le Pup, et une commande suédoise pour sa version militaire. Scottish Aviation, à Prestwick, rachète le projet, l''achève et le livre — sauvant à la fois le contrat et le type.\n\n## Conception\nUne tonne à pleine charge, un Lycoming de deux cents chevaux, un train fixe et une verrière coulissante. Deux places **côte à côte** : ce n''est pas une école de chasse mais une école de vol, où l''instructeur doit pouvoir montrer. L''aile est contrainte à six g, ce qui autorise la voltige complète — argument décisif auprès des escadrons universitaires.\n\n## Carrière opérationnelle\nTrois cent vingt-huit exemplaires, neuf pays. La RAF l''emploie de 1973 à **2001**, essentiellement au sein des **University Air Squadrons** : des milliers d''étudiants britanniques ont fait sur Bulldog leur premier vol, dont beaucoup ne sont jamais devenus pilotes militaires. La **Suède** en exploite cent soixante-dix-huit sous le nom de Sk 61.\n\n## Place dans l''histoire\nTrois cent vingt-huit exemplaires. Le Bulldog a une particularité : sa mission n''était pas de former des pilotes de combat mais de **faire voler des civils** pour leur donner le goût de l''aviation — recrutement à long terme autant qu''instruction. Une centaine volent encore, aujourd''hui aux mains de particuliers.',
    E'## Genesis\nThe British manufacturer **Beagle** went bankrupt in 1969, leaving behind a sound little two-seater, the Pup, and a Swedish order for its military version. Scottish Aviation at Prestwick bought the project, finished it and delivered — saving both the contract and the type.\n\n## Design\nA tonne fully loaded, a two-hundred-horsepower Lycoming, fixed gear and a sliding canopy. Two **side-by-side** seats: this is not a fighter school but a flying school, where the instructor must be able to demonstrate. The wing is stressed to six g, which permits full aerobatics — the decisive argument for the university squadrons.\n\n## Operational career\nThree hundred and twenty-eight built, nine countries. The RAF used it from 1973 to **2001**, mainly in the **University Air Squadrons**: thousands of British students made their first flight on a Bulldog, many of whom never became military pilots. **Sweden** operated one hundred and seventy-eight as the Sk 61.\n\n## Place in history\nThree hundred and twenty-eight built. The Bulldog has a peculiarity: its mission was not to train combat pilots but to **get civilians flying** and give them a taste for aviation — long-term recruitment as much as instruction. About a hundred still fly, now in private hands.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1968-01-01',
    '1969-05-19',
    '1973-04-01',
    241.0,
    1000.0,
    (SELECT id FROM manufacturer WHERE code = 'SAL'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Bulldog'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Bulldog'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Bulldog'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.09,
  wingspan          = 10.06,
  height            = 2.28,
  wing_area         = 12.02,
  empty_weight      = 650,
  mtow              = 1066,
  service_ceiling   = 4900,
  climb_rate        = 5.1,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = 350,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming IO-360-A1B6',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1971,
  production_end    = 1982,
  units_built       = 328,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 9,
  variants          = E'- **Bulldog T.1** : version RAF, cent trente exemplaires\n- **Bulldog Sk 61** : version suédoise, la plus produite, cent soixante-dix-huit exemplaires\n- Dérivé du **Beagle Pup** civil, dont Scottish Aviation reprend le projet en faillite\n- Monture des **University Air Squadrons** : premier vol de milliers d''étudiants\n- Revendus au civil après 2001 : une centaine volent encore en aéroclub',
  variants_en       = E'- **Bulldog T.1** : RAF version, one hundred and thirty aircraft\n- **Bulldog Sk 61** : Swedish version, the most produced, one hundred and seventy-eight\n- Derived from the civil **Beagle Pup**, whose bankrupt project Scottish Aviation took over\n- Mount of the **University Air Squadrons**: first flight for thousands of students\n- Sold on to civil owners after 2001: about a hundred still fly with clubs',

  -- Strate 4 : qualitatif
  nickname          = 'Bulldog',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Scottish_Aviation_Bulldog',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Scottish_Aviation_Bulldog',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Adrian Pingstone',
  image_licence     = 'Public domain'
WHERE name = 'Scottish Aviation Bulldog';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Scottish Aviation Bulldog';
