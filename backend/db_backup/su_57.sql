-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Su-57', 'Sukhoi Su-57 Felon', 'Chasseur furtif russe de 5e génération', 
    'https://i.postimg.cc/NjWrKjZJ/su57.jpg', 
    'Le Sukhoi Su-57 Felon est un avion de chasse multirôle furtif développé par Sukhoi pour les forces aériennes russes. Classé dans la 5e génération, il est conçu pour la supériorité aérienne et les frappes au sol, avec une furtivité avancée, des capteurs intégrés et une supercroisière. Premier avion furtif russe opérationnel, il vise à concurrencer les chasseurs américains comme le F-22 et le F-35.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '2002-01-01', '2010-01-29', '2020-12-25', 
    2470.0, 3500.0, (SELECT id FROM manufacturer WHERE code = 'SUK'), 
    (SELECT id FROM generation WHERE generation = 5), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Actif', 18500.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM tech WHERE name = 'Radar N036')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM tech WHERE name = 'Moteurs à poussée vectorielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM armement WHERE name = 'R-77')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM armement WHERE name = 'Kh-59')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM armement WHERE name = 'KAB-500L'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Su-57'), (SELECT id FROM missions WHERE name = 'Interception'));