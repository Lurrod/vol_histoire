-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Jaguar', 'SEPECAT Jaguar', 'Chasseur-bombardier franco-britannique de 3e génération', 
    'https://i.postimg.cc/ZR4ZTB8C/jaguar.jpg', 
    'Le SEPECAT Jaguar est un avion de chasse-bombardier développé conjointement par la France et le Royaume-Uni (SEPECAT). Classé dans la 3e génération, il a été conçu pour des missions d''attaque au sol à basse altitude et d''appui aérien rapproché, avec des capacités secondaires de supériorité aérienne. Utilisé par l''Armée de l''Air française et la Royal Air Force, il a servi dans plusieurs conflits avant d’être retiré.', 
    (SELECT id FROM countries WHERE code = 'FRA'), '1965-01-01', '1968-09-08', '1973-06-01', 
    1700.0, 3524.0, (SELECT id FROM manufacturer WHERE code = 'DAS'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Appui aérien'), 
    'Retiré', 7700.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM tech WHERE name = 'Système de navigation attaque à basse altitude')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM tech WHERE name = 'Pod désignateur laser')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM armement WHERE name = 'Matra R550 Magic')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM armement WHERE name = 'AS-30L')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM armement WHERE name = 'BL755')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Jaguar'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));