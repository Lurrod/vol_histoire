-- Bell Boeing V-22 Osprey
--
-- Photo : Ridge Runners and Red Lions team up for co-op flight 130214-M-RR352-006.jpg
--   licence Public domain — Cpl. Melissa Wenger, U.S. Marine Corps
--   https://commons.wikimedia.org/wiki/File:Ridge_Runners_and_Red_Lions_team_up_for_co-op_flight_130214-M-RR352-006.jpg

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
    'V-22 Osprey',
    'V-22 Osprey',
    'Bell Boeing V-22 Osprey',
    'Bell Boeing V-22 Osprey',
    'Décoller comme un hélicoptère, voler comme un avion : le premier convertible de série',
    'Take off like a helicopter, fly like an aeroplane: the first production tiltrotor',
    '/assets/airplanes/v22-osprey.jpg',
    E'## Genèse\nAvril 1980 : l''opération **Eagle Claw**, tentative de libération des otages américains de Téhéran, échoue dans le désert iranien. Il manquait un appareil capable de décoller comme un hélicoptère et de voler loin et vite comme un avion. Le programme interarmées JVX est lancé en 1981 ; Bell et Boeing Vertol, seuls à répondre, proposent en 1983 une version agrandie du démonstrateur **XV-15**. L''appareil est baptisé Osprey en janvier 1985.\n\n## Conception\nDeux turbomoteurs **Rolls-Royce T406** de 6 150 ch logés dans des nacelles basculantes en bout d''aile, deux rotors de 11,6 m reliés par un arbre qui traverse la voilure : si un moteur s''arrête, l''autre entraîne les deux rotors. Pour se ranger à bord des navires, l''aile pivote le long du fuselage et les pales se replient, exigence qui a lourdement pesé sur les coûts. Commandes de vol électriques, structure largement en composites, 24 soldats assis : l''Osprey vole nettement plus vite et plus loin qu''un hélicoptère de transport.\n\n## Carrière opérationnelle\nPremier vol le 19 mars 1989. Le secrétaire à la Défense **Dick Cheney** tente de l''annuler de 1989 à 1992 ; le Congrès le maintient. Deux accidents en 2000 tuent 23 Marines. Le Corps des Marines le met en service en juin 2007, à la place du CH-46, et l''engage aussitôt en **Irak**, puis en **Afghanistan** et en **Libye**. L''Air Force aligne le CV-22 des forces spéciales, la Navy le CMV-22B, et le Japon devient en 2020 le premier client étranger. L''accident d''un CV-22 au large de Yakushima, en novembre 2023, cloue la flotte au sol jusqu''en mars 2024.\n\n## Place dans l''histoire\nEnviron quatre cents exemplaires : le premier convertible produit en série. La fiche du **LTV XC-142** rappelle que l''idée du basculement avait été abandonnée en 1970 avec une aile entière ; l''Osprey ne fait pivoter que les nacelles. Sur les porte-avions, son CMV-22B succède au **C-2 Greyhound**. Il a fallu vingt-six ans entre le lancement du programme et la mise en service.',
    E'## Genesis\nApril 1980: Operation **Eagle Claw**, the attempt to free the American hostages in Tehran, failed in the Iranian desert. What had been missing was an aircraft able to take off like a helicopter and fly far and fast like an aeroplane. The joint-service JVX programme was launched in 1981; Bell and Boeing Vertol, the only bidders, proposed an enlarged version of the **XV-15** demonstrator in 1983. The aircraft was named Osprey in January 1985.\n\n## Design\nTwo 6,150 hp **Rolls-Royce T406** turboshafts housed in tilting wingtip nacelles, two 11.6 m rotors linked by a shaft running through the wing: if one engine stops, the other drives both rotors. To stow aboard ships, the wing swivels along the fuselage and the blades fold, a requirement that weighed heavily on costs. Fly-by-wire controls, a largely composite structure, 24 seated troops: the Osprey flies markedly faster and further than a transport helicopter.\n\n## Operational career\nFirst flight on 19 March 1989. Defense Secretary **Dick Cheney** tried to cancel it from 1989 to 1992; Congress kept it alive. Two crashes in 2000 killed 23 Marines. The Marine Corps brought it into service in June 2007, in place of the CH-46, and sent it straight to **Iraq**, then to **Afghanistan** and **Libya**. The Air Force fields the special operations CV-22, the Navy the CMV-22B, and Japan became the first foreign customer in 2020. The crash of a CV-22 off Yakushima in November 2023 grounded the fleet until March 2024.\n\n## Place in history\nAround four hundred built: the first tiltrotor in series production. The **LTV XC-142** entry recalls that the tilting idea had been dropped in 1970 with an entire wing; the Osprey tilts only its nacelles. On carriers its CMV-22B succeeds the **C-2 Greyhound**. Twenty-six years passed between the launch of the programme and service entry.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1981-01-01',
    '1989-03-19',
    '2007-06-13',
    509.0,
    4130.0,
    (SELECT id FROM manufacturer WHERE code = 'BEL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), (SELECT id FROM tech WHERE name = 'Rotors basculants')),
((SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.48,
  wingspan          = 13.97,
  height            = 6.73,
  wing_area         = 28.0,
  empty_weight      = 14432,
  mtow              = 27442,
  service_ceiling   = 7620,
  climb_rate        = NULL,
  g_limit_pos       = 4.0,
  g_limit_neg       = -1.0,
  combat_radius     = 722,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce T406-AD-400',
  engine_count      = 2,
  engine_type       = 'Turbomoteur à rotors basculants',
  engine_type_en    = 'Tiltrotor turboshaft',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1988,
  production_end    = NULL,
  units_built       = 400,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **MV-22B** : version d''assaut du Corps des Marines, en service depuis 2007\n- **CV-22B** : version des forces spéciales de l''US Air Force, mise en service en 2009\n- **CMV-22B** : ravitaillement des porte-avions de l''US Navy, successeur du **C-2 Greyhound** depuis 2021\n- **MV-22B japonais** : Forces terrestres d''autodéfense, premier client étranger en 2020\n- Issu du démonstrateur **Bell XV-15** ; autodéfense limitée à une mitrailleuse sur la rampe',
  variants_en       = E'- **MV-22B** : Marine Corps assault version, in service since 2007\n- **CV-22B** : US Air Force special operations version, in service from 2009\n- **CMV-22B** : US Navy carrier resupply, successor to the **C-2 Greyhound** since 2021\n- **Japanese MV-22B** : Ground Self-Defense Force, first foreign customer in 2020\n- Derived from the **Bell XV-15** demonstrator; self-defence limited to a ramp-mounted machine gun',

  -- Strate 4 : qualitatif
  nickname          = 'Osprey',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing-Bell_V-22_Osprey',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bell–Boeing_V-22_Osprey',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Cpl. Melissa Wenger, U.S. Marine Corps',
  image_licence     = 'Public domain'
WHERE name = 'V-22 Osprey';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'V-22 Osprey';
