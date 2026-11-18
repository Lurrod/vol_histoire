-- Boeing VC-137 / C-137 Stratoliner
--
-- Photo : Boeing VC-137C SAM 26000 (Air Force One) in flight-130823-F-DW547-005.jpg
--   licence Public domain — Unknown authorUnknown author
--   https://commons.wikimedia.org/wiki/File:Boeing_VC-137C_SAM_26000_(Air_Force_One)_in_flight-130823-F-DW547-005.jpg

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
    'Boeing VC-137',
    'Boeing VC-137',
    'Boeing VC-137 / C-137 Stratoliner',
    'Boeing VC-137 / C-137 Stratoliner',
    'Boeing 707 présidentiel, premier Air Force One à réaction, de SAM 26000 à SAM 27000',
    'Presidential Boeing 707, the first jet Air Force One, from SAM 26000 to SAM 27000',
    '/assets/airplanes/boeing-vc137.jpg',
    E'## Genèse\nL''US Air Force n''achète que très peu de **Boeing 707** sous sa propre désignation : trois **707-153**, baptisés **VC-137A**, sont livrés en 1959 pour le transport de personnalités. Leur cabine compte 22 places VIP et peut, au besoin, servir de poste de commandement aéroporté. Ils sont confiés au 89th Military Airlift Wing, et l''Air Force complète la flotte en aménageant plusieurs C-135 au standard VC-135, surtout pour les déplacements à l''intérieur des États-Unis.\n\n## Conception\nLes VC-137A volent d''abord avec quatre turboréacteurs Pratt & Whitney J57 (JT3C-6) de 60 kN. En 1963, ils reçoivent des turbosoufflantes JT3D-3, ou TF33, de 80 kN, et deviennent des **VC-137B**. L''Air Force ajoute deux **707-353B Intercontinental**, achetés en 1962 et en 1972, avec un aménagement présidentiel et des transmissions avancées : les **VC-137C**. Ils franchissent plus de 12 000 km à 966 km/h de croisière, sous un plafond de 15 200 m.\n\n## Carrière opérationnelle\nSous les indicatifs **SAM 26000** et **SAM 27000**, les deux VC-137C deviennent **Air Force One** dès que le président est à bord. Le VC-137B 58-6971 ramène en 1981 les otages américains libérés de Téhéran, ce qui lui vaut le surnom de « Freedom One » ; le 58-6970, ancien Air Force One, est surnommé « Queenie ». Déclassés de leur rôle de transport de personnalités, les appareils deviennent des C-137B et C-137C. Deux autres C-137C les rejoignent en 1988, dont un 707 saisi à des trafiquants d''armes ; l''un d''eux est ensuite transformé en E-8C JSTARS.\n\n## Place dans l''histoire\nLe VC-137 fait entrer le transport présidentiel américain dans l''ère du jet, et la livrée bleu et blanc dessinée par **Raymond Loewy** à la demande du président Kennedy pour Air Force One habille encore les avions des Special Air Missions. SAM 26000 et SAM 27000 sont retirés en 1998 et en 2001 ; le premier est exposé au musée de l''US Air Force à Dayton, le second à la bibliothèque présidentielle Ronald Reagan, à Simi Valley. Leurs missions sont reprises par le **VC-25** pour le président et par les C-32, C-37A et C-40, qui doublent l''autonomie du C-137 tout en se posant sur des pistes plus courtes.',
    E'## Genesis\nThe US Air Force bought very few **Boeing 707s** under its own designation: three **707-153s**, named **VC-137A**, were delivered in 1959 for VIP transport. Their cabin had 22 VIP seats and could, if needed, serve as an airborne command post. They were assigned to the 89th Military Airlift Wing, and the Air Force supplemented the fleet by converting several C-135s to VC-135 standard, mainly for travel within the United States.\n\n## Design\nThe VC-137As first flew with four 60 kN Pratt & Whitney J57 (JT3C-6) turbojets. In 1963 they received 80 kN JT3D-3, or TF33, turbofans and became **VC-137Bs**. The Air Force added two **707-353B Intercontinentals**, bought in 1962 and 1972, with a presidential interior and advanced communications: the **VC-137Cs**. They could cover more than 12,000 km at a 966 km/h cruise, with a 15,200 m ceiling.\n\n## Operational career\nUnder the call signs **SAM 26000** and **SAM 27000**, the two VC-137Cs became **Air Force One** whenever the president was aboard. In 1981 VC-137B 58-6971 brought home the American hostages freed from Tehran, earning it the nickname "Freedom One"; 58-6970, a former Air Force One, was nicknamed "Queenie". Once downgraded from VIP transport, the aircraft became C-137Bs and C-137Cs. Two more C-137Cs joined them in 1988, one of them a 707 seized from arms smugglers; one was later converted into an E-8C JSTARS.\n\n## Place in history\nThe VC-137 brought American presidential transport into the jet age, and the blue and white livery designed by **Raymond Loewy** at President Kennedy''s request for Air Force One still adorns the Special Air Mission aircraft. SAM 26000 and SAM 27000 were retired in 1998 and 2001; the first is displayed at the National Museum of the US Air Force in Dayton, the second at the Ronald Reagan Presidential Library in Simi Valley. Their missions were taken over by the **VC-25** for the president and by the C-32, C-37A and C-40, which double the C-137''s range while landing on shorter runways.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1958-12-31',
    '1959-01-01',
    1009,
    12247,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing VC-137'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Boeing VC-137'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing VC-137'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 46.61,
  wingspan          = 44.42,
  height            = 12.93,
  wing_area         = 279.63,
  empty_weight      = 44663,
  mtow              = 148325,
  service_ceiling   = 15200,
  climb_rate        = 25.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney TF33-PW-102 (JT3D)',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 80,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **VC-137A** : trois 707-153 livrés en 1959, turboréacteurs J57, 22 places VIP et poste de commandement aéroporté possible\n- **VC-137B / C-137B** : les trois VC-137A remotorisés en 1963 avec des turbosoufflantes JT3D-3, puis déclassés du rôle VIP\n- **VC-137C** : deux 707-353B présidentiels, SAM 26000 (1962) et SAM 27000 (1972), retirés en 1998 et en 2001\n- **C-137C** : désignation des VC-137C déclassés et de deux 707 d''occasion acquis en 1988, dont l''un devient E-8C JSTARS\n- **EC-137D** : deux prototypes du système de détection AWACS, devenus des E-3A',
  variants_en       = E'- **VC-137A**: three 707-153s delivered in 1959, J57 turbojets, 22 VIP seats and provision for an airborne command post\n- **VC-137B / C-137B**: the three VC-137As re-engined in 1963 with JT3D-3 turbofans, later downgraded from the VIP role\n- **VC-137C**: two presidential 707-353Bs, SAM 26000 (1962) and SAM 27000 (1972), retired in 1998 and 2001\n- **C-137C**: designation of the downgraded VC-137Cs and of two second-hand 707s acquired in 1988, one of which became an E-8C JSTARS\n- **EC-137D**: two AWACS prototypes, later E-3As',

  -- Strate 4 : qualitatif
  nickname          = 'Air Force One',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_C-137_Stratoliner',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_C-137_Stratoliner',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Boeing VC-137';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing VC-137';
