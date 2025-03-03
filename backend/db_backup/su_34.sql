-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Su-34', 'Sukhoi Su-34 Fullback', 'Chasseur-bombardier russe de 4e génération avancée', 
    'https://i.postimg.cc/W1qX458H/su34.jpg', 
    'Le Sukhoi Su-34 Fullback est un chasseur-bombardier biplace dérivé du Su-27, développé pour les forces aériennes russes. Classé dans la 4e génération avancée (souvent appelée 4++), il est conçu pour des missions de frappe tactique et stratégique avec une capacité tous temps et une grande précision. Équipé d’un poste de pilotage côte à côte, il est utilisé dans des conflits modernes comme la guerre en Syrie.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1986-01-01', '1990-04-13', '2014-03-20', 
    1900.0, 4000.0, (SELECT id FROM manufacturer WHERE code = 'SUK'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Actif', 22500.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM tech WHERE name = 'Radar V004')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM armement WHERE name = 'Kh-29L')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM armement WHERE name = 'Kh-59')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM armement WHERE name = 'KAB-500L'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'Su-34'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));