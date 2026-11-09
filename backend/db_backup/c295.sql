-- Airbus C295 (ex-CASA C-295)
--
-- Photo : 1199 SU-BTL Casa C295M Egyptian Air Force El Alamein 4.9.24 (53981388110).jpg
--   licence CC BY-SA 2.0 — Colin Cooke Photo
--   https://commons.wikimedia.org/wiki/File:1199_SU-BTL_Casa_C295M_Egyptian_Air_Force_El_Alamein_4.9.24_(53981388110).jpg

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
    'Airbus C295',
    'Airbus C295',
    'Airbus C295 (ex-CASA C-295)',
    'Airbus C295 (formerly CASA C-295)',
    'Le CN-235 allongé de trois mètres, devenu un succès à l’exportation',
    'The CN-235 stretched by three metres, turned export success',
    '/assets/airplanes/c295.jpg',
    E'## Genèse\nFin 1996, l''armée de l''air espagnole demande un transport intermédiaire entre le **CN-235** et le **C-130 Hercules**. CASA prend le chemin le plus court : allonger le CN-235. Le prototype vole le 28 novembre 1997 et l''appareil est certifié en Espagne et aux États-Unis dès décembre 1999. L''Espagne commande les neuf premiers en 1999 et les reçoit à partir de novembre 2001, pour remplacer des CN-235 passés à la patrouille maritime.\n\n## Conception\nDeux tronçons de 1,5 m de part et d''autre de l''aile, une voilure renforcée avec trois points d''emport de chaque côté, un train avant à deux roues et des turbopropulseurs **PW127G** de 2 645 ch à hélices à six pales. La soute de 12,69 m accueille 71 soldats, 48 parachutistes, 24 civières ou trois véhicules légers, pour neuf tonnes de charge utile — la moitié de plus que le CN-235. L''appareil se pose sur terrain sommaire et fait demi-tour sur une piste de 12 m de large. Son avionique, conçue avec Thales, répond aux normes civiles comme militaires.\n\n## Carrière opérationnelle\nLa Pologne est le premier client à l''exportation, en 2001, pour remplacer ses **An-26** ; un de ses appareils s''écrase en 2008 à Mirosławiec, tuant vingt personnes. L''Égypte devient le premier utilisateur avec 21 exemplaires. Le Canada en prend seize pour le sauvetage, à la place du **DHC-5 Buffalo**, et l''Inde 56, dont 40 assemblés par Tata à Vadodara. Les versions se multiplient : patrouille maritime armée, guet aérien, renseignement électromagnétique, bombardier d''eau, ravitailleur d''hélicoptères.\n\n## Place dans l''histoire\nPlus de trois cents commandes et trente-huit pays utilisateurs : le C295 a dépassé son aîné. La fiche du **CN-235** le présente comme sa descendance — une cellule hispano-indonésienne allongée de trois mètres, qui dispute depuis chaque marché au **C-27J Spartan** et lui a perdu le programme américain JCA en 2007.',
    E'## Genesis\nIn late 1996 the Spanish Air Force asked for a transport sitting between the **CN-235** and the **C-130 Hercules**. CASA took the shortest route: stretch the CN-235. The prototype flew on 28 November 1997 and the aircraft was certified in Spain and the United States as early as December 1999. Spain ordered the first nine in 1999 and received them from November 2001, to replace CN-235s moved over to maritime patrol.\n\n## Design\nTwo 1.5 m plugs either side of the wing, a strengthened wing with three hardpoints on each side, a twin-wheel nose gear and 2,645 hp **PW127G** turboprops driving six-bladed propellers. The 12.69 m hold takes 71 troops, 48 paratroopers, 24 stretchers or three light vehicles, for nine tonnes of payload — half as much again as the CN-235. The aircraft lands on rough strips and turns round on a runway 12 m wide. Its avionics, designed with Thales, meet civil as well as military standards.\n\n## Operational career\nPoland was the first export customer, in 2001, to replace its **An-26s**; one of its aircraft crashed at Mirosławiec in 2008, killing twenty people. Egypt became the largest user with 21 aircraft. Canada took sixteen for search and rescue, in place of the **DHC-5 Buffalo**, and India 56, of which 40 are assembled by Tata at Vadodara. Versions multiplied: armed maritime patrol, airborne early warning, signals intelligence, water bomber, helicopter tanker.\n\n## Place in history\nMore than three hundred orders and thirty-eight user countries: the C295 has overtaken its elder. The **CN-235** entry presents it as its descendant — a Spanish-Indonesian airframe stretched by three metres, which has contested every market with the **C-27J Spartan** ever since and lost the American JCA programme to it in 2007.',
    (SELECT id FROM countries WHERE code = 'ESP'),
    '1996-11-01',
    '1997-11-28',
    '2001-11-15',
    482.0,
    5750.0,
    (SELECT id FROM manufacturer WHERE code = 'CASA'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Airbus C295'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Airbus C295'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Airbus C295'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Airbus C295'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Airbus C295'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Airbus C295'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'Airbus C295'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 24.45,
  wingspan          = 25.81,
  height            = 8.66,
  wing_area         = 59.1,
  empty_weight      = NULL,
  mtow              = 23200,
  service_ceiling   = 7620,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PW127G',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1997,
  production_end    = NULL,
  units_built       = 241,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 38,
  variants          = E'- **C295M** : version de transport de base, 71 soldats ou cinq palettes\n- **C295 MPA Persuader** : patrouille maritime et lutte anti-sous-marine, six points d''emport\n- **C295 AEW** : guet aérien à radar **AESA** d''IAI sous radôme dorsal, resté au stade de prototype\n- **C295W** : version à winglets, plus économe au décollage et en croisière\n- **CN-295 / CC-295 Kingfisher** : production indonésienne sous licence ; version canadienne de recherche et sauvetage',
  variants_en       = E'- **C295M** : basic transport version, 71 troops or five pallets\n- **C295 MPA Persuader** : maritime patrol and anti-submarine warfare, six hardpoints\n- **C295 AEW** : airborne early warning with an IAI **AESA** radar in a dorsal radome, still a prototype\n- **C295W** : winglet version, more economical at take-off and in cruise\n- **CN-295 / CC-295 Kingfisher** : Indonesian licence production; Canadian search and rescue version',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Airbus_C295',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Airbus_C295',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Colin Cooke Photo',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Airbus C295';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Airbus C295';
