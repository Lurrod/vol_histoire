-- Xian Y-20 Kunpeng
--
-- Photo : 11059@PEK (20220208110504).jpg
--   licence CC BY-SA 4.0 — N509FZ
--   https://commons.wikimedia.org/wiki/File%3A11059%40PEK_%2820220208110504%29.jpg

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
    'Xian Y-20 Kunpeng',
    'Xian Y-20 Kunpeng',
    'Xian Y-20 Kunpeng',
    'Xian Y-20 Kunpeng',
    'Premier gros-porteur stratégique chinois, clé de la projection de Pékin',
    'China’s first strategic airlifter, the key to Beijing’s reach',
    '/assets/airplanes/y20-kunpeng.jpg',
    E'## Genèse\nLe séisme du **Sichuan en 2008** met la Chine devant une évidence humiliante : elle ne dispose d''aucun appareil capable d''acheminer rapidement des engins lourds vers une zone sinistrée de son propre territoire, et doit affréter des **An-124** ukrainiens. Le programme Y-20, engagé deux ans plus tôt, devient prioritaire. Il vole en 2013, sept ans seulement après son lancement.\n\n## Conception\nL''appareil emprunte visiblement au **C-17** américain sa silhouette générale et son aile supercritique, et à l''**Il-76** son train à roues multiples et sa soute. Le point de blocage est le moteur : les premiers Y-20 volent avec des D-30 russes, peu puissants et gourmands. Le **WS-20** chinois, entré en service en 2023 après vingt ans de développement, porte enfin la charge utile à soixante-cinq tonnes et affranchit le programme de Moscou.\n\n## Carrière opérationnelle\nIl achemine du matériel médical pendant la pandémie, rapatrie des ressortissants chinois d''Afghanistan et du Soudan, livre des systèmes antiaériens à la Serbie en 2022 — première mission d''exportation d''armement lourd par voie aérienne. Sa version ravitailleuse **YY-20** double le rayon d''action des chasseurs chinois, transformant la portée réelle de l''aviation de Pékin.\n\n## Place dans l''histoire\nEnviron quatre-vingts exemplaires en huit ans, cadence rare pour un appareil de cette taille. Il fait de la Chine la troisième nation, après les États-Unis et la Russie, à concevoir et produire un gros-porteur stratégique. Son existence change moins l''équilibre militaire que la **portée logistique** chinoise, qui ne dépendait jusque-là que d''affrètements étrangers.',
    E'## Genesis\nThe **2008 Sichuan earthquake** confronted China with a humiliating fact: it had no aircraft able to move heavy plant quickly to a disaster area on its own territory, and had to charter Ukrainian **An-124s**. The Y-20 programme, launched two years earlier, became a priority. It flew in 2013, just seven years after launch.\n\n## Design\nThe aircraft visibly borrows its general shape and supercritical wing from the American **C-17**, and its multi-wheel gear and hold from the **Il-76**. The sticking point was the engine: early Y-20s flew with Russian D-30s, underpowered and thirsty. The Chinese **WS-20**, entering service in 2023 after twenty years of development, finally raised payload to sixty-five tonnes and freed the programme from Moscow.\n\n## Operational career\nIt carried medical supplies during the pandemic, repatriated Chinese nationals from Afghanistan and Sudan, and delivered air defence systems to Serbia in 2022 — the first airborne export of heavy weaponry. Its **YY-20** tanker version doubles the radius of Chinese fighters, transforming the real reach of Beijing''s air force.\n\n## Place in history\nAbout eighty aircraft in eight years, a rare rate for something this size. It makes China the third nation, after the United States and Russia, to design and build a strategic airlifter. Its existence changes the military balance less than it changes Chinese **logistic reach**, which until then depended entirely on foreign charter.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2006-01-01',
    '2013-01-26',
    '2016-07-06',
    918.0,
    7800.0,
    (SELECT id FROM manufacturer WHERE code = 'XAC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Xian Y-20 Kunpeng'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Xian Y-20 Kunpeng'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Xian Y-20 Kunpeng'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Xian Y-20 Kunpeng'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Xian Y-20 Kunpeng'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Xian Y-20 Kunpeng'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Xian Y-20 Kunpeng'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 47.0,
  wingspan          = 50.0,
  height            = 15.0,
  wing_area         = 310.0,
  empty_weight      = 100000,
  mtow              = 220000,
  service_ceiling   = 13000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4500,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Shenyang WS-20',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 147.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2013,
  production_end    = NULL,
  units_built       = 80,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Y-20A** : version initiale, réacteurs russes D-30KP-2\n- **Y-20B** : version à réacteurs chinois **WS-20**, charge utile portée à 65 tonnes\n- **YY-20** : version ravitailleuse, trois postes de transfert, en service depuis 2021\n- **KJ-3000** : plateforme de guet aérien en développement sur la même cellule\n- Nom tiré du *Kunpeng*, oiseau géant de la mythologie taoïste',
  variants_en       = E'- **Y-20A** : initial version with Russian D-30KP-2 engines\n- **Y-20B** : version with Chinese **WS-20** engines, payload raised to 65 tonnes\n- **YY-20** : tanker version with three transfer stations, in service since 2021\n- **KJ-3000** : airborne early warning platform in development on the same airframe\n- Named after the *Kunpeng*, a giant bird of Taoist mythology',

  -- Strate 4 : qualitatif
  nickname          = 'Kunpeng',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Xian_Y-20',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Xian_Y-20',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'N509FZ',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Xian Y-20 Kunpeng';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Xian Y-20 Kunpeng';
