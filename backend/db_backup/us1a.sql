-- ShinMaywa US-1A
--
-- Photo : Shin Meiwa US-1A ‘9078 78’ (47988694916).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3AShin_Meiwa_US-1A_%E2%80%989078_78%E2%80%99_%2847988694916%29.jpg

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
    'ShinMaywa US-1A',
    'ShinMaywa US-1A',
    'ShinMaywa US-1A',
    'ShinMaywa US-1A',
    'Hydravion capable d’amerrir dans trois mètres de creux',
    'Flying boat able to alight in a three-metre swell',
    '/assets/airplanes/us1a.jpg',
    E'## Genèse\nLe Japon est un archipel de six mille huit cents îles entouré d''un océan hostile, et ses pêcheurs travaillent parfois à mille kilomètres des côtes. Un hélicoptère n''a pas l''allonge, un navire n''a pas la vitesse. La solution est l''hydravion — mais aucun ne sait se poser dans une mer formée. ShinMaywa se donne pour but exactement cela.\n\n## Conception\nTout tient dans la vitesse d''amerrissage : plus elle est basse, plus la mer peut être mauvaise. L''appareil emploie le **soufflage de couche limite** — de l''air prélevé sur les moteurs est soufflé sur les volets pour retarder le décrochage — et descend ainsi sous les quatre-vingt-dix kilomètres-heure. La coque profonde et les redans absorbent le choc. Résultat : amerrissage par **trois mètres de creux**.\n\n## Carrière opérationnelle\nVingt exemplaires, un seul opérateur : la force maritime d''autodéfense japonaise. En trente ans, les US-1A sauvent plus de **cinq cents personnes** en mer, dont des naufragés récupérés à plus de mille kilomètres du Japon — hors de portée de tout autre moyen.\n\n## Place dans l''histoire\nVingt exemplaires. Le US-1A et son successeur le **US-2** sont les derniers grands hydravions militaires en service dans le monde, et les seuls dont la mission ne soit pas la guerre. L''Inde a longtemps négocié l''achat de US-2 : ce serait la première exportation d''armement japonaise depuis 1945.',
    E'## Genesis\nJapan is an archipelago of six thousand eight hundred islands surrounded by a hostile ocean, and its fishermen sometimes work a thousand kilometres from shore. A helicopter lacks the reach, a ship the speed. The answer is the flying boat — but none could alight in a rough sea. ShinMaywa set itself exactly that goal.\n\n## Design\nEverything turns on alighting speed: the lower it is, the worse the sea may be. The aircraft uses **boundary-layer blowing** — air bled from the engines is blown over the flaps to delay the stall — and so comes down below ninety kilometres an hour. The deep hull and its steps absorb the shock. The result: alighting in a **three-metre swell**.\n\n## Operational career\nTwenty built, a single operator: the Japan Maritime Self-Defense Force. In thirty years the US-1As rescued more than **five hundred people** at sea, including survivors picked up more than a thousand kilometres from Japan — beyond the reach of any other means.\n\n## Place in history\nTwenty built. The US-1A and its successor the **US-2** are the last large military flying boats in service anywhere, and the only ones whose mission is not war. India has long negotiated to buy US-2s: it would be the first Japanese arms export since 1945.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1966-01-01',
    '1974-10-16',
    '1976-03-01',
    511.0,
    3800.0,
    (SELECT id FROM manufacturer WHERE code = 'SHM'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'ShinMaywa US-1A'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'ShinMaywa US-1A'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'ShinMaywa US-1A'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'ShinMaywa US-1A'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 33.5,
  wingspan          = 33.15,
  height            = 9.95,
  wing_area         = 135.8,
  empty_weight      = 25500,
  mtow              = 45000,
  service_ceiling   = 8650,
  climb_rate        = 8.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1800,
  crew              = 9,

  -- Strate 2 : motorisation
  engine_name       = 'Ishikawajima-Harima T64-IHI-10J',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1974,
  production_end    = 1988,
  units_built       = 20,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **PS-1** : version anti-sous-marine d''origine, sans train d''atterrissage\n- **US-1** puis **US-1A** : versions **amphibies** de recherche et sauvetage\n- **Soufflage de couche limite** : décolle et amerrit à moins de 90 km/h\n- Capable d''amerrir dans une mer de **trois mètres de creux**, record du genre\n- Remplacé par le **US-2**, à cabine pressurisée et moteurs plus puissants',
  variants_en       = E'- **PS-1** : original anti-submarine version, with no undercarriage\n- **US-1** then **US-1A** : **amphibious** search and rescue versions\n- **Boundary-layer blowing**: takes off and alights below 90 km/h\n- Able to alight in a **three-metre swell**, a record for the type\n- Replaced by the **US-2**, with a pressurised cabin and more powerful engines',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/ShinMaywa_US-1A',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/ShinMaywa_US-1A',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'ShinMaywa US-1A';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'ShinMaywa US-1A';
