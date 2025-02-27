-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'SR-71 Blackbird', 'Lockheed SR-71 Blackbird', 'Avion de reconnaissance stratégique américain de 3e génération', 
    'https://i.postimg.cc/yd4hWBxJ/sr71-blackbird.jpg', 
    'Le Lockheed SR-71 Blackbird est un avion de reconnaissance stratégique à longue portée et haute altitude, développé pour l''US Air Force. Classé dans la 3e génération, il est célèbre pour sa vitesse exceptionnelle (plus de Mach 3) et son design furtif précoce, conçu pour échapper aux défenses ennemies. Utilisé pendant la Guerre froide, il a établi des records de vitesse et d''altitude inégalés.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1960-01-01', '1964-12-22', '1966-01-01', 
    3529.0, 5400.0, (SELECT id FROM manufacturer WHERE code = 'LM'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Reconnaissance'), 
    'Retiré', 30600.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'), (SELECT id FROM tech WHERE name = 'Conception aérodynamique pour haute altitude')),
((SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'), (SELECT id FROM tech WHERE name = 'Matériaux résistants à la chaleur')),
((SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'), (SELECT id FROM tech WHERE name = 'Conception furtive'));

-- Insertion des armements
-- Le SR-71 n'était pas armé, donc pas d'insertion dans airplane_armement
-- Il était équipé de capteurs de reconnaissance (caméras, radars, etc.), mais ce ne sont pas des "armements" dans votre base.

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));