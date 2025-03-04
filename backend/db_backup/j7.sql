-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Chengdu J-7', 'Chengdu J-7 Fishcan', 'Chasseur chinois de 3e génération', 
    'https://i.postimg.cc/G3YD9ZnY/j7.jpg', 
    'Le Chengdu J-7 Fishcan est une version chinoise sous licence et améliorée du MiG-21 soviétique, développée par Chengdu Aerospace Corporation pour l''Armée populaire de libération. Classé dans la 3e génération, ce chasseur supersonique est conçu pour la supériorité aérienne et l''interception, avec des capacités air-sol limitées. Largement exporté, il a été utilisé dans plusieurs conflits pendant et après la Guerre froide.', 
    (SELECT id FROM countries WHERE code = 'CHN'), '1961-01-01', '1966-01-17', '1967-04-01', 
    2230.0, 1700.0, (SELECT id FROM manufacturer WHERE code = 'CAC'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Chasseur'), 
    'Retiré', 5843.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM tech WHERE name = 'Réacteur WP-7')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM tech WHERE name = 'Radar Type 226'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM armement WHERE name = 'NR-30')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM armement WHERE name = 'PL-2')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM armement WHERE name = 'FAB-250'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));