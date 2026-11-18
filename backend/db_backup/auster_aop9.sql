-- Auster B.5 AOP Mk 9
--
-- Photo : Auster AOP.9 ‘XP241’ (G-CEHR) (26698154477).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Auster_AOP.9_%E2%80%98XP241%E2%80%99_(G-CEHR)_(26698154477).jpg

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
    'Auster AOP.9',
    'Auster AOP.9',
    'Auster B.5 AOP Mk 9',
    'Auster B.5 AOP Mk 9',
    'Le dernier « poste d''observation aérien » à voilure fixe de l''armée britannique, de la Malaisie à Aden',
    'The British Army''s last fixed-wing air observation post, from Malaya to Aden',
    '/assets/airplanes/auster-aop9.jpg',
    E'## Genèse\nPour observer le champ de bataille, l''armée britannique s''appuie sur des **Air Observation Posts** (AOP), de petits monoplans Auster pilotés par ses propres militaires. Fin 1953, un programme est lancé pour remplacer l''**Auster AOP.6** : le nouvel appareil doit tirer les leçons de la Corée et supporter les climats tropicaux, alors que le Commonwealth affronte une guérilla communiste en Malaisie. Le prototype WZ662 vole le 19 mars 1954 ; Auster lui donne la désignation interne B5.\n\n## Conception\nD''allure proche de son prédécesseur, l''AOP.9 est une machine entièrement nouvelle : monoplan à aile haute contreventée et train classique fixe, avec une aile plus grande, de grands volets et un moteur **Blackburn Cirrus Bombardier** de 180 ch. L''aile et l''empennage sont revêtus de métal, le fuselage entoilé. Pneus basse pression et train renforcé lui permettent d''opérer depuis des champs labourés et des terrains boueux. La cabine accueille le pilote et un passager côte à côte, l''observateur derrière eux, assis face à l''avant ou à l''arrière ; un plancher amovible en fait au besoin un biplace de transport léger.\n\n## Carrière opérationnelle\nLes livraisons à la Royal Air Force commencent en février 1955 ; jusqu''à la création de l''**Army Air Corps** en septembre 1957, ce sont des militaires de l''armée de Terre qui pilotent ces avions de la RAF. Dès septembre 1955, le No. 656 Squadron les engage dans l''**insurrection malaise**, à raison de 1 200 sorties par mois en moyenne : à la fin de l''opération Firedog, le 31 juillet 1960, ses AOP.6 et AOP.9 ont effectué 143 000 sorties. Au début des années 1960, le 653 Squadron de l''Army Air Corps les emploie à **Aden**, depuis Falaise, à Little Aden. L''Inde en reçoit 35, l''Afrique du Sud les utilise de 1957 à 1967 et Hong Kong récupère des exemplaires de l''Army Air Corps.\n\n## Place dans l''histoire\nRetiré en 1966, l''AOP.9 est le dernier avion d''observation à voilure fixe de l''Army Air Corps : l''hélicoptère prend la relève pour la surveillance du champ de bataille, et le **DHC-2 Beaver** reprend son rôle de transport léger. Construit à 182 exemplaires, il a aussi fait carrière dans le civil : dix-neuf AOP.9 rejoignent le registre britannique dans les années 1970. L''Army Historic Aircraft Flight en maintient un en état de vol à Middle Wallop.',
    E'## Genesis\nTo watch the battlefield, the British Army relied on **Air Observation Posts** (AOP), small Auster monoplanes flown by its own soldiers. In late 1953 a programme was launched to replace the **Auster AOP.6**: the new aircraft had to draw on the lessons of Korea and cope with tropical climates, as the Commonwealth was fighting a communist insurgency in Malaya. The prototype WZ662 flew on 19 March 1954; Auster gave it the company designation B5.\n\n## Design\nThough it looked much like its predecessor, the AOP.9 was an all-new machine: a strut-braced high-wing monoplane with fixed tailwheel landing gear, a larger wing, big flaps and a 180 hp **Blackburn Cirrus Bombardier** engine. The wing and tail were metal-skinned, the fuselage fabric-covered. Low-pressure tyres and strengthened landing gear let it operate from ploughed fields and muddy strips. The cabin seated the pilot and a passenger side by side, with the observer behind them facing forwards or rearwards; an interchangeable floor turned it into a two-seat light transport when needed.\n\n## Operational career\nDeliveries to the Royal Air Force began in February 1955; until the **Army Air Corps** was formed in September 1957, Army personnel flew these RAF aircraft. From September 1955 No. 656 Squadron flew them in the **Malayan Emergency**, averaging 1,200 sorties a month: by the end of Operation Firedog on 31 July 1960, its AOP.6s and AOP.9s had flown 143,000 sorties. In the early 1960s the Army Air Corps'' 653 Squadron used them in **Aden**, flying from Falaise at Little Aden. India received 35, South Africa flew them from 1957 to 1967, and Hong Kong took over former Army Air Corps examples.\n\n## Place in history\nRetired in 1966, the AOP.9 was the Army Air Corps'' last fixed-wing observation aircraft: the helicopter took over battlefield surveillance, and the **DHC-2 Beaver** inherited its light transport role. Built in 182 examples, it also found a civil career: nineteen AOP.9s joined the British register in the 1970s. The Army Historic Aircraft Flight keeps one airworthy at Middle Wallop.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1953-01-01',
    '1954-03-19',
    '1955-02-01',
    204,
    389,
    (SELECT id FROM manufacturer WHERE code = 'AUST'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Auster AOP.9'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Auster AOP.9'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Auster AOP.9'), (SELECT id FROM wars WHERE name = 'Insurrection malaise')),
((SELECT id FROM airplanes WHERE name = 'Auster AOP.9'), (SELECT id FROM wars WHERE name = 'Urgence d''Aden'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.23,
  wingspan          = 11.1,
  height            = 2.72,
  wing_area         = 18.36,
  empty_weight      = 662,
  mtow              = 953,
  service_ceiling   = 5600,
  climb_rate        = 4.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Blackburn Cirrus Bombardier 203 (180 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 182,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **AOP.9 (B5)** : seule version de série, 182 exemplaires\n- **AOP.11 (Beagle E.3)** : AOP.9 converti avec un moteur Continental IO-470-D de 260 ch, un seul exemplaire, premier vol le 18 août 1961\n- **Auster 9M** : appareil des surplus remotorisé avec un Lycoming O-360 pour le marché civil, premier vol le 4 janvier 1968',
  variants_en       = E'- **AOP.9 (B5)**: only production version, 182 built\n- **AOP.11 (Beagle E.3)**: AOP.9 converted with a 260 hp Continental IO-470-D, one aircraft, first flight on 18 August 1961\n- **Auster 9M**: surplus aircraft re-engined with a Lycoming O-360 for the civil market, first flight on 4 January 1968',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Auster_AOP_Mk_9',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Auster_AOP.9',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Auster AOP.9';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Auster AOP.9';
