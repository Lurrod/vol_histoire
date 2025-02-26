-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'F-16 Fighting Falcon', 'General Dynamics F-16 Fighting Falcon', 'Chasseur multirôle américain de 4e génération', 
    'https://i.postimg.cc/d0fvshX3/f16-fighting-falcon.jpg', 
    'Le General Dynamics F-16 Fighting Falcon est un avion de chasse multirôle emblématique de l''US Air Force. Classé dans la 4e génération, il est réputé pour sa maniabilité exceptionnelle grâce à son système fly-by-wire, son coût abordable et sa polyvalence dans les missions air-air et air-sol. Largement exporté, il a été utilisé dans de nombreux conflits à travers le monde.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1972-01-01', '1974-02-02', '1979-08-17', 
    2410.0, 4220.0, (SELECT id FROM manufacturer WHERE code = 'LM'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Actif', 8570.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-68')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM tech WHERE name = 'Siège incliné')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));