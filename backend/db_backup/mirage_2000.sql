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
    'Mirage 2000',
    'Dassault Mirage 2000',
    'Chasseur multirôle de 4ème génération',
    'Le Mirage 2000 est un avion de combat polyvalent français développé par Dassault Aviation. Entré en service en 1984, il a été exporté dans 9 pays et produit à 601 exemplaires. Doté d''une aile delta et de commandes de vol électriques, il reste opérationnel dans plusieurs armées de l''air.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1975-01-01',
    '1978-03-10',
    '1984-07-02',
    2340,
    1550,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    7500,
    'https://i.postimg.cc/s2TdnMyK/mirage2000.jpg'
);

INSERT INTO tech (name, description) VALUES
('RDM Radar', 'Radar Doppler multimode'),
('Syracuse IV', 'Système de guerre électronique'),
('Sagem ULISS 52', 'Système de navigation inertielle');

INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage 2000'), 
    id 
FROM tech 
WHERE name IN ('RDM Radar', 'Syracuse IV', 'Sagem ULISS 52');

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage 2000'), 
    id 
FROM armement 
WHERE name IN ('MICA EM', 'SCALP EG', '30M791');

INSERT INTO wars (name, date_start, date_end, description) VALUES
('Guerre du Golfe (1990-1991)', '1990-08-02', '1991-02-28', 'Opération Daguet'),
('Guerre du Kosovo', '1998-02-28', '1999-06-11', 'Opération Trident');

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage 2000'), 
    id 
FROM wars 
WHERE name IN ('Guerre du Golfe (1990-1991)', 'Guerre du Kosovo', 'Intervention en Libye');

INSERT INTO missions (name, description) VALUES
('Interception', 'Interception rapide de cibles aériennes'),
('Patrouille frontalière', 'Surveillance des frontières');

INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage 2000'), 
    id 
FROM missions 
WHERE name IN ('Interception', 'Patrouille frontalière', 'Supériorité aérienne');