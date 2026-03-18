-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'BAE Sea Harrier', 'British Aerospace Sea Harrier', 'Chasseur embarqué VTOL britannique de 3e génération', 
    'https://i.postimg.cc/R0TBP78X/sea-harrier.jpg', 
    'Le British Aerospace Sea Harrier est la version navalisée du Harrier, développée pour la Royal Navy afin d''opérer depuis des porte-aéronefs légers de classe Invincible grâce à son décollage court et atterrissage vertical (STOVL). Classé dans la 3e génération, il combine la poussée vectorielle du réacteur Rolls-Royce Pegasus avec un radar Blue Fox (puis Blue Vixen sur la version FA2) et des missiles air-air pour la défense aérienne de la flotte. Le Sea Harrier s''est illustré de manière décisive pendant la guerre des Malouines en 1982, où il a remporté 20 victoires aériennes sans aucune perte en combat aérien, un bilan exceptionnel qui a démontré la viabilité du concept VTOL en opérations navales. Il a ensuite servi dans les Balkans avant d''être retiré en 2006, remplacé par le Harrier GR.9 puis le F-35B Lightning II.', 
    (SELECT id FROM countries WHERE code = 'GBR'), '1975-01-01', '1978-08-20', '1980-04-18', 
    1185.0, 3600.0, (SELECT id FROM manufacturer WHERE code = 'BAE'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Chasseur'), 
    'Retiré', 6374.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM tech WHERE name = 'Radar Blue Fox')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM armement WHERE name = 'Sea Eagle')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM armement WHERE name = 'BL755'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));