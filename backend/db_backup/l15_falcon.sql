-- Hongdu L-15 Lieying / JL-10
--
-- Photo : Hongdu JL-10 in Zhuhai airshow 2024.jpg
--   licence CC0 — Z3144228
--   https://commons.wikimedia.org/wiki/File%3AHongdu_JL-10_in_Zhuhai_airshow_2024.jpg

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
    'Hongdu L-15',
    'Hongdu L-15',
    'Hongdu L-15 Lieying / JL-10',
    'Hongdu L-15 Lieying / JL-10',
    'École supersonique chinoise dessinée avec l’aide de Yakovlev',
    'Chinese supersonic trainer drawn with Yakovlev’s help',
    '/assets/airplanes/l15-falcon.jpg',
    E'## Genèse\nAu début des années 2000, la Chine met en service des **J-10** et des **J-11** à commandes électriques et cockpit tout-écran, et continue de former ses pilotes sur des dérivés de MiG-21. L''écart devient dangereux. Hongdu lance le L-15 — mais, faute d''expérience sur ce type de cellule, s''adjoint le bureau russe **Yakovlev**, qui vient d''achever le Yak-130.\n\n## Conception\nLa parenté avec le Yak-130 saute aux yeux : mêmes extensions d''emplanture très marquées, même aile, même architecture bimoteur. Le L-15 s''en écarte par la puissance — deux **AI-222** à postcombustion, qui en font un école **supersonique**, ce que le Yak-130 n''est pas. Le cockpit reproduit celui des chasseurs de quatrième génération, écran par écran.\n\n## Carrière opérationnelle\nEnviron deux cents exemplaires. Sous la désignation **JL-10**, il forme les pilotes chinois destinés aux J-10, J-16 et J-20. Il est exporté vers la **Zambie** et les **Émirats arabes unis** — ces derniers en ayant commandé douze en 2022, première vente à un pays du Golfe.\n\n## Place dans l''histoire\nDeux cents exemplaires. Le L-15 marque le moment où la formation chinoise cesse d''avoir une génération de retard sur ses appareils de combat. Il illustre aussi une pratique constante : acheter l''expertise étrangère — russe ici, israélienne pour les radars, ukrainienne pour les moteurs — pour combler ce qui manque.',
    E'## Genesis\nIn the early 2000s China was fielding **J-10s** and **J-11s** with fly-by-wire and glass cockpits while still training its pilots on MiG-21 derivatives. The gap was becoming dangerous. Hongdu launched the L-15 — but, lacking experience with this kind of airframe, brought in the Russian **Yakovlev** bureau, fresh from completing the Yak-130.\n\n## Design\nThe kinship with the Yak-130 is obvious: the same pronounced root extensions, the same wing, the same twin-engine architecture. The L-15 departs from it in power — two afterburning **AI-222s**, which make it a **supersonic** trainer, which the Yak-130 is not. The cockpit reproduces that of fourth-generation fighters, screen for screen.\n\n## Operational career\nSome two hundred built. As the **JL-10** it trains Chinese pilots destined for the J-10, J-16 and J-20. It has been exported to **Zambia** and the **United Arab Emirates**, the latter ordering twelve in 2022, a first sale to a Gulf state.\n\n## Place in history\nTwo hundred built. The L-15 marks the moment Chinese training stopped being a generation behind its combat aircraft. It also illustrates a consistent practice: buy foreign expertise — Russian here, Israeli for radars, Ukrainian for engines — to fill what is missing.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2004-01-01',
    '2006-03-13',
    '2013-01-01',
    1715.0,
    3100.0,
    (SELECT id FROM manufacturer WHERE code = 'HONG'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu L-15'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Hongdu L-15'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Hongdu L-15'), (SELECT id FROM tech WHERE name = 'Radar AESA'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu L-15'), (SELECT id FROM armement WHERE name = 'PL-8')),
((SELECT id FROM airplanes WHERE name = 'Hongdu L-15'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu L-15'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Hongdu L-15'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.27,
  wingspan          = 9.48,
  height            = 4.81,
  wing_area         = 24.6,
  empty_weight      = 4960,
  mtow              = 9800,
  service_ceiling   = 16000,
  climb_rate        = 150.0,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = 550,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko-Progress AI-222-25F',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 24.5,
  thrust_wet        = 41.7,

  -- Strate 3 : production & service
  production_start  = 2010,
  production_end    = NULL,
  units_built       = 200,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **L-15** : désignation export ; **JL-10** en service chinois\n- **L-15A** : version d''entraînement sans postcombustion, subsonique\n- **L-15B / JL-10** : version à postcombustion, supersonique, radar AESA\n- Conçu avec l''assistance du bureau **Yakovlev**, qui venait de faire le Yak-130\n- Exporté vers la **Zambie** et les **Émirats arabes unis**',
  variants_en       = E'- **L-15** : export designation; **JL-10** in Chinese service\n- **L-15A** : training version without afterburners, subsonic\n- **L-15B / JL-10** : afterburning version, supersonic, AESA radar\n- Designed with the help of the **Yakovlev** bureau, fresh from the Yak-130\n- Exported to **Zambia** and the **United Arab Emirates**',

  -- Strate 4 : qualitatif
  nickname          = 'Lieying',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hongdu_L-15',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hongdu_L-15',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Z3144228',
  image_licence     = 'CC0'
WHERE name = 'Hongdu L-15';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Hongdu L-15';
