-- CASA / IPTN CN-235
--
-- Photo : Bray Air Spectacular 2010 - Irish Air Corps CASA CN-235-100MP Persuader (4829222406).jpg
--   licence CC BY-SA 2.0 — William Murphy from Dublin, Ireland
--   https://commons.wikimedia.org/wiki/File%3ABray_Air_Spectacular_2010_-_Irish_Air_Corps_CASA_CN-235-100MP_Persuader_%284829222406%29.jpg

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
    'CASA/IPTN CN-235',
    'CASA/IPTN CN-235',
    'CASA / IPTN CN-235',
    'CASA / IPTN CN-235',
    'Coentreprise hispano-indonésienne, vendue dans quarante pays',
    'Spanish-Indonesian joint venture, sold to forty countries',
    '/assets/airplanes/cn235.jpg',
    E'## Genèse\nL''Indonésie de 1979 est un archipel de dix-sept mille îles sans industrie aéronautique, dirigé par un ingénieur, **B. J. Habibie**, qui veut en créer une. L''Espagne de CASA a le savoir-faire mais un marché intérieur trop étroit. Les deux pays fondent une coentreprise à parts égales — cas presque unique dans l''aéronautique militaire.\n\n## Conception\nUn bimoteur à turbopropulseurs de seize tonnes, aile haute, rampe arrière, capable de se poser sur huit cents mètres de piste sommaire. Le cahier des charges est celui de l''Indonésie autant que de l''Espagne : relier des îles dépourvues d''aérodrome équipé. La production est **partagée** — les ailes en Espagne, le fuselage arrière en Indonésie, assemblage dans les deux pays.\n\n## Carrière opérationnelle\nEnviron trois cents exemplaires, **quarante pays**. La version de patrouille maritime **Persuader** est adoptée par l''Irlande, la Turquie et les garde-côtes américains sous le nom de HC-144. La Turquie et la Corée du Sud l''assemblent aussi sous licence.\n\n## Place dans l''histoire\nTrois cents exemplaires et une descendance, le **C-295**, vendu à plus de deux cents exemplaires supplémentaires. Le CN-235 a doté l''Indonésie d''une industrie aéronautique réelle — la seule d''Asie du Sud-Est — et prouvé qu''une coentreprise entre un pays riche en savoir-faire et un pays riche en besoin peut produire autre chose qu''un montage sous licence.',
    E'## Genesis\nIndonesia in 1979 was an archipelago of seventeen thousand islands with no aircraft industry, led by an engineer, **B. J. Habibie**, who wanted to create one. Spain''s CASA had the know-how but too narrow a home market. The two countries founded a fifty-fifty joint venture — almost unique in military aviation.\n\n## Design\nA sixteen-tonne twin turboprop, high wing, rear ramp, able to land on eight hundred metres of rough strip. The requirement is Indonesia''s as much as Spain''s: connect islands with no equipped airfield. Production is **shared** — wings in Spain, rear fuselage in Indonesia, assembly in both countries.\n\n## Operational career\nSome three hundred built, **forty countries**. The **Persuader** maritime patrol version was adopted by Ireland, Turkey and the US Coast Guard as the HC-144. Turkey and South Korea also assemble it under licence.\n\n## Place in history\nThree hundred built and a descendant, the **C-295**, sold in more than two hundred further examples. The CN-235 gave Indonesia a real aircraft industry — the only one in South-East Asia — and proved that a joint venture between a country rich in know-how and one rich in need can produce something other than licence assembly.',
    (SELECT id FROM countries WHERE code = 'IDN'),
    '1979-01-01',
    '1983-11-11',
    '1988-03-01',
    509.0,
    5003.0,
    (SELECT id FROM manufacturer WHERE code = 'IPTN'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 21.4,
  wingspan          = 25.81,
  height            = 8.18,
  wing_area         = 59.1,
  empty_weight      = 9800,
  mtow              = 16500,
  service_ceiling   = 7620,
  climb_rate        = 7.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1500,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CT7-9C3',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1983,
  production_end    = NULL,
  units_built       = 300,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 40,
  variants          = E'- **CN-235M** : version de transport militaire, la plus répandue\n- **CN-235 MPA Persuader** : patrouille maritime, radar ventral et bulles d''observation\n- **HC-144 Ocean Sentry** : version de l''**US Coast Guard**, dix-huit exemplaires\n- **C-295** : version allongée développée ensuite par CASA seule, plus vendue encore\n- *CN* pour **CASA** et **Nurtanio**, les deux firmes fondatrices',
  variants_en       = E'- **CN-235M** : military transport version, the most widespread\n- **CN-235 MPA Persuader** : maritime patrol, with belly radar and observation bubbles\n- **HC-144 Ocean Sentry** : **US Coast Guard** version, eighteen aircraft\n- **C-295** : stretched version developed afterwards by CASA alone, sold even more widely\n- *CN* for **CASA** and **Nurtanio**, the two founding firms',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/CASA_CN-235',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/CASA/IPTN_CN-235',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'William Murphy from Dublin, Ireland',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'CASA/IPTN CN-235';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'CASA/IPTN CN-235';
