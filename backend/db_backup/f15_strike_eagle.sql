-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'F-15E Strike Eagle', 'McDonnell Douglas F-15E Strike Eagle', 'Chasseur-bombardier multirôle américain de 4e génération', 
    'https://i.postimg.cc/BvDMfhV7/f15-eagle.jpg', 
    'Le McDonnell Douglas F-15E Strike Eagle est une variante multirôle du F-15 Eagle, optimisée pour les missions de frappe au sol tout en conservant des capacités de supériorité aérienne. Classé dans la 4e génération, il est équipé de systèmes avancés pour les frappes de précision à longue portée et a été largement utilisé dans des conflits modernes par l''US Air Force.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1982-01-01', '1986-12-11', '1988-09-30', 
    2655.0, 3900.0, (SELECT id FROM manufacturer WHERE code = 'BOE'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Actif', 14300.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-63')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM tech WHERE name = 'Moteurs à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM armement WHERE name = 'GBU-10 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));