-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'MiG-21', 'Mikoyan-Gourevitch MiG-21 Fishbed', 'Chasseur soviétique de 3e génération', 
    'https://i.postimg.cc/bwnsrntT/mig21.jpg', 
    'Le Mikoyan-Gourevitch MiG-21 Fishbed est un avion de chasse supersonique développé pour les forces aériennes soviétiques. Classé dans la 3e génération, il est connu pour sa simplicité, sa vitesse et sa maniabilité, servant principalement comme intercepteur et chasseur léger. Largement exporté, il a été un pilier des forces aériennes du Pacte de Varsovie et a participé à de nombreux conflits de la Guerre froide à nos jours.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1954-01-01', '1956-06-14', '1959-01-01', 
    2230.0, 1210.0, (SELECT id FROM manufacturer WHERE code = 'MIG'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Chasseur'), 
    'Actif', 5843.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM tech WHERE name = 'Réacteur Tumansky R-25')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM tech WHERE name = 'Radar RP-21')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM armement WHERE name = 'R-3S')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM armement WHERE name = 'S-5'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));