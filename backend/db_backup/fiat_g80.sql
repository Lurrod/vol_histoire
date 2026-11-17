-- Fiat G.80 / G.82
--
-- Photo : Prototype Fiat G.80.jpg
--   licence CC0 — Fiat
--   https://commons.wikimedia.org/wiki/File:Prototype_Fiat_G.80.jpg

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
    'Fiat G.80',
    'Fiat G.80',
    'Fiat G.80 / G.82',
    'Fiat G.80 / G.82',
    'Premier avion à réaction entièrement conçu en Italie, biplace d''entraînement resté sans commande',
    'The first jet aircraft designed entirely in Italy, a two-seat trainer that never won an order',
    '/assets/airplanes/fiat-g80.jpg',
    E'## Genèse\nAu lendemain de la Seconde Guerre mondiale, plusieurs acteurs veulent faire entrer l''Italie dans l''ère du réacteur et relancer son industrie aéronautique. L''**Aeronautica Militare** a besoin d''un avion d''entraînement à réaction pour former ses pilotes aux appareils modernes, et **Fiat**, constructeur historique, cherche à retrouver sa place. Sous la direction de l''ingénieur **Giuseppe Gabrielli**, la firme dessine un biplace national, le **G.80**. Le premier prototype vole le 9 décembre 1951, piloté par **Vittorio Sanseverino** : c''est le premier véritable avion à réaction conçu en Italie à prendre l''air.\n\n## Conception\nLe G.80 est un monoplan à aile basse entièrement métallique, à cabine pressurisée et train tricycle escamotable. Élève et instructeur sont assis en tandem sous une longue verrière, et les entrées d''air du réacteur s''ouvrent sur les flancs du fuselage. Le moteur est britannique : un **de Havilland Goblin**. Pendant les essais, l''avion atteint 840 km/h. Deux prototypes et trois appareils de présérie sont construits.\n\n## Carrière opérationnelle\nÉvalué officiellement, le G.80 déçoit l''armée de l''air : trop peu puissant et plus lourd que ses concurrents étrangers, comme le **Fokker S.14 Machtrainer**. Fiat persiste avec le **G.82**, au fuselage allongé, doté de réservoirs en bout d''aile et surtout d''un **Rolls-Royce Nene** bien plus puissant, qui vole le 23 mai 1954. Présenté au concours de l''OTAN pour un avion d''entraînement standard, il se montre plus performant que le **Lockheed T-33**, mais n''a pas l''avantage économique de ce dernier, déjà en service dans de nombreux pays de l''Alliance, Italie comprise. Le concours est annulé et Fiat abandonne le programme, ainsi que ses projets de chasseur de nuit, de reconnaissance et d''appui. Les quelques G.82 construits servent plusieurs années à l''école d''Amendola, puis passent en 1957 au Reparto Sperimentale Volo.\n\n## Place dans l''histoire\nLe G.80 est un échec commercial, mais il marque le retour de l''Italie dans la conception d''avions militaires après la guerre. Il bute sur un obstacle que rencontrent alors bien des industries européennes : la concurrence d''avions américains déjà amortis et largement diffusés. Fiat prendra sa revanche quelques années plus tard : en 1957, son **G.91** remporte le concours de l''OTAN pour un chasseur léger d''appui.',
    E'## Genesis\nIn the aftermath of the Second World War, several parties wanted to bring Italy into the jet age and revive its aircraft industry. The **Aeronautica Militare** needed a jet trainer to instruct its pilots on modern aircraft, and **Fiat**, a long-established manufacturer, was seeking to reassert itself. Under the engineer **Giuseppe Gabrielli**, the company designed a domestic two-seater, the **G.80**. The first prototype flew on 9 December 1951 with **Vittorio Sanseverino** at the controls: it was the first true jet aircraft designed in Italy to fly.\n\n## Design\nThe G.80 was an all-metal low-wing monoplane with a pressurised cabin and retractable tricycle undercarriage. Student and instructor sat in tandem under a long canopy, and the engine air intakes opened on the fuselage sides. The engine was British: a **de Havilland Goblin**. During testing the aircraft reached 840 km/h. Two prototypes and three pre-production aircraft were built.\n\n## Operational career\nFormally evaluated, the G.80 disappointed the air force: underpowered and heavier than foreign competitors such as the **Fokker S.14 Machtrainer**. Fiat persevered with the **G.82**, with a lengthened fuselage, wingtip tanks and above all a far more powerful **Rolls-Royce Nene**, which flew on 23 May 1954. Entered in the NATO competition for a standard jet trainer, it proved to perform better than the **Lockheed T-33**, but lacked the economic advantage of the latter, already in service with many Alliance nations, Italy included. The competition was cancelled and Fiat abandoned the programme, along with its night fighter, reconnaissance and close-support projects. The few G.82s built served for several years at the Amendola school, then moved in 1957 to the Reparto Sperimentale Volo.\n\n## Place in history\nThe G.80 was a commercial failure, but it marked Italy''s return to military aircraft design after the war. It ran into an obstacle that many European industries faced at the time: competition from American aircraft already paid for and widely distributed. Fiat would have its revenge a few years later: in 1957 its **G.91** won the NATO competition for a light strike fighter.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    NULL,
    '1951-12-09',
    NULL,
    910,
    1600,
    (SELECT id FROM manufacturer WHERE code = 'FIAT'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Fiat G.80'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fiat G.80'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Fiat G.80'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.93,
  wingspan          = 11.81,
  height            = 4.08,
  wing_area         = 25.14,
  empty_weight      = 4400,
  mtow              = 7000,
  service_ceiling   = 12500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Nene 2/21 (G.82)',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 22,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 11,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **G.80-1B** : prototypes à réacteur de Havilland Goblin, deux exemplaires\n- **G.80-3B** : présérie, trois exemplaires\n- **G.81** : version de série prévue du G.80, abandonnée au profit du G.82\n- **G.82** : fuselage allongé, réservoirs en bout d''aile et Rolls-Royce Nene, deux prototypes pour le concours de l''OTAN et quatre de série\n- **G.84** : projet à réacteur Allison J35, jamais construit',
  variants_en       = E'- **G.80-1B**: prototypes with de Havilland Goblin engine, two built\n- **G.80-3B**: pre-production, three built\n- **G.81**: planned production version of the G.80, dropped in favour of the G.82\n- **G.82**: lengthened fuselage, wingtip tanks and Rolls-Royce Nene, two prototypes for the NATO competition and four production aircraft\n- **G.84**: Allison J35-powered project, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fiat_G.80',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Fiat',
  image_licence     = 'CC0'
WHERE name = 'Fiat G.80';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fiat G.80';
