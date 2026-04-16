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
    'F-35B Lightning II Anglais',
    'British F-35B Lightning II',
    'Lockheed Martin F-35B Lightning II (Royal Air Force / Royal Navy)',
    'Lockheed Martin F-35B Lightning II (Royal Air Force / Royal Navy)',
    'Avion furtif STOVL de 5e génération au service du Royaume-Uni',
    '5th-generation STOVL stealth aircraft in UK service',
    '/assets/airplanes/f35b-lightning-2-anglais.jpg',
    'Le F-35B Lightning II britannique est la variante à décollage court et atterrissage vertical (STOVL) du programme Joint Strike Fighter, exploitée conjointement par la Royal Air Force et la Royal Navy. Classé dans la 5e génération, il combine furtivité, fusion de capteurs avancée et capacités STOVL grâce à son réacteur Pratt & Whitney F135 et sa soufflante de sustentation Rolls-Royce LiftFan. Opérant depuis les porte-avions de classe Queen Elizabeth et les bases terrestres, il remplace le Harrier dans le rôle d''avion de combat embarqué britannique. Le Royaume-Uni est un partenaire industriel majeur du programme, avec environ 15% de la production confiée à des entreprises britanniques. Capable de missions air-air, air-sol et de reconnaissance, le F-35B constitue la pièce maîtresse de la puissance aérienne expéditionnaire britannique pour les décennies à venir.',
    'The British F-35B Lightning II is the short take-off and vertical landing (STOVL) variant of the Joint Strike Fighter program, jointly operated by the Royal Air Force and the Royal Navy. Classified as 5th generation, it combines stealth, advanced sensor fusion and STOVL capabilities thanks to its Pratt & Whitney F135 engine and Rolls-Royce LiftFan lift fan. Operating from Queen Elizabeth-class aircraft carriers and land bases, it replaces the Harrier in the British carrier-based combat aircraft role. The United Kingdom is a major industrial partner in the program, with approximately 15% of the work share.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1996-01-01',
    '2008-06-11',
    '2018-01-10',
    1975.0,
    1670.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    14651.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-81')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'ASRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'Paveway IV')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'Storm Shadow'));

-- Insertion des guerres
-- Pas de participation à des conflits majeurs répertoriés à ce jour pour la version britannique

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 15.6, wingspan = 10.7, height = 4.36, wing_area = 42.7,
  empty_weight = 14700, mtow = 27200, service_ceiling = 15240,
  combat_radius = 833, crew = 1, g_limit_pos = 7.0,
  engine_name = 'Pratt & Whitney F135-PW-600 (avec LiftFan)', engine_count = 1,
  engine_type = 'Turbofan STOVL avec postcombustion', engine_type_en = 'STOVL afterburning turbofan',
  thrust_dry = 128.1, thrust_wet = 191.3,
  production_start = 2006, production_end = NULL,
  stealth_level = 'elevee',
  nickname = 'Lightning II',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Lockheed_Martin_F-35_Lightning_II',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Lockheed_Martin_F-35_Lightning_II'
WHERE name = 'F-35B Lightning II Anglais';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 109000000, unit_cost_year = 2023,
  operators_count = 4,
  manufacturer_page = 'https://www.lockheedmartin.com/en-us/products/f-35.html'
WHERE name = 'F-35B Lightning II Anglais';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nVersion STOVL (Short Take-Off, Vertical Landing) du F-35, développée pour remplacer le Harrier britannique et l''AV-8B américain. Utilise un **LiftFan** Rolls-Royce et une tuyère orientable à 90°.\n\n## Carrière opérationnelle\nOpérée depuis les porte-avions britanniques de la classe **Queen Elizabeth** (HMS Queen Elizabeth, HMS Prince of Wales). Premier déploiement opérationnel en 2021 avec le squadron 617 « Dambusters ». Engagée au-dessus de la mer Rouge en 2024.\n\n## Héritage\nRenaissance de la Fleet Air Arm britannique après 10 ans sans chasseur embarqué (retrait du Harrier en 2010). Commandes totales : ~138 exemplaires prévus pour la RAF et la Royal Navy.',
  description_en = E'## Genesis\nSTOVL (Short Take-Off, Vertical Landing) variant of the F-35, developed to replace the British Harrier and the US AV-8B. Uses a Rolls-Royce **LiftFan** and a 90°-deflecting nozzle.\n\n## Operational career\nOperated from the UK **Queen Elizabeth**-class carriers (HMS Queen Elizabeth, HMS Prince of Wales). First operational deployment in 2021 with 617 "Dambusters" squadron. Used over the Red Sea in 2024.\n\n## Legacy\nRenaissance of the British Fleet Air Arm after 10 years without a carrier-borne fighter (Harrier retired 2010). Total planned orders: ~138 aircraft across the RAF and Royal Navy.'
WHERE name = 'F-35B Lightning II Anglais';
