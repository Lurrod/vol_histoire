INSERT INTO airplanes (
    name, 
    complete_name, 
    little_description, 
    description, 
    country_id,
    date_concept, 
    date_first_fly, 
    date_operationel, 
    max_speed, 
    max_range, 
    id_manufacturer,
    id_generation, 
    type, 
    status, 
    weight,
    image_url
) VALUES (
    'Mirage F1',
    'Dassault Mirage F1',
    'Chasseur-intercepteur de 3ème génération',
    'Le Mirage F1 est un avion de combat multirôle français développé dans les années 1960 pour remplacer le Mirage III. Entré en service en 1973, il a été exporté dans 14 pays et produit à 720 exemplaires. Particulièrement efficace dans les missions d''interception et d''attaque au sol, il a été progressivement remplacé par le Mirage 2000 mais reste en service dans certains pays.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1964-01-01',
    '1966-12-23',
    '1973-03-14',
    2335,
    3300,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré du service en France (2014)',
    7400,
    'https://i.postimg.cc/SKNCDgpz/miragef1.jpg'
);

INSERT INTO tech (name, description) VALUES
('Cyrano IV Radar', 'Radar monopulse de interception'),
('SAGEM ULISS 43', 'Système de navigation inertielle'),
('Barem ECM', 'Système de contre-mesures électroniques');

INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage F1'), 
    id 
FROM tech 
WHERE name IN ('Cyrano IV Radar', 'SAGEM ULISS 43', 'Barem ECM');

INSERT INTO armement (name, description) VALUES
('Matra R550 Magic', 'Missile air-air courte portée (1975)'),
('Bombe Belouga', 'Bombe à sous-munitions (1980)'),
('Canon DEFA 553', 'Canon de 30 mm (250 coups)');

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage F1'), 
    id 
FROM armement 
WHERE name IN ('Matra R550 Magic', 'Bombe Belouga', 'Canon DEFA 553', 'AM39 Exocet');

INSERT INTO wars (name, date_start, date_end, description) VALUES
('Guerre Iran-Irak', '1980-09-22', '1988-08-20', 'Utilisation intensive par l''Irak'),
('Guerre du Désert', '1991-01-17', '1991-02-28', 'Opération Tempête du désert');

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage F1'), 
    id 
FROM wars 
WHERE name IN ('Guerre Iran-Irak', 'Guerre du Désert', 'Guerre du Golfe');

INSERT INTO missions (name, description) VALUES
('Interception stratégique', 'Protection de l''espace aérien national'),
('Appui-feu tactique', 'Soutien des troupes au sol');

INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage F1'), 
    id 
FROM missions 
WHERE name IN ('Interception stratégique', 'Appui-feu tactique', 'Reconnaissance armée');