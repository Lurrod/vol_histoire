-- Lockheed C-121 / R7V-1 Constellation
--
-- Photo : Blue Angels Lockheed C-121 in flight 1968.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Blue_Angels_Lockheed_C-121_in_flight_1968.jpg

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
    'Lockheed C-121 Constellation',
    'Lockheed C-121 Constellation',
    'Lockheed C-121 / R7V-1 Constellation',
    'Lockheed C-121 / R7V-1 Constellation',
    'Le Constellation en uniforme, transport et avion de personnalités de l''US Air Force et de l''US Navy',
    'The Constellation in uniform, transport and VIP aircraft of the US Air Force and US Navy',
    '/assets/airplanes/lockheed-c121-constellation.jpg',
    E'## Genèse\nLa première carrière militaire du **Constellation** avait tourné court : handicapés par leurs moteurs **Wright R-3350**, les rares **C-69** du temps de guerre avaient été rendus aux compagnies aériennes. En 1947, Lockheed lance une version plus économique, le **L-749**, mais perd 1 200 salariés dans l''année et, en 1948, sa chaîne est presque à l''arrêt. C''est alors que l''**US Air Force** commande dix L-749A, désignés **C-121A**, tandis que l''**US Navy** en commande deux en version de guet aérien. Les premiers L-749A sortis de chaîne sont donc militaires.\n\n## Conception\nLe C-121A ne diffère du L-749 que par un plancher renforcé pour le fret et une grande porte de chargement arrière ; il reçoit pourtant le plus souvent 44 sièges, pour cinq hommes d''équipage et quatre de relève. En août 1950, la Navy commande onze **Super Constellation** allongés, convertibles en deux heures du transport de 97 à 107 passagers au fret ou à l''évacuation de 73 blessés : ce sont les R7O, devenus **R7V-1**, qui volent en 1952. L''Air Force suit en 1951 avec 33 **C-121C**, à hublots carrés, groupe auxiliaire de puissance et moteurs turbo-compound, qui emportent 75 passagers, 72 soldats ou 47 civières et volent en 1955.\n\n## Carrière opérationnelle\nAffectés à la division Atlantique du **Military Air Transport Service**, les C-121A participent au **pont aérien de Berlin** ; **Dwight Eisenhower** et **Douglas MacArthur** en font leurs avions personnels, et six deviennent en 1950 des VC-121A de transport officiel. Les R7V-1 servent au-dessus de l''Atlantique et du Pacifique, et deux ravitaillent l''Antarctique. En 1962, 32 des 50 R7V-1 passent à l''Air Force sous le nom de **C-121G**, les 18 autres deviennent des **C-121J** ; quatre sont transformés en stations de télévision volantes pour le **Vietnam**, et l''un sert aux **Blue Angels** jusqu''en 1971. Les C-121C finissent dans la Garde nationale aérienne et sont retirés en 1973.\n\n## Place dans l''histoire\nConstruit à 332 exemplaires pour l''Air Force et la Navy, le C-121 est aussi le tronc d''où sont nées les versions de guet aérien **EC-121**. Le VC-121A **Columbine II** est le premier avion à avoir employé l''indicatif **Air Force One** avec le président à bord. Après leur réforme, des C-121 et R7V-1 volent encore comme cargos civils, jusqu''à ce que l''administration fédérale de l''aviation interdise en 1993 les vols des dernières compagnies dominicaines vers Miami. Le VC-121A **Bataan** de MacArthur et un C-121C restauré en Australie volent toujours.',
    E'## Genesis\nThe **Constellation**''s first military career had been cut short: hampered by their **Wright R-3350** engines, the few wartime **C-69s** had been handed back to the airlines. In 1947 Lockheed launched a more economical version, the **L-749**, but lost 1,200 workers that year, and by 1948 its production line had almost stopped. It was then that the **US Air Force** ordered ten L-749As, designated **C-121A**, while the **US Navy** ordered two as airborne early warning aircraft. The first L-749As off the line were therefore military.\n\n## Design\nThe C-121A differed from the L-749 only in a floor reinforced for cargo and a large aft loading door; it was nonetheless usually fitted with 44 seats, for a crew of five plus four relief crew. In August 1950 the Navy ordered eleven stretched **Super Constellations**, convertible in two hours from a 97 to 107-passenger transport to a freighter, or to an ambulance for 73 stretchers: these were the R7Os, later **R7V-1s**, which flew in 1952. The Air Force followed in 1951 with 33 **C-121Cs**, with square windows, an auxiliary power unit and turbo-compound engines, carrying 75 passengers, 72 troops or 47 stretchers; they flew in 1955.\n\n## Operational career\nAssigned to the Atlantic division of the **Military Air Transport Service**, the C-121As took part in the **Berlin Airlift**; **Dwight Eisenhower** and **Douglas MacArthur** used them as their personal aircraft, and six became VC-121A VIP transports in 1950. The R7V-1s served over the Atlantic and the Pacific, and two flew supplies to Antarctica. In 1962, 32 of the 50 R7V-1s went to the Air Force as **C-121Gs** and the other 18 became **C-121Js**; four were turned into flying television stations for **Vietnam**, and one served the **Blue Angels** until 1971. The C-121Cs ended their days with the Air National Guard and were retired in 1973.\n\n## Place in history\nBuilt in 332 examples for the Air Force and Navy, the C-121 was also the stock from which the **EC-121** early warning versions grew. VC-121A **Columbine II** was the first aircraft to use the call sign **Air Force One** with the President aboard. After retirement, C-121s and R7V-1s flew on as civil freighters until the Federal Aviation Administration banned the last Dominican operators from flying to Miami in 1993. MacArthur''s VC-121A **Bataan** and a C-121C restored in Australia still fly.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1947-03-14',
    '1948-11-12',
    538,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'LOC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed C-121 Constellation'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed C-121 Constellation'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed C-121 Constellation'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Lockheed C-121 Constellation'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 29.01,
  wingspan          = 37.49,
  height            = 6.83,
  wing_area         = 153.3,
  empty_weight      = 27776,
  mtow              = 48534,
  service_ceiling   = 7450,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-3350-75 Duplex-Cyclone (2 500 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 1958,
  units_built       = 332,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **C-121A** : version initiale dérivée du L-749, plancher renforcé et porte cargo ; VC-121A de transport officiel\n- **C-121C** : 33 Super Constellation de l''Air Force, hublots carrés, moteurs turbo-compound\n- **R7V-1** : Super Constellation convertible de la Navy, 50 construits, devenus C-121G (Air Force) et C-121J (Navy) en 1962\n- **VC-121E** : R7V-1 transformé avant livraison en avion présidentiel de l''Air Force\n- **NC-121J** : quatre C-121J transformés en stations de télévision volantes pour le Vietnam\n- **R7V-2 / YC-121F** : appareils d''essai à turbopropulseurs Pratt & Whitney T34, passés de la Navy à l''Air Force',
  variants_en       = E'- **C-121A**: initial version derived from the L-749, reinforced floor and cargo door; VC-121A VIP transports\n- **C-121C**: 33 Air Force Super Constellations, square windows, turbo-compound engines\n- **R7V-1**: Navy convertible Super Constellation, 50 built, becoming C-121G (Air Force) and C-121J (Navy) in 1962\n- **VC-121E**: R7V-1 converted before delivery into an Air Force presidential aircraft\n- **NC-121J**: four C-121Js turned into flying television stations for Vietnam\n- **R7V-2 / YC-121F**: test aircraft with Pratt & Whitney T34 turboprops, transferred from the Navy to the Air Force',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_C-121_Constellation',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_C-121_Constellation',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed C-121 Constellation';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed C-121 Constellation';
