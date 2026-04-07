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
    'Su-24',
    'Su-24',
    'Sukhoi Su-24 Fencer',
    'Sukhoi Su-24 Fencer',
    'Chasseur-bombardier soviétique/russe de 3e génération',
    'Soviet/Russian 3rd-generation fighter-bomber',
    'https://i.postimg.cc/QMWPRXvV/su24.jpg',
    'Le Sukhoi Su-24 Fencer est un chasseur-bombardier à géométrie variable développé pour les forces aériennes soviétiques, puis russes. Classé dans la 3e génération, il est conçu pour des missions de frappe tactique et stratégique à basse altitude, avec une capacité tous temps grâce à son radar de suivi de terrain. Utilisé dans de nombreux conflits, il reste un pilier des opérations air-sol russes.',
    'The Sukhoi Su-24 Fencer is a variable-geometry fighter-bomber developed for the Soviet and later Russian air forces. Classified as 3rd generation, it is designed for tactical and strategic strike missions at low altitude, with all-weather capability thanks to its terrain-following radar. Used in many conflicts, it remains a pillar of Russian air-to-ground operations.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1965-01-01',
    '1970-01-17',
    '1974-02-01',
    2320.0,
    2775.0,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Actif',
    'Active',
    22320.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM tech WHERE name = 'Radar Puma')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM armement WHERE name = 'GSh-6-23')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM armement WHERE name = 'Kh-25ML')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM armement WHERE name = 'Kh-29L')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM armement WHERE name = 'S-8'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'Su-24'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));