-- PAC MFI-395 Super Mushshak
--
-- Photo : PAC Super Mushshak at Dubai Air Show 2017.jpg
--   licence CC BY-SA 4.0 — Mztourist
--   https://commons.wikimedia.org/wiki/File%3APAC_Super_Mushshak_at_Dubai_Air_Show_2017.jpg

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
    'PAC Super Mushshak',
    'PAC Super Mushshak',
    'PAC MFI-395 Super Mushshak',
    'PAC MFI-395 Super Mushshak',
    'Une cellule suédoise devenue le premier avion exporté du Pakistan',
    'A Swedish airframe turned into Pakistan’s first exported aircraft',
    '/assets/airplanes/super-mushshak.jpg',
    E'## Genèse\nLe Pakistan de 1974 assemble sous licence des Mirage et achète des F-6 chinois, mais ne conçoit rien. Le complexe aéronautique de **Kamra** est créé pour changer cela, et commence par le plus accessible : construire sous licence le **MFI-17 Supporter** suédois, petit biplace d''observation dérivé du Saab Safari.\n\n## Conception\nL''appareil est minuscule — une tonne deux à pleine charge — avec deux places côte à côte, une verrière bulle et un train fixe. La transformation pakistanaise porte sur le moteur : le Lycoming passe de deux cents à **deux cent soixante chevaux** et reçoit une hélice tripale, ce qui donne au Super Mushshak les performances nécessaires par temps chaud et en altitude — condition qui décide de tout au Pakistan.\n\n## Carrière opérationnelle\nEnviron cinq cents exemplaires depuis 1975. La force aérienne et l''armée de terre pakistanaises l''emploient pour la formation élémentaire, l''observation d''artillerie et la liaison. Il est exporté vers **treize pays**, du Nigeria à l''Azerbaïdjan, et l''**Arabie saoudite** en a commandé vingt en 2017 — première vente d''un avion pakistanais à un pays du Golfe.\n\n## Place dans l''histoire\nCinq cents exemplaires. Le Mushshak n''est pas une conception pakistanaise, et c''est précisément ce qui rend son histoire instructive : le pays a commencé par la licence, puis a modifié, puis a coconçu le **K-8 Karakorum** et le **JF-17 Thunder** avec la Chine. Cinquante ans pour passer d''assembleur à partenaire.',
    E'## Genesis\nPakistan in 1974 assembled Mirages under licence and bought Chinese F-6s, but designed nothing. The aeronautical complex at **Kamra** was created to change that, and began with the most accessible step: licence-building the Swedish **MFI-17 Supporter**, a small two-seat observation aircraft derived from the Saab Safari.\n\n## Design\nThe aircraft is tiny — one point two tonnes fully loaded — with two side-by-side seats, a bubble canopy and fixed gear. The Pakistani change concerns the engine: the Lycoming goes from two hundred to **two hundred and sixty horsepower** and gains a three-blade propeller, giving the Super Mushshak the performance needed in heat and at altitude — the condition that decides everything in Pakistan.\n\n## Operational career\nSome five hundred built since 1975. The Pakistani air force and army use it for elementary training, artillery observation and liaison. It has been exported to **thirteen countries**, from Nigeria to Azerbaijan, and **Saudi Arabia** ordered twenty in 2017 — the first sale of a Pakistani aircraft to a Gulf state.\n\n## Place in history\nFive hundred built. The Mushshak is not a Pakistani design, and that is precisely what makes its story instructive: the country began with a licence, then modified, then co-designed the **K-8 Karakorum** and the **JF-17 Thunder** with China. Fifty years to go from assembler to partner.',
    (SELECT id FROM countries WHERE code = 'PAK'),
    '1974-01-01',
    '1996-01-01',
    '1997-01-01',
    264.0,
    1046.0,
    (SELECT id FROM manufacturer WHERE code = 'PAC'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'PAC Super Mushshak'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'PAC Super Mushshak'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'PAC Super Mushshak'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'PAC Super Mushshak'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.0,
  wingspan          = 8.85,
  height            = 2.6,
  wing_area         = 11.9,
  empty_weight      = 770,
  mtow              = 1200,
  service_ceiling   = 4100,
  climb_rate        = 6.5,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = 400,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming IO-540-V4A5',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1975,
  production_end    = NULL,
  units_built       = 500,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 13,
  variants          = E'- **Mushshak** : version d''origine, MFI-17 Supporter suédois construit sous licence\n- **Super Mushshak** : moteur porté de 200 à **260 ch**, hélice tripale, depuis 1996\n- *Mushshak* signifie « **habile** » en ourdou ; *shahbaz* désigne le faucon\n- Places **côte à côte**, quatre points d''emport sous voilure sur la version armée\n- Exporté vers **treize forces aériennes**, dont l''Azerbaïdjan, le Nigeria, l''Irak et Oman',
  variants_en       = E'- **Mushshak** : original version, the Swedish MFI-17 Supporter built under licence\n- **Super Mushshak** : engine raised from 200 to **260 hp**, three-blade propeller, since 1996\n- *Mushshak* means ''**proficient**'' in Urdu; *shahbaz* denotes the falcon\n- **Side-by-side** seating, four underwing hardpoints on the armed version\n- Exported to **thirteen air forces**, including Azerbaijan, Nigeria, Iraq and Oman',

  -- Strate 4 : qualitatif
  nickname          = 'Mushshak',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/PAC_MFI-17_Mushshak',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/PAC_MFI-17_Mushshak',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mztourist',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'PAC Super Mushshak';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'PAC Super Mushshak';
