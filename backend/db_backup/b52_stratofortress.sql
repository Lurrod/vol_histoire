-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'B-52 Stratofortress', 'Boeing B-52 Stratofortress', 'Bombardier stratégique américain de 2e génération', 
    'https://i.postimg.cc/3RTpYBfm/b52-stratofortress.jpg', 
    'Le Boeing B-52 Stratofortress est un bombardier stratégique à longue portée développé pour l''US Air Force. Classé dans la 2e génération, il est conçu pour des missions de frappe stratégique et nucléaire, avec une capacité exceptionnelle de charge utile et de portée. En service depuis les années 1950, il a été modernisé à plusieurs reprises et reste actif, participant à presque tous les conflits majeurs américains depuis la Guerre froide.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1950-01-01', '1952-04-15', '1955-02-01', 
    957.0, 14800.0, (SELECT id FROM manufacturer WHERE code = 'BOE'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Actif', 83000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol automatique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM armement WHERE name = 'B61')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM armement WHERE name = 'B83')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM armement WHERE name = 'Mk 84')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM armement WHERE name = 'AGM-86 ALCM'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));