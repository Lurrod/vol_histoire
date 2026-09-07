-- IAI 201 / 202 Arava
--
-- Photo : IAI Arava 201 at the Royal Thai Air Force Museum.jpg
--   licence CC BY 4.0 — Photographer: Mosbatho
--   https://commons.wikimedia.org/wiki/File%3AIAI_Arava_201_at_the_Royal_Thai_Air_Force_Museum.jpg

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
    'IAI Arava',
    'IAI Arava',
    'IAI 201 / 202 Arava',
    'IAI 201 / 202 Arava',
    'Le premier avion de transport israélien, vendu surtout en Amérique latine',
    'Israel’s first transport aircraft, sold mostly in Latin America',
    '/assets/airplanes/iai-arava.jpg',
    E'## Genèse\nIsrael Aircraft Industries assemble depuis 1953 des appareils étrangers et modernise des Mirage. En 1966, la firme décide de concevoir de bout en bout — et choisit la catégorie la plus abordable : un transport léger à décollage court, capable d''opérer depuis les pistes sommaires du Néguev et du Sinaï.\n\n## Conception\nUne **double poutre de queue** encadrant un fuselage court et large, dont l''arrière **bascule entièrement** sur charnière pour charger un véhicule ou une civière. Deux PT6 canadiens, une aile haute très portante, un train fixe. L''appareil décolle en trois cents mètres avec deux tonnes et demie — exactement le cahier des charges d''une armée qui opère dans le désert.\n\n## Carrière opérationnelle\nCent trois exemplaires, quinze pays. Israël n''en emploie qu''une dizaine ; l''essentiel part à l''exportation, principalement vers l''**Amérique latine** — Mexique, Équateur, Guatemala, Salvador, Venezuela, Colombie — et vers l''**Eswatini**, la **Thaïlande** et le **Cameroun**. Plusieurs sont perdus lors de conflits internes latino-américains.\n\n## Place dans l''histoire\nCent trois exemplaires. L''Arava est **le premier avion complet conçu en Israël**, avant le **Nesher**, le **Kfir** et le **Lavi** que ce catalogue recense. Il a ouvert à IAI un marché — l''Amérique latine — qui restera pendant trente ans le débouché principal de l''industrie de défense israélienne.',
    E'## Genesis\nIsrael Aircraft Industries had assembled foreign aircraft and upgraded Mirages since 1953. In 1966 the firm decided to design from end to end — and chose the most affordable category: a light short-take-off transport able to work from the rough strips of the Negev and Sinai.\n\n## Design\nA **twin tail boom** framing a short, wide fuselage whose rear **swings open entirely** on a hinge to load a vehicle or a stretcher. Two Canadian PT6s, a high-lift high wing, fixed gear. The aircraft takes off in three hundred metres with two and a half tonnes — exactly the requirement of an army operating in desert.\n\n## Operational career\nOne hundred and three built, fifteen countries. Israel operated only about ten; most went for export, mainly to **Latin America** — Mexico, Ecuador, Guatemala, El Salvador, Venezuela, Colombia — and to **Eswatini**, **Thailand** and **Cameroon**. Several were lost in Latin American internal conflicts.\n\n## Place in history\nOne hundred and three built. The Arava is **the first complete aircraft designed in Israel**, before the **Nesher**, the **Kfir** and the **Lavi** this catalogue records. It opened for IAI a market — Latin America — that would remain the Israeli defence industry''s principal outlet for thirty years.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1966-01-01',
    '1969-11-27',
    '1972-01-01',
    326.0,
    1306.0,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Arava'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Arava'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'IAI Arava'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'IAI Arava'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.03,
  wingspan          = 20.96,
  height            = 5.21,
  wing_area         = 43.68,
  empty_weight      = 3999,
  mtow              = 6804,
  service_ceiling   = 7620,
  climb_rate        = 6.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 550,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-34',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1969,
  production_end    = 1988,
  units_built       = 103,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 15,
  variants          = E'- **IAI 101** : version civile d''origine, peu vendue\n- **IAI 201** : version militaire de transport, la plus produite\n- **IAI 202** : version à ailettes marginales et charge accrue\n- **Fuselage arrière basculant** : la queue s''ouvre entièrement pour le chargement\n- *Arava* désigne la **vallée désertique** entre la mer Morte et la mer Rouge',
  variants_en       = E'- **IAI 101** : original civil version, few sold\n- **IAI 201** : military transport version, the most produced\n- **IAI 202** : version with winglets and increased payload\n- **Swing-tail rear fuselage**: the tail opens entirely for loading\n- *Arava* is the **desert valley** between the Dead Sea and the Red Sea',

  -- Strate 4 : qualitatif
  nickname          = 'Arava',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/IAI_Arava',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAI_Arava',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Photographer: Mosbatho',
  image_licence     = 'CC BY 4.0'
WHERE name = 'IAI Arava';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAI Arava';
