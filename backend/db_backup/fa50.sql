-- KAI FA-50 Fighting Eagle
--
-- Photo : FA-50PH Taking Off - 2019 BACE-P 001.jpg
--   licence Public domain — Staff Sgt. Anthony Small
--   https://commons.wikimedia.org/wiki/File%3AFA-50PH_Taking_Off_-_2019_BACE-P_001.jpg

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
    'KAI FA-50',
    'KAI FA-50',
    'KAI FA-50 Fighting Eagle',
    'KAI FA-50 Fighting Eagle',
    'Premier avion de combat coréen exporté, et vendu à l’OTAN',
    'The first Korean combat aircraft exported, and sold into NATO',
    '/assets/airplanes/fa50.jpg',
    E'## Genèse\nLa Corée du Sud a conçu le **T-50 Golden Eagle** avec Lockheed Martin dans les années 1990, un avion-école supersonique proche d''un F-16 réduit. Une école aussi performante demande peu pour devenir un chasseur léger : un radar, un canon, des points d''emport. En 2008, KAI franchit le pas et développe la version de combat.\n\n## Conception\nRadar israélien **EL/M-2032**, canon rotatif de 20 mm, sept points d''emport, liaison de données tactique. Le F404 reste inchangé — l''appareil ne dépasse pas Mach 1,5 et son rayon d''action de quatre cent quarante kilomètres est court. Il n''est pas fait pour la supériorité aérienne mais pour l''appui et la police du ciel, à un tiers du prix d''un F-16 neuf.\n\n## Carrière opérationnelle\nEnviron deux cents exemplaires, cinq forces aériennes. Les **Philippines** l''engagent réellement dès 2017 lors de la bataille de Marawi, où il exécute des frappes de précision contre des groupes armés. La **Pologne** en commande quarante-huit en 2022 pour remplacer ses MiG-29 cédés à l''Ukraine — première vente d''un avion de combat coréen à un pays de l''OTAN.\n\n## Place dans l''histoire\nDeux cents exemplaires. Le FA-50 a fait de la Corée du Sud le neuvième pays exportateur d''avions de combat. Il ouvre la voie au **KF-21 Boramae**, chasseur de génération 4,5 entièrement coréen, dont il partage l''ambition : ne plus acheter ce qu''on peut construire.',
    E'## Genesis\nSouth Korea designed the **T-50 Golden Eagle** with Lockheed Martin in the 1990s, a supersonic trainer close to a scaled-down F-16. So capable a trainer needs little to become a light fighter: a radar, a gun, hardpoints. In 2008 KAI took the step and developed the combat version.\n\n## Design\nAn Israeli **EL/M-2032** radar, a 20 mm rotary cannon, seven hardpoints, a tactical data link. The F404 is unchanged — the aircraft does not exceed Mach 1.5 and its four-hundred-and-forty-kilometre radius is short. It is not built for air superiority but for support and air policing, at a third the price of a new F-16.\n\n## Operational career\nSome two hundred built, five air forces. The **Philippines** used it in earnest from 2017 at the battle of Marawi, flying precision strikes against armed groups. **Poland** ordered forty-eight in 2022 to replace the MiG-29s given to Ukraine — the first sale of a Korean combat aircraft to a NATO country.\n\n## Place in history\nTwo hundred built. The FA-50 made South Korea the ninth country to export combat aircraft. It opens the way to the **KF-21 Boramae**, a fully Korean generation 4.5 fighter that shares its ambition: stop buying what you can build.',
    (SELECT id FROM countries WHERE code = 'ROK'),
    '2008-01-01',
    '2011-05-04',
    '2013-08-01',
    1837.0,
    1851.0,
    (SELECT id FROM manufacturer WHERE code = 'KAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI FA-50'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'KAI FA-50'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'KAI FA-50'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI FA-50'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'KAI FA-50'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'KAI FA-50'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI FA-50'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'KAI FA-50'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'KAI FA-50'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.14,
  wingspan          = 9.45,
  height            = 4.94,
  wing_area         = 23.69,
  empty_weight      = 6470,
  mtow              = 12300,
  service_ceiling   = 14630,
  climb_rate        = NULL,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = 444,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F404-GE-102',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 53.0,
  thrust_wet        = 78.7,

  -- Strate 3 : production & service
  production_start  = 2011,
  production_end    = NULL,
  units_built       = 200,
  unit_cost_usd     = 30000000,
  unit_cost_year    = 2022,
  operators_count   = 5,
  variants          = E'- **FA-50** : version de combat du **T-50 Golden Eagle**, radar et emport complets\n- **FA-50PH** : version philippine, première exportation en 2015\n- **FA-50PL** : version polonaise, quarante-huit appareils commandés en **2022**\n- **FA-50 Block 20** : ravitaillement en vol et radar AESA, à partir de 2028\n- Développé avec **Lockheed Martin** : la cellule évoque nettement le F-16',
  variants_en       = E'- **FA-50** : combat version of the **T-50 Golden Eagle**, with full radar and payload\n- **FA-50PH** : Philippine version, the first export in 2015\n- **FA-50PL** : Polish version, forty-eight ordered in **2022**\n- **FA-50 Block 20** : aerial refuelling and AESA radar, from 2028\n- Developed with **Lockheed Martin**: the airframe clearly echoes the F-16',

  -- Strate 4 : qualitatif
  nickname          = 'Fighting Eagle',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/KAI_T-50_Golden_Eagle',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/KAI_T-50_Golden_Eagle',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. Anthony Small',
  image_licence     = 'Public domain'
WHERE name = 'KAI FA-50';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'KAI FA-50';
