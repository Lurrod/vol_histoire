-- Hongdu JL-8 / K-8 Karakorum
--
-- Photo : 06-09-819 Pakistan Air Force Hongdu K-8 Karakorum (7955999172).jpg
--   licence CC BY-SA 2.0 — Kurush Pawar from Dubai, United Arab Emirates
--   https://commons.wikimedia.org/wiki/File%3A06-09-819_Pakistan_Air_Force_Hongdu_K-8_Karakorum_%287955999172%29.jpg

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
    'Hongdu K-8 Karakorum',
    'Hongdu K-8 Karakorum',
    'Hongdu JL-8 / K-8 Karakorum',
    'Hongdu JL-8 / K-8 Karakorum',
    'Programme sino-pakistanais devenu l’école la plus vendue d’Asie',
    'A Sino-Pakistani programme turned into Asia’s best-selling trainer',
    '/assets/airplanes/k8-karakorum.jpg',
    E'## Genèse\nLa Chine et le Pakistan sont alliés depuis les années 1960 et partagent une frontière dans le **Karakorum**. En 1986, les deux pays lancent un programme commun d''avion-école à réaction : la Chine apporte l''industrie, le Pakistan un quart du financement et un besoin immédiat. L''appareil prendra le nom du massif qui les sépare.\n\n## Conception\nLe K-8 est moderne pour son origine : aile droite mais profil supercritique, verrière à deux bulles décalées offrant à l''instructeur une vue vers l''avant, siège éjectable zéro-zéro et cinq points d''emport. Le choix décisif est le moteur : un **TFE731 américain**, plus fiable et plus économe que tout ce que la Chine sait produire alors. Les sanctions post-1989 obligeront à développer une version à moteur ukrainien.\n\n## Carrière opérationnelle\nEnviron six cents exemplaires, **quinze forces aériennes** — Égypte, Ghana, Myanmar, Namibie, Soudan, Venezuela, Zambie, Zimbabwe. Le Pakistan l''assemble à Kamra et en a fait la monture de sa patrouille acrobatique, les **Sherdils**. Plusieurs pays l''emploient en appui léger.\n\n## Place dans l''histoire\nSix cents exemplaires et le premier succès à l''export d''un avion chinois hors du monde communiste. Le K-8 a ouvert la voie commerciale qu''emprunteront le **JF-17 Thunder** — également sino-pakistanais — et le **L-15**. C''est l''appareil par lequel l''industrie aéronautique chinoise est devenue exportatrice.',
    E'## Genesis\nChina and Pakistan have been allies since the 1960s and share a border in the **Karakoram**. In 1986 the two countries launched a joint jet trainer programme: China provided the industry, Pakistan a quarter of the funding and an immediate need. The aircraft would take the name of the range that separates them.\n\n## Design\nThe K-8 is modern for its origin: a straight wing but a supercritical section, a stepped twin-bubble canopy giving the instructor a forward view, zero-zero ejection seats and five hardpoints. The decisive choice is the engine: an **American TFE731**, more reliable and more economical than anything China could then build. Post-1989 sanctions would force the development of a Ukrainian-engined version.\n\n## Operational career\nSome six hundred built, **fifteen air forces** — Egypt, Ghana, Myanmar, Namibia, Sudan, Venezuela, Zambia, Zimbabwe. Pakistan assembles it at Kamra and has made it the mount of its display team, the **Sherdils**. Several countries use it for light attack.\n\n## Place in history\nSix hundred built and the first export success of a Chinese aircraft outside the communist world. The K-8 opened the commercial path later taken by the **JF-17 Thunder** — also Sino-Pakistani — and the **L-15**. It is the aircraft through which the Chinese aviation industry became an exporter.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '1986-01-01',
    '1990-11-21',
    '1994-01-01',
    800.0,
    2140.0,
    (SELECT id FROM manufacturer WHERE code = 'HONG'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu K-8 Karakorum'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu K-8 Karakorum'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'Hongdu K-8 Karakorum'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu K-8 Karakorum'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Hongdu K-8 Karakorum'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.6,
  wingspan          = 9.63,
  height            = 4.21,
  wing_area         = 17.02,
  empty_weight      = 2687,
  mtow              = 4330,
  service_ceiling   = 13000,
  climb_rate        = 30.0,
  g_limit_pos       = 7.3,
  g_limit_neg       = -3.0,
  combat_radius     = 1000,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Honeywell TFE731-2A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 16.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1992,
  production_end    = NULL,
  units_built       = 600,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 15,
  variants          = E'- **K-8** : désignation export ; **JL-8** en service chinois\n- **K-8P** : version pakistanaise, assemblée localement à Kamra\n- **JL-8 / K-8V** : versions à commandes de vol électriques pour les essais\n- Nommé d''après le massif du **Karakorum**, frontière entre la Chine et le Pakistan\n- Monture de la patrouille pakistanaise **Sherdils** et de la chinoise **Red Falcon**',
  variants_en       = E'- **K-8** : export designation; **JL-8** in Chinese service\n- **K-8P** : Pakistani version, assembled locally at Kamra\n- **JL-8 / K-8V** : fly-by-wire versions built for testing\n- Named after the **Karakoram** range, the border between China and Pakistan\n- Mount of Pakistan''s **Sherdils** and China''s **Red Falcon** display teams',

  -- Strate 4 : qualitatif
  nickname          = 'Karakorum',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hongdu_JL-8',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hongdu_JL-8',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Kurush Pawar from Dubai, United Arab Emirates',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Hongdu K-8 Karakorum';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Hongdu K-8 Karakorum';
