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
    'F-4E Kurnass',
    'F-4E Kurnass',
    'McDonnell Douglas F-4E Kurnass / Kurnass 2000 (Israeli Air Force)',
    'McDonnell Douglas F-4E Kurnass / Kurnass 2000 (Israeli Air Force)',
    'Version israélienne du F-4E Phantom II, modernisée au standard Kurnass 2000',
    'Israeli version of the F-4E Phantom II, upgraded to Kurnass 2000 standard',
    '/assets/airplanes/f4e-kurnass.jpg',
    'Le F-4E Kurnass ("Masse d''armes" en hébreu) est la version israélienne du McDonnell Douglas F-4E Phantom II reçue à partir de 1969 dans le cadre d''un deal Kennedy-Eshkol suivant l''embargo français (204 appareils livrés). Pilier de la Guerre du Kippour (1973) où il a joué un rôle majeur dans les frappes contre les défenses aériennes syriennes et égyptiennes, à un coût humain et matériel important (40+ pertes sur SA-6). Modernisé au standard Kurnass 2000 dans les années 1990 par IAI (radar Elta, HUD numérique, compatibilité Popeye et GBU-15). Retiré définitivement en 2004, remplacé par F-15I et F-16I.',
    'The F-4E Kurnass ("Mace" in Hebrew) is the Israeli version of the McDonnell Douglas F-4E Phantom II received from 1969 as part of the Kennedy-Eshkol deal following the French embargo (204 aircraft delivered). A pillar of the Yom Kippur War (1973) where it played a major role in strikes against Syrian and Egyptian air defences, at a heavy human and material cost (40+ losses to SA-6). Upgraded to Kurnass 2000 standard in the 1990s by IAI (Elta radar, digital HUD, Popeye and GBU-15 compatibility). Finally retired in 2004, replaced by F-15I and F-16I.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1967-01-01',
    '1969-09-05',
    '1969-09-05',
    2370.0,
    2600.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired',
    13757.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM tech WHERE name = 'Radar AN/APQ-120')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM armement WHERE name = 'Python 3')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM armement WHERE name = 'Popeye')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM armement WHERE name = 'AGM-45 Shrike')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM armement WHERE name = 'Mk 84')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM wars WHERE name = 'Guerre du Liban')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), (SELECT id FROM missions WHERE name = 'Interception'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 19.20, wingspan = 11.77, height = 5.00, wing_area = 49.20,
  empty_weight = 13757, mtow = 28030, service_ceiling = 18000, climb_rate = 210,
  combat_radius = 680, crew = 2, g_limit_pos = 7.5, g_limit_neg = -3.0,
  engine_name = 'General Electric J79-GE-17', engine_count = 2,
  engine_type = 'Turbojet avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 52.8, thrust_wet = 79.6,
  production_start = 1969, production_end = 1976, units_built = 204,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_F-4_Phantom_II',
  wikipedia_en = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_F-4_Phantom_II#Israel'
WHERE name = 'F-4E Kurnass';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 4000000, unit_cost_year = 1970,
  manufacturer_page = 'https://www.boeing.com/',
  variants    = E'- **F-4E Kurnass** : version initiale livrée 1969-1976 (204 appareils)\n- **RF-4E Kurnass** : reconnaissance photographique (12 appareils)\n- **F-4E Kurnass 2000** : upgrade majeur IAI 1989-1998 (39 appareils) — HUD numérique, HOTAS, INS, radar AN/APG-76 (licence), Popeye AGM-142 Have Nap, GBU-15\n- **F-4E Super Phantom** : prototype de refonte profonde avec moteur PW1120 (F100 adapté) — 1 prototype, projet abandonné au profit du F-16I',
  variants_en = E'- **F-4E Kurnass** : initial version delivered 1969-1976 (204 aircraft)\n- **RF-4E Kurnass** : photo reconnaissance (12 aircraft)\n- **F-4E Kurnass 2000** : major IAI upgrade 1989-1998 (39 aircraft) — digital HUD, HOTAS, INS, AN/APG-76 radar (licence), Popeye AGM-142 Have Nap, GBU-15\n- **F-4E Super Phantom** : deep redesign prototype with PW1120 engine (adapted F100) — 1 prototype, project dropped in favour of F-16I'
WHERE name = 'F-4E Kurnass';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nAccord bilatéral **Kennedy-Eshkol** (décembre 1968) autorisant la vente de 50 F-4E et 6 RF-4E à Israël après l''embargo français. Premier F-4E Kurnass ("Masse d''armes") livré à Hatzor le **5 septembre 1969**. **204 appareils** livrés au total sur 7 ans — le plus grand client étranger du Phantom avec l''Allemagne.\n\n## Carrière opérationnelle\nPilier de la **Guerre d''usure (1969-1970)** avec des frappes stratégiques profondes contre l''Égypte — opération **Priha** (raids sur le Caire). Rôle majeur dans la **Guerre du Kippour (1973)** : frappes SEAD contre les SA-6 syriens et égyptiens au prix humain et matériel très lourd (~40 Kurnass perdus sur SAM en 18 jours). Modernisation **Kurnass 2000** (1989-1998) sur 39 appareils prolonge le service jusqu''en **2004**.\n\n## Héritage\nPlus longue carrière opérationnelle du F-4 israélien : **35 ans de service continu** (1969-2004). Référence mondiale du SEAD/DEAD moderne (leçons du Kippour reprises par l''USAF Wild Weasel). Remplacé par F-15I Ra''am (frappe stratégique) et F-16I Sufa (multirôle).',
  description_en = E'## Genesis\nBilateral **Kennedy-Eshkol** agreement (December 1968) authorising the sale of 50 F-4E and 6 RF-4E to Israel after the French embargo. First F-4E Kurnass ("Mace") delivered to Hatzor on **5 September 1969**. **204 aircraft** delivered in total over 7 years — the largest foreign customer for the Phantom alongside Germany.\n\n## Operational career\nPillar of the **War of Attrition (1969-1970)** with deep strategic strikes against Egypt — Operation **Priha** (raids on Cairo). Major role in the **Yom Kippur War (1973)**: SEAD strikes against Syrian and Egyptian SA-6 at very heavy human and material cost (~40 Kurnass lost to SAM in 18 days). **Kurnass 2000** upgrade (1989-1998) on 39 aircraft extends service until **2004**.\n\n## Legacy\nLongest operational career of the Israeli F-4: **35 years of continuous service** (1969-2004). World reference for modern SEAD/DEAD (Kippur lessons adopted by USAF Wild Weasel). Replaced by F-15I Ra''am (strategic strike) and F-16I Sufa (multirole).'
WHERE name = 'F-4E Kurnass';
