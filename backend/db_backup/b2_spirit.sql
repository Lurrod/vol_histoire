-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'B-2 Spirit', 'Northrop Grumman B-2 Spirit', 'Bombardier furtif américain de 5e génération', 
    'https://i.postimg.cc/ZKhQXtL5/b2-spirit.jpg', 
    'Le Northrop Grumman B-2 Spirit est un bombardier stratégique furtif développé pour l''US Air Force. Classé dans la 5e génération, il est conçu pour des missions de pénétration furtive à haute altitude, capable de transporter des armes nucléaires et conventionnelles. Surnommé l''avion furtif par excellence, il a été utilisé dans des conflits modernes pour des frappes stratégiques de précision.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1979-01-01', '1989-07-17', '1997-04-01', 
    1010.0, 11100.0, (SELECT id FROM manufacturer WHERE code = 'LM'), 
    (SELECT id FROM generation WHERE generation = 5), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Actif', 71600.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM armement WHERE name = 'B61')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM armement WHERE name = 'B83')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM armement WHERE name = 'Mk 84')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));