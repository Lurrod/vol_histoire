-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Shenyang J-5', 'Shenyang J-5 Fresco', 'Chasseur chinois de 2e génération', 
    'https://i.postimg.cc/tR15kSQC/j5.jpg', 
    'Le Shenyang J-5 Fresco est une copie chinoise sous licence du MiG-17 soviétique, développée par Shenyang Aircraft Corporation pour l''Armée populaire de libération. Classé dans la 2e génération, il est conçu comme un chasseur-intercepteur subsonique avec des capacités air-air et air-sol limitées. Utilisé principalement pendant la Guerre froide, il a été exporté à plusieurs pays alliés de la Chine.', 
    (SELECT id FROM countries WHERE code = 'CHN'), '1954-01-01', '1956-07-19', '1956-09-01', 
    1145.0, 1420.0, (SELECT id FROM manufacturer WHERE code = 'SAC'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Chasseur'), 
    'Retiré', 3930.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'), (SELECT id FROM tech WHERE name = 'Réacteur Klimov VK-1')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'), (SELECT id FROM armement WHERE name = 'Canon NR-23')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'), (SELECT id FROM armement WHERE name = 'FAB-250'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));