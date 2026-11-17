-- Boeing E-6B Mercury
--
-- Photo : United States Navy Boeing E-6B Mercury of Strategic Communications Wing ONE, Task Group 114.jpg
--   licence Public domain — USAF Greg L. Davis
--   https://commons.wikimedia.org/wiki/File:United_States_Navy_Boeing_E-6B_Mercury_of_Strategic_Communications_Wing_ONE,_Task_Group_114.jpg

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
    'Boeing E-6 Mercury',
    'Boeing E-6 Mercury',
    'Boeing E-6B Mercury',
    'Boeing E-6B Mercury',
    'Dernier dérivé du Boeing 707, relais volant des ordres de tir vers les sous-marins nucléaires',
    'The last Boeing 707 derivative, a flying relay for firing orders to nuclear submarines',
    '/assets/airplanes/boeing-e6.jpg',
    E'## Genèse\nPour transmettre les ordres de tir à ses sous-marins lanceurs d''engins, l''US Navy s''appuie sur des **EC-130Q**, des Hercules chargés d''électronique qui vieillissent mal. En 1977, le Naval Air Development Center étudie leur remplacement ; le Boeing 707, le Douglas DC-8 et le C-130 sont examinés, et le choix se porte en avril 1983 sur le **Boeing 707-320**. Sorti de l''usine de Renton en décembre 1986, le premier **E-6** vole le 19 février 1987. Baptisé Hermes, il entre en service en août 1989 au sein de l''escadron VQ-3 et devient **Mercury** à l''automne 1991.\n\n## Conception\nComme l''**E-3 Sentry**, l''E-6 reprend la cellule du 707, avec des réacteurs **CFM56** ; produit jusqu''en 1991, il est le dernier dérivé neuf du 707. Sa mission porte un nom, **TACAMO** pour « Take Charge And Move Out ». Pour parler aux sous-marins en plongée, il déroule des **antennes filaires traînantes** en très basse fréquence, la plus longue approchant 8 km. À la différence des autres avions de la Navy, il se ravitaille par perche rigide, grâce à un réceptacle au-dessus du poste : les **KC-135** et **KC-46** de l''Air Force peuvent ainsi le tenir en l''air jusqu''à 72 heures.\n\n## Carrière opérationnelle\nSeize E-6A sont livrés de 1988 à 1992 aux escadrons VQ-3 et VQ-4, ce qui permet de retirer les EC-130Q en juin 1991. L''**E-6B**, accepté en décembre 1997, ajoute un espace pour un état-major de combat. Il reprend aux **EC-135C** de l''Air Force la mission **Looking Glass**, poste de commandement aéroporté du Strategic Command, et peut commander à distance les missiles **Minuteman** grâce à l''Airborne Launch Control System. Les seize avions sont convertis, le dernier livré en décembre 2006, et reçoivent le poste de pilotage du **Boeing 737 Next Generation**. Basée à Tinker, dans l''Oklahoma, la flotte vole avec un équipage de 22 personnes.\n\n## Place dans l''histoire\nL''E-6 réunit dans une même cellule deux missions jusque-là confiées à deux armées : relayer les ordres vers les sous-marins et diriger les forces nucléaires si les centres au sol se taisent. Un E-3D racheté à la Royal Air Force en 2021 devait servir d''avion d''entraînement ; le projet est abandonné en 2025. La Navy lui a choisi pour successeur un dérivé du **C-130J-30**, baptisé **E-130J** en octobre 2024, mais compte sur l''E-6 jusque dans les années 2030. Côté soviétique, son homologue est le **Tu-142MR**.',
    E'## Genesis\nTo pass firing orders to its ballistic missile submarines, the US Navy relied on **EC-130Q** aircraft, electronics-laden Hercules that were ageing badly. In 1977 the Naval Air Development Center began studying a replacement; the Boeing 707, Douglas DC-8 and C-130 were examined, and in April 1983 the choice fell on the **Boeing 707-320**. Rolled out at Renton in December 1986, the first **E-6** flew on 19 February 1987. Named Hermes, it entered service in August 1989 with squadron VQ-3 and was renamed **Mercury** in autumn 1991.\n\n## Design\nLike the **E-3 Sentry**, the E-6 uses the 707 airframe, fitted with **CFM56** engines; with production lasting until 1991, it was the last new-build 707 derivative. Its mission has a name, **TACAMO**, for "Take Charge And Move Out". To talk to submerged submarines it reels out very low frequency **trailing wire antennas**, the longest close to 8 km. Unlike other Navy aircraft, it refuels by flying boom through a receptacle above the cockpit, so the Air Force''s **KC-135** and **KC-46** tankers can keep it aloft for up to 72 hours.\n\n## Operational career\nSixteen E-6As were delivered from 1988 to 1992 to squadrons VQ-3 and VQ-4, allowing the EC-130Q to be withdrawn in June 1991. The **E-6B**, accepted in December 1997, added a battle staff area. It took over from the Air Force''s **EC-135C** the **Looking Glass** mission, Strategic Command''s airborne command post, and can remotely control **Minuteman** missiles through the Airborne Launch Control System. All sixteen aircraft were converted, the last delivered in December 2006, and received the cockpit of the **Boeing 737 Next Generation**. Based at Tinker in Oklahoma, the fleet flies with a crew of 22.\n\n## Place in history\nThe E-6 brought together in one airframe two missions previously held by two services: relaying orders to submarines and directing nuclear forces should ground centres fall silent. A former Royal Air Force E-3D bought in 2021 was to become a training aircraft; the project was cancelled in 2025. The Navy has chosen as its successor a derivative of the **C-130J-30**, named **E-130J** in October 2024, but expects the E-6 to serve into the 2030s. On the Soviet side, its counterpart was the **Tu-142MR**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1983-04-01',
    '1987-02-19',
    '1989-08-01',
    967,
    12200,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-6 Mercury'), (SELECT id FROM tech WHERE name = 'Antenne filaire traînante')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-6 Mercury'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-6 Mercury'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-6 Mercury'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-6 Mercury'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-6 Mercury'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 45.82,
  wingspan          = 45.21,
  height            = 12.93,
  wing_area         = 283,
  empty_weight      = 78378,
  mtow              = 155129,
  service_ceiling   = 12192,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 22,

  -- Strate 2 : motorisation
  engine_name       = 'CFM International CFM56-2A-2',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1986,
  production_end    = 1991,
  units_built       = 16,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **E-6A Hermes / Mercury** : seize appareils livrés de 1988 à 1992, relais TACAMO vers les sous-marins lanceurs d''engins\n- **E-6B** : premier exemplaire accepté en décembre 1997, espace d''état-major et mission Looking Glass ; les seize E-6A convertis, le dernier en décembre 2006\n- **Poste 737 NG** : poste de pilotage du Boeing 737 Next Generation installé sur les E-6B\n- **TC-18F** : deux Boeing 707-382C d''occasion convertis pour l''entraînement des équipages, retirés en 2012',
  variants_en       = E'- **E-6A Hermes / Mercury**: sixteen aircraft delivered from 1988 to 1992, TACAMO relay to ballistic missile submarines\n- **E-6B**: first example accepted in December 1997, battle staff area and Looking Glass mission; all sixteen E-6As converted, the last in December 2006\n- **737 NG cockpit**: Boeing 737 Next Generation flight deck fitted to the E-6B\n- **TC-18F**: two second-hand Boeing 707-382Cs converted for crew training, retired in 2012',

  -- Strate 4 : qualitatif
  nickname          = 'TACAMO',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_E-6_Mercury',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_E-6_Mercury',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Greg L. Davis, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Boeing E-6 Mercury';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing E-6 Mercury';
