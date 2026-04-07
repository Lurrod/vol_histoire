-- Insertion des nouveaux armements spécifiques au J-20
INSERT INTO armement (name, description) VALUES
('PL-10', 'Missile air-air courte portée, guidage infrarouge à imagerie, 20 km'),
('PL-15', 'Missile air-air longue portée, guidage radar actif, 200+ km');

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
    'Chengdu J-20',
    'Chengdu J-20',
    'Chengdu J-20 Mighty Dragon',
    'Chengdu J-20 Mighty Dragon',
    'Chasseur furtif chinois de 5e génération',
    'Chinese 5th-generation stealth fighter',
    'https://i.postimg.cc/9XpWxpGK/j20.jpg',
    'Le Chengdu J-20 Mighty Dragon est le premier avion de combat furtif de 5e génération développé par la Chine. Conçu par Chengdu Aerospace Corporation, il a effectué son premier vol en 2011 et est entré en service actif en 2017. Le J-20 combine une conception furtive avancée, une configuration delta-canard, des capacités de supercroisière et une fusion de capteurs sophistiquée. Destiné à la supériorité aérienne et à l''interception à longue portée, il est conçu pour rivaliser avec les chasseurs de 5e génération occidentaux comme le F-22 Raptor et le F-35 Lightning II. Équipé de missiles à très longue portée, il représente un bond technologique majeur pour l''aviation militaire chinoise.',
    'The Chengdu J-20 Mighty Dragon is the first 5th-generation stealth combat aircraft developed by China. Designed by Chengdu Aerospace Corporation, it made its first flight in 2011 and entered active service in 2017. The J-20 combines advanced stealth design, a delta-canard configuration, supercruise capabilities and sophisticated sensor fusion. Intended for air superiority and long-range interception, it is designed to compete with Western 5th-generation fighters such as the F-22 Raptor and the F-35 Lightning II. Equipped with very long-range missiles, it represents a major technological leap for Chinese military aviation.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '1997-01-01',
    '2011-01-11',
    '2017-03-09',
    2100.0,
    2000.0,
    (SELECT id FROM manufacturer WHERE code = 'CAC'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Actif',
    'Active',
    19390.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM tech WHERE name = 'Aile delta-canard')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM tech WHERE name = 'Réacteur WS-10')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM armement WHERE name = 'PL-10')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM armement WHERE name = 'PL-12')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM armement WHERE name = 'PL-15')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM armement WHERE name = 'LS-6'));

-- Insertion des guerres
-- Le J-20 n'a pas été engagé dans des conflits majeurs à ce jour, donc pas d'entrée dans airplane_wars

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-20'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));