-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'F-4 Phantom II', 'McDonnell Douglas F-4 Phantom II', 'Chasseur-bombardier multirôle américain de 3e génération', 
    'https://i.postimg.cc/0ySqDdZz/f4-phantom-2.jpg', 
    'Le McDonnell Douglas F-4 Phantom II est un avion de chasse-bombardier multirôle emblématique, développé pour l''US Navy et l''US Air Force. Classé dans la 3e génération, il est connu pour sa polyvalence, sa vitesse et sa robustesse, servant dans des rôles d''interception, de supériorité aérienne et d''attaque au sol. Largement exporté, il a été un pilier des forces aériennes occidentales pendant la Guerre froide et au-delà.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1955-01-01', '1958-05-27', '1960-12-30', 
    2370.0, 2600.0, (SELECT id FROM manufacturer WHERE code = 'BOE'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Retiré', 12700.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM tech WHERE name = 'Radar AN/APQ-120')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM armement WHERE name = 'Mk 84'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));