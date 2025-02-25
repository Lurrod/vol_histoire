INSERT INTO airplanes (
    name, 
    complete_name, 
    little_description, 
    image_url, 
    description, 
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
    weight
) VALUES (
    'Rafale',
    'Dassault Rafale',
    'Chasseur multirôle omnirole 4.5ème génération',
    'https://i.postimg.cc/3NhD2ZCd/rafale.jpg',
    'Le Rafale de Dassault Aviation est un avion de combat multirôle qualifié d’omnirôle par son constructeur, développé pour la Marine nationale et l’Armée de l’air françaises. Livré à partir du 18 mai 2001, il est entré en service en 2002 dans la Marine. Il équipe également les forces aériennes égyptiennes, qataris, indiennes, grecques et croates, et a été commandé par les Émirats arabes unis, l’Indonésie et la Serbie.\n\nÀ la fin des années 1970, les forces armées françaises ont exprimé le besoin d’un nouvel avion polyvalent. Initialement envisagé en collaboration avec plusieurs pays européens, la France s’est désolidarisée en 1985 pour répondre à ses besoins spécifiques, notamment l’opération depuis un porte-avions. Le démonstrateur Rafale A a volé le 4 juillet 1986, et le programme a été lancé en 1988. Le Rafale C (monoplace) a volé le 19 mai 1991, le Rafale M (marine) le 12 décembre 1991, et le Rafale B (biplace) le 30 avril 1993. Le coût total du programme s’élève à 46,4 milliards d’euros.\n\nLe Rafale est un avion à aile delta avec plans canard, équipé de commandes de vol électriques, de furtivité passive et active, d’un radar RBE2-AA AESA, et de moteurs Snecma M88. Il utilise des missiles air-air (MICA, Meteor), un canon de 30 mm, des bombes guidées (GBU-12), des missiles de croisière (SCALP EG), des missiles antinavires (Exocet), et le missile nucléaire ASMP-A pour des missions stratégiques.\n\nLe Rafale a participé à des missions de bombardement en Afghanistan, au Mali (Opération Serval), en Irak et Syrie (Opération Chammal), et en Libye (Intervention 2011). À l’export, il a généré 48,7 milliards d’euros de contrats (Égypte, Qatar, Inde, Grèce, Croatie, Émirats, Indonésie).',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1983-01-01',
    '1986-07-04',
    '2001-05-18',
    1912,
    3700,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    10000
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Rafale'), 
    id 
FROM tech 
WHERE name IN ('SPECTRA', 'OSF', 'RBE2-AA Radar');

-- Armements
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Rafale'), 
    id 
FROM armement 
WHERE name IN ('MICA IR', 'MICA EM', 'Meteor', 'SCALP EG', 'AM39 Exocet', 'GBU-12 Paveway II', '30M791');

-- Guerres
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Rafale'), 
    id 
FROM wars 
WHERE name IN ('Intervention en Libye', 'Opération Serval', 'Opération Chammal', 'Guerre d’Afghanistan');

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Rafale'), 
    id 
FROM missions 
WHERE name IN (
    'Supériorité aérienne', 
    'Frappe stratégique', 
    'Frappe tactique',  
    'Dissuasion nucléaire'
);