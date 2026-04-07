-- Insertion dans airplanes
INSERT INTO airplanes (
    name,
    name_en,
    complete_name,
    complete_name_en,
    little_description,
    little_description_en,
    image_url,
    description,
    description_en,
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
    status_en,
    weight
) VALUES (
    'Mirage III',
    'Mirage III',
    'Dassault Mirage III',
    'Dassault Mirage III',
    'Chasseur français de 3e génération',
    'French 3rd-generation fighter',
    'https://i.postimg.cc/cCFqSbZ2/mirage3.jpg',
    'Le Dassault Mirage III est un avion de chasse emblématique développé par Dassault Aviation pour l''Armée de l''Air française. Premier avion de combat européen à dépasser Mach 2, il est classé dans la 3e génération et a été conçu principalement pour l''interception et la supériorité aérienne. Avec son aile delta, il a été largement exporté et employé dans de nombreux conflits, notamment au Moyen-Orient.',
    'The Dassault Mirage III is an iconic fighter aircraft developed by Dassault Aviation for the French Air Force. The first European combat aircraft to exceed Mach 2, it is classified as 3rd generation and was designed primarily for interception and air superiority. With its delta wing, it was widely exported and employed in many conflicts, notably in the Middle East.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1953-01-01',
    '1956-11-17',
    '1961-07-12',
    2350.0,
    2400.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    NULL,
    7050.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM tech WHERE name = 'Radar Cyrano')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM armement WHERE name = 'Matra R530')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM armement WHERE name = 'Matra R550 Magic')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM armement WHERE name = 'Bombe lisse 400 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Mirage III'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));