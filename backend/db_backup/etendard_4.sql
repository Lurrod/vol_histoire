-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Étendard IV', 'Dassault Étendard IV', 'Chasseur naval français de 2e génération', 
    'https://i.postimg.cc/pdJq4nP1/etendard4.jpg', 
    'Le Dassault Étendard IV est un avion de chasse embarqué développé par Dassault Aviation pour la Marine nationale française. Classé dans la 2e génération, il a été conçu pour des missions d''attaque au sol et de reconnaissance depuis des porte-avions. Premier avion naval français de série, il a servi de base au développement du Super Étendard.', 
    (SELECT id FROM countries WHERE code = 'FRA'), '1954-01-01', '1958-05-21', '1962-07-01', 
    1099.0, 1700.0, (SELECT id FROM manufacturer WHERE code = 'DAS'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Appui aérien'), 
    'Retiré', 6100.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Étendard IV'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Étendard IV'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Étendard IV'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Étendard IV'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'Étendard IV'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Étendard IV'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Étendard IV'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Étendard IV'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Étendard IV'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Étendard IV'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));