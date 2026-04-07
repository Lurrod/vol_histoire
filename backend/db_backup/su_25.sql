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
    'Su-25',
    'Su-25',
    'Sukhoi Su-25 Frogfoot',
    'Sukhoi Su-25 Frogfoot',
    'Avion d''appui aérien rapproché soviétique/russe de 3e génération',
    'Soviet/Russian 3rd-generation close air support aircraft',
    'https://i.postimg.cc/K81sMGGQ/su25.jpg',
    'Le Sukhoi Su-25 Frogfoot est un avion d''appui aérien rapproché développé pour les forces aériennes soviétiques, puis russes. Classé dans la 3e génération, il est conçu pour fournir un soutien direct aux troupes au sol avec une robustesse exceptionnelle et une forte capacité d''armement. Surnommé le "char volant", il a été largement utilisé dans des conflits comme l''Afghanistan et reste en service dans plusieurs pays.',
    'The Sukhoi Su-25 Frogfoot is a close air support aircraft developed for the Soviet and later Russian air forces. Classified as 3rd generation, it is designed to provide direct support to ground troops with exceptional ruggedness and strong weapon capacity. Nicknamed the "flying tank", it has been widely used in conflicts such as Afghanistan and remains in service in several countries.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1972-01-01',
    '1975-02-22',
    '1981-07-01',
    975.0,
    1850.0,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Actif',
    'Active',
    9500.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM tech WHERE name = 'Blindage en titane')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM tech WHERE name = 'Canon GSh-30-2')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM armement WHERE name = 'GSh-30-2')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM armement WHERE name = 'Kh-25ML')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM armement WHERE name = 'S-8')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM armement WHERE name = 'S-25'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'Su-25'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));