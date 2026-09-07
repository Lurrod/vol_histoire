-- McDonnell Douglas AV-8B Harrier II
--
-- Photo : U.S. Marine Corps AV-8B Harrier II aircraft with Marine Attack Squadron 223 fly over the coast of North Carolina, May 15, 2026.jpg
--   licence Public domain — Official U.S. Navy Page from United States of America MC3(SW) Craig Z. Rodarte/U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3AAn_AV-8B_Harrier_II_lands_on_the_flight_deck_of_USS_Boxer._%2828252389134%29.jpg

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
    'AV-8B Harrier II',
    'AV-8B Harrier II',
    'McDonnell Douglas AV-8B Harrier II',
    'McDonnell Douglas AV-8B Harrier II',
    'Harrier de deuxième génération, monture d’assaut du corps des Marines',
    'Second-generation Harrier, assault mount of the Marine Corps',
    '/assets/airplanes/av8b-harrier-2.jpg',
    E'## Genèse\nLe Harrier britannique de première génération emportait peu et n''allait pas loin. Les Marines américains, seuls convaincus par le décollage court, financent une refonte que le Royaume-Uni avait abandonnée faute de crédits. McDonnell Douglas mène le projet, British Aerospace y revient en associé.\n\n## Conception\nAile entièrement nouvelle en **matériaux composites**, plus grande et supercritique, avec des volets de bord de fuite à grand débattement. Des barrières sous le fuselage piègent le souffle des tuyères au décollage et créent un coussin d''air : la charge emportée double par rapport au Harrier d''origine. Le pilotage en vol stationnaire reste néanmoins l''un des plus exigeants qui soient.\n\n## Carrière opérationnelle\nGolfe 1991, Balkans, Irak, Afghanistan, Libye, Syrie : l''AV-8B est de toutes les opérations américaines depuis trente ans, opérant depuis les porte-hélicoptères d''assaut et depuis des plateformes sommaires à terre. L''Italie et l''Espagne l''utilisent depuis leurs porte-aéronefs.\n\n## Place dans l''histoire\nSon taux d''accidents, longtemps le plus élevé de l''aviation américaine, a alimenté un débat permanent sur le coût réel du décollage vertical. Son remplaçant, le **F-35B**, reprend le principe avec une soufflante de sustentation empruntée aux travaux soviétiques du Yak-141.',
    E'## Genesis\nThe first-generation British Harrier carried little and did not go far. The US Marines, alone in being convinced by short take-off, funded a redesign Britain had abandoned for lack of money. McDonnell Douglas led the project, with British Aerospace returning as a partner.\n\n## Design\nAn entirely new, larger supercritical wing in **composite materials**, with large-travel trailing edge flaps. Strakes under the fuselage trap the nozzle efflux on take-off and create an air cushion: payload doubled compared with the original Harrier. Hovering nonetheless remains one of the most demanding tasks in aviation.\n\n## Operational career\nGulf 1991, the Balkans, Iraq, Afghanistan, Libya, Syria: the AV-8B has been part of every American operation for thirty years, flying from amphibious assault ships and from rough forward sites ashore. Italy and Spain operate it from their own carriers.\n\n## Place in history\nIts accident rate, long the highest in American aviation, fed a permanent debate about the real cost of vertical flight. Its replacement, the **F-35B**, keeps the principle with a lift fan borrowed from Soviet work on the Yak-141.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1973-01-01',
    '1978-11-09',
    '1985-01-12',
    1083.0,
    2200.0,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM tech WHERE name = 'Pod désignateur laser'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM armement WHERE name = 'GAU-12 Equalizer')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'AV-8B Harrier II'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.12,
  wingspan          = 9.25,
  height            = 3.55,
  wing_area         = 22.6,
  empty_weight      = 6340,
  mtow              = 14100,
  service_ceiling   = 15240,
  climb_rate        = 75,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.0,
  combat_radius     = 556,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce F402-RR-408 (Pegasus 11-61)',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux à poussée vectorielle',
  engine_type_en    = 'Vectored-thrust turbofan',
  thrust_dry        = 105.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1981,
  production_end    = 2003,
  units_built       = 337,
  unit_cost_usd     = 30000000,
  unit_cost_year    = 1996,
  operators_count   = 3,
  variants          = E'- **AV-8B** : version de jour initiale\n- **AV-8B(NA)** : capacité de nuit, caméra infrarouge et jumelles de vision nocturne\n- **AV-8B Plus** : radar APG-65 et missiles AMRAAM\n- **EAV-8B / TAV-8B** : version espagnole et biplace d''entraînement',
  variants_en       = E'- **AV-8B** : initial day-attack version\n- **AV-8B(NA)** : night attack capability, FLIR and night vision goggles\n- **AV-8B Plus** : APG-65 radar and AMRAAM missiles\n- **EAV-8B / TAV-8B** : Spanish version and two-seat trainer',

  -- Strate 4 : qualitatif
  nickname          = 'Jump Jet',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_AV-8B_Harrier_II',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_AV-8B_Harrier_II',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Sgt. David Ornelas Baeza',
  image_licence     = 'Public domain'
WHERE name = 'AV-8B Harrier II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AV-8B Harrier II';
