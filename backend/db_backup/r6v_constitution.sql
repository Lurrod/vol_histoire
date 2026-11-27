-- Lockheed R6V Constitution
--
-- Photo : Lockheed XR6O-1 landing Moffett Field.jpg
--   licence CC BY 2.5 — W. T. Larkins at English Wikipedia
--   https://commons.wikimedia.org/wiki/File:Lockheed_XR6O-1_landing_Moffett_Field.jpg

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
    'Lockheed R6V Constitution',
    'Lockheed R6V Constitution',
    'Lockheed R6V Constitution',
    'Lockheed R6V Constitution',
    'Le transport à deux ponts de l''US Navy, plus grand avion terrestre qu''elle ait jamais exploité',
    'The US Navy''s double-deck transport, the largest landplane it ever operated',
    '/assets/airplanes/lockheed-r6v-constitution.jpg',
    E'## Genèse\nEn 1942, l''US Navy, la compagnie **Pan American** et **Lockheed** étudient ensemble un grand transport terrestre destiné à surpasser la flotte d''hydravions de la Marine. Le cahier des charges du **Model 89** demande d''emporter 7,9 tonnes de fret sur 8 000 km, à 7 600 m d''altitude et à plus de 400 km/h, dans une cabine entièrement pressurisée. L''équipe de **Willis Hawkins**, de W.A. Pulver et du commandant E. L. Simpson dessine l''appareil, que le président de Lockheed, **Robert E. Gross**, baptise Constitution. La commande initiale de 50 avions pour 111,25 millions de dollars est ramenée, à la victoire sur le Japon, à deux exemplaires pour 27 millions.\n\n## Conception\nLe fuselage à « double bulle », dont la section dessine un huit, offre deux ponts tout en gardant les avantages du cylindre pour la pressurisation. L''avion est si grand que des tunnels traversant l''aile épaisse donnent accès aux quatre moteurs en vol, et que Lockheed doit bâtir à Burbank un hangar spécial de 124 m sur 92 m. Le pont supérieur du second exemplaire accueille 92 passagers ; le pont inférieur offre 208,8 m³ de soute chargée par un palan électrique, ou 76 places de plus. Jugés insuffisants, les moteurs en étoile de 3 000 ch sont remplacés par des **Pratt & Whitney R-4360** de 3 500 ch à injection d''eau.\n\n## Carrière opérationnelle\nLe premier exemplaire vole le 9 novembre 1946, aux mains de Joe Towle et **Tony LeVier**. Le 25 juillet 1948, il relie sans escale Moffett Field, en Californie, à Patuxent River, dans le Maryland, soit 3 960 km ; il est livré le 2 février 1949 à l''escadron de transport VR-44 d''Alameda. Les deux Constitution desservent la ligne de Hawaï. Le second embarque le 3 février 1949 soixante-quatorze journalistes à travers le pays, record de l''époque pour un vol transcontinental, avant six mois de service régulier entre Washington et San Francisco ; une tournée de recrutement dans dix-neuf villes attire 546 000 visiteurs.\n\n## Place dans l''histoire\nSous-motorisé, affligé de moteurs qui chauffent, le Constitution n''atteint jamais ses objectifs. Dès 1949, la Navy annonce qu''elle n''a plus les moyens de l''exploiter ; aucune compagnie ne veut les louer, et les deux avions sont retirés en 1953, puis vendus avec treize moteurs de rechange pour 97 785 dollars. Le premier finit en panneau publicitaire à Las Vegas avant d''être démoli. Il reste le plus grand avion à voilure fixe jamais exploité par l''US Navy, seul l''hydravion **Martin JRM Mars** le dépassant légèrement en envergure.',
    E'## Genesis\nIn 1942 the US Navy, **Pan American** and **Lockheed** jointly studied a large landplane transport meant to improve on the Navy''s fleet of flying boats. The **Model 89** requirement called for 7.9 tonnes of cargo to be carried 8,000 km at a cruising altitude of 7,600 m and more than 400 km/h, in a fully pressurised cabin. The team of **Willis Hawkins**, W.A. Pulver and Commander E. L. Simpson designed the aircraft, which Lockheed president **Robert E. Gross** named Constitution. The original order for 50 aircraft worth $111.25 million was cut back on VJ Day to two examples for $27 million.\n\n## Design\nThe ''double bubble'' fuselage, with a figure-eight cross-section, offered two decks while keeping the structural advantages of a cylinder for pressurisation. The aircraft was so large that tunnels through the thick wing gave access to all four engines in flight, and Lockheed had to build a special 124 m by 92 m hangar at Burbank. The upper deck of the second example seated 92 passengers; the lower deck offered 208.8 m³ of hold space loaded by an electric hoist, or room for 76 more seats. Found to be underpowered, the original 3,000 hp radials were replaced by 3,500 hp water-injected **Pratt & Whitney R-4360s**.\n\n## Operational career\nThe first example flew on 9 November 1946, with Joe Towle and **Tony LeVier** at the controls. On 25 July 1948 it flew non-stop from Moffett Field, California, to Patuxent River, Maryland, a distance of 3,960 km; it was delivered on 2 February 1949 to transport squadron VR-44 at Alameda. Both Constitutions flew the route to Hawaii. On 3 February 1949 the second carried 74 members of the press across the country, then a record for a transcontinental flight, before six months of regular service between Washington and San Francisco; a recruiting tour of nineteen cities drew 546,000 visitors.\n\n## Place in history\nUnderpowered and plagued by engine cooling problems, the Constitution never met its design objectives. As early as 1949 the Navy announced that it could no longer afford to operate the pair; no airline would lease them, and both were retired in 1953, then sold with thirteen spare engines for $97,785. The first ended up as a billboard in Las Vegas before being scrapped. It remains the largest fixed-wing aircraft type ever operated by the US Navy, only the **Martin JRM Mars** flying boat having a slightly longer wingspan.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1942-01-01',
    '1946-11-09',
    '1949-02-02',
    490,
    10100,
    (SELECT id FROM manufacturer WHERE code = 'LOC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed R6V Constitution'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed R6V Constitution'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 47.57,
  wingspan          = 57.64,
  height            = 15.35,
  wing_area         = 335,
  empty_weight      = 51970,
  mtow              = 83461,
  service_ceiling   = 8400,
  climb_rate        = 5.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 12,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-4360-22W (3 500 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Constitution n° 1 (BuNo 85163)** : premier vol le 9 novembre 1946, pont supérieur sommairement aménagé, livré au VR-44 le 2 février 1949\n- **Constitution n° 2 (BuNo 85164)** : premier vol le 9 juin 1948, pont supérieur de luxe pour 92 passagers et 12 membres d''équipage\n- **R6O / R6V** : désignations successives des deux appareils dans l''US Navy (escadrons VR-5 et VR-44)\n- **Model 189** : version de ligne proposée aux compagnies, sans preneur\n- **Models 389 et 489** : projets d''avions de ligne jusqu''à 169 passagers, restés sur le papier',
  variants_en       = E'- **Constitution No. 1 (BuNo 85163)**: first flight on 9 November 1946, spartan upper deck, delivered to VR-44 on 2 February 1949\n- **Constitution No. 2 (BuNo 85164)**: first flight on 9 June 1948, luxury upper deck for 92 passengers and 12 crew\n- **R6O / R6V**: successive US Navy designations of the two aircraft (squadrons VR-5 and VR-44)\n- **Model 189**: airliner version offered to the airlines, with no takers\n- **Models 389 and 489**: airliner projects for up to 169 passengers, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_R6V_Constitution',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_R6V_Constitution',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'W. T. Larkins',
  image_licence     = 'CC BY 2.5'
WHERE name = 'Lockheed R6V Constitution';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed R6V Constitution';
