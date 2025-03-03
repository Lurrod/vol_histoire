-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'F-5 Freedom Fighter', 'Northrop F-5 Freedom Fighter', 'Chasseur léger américain de 3e génération', 
    'https://i.postimg.cc/nrryzvCc/f5-freedom-fighter.jpg', 
    'Le Northrop F-5 Freedom Fighter est un avion de chasse léger développé par Northrop pour l''US Air Force et ses alliés. Classé dans la 3e génération, il est conçu pour être économique, maniable et facile à entretenir, avec des capacités de supériorité aérienne et d''attaque au sol. Largement exporté, il a été utilisé dans de nombreux conflits, notamment pendant la Guerre du Vietnam.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1955-01-01', '1959-07-30', '1964-03-01', 
    1700.0, 2870.0, (SELECT id FROM manufacturer WHERE code = 'LM'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Chasseur'), 
    'Retiré', 4240.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM tech WHERE name = 'Canon M39'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM armement WHERE name = 'Canon M39')),
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM armement WHERE name = 'Hydra 70'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));