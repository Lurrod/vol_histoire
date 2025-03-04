-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Su-15', 'Sukhoi Su-15 Flagon', 'Intercepteur soviétique de 2e génération', 
    'https://i.postimg.cc/m2BsCFJj/su15.jpg', 
    'Le Sukhoi Su-15 Flagon est un avion intercepteur supersonique développé pour les forces aériennes soviétiques. Classé dans la 2e génération, il est conçu pour contrer les bombardiers à haute altitude et les avions espions pendant la Guerre froide, avec une capacité tous temps grâce à son radar. Utilisé principalement pour la défense aérienne, il a été impliqué dans des incidents célèbres comme l''interception du vol KAL 007.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1962-01-01', '1965-05-30', '1967-04-01', 
    2230.0, 1550.0, (SELECT id FROM manufacturer WHERE code = 'SUK'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Intercepteur'), 
    'Retiré', 10675.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM tech WHERE name = 'Radar RP-15')),
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM tech WHERE name = 'Moteurs Tumansky R-11')),
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM armement WHERE name = 'R-23R')),
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM armement WHERE name = 'R-23T'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Su-15'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));