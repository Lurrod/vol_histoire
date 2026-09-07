-- Yakovlev Yak-38 Forger
--
-- Photo : Yak-38 Forger CVHG Minsk.jpg
--   licence Public domain — US Navy Service Depicted: Other Service
--   https://commons.wikimedia.org/wiki/File%3AYak-38_Forger_CVHG_Minsk.jpg

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
    'Yak-38',
    'Yak-38',
    'Yakovlev Yak-38 Forger',
    'Yakovlev Yak-38 Forger',
    'Seul avion de combat à décollage vertical soviétique en service',
    'The only Soviet VTOL combat aircraft to enter service',
    '/assets/airplanes/yak38-forger.jpg',
    E'## Genèse\nL''URSS ne dispose pas de porte-avions à catapultes. Pour donner une aviation à ses croiseurs porte-aéronefs de la classe **Kiev**, elle mise sur le décollage vertical. Le Yak-38 est la réponse soviétique au Harrier britannique — avec une solution technique radicalement différente.\n\n## Conception\nLà où le Harrier utilise un seul moteur à tuyères orientables, le Yak-38 en aligne **trois** : un réacteur principal à tuyères pivotantes et deux réacteurs de sustentation verticaux juste derrière le cockpit. Ces deux moteurs ne servent qu''au décollage et à l''atterrissage : le reste du temps, ils sont du poids mort. La transition est automatisée et le siège éjectable se déclenche seul en cas d''anomalie en vol stationnaire — une nécessité qui sauvera plusieurs pilotes.\n\n## Carrière opérationnelle\nSes performances déçoivent : rayon d''action très court, charge utile faible, sensibilité extrême à la chaleur. L''essai en conditions réelles en **Afghanistan** en 1980 est un échec — par temps chaud, l''appareil peine à décoller avec un armement significatif. Il sert néanmoins seize ans à bord des quatre croiseurs de la classe Kiev.\n\n## Place dans l''histoire\nRetiré en 1991 avec la fin de l''URSS, il n''a pas de successeur : le **Yak-141**, supersonique et prometteur, est abandonné faute de crédits. Son système de sustentation inspirera pourtant, via une coopération Yakovlev-Lockheed dans les années 1990, la soufflante de sustentation du **F-35B**.',
    E'## Genesis\nThe USSR had no catapult-equipped aircraft carriers. To give its **Kiev**-class aviation cruisers an air arm, it bet on vertical take-off. The Yak-38 was the Soviet answer to the British Harrier — with a radically different technical solution.\n\n## Design\nWhere the Harrier uses a single engine with vectoring nozzles, the Yak-38 has **three**: a main engine with swivelling nozzles and two vertical lift jets just behind the cockpit. Those two engines are only used for take-off and landing; the rest of the time they are dead weight. Transition is automated and the ejection seat fires by itself if anything goes wrong in the hover — a necessity that saved several pilots.\n\n## Operational career\nPerformance disappointed: very short radius, small payload, extreme sensitivity to heat. The 1980 operational trial in **Afghanistan** failed — in hot weather the aircraft struggled to take off with any meaningful load. It nevertheless served sixteen years aboard the four Kiev-class cruisers.\n\n## Place in history\nRetired in 1991 with the end of the USSR, it had no successor: the promising supersonic **Yak-141** was abandoned for lack of funding. Its lift system did, however, inspire the **F-35B** lift fan through a Yakovlev-Lockheed cooperation in the 1990s.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1967-01-01',
    '1971-05-15',
    '1976-08-11',
    1009.0,
    1300.0,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM armement WHERE name = 'Kh-23')),
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM armement WHERE name = 'FAB-250'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Yak-38'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.37,
  wingspan          = 7.32,
  height            = 4.25,
  wing_area         = 18.5,
  empty_weight      = 7385,
  mtow              = 11700,
  service_ceiling   = 11000,
  climb_rate        = 75,
  g_limit_pos       = 6.0,
  g_limit_neg       = NULL,
  combat_radius     = 195,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Tumansky R-28 V-300 + 2 × Rybinsk RD-38',
  engine_count      = 3,
  engine_type       = 'Turboréacteurs de sustentation et de propulsion',
  engine_type_en    = 'Lift and lift-cruise turbojets',
  thrust_dry        = 66.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1974,
  production_end    = 1988,
  units_built       = 231,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Yak-38** : version initiale embarquée\n- **Yak-38M** : moteurs plus puissants, masse au décollage augmentée\n- **Yak-38U** : biplace d''entraînement\n- **Yak-141** : successeur supersonique, annulé en 1991',
  variants_en       = E'- **Yak-38** : initial carrier-borne version\n- **Yak-38M** : uprated engines, higher take-off weight\n- **Yak-38U** : two-seat trainer\n- **Yak-141** : supersonic successor, cancelled in 1991',

  -- Strate 4 : qualitatif
  nickname          = 'Forger',

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-38',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-38',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'US Navy Service Depicted: Other Service',
  image_licence     = 'Public domain'
WHERE name = 'Yak-38';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-38';
