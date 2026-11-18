-- Boeing C-32A / C-32B Gatekeeper
--
-- Photo : Air Force One VC-32A HGR MD1.jpg
--   licence CC BY-SA 4.0 — Acroterion
--   https://commons.wikimedia.org/wiki/File:Air_Force_One_VC-32A_HGR_MD1.jpg

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
    'Boeing C-32',
    'Boeing C-32',
    'Boeing C-32A / C-32B Gatekeeper',
    'Boeing C-32A / C-32B Gatekeeper',
    'Boeing 757 du vice-président américain, et son jumeau secret au service des forces spéciales',
    'The US vice president''s Boeing 757, and its secretive twin serving special operations',
    '/assets/airplanes/boeing-c32.jpg',
    E'## Genèse\nAu milieu des années 1990, les **VC-137** dérivés du Boeing 707 qui transportent les dirigeants américains ont plusieurs décennies de service. En août 1996, l''US Air Force commande quatre **Boeing 757-2G4** pour les remplacer, aux côtés des plus petits C-37A puis des C-40. Désignés **C-32A**, ils ont deux fois l''autonomie du C-137 tout en se posant sur des pistes plus courtes. Le premier rejoint le 89th Airlift Wing à Andrews, près de Washington, fin juin 1998 ; d''autres suivent, jusqu''à huit appareils.\n\n## Conception\nLe C-32A est un 757-200 à cabine de 45 places, avec centre de transmissions, salle de conférence, salon et quartiers privés, et une avionique militaire. Il porte la livrée bleu et blanc, le drapeau sur la dérive et l''inscription « United States of America » dessinés par **Raymond Loewy** pour Air Force One. Deux réacteurs Pratt & Whitney PW2000 de 178 kN et des winglets lui donnent 10 460 km d''autonomie. Le **C-32B Gatekeeper**, lui, est un ancien 757 de ligne motorisé par des Rolls-Royce RB211, peint en blanc presque sans marques : réservoirs agrandis à la place des soutes, réceptacle de ravitaillement en vol, escalier intégré et treuil à bagages pour les terrains sommaires.\n\n## Carrière opérationnelle\nLes C-32A du 1st Airlift Squadron transportent le vice-président, qui prend alors l''indicatif **Air Force Two**, la Première dame, le secrétaire d''État et des membres du Congrès. Ils remplacent parfois le VC-25A comme Air Force One quand le président se rend sur un petit aéroport, ou pour tromper les menaces, comme lors du voyage de **Joe Biden** en Ukraine en février 2023. Les deux C-32B, achetés en 2001 pour près de 145 millions de dollars, servent les équipes d''urgence du département d''État ainsi que des missions classifiées des opérations spéciales et du renseignement, avec au moins deux membres d''équipage armés.\n\n## Place dans l''histoire\nLe C-32 incarne le transport gouvernemental à l''américaine, entre vitrine et discrétion. Les rénovations de cabine des C-32A, à 16 millions de dollars par avion, sont critiquées comme des « palais volants », et le C-32B, soupçonné sans preuve de vols de transfert de la CIA, gagne le surnom de « torture taxi ». Le 757 n''étant plus produit depuis 2004, l''Air Force prévoit de garder ses C-32A jusqu''en 2040, faute de successeur évident.',
    E'## Genesis\nBy the mid-1990s the Boeing 707-based **VC-137s** carrying America''s leaders had been in service for decades. In August 1996 the US Air Force ordered four **Boeing 757-2G4s** to replace them, alongside the smaller C-37A and later the C-40. Designated **C-32A**, they had twice the C-137''s range while landing on shorter runways. The first joined the 89th Airlift Wing at Andrews, near Washington, in late June 1998; more followed, up to eight aircraft.\n\n## Design\nThe C-32A is a 757-200 with a 45-seat cabin, a communications centre, a conference room, a lounge and private quarters, and military avionics. It wears the blue and white livery, the tail flag and the "United States of America" lettering designed by **Raymond Loewy** for Air Force One. Two 178 kN Pratt & Whitney PW2000 engines and winglets give it a range of 10,460 km. The **C-32B Gatekeeper**, by contrast, is a former airline 757 powered by Rolls-Royce RB211s, painted white with almost no markings: enlarged fuel tanks in place of the holds, an air refuelling receptacle, a built-in airstair and a baggage winch for austere airfields.\n\n## Operational career\nThe C-32As of the 1st Airlift Squadron carry the vice president, who then takes the call sign **Air Force Two**, the first lady, the secretary of state and members of Congress. They sometimes replace the VC-25A as Air Force One when the president flies into a small airport, or to throw off threats, as on **Joe Biden**''s trip to Ukraine in February 2023. The two C-32Bs, bought in 2001 for nearly $145 million, serve the State Department''s emergency support teams as well as classified special operations and intelligence missions, with at least two crew members always armed.\n\n## Place in history\nThe C-32 embodies American government transport, between showcase and secrecy. Cabin refits of the C-32As, at $16 million per aircraft, have been criticised as "flying palaces", and the C-32B, the subject of unsubstantiated rumours of CIA rendition flights, earned the nickname "torture taxi". With the 757 out of production since 2004, the Air Force plans to keep its C-32As until 2040, for lack of an obvious successor.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1996-08-01',
    NULL,
    '1998-06-01',
    974,
    10460,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing C-32'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Boeing C-32'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Boeing C-32'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing C-32'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 47.32,
  wingspan          = 38.05,
  height            = 13.49,
  wing_area         = 185.25,
  empty_weight      = 58391,
  mtow              = 116120,
  service_ceiling   = 12802,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 16,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney PW2000-40',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 178,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 10,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **C-32A** : Boeing 757-2G4 de transport de personnalités, 45 places, réacteurs Pratt & Whitney PW2000, huit appareils au 1st Airlift Squadron\n- **C-32A rénové** : cabine refaite à 16 millions de dollars par avion sous les présidences Obama, Trump et Biden\n- **C-32B Gatekeeper** : deux anciens 757 de ligne à réacteurs Rolls-Royce RB211, réservoirs agrandis et réceptacle de ravitaillement en vol, pour les missions des forces spéciales et du département d''État\n- **C-32B modernisé** : transmissions satellitaires sécurisées en bande Ku en 2014, collimateurs tête haute vers 2016',
  variants_en       = E'- **C-32A**: Boeing 757-2G4 VIP transport, 45 seats, Pratt & Whitney PW2000 engines, eight aircraft with the 1st Airlift Squadron\n- **Refitted C-32A**: cabin redone at $16 million per aircraft under the Obama, Trump and Biden administrations\n- **C-32B Gatekeeper**: two former airline 757s with Rolls-Royce RB211 engines, enlarged fuel tanks and an air refuelling receptacle, for special operations and State Department missions\n- **Upgraded C-32B**: secure Ku-band satellite communications in 2014, head-up displays around 2016',

  -- Strate 4 : qualitatif
  nickname          = 'Air Force Two',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_C-32',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_C-32',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Acroterion',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Boeing C-32';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing C-32';
