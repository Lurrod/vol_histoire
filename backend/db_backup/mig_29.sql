-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'MiG-29', 'Mikoyan MiG-29 Fulcrum', 'Chasseur multirôle soviétique/russe de 4e génération', 
    'https://i.postimg.cc/44VZGN14/mig29.jpg', 
    'Le Mikoyan MiG-29 Fulcrum est un avion de chasse multirôle développé par le bureau MiG pour les forces aériennes soviétiques, puis russes. Classé dans la 4e génération, il est conçu pour la supériorité aérienne et les combats rapprochés, avec une grande maniabilité et une robustesse exceptionnelle. Largement exporté, il a été utilisé dans de nombreux conflits par diverses nations.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1974-01-01', '1977-10-06', '1983-07-01', 
    2450.0, 1430.0, (SELECT id FROM manufacturer WHERE code = 'MIG'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Actif', 11000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM tech WHERE name = 'Radar N019')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM armement WHERE name = 'R-27R')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM armement WHERE name = 'FAB-500'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'MiG-29'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));