-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Avro Vulcan', 'Avro Vulcan B.2', 'Bombardier stratégique nucléaire britannique de 2e génération à aile delta', 
    'https://i.postimg.cc/gktk68TL/avro_vulcan.jpg', 
    'L''Avro Vulcan est un bombardier stratégique à aile delta développé pour la Royal Air Force dans le cadre de la force de dissuasion nucléaire britannique, les célèbres « V-Bombers ». Classé dans la 2e génération, il se distingue par sa spectaculaire voilure delta sans empennage, lui offrant une grande altitude opérationnelle et une maniabilité surprenante pour un bombardier de cette taille. Propulsé par quatre réacteurs Rolls-Royce Olympus, il était capable de pénétrer l''espace aérien soviétique à haute altitude pour délivrer des armes nucléaires. Avec l''évolution des défenses antiaériennes, son rôle a évolué vers la pénétration à basse altitude. Le Vulcan s''est illustré de manière spectaculaire lors de la guerre des Malouines en 1982 avec les raids « Black Buck », les missions de bombardement les plus longues de l''histoire à cette époque, frappant l''aérodrome de Port Stanley. Retiré en 1984, il reste l''un des avions militaires britanniques les plus emblématiques.', 
    (SELECT id FROM countries WHERE code = 'GBR'), '1947-01-01', '1952-08-30', '1957-05-20', 
    1038.0, 7400.0, (SELECT id FROM manufacturer WHERE code = 'BAE'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Retiré', 37144.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Radar H2S')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM armement WHERE name = 'WE.177')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM armement WHERE name = '1000 lb GP')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM armement WHERE name = 'AGM-45 Shrike'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));