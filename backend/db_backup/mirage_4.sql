-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Mirage IV', 'Dassault Mirage IV', 'Bombardier stratégique français de 3e génération', 
    'https://i.postimg.cc/cC5NMFVn/mirage4.jpg', 
    'Le Dassault Mirage IV est un bombardier stratégique supersonique développé par Dassault Aviation pour l''Armée de l''Air française. Classé dans la 3e génération, il a été conçu pour la dissuasion nucléaire avec des capacités de pénétration à basse altitude. Utilisé comme vecteur principal de la force de frappe nucléaire française pendant la Guerre froide, il a été adapté plus tard pour des missions de reconnaissance.', 
    (SELECT id FROM countries WHERE code = 'FRA'), '1956-01-01', '1959-06-17', '1964-10-01', 
    2340.0, 4000.0, (SELECT id FROM manufacturer WHERE code = 'DAS'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Retiré', 14450.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol automatique')),
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM tech WHERE name = 'Soute à armement pressurisée')),
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM armement WHERE name = 'AN-11')),
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM armement WHERE name = 'AN-22')),
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM armement WHERE name = 'ASMP')),
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM armement WHERE name = 'ASMP-A'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Mirage IV'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));