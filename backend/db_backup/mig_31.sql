-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'MiG-31', 'Mikoyan-Gourevitch MiG-31 Foxhound', 'Intercepteur soviétique/russe de 4e génération', 
    'https://i.postimg.cc/tJP4JQ1g/mig31.jpg', 
    'Le Mikoyan-Gourevitch MiG-31 Foxhound est un avion intercepteur supersonique développé pour les forces aériennes soviétiques, puis russes. Classé dans la 4e génération, il est conçu pour intercepter des cibles à haute altitude et grande vitesse, comme les bombardiers et missiles de croisière, avec son radar avancé Zaslon et ses missiles à longue portée. Toujours en service, il demeure un élément clé de la défense aérienne russe.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1972-01-01', '1975-09-16', '1981-05-06', 
    3000.0, 3000.0, (SELECT id FROM manufacturer WHERE code = 'MIG'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Intercepteur'), 
    'Actif', 21825.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM tech WHERE name = 'Radar Zaslon')),
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM tech WHERE name = 'Moteurs D-30F6')),
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM armement WHERE name = 'GSh-6-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM armement WHERE name = 'R-33')),
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM armement WHERE name = 'R-37')),
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM armement WHERE name = 'R-60'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'MiG-31'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));