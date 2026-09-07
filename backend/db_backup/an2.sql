-- Antonov An-2 (Colt)
--
-- Photo : Antonov An-2 formation - Zhukovsky 2012 (8696194339).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File%3AAntonov_An-2_formation_-_Zhukovsky_2012_%288696194339%29.jpg

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
    'Antonov An-2',
    'Antonov An-2',
    'Antonov An-2 (Colt)',
    'Antonov An-2 (Colt)',
    'Le plus grand biplan de série de l’histoire, produit pendant cinquante-quatre ans',
    'The largest series-built biplane in history, produced for fifty-four years',
    '/assets/airplanes/an2.jpg',
    E'## Genèse\nEn 1946, l''URSS n''a pas besoin d''un avion rapide : elle a besoin d''un avion qui se pose dans un champ, décharge une tonne d''engrais et reparte, à des milliers d''exemplaires, sur un territoire sans routes. Oleg Antonov dessine donc, à contre-courant de toute l''aéronautique de l''époque, un **biplan** — formule abandonnée partout ailleurs depuis dix ans, mais imbattable pour la portance à basse vitesse.\n\n## Conception\nToile et métal, un seul moteur en étoile, des becs de bord d''attaque **automatiques** qui sortent seuls quand l''incidence monte. Le résultat est un avion sans vitesse de décrochage utilisable : en dessous de cinquante kilomètres-heure, l''An-2 ne décroche pas, il **descend en parachute** à quelques mètres par seconde, commandes actives. Le manuel de vol soviétique se contentait d''indiquer que, vent debout, l''appareil pouvait reculer.\n\n## Carrière opérationnelle\nQuarante forces aériennes l''ont employé, et pratiquement tous les usages civils imaginables : épandage, parachutisme, ambulance, largage de commandos. Le Vietnam du Nord s''en sert pour des raids nocturnes ; la **Corée du Nord** en conserve une flotte précisément parce qu''un biplan entoilé volant à trente mètres est difficile à voir au radar.\n\n## Place dans l''histoire\nEnviron dix-huit mille exemplaires et **cinquante-quatre ans de production continue** — de 1947 à 2001 en Pologne, et toujours en Chine sous le nom de Y-5. Aucun autre avion n''a été construit aussi longtemps. Il est le seul appareil du catalogue dont le principal mérite soit de voler lentement.',
    E'## Genesis\nIn 1946 the USSR did not need a fast aircraft: it needed one that could land in a field, unload a tonne of fertiliser and leave again, in thousands of examples, across a country without roads. Against the grain of all contemporary aviation, Oleg Antonov therefore drew a **biplane** — a layout abandoned everywhere else a decade earlier, but unbeatable for lift at low speed.\n\n## Design\nFabric and metal, a single radial engine, and **automatic** leading-edge slats that deploy by themselves as the angle of attack rises. The result is an aircraft with no usable stalling speed: below fifty kilometres an hour the An-2 does not stall, it **parachutes down** at a few metres per second with the controls still working. The Soviet flight manual simply noted that, into wind, the aircraft could fly backwards.\n\n## Operational career\nForty air forces have used it, along with practically every civil use imaginable: crop spraying, parachuting, ambulance work, commando dropping. North Vietnam used it for night raids; **North Korea** keeps a fleet precisely because a fabric biplane flying at thirty metres is hard to see on radar.\n\n## Place in history\nAbout eighteen thousand built and **fifty-four years of continuous production** — from 1947 to 2001 in Poland, and still in China as the Y-5. No other aircraft has been built for so long. It is the only aircraft in the catalogue whose chief merit is flying slowly.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1946-01-01',
    '1947-08-31',
    '1949-01-01',
    258.0,
    845.0,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-2'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-2'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-2'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-2'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-2'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-2'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.4,
  wingspan          = 18.18,
  height            = 4.1,
  wing_area         = 71.52,
  empty_weight      = 3300,
  mtow              = 5500,
  service_ceiling   = 4500,
  climb_rate        = 3.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Shvetsov ASh-62IR',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 2001,
  units_built       = 18000,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 40,
  variants          = E'- **An-2T / TP** : transport de fret et de passagers, versions les plus répandues\n- **An-2S** : version sanitaire, six brancards\n- **An-2V** : version à flotteurs, opérant depuis lacs et rivières\n- **Shijiazhuang Y-5** : copie chinoise, toujours produite aujourd''hui\n- La **Corée du Nord** en exploite encore une flotte pour l''infiltration de commandos',
  variants_en       = E'- **An-2T / TP** : freight and passenger transport, the most widespread versions\n- **An-2S** : ambulance version carrying six stretchers\n- **An-2V** : float version, operating from lakes and rivers\n- **Shijiazhuang Y-5** : Chinese copy, still in production today\n- **North Korea** still flies a fleet of them for commando infiltration',

  -- Strate 4 : qualitatif
  nickname          = 'Colt',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Antonov An-2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-2';
