-- Kronshtadt Orion (Inokhodets)
--
-- Photo : Army-2020-209.JPG
--   licence CC0 — Nickel nitride
--   https://commons.wikimedia.org/wiki/File:Army-2020-209.JPG

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
    'Kronshtadt Orion',
    'Kronshtadt Orion',
    'Kronshtadt Orion (Inokhodets)',
    'Kronshtadt Orion (Inokhodets)',
    'Le premier drone armé de moyenne altitude russe, rattrapé en Ukraine par les défenses antiaériennes',
    'Russia''s first armed medium-altitude drone, caught out in Ukraine by air defences',
    '/assets/airplanes/kronshtadt-orion.jpg',
    E'## Genèse\nLa Russie aborde les années 2010 sans drone armé de moyenne altitude et longue endurance, alors que le **MQ-9 Reaper** américain a fait ses preuves depuis longtemps. En 2011, le ministère de la Défense finance le programme **Inokhodets** (« l''ambleur »), confié au groupe **Kronshtadt**. La silhouette de l''**Orion** est dévoilée entre 2013 et 2015, et les essais en vol commencent en 2016. Les trois premiers exemplaires de série sont livrés aux forces russes en avril 2020.\n\n## Conception\nL''Orion adopte la formule classique des drones MALE : aile droite, fuselage presque entièrement en fibre de carbone et hélice bipale propulsive à l''arrière. Il décolle et atterrit automatiquement sur piste et possède un système antigivre pour les grands froids. Sous le nez, une boule gyrostabilisée de 55 kg réunit deux caméras thermiques, une caméra grand-angle et un télémètre laser. Quatre points d''emport sous les ailes reçoivent environ 200 kg de missiles antichars guidés et de petites bombes guidées. La version d''exportation Orion-E pèse 1 150 kg, mesure 16 m d''envergure et tient 24 heures en l''air.\n\n## Carrière opérationnelle\nSelon le ministre **Sergueï Choïgou**, l''Orion est testé en mission de frappe en **Syrie** en 2019. Lors de l''**invasion de l''Ukraine**, il frappe le 4 mars 2022 un poste de commandement du bataillon Aïdar ; début avril, six frappes sur des véhicules ukrainiens sont attestées en vidéo, et le premier appareil est perdu le 7 avril. Les défenses antiaériennes le cantonnent ensuite à un rôle discret. Il réapparaît en 2024 dans l''oblast de Koursk, où la défense ukrainienne est plus clairsemée, et détruit en février 2025 un drone naval Magura V5 d''un missile à guidage laser.\n\n## Place dans l''histoire\nL''Orion est le premier drone de combat MALE russe produit en série, à Doubna, et le premier exporté, vers l''Algérie et l''Éthiopie. Sa guerre en dit long sur les limites du genre : un journaliste russe juge en 2024 qu''il a été « éclipsé » par les munitions rôdeuses Lancet et les drones FPV, et que les drones de moyenne altitude sont inutiles face à une défense aérienne étagée. Neuf Orion auraient été perdus au combat fin 2025, tandis que Kronshtadt développe des successeurs plus lourds.',
    E'## Genesis\nRussia entered the 2010s without an armed medium-altitude long-endurance drone, while the American **MQ-9 Reaper** had long proved itself. In 2011 the Defence Ministry funded the **Inokhodets** ("pacer") programme, entrusted to the **Kronshtadt** group. The **Orion**''s shape was revealed between 2013 and 2015, and flight testing began in 2016. The first three production aircraft were delivered to Russian forces in April 2020.\n\n## Design\nThe Orion follows the classic MALE drone formula: straight wing, fuselage almost entirely of carbon fibre and a two-blade pusher propeller at the rear. It takes off and lands automatically on a runway and has a de-icing system for severe cold. Under the nose, a 55 kg gyro-stabilised ball combines two thermal cameras, a wide-angle camera and a laser rangefinder. Four underwing hardpoints take about 200 kg of guided anti-tank missiles and small guided bombs. The Orion-E export version weighs 1,150 kg, spans 16 m and stays aloft for 24 hours.\n\n## Operational career\nAccording to minister **Sergei Shoigu**, the Orion was tested on strike missions in **Syria** in 2019. During the **invasion of Ukraine** it struck a command post of the Aidar battalion on 4 March 2022; by early April six strikes on Ukrainian vehicles had been confirmed on video, and the first aircraft was lost on 7 April. Air defences then confined it to a low-profile role. It reappeared in 2024 in Kursk Oblast, where Ukrainian defences were thinner, and in February 2025 destroyed a Magura V5 naval drone with a laser-guided missile.\n\n## Place in history\nThe Orion is Russia''s first series-produced MALE combat drone, built at Dubna, and the first to be exported, to Algeria and Ethiopia. Its war says much about the limits of the type: a Russian journalist judged in 2024 that it had been "eclipsed" by Lancet loitering munitions and FPV drones, and that medium-altitude drones are useless against layered air defence. Nine Orions had reportedly been lost in combat by late 2025, while Kronshtadt develops heavier successors.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '2011-01-01',
    '2016-01-01',
    '2020-04-01',
    200,
    1440,
    (SELECT id FROM manufacturer WHERE code = 'KRO'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Kronshtadt Orion'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Kronshtadt Orion'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'Kronshtadt Orion'), (SELECT id FROM tech WHERE name = 'Pod désignateur laser'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Kronshtadt Orion'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Kronshtadt Orion'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Kronshtadt Orion'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'Kronshtadt Orion'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8,
  wingspan          = 16,
  height            = 3,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 1150,
  service_ceiling   = 7500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = NULL,
  engine_count      = 1,
  engine_type       = NULL,
  engine_type_en    = NULL,
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2020,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Orion (Inokhodets)** : version d''origine des forces russes, quatre bombes ou missiles guidés, 200 kg de charge\n- **Orion-E** : version d''exportation, d''abord vendue en configuration de reconnaissance, puis armée\n- **Inokhodets-RU (Sirius)** : dérivé bimoteur de 30 m d''envergure, 450 kg de charge et 40 heures d''endurance, premier vol en 2023\n- **Helios-RLD** : dérivé de haute altitude et longue endurance de 5 t, maquette présentée en 2020',
  variants_en       = E'- **Orion (Inokhodets)**: original Russian forces version, four guided bombs or missiles, 200 kg payload\n- **Orion-E**: export version, first sold in reconnaissance configuration, later armed\n- **Inokhodets-RU (Sirius)**: twin-engined derivative with a 30 m span, 450 kg payload and 40 hours'' endurance, first flight in 2023\n- **Helios-RLD**: 5 t high-altitude long-endurance derivative, mock-up shown in 2020',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Kronstadt_Orion',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Kronshtadt_Orion',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Nickel nitride',
  image_licence     = 'CC0'
WHERE name = 'Kronshtadt Orion';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Kronshtadt Orion';
