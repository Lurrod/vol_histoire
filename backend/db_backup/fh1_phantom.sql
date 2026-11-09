-- McDonnell FH-1 Phantom
--
-- Photo : FH-1 Phantom in flight in February 1948 cropped.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:FH-1_Phantom_in_flight_in_February_1948_cropped.jpg

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
    'FH-1 Phantom',
    'FH-1 Phantom',
    'McDonnell FH-1 Phantom',
    'McDonnell FH-1 Phantom',
    'Le premier avion à réaction à apponter sur un porte-avions américain, en juillet 1946',
    'The first jet to land on an American aircraft carrier, in July 1946',
    '/assets/airplanes/fh1-phantom.jpg',
    E'## Genèse\nEn 1943, l''US Navy veut savoir si un avion à réaction peut opérer depuis un porte-avions. Elle confie l''étude à **McDonnell**, jeune constructeur de Saint-Louis qui n''a encore produit aucun avion de série : les grands bureaux d''études sont absorbés par la production de guerre, et la Marine veut une équipe libre de tout autre programme. Trois prototypes sont commandés en août 1943. Le premier vole le **26 janvier 1945**.\n\n## Conception\nLes premiers réacteurs américains sont faibles. McDonnell étudie d''abord des formules à nombreux petits moteurs, jusqu''à huit, avant de retenir deux **Westinghouse J30** de 7 kN chacun, logés dans les emplantures d''une aile droite repliable. Le nez, libéré de toute hélice, reçoit quatre mitrailleuses de 12,7 mm. L''avion atteint 813 km/h, mais ses réacteurs mettent plusieurs secondes à reprendre de la puissance, ce qui rend toute remise de gaz délicate à l''appontage. Désigné d''abord **FD-1**, il devient **FH-1** en 1946, la lettre D revenant à Douglas.\n\n## Carrière opérationnelle\nLe **21 juillet 1946**, le prototype apponte sur l''**USS Franklin D. Roosevelt** : c''est le premier avion à réaction pur à se poser sur un porte-avions américain, sept mois après le Sea Vampire britannique. Soixante-deux appareils sont construits. Le VF-17A en reçoit à partir de 1947 et devient en 1948 la première flottille à réaction qualifiée sur porte-avions de l''US Navy. Les Marines en équipent le VMF-122, qui forme une patrouille de présentation. Dès 1949, le FH-1 quitte les unités de première ligne ; la réserve le garde jusqu''en 1954.\n\n## Place dans l''histoire\nUn appareil de transition, construit en petit nombre et vite remplacé. Mais il fonde la lignée navale de McDonnell : le **F2H Banshee** en est l''agrandissement direct, le **F3H Demon** lui succède, et le nom de Phantom est repris en 1959 pour le **F-4 Phantom II**, l''avion de combat occidental le plus produit de son époque. Tout commence avec ces deux petits réacteurs dans les ailes.',
    E'## Genesis\nIn 1943 the US Navy wanted to know whether a jet could operate from an aircraft carrier. It gave the study to **McDonnell**, a young St. Louis manufacturer that had yet to build a production aircraft: the big design offices were absorbed by war production, and the Navy wanted a team free of any other programme. Three prototypes were ordered in August 1943. The first flew on **26 January 1945**.\n\n## Design\nThe first American jet engines were weak. McDonnell first studied layouts with many small engines, up to eight, before settling on two **Westinghouse J30s** of 7 kN each, housed in the roots of a folding straight wing. The nose, free of any propeller, took four 12.7 mm machine guns. The aircraft reached 813 km/h, but its engines took several seconds to spool up, making any go-around on a carrier approach a delicate matter. First designated **FD-1**, it became the **FH-1** in 1946, the letter D going to Douglas.\n\n## Operational career\nOn **21 July 1946** the prototype landed on **USS Franklin D. Roosevelt**: the first pure jet to land on an American carrier, seven months after the British Sea Vampire. Sixty-two were built. VF-17A received them from 1947 and in 1948 became the US Navy’s first carrier-qualified jet squadron. The Marines equipped VMF-122 with them, which formed a display team. From 1949 the FH-1 left front-line units; the reserve kept it until 1954.\n\n## Place in history\nA transitional aircraft, built in small numbers and soon replaced. But it founded McDonnell’s naval line: the **F2H Banshee** is its direct enlargement, the **F3H Demon** followed, and the Phantom name was taken up again in 1959 for the **F-4 Phantom II**, the most-produced Western combat aircraft of its era. It all began with those two small engines in the wings.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1943-08-01',
    '1945-01-26',
    '1947-08-01',
    813.0,
    1110.0,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'FH-1 Phantom'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'FH-1 Phantom'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'FH-1 Phantom'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'FH-1 Phantom'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'FH-1 Phantom'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'FH-1 Phantom'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'FH-1 Phantom'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.35,
  wingspan          = 12.42,
  height            = 4.32,
  wing_area         = 25.43,
  empty_weight      = 3031,
  mtow              = 5459,
  service_ceiling   = 12500,
  climb_rate        = 21.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse J30-WE-20',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 7.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 62,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XFD-1** : prototypes, premier vol le 26 janvier 1945, appontage du 21 juillet 1946\n- **FD-1 / FH-1** : chasseur embarqué de série, redésigné en 1946 (la lettre D revient à Douglas)\n- Unités : **VF-17A** de l''US Navy, première flottille à réaction qualifiée sur porte-avions (1948)\n- **VMF-122** des Marines, et sa patrouille de présentation sur Phantom\n- Retiré de première ligne en **1949**, de la réserve en 1954',
  variants_en       = E'- **XFD-1** : prototypes, first flight on 26 January 1945, carrier landing on 21 July 1946\n- **FD-1 / FH-1** : production carrier fighter, redesignated in 1946 (the letter D went to Douglas)\n- Units: the US Navy’s **VF-17A**, first carrier-qualified jet squadron (1948)\n- The Marines’ **VMF-122**, and its Phantom display team\n- Withdrawn from the front line in **1949**, from the reserve in 1954',

  -- Strate 4 : qualitatif
  nickname          = 'Phantom',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_FH-1_Phantom',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_FH_Phantom',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'FH-1 Phantom';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'FH-1 Phantom';
