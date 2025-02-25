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
    'J-20',
    'Chengdu J-20 Mighty Dragon',
    'Chasseur furtif chinois de 5e génération',
    'https://i.postimg.cc/05B5kHTZ/j20.jpg',
    'Le Chengdu J-20 Mighty Dragon est un avion de chasse furtif de cinquième génération développé par la Chine pour rivaliser avec les F-22, F-35, et Su-57. Conçu par Chengdu Aerospace Corporation, il vise à assurer la supériorité aérienne et à pénétrer les défenses ennemies. Le programme a débuté dans les années 2000, avec un premier vol le 11 janvier 2011. Il est entré en service opérationnel avec l’Armée de l’air chinoise en mars 2017, avec environ 50 à 100 unités produites d’ici 2025.\n\nLe J-20 est équipé du radar Type 1475 AESA, d’un système EOTS-86, et de moteurs WS-10C (en attendant les WS-15 plus avancés). Sa furtivité repose sur une conception angulaire et des baies d’armes internes. Il utilise des missiles PL-15 et PL-10 pour le combat air-air, et des bombes LS-6 pour les frappes au sol. Bien qu’il n’ait pas été engagé dans des conflits, il est régulièrement déployé dans des exercices militaires près des frontières chinoises (mer de Chine méridionale, Taïwan). Sa furtivité et sa portée en font une menace stratégique pour les forces aériennes adverses.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2000-01-01',
    '2011-01-11',
    '2017-03-09',
    2100,
    6000,
    (SELECT id FROM manufacturer WHERE code = 'CAC'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    17000
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'J-20'), 
    id 
FROM tech 
WHERE name IN ('WS-10C', 'EOTS-86', 'Type 1475 Radar');

-- Armements
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'J-20'), 
    id 
FROM armement 
WHERE name IN ('PL-15', 'PL-10', 'PL-12', 'LS-6');

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'J-20'), 
    id 
FROM missions 
WHERE name IN (
    'Supériorité aérienne',
    'Interception',       
    'Frappe tactique',  
    'Reconnaissance stratégique',
    'Guerre électronique'
);