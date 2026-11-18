-- McDonnell Douglas C-9 Nightingale / Skytrain II
--
-- Photo : US Navy 030819-N-6501M-005 With the San Diego skyline in the background, a C-9B Skytrain II from the Conquistadors of Fleet Logistics Squadron Fifty Seven (VR-57) flies over Coronado, California.jpg
--   licence Public domain — U.S. Navy photo by Photographer's Mate 1st Class Edward G. Martens.
--   https://commons.wikimedia.org/wiki/File:US_Navy_030819-N-6501M-005_With_the_San_Diego_skyline_in_the_background,_a_C-9B_Skytrain_II_from_the_Conquistadors_of_Fleet_Logistics_Squadron_Fifty_Seven_(VR-57)_flies_over_Coronado,_California.jpg

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
    'McDonnell Douglas C-9',
    'McDonnell Douglas C-9',
    'McDonnell Douglas C-9 Nightingale / Skytrain II',
    'McDonnell Douglas C-9 Nightingale / Skytrain II',
    'DC-9 militaire, premier jet américain d''évacuation sanitaire puis navette logistique de la Navy pendant 46 ans',
    'Military DC-9, the first American medical evacuation jet and then a Navy logistics shuttle for 46 years',
    '/assets/airplanes/c9-nightingale.jpg',
    E'## Genèse\nEn 1966, l''US Air Force exprime le besoin d''un avion de transport sanitaire et commande l''année suivante une version militaire du biréacteur de ligne **DC-9**. Baptisé **Nightingale** en hommage à **Florence Nightingale**, fondatrice des soins infirmiers modernes, le C-9A est tiré du DC-9-32CF convertible. Les 21 exemplaires sont livrés en 1968 et 1969 ; le premier accepté par le Military Airlift Command est aussi le premier avion à réaction américain conçu spécialement pour l''évacuation sanitaire.\n\n## Conception\nLe C-9 garde la formule du DC-9 : deux turbosoufflantes Pratt & Whitney **JT8D-9** de 64 kN fixées à l''arrière du fuselage, sous un empennage en T, et une croisière à Mach 0,84. Le C-9A peut emporter des civières, la cabine du C-9B de la Navy est convertible entre passagers, jusqu''à 76, et fret. Beaucoup de C-9B voient leur masse au décollage portée à 50 t et reçoivent des réservoirs supplémentaires en soute, qui étendent leur rayon d''action à près de 4 800 km pour les missions outre-mer, ainsi que des brouilleurs infrarouges en queue contre les missiles à guidage thermique.\n\n## Carrière opérationnelle\nLa Navy veut aussi ses DC-9, mais sa première commande est annulée : le transport du personnel relève alors du Military Airlift Command. Elle démontre au Congrès que ses marins passent en dernier sur les vols de l''Air Force, et obtient le droit d''exploiter ses propres jets. Huit **C-9B Skytrain II** partagent la logistique entre la côte Ouest, à Alameda, et la côte Est, à Norfolk, six autres arrivent en 1976, dont deux pour le Marine Corps, puis vingt DC-9 neufs ou d''occasion sont convertis ; des détachements opèrent en Europe et en Asie. L''Air Force ajoute trois VC-9C de transport de personnalités, qui portent notamment **Ronald Reagan** et **Bill Clinton**.\n\n## Place dans l''histoire\nSon nom de Skytrain II rappelle le **C-47 Skytrain**, tiré du DC-3 : une même tradition de Douglas, faire d''un avion de ligne éprouvé un transport militaire. Le C-9A vole jusqu''en septembre 2005, les VC-9C jusqu''en 2011, et la Navy retire son dernier C-9B le 28 juin 2014 ; les deux derniers du Marine Corps partent en avril 2017. La NASA en a aussi fait un avion de vol en apesanteur, successeur du KC-135 surnommé « Vomit Comet ».',
    E'## Genesis\nIn 1966 the US Air Force identified a need for an aeromedical transport and the following year ordered a military version of the **DC-9** twinjet airliner. Named **Nightingale** after **Florence Nightingale**, founder of modern nursing, the C-9A was based on the convertible DC-9-32CF. All 21 were delivered in 1968 and 1969; the first accepted by Military Airlift Command was also the first American jet aircraft specifically designed for medical evacuation.\n\n## Design\nThe C-9 keeps the DC-9 formula: two 64 kN Pratt & Whitney **JT8D-9** turbofans mounted on the rear fuselage under a T-tail, and a Mach 0.84 cruise. The C-9A can carry litters, while the cabin of the Navy''s C-9B converts between passengers, up to 76, and cargo. Many C-9Bs had their take-off weight raised to 50 t and received auxiliary tanks in the lower hold, extending their range to nearly 4,800 km for overseas missions, as well as tail-mounted infrared jammers against heat-seeking missiles.\n\n## Operational career\nThe Navy wanted DC-9s too, but its first order was cancelled: personnel transport was then Military Airlift Command''s job. It showed Congress that its sailors were given last seats on Air Force flights, and won the right to fly its own jets. Eight **C-9B Skytrain IIs** shared logistics between the West Coast, at Alameda, and the East Coast, at Norfolk, six more arrived in 1976, two of them for the Marine Corps, then twenty new and used DC-9s were converted; detachments operated in Europe and Asia. The Air Force added three VC-9C executive transports, which carried **Ronald Reagan** and **Bill Clinton** among others.\n\n## Place in history\nIts Skytrain II name recalls the DC-3-derived **C-47 Skytrain**: the same Douglas tradition of turning a proven airliner into a military transport. The C-9A flew until September 2005, the VC-9Cs until 2011, and the Navy retired its last C-9B on 28 June 2014; the Marine Corps'' last two left in April 2017. NASA also used one for reduced-gravity flights, succeeding the KC-135 known as the "Vomit Comet".',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1966-01-01',
    NULL,
    '1968-01-01',
    930,
    4670,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell Douglas C-9'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell Douglas C-9'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 36.35,
  wingspan          = 28.47,
  height            = 8.38,
  wing_area         = 93.0,
  empty_weight      = 27079,
  mtow              = 49895,
  service_ceiling   = 11280,
  climb_rate        = 15.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 8,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney JT8D-9',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 64.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1968,
  production_end    = NULL,
  units_built       = 48,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **C-9A Nightingale** : évacuation sanitaire de l''USAF tirée du DC-9-32CF, 21 livrés en 1968-1969 ; deux convertis en transport de personnalités en Europe\n- **C-9B Skytrain II** : transport convertible passagers-fret de la Navy et du Marine Corps, 24 livrés de 1973 à 1976, plus cinq DC-9 de ligne convertis\n- **VC-9C** : trois transports de personnalités de l''USAF, livrés en 1976 et retirés en 2011\n- **C-9K** : deux appareils pour la force aérienne du Koweït',
  variants_en       = E'- **C-9A Nightingale**: USAF aeromedical evacuation aircraft based on the DC-9-32CF, 21 delivered in 1968-1969; two converted to VIP transports in Europe\n- **C-9B Skytrain II**: Navy and Marine Corps convertible passenger-cargo transport, 24 delivered from 1973 to 1976, plus five converted airline DC-9s\n- **VC-9C**: three USAF executive transports, delivered in 1976 and retired in 2011\n- **C-9K**: two aircraft for the Kuwait Air Force',

  -- Strate 4 : qualitatif
  nickname          = 'Nightingale',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_C-9',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_C-9',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Photographer''s Mate 1st Class Edward G. Martens, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'McDonnell Douglas C-9';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'McDonnell Douglas C-9';
