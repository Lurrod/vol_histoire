-- Northrop Grumman X-47B
--
-- Photo : X-47B over coastline.jpg
--   licence Public domain — DARPA
--   https://commons.wikimedia.org/wiki/File%3AX-47B_over_coastline.jpg

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
    'X-47B',
    'X-47B',
    'Northrop Grumman X-47B',
    'Northrop Grumman X-47B',
    'Premier drone à apponter et à se ravitailler en vol, puis abandonné',
    'First drone to land on a carrier and refuel in flight, then abandoned',
    '/assets/airplanes/x47b.jpg',
    E'## Genèse\nLe porte-avions américain a un rayon d''action limité par celui de ses appareils : environ huit cents kilomètres. Les missiles antinavires chinois portant plus loin, la question devient stratégique. Un drone furtif capable de voler **deux mille kilomètres** et de rester en l''air longtemps réglerait le problème. La Navy commande le X-47B pour prouver que c''est faisable.\n\n## Conception\nUne aile volante sans dérive ni empennage, dix-neuf mètres d''envergure repliables, un réacteur F100 enterré et des soutes internes. Sans gouverne de direction, l''appareil vire en **freinant une aile** — technique héritée du B-2. La difficulté n''est pourtant pas là : elle est dans l''appontage automatique, exercice où un pilote humain met des années à devenir compétent.\n\n## Carrière opérationnelle\nAucune. Deux démonstrateurs, mais deux premières mondiales : le **10 juillet 2013**, un X-47B apponte seul sur l''USS *George H.W. Bush* ; le **22 avril 2015**, un autre se ravitaille en vol derrière un Omega 707. Les deux manœuvres les plus difficiles de l''aéronautique navale, exécutées sans pilote.\n\n## Place dans l''histoire\nDeux exemplaires, tous deux au musée. La Navy conclut la démonstration et… change d''avis : plutôt qu''un drone de frappe furtif, elle commande un **ravitailleur**, le MQ-25 Stingray, jugé moins risqué. Le X-47B aura prouvé que le drone embarqué fonctionne, et laissé à d''autres le soin d''en tirer parti.',
    E'## Genesis\nThe American carrier''s reach is limited by that of its aircraft: about eight hundred kilometres. With Chinese anti-ship missiles reaching further, this became a strategic question. A stealthy drone able to fly **two thousand kilometres** and loiter would solve it. The Navy ordered the X-47B to prove it could be done.\n\n## Design\nA tailless flying wing, nineteen metres of folding span, a buried F100 engine and internal bays. With no rudder, the aircraft turns by **braking one wing** — a technique inherited from the B-2. The difficulty lies elsewhere: in automatic carrier landing, an exercise a human pilot takes years to master.\n\n## Operational career\nNone. Two demonstrators, but two world firsts: on **10 July 2013** an X-47B landed itself aboard USS *George H.W. Bush*; on **22 April 2015** another refuelled in flight behind an Omega 707. The two hardest manoeuvres in naval aviation, performed with no pilot.\n\n## Place in history\nTwo built, both now in museums. The Navy completed the demonstration and… changed its mind: rather than a stealthy strike drone it ordered a **tanker**, the MQ-25 Stingray, judged less risky. The X-47B proved the carrier drone works, and left it to others to make use of the fact.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2000-01-01',
    '2011-02-04',
    NULL,
    1035.0,
    3900.0,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'X-47B'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'X-47B'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'X-47B'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'X-47B'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'X-47B'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'X-47B'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.63,
  wingspan          = 18.92,
  height            = 3.1,
  wing_area         = 90.0,
  empty_weight      = 6350,
  mtow              = 20215,
  service_ceiling   = 12190,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2100,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney F100-PW-220U',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 79.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2008,
  production_end    = 2011,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **X-47B** : deux démonstrateurs, AV-1 et AV-2\n- **10 juillet 2013** : premier **appontage** d''un drone sur porte-avions, l''USS Bush\n- **22 avril 2015** : premier **ravitaillement en vol** d''un drone\n- Aile volante sans dérive, pilotée par des gouvernes de traînée différentielle\n- Programme clos en 2015 : la Navy lui préfère le ravitailleur **MQ-25**',
  variants_en       = E'- **X-47B** : two demonstrators, AV-1 and AV-2\n- **10 July 2013** : first **carrier landing** by a drone, aboard USS Bush\n- **22 April 2015** : first **aerial refuelling** of a drone\n- Tailless flying wing, controlled by differential drag surfaces\n- Programme closed in 2015: the Navy chose the **MQ-25** tanker instead',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_Grumman_X-47B',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_Grumman_X-47B',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'DARPA',
  image_licence     = 'Public domain'
WHERE name = 'X-47B';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'X-47B';
