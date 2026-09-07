-- Let L-410 Turbolet
--
-- Photo : Let L-410 UVP, Radom.jpg
--   licence CC BY-SA 4.0 — Raf24~commonswiki
--   https://commons.wikimedia.org/wiki/File%3ALet_L-410_UVP%2C_Radom.jpg

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
    'Let L-410 Turbolet',
    'Let L-410 Turbolet',
    'Let L-410 Turbolet',
    'Let L-410 Turbolet',
    'Plus de mille deux cents exemplaires : le bimoteur léger du bloc de l’Est',
    'More than twelve hundred built: the Eastern bloc’s light twin',
    '/assets/airplanes/l410.jpg',
    E'## Genèse\nL''Aeroflot des années 1960 dessert des milliers de localités sibériennes avec des **An-2** biplans, robustes mais lents et non pressurisés. Il faut un bimoteur moderne, capable de tenir par moins cinquante degrés et de se poser sur une piste gelée. La Tchécoslovaquie, spécialiste du petit avion au sein du **Comecon**, reçoit la commande.\n\n## Conception\nDix-neuf places, aile haute, train tricycle, et — choix décisif — un turbopropulseur conçu spécialement, le **Walter M601** tchèque, après un premier essai avec des Pratt & Whitney canadiens que le blocus rendait incertains. L''appareil démarre sans groupe au sol, se déglace seul et supporte des pistes que rien de plus lourd ne peut utiliser.\n\n## Carrière opérationnelle\nPlus de **mille deux cents exemplaires**, une cinquantaine de pays. Il transporte, largue des parachutistes, forme des équipages et effectue des évacuations sanitaires, de la Sibérie à l''Afrique. Son emploi militaire est répandu chez les anciens membres du pacte de Varsovie, mais aussi en Lituanie, en Estonie et au Bangladesh.\n\n## Place dans l''histoire\nMille deux cents exemplaires, une production ouverte depuis **1970** — cinquante-six ans. Le L-410 est l''appareil le plus produit de Tchécoslovaquie après le **L-39 Albatros**, et le seul avion civil du bloc de l''Est à s''être vendu massivement à l''Ouest après 1990.',
    E'## Genesis\nAeroflot in the 1960s served thousands of Siberian settlements with **An-2** biplanes, rugged but slow and unpressurised. A modern twin was needed, able to work at minus fifty degrees and land on a frozen strip. Czechoslovakia, the **Comecon**''s small-aircraft specialist, received the order.\n\n## Design\nNineteen seats, a high wing, tricycle gear, and — the decisive choice — a purpose-designed turboprop, the Czech **Walter M601**, after a first attempt with Canadian Pratt & Whitneys that the embargo made uncertain. The aircraft starts without a ground unit, de-ices itself and handles strips nothing heavier can use.\n\n## Operational career\nMore than **twelve hundred built**, some fifty countries. It carries freight, drops paratroopers, trains crews and flies medical evacuations, from Siberia to Africa. Military use is widespread among former Warsaw Pact members, but also in Lithuania, Estonia and Bangladesh.\n\n## Place in history\nTwelve hundred built and a production run open since **1970** — fifty-six years. The L-410 is Czechoslovakia''s most produced aircraft after the **L-39 Albatros**, and the only Eastern bloc civil aircraft to have sold heavily in the West after 1990.',
    (SELECT id FROM countries WHERE code = 'CSK'),
    '1966-01-01',
    '1969-04-16',
    '1971-01-01',
    386.0,
    1500.0,
    (SELECT id FROM manufacturer WHERE code = 'LET'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Let L-410 Turbolet'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Let L-410 Turbolet'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Let L-410 Turbolet'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Let L-410 Turbolet'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.42,
  wingspan          = 19.98,
  height            = 5.83,
  wing_area         = 34.86,
  empty_weight      = 4200,
  mtow              = 6600,
  service_ceiling   = 7000,
  climb_rate        = 8.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Walter M601E',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1970,
  production_end    = NULL,
  units_built       = 1200,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 50,
  variants          = E'- **L-410 M / UVP / UVP-E** : générations successives, la UVP à fuselage allongé\n- **L-410 UVP-E20** : version actuelle, certifiée aux normes occidentales\n- **L-420** : version à moteurs plus puissants, homologuée aux États-Unis\n- Moteur **Walter M601** tchèque, conçu spécialement pour lui\n- Conçu pour démarrer et voler par **−50 °C** : cahier des charges sibérien',
  variants_en       = E'- **L-410 M / UVP / UVP-E** : successive generations, the UVP with a stretched fuselage\n- **L-410 UVP-E20** : current version, certified to Western standards\n- **L-420** : more powerful version, certified in the United States\n- Czech **Walter M601** engine, designed specially for it\n- Designed to start and fly at **−50 °C**: a Siberian requirement',

  -- Strate 4 : qualitatif
  nickname          = 'Turbolet',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Let_L-410_Turbolet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Let_L-410_Turbolet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Raf24~commonswiki',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Let L-410 Turbolet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Let L-410 Turbolet';
