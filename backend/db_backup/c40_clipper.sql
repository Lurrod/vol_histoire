-- Boeing C-40A Clipper / C-40B / C-40C
--
-- Photo : US Navy 111021-N-WD757-068 A C-40 Clipper assigned to Fleet Logistics Support Squadron (VR) 57 lands at Naval Air Station North Island.jpg
--   licence Public domain — U.S. Navy photo by Mass Communication Seaman Carlos M. Vazquez II
--   https://commons.wikimedia.org/wiki/File:US_Navy_111021-N-WD757-068_A_C-40_Clipper_assigned_to_Fleet_Logistics_Support_Squadron_(VR)_57_lands_at_Naval_Air_Station_North_Island.jpg

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
    'Boeing C-40 Clipper',
    'Boeing C-40 Clipper',
    'Boeing C-40A Clipper / C-40B / C-40C',
    'Boeing C-40A Clipper / C-40B / C-40C',
    'Boeing 737 militaire, cargo mixte de la Navy et bureau volant des chefs militaires américains',
    'Military Boeing 737, a Navy combi freighter and flying office for America''s military commanders',
    '/assets/airplanes/boeing-c40-clipper.jpg',
    E'## Genèse\nÀ la fin des années 1990, la réserve de l''US Navy, qui assure tout le transport aérien moyen et lourd de la marine, doit remplacer ses **C-9B Skytrain II** vieillissants, bruyants et gourmands. Elle choisit un dérivé du **Boeing 737 Next Generation**, acheté selon les pratiques commerciales : six 737-700C, puis d''autres. Le premier vole en avril 2000, et les deux premiers **C-40A Clipper** rejoignent le 21 avril 2001 l''escadron VR-59 à Fort Worth, au Texas ; c''est le premier avion logistique neuf de la réserve navale depuis dix-sept ans. L''US Air Force suit en août 2000 avec le C-40B, pour remplacer les **C-137** de ses commandants de théâtre.\n\n## Conception\nLe C-40 associe le fuselage du 737-700 à la voilure et au train renforcés du 737-800, plus lourd, et ajoute des réservoirs auxiliaires qui portent l''autonomie jusqu''à 9 300 km. Deux réacteurs **CFM56-7B** de 121 kN le propulsent jusqu''à 989 km/h. Le C-40A de la Navy est un « combi » : 121 passagers, huit palettes de fret, ou trois palettes et 70 passagers sur le pont principal. Le C-40B, tiré du Boeing Business Jet, est un « bureau volant » pour 26 à 32 passagers, avec transmissions sécurisées et accès internet ; le C-40C, sans ces transmissions, accueille de 42 à 111 passagers.\n\n## Carrière opérationnelle\nLes C-40A sont livrés aux escadrons VR-59, VR-58 à Jacksonville, VR-57 à North Island, puis à Hawaï, en Virginie et dans l''État de Washington. L''Air Force reçoit son premier C-40B au 89th Airlift Wing d''Andrews en décembre 2002, puis à Hickam pour le commandement du Pacifique et à Ramstein pour l''Europe. Les C-40C remplacent trois **C-22**, des Boeing 727 de la Garde nationale : deux arrivent en octobre 2002 et trois au 932nd Airlift Wing de Scott en 2007. Le Marine Corps, privé de ses Skytrain depuis 2017, reçoit ses deux C-40A à partir de 2020.\n\n## Place dans l''histoire\nLe C-40C est le premier avion militaire acquis sur étagère par le département de la Défense. Plus économe, plus silencieux et doté de plus d''autonomie et de charge utile que le C-9B, le Clipper montre qu''un avion de ligne moderne, acheté tel quel, peut remplir les missions logistiques d''une armée. Vingt-huit exemplaires sont construits jusqu''en 2019 : dix-sept C-40A, quatre C-40B et sept C-40C.',
    E'## Genesis\nIn the late 1990s the US Navy Reserve, which provides all of the Navy''s medium and heavy airlift, had to replace its ageing, noisy and thirsty **C-9B Skytrain IIs**. It chose a derivative of the **Boeing 737 Next Generation**, bought through standard commercial practice: six 737-700Cs, then more. The first flew in April 2000, and the first two **C-40A Clippers** joined squadron VR-59 at Fort Worth, Texas, on 21 April 2001, the Navy Reserve''s first new logistics aircraft in seventeen years. The US Air Force followed in August 2000 with the C-40B, to replace the **C-137s** of its combatant commanders.\n\n## Design\nThe C-40 combines the 737-700 fuselage with the strengthened wing and landing gear of the heavier 737-800, and adds auxiliary tanks that extend its range to as much as 9,300 km. Two 121 kN **CFM56-7B** engines give it a top speed of 989 km/h. The Navy''s C-40A is a "combi": 121 passengers, eight cargo pallets, or three pallets and 70 passengers on the main deck. The C-40B, derived from the Boeing Business Jet, is an "office in the sky" for 26 to 32 passengers, with secure communications and internet access; the C-40C, without those communications, seats 42 to 111 passengers.\n\n## Operational career\nC-40As went to squadrons VR-59, VR-58 at Jacksonville and VR-57 at North Island, then to Hawaii, Virginia and Washington State. The Air Force received its first C-40B with the 89th Airlift Wing at Andrews in December 2002, then at Hickam for Pacific Command and at Ramstein for Europe. The C-40Cs replaced three **C-22s**, Air National Guard Boeing 727s: two arrived in October 2002 and three with the 932nd Airlift Wing at Scott in 2007. The Marine Corps, without its Skytrains since 2017, received its two C-40As from 2020.\n\n## Place in history\nThe C-40C was the first military aircraft acquired off the shelf for the Department of Defense. More fuel-efficient and quieter than the C-9B, with more range and payload, the Clipper showed that a modern airliner bought as it stands could fulfil an armed service''s logistics missions. Twenty-eight were built up to 2019: seventeen C-40As, four C-40Bs and seven C-40Cs.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '2000-04-01',
    '2001-04-21',
    989,
    9300,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing C-40 Clipper'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Boeing C-40 Clipper'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing C-40 Clipper'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 33.63,
  wingspan          = 34.32,
  height            = 12.55,
  wing_area         = NULL,
  empty_weight      = 57153,
  mtow              = 77564,
  service_ceiling   = 12497,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'CFM International CFM56-7B',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 121,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2001,
  production_end    = 2019,
  units_built       = 28,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **C-40A Clipper** : version « combi » de l''US Navy et du Marine Corps, 121 passagers ou huit palettes, dix-sept construits\n- **C-40B** : Boeing Business Jet de l''US Air Force, bureau volant à transmissions sécurisées pour les commandants de théâtre, quatre construits\n- **C-40C** : transport de personnalités de l''Air Force, de la Garde nationale et de la réserve, de 42 à 111 passagers, sept construits',
  variants_en       = E'- **C-40A Clipper**: US Navy and Marine Corps combi version, 121 passengers or eight pallets, seventeen built\n- **C-40B**: US Air Force Boeing Business Jet, a flying office with secure communications for combatant commanders, four built\n- **C-40C**: VIP transport for the Air Force, Air National Guard and Reserve, 42 to 111 passengers, seven built',

  -- Strate 4 : qualitatif
  nickname          = 'Clipper',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_C-40_Clipper',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_C-40',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mass Communication Seaman Carlos M. Vazquez II, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Boeing C-40 Clipper';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing C-40 Clipper';
