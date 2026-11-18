-- Ryan VZ-3RY Vertiplane (Model 92)
--
-- Photo : ARC-1961-A-28066-1.jpg
--   licence Public domain — NASA Ames Research Center / Dave West
--   https://commons.wikimedia.org/wiki/File:ARC-1961-A-28066-1.jpg

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
    'Ryan VZ-3 Vertiplane',
    'Ryan VZ-3 Vertiplane',
    'Ryan VZ-3RY Vertiplane (Model 92)',
    'Ryan VZ-3RY Vertiplane (Model 92)',
    'Démonstrateur de l''US Army qui rabattait le souffle de ses hélices vers le sol pour décoller presque à la verticale',
    'US Army demonstrator that turned its propeller slipstream downwards to take off almost vertically',
    '/assets/airplanes/ryan-vz3.jpg',
    E'## Genèse\nÀ la fin des années 1950, l''**US Army** finance une série de petits appareils expérimentaux, la série VZ, pour trouver comment décoller et se poser sur quelques mètres. **Ryan Aeronautical** lui livre le **Model 92**, baptisé **Vertiplane** et désigné VZ-3. Ryan ne fait basculer ni l''aile ni les hélices : il mise sur le **souffle dévié**, l''air des hélices rabattu vers le sol par de grands volets. Simple démonstrateur destiné à prouver le principe, l''appareil vole pour la première fois le 29 décembre 1958.\n\n## Conception\nLe VZ-3 est un monoplan à aile haute et empennage en T, d''abord posé sur un train classique fixe à roulette de queue. Une turbine **Avco Lycoming T53** de 1 000 ch, logée dans le fuselage, entraîne deux hélices de grand diamètre, une sur chaque aile. Derrière elles, des volets doubles escamotables couvrant presque toute l''envergure se déploient dans leur souffle au décollage et le renvoient vers le bas. En vol stationnaire, où les gouvernes ne servent plus, le pilote dispose à l''arrière d''une tuyère de déviation du jet montée sur rotule, orientable dans tous les sens.\n\n## Essais\nLe Vertiplane peut décoller presque à la verticale sur moins de 9 m, à 40 km/h, et tenir le stationnaire jusqu''à 1 100 m d''altitude. Après un programme de 21 vols pour l''US Army, il s''écrase en 1959. Reconstruit avec un poste ouvert et un fuselage allongé, il passe à la **NASA**, qui l''essaie au centre de recherche d''**Ames** pour étudier les qualités de vol d''un avion à souffle dévié : on l''y voit voler en palier à 25 nœuds, volets braqués à 60 degrés. Muni plus tard de becs de bord d''attaque, il descend jusqu''à 6 nœuds hors de l''effet de sol. Il reçoit aussi un train à roulette de nez.\n\n## Place dans l''histoire\nLe VZ-3 est l''un des appareils qui ont mis à l''épreuve le souffle dévié, comme le **Fairchild VZ-5** de la même série et le **Dornier Do 29** allemand. Son voyage d''un programme de l''Army à un laboratoire de la NASA illustre la façon dont ces machines d''essai, une fois leur mission militaire close, servaient encore la recherche aéronautique. Exemplaire unique, il est exposé au musée de l''aviation de l''US Army.',
    E'## Genesis\nIn the late 1950s the **US Army** funded a series of small experimental aircraft, the VZ series, to find out how to take off and land within a few metres. **Ryan Aeronautical** supplied it with the **Model 92**, named **Vertiplane** and designated VZ-3. Ryan tilted neither the wing nor the propellers: it relied on the **deflected slipstream**, the propellers'' airflow turned towards the ground by large flaps. A simple proof-of-concept aircraft, it flew for the first time on 29 December 1958.\n\n## Design\nThe VZ-3 was a high-wing monoplane with a T-tail, at first standing on a fixed tailwheel undercarriage. A 1,000 shp **Avco Lycoming T53** turboshaft inside the fuselage drove two large-diameter propellers, one on each wing. Behind them, wide-span double retractable trailing-edge flaps were extended into the slipstream for take-off and turned it downwards. In the hover, where control surfaces no longer work, the pilot had a universally jointed jet-deflection nozzle at the rear of the aircraft.\n\n## Testing\nThe Vertiplane could make a near-vertical take-off within 9 m at 40 km/h, and hover at heights of up to 1,100 m. After a 21-flight test programme for the US Army, it crashed in 1959. Rebuilt with an open cockpit and a lengthened fuselage, it was handed to **NASA**, which flew it at the **Ames** research centre to study the flying qualities of a deflected-slipstream aircraft: it was flown there in level flight at 25 knots with the flaps deflected 60 degrees. Later fitted with leading-edge slats, it flew as slowly as 6 knots out of ground effect. It also received a nosewheel undercarriage.\n\n## Place in history\nThe VZ-3 was one of the aircraft that put the deflected slipstream to the test, like the **Fairchild VZ-5** of the same series and the German **Dornier Do 29**. Its journey from an Army programme to a NASA laboratory shows how these test machines, once their military mission was over, still served aeronautical research. The sole example is on display at the US Army Aviation Museum.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1958-12-29',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'RYA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan VZ-3 Vertiplane'), (SELECT id FROM tech WHERE name = 'Aile soufflée'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan VZ-3 Vertiplane'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.43,
  wingspan          = 7.14,
  height            = 3.25,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 1179,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Avco Lycoming T53-L-1 (1 000 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Model 92** : désignation du constructeur\n- **VZ-3RY** : configuration d''origine pour l''US Army, train classique fixe à roulette de queue, 21 vols jusqu''à l''accident de 1959\n- **VZ-3 reconstruit** : poste ouvert et fuselage allongé, confié à la NASA\n- **Train à roulette de nez** : modification ultérieure du train d''atterrissage\n- **Aile à becs** : bords d''attaque munis de becs, essayés à Ames pour descendre jusqu''à 6 nœuds',
  variants_en       = E'- **Model 92**: manufacturer''s designation\n- **VZ-3RY**: original US Army configuration, fixed tailwheel undercarriage, 21 flights until the 1959 crash\n- **Rebuilt VZ-3**: open cockpit and lengthened fuselage, handed over to NASA\n- **Nosewheel undercarriage**: later modification of the landing gear\n- **Slatted wing**: leading-edge slats tried at Ames to fly as slowly as 6 knots',

  -- Strate 4 : qualitatif
  nickname          = 'Vertiplane',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ryan_VZ-3_Vertiplane',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Dave West, NASA Ames Research Center',
  image_licence     = 'Public domain'
WHERE name = 'Ryan VZ-3 Vertiplane';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Ryan VZ-3 Vertiplane';
