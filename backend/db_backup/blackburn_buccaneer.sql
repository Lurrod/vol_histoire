-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Blackburn Buccaneer', 'Blackburn (Hawker Siddeley) Buccaneer', 'Bombardier embarqué britannique de 2e génération spécialisé dans l''attaque à basse altitude', 
    'https://i.postimg.cc/cJnHWCh9/blackburn_buccaneer.jpg', 
    'Le Blackburn Buccaneer est un avion d''attaque embarqué conçu pour la Royal Navy afin de mener des frappes antinavires à très basse altitude sous la couverture radar ennemie. Classé dans la 2e génération, il se distingue par son système de soufflage de couche limite sur les ailes et les gouvernes, lui conférant d''excellentes performances à basse vitesse indispensables aux opérations sur porte-avions. Propulsé par deux réacteurs Rolls-Royce Spey, il possède une soute à bombes rotative interne et peut emporter une charge offensive considérable. Après le retrait des porte-avions britanniques, le Buccaneer a été transféré à la RAF où il a servi comme bombardier tactique à pénétration basse altitude. Il s''est illustré pendant la guerre du Golfe en 1991 comme désignateur laser pour les Tornado, prouvant sa valeur jusqu''à sa retraite en 1994. L''Afrique du Sud l''a également employé au combat.', 
    (SELECT id FROM countries WHERE code = 'GBR'), '1955-01-01', '1958-04-30', '1962-07-17', 
    1040.0, 3700.0, (SELECT id FROM manufacturer WHERE code = 'BAE'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Retiré', 13608.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Spey')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Radar Blue Parrot')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'Martel AJ-168')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'Sea Eagle')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'WE.177')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'BL755')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = '1000 lb GP')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));