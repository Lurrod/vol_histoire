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
    'Su-30',
    'Su-30',
    'Sukhoi Su-30 Flanker-C',
    'Sukhoi Su-30 Flanker-C',
    'Chasseur multirôle russe de 4e génération avancée',
    'Advanced Russian 4th-generation multirole fighter',
    'https://i.postimg.cc/m2DmvLHR/su30.jpg',
    'Le Sukhoi Su-30 Flanker-C est un chasseur multirôle biplace dérivé du Su-27, développé pour les forces aériennes russes. Classé dans la 4e génération avancée (souvent appelée 4++), il excelle dans la supériorité aérienne et les frappes au sol grâce à sa maniabilité, son radar avancé et sa capacité de ravitaillement en vol. Largement exporté, il est utilisé dans des conflits modernes et est un pilier des forces aériennes russes.',
    'The Sukhoi Su-30 Flanker-C is a twin-seat multirole fighter derived from the Su-27, developed for the Russian air forces. Classified as advanced 4th generation (often called 4++), it excels in air superiority and ground strikes thanks to its maneuverability, advanced radar and aerial refueling capability. Widely exported, it is used in modern conflicts and is a pillar of the Russian air forces.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1986-01-01',
    '1989-12-31',
    '1992-04-01',
    2120.0,
    3000.0,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    17700.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM tech WHERE name = 'Radar N011M Bars')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM armement WHERE name = 'R-27R')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM armement WHERE name = 'R-77')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM armement WHERE name = 'Kh-29L'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Su-30'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));