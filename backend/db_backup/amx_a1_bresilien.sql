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
    'AMX A-1 Brésilien',
    'AMX A-1 Brazilian',
    'Embraer A-1 (AMX International) — Força Aérea Brasileira',
    'Embraer A-1 (AMX International) — Brazilian Air Force',
    'Version brésilienne de l''AMX International pour la Força Aérea Brasileira',
    'Brazilian version of the AMX International for the Brazilian Air Force',
    '/assets/airplanes/amx-bresilien.jpg',
    'L''A-1 est la désignation brésilienne de l''AMX International, avion d''attaque tactique issu du programme tri-national Italie-Brésil-Embraer lancé en 1980. Embraer a produit 56 appareils pour la Força Aérea Brasileira entre 1990 et 1999, dont la modernisation A-1M (2013-2023) a introduit un radar Elta EL/M-2032, un cockpit tout écran, de nouvelles liaisons de données et la compatibilité bombes guidées GBU-12 et Mectron MAR-1. L''A-1 a été engagé dans des missions de surveillance aux frontières amazoniennes et lors d''exercices OTAN (CRUZEX). Retrait progressif prévu face à l''arrivée du Gripen E.',
    'The A-1 is the Brazilian designation of the AMX International, a tactical attack aircraft from the tri-national Italy-Brazil-Embraer programme launched in 1980. Embraer produced 56 aircraft for the Brazilian Air Force between 1990 and 1999, with the A-1M upgrade (2013-2023) introducing an Elta EL/M-2032 radar, a fully digital cockpit, new data links and compatibility with GBU-12 and Mectron MAR-1 guided bombs. The A-1 has been deployed in Amazon border surveillance missions and NATO exercises (CRUZEX). Gradual retirement planned with the arrival of the Gripen E.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1980-04-01',
    '1985-05-15',
    '1990-10-05',
    1053.0,
    3330.0,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Actif',
    'Active',
    6700.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Spey')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM tech WHERE name = 'Radar EL/M-2032')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'MAR-1')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'Mk 83')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'Mk 84'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 13.57, wingspan = 8.87, height = 4.58, wing_area = 21.00,
  empty_weight = 6700, mtow = 13000, service_ceiling = 13000, climb_rate = 51,
  combat_radius = 520, crew = 1, g_limit_pos = 8.0, g_limit_neg = -3.0,
  engine_name = 'Rolls-Royce Spey Mk 807 (licence Fiat)', engine_count = 1,
  engine_type = 'Turbofan', engine_type_en = 'Turbofan',
  thrust_dry = 49.1, thrust_wet = NULL,
  production_start = 1989, production_end = 1999, units_built = 56,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/AMX_International_AMX',
  wikipedia_en = 'https://en.wikipedia.org/wiki/AMX_International_AMX'
WHERE name = 'AMX A-1 Brésilien';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 22000000, unit_cost_year = 1995,
  manufacturer_page = 'https://www.embraer.com/',
  variants    = E'- **A-1A** : monoplace d''attaque FAB (40 appareils)\n- **A-1B** : biplace d''entraînement (16 appareils)\n- **A-1M (AMX/M-AMX)** : modernisation 2013-2023 par Embraer avec radar Elta EL/M-2032, cockpit tout écran, MAR-1, GBU-12\n- **A-1R/TA-1R** : version reconnaissance avec pod Condor\n- Part brésilienne : 29,7 % du programme AMX International (aile + pylônes + pré-production)',
  variants_en = E'- **A-1A** : single-seat FAB attacker (40 aircraft)\n- **A-1B** : two-seat trainer (16 aircraft)\n- **A-1M (AMX/M-AMX)** : 2013-2023 Embraer upgrade with Elta EL/M-2032 radar, full-screen cockpit, MAR-1, GBU-12\n- **A-1R/TA-1R** : reconnaissance version with Condor pod\n- Brazilian share: 29.7 % of the AMX International programme (wing + pylons + pre-production)'
WHERE name = 'AMX A-1 Brésilien';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme tri-national **AMX International** lancé en **1980** entre Aeritalia (Italie, 46,5 %), Aermacchi (Italie, 23,8 %) et **Embraer (Brésil, 29,7 %)** pour remplacer les F-104G italiens et les AT-26 brésiliens. Premier vol le **15 mai 1984** à Turin, premier vol de la version brésilienne en **1985**. Mise en service FAB en **1989**.\n\n## Carrière opérationnelle\n**56 appareils brésiliens produits** à São José dos Campos entre 1989 et 1999. Intégré à la doctrine **SIVAM** (système de surveillance amazonienne) pour la défense stratégique du bassin amazonien. Engagé lors d''exercices internationaux **CRUZEX** tous les deux ans avec les forces aériennes sud-américaines et l''OTAN.\n\n## Héritage\nProgramme **A-1M** (2013-2023) a modernisé 43 A-1 survivants à standard 4e génération. Retrait progressif prévu à partir de **2030** avec l''arrivée en puissance du **Gripen E/F**. L''AMX reste le seul chasseur-bombardier léger conçu en partie au Brésil.',
  description_en = E'## Genesis\nTri-national **AMX International** programme launched in **1980** between Aeritalia (Italy, 46.5 %), Aermacchi (Italy, 23.8 %) and **Embraer (Brazil, 29.7 %)** to replace Italian F-104Gs and Brazilian AT-26s. First flight on **15 May 1984** in Turin, first flight of the Brazilian variant in **1985**. FAB service entry in **1989**.\n\n## Operational career\n**56 Brazilian aircraft produced** at São José dos Campos between 1989 and 1999. Integrated into the **SIVAM** doctrine (Amazon surveillance system) for strategic defence of the Amazon basin. Deployed during international **CRUZEX** exercises every two years with South American air forces and NATO.\n\n## Legacy\nThe **A-1M** programme (2013-2023) upgraded 43 surviving A-1s to 4th-generation standard. Progressive retirement planned from **2030** with the build-up of the **Gripen E/F**. The AMX remains the only light attack fighter partly designed in Brazil.'
WHERE name = 'AMX A-1 Brésilien';
