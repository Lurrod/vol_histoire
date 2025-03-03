-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Su-27', 'Sukhoi Su-27 Flanker', 'Chasseur multirôle soviétique/russe de 4e génération', 
    'https://i.postimg.cc/W4rW55Jk/su27.jpg', 
    'Le Sukhoi Su-27 Flanker est un avion de chasse multirôle développé pour les forces aériennes soviétiques, puis russes. Classé dans la 4e génération, il est conçu pour la supériorité aérienne avec une maniabilité exceptionnelle et une capacité de frappe au sol secondaire. Rival direct des chasseurs occidentaux comme le F-15, il a été largement exporté et a servi de base à de nombreuses variantes modernes.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1974-01-01', '1977-05-20', '1982-06-20', 
    2500.0, 3530.0, (SELECT id FROM manufacturer WHERE code = 'SUK'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Chasseur'), 
    'Actif', 16400.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM tech WHERE name = 'Radar N001')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM armement WHERE name = 'R-27R')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM armement WHERE name = 'R-77')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM armement WHERE name = 'FAB-500'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));