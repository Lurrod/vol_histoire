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
    'Panavia Tornado',
    'Panavia Tornado',
    'Panavia Tornado',
    'Panavia Tornado',
    'Avion multirôle européen de 4e génération à géométrie variable',
    'European 4th-generation variable-geometry multirole aircraft',
    'https://i.postimg.cc/xTdcLCXw/tornado.jpg',
    'Le Panavia Tornado est un avion de combat multirôle développé conjointement par le Royaume-Uni, l''Allemagne de l''Ouest et l''Italie dans le cadre du consortium Panavia Aircraft GmbH. Classé dans la 4e génération, il se distingue par ses ailes à géométrie variable et son radar de suivi de terrain, lui permettant des pénétrations à très basse altitude et grande vitesse. Décliné en trois variantes principales — IDS (interdiction/frappe), ECR (suppression des défenses aériennes) et ADV (défense aérienne) —, il a été un pilier des forces aériennes européennes et de l''OTAN pendant plus de quatre décennies, participant à de nombreux conflits depuis la Guerre du Golfe.',
    'The Panavia Tornado is a multirole combat aircraft jointly developed by the United Kingdom, West Germany and Italy as part of the Panavia Aircraft GmbH consortium. Classified as 4th generation, it is distinguished by its variable-geometry wings and its terrain-following radar, allowing it to penetrate at very low altitude and high speed. Declined in three main variants — IDS (interdiction/strike), ECR (suppression of enemy air defenses) and ADV (air defense) —, it was a pillar of European and NATO air forces for more than four decades, participating in numerous conflicts since the Gulf War.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1968-07-01',
    '1974-08-14',
    '1979-07-06',
    2337.0,
    3890.0,
    (SELECT id FROM manufacturer WHERE code = 'BAE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    NULL,
    13890.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM tech WHERE name = 'Radar de suivi de terrain')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'Storm Shadow')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'Brimstone')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'Paveway IV')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'BL755'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));