-- PZL Mielec M28 Skytruck
--
-- Photo : PZL M28-05 Skytruck ’44’ (53536712290).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3APZL_M28-05_Skytruck_%E2%80%9944%E2%80%99_%2853536712290%29.jpg

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
    'PZL M28 Skytruck',
    'PZL M28 Skytruck',
    'PZL Mielec M28 Skytruck',
    'PZL Mielec M28 Skytruck',
    'Un An-28 soviétique certifié aux normes américaines',
    'A Soviet An-28 certified to American standards',
    '/assets/airplanes/m28-skytruck.jpg',
    E'## Genèse\nL''**Antonov An-28** est conçu à Kiev mais produit en Pologne, à Mielec, à partir de 1984 — répartition classique du Comecon. Quand le bloc s''effondre, PZL se retrouve avec une chaîne de production, un appareil correct et plus aucun marché : l''URSS n''existe plus et l''Occident n''achète pas de moteurs soviétiques.\n\n## Conception\nPZL fait la seule chose possible : remplacer les turbopropulseurs **Glushenkov** par des **PT6** canadiens, l''hélice par une Hartzell, l''avionique par du Bendix, et faire certifier l''ensemble aux normes américaines. La cellule reste celle de l''An-28 — aile haute à hypersustentateurs, double dérive, train fixe — mais l''appareil devient exportable.\n\n## Carrière opérationnelle\nEnviron cent trente exemplaires, une dizaine de pays. La Pologne l''emploie pour le transport et la surveillance maritime sous le nom de **Bryza**. Les **forces spéciales américaines** en achètent seize sous la désignation C-145A, pour former et soutenir des unités alliées sur des pistes sommaires en Afrique et en Asie centrale.\n\n## Place dans l''histoire\nCent trente exemplaires. Le M28 est le cas d''école de la reconversion post-1989 : conserver la cellule, changer tout ce qui vient de l''Est, et vendre à l''ancien adversaire. PZL Mielec appartient depuis 2007 à **Lockheed Martin**.',
    E'## Genesis\nThe **Antonov An-28** was designed in Kyiv but built in Poland, at Mielec, from 1984 — a classic Comecon division of labour. When the bloc collapsed, PZL found itself with a production line, a sound aircraft and no market at all: the USSR no longer existed and the West does not buy Soviet engines.\n\n## Design\nPZL did the only possible thing: replace the **Glushenkov** turboprops with Canadian **PT6s**, the propeller with a Hartzell, the avionics with Bendix, and have the whole certified to American standards. The airframe stays the An-28''s — high wing with high-lift devices, twin fins, fixed gear — but the aircraft becomes exportable.\n\n## Operational career\nSome one hundred and thirty built, about ten countries. Poland uses it for transport and maritime surveillance as the **Bryza**. **US special forces** bought sixteen as the C-145A, to train and support allied units from rough strips in Africa and Central Asia.\n\n## Place in history\nOne hundred and thirty built. The M28 is the textbook case of post-1989 conversion: keep the airframe, change everything that came from the East, and sell to the former adversary. PZL Mielec has belonged to **Lockheed Martin** since 2007.',
    (SELECT id FROM countries WHERE code = 'POL'),
    '1984-01-01',
    '1993-07-24',
    '2004-01-01',
    355.0,
    1500.0,
    (SELECT id FROM manufacturer WHERE code = 'PZL'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL M28 Skytruck'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL M28 Skytruck'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'PZL M28 Skytruck'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'PZL M28 Skytruck'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.1,
  wingspan          = 22.06,
  height            = 4.9,
  wing_area         = 39.72,
  empty_weight      = 4090,
  mtow              = 7500,
  service_ceiling   = 7620,
  climb_rate        = 8.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 650,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-65B',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1993,
  production_end    = NULL,
  units_built       = 130,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 10,
  variants          = E'- **M28 Skytruck** : version de transport, la plus répandue\n- **M28B Bryza** : versions de patrouille maritime et de surveillance polonaises\n- **C-145A Combat Coyote** : version des **forces spéciales américaines**, seize exemplaires\n- Dérivé de l''**Antonov An-28**, remotorisé en **PT6** canadiens après 1990\n- Double dérive et aile à hypersustentateurs : décolle en **350 m**',
  variants_en       = E'- **M28 Skytruck** : transport version, the most widespread\n- **M28B Bryza** : Polish maritime patrol and surveillance versions\n- **C-145A Combat Coyote** : **US special forces** version, sixteen aircraft\n- Derived from the **Antonov An-28**, re-engined with Canadian **PT6s** after 1990\n- Twin fins and a high-lift wing: takes off in **350 m**',

  -- Strate 4 : qualitatif
  nickname          = 'Skytruck',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/PZL_M28_Skytruck',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/PZL_M28_Skytruck',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'PZL M28 Skytruck';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'PZL M28 Skytruck';
