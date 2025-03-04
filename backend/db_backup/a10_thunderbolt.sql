-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'A-10 Thunderbolt II', 'Fairchild Republic A-10 Thunderbolt II', 'Avion d''appui aérien rapproché américain de 4e génération', 
    'https://i.postimg.cc/gcysXwvG/a10-thunderbolt-2.jpg', 
    'Le Fairchild Republic A-10 Thunderbolt II, surnommé "Warthog", est un avion d''appui aérien rapproché conçu pour l''US Air Force. Classé dans la 4e génération, il est spécialisé dans la destruction de blindés et de cibles au sol grâce à son canon GAU-8 Avenger et sa robustesse exceptionnelle. Utilisé dans de nombreux conflits modernes, il est célèbre pour sa durabilité et son efficacité au combat.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1970-01-01', '1972-05-10', '1977-03-10', 
    706.0, 4150.0, (SELECT id FROM manufacturer WHERE code = 'LM'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Appui aérien'), 
    'Actif', 12000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM tech WHERE name = 'Canon GAU-8 Avenger')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM tech WHERE name = 'Blindage en titane')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM armement WHERE name = 'GAU-8 Avenger')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM armement WHERE name = 'Hydra 70')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM armement WHERE name = 'CBU-97'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));