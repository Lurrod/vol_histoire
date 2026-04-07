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
    'https://i.postimg.cc/43N5FC1b/f35b-lightning-2-anglais.jpg',
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