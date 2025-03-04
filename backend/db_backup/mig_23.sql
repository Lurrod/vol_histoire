-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'MiG-23', 'Mikoyan-Gourevitch MiG-23 Flogger', 'Chasseur multirôle soviétique de 3e génération', 
    'https://i.postimg.cc/cC6JStWf/mig23.jpg', 
    'Le Mikoyan-Gourevitch MiG-23 Flogger est un avion de chasse multirôle à géométrie variable développé pour les forces aériennes soviétiques. Classé dans la 3e génération, il est conçu pour la supériorité aérienne et les frappes au sol, avec une capacité d''adaptation grâce à ses ailes ajustables. Largement exporté, il a été utilisé dans de nombreux conflits de la Guerre froide et au-delà.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1964-01-01', '1967-06-10', '1970-01-01', 
    2500.0, 1900.0, (SELECT id FROM manufacturer WHERE code = 'MIG'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Retiré', 11780.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM tech WHERE name = 'Radar RP-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM armement WHERE name = 'R-23R')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM armement WHERE name = 'Kh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM armement WHERE name = 'FAB-500'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM wars WHERE name = 'Guerre du Liban')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));