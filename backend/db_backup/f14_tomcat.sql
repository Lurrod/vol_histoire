-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'F-14 Tomcat', 'Grumman F-14 Tomcat', 'Chasseur embarqué américain de 4e génération', 
    'https://i.postimg.cc/DwQSVLcd/f14-tomcat.jpg', 
    'Le Grumman F-14 Tomcat est un avion de chasse embarqué développé pour l''US Navy, célèbre pour ses ailes à géométrie variable et sa capacité à intercepter à longue portée. Classé dans la 4e génération, il a été conçu pour la supériorité aérienne et la défense des flottes, avec des capacités secondaires air-sol. Utilisé principalement pendant la Guerre froide, il reste une icône de l''aviation navale.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1968-01-01', '1970-12-21', '1974-09-22', 
    2485.0, 2965.0, (SELECT id FROM manufacturer WHERE code = 'LM'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Intercepteur'), 
    'Retiré', 19940.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM tech WHERE name = 'Radar AN/AWG-9')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM armement WHERE name = 'AIM-54 Phoenix')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM armement WHERE name = 'Mk 84'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), (SELECT id FROM missions WHERE name = 'Escorte'));