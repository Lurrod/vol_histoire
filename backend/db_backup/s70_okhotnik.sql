-- Sukhoi S-70 Okhotnik-B
--
-- Photo : S-70 takeoff rear view.png
--   licence CC BY 4.0 — Ministère de la Défense de la Fédération de Russie (mil.ru)
--   https://commons.wikimedia.org/wiki/File:S-70_takeoff_rear_view.png

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
    'Sukhoi S-70 Okhotnik',
    'Sukhoi S-70 Okhotnik',
    'Sukhoi S-70 Okhotnik-B',
    'Sukhoi S-70 Okhotnik-B',
    'L’aile volante russe conçue pour escorter le Su-57 — et abattue par l’un d’eux',
    'The Russian flying wing designed to fly with the Su-57 — and shot down by one',
    '/assets/airplanes/s70-okhotnik.jpg',
    E'## Genèse\nAu début des années 2010, la Russie constate son retard sur les drones de combat furtifs américains (**X-47B**) et européens (**nEUROn**). Le ministère de la Défense retient **Sukhoi** vers 2011 pour un drone lourd, l''Okhotnik (« chasseur », au sens de celui qui chasse). Le programme reste secret jusqu''à la diffusion, en janvier 2019, de photographies du prototype sur le parking de l''usine de Novossibirsk.\n\n## Conception\nUne **aile volante** d''environ vingt mètres d''envergure, sans dérive, avec une soute interne. Le premier prototype conserve une tuyère ronde et apparente, incompatible avec une signature radar réduite par l''arrière ; un exemplaire présenté fin 2021 adopte une tuyère plate, plus discrète. Le moteur serait un dérivé de la famille AL-31/AL-41 du Su-27 et du Su-57. Masse, vitesse et autonomie n''ont pas été publiées officiellement : les chiffres qui circulent sont des estimations.\n\n## Carrière opérationnelle\nPremier vol le **3 août 2019**. Le 27 septembre 2019, l''Okhotnik vole en formation avec un **Su-57**, son partenaire désigné : le chasseur piloté doit diriger le drone et lui confier les missions les plus exposées. Le **5 octobre 2024**, un S-70 s''écrase près de Kostiantynivka, en territoire ukrainien. Des vidéos montrent un Su-57 qui le suit ; l''explication la plus répandue chez les analystes, que Moscou n''a pas confirmée, est que le drone avait perdu le contact avec ses opérateurs et a été abattu par son escorteur pour ne pas tomber intact aux mains ukrainiennes. Les débris contenaient les restes d''une bombe planante : l''appareil participait donc à une mission de guerre.\n\n## Place dans l''histoire\nL''Okhotnik est le premier drone de combat furtif russe à avoir volé. Son seul épisode connu au combat est une perte, qui a livré à l''adversaire une partie de ses secrets. Le nombre d''exemplaires construits, l''état réel du programme et la date d''une éventuelle mise en service restent inconnus. Il fait face au **Hongdu GJ-11** chinois, son contemporain le plus proche.',
    E'## Genesis\nIn the early 2010s Russia recognised that it lagged behind American (**X-47B**) and European (**nEUROn**) stealth combat drones. Around 2011 the defence ministry selected **Sukhoi** for a heavy drone, the Okhotnik ("hunter"). The programme stayed secret until photographs of the prototype on the apron of the Novosibirsk plant were released in January 2019.\n\n## Design\nA **flying wing** of about twenty metres span, with no fin and an internal bay. The first prototype kept a round, exposed nozzle, incompatible with a reduced radar signature from the rear; an example shown in late 2021 adopted a flat, stealthier nozzle. The engine is reported to derive from the AL-31/AL-41 family of the Su-27 and Su-57. Weight, speed and endurance have not been officially published: the figures in circulation are estimates.\n\n## Operational career\nFirst flight on **3 August 2019**. On 27 September 2019 the Okhotnik flew in formation with a **Su-57**, its designated partner: the crewed fighter is meant to direct the drone and hand it the most exposed tasks. On **5 October 2024** an S-70 crashed near Kostiantynivka, in Ukrainian-held territory. Videos show a Su-57 following it; the explanation most widely held by analysts, not confirmed by Moscow, is that the drone had lost contact with its operators and was shot down by its escort so that it would not fall intact into Ukrainian hands. The wreckage contained the remains of a glide bomb: the aircraft was therefore on a war mission.\n\n## Place in history\nThe Okhotnik is the first Russian stealth combat drone to have flown. Its only known episode in combat is a loss, which handed part of its secrets to the enemy. The number built, the real state of the programme and the date of any entry into service remain unknown. It faces China''s **Hongdu GJ-11**, its closest contemporary.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '2011-01-01',
    '2019-08-03',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Sukhoi S-70 Okhotnik'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Sukhoi S-70 Okhotnik'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Sukhoi S-70 Okhotnik'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Sukhoi S-70 Okhotnik'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Sukhoi S-70 Okhotnik'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

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
  variants          = E'- **Premier prototype** : tuyère ronde apparente, premier vol le **3 août 2019**\n- **Prototype de 2021** : tuyère plate, présenté comme proche du standard de série\n- Vol en formation avec un **Su-57** le 27 septembre 2019\n- Un exemplaire perdu au-dessus de l''Ukraine le **5 octobre 2024**\n\n*Programme classifié : dimensions, masses et performances ne sont pas publiées, les valeurs manquantes sont laissées vides plutôt qu''estimées.*',
  variants_en       = E'- **First prototype** : round exposed nozzle, first flight on **3 August 2019**\n- **2021 prototype** : flat nozzle, presented as close to production standard\n- Formation flight with a **Su-57** on 27 September 2019\n- One aircraft lost over Ukraine on **5 October 2024**\n\n*Classified programme: dimensions, weights and performance are not published; missing values are left blank rather than estimated.*',

  -- Strate 4 : qualitatif
  nickname          = 'Okhotnik',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soukho%C3%AF_S-70_Okhotnik-B',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Sukhoi_S-70_Okhotnik-B',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ministère de la Défense de la Fédération de Russie (mil.ru)',
  image_licence     = 'CC BY 4.0'
WHERE name = 'Sukhoi S-70 Okhotnik';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'Sukhoi S-70 Okhotnik';
