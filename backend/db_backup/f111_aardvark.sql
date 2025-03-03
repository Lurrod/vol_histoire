-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'F-111 Aardvark', 'General Dynamics F-111 Aardvark', 'Bombardier tactique américain de 3e génération', 
    'https://i.postimg.cc/cCPbL2pX/f111-aardvark.jpg', 
    'Le General Dynamics F-111 Aardvark est un bombardier tactique à géométrie variable développé pour l''US Air Force. Classé dans la 3e génération, il est conçu pour des missions de frappe stratégique et tactique à basse altitude, avec une capacité de pénétration avancée grâce à son radar de suivi de terrain. Utilisé principalement pendant la Guerre du Vietnam et la Guerre du Golfe, il est célèbre pour sa polyvalence et sa vitesse.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1963-01-01', '1964-12-21', '1967-10-18', 
    2655.0, 6700.0, (SELECT id FROM manufacturer WHERE code = 'LM'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Retiré', 20900.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM tech WHERE name = 'Radar de suivi de terrain')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion' )),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM armement WHERE name = 'AGM-69 SRAM')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM armement WHERE name = 'Mk 84')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM armement WHERE name = 'GBU-10 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM armement WHERE name = 'CBU-87'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));