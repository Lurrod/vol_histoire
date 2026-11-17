-- Breguet Br 941
--
-- Photo : 24.05.65 Le Bréguet 941 à atterrissage court en Forêt de Bouconne (1965) - 53Fi2253.jpg
--   licence CC BY-SA 4.0 — André Cros
--   https://commons.wikimedia.org/wiki/File:24.05.65_Le_Br%C3%A9guet_941_%C3%A0_atterrissage_court_en_For%C3%AAt_de_Bouconne_(1965)_-_53Fi2253.jpg

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
    'Breguet 941',
    'Breguet 941',
    'Breguet Br 941',
    'Breguet Br 941',
    'Le quadrimoteur à aile soufflée qui décollait en 185 m et qu''aucune compagnie n''a voulu',
    'The blown-wing four-engined transport that took off in 185 m and that no airline wanted',
    '/assets/airplanes/breguet-941.jpg',
    E'## Genèse\nÀ la fin des années 1940, le pionnier **Louis Breguet** imagine un avion à décollage et atterrissage courts dont l''aile serait entièrement balayée par le souffle de quatre grandes hélices : l''« aile soufflée ». Un démonstrateur, le **Breguet 940 Intégral**, vole le 21 mai 1958 et prouve l''intérêt du principe. En février 1960, l''État commande un prototype capable d''emporter une charge utile, en ne finançant qu''un quart du budget. Le Breguet 941 vole le 1er juin 1961.\n\n## Conception\nQuatre turbines **Turbomeca Turmo** entraînent des hélices de 4 m reliées entre elles par des arbres de transmission : si un moteur s''arrête, toute l''aile reste soufflée de façon égale, à 75 % de la puissance. Les moteurs intérieurs et extérieurs tournent en sens inverse pour annuler le couple, et de grands volets à fente sur toute l''envergure se braquent jusqu''à près de 95°. Le **941S** de série, plus puissant, vole le 19 avril 1967 avec une porte arrière modifiée pour le largage de charges. Il lui suffit de 185 m de roulage pour décoller à 22 t, avec 57 passagers ou 40 soldats équipés en cabine.\n\n## Carrière opérationnelle\nMcDonnell achète une licence et promeut l''avion aux États-Unis sous le nom de **McDonnell 188** : le prototype y est démontré fin 1964 et début 1965, évalué par la NASA et l''armée américaine, sans commande. De retour en France, il multiplie les atterrissages courts, comme en forêt de Bouconne, près de Toulouse, en mai 1965. En 1968, un 941S assure deux mois de liaisons pour Eastern Air Lines, puis il est testé par American Airlines et la FAA pour évaluer le concept d''aéroport court en centre-ville. Les quatre 941S servent dans l''armée de l''air de 1967 à 1974, en dernier lieu à l''escadron « Ventoux » de Reims.\n\n## Place dans l''histoire\nMalgré une promotion intense de part et d''autre de l''Atlantique, le Breguet 941 n''a été construit qu''à cinq exemplaires, et ses dérivés civils, le Breguet 942 et les McDonnell 188E et 210, sont restés à l''état de projets : les compagnies voulaient des jets sur des aéroports classiques. Ses performances de décollage court n''en restent pas moins remarquables. Deux 941S sont conservés, l''un à Toulouse par les Ailes Anciennes, l''autre dans les réserves du Musée de l''Air au Bourget.',
    E'## Genesis\nIn the late 1940s the aviation pioneer **Louis Breguet** conceived a short take-off and landing aircraft whose wing would be entirely washed by the slipstream of four large propellers: the "blown wing". A demonstrator, the **Breguet 940 Integral**, flew on 21 May 1958 and proved the concept. In February 1960 the French state ordered a prototype able to carry a useful load, funding only a quarter of the cost. The Breguet 941 flew on 1 June 1961.\n\n## Design\nFour **Turbomeca Turmo** engines drove 4 m propellers linked by transmission shafts: if one engine stopped, the whole wing stayed evenly blown, at 75 per cent power. The inner and outer engines turned in opposite directions to cancel torque, and large full-span slotted flaps deflected to nearly 95°. The more powerful production **941S** flew on 19 April 1967, with a modified rear door for air-dropping stores. It needed only a 185 m take-off run at 22 tonnes, carrying 57 passengers or 40 equipped troops.\n\n## Operational career\nMcDonnell bought a licence and promoted the aircraft in the United States as the **McDonnell 188**: the prototype was demonstrated there in late 1964 and early 1965 and evaluated by NASA and the US military, without orders. Back in France it made repeated short landings, as in the Bouconne forest near Toulouse in May 1965. In 1968 a 941S flew two months of services for Eastern Air Lines, then was tested by American Airlines and the FAA to assess the city-centre STOLport concept. The four 941S served with the French Air Force from 1967 to 1974, last with the "Ventoux" squadron at Reims.\n\n## Place in history\nDespite intense promotion on both sides of the Atlantic, the Breguet 941 was built in only five examples, and its civil derivatives, the Breguet 942 and the McDonnell 188E and 210, stayed on paper: airlines wanted jets at conventional airports. Its short-field performance remains remarkable all the same. Two 941S survive, one at Toulouse with Ailes Anciennes, the other in storage for the Musée de l''Air at Le Bourget.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1960-02-01',
    '1961-06-01',
    '1967-01-01',
    450,
    1000,
    (SELECT id FROM manufacturer WHERE code = 'BRG'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet 941'), (SELECT id FROM tech WHERE name = 'Aile soufflée')),
((SELECT id FROM airplanes WHERE name = 'Breguet 941'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet 941'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Breguet 941'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.75,
  wingspan          = 23.4,
  height            = 9.65,
  wing_area         = 83.8,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = 9500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Turbomeca Turmo IIID3 (1 501 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Breguet 940 Intégral** : démonstrateur de l''aile soufflée à quatre Turmo II, premier vol le 21 mai 1958\n- **Breguet 941** : prototype de transport à quatre Turmo IIID, premier vol le 1er juin 1961\n- **Breguet 941S** : version de série de l''armée de l''air, quatre Turmo IIID3 et porte arrière de largage, quatre exemplaires\n- **Breguet 942 / 945** : projets d''avion de ligne pressurisé et de version militaire réduite, non construits\n- **McDonnell 188 / 188E / McDonnell Douglas 210** : versions américaines sous licence, restées à l''état de projet',
  variants_en       = E'- **Breguet 940 Integral**: blown-wing demonstrator with four Turmo II engines, first flown on 21 May 1958\n- **Breguet 941**: transport prototype with four Turmo IIID engines, first flown on 1 June 1961\n- **Breguet 941S**: French Air Force production version, four Turmo IIID3 engines and an air-drop rear door, four built\n- **Breguet 942 / 945**: projects for a pressurised airliner and a smaller military version, not built\n- **McDonnell 188 / 188E / McDonnell Douglas 210**: licensed American versions that remained projects',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Breguet_941',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bréguet_941',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'André Cros',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Breguet 941';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Breguet 941';
