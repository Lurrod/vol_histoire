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
    'HAL Tejas Mk2',
    'HAL Tejas Mk2',
    'HAL Tejas Mk2 MWF (Indian Air Force)',
    'HAL Tejas Mk2 MWF (Indian Air Force)',
    'Chasseur multirôle indien de catégorie medium, dérivé amplifié du Tejas',
    'Indian medium-weight multirole fighter, enlarged derivative of the Tejas',
    '/assets/airplanes/hal-tejas-mk2.jpg',
    'Le HAL Tejas Mk2 (Medium Weight Fighter — MWF) est une évolution profonde du Tejas, passant dans la catégorie des 17,5 tonnes au décollage maximal. Dotée d''un fuselage rallongé, de canards delta, d''un réacteur GE F414-INS6 (98 kN) et d''une capacité d''emport de 6500 kg sur 13 points, cette plateforme vise à remplacer les Mirage 2000, MiG-29 et Jaguar de l''Indian Air Force. Premier vol prévu en 2026, service opérationnel en 2030. Radar Uttam AESA indigène, suite EW intégrée, Meteor et BrahMos-NG compatibles.',
    'The HAL Tejas Mk2 (Medium Weight Fighter — MWF) is a deep evolution of the Tejas, moving into the 17.5-tonne maximum take-off weight class. With a stretched fuselage, delta canards, a GE F414-INS6 engine (98 kN) and a 6500 kg payload across 13 hardpoints, this platform aims to replace the Indian Air Force''s Mirage 2000, MiG-29 and Jaguar. First flight scheduled for 2026, operational service in 2030. Indigenous Uttam AESA radar, integrated EW suite, Meteor and BrahMos-NG compatible.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '2009-01-01',
    NULL,
    NULL,
    2385.0,
    3500.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En développement',
    'In development',
    7850.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'Derby')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'Python 5')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'SCALP EG')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'Astra Mk1')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'BrahMos-A'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 14.65, wingspan = 8.50, height = 4.80, wing_area = 43.00,
  empty_weight = 7850, mtow = 17500, service_ceiling = 17000, climb_rate = 65,
  combat_radius = 1500, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.5,
  engine_name = 'General Electric F414-INS6', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 62.3, thrust_wet = 98.0,
  production_start = NULL, production_end = NULL, units_built = 0,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_Tejas_Mark_2',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_Tejas_Mk2'
WHERE name = 'HAL Tejas Mk2';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 72000000, unit_cost_year = 2025,
  manufacturer_page = 'https://hal-india.co.in/',
  variants    = E'- **MWF (Medium Weight Fighter)** : version de production monoplace\n- 13 pylônes, 6500 kg de charge utile, canards delta, radar Uttam AESA indigène\n- Compatible Astra Mk1/Mk2, Meteor, SCALP, BrahMos-NG, Rudram-1\n- 6 escadrons prévus (~108 appareils) pour remplacer Mirage 2000, MiG-29, Jaguar',
  variants_en = E'- **MWF (Medium Weight Fighter)** : single-seat production version\n- 13 pylons, 6,500 kg payload, delta canards, indigenous Uttam AESA radar\n- Compatible with Astra Mk1/Mk2, Meteor, SCALP, BrahMos-NG, Rudram-1\n- 6 squadrons planned (~108 aircraft) to replace Mirage 2000, MiG-29, Jaguar'
WHERE name = 'HAL Tejas Mk2';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme approuvé par le Cabinet indien le **31 août 2022** avec un budget de **9 000 crore INR** (≈ 1,1 milliard USD) pour le développement. Évolution profonde du Tejas Mk1 — fuselage rallongé (+1,35 m), canards delta, réacteur F414 plus puissant (+48 % de poussée). Premier vol prévu en **2026**, service opérationnel en **2030**.\n\n## Carrière opérationnelle\nProduction attendue à partir de 2030. Cible : **108+ appareils** pour remplacer les Mirage 2000, MiG-29, Jaguar IS dans l''IAF. Plateforme naval LCA Navy Mk2 dérivée prévue pour INS Vikrant.\n\n## Héritage\nPasserelle technologique entre le LCA (Mk1/Mk1A) et l''AMCA de 5e génération. Première cellule indienne avec capacité de fuel dorsal (CFT) et soute partielle pour missiles semi-enfouis. Radar Uttam AESA indigène — étape clé vers la souveraineté aéronautique.',
  description_en = E'## Genesis\nProgramme approved by the Indian Cabinet on **31 August 2022** with a budget of **INR 9,000 crore** (≈ USD 1.1 billion) for development. Deep evolution of the Tejas Mk1 — stretched fuselage (+1.35 m), delta canards, more powerful F414 engine (+48 % thrust). First flight scheduled for **2026**, operational service in **2030**.\n\n## Operational career\nProduction expected from 2030. Target: **108+ aircraft** to replace Mirage 2000, MiG-29, Jaguar IS in the IAF. Derived naval LCA Navy Mk2 platform planned for INS Vikrant.\n\n## Legacy\nTechnological bridge between the LCA (Mk1/Mk1A) and the 5th-generation AMCA. First Indian airframe with dorsal fuel (CFT) capacity and partial semi-recessed missile bay. Indigenous Uttam AESA radar — a key step towards aerospace sovereignty.'
WHERE name = 'HAL Tejas Mk2';
