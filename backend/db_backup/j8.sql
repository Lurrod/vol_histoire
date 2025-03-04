-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Shenyang J-8', 'Shenyang J-8 Finback', 'Intercepteur chinois de 3e génération', 
    'https://i.postimg.cc/8khFTMLm/j8.jpg', 
    'Le Shenyang J-8 Finback est un chasseur-intercepteur développé par Shenyang Aircraft Corporation pour l''Armée populaire de libération. Classé dans la 3e génération, il est conçu pour des missions d''interception à haute altitude et grande vitesse, évoluant à partir des bases du MiG-21 avec des améliorations chinoises. Utilisé pendant la Guerre froide, il a été modernisé dans des variantes comme le J-8II pour inclure des capacités multirôles.', 
    (SELECT id FROM countries WHERE code = 'CHN'), '1964-01-01', '1969-07-05', '1980-03-01', 
    2350.0, 2200.0, (SELECT id FROM manufacturer WHERE code = 'SAC'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Intercepteur'), 
    'Retiré', 9820.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'), (SELECT id FROM tech WHERE name = 'Réacteur WP-7')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'), (SELECT id FROM tech WHERE name = 'Radar Type 242'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'), (SELECT id FROM armement WHERE name = 'NR-30')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'), (SELECT id FROM armement WHERE name = 'PL-2')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'), (SELECT id FROM armement WHERE name = 'PL-5'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));