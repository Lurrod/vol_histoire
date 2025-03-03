-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Super Étendard', 'Dassault Super Étendard', 'Chasseur naval français de 3e génération', 
    'https://i.postimg.cc/QCzwqh9m/super-etendard.jpg', 
    'Le Dassault Super Étendard est un avion de chasse embarqué développé par Dassault Aviation pour la Marine nationale française. Évolution de l''Étendard IV, il est classé dans la 3e génération et a été conçu principalement pour des missions antinavires et d''attaque au sol. Équipé pour opérer depuis des porte-avions, il est célèbre pour son rôle dans l''utilisation du missile Exocet.', 
    (SELECT id FROM countries WHERE code = 'FRA'), '1970-01-01', '1974-10-28', '1978-06-27', 
    1180.0, 1820.0, (SELECT id FROM manufacturer WHERE code = 'DAS'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Appui aérien'), 
    'Retiré', 6500.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM armement WHERE name = 'AM39 Exocet')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM armement WHERE name = 'AS-30L')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM armement WHERE name = 'Bombe lisse 400 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM wars WHERE name = 'Guerre du Liban')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Super Étendard'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));