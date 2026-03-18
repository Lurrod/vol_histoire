-- Insertion du nouveau constructeur
INSERT INTO manufacturer (name, country_id, code) VALUES
('Hawker Siddeley', (SELECT id FROM countries WHERE code = 'GBR'), 'HS');

-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Hawker Siddeley Harrier', 'Hawker Siddeley Harrier GR.1/GR.3', 'Avion d''attaque VTOL britannique de 3e génération', 
    'https://i.postimg.cc/nz8Dktyv/hawker-siddeley-harrier.jpg', 
    'Le Hawker Siddeley Harrier est le premier avion de combat à décollage et atterrissage verticaux (VTOL) opérationnel au monde. Développé à partir du prototype Hawker P.1127, il utilise un unique réacteur Rolls-Royce Pegasus à quatre tuyères orientables permettant de diriger la poussée du vol vertical au vol horizontal. Entré en service dans la RAF en 1969, le Harrier a révolutionné les opérations aériennes tactiques en permettant de se passer de pistes conventionnelles, opérant depuis des clairières, des routes ou des navires. Il s''est illustré de manière spectaculaire lors de la guerre des Malouines en 1982, où les Sea Harrier de la Royal Navy ont dominé l''aviation argentine. Exporté vers les États-Unis (AV-8A), l''Espagne et l''Inde, il a ouvert la voie au Harrier II et au F-35B. Le Harrier reste un jalon majeur de l''histoire de l''aviation militaire.', 
    (SELECT id FROM countries WHERE code = 'GBR'), '1957-01-01', '1967-08-31', '1969-04-01', 
    1176.0, 3300.0, (SELECT id FROM manufacturer WHERE code = 'HS'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Appui aérien'), 
    'Retiré', 5530.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM tech WHERE name = 'Système de navigation attaque à basse altitude')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM armement WHERE name = 'BL755')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM armement WHERE name = 'Mk 82'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));