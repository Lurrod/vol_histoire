-- McDonnell Douglas T-45 Goshawk
--
-- Photo : 170320-N-QI061-024 (33647844625).jpg
--   licence Public domain — National Museum of the U.S. Navy
--   https://commons.wikimedia.org/wiki/File:170320-N-QI061-024_(33647844625).jpg

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
    'T-45 Goshawk',
    'T-45 Goshawk',
    'McDonnell Douglas T-45 Goshawk',
    'McDonnell Douglas T-45 Goshawk',
    'Le Hawk britannique renforcé pour le porte-avions, école des pilotes embarqués américains depuis 1991',
    'The British Hawk strengthened for carrier work, school of American naval jet pilots since 1991',
    '/assets/airplanes/t45-goshawk.jpg',
    E'## Genèse\nAu milieu des années 1970, l''**US Navy** cherche un seul avion pour remplacer deux écoles : le **T-2 Buckeye** et le TA-4 Skyhawk biplace. Le programme VTXTS, lancé en 1978, ne porte pas seulement sur un appareil mais sur un système complet : simulateurs, enseignement au sol, soutien logistique. **McDonnell Douglas** s''associe à **British Aerospace** pour proposer une version navale du **Hawk** britannique, face notamment à l''Alpha Jet de Dassault et Dornier et à une offre de Lockheed. Le Hawk l''emporte en novembre 1981 et devient le **T-45 Goshawk**.\n\n## Conception\nUn Hawk terrestre ne supporte ni la catapulte ni l''appontage. Il faut renforcer la cellule et le train pour encaisser des contacts à 4,3 m/s de vitesse verticale, monter une roue avant double avec barre de catapultage, une crosse d''appontage, un empennage horizontal agrandi et deux aérofreins latéraux. Les essais de la Navy imposent encore une quille ventrale, une dérive rallongée, des saumons d''aile carrés et des becs de bord d''attaque. Le dessin vise le **USS Lexington**, porte-avions d''entraînement aux catapultes et brins d''arrêt courts. Le moteur reste le turbofan **Rolls-Royce Turbomeca Adour** ; près de 60 % du travail est réalisé au Royaume-Uni. Le premier T-45A vole le 16 avril 1988.\n\n## Carrière opérationnelle\nEn service à partir de 1991 à Meridian (Mississippi) et Kingsville (Texas), le Goshawk prend en charge les phases intermédiaire et avancée des futurs pilotes d''attaque de la Navy et des Marines. À partir de décembre 1997, le **T-45C** apporte une planche de bord à écrans et un collimateur tête haute, et tous les T-45A sont mis à ce standard. Depuis 2008, il forme aussi les officiers navigants à Pensacola, certains équipés d''un radar simulé reproduisant celui du **Super Hornet**. La plupart des pilotes de l''Aéronavale française y ont aussi fait leur premier appontage. En 2017, plus de cent instructeurs refusent de voler à cause d''épisodes d''hypoxie liés au générateur d''oxygène, qui est ensuite remplacé.\n\n## Place dans l''histoire\nConstruit à 221 exemplaires jusqu''en novembre 2009, le T-45 est l''un des rares avions militaires britanniques adoptés en série par les forces américaines. Il a fait du Hawk une famille transatlantique et prouvé qu''un avion d''école terrestre pouvait devenir embarqué. Environ 34 appareils ont été perdus en accident ; la Navy prévoit de le garder jusqu''en 2035 au moins.',
    E'## Genesis\nIn the mid-1970s the **US Navy** sought a single aircraft to replace two trainers: the **T-2 Buckeye** and the two-seat TA-4 Skyhawk. The VTXTS programme, launched in 1978, covered not just an aircraft but a complete system: simulators, academic training, logistic support. **McDonnell Douglas** teamed with **British Aerospace** to offer a naval version of the British **Hawk**, against rivals including the Dassault-Dornier Alpha Jet and a Lockheed bid. The Hawk won in November 1981 and became the **T-45 Goshawk**.\n\n## Design\nA land-based Hawk could withstand neither catapult nor carrier landing. The airframe and undercarriage had to be strengthened for touchdowns at 4.3 m/s sink rate, with a twin-wheel nose gear and catapult tow bar, an arrester hook, a larger tailplane and two side airbrakes. Navy testing then required a ventral fin, an extended tail fin, squared-off wingtips and leading-edge slats. The design targeted the **USS Lexington**, the training carrier with short catapults and short arrester gear. The engine remained the **Rolls-Royce Turbomeca Adour** turbofan; about 60 per cent of the work was done in Britain. The first T-45A flew on 16 April 1988.\n\n## Operational career\nIn service from 1991 at Meridian, Mississippi, and Kingsville, Texas, the Goshawk took on the intermediate and advanced phases for Navy and Marine Corps strike pilots. From December 1997 the **T-45C** introduced a glass cockpit and head-up display, and all T-45As were brought to that standard. Since 2008 it has also trained flight officers at Pensacola, some fitted with a simulated radar reproducing that of the **Super Hornet**. Most French Navy pilots have also made their first carrier landing on it. In 2017 more than a hundred instructors refused to fly because of hypoxia episodes linked to the oxygen generator, which was later replaced.\n\n## Place in history\nBuilt to 221 aircraft until November 2009, the T-45 is one of the few British military aircraft adopted in quantity by the American forces. It turned the Hawk into a transatlantic family and proved that a land-based trainer could go to sea. About 34 have been lost in accidents; the Navy plans to keep it until at least 2035.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1978-01-01',
    '1988-04-16',
    '1991-01-01',
    1006,
    1300,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'T-45 Goshawk'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'T-45 Goshawk'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce/Turbomeca Adour')),
((SELECT id FROM airplanes WHERE name = 'T-45 Goshawk'), (SELECT id FROM tech WHERE name = 'Système de décollage et d''atterrissage sur porte-avions')),
((SELECT id FROM airplanes WHERE name = 'T-45 Goshawk'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'T-45 Goshawk'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.99,
  wingspan          = 9.39,
  height            = 4.11,
  wing_area         = 17.66,
  empty_weight      = 4261,
  mtow              = 6123,
  service_ceiling   = 13000,
  climb_rate        = 41,
  g_limit_pos       = 7.33,
  g_limit_neg       = -3,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Turbomeca F405-RR-401 (Adour)',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 24.59,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1988,
  production_end    = 2009,
  units_built       = 221,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **T-45A** : version initiale à planche de bord analogique, en service en 1991\n- **T-45B** : version terrestre sans aptitude embarquée, abandonnée en 1984\n- **T-45C** : planche de bord à écrans, collimateur tête haute et navigation inertielle, livré à partir de 1997 ; tous les T-45A y ont été portés\n- **T-45C à radar simulé** : 19 appareils dotés d''un système reproduisant le radar APG-73 du Super Hornet pour former les officiers navigants\n- **T-45D** : désignation provisoire d''une modernisation envisagée',
  variants_en       = E'- **T-45A**: initial version with analogue cockpit, in service in 1991\n- **T-45B**: land-based version without carrier capability, abandoned in 1984\n- **T-45C**: glass cockpit, head-up display and inertial navigation, delivered from 1997; all T-45As were brought to this standard\n- **T-45C with simulated radar**: 19 aircraft with a system reproducing the Super Hornet''s APG-73 radar to train flight officers\n- **T-45D**: tentative designation for a planned upgrade',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_T-45_Goshawk',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_T-45_Goshawk',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'T-45 Goshawk';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'T-45 Goshawk';
