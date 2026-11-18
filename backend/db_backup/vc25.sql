-- Boeing VC-25A
--
-- Photo : 195A3678-Edit-2.jpg
--   licence CC BY-SA 4.0 — R.E.I.JR
--   https://commons.wikimedia.org/wiki/File:195A3678-Edit-2.jpg

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
    'Boeing VC-25',
    'Boeing VC-25',
    'Boeing VC-25A',
    'Boeing VC-25A',
    'Boeing 747 présidentiel, blindé contre l''atome, qui devient Air Force One dès que le président monte à bord',
    'Presidential Boeing 747, hardened against nuclear attack, that becomes Air Force One once the president boards',
    '/assets/airplanes/boeing-vc25.jpg',
    E'## Genèse\nEn 1985, les deux **VC-137** dérivés du Boeing 707 qui transportent le président des États-Unis ont respectivement 23 et 13 ans de service. L''US Air Force cherche leur remplaçant : au moins trois moteurs et 9 700 km d''autonomie sans ravitaillement. Le **Boeing 747** l''emporte sur le **DC-10** de McDonnell Douglas, et deux 747-200B sont construits en 1986, sous la présidence de **Ronald Reagan**. Ils volent pour la première fois le 16 mai 1987, mais des difficultés de câblage des transmissions repoussent leur livraison à 1990, sous **George H. W. Bush**.\n\n## Conception\nLes 370 m² de plancher du 747 sont redistribués : soute à bagages et à vivres en bas, passagers sur le pont principal, cockpit et centre de transmissions à l''étage. À l''avant, la « Maison-Blanche » réunit la suite présidentielle, un bureau d''où le président peut s''adresser à la nation, une salle de conférence et une annexe médicale dotée d''une table d''opération ; deux cuisines peuvent nourrir cent personnes. L''avion est aussi un **poste de commandement** en cas d''attaque nucléaire : ravitaillable en vol, il porte 383 km de câblage blindé contre l''impulsion électromagnétique, un brouilleur **AN/ALQ-204 Matador**, des leurres thermiques et des paillettes.\n\n## Carrière opérationnelle\nConfiés au Presidential Airlift Group du 89th Airlift Wing, à Andrews près de Washington, les deux appareils, numérotés 28000 et 29000, ne prennent l''indicatif **Air Force One** qu''avec le président à bord. Le 11 septembre 2001, l''un d''eux doit se poser à Barksdale pour que **George W. Bush** puisse parler au pays ; le 27 novembre 2003, il le conduit en secret en Irak sous l''indicatif « Gulf Stream Five ». Ils ramènent aussi à Washington la dépouille des anciens présidents, de Reagan à Jimmy Carter. En 2014, l''heure de vol coûte 210 877 dollars.\n\n## Place dans l''histoire\nLe VC-25 est devenu l''un des symboles les plus reconnaissables de la présidence américaine, jusque dans le cinéma. Sa succession illustre la difficulté d''un programme hors normes : choisi en 2015, le **VC-25B** est tiré de deux 747-8 commandés par la compagnie russe Transaero et restés sans acheteur, et il accumule retards, fissures de lisses et surcoûts. En attendant, un ancien 747-8 de la flotte de l''émir du Qatar modifié par L3Harris, le **VC-25B Bridge**, vole comme Air Force One depuis le 1er juillet 2026 ; les VC-25A doivent rejoindre des musées vers 2028-2029.',
    E'## Genesis\nBy 1985 the two Boeing 707-based **VC-137s** carrying the president of the United States had been in service for 23 and 13 years respectively. The US Air Force sought a replacement with at least three engines and an unrefuelled range of 9,700 km. The **Boeing 747** beat McDonnell Douglas''s **DC-10**, and two 747-200Bs were built in 1986, under **Ronald Reagan**. They first flew on 16 May 1987, but problems with the communications wiring delayed delivery until 1990, under **George H. W. Bush**.\n\n## Design\nThe 747''s 370 m² of floor space was reorganised: luggage and food in the lower hold, passengers on the main deck, cockpit and communications centre upstairs. At the front, the "White House" groups the presidential suite, an office from which the president can address the nation, a conference room and a medical annex with an operating table; two galleys can feed a hundred people. The aircraft is also a **command post** in the event of nuclear attack: refuellable in flight, it carries 383 km of wiring shielded against electromagnetic pulse, an **AN/ALQ-204 Matador** jammer, flares and chaff.\n\n## Operational career\nAssigned to the Presidential Airlift Group of the 89th Airlift Wing at Andrews, near Washington, the two aircraft, numbered 28000 and 29000, use the call sign **Air Force One** only with the president aboard. On 11 September 2001 one of them had to land at Barksdale so that **George W. Bush** could address the country; on 27 November 2003 it flew him secretly to Iraq under the call sign "Gulf Stream Five". They have also carried former presidents home to Washington for their state funerals, from Reagan to Jimmy Carter. In 2014 a flight hour cost $210,877.\n\n## Place in history\nThe VC-25 has become one of the most recognisable symbols of the American presidency, cinema included. Its succession shows how hard such an unusual programme can be: chosen in 2015, the **VC-25B** uses two 747-8s ordered by the Russian airline Transaero and left unsold, and it has piled up delays, stringer cracks and cost overruns. Meanwhile a former Qatar Amiri Flight 747-8 modified by L3Harris, the **VC-25B Bridge**, has flown as Air Force One since 1 July 2026; the VC-25As are due to go to museums around 2028-2029.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1985-01-01',
    '1987-05-16',
    '1990-08-23',
    1014,
    12600,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing VC-25'), (SELECT id FROM tech WHERE name = 'Durcissement contre l''impulsion électromagnétique')),
((SELECT id FROM airplanes WHERE name = 'Boeing VC-25'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Boeing VC-25'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Boeing VC-25'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing VC-25'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 70.66,
  wingspan          = 59.94,
  height            = 19.33,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 377842,
  service_ceiling   = 13700,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 26,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CF6-80C2B1',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 252.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1986,
  production_end    = 1990,
  units_built       = 2,
  unit_cost_usd     = 325000000,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **VC-25A** : deux Boeing 747-200B (28000 et 29000) livrés en 1990, ravitaillables en vol et blindés contre l''impulsion électromagnétique\n- **VC-25B** : deux 747-8 Intercontinental construits pour Transaero, à modifier pour 3,9 milliards de dollars selon l''accord de 2018, livraison repoussée à la fin des années 2020\n- **VC-25B Bridge** : ancien 747-8I de la flotte de l''émir du Qatar modifié par L3Harris, Air Force One intérimaire depuis le 1er juillet 2026\n- **747-8I d''instruction** : deux appareils rachetés à Lufthansa en décembre 2025 pour 400 millions de dollars, pour la formation des pilotes et les pièces détachées',
  variants_en       = E'- **VC-25A**: two Boeing 747-200Bs (28000 and 29000) delivered in 1990, refuellable in flight and shielded against electromagnetic pulse\n- **VC-25B**: two 747-8 Intercontinentals built for Transaero, to be modified for $3.9 billion under the 2018 agreement, delivery pushed back to the late 2020s\n- **VC-25B Bridge**: former Qatar Amiri Flight 747-8I modified by L3Harris, interim Air Force One since 1 July 2026\n- **Training 747-8Is**: two aircraft bought from Lufthansa in December 2025 for $400 million, for pilot training and spare parts',

  -- Strate 4 : qualitatif
  nickname          = 'Air Force One',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_VC-25',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_VC-25',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'R.E.I.JR',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Boeing VC-25';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing VC-25';
