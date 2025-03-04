-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Mirage F1', 'Dassault Mirage F1', 'Chasseur multirôle français de 3e génération', 
    'https://i.postimg.cc/SKNCDgpz/miragef1.jpg', 
    'Le Dassault Mirage F1 est un avion de chasse multirôle développé par Dassault Aviation pour l''Armée de l''Air française. Successeur du Mirage III, il est classé dans la 3e génération avec une amélioration de la maniabilité à basse vitesse grâce à son aile en flèche. Utilisé pour la supériorité aérienne et les frappes au sol, il a été exporté et engagé dans plusieurs conflits.', 
    (SELECT id FROM countries WHERE code = 'FRA'), '1964-01-01', '1966-12-23', '1973-06-14', 
    2338.0, 3300.0, (SELECT id FROM manufacturer WHERE code = 'DAS'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Retiré', 7400.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM tech WHERE name = 'Radar Cyrano IV')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM armement WHERE name = 'DEFA 553')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM armement WHERE name = 'Matra R550 Magic')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM armement WHERE name = 'Matra Super 530F')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM armement WHERE name = 'AS-30')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Mirage F1'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));