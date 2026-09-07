-- Dassault Mirage III V
--
-- Photo : Dassault Mirage IIIV (MAE).JPG
--   licence CC BY-SA 3.0 — Duch.seb
--   https://commons.wikimedia.org/wiki/File%3ADassault_Mirage_IIIV_%28MAE%29.JPG

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
    'Mirage III V',
    'Mirage III V',
    'Dassault Mirage III V',
    'Dassault Mirage III V',
    'Neuf moteurs pour Mach 2 à la verticale, et deux prototypes détruits',
    'Nine engines for vertical Mach 2, and two prototypes destroyed',
    '/assets/airplanes/mirage-3v.jpg',
    E'## Genèse\nL''appel d''offres de l''OTAN de 1961 pousse la France à entrer dans la course ADAV. Dassault construit d''abord le **Balzac V**, banc d''essai bâti sur une cellule de Mirage III et truffé de huit petits réacteurs verticaux. Il vole en 1962, s''écrase en 1964 tuant son pilote, est reconstruit, puis s''écrase de nouveau en 1965 — tuant un second pilote.\n\n## Conception\nLe Mirage III V en est la version agrandie et opérationnelle. Un réacteur de propulsion **TF106** à l''arrière, et **huit RB.162** britanniques montés verticalement de part et d''autre du fuselage, qui ne servent qu''au décollage et à l''atterrissage. Neuf moteurs pour un monoplace. Le carburant brûlé pendant les phases verticales est tel que le rayon d''action utile tombe sous les trois cents kilomètres.\n\n## Carrière opérationnelle\nAucune. Le prototype 01 vole en février 1965. Le 02, plus puissant, atteint **Mach 2,04** le 12 septembre 1966 : aucun autre appareil à décollage vertical n''a jamais volé aussi vite. Deux mois plus tard, le 28 novembre, il est détruit lors d''une transition ratée. Le programme s''arrête aussitôt.\n\n## Place dans l''histoire\nDeux exemplaires, quatre cellules perdues en comptant les Balzac, trois pilotes tués. Le bilan français est le plus lourd de tous les programmes ADAV européens. Dassault en tire une conclusion définitive et revient à la piste avec le **Mirage F1** — un intercepteur qui, lui, sera vendu à plus de sept cents exemplaires.',
    E'## Genesis\nThe 1961 NATO requirement pushed France into the VTOL race. Dassault first built the **Balzac V**, a testbed on a Mirage III airframe stuffed with eight small vertical engines. It flew in 1962, crashed in 1964 killing its pilot, was rebuilt, then crashed again in 1965 — killing a second pilot.\n\n## Design\nThe Mirage III V is the enlarged, operational version. A **TF106** propulsion engine at the rear, and **eight** British **RB.162s** mounted vertically on either side of the fuselage, used only for take-off and landing. Nine engines for a single-seater. The fuel burned during the vertical phases is such that useful range falls below three hundred kilometres.\n\n## Operational career\nNone. Prototype 01 flew in February 1965. The more powerful 02 reached **Mach 2.04** on 12 September 1966: no other vertical take-off aircraft has ever flown as fast. Two months later, on 28 November, it was destroyed in a failed transition. The programme stopped at once.\n\n## Place in history\nTwo built, four airframes lost counting the Balzacs, three pilots killed. The French toll is the heaviest of all the European VTOL programmes. Dassault drew a definitive conclusion and returned to the runway with the **Mirage F1** — an interceptor that would sell more than seven hundred aircraft.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1961-01-01',
    '1965-02-12',
    NULL,
    2340.0,
    800.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage III V'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Mirage III V'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage III V'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Mirage III V'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage III V'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.3,
  wingspan          = 8.72,
  height            = 5.55,
  wing_area         = 35.0,
  empty_weight      = 6750,
  mtow              = 13500,
  service_ceiling   = 18000,
  climb_rate        = 150.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 280,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA TF106 + 8 Rolls-Royce RB.162',
  engine_count      = 9,
  engine_type       = 'Turboréacteur et réacteurs de sustentation',
  engine_type_en    = 'Turbofan and lift jets',
  thrust_dry        = 53.0,
  thrust_wet        = 82.4,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1966,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Balzac V** : démonstrateur préalable, cellule de Mirage III, détruit deux fois\n- **Mirage III V 01 / 02** : deux prototypes, l''un et l''autre perdus en essais\n- **Neuf moteurs** : un de propulsion, huit RB.162 verticaux dans le fuselage\n- Atteint **Mach 2,04 le 12 septembre 1966**, seul ADAV à y être parvenu\n- Abandonné après le crash du 02 : la France choisit le **Mirage F1**',
  variants_en       = E'- **Balzac V** : preliminary demonstrator on a Mirage III airframe, destroyed twice\n- **Mirage III V 01 / 02** : two prototypes, both lost in testing\n- **Nine engines**: one for propulsion, eight vertical RB.162 in the fuselage\n- Reached **Mach 2.04 on 12 September 1966**, the only VTOL ever to do so\n- Abandoned after the loss of 02: France chose the **Mirage F1** instead',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_Mirage_III_V',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_Mirage_IIIV',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Duch.seb',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Mirage III V';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mirage III V';
