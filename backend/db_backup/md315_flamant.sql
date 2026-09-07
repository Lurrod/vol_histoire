-- Dassault MD 311 / 312 / 315 Flamant
--
-- Photo : Dassault Flamant at Ferte-Alais Air Show 2004 02.jpg
--   licence CC BY-SA 3.0 — Lionel Allorge
--   https://commons.wikimedia.org/wiki/File%3ADassault_Flamant_at_Ferte-Alais_Air_Show_2004_02.jpg

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
    'Dassault MD 315 Flamant',
    'Dassault MD 315 Flamant',
    'Dassault MD 311 / 312 / 315 Flamant',
    'Dassault MD 311 / 312 / 315 Flamant',
    'Le premier appareil de série de Dassault, sorti des ruines de 1945',
    'Dassault’s first production aircraft, out of the ruins of 1945',
    '/assets/airplanes/md315-flamant.jpg',
    E'## Genèse\nMarcel Bloch sort du camp de Buchenwald en 1945, reprend son entreprise nationalisée et la rebaptise du nom de résistance de son frère : **Dassault**. La France a besoin de tout, et d''abord d''un appareil de liaison, d''entraînement et de transport léger pour remplacer les matériels américains prêtés. Le Flamant est la réponse.\n\n## Conception\nUn bimoteur de six tonnes à structure métallique et train rentrant, propulsé par des moteurs en V **SNECMA 12S** — c''est-à-dire des Argus allemands construits sous licence, l''industrie française ne produisant alors rien d''autre. Trois versions couvrent tous les besoins : nez vitré pour former les bombardiers, cabine pour la liaison, points d''emport pour l''outre-mer.\n\n## Carrière opérationnelle\nTrois cent vingt-cinq exemplaires. Le Flamant sert en métropole, en **Indochine** et en **Algérie**, où sa version MD 315 armée effectue des missions d''observation et d''appui léger. Il forme aussi les navigateurs et les mécaniciens navigants français pendant plus de vingt ans, jusqu''en 1981.\n\n## Place dans l''histoire\nTrois cent vingt-cinq exemplaires. Le Flamant est **le premier avion produit en série par Dassault**, maison qui donnera ensuite l''Ouragan, le Mystère, le Mirage et le Rafale — dont ce catalogue compte une vingtaine d''appareils. Il rappelle que la plus célèbre firme de chasse française a commencé par un bimoteur de liaison à moteurs allemands.',
    E'## Genesis\nMarcel Bloch came out of Buchenwald in 1945, took back his nationalised company and renamed it after his brother''s resistance name: **Dassault**. France needed everything, and first of all a liaison, training and light transport aircraft to replace lent American equipment. The Flamant was the answer.\n\n## Design\nA six-tonne twin with metal structure and retractable gear, powered by **SNECMA 12S** V engines — that is, licence-built German Arguses, French industry then producing nothing else. Three versions cover every need: a glazed nose to train bomb-aimers, a cabin for liaison, hardpoints for overseas work.\n\n## Operational career\nThree hundred and twenty-five built. The Flamant served at home, in **Indochina** and in **Algeria**, where its armed MD 315 version flew observation and light support missions. It also trained French navigators and flight engineers for more than twenty years, until 1981.\n\n## Place in history\nThree hundred and twenty-five built. The Flamant is **the first aircraft series-produced by Dassault**, a house that would go on to give the Ouragan, the Mystère, the Mirage and the Rafale — of which this catalogue holds some twenty. It is a reminder that France''s most famous fighter firm began with a liaison twin powered by German engines.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1945-01-01',
    '1947-02-10',
    '1949-01-01',
    380.0,
    1200.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Dassault MD 315 Flamant'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Dassault MD 315 Flamant'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'Dassault MD 315 Flamant'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Dassault MD 315 Flamant'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Dassault MD 315 Flamant'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Dassault MD 315 Flamant'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Dassault MD 315 Flamant'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.55,
  wingspan          = 20.67,
  height            = 4.5,
  wing_area         = 47.0,
  empty_weight      = 4200,
  mtow              = 5800,
  service_ceiling   = 8000,
  climb_rate        = 6.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA 12S-02',
  engine_count      = 2,
  engine_type       = 'Moteur en V',
  engine_type_en    = 'V engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1948,
  production_end    = 1953,
  units_built       = 325,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **MD 311** : version de formation au bombardement, nez entièrement vitré\n- **MD 312** : version de transport et de liaison, six passagers\n- **MD 315** : version de reconnaissance et d''appui colonial, la plus produite\n- Premier appareil de série de **Marcel Bloch**, revenu de Buchenwald sous le nom Dassault\n- Engagé en **Indochine** et en **Algérie** pour la liaison et l''observation',
  variants_en       = E'- **MD 311** : bombing-training version, with a fully glazed nose\n- **MD 312** : transport and liaison version, six passengers\n- **MD 315** : reconnaissance and colonial support version, the most produced\n- The first production aircraft of **Marcel Bloch**, back from Buchenwald as Dassault\n- Used in **Indochina** and **Algeria** for liaison and observation',

  -- Strate 4 : qualitatif
  nickname          = 'Flamant',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_MD_315_Flamant',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_MD_315_Flamant',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Lionel Allorge',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Dassault MD 315 Flamant';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Dassault MD 315 Flamant';
