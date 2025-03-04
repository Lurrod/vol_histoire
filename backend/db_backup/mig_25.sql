-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'MiG-25', 'Mikoyan-Gourevitch MiG-25 Foxbat', 'Intercepteur soviétique de 3e génération', 
    'https://i.postimg.cc/ZYgbNRZD/mig25.jpg', 
    'Le Mikoyan-Gourevitch MiG-25 Foxbat est un avion intercepteur et de reconnaissance développé pour les forces aériennes soviétiques. Classé dans la 3e génération, il est conçu pour contrer les bombardiers supersoniques à haute altitude, atteignant des vitesses supérieures à Mach 3 grâce à sa structure en acier inoxydable. Utilisé pendant la Guerre froide, il a également servi dans des conflits au Moyen-Orient.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1961-01-01', '1964-03-06', '1970-07-01', 
    3400.0, 1730.0, (SELECT id FROM manufacturer WHERE code = 'MIG'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Intercepteur'), 
    'Retiré', 20000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM tech WHERE name = 'Conception en acier inoxydable')),
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM tech WHERE name = 'Radar RP-25')),
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM tech WHERE name = 'Moteurs Tumansky R-15')),
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM armement WHERE name = 'R-40R')),
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM armement WHERE name = 'R-40T')),
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM armement WHERE name = 'R-60'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'MiG-25'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne'));