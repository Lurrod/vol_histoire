-- Hongdu GJ-11 Sharp Sword (Lijian)
--
-- Photo : Gongji-11 20221020.jpg
--   licence CC BY-SA 4.0 — 颐园居
--   https://commons.wikimedia.org/wiki/File:Gongji-11_20221020.jpg

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
    'Hongdu GJ-11 Sharp Sword',
    'Hongdu GJ-11 Sharp Sword',
    'Hongdu GJ-11 Lijian (Sharp Sword)',
    'Hongdu GJ-11 Lijian (Sharp Sword)',
    'L’aile volante furtive chinoise, révélée au défilé de 2019 et presque tout entière secrète',
    'China’s stealthy flying wing, revealed at the 2019 parade and still almost entirely secret',
    '/assets/airplanes/gj11-sharp-sword.jpg',
    E'## Genèse\nLe programme **Lijian** (« épée acérée ») est mené par **Hongdu**, avec l''institut de conception de Shenyang, dans les années 2000-2010, en réponse aux démonstrateurs américains de drones de combat furtifs. Aucune annonce officielle ne l''accompagne : son existence n''est connue que par des photographies apparues en ligne, montrant des essais au sol à partir de décembre 2012, puis un premier vol d''une vingtaine de minutes rendu public le **21 novembre 2013**.\n\n## Conception\nUne **aile volante** sans dérive, à bord de fuite en dents de scie, avec une entrée d''air dorsale qui masque le compresseur et une soute interne. La forme générale rappelle celle du **X-47B** et du **nEUROn**. Le démonstrateur de 2013 laissait voir une tuyère classique ; l''appareil présenté en 2019 a une sortie de réacteur dissimulée, plus conforme à l''exigence de discrétion. Le moteur, la masse, la vitesse et l''autonomie n''ont pas été publiés : les dimensions qui circulent (de l''ordre de quatorze mètres d''envergure pour le démonstrateur) sont des estimations.\n\n## Carrière opérationnelle\nLe GJ-11 apparaît en public pour la première fois lors du défilé militaire du **1er octobre 2019** à Pékin, pour les soixante-dix ans de la République populaire. Un modèle est exposé au salon de Zhuhai en 2021. En 2024 et 2025, des images satellitaires montrent plusieurs exemplaires sur des bases opérationnelles de l''aviation chinoise, notamment à Malan puis à Shigatse, sur le plateau tibétain. Ces indices suggèrent des essais opérationnels, voire une mise en service, que Pékin n''a pas annoncée à la date de rédaction. Une déclinaison embarquée est également attendue.\n\n## Place dans l''histoire\nLe GJ-11 est le premier drone de combat furtif chinois connu et l''un des rares au monde à avoir dépassé le stade du démonstrateur unique. Tout ce qu''on en sait vient de ce que la Chine a choisi de montrer ou de ce que les satellites ont vu. Son contemporain russe, le **Sukhoi S-70 Okhotnik**, suit la même logique d''aile volante associée à un chasseur piloté.',
    E'## Genesis\nThe **Lijian** ("sharp sword") programme was run by **Hongdu**, with the Shenyang design institute, in the 2000s and 2010s, in response to the American stealth combat drone demonstrators. No official announcement accompanied it: its existence is known only through photographs that appeared online, showing ground trials from December 2012, then a first flight of about twenty minutes made public on **21 November 2013**.\n\n## Design\nA tailless **flying wing** with a saw-tooth trailing edge, a dorsal intake hiding the compressor and an internal bay. The general shape recalls the **X-47B** and the **nEUROn**. The 2013 demonstrator showed a conventional nozzle; the aircraft shown in 2019 has a concealed engine exhaust, more in keeping with the low-observability requirement. Engine, weight, speed and endurance have not been published: the dimensions in circulation (around fourteen metres of span for the demonstrator) are estimates.\n\n## Operational career\nThe GJ-11 first appeared in public at the military parade of **1 October 2019** in Beijing, for the seventieth anniversary of the People''s Republic. A model was shown at the Zhuhai air show in 2021. In 2024 and 2025 satellite images showed several examples at operational Chinese air force bases, notably Malan and then Shigatse, on the Tibetan plateau. These clues suggest operational trials, or even entry into service, which Beijing had not announced at the time of writing. A shipborne derivative is also expected.\n\n## Place in history\nThe GJ-11 is the first known Chinese stealth combat drone and one of the few in the world to have gone beyond the single demonstrator. Everything known about it comes from what China chose to show or what satellites have seen. Its Russian contemporary, the **Sukhoi S-70 Okhotnik**, follows the same logic of a flying wing paired with a crewed fighter.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    NULL,
    '2013-11-21',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'HONG'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu GJ-11 Sharp Sword'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Hongdu GJ-11 Sharp Sword'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu GJ-11 Sharp Sword'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Hongdu GJ-11 Sharp Sword'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = NULL,
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Lijian** : démonstrateur, premier vol rendu public le **21 novembre 2013**\n- **GJ-11** : version présentée au défilé du **1er octobre 2019**, sortie de réacteur dissimulée\n- Exemplaires observés par satellite à **Malan** puis à **Shigatse** en 2024-2025\n- Déclinaison embarquée attendue pour la marine chinoise\n\n*Programme classifié : aucune caractéristique officielle n''est publiée, les valeurs manquantes sont laissées vides plutôt qu''estimées.*',
  variants_en       = E'- **Lijian** : demonstrator, first flight made public on **21 November 2013**\n- **GJ-11** : version shown at the parade of **1 October 2019**, with concealed exhaust\n- Examples seen by satellite at **Malan** and then **Shigatse** in 2024-2025\n- Shipborne derivative expected for the Chinese navy\n\n*Classified programme: no official characteristics are published; missing values are left blank rather than estimated.*',

  -- Strate 4 : qualitatif
  nickname          = 'Lijian',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hongdu_GJ-11',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hongdu_GJ-11',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '颐园居',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Hongdu GJ-11 Sharp Sword';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'Hongdu GJ-11 Sharp Sword';
