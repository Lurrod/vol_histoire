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
    status_en,
    weight
) VALUES (
    'F-5EM Tiger II',
    'F-5EM Tiger II',
    'Embraer F-5EM/FM Tiger II (Força Aérea Brasileira)',
    'Embraer F-5EM/FM Tiger II (Brazilian Air Force)',
    'Modernisation brésilienne du Northrop F-5 Tiger II par Embraer et Elbit',
    'Brazilian upgrade of the Northrop F-5 Tiger II by Embraer and Elbit',
    '/assets/airplanes/f5em-tiger-2.jpg',
    'Le F-5EM Tiger II est la modernisation majeure des F-5E/F brésiliens réalisée par Embraer, Elbit Systems et Mectron entre 2005 et 2013 sur 46 appareils. Upgrades : radar Grifo F, MFDs, HOTAS, liaison 16, INS/GPS, pods ELBit et EW, compatibilité missiles Python 4 et Derby. Cette refonte a prolongé la carrière de la flotte F-5 brésilienne jusqu''aux années 2030, en attendant la pleine montée en puissance du Gripen E/F. Basés à Santa Cruz (1° GAvCa) et Canoas (14° GAvCa).',
    'The F-5EM Tiger II is the major upgrade of Brazilian F-5E/F carried out by Embraer, Elbit Systems and Mectron between 2005 and 2013 on 46 aircraft. Upgrades: Grifo F radar, MFDs, HOTAS, Link 16, INS/GPS, Elbit pods and EW, compatibility with Python 4 and Derby missiles. This overhaul extended the Brazilian F-5 fleet career until the 2030s, pending full build-up of the Gripen E/F. Based at Santa Cruz (1° GAvCa) and Canoas (14° GAvCa).',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '2001-01-01',
    '2005-07-22',
    '2007-09-21',
    1700.0,
    2863.0,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    4410.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM armement WHERE name = 'M39')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM armement WHERE name = 'Python 4')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM armement WHERE name = 'Derby')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM armement WHERE name = 'Mk 83'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-5EM Tiger II'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 14.44, wingspan = 8.13, height = 4.07, wing_area = 17.28,
  empty_weight = 4410, mtow = 11187, service_ceiling = 15800, climb_rate = 175,
  combat_radius = 740, crew = 1, g_limit_pos = 7.33, g_limit_neg = -3.0,
  engine_name = 'General Electric J85-GE-21B', engine_count = 2,
  engine_type = 'Turbojet avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 15.6, thrust_wet = 22.2,
  production_start = 2005, production_end = 2013, units_built = 46,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Northrop_F-5',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Northrop_F-5#Brazilian_upgrades'
WHERE name = 'F-5EM Tiger II';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 15000000, unit_cost_year = 2010,
  manufacturer_page = 'https://www.embraer.com/',
  variants    = E'- **F-5EM** : monoplace upgrade (40 appareils)\n- **F-5FM** : biplace upgrade (6 appareils)\n- Upgrade Embraer + Elbit + Mectron 2005-2013 : radar Grifo F, MFD, HOTAS, Link 16, INS/GPS, EW, Python 4/Derby BVR, MAGIC/Mectron\n- 1° GAvCa (Santa Cruz RJ) et 14° GAvCa (Canoas RS)\n- Service prolongé jusqu''aux années 2030 en attendant la pleine capacité Gripen E/F',
  variants_en = E'- **F-5EM** : single-seat upgrade (40 aircraft)\n- **F-5FM** : two-seat upgrade (6 aircraft)\n- Embraer + Elbit + Mectron upgrade 2005-2013: Grifo F radar, MFD, HOTAS, Link 16, INS/GPS, EW, Python 4/Derby BVR, MAGIC/Mectron\n- 1° GAvCa (Santa Cruz RJ) and 14° GAvCa (Canoas RS)\n- Service extended into the 2030s pending full Gripen E/F capability'
WHERE name = 'F-5EM Tiger II';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nLa FAB acquiert 42 F-5E/B en 1975 puis 22 F-5E/F ex-Jordanie en 1988 (total 64 appareils). Face au vieillissement de la flotte, programme de modernisation majeur lancé en **2001** par **Embraer + Elbit Systems + Mectron** (consortium F-5BR Modernization) pour 1,2 milliard USD. Premier vol du F-5EM modernisé le **22 juillet 2005**. Livraison achevée en **2013** sur 46 cellules.\n\n## Carrière opérationnelle\nPierre angulaire de la défense aérienne brésilienne depuis 2010. Déployé depuis **Santa Cruz (Rio de Janeiro)** face à l''Atlantique Sud et **Canoas (Rio Grande do Sul)** face aux frontières sud. Participation régulière aux exercices **CRUZEX** et **Salitre** avec les forces aériennes sud-américaines. Assure la police du ciel des Jeux Olympiques de Rio 2016 et de la Coupe du monde 2014.\n\n## Héritage\nDémontre la capacité d''Embraer à prolonger la vie d''une cellule des années 1970 avec une avionique de pointe. Service prévu jusqu''aux années **2030** en attendant la pleine montée en puissance de la flotte **Gripen E/F** brésilienne (36 appareils commandés, livraisons 2020-2026).',
  description_en = E'## Genesis\nThe FAB acquires 42 F-5E/B in 1975 then 22 ex-Jordan F-5E/F in 1988 (total 64 aircraft). Facing fleet ageing, major upgrade programme launched in **2001** by **Embraer + Elbit Systems + Mectron** (F-5BR Modernization consortium) for USD 1.2 billion. First flight of the upgraded F-5EM on **22 July 2005**. Delivery completed in **2013** on 46 airframes.\n\n## Operational career\nCornerstone of Brazilian air defence since 2010. Based at **Santa Cruz (Rio de Janeiro)** facing the South Atlantic and **Canoas (Rio Grande do Sul)** facing southern borders. Regular participation in **CRUZEX** and **Salitre** exercises with South American air forces. Provided air policing during the 2016 Rio Olympic Games and the 2014 World Cup.\n\n## Legacy\nDemonstrates Embraer''s capability to extend the life of a 1970s airframe with cutting-edge avionics. Service planned until the **2030s** pending full build-up of the Brazilian **Gripen E/F** fleet (36 aircraft ordered, deliveries 2020-2026).'
WHERE name = 'F-5EM Tiger II';
