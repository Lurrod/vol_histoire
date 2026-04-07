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
    'Su-17',
    'Su-17',
    'Sukhoi Su-17 Fitter',
    'Sukhoi Su-17 Fitter',
    'Chasseur-bombardier soviétique de 3e génération',
    'Soviet 3rd-generation fighter-bomber',
    'https://i.postimg.cc/3rCM8xNv/su17.jpg',
    'Le Sukhoi Su-17 Fitter est un chasseur-bombardier à géométrie variable développé pour les forces aériennes soviétiques. Classé dans la 3e génération, il est une évolution du Su-7, conçu pour des missions d''attaque au sol et d''appui aérien rapproché avec une capacité de supériorité aérienne limitée. Largement exporté, il a été utilisé dans plusieurs conflits au Moyen-Orient et en Afghanistan.',
    'The Sukhoi Su-17 Fitter is a variable-geometry fighter-bomber developed for the Soviet air forces. Classified as 3rd generation, it is an evolution of the Su-7, designed for ground attack and close air support missions with limited air superiority capability. Widely exported, it has been used in several conflicts in the Middle East and Afghanistan.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1964-01-01',
    '1966-08-02',
    '1970-01-01',
    2230.0,
    2300.0,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    NULL,
    12000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM tech WHERE name = 'Radar Klen')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM armement WHERE name = 'GSh-30-2')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM armement WHERE name = 'Kh-23')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM armement WHERE name = 'R-60'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'Su-17'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));