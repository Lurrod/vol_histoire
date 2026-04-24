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
    'HAL Tejas Mk1A',
    'HAL Tejas Mk1A',
    'HAL Tejas Mk1A LCA (Indian Air Force)',
    'HAL Tejas Mk1A LCA (Indian Air Force)',
    'Version modernisée du Tejas Mk1 avec radar AESA et armement BVR',
    'Upgraded Tejas Mk1 variant with AESA radar and BVR weapons',
    '/assets/airplanes/hal-tejas-mk1a.jpg',
    'Le HAL Tejas Mk1A est la version améliorée du Tejas Mk1, introduisant un radar à antenne active (AESA) EL/M-2052 d''Elta, une suite de guerre électronique EW indigène Angad, une capacité BVR intégrée (Derby NG / Astra Mk1) et un maintenance friendly cockpit. 83 appareils commandés en 2021 pour 46 898 crore INR, premières livraisons attendues en 2024. Le Mk1A comble l''écart capacitaire en attendant la génération Mk2 (MWF).',
    'The HAL Tejas Mk1A is the upgraded variant of the Tejas Mk1, introducing an Elta EL/M-2052 AESA radar, an indigenous Angad EW suite, an integrated BVR capability (Derby NG / Astra Mk1) and a maintenance-friendly cockpit. 83 aircraft ordered in 2021 for INR 46,898 crore, first deliveries expected in 2024. The Mk1A fills the capability gap pending the Mk2 (MWF) generation.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '2018-01-01',
    '2024-03-28',
    '2024-12-01',
    1975.0,
    3000.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    6560.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric F404')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'Derby')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'Python 5')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'Astra Mk1'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 13.20, wingspan = 8.20, height = 4.40, wing_area = 38.40,
  empty_weight = 6560, mtow = 13500, service_ceiling = 15240, climb_rate = 53,
  combat_radius = 500, crew = 1, g_limit_pos = 8.0, g_limit_neg = -3.5,
  engine_name = 'General Electric F404-GE-IN20', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 53.9, thrust_wet = 84.0,
  production_start = 2024, production_end = NULL, units_built = 0,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_Tejas',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_Tejas#Variants'
WHERE name = 'HAL Tejas Mk1A';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 42000000, unit_cost_year = 2021,
  manufacturer_page = 'https://hal-india.co.in/tejas',
  variants    = E'- **Mk1A** : upgrade Mk1 avec radar AESA Elta EL/M-2052, EW Angad, Derby NG/Astra Mk1 BVR, maintenance conviviale\n- 83 appareils commandés en 2021 (46 898 crore INR)\n- 97 appareils supplémentaires commandés en 2023 (67 000 crore INR)',
  variants_en = E'- **Mk1A** : Mk1 upgrade with Elta EL/M-2052 AESA radar, Angad EW, Derby NG/Astra Mk1 BVR, maintenance-friendly design\n- 83 aircraft ordered in 2021 (INR 46,898 crore)\n- 97 additional aircraft ordered in 2023 (INR 67,000 crore)'
WHERE name = 'HAL Tejas Mk1A';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme de modernisation incrémentale du Tejas Mk1 lancé en **2018** pour répondre aux critiques de l''IAF sur le manque de capacité BVR, de radar AESA et de maintenance conviviale. Premier vol du prototype Mk1A le **28 mars 2024**.\n\n## Carrière opérationnelle\n**180 appareils commandés** au total (83 en 2021 + 97 en 2023) pour environ **14 milliards USD**. Premières livraisons prévues mi-2024, cadence de 24/an à pleine charge. Le Mk1A comble l''écart capacitaire en attendant la génération Mk2 (MWF). Exporté potentiellement vers l''Argentine, l''Égypte et les Philippines.\n\n## Héritage\nIncarne la maturité de l''écosystème aéronautique indien — radar AESA Uttam indigène en intégration, EW Angad DRDO, missile Astra Mk1 BVR. La production Mk1A précède celle du Mk2 et contribue à la capacité de la chaîne HAL pour l''AMCA.',
  description_en = E'## Genesis\nIncremental upgrade programme of the Tejas Mk1 launched in **2018** to address IAF criticism of insufficient BVR capability, lack of AESA radar and maintenance-unfriendly design. First Mk1A prototype flight on **28 March 2024**.\n\n## Operational career\n**180 aircraft ordered** in total (83 in 2021 + 97 in 2023) for approximately **USD 14 billion**. First deliveries expected mid-2024, rate of 24/year at full capacity. The Mk1A fills the capability gap pending the Mk2 (MWF) generation. Potential exports to Argentina, Egypt and the Philippines.\n\n## Legacy\nEmbodies the maturity of the Indian aerospace ecosystem — indigenous Uttam AESA radar in integration, DRDO Angad EW, Astra Mk1 BVR missile. Mk1A production precedes the Mk2 and contributes to HAL chain capacity for the AMCA.'
WHERE name = 'HAL Tejas Mk1A';
