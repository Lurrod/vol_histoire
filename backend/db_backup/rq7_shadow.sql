-- AAI RQ-7 Shadow 200
--
-- Photo : Exercise Swift Response RQ-7B V2 Shadow Operations 7195390.jpg
--   licence Public domain — U.S. Army photo by Staff Sgt. Malcolm Cohens-Ashley, 40th Public Affairs Detachment
--   https://commons.wikimedia.org/wiki/File:Exercise_Swift_Response_RQ-7B_V2_Shadow_Operations_7195390.jpg

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
    'RQ-7 Shadow',
    'RQ-7 Shadow',
    'AAI RQ-7 Shadow 200',
    'AAI RQ-7 Shadow 200',
    'Le drone de brigade de l''US Army, lancé par catapulte et arrêté au brin, qui a volé près d''un million d''heures',
    'The US Army''s brigade drone, catapult-launched and stopped by an arresting wire, which flew almost a million hours',
    '/assets/airplanes/rq7-shadow.jpg',
    E'## Genèse\nÀ la fin des années 1990, l''**US Army** cherche toujours un drone tactique efficace : l''**Alliant RQ-6 Outrider** accumule les problèmes et finit annulé. **AAI Corporation**, qui fabrique déjà le **RQ-2 Pioneer**, propose son successeur affiné, le **Shadow 200**. L''Army le choisit fin 1999 et le désigne RQ-7. Le cahier des charges demande un moteur à essence, une tourelle optique et infrarouge, 50 km de portée et quatre heures sur zone, avec la possibilité de se poser sur un terrain de sport : le Shadow offre au moins le double de portée.\n\n## Conception\nC''est un petit monoplan à aile haute à corde constante, à hélice propulsive, double poutre et empennage en V inversé, mû par un moteur rotatif **Wankel** de 38 ch fabriqué au Royaume-Uni. Une catapulte pneumatique montée sur remorque le lance à 130 km/h en 12 m ; au retour, un radar au sol le guide jusqu''au toucher, et une crosse accroche un brin d''arrêt qui l''immobilise en moins de 52 m. Sa tourelle d''origine israélienne, la POP300, associe caméra thermique, caméra de jour et pointeur laser. Un système complet compte quatre appareils, des Humvee, deux stations de contrôle et 22 soldats.\n\n## Carrière opérationnelle\nLivré en présérie en 2002, le Shadow fait ses débuts lors de l''invasion de l''**Irak** en 2003. La chaleur et le sable y provoquent des pannes de moteur en série, que l''Army corrige à marche forcée, notamment en imposant l''essence d''aviation. Il vole ensuite des centaines de milliers d''heures de combat en Irak et en **Afghanistan**. Les Marines l''adoptent en 2007 à la place du Pioneer et l''engagent en Irak dès octobre, avant de le retirer en 2018. Des essais d''armement sont menés à partir de 2011, puis abandonnés en 2015 faute de crédits.\n\n## Place dans l''histoire\nPlus de 900 000 heures de vol à la mi-2014 : le Shadow a fait du drone un outil ordinaire de la brigade américaine. À partir de 2015, il remplace même l''hélicoptère d''observation OH-58 Kiowa en éclairant pour les Apache. Exporté en Australie, en Suède, en Italie et, en version Shadow 600, en Turquie et en Roumanie, il voit pourtant l''Army annoncer en février 2024 son remplacement complet.',
    E'## Genesis\nIn the late 1990s the **US Army** was still looking for an effective tactical drone: the **Alliant RQ-6 Outrider** ran into trouble and was eventually cancelled. **AAI Corporation**, already building the **RQ-2 Pioneer**, offered its refined successor, the **Shadow 200**. The Army selected it in late 1999 and designated it RQ-7. The requirement called for a petrol engine, an electro-optical and infrared turret, 50 km of range and four hours on station, with the ability to land on a sports field: the Shadow offered at least twice the range.\n\n## Design\nIt is a small high-wing monoplane with a constant-chord wing, a pusher propeller, twin booms and an inverted V-tail, powered by a 38 hp **Wankel** rotary engine made in the United Kingdom. A trailer-mounted pneumatic catapult launches it at 130 km/h in 12 m; on return, a ground radar guides it to touchdown, and a tailhook catches an arresting wire that stops it in less than 52 m. Its Israeli-designed POP300 turret combines a thermal camera, a daylight camera and a laser pointer. A complete system comprises four aircraft, Humvees, two control stations and 22 soldiers.\n\n## Operational career\nDelivered in low-rate production in 2002, the Shadow made its debut during the 2003 invasion of **Iraq**. Heat and sand caused a run of engine failures there, which the Army fixed in a hurry, notably by mandating aviation fuel. It went on to fly hundreds of thousands of combat hours in Iraq and **Afghanistan**. The Marines adopted it in 2007 in place of the Pioneer and took it to Iraq that October, before retiring it in 2018. Arming trials began in 2011 and were dropped in 2015 for lack of funding.\n\n## Place in history\nMore than 900,000 flight hours by mid-2014: the Shadow made the drone an everyday tool of the American brigade. From 2015 it even replaced the OH-58 Kiowa scout helicopter, scouting ahead for Apaches. Exported to Australia, Sweden and Italy and, as the Shadow 600, to Turkey and Romania, it nevertheless saw the Army announce its complete replacement in February 2024.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1991-01-01',
    '2002-01-01',
    200,
    110,
    (SELECT id FROM manufacturer WHERE code = 'AAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-7 Shadow'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'RQ-7 Shadow'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-7 Shadow'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-7 Shadow'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'RQ-7 Shadow'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 3.41,
  wingspan          = 4.3,
  height            = 1.0,
  wing_area         = NULL,
  empty_weight      = 77,
  mtow              = 170,
  service_ceiling   = 4600,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'UEL AR741-1101 (38 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur rotatif',
  engine_type_en    = 'Rotary engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2002,
  production_end    = NULL,
  units_built       = 500,
  unit_cost_usd     = 275000,
  unit_cost_year    = 2002,
  operators_count   = 6,
  variants          = E'- **RQ-7A** : version initiale livrée en 2002, 3,89 m d''envergure, tourelle POP200\n- **RQ-7B** : voilure portée à 4,3 m et transformée en réservoir, six heures d''endurance, tourelle POP300, produit à partir de l''été 2004\n- **RQ-7BV2** : liaison TCDL chiffrée, injection électronique, envergure de 6,1 m et neuf heures d''endurance, en service à partir de 2015\n- **Shadow 600** : dérivé agrandi du Pioneer à voilure externe en flèche, exporté en Roumanie et en Turquie\n- **Nightwarden (Shadow M2)** : version plus lourde à fuselage intégré, liaison satellite et quinze heures d''endurance, présentée en 2017',
  variants_en       = E'- **RQ-7A**: initial version delivered in 2002, 3.89 m span, POP200 turret\n- **RQ-7B**: wing extended to 4.3 m and made into a fuel tank, six hours'' endurance, POP300 turret, built from summer 2004\n- **RQ-7BV2**: encrypted TCDL link, electronic fuel injection, 6.1 m span and nine hours'' endurance, in service from 2015\n- **Shadow 600**: enlarged Pioneer derivative with swept outer wing panels, exported to Romania and Turkey\n- **Nightwarden (Shadow M2)**: heavier version with a blended body, satellite link and fifteen hours'' endurance, unveiled in 2017',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/AAI_Shadow_200',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AAI_RQ-7_Shadow',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. Malcolm Cohens-Ashley, U.S. Army',
  image_licence     = 'Public domain'
WHERE name = 'RQ-7 Shadow';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'RQ-7 Shadow';
