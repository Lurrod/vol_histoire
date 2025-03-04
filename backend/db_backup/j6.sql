-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Shenyang J-6', 'Shenyang J-6 Farmer', 'Chasseur chinois de 2e génération', 
    'https://i.postimg.cc/2ypB2xhV/j6.jpg', 
    'Le Shenyang J-6 Farmer est une copie chinoise sous licence du MiG-19 soviétique, développée par Shenyang Aircraft Corporation pour l''Armée populaire de libération. Classé dans la 2e génération, il est le premier chasseur supersonique chinois, conçu pour la supériorité aérienne et des missions d''interception. Utilisé pendant la Guerre froide, il a été largement exporté à des pays alliés comme le Pakistan et la Corée du Nord.', 
    (SELECT id FROM countries WHERE code = 'CHN'), '1956-01-01', '1958-09-30', '1960-01-01', 
    1450.0, 1390.0, (SELECT id FROM manufacturer WHERE code = 'SAC'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Chasseur'), 
    'Retiré', 5770.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM tech WHERE name = 'Réacteur WP-6')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM armement WHERE name = 'NR-30')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM armement WHERE name = 'S-5'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));