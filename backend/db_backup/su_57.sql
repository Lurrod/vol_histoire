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
    'Su-57',
    'Sukhoi Su-57 Felon',
    'Chasseur furtif russe de 5e génération',
    'https://i.postimg.cc/NjWrKjZJ/su57.jpg',
    'Le Sukhoi Su-57 (nom de code OTAN : Felon) est un avion de chasse furtif de cinquième génération développé par la Russie pour rivaliser avec des appareils comme le F-22 et le F-35. Conçu dans le cadre du programme PAK FA (Perspektivny Aviatsionny Kompleks Frontovoy Aviatsii), il vise à assurer la supériorité aérienne et à effectuer des frappes au sol. Le développement a débuté en 2002, avec un premier vol du prototype T-50 le 29 janvier 2010. Il est entré en service opérationnel limité avec l’armée de l’air russe en décembre 2020, bien que sa production reste modeste (environ 20 unités livrées d’ici 2025).\n\nLe Su-57 est équipé du radar N036 Byelka AESA, d’un système IRST 101KS-V, et de moteurs Izdeliye 30 (remplaçant les AL-41F1 initiaux) permettant la supercroisière. Sa furtivité repose sur une conception à faible signature radar et des baies d’armes internes. Il peut emporter des missiles R-77 et R-73 pour le combat air-air, des missiles Kh-59MK2 pour les frappes au sol, et un canon GSh-30-1 de 30 mm. Le Su-57 a été testé en combat réel lors de l’intervention russe en Syrie en 2018, bien que son déploiement reste limité. Contrairement aux chasseurs américains, il est proposé à l’export (Inde, Algérie en discussion).',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '2002-01-01',
    '2010-01-29',
    '2020-12-25',
    2600,
    3500,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    18500
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Su-57'), 
    id 
FROM tech 
WHERE name IN ('101KS-V', 'Izdeliye 30', 'N036 Byelka');

-- Armements
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Su-57'), 
    id 
FROM armement 
WHERE name IN ('R-77', 'R-73', 'Kh-59MK2', 'KAB-500', '30mm GSh-30-1');

-- Guerres
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Su-57'), 
    id 
FROM wars 
WHERE name = 'Intervention russe en Syrie';

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Su-57'), 
    id 
FROM missions 
WHERE name IN (
    'Supériorité aérienne',      
    'Frappe tactique',             
    'Reconnaissance stratégique',    
    'Interception',                
    'Guerre électronique'       
);