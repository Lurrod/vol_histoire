-- Yakovlev Yak-23 (Flora)
--
-- Photo : Yakolev Yak-23 '21' (11676613624).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3AYakolev_Yak-23_%2721%27_%2811676613624%29.jpg

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
    'Yak-23',
    'Yak-23',
    'Yakovlev Yak-23 (Flora)',
    'Yakovlev Yak-23 (Flora)',
    'Le jet le plus léger du bloc de l’Est, dépassé avant d’être livré',
    'The Eastern Bloc’s lightest jet, outdated before it was delivered',
    '/assets/airplanes/yak23.jpg',
    E'## Genèse\nEn 1947, la Grande-Bretagne vend à l''URSS des réacteurs **Rolls-Royce Nene et Derwent** — décision que Staline lui-même jugea incompréhensible. Deux bureaux en tirent aussitôt un chasseur : Mikoyan conçoit le MiG-15 autour du Nene, avec une aile en flèche ; Yakovlev choisit le Derwent, plus petit, et une aile droite. Le Yak-23 vole le premier.\n\n## Conception\nTout est réduit au minimum : moins de deux tonnes à vide, treize mètres carrés d''aile, un fuselage à **conduit droit** où l''air entre par le nez et ressort sous le fuselage, laissant le pilote assis au-dessus de la tuyère. La formule est simple, robuste et bon marché — mais l''aile droite plafonne aux abords de Mach 0,85, quand le MiG-15 passe outre.\n\n## Carrière opérationnelle\nL''URSS ne le garde presque pas : trois cent dix exemplaires partent aussitôt vers les satellites — **Pologne, Tchécoslovaquie, Bulgarie, Roumanie** — qui l''exploitent jusqu''au milieu des années 1950. En 1953, un pilote roumain permet aux Américains d''examiner secrètement un exemplaire en Yougoslavie ; il fut remonté, évalué, puis rendu sans que Bucarest ne s''en aperçoive.\n\n## Place dans l''histoire\nTrois cent dix exemplaires et deux ans de production. Il est le dernier chasseur à aile droite de Yakovlev, et le témoin d''un moment très bref où deux bureaux soviétiques ont couru la même course avec le même moteur britannique. Le **MiG-15** l''a gagnée si nettement que Yakovlev abandonnera la chasse pure pour l''intercepteur lourd — le **Yak-25**.',
    E'## Genesis\nIn 1947 Britain sold the USSR **Rolls-Royce Nene and Derwent** engines — a decision Stalin himself found incomprehensible. Two bureaux immediately drew a fighter from them: Mikoyan designed the MiG-15 around the Nene, with a swept wing; Yakovlev chose the smaller Derwent and a straight wing. The Yak-23 flew first.\n\n## Design\nEverything is pared down: under two tonnes empty, thirteen square metres of wing, and a **straight-through** fuselage where air enters at the nose and leaves beneath, the pilot sitting above the jet pipe. The formula is simple, rugged and cheap — but the straight wing tops out near Mach 0.85, where the MiG-15 goes past.\n\n## Operational career\nThe USSR barely kept it: three hundred and ten aircraft went straight to the satellites — **Poland, Czechoslovakia, Bulgaria, Romania** — which flew them into the mid-1950s. In 1953 a Romanian pilot let the Americans secretly examine one in Yugoslavia; it was reassembled, evaluated and returned without Bucharest ever noticing.\n\n## Place in history\nThree hundred and ten built over two years. It is Yakovlev''s last straight-wing fighter, and the witness to a very brief moment when two Soviet bureaux ran the same race with the same British engine. The **MiG-15** won it so decisively that Yakovlev abandoned the pure fighter for the heavy interceptor — the **Yak-25**.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1946-01-01',
    '1947-07-08',
    '1949-01-01',
    925.0,
    1200.0,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-23'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-23'), (SELECT id FROM armement WHERE name = 'NR-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-23'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Yak-23'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-23'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.12,
  wingspan          = 8.73,
  height            = 3.31,
  wing_area         = 13.5,
  empty_weight      = 1980,
  mtow              = 3384,
  service_ceiling   = 14800,
  climb_rate        = 41.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 350,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Klimov RD-500',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 15.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1951,
  units_built       = 310,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **Yak-23** : version de série unique, monoplace de chasse\n- **Yak-23UTI** : biplace d''entraînement, une poignée d''exemplaires\n- Exporté vers la **Pologne**, la Tchécoslovaquie, la Bulgarie et la Roumanie\n- Réacteur **RD-500**, copie soviétique du Rolls-Royce Derwent vendu en 1947\n- Un exemplaire roumain fut secrètement évalué par l''US Air Force en 1953',
  variants_en       = E'- **Yak-23** : the sole production version, a single-seat fighter\n- **Yak-23UTI** : two-seat trainer, a handful built\n- Exported to **Poland**, Czechoslovakia, Bulgaria and Romania\n- **RD-500** engine, a Soviet copy of the Rolls-Royce Derwent sold in 1947\n- A Romanian example was secretly evaluated by the US Air Force in 1953',

  -- Strate 4 : qualitatif
  nickname          = 'Flora',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-23',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-23',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Yak-23';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-23';
