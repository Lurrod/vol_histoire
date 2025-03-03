-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Tu-95', 'Tupolev Tu-95 Bear', 'Bombardier stratégique soviétique/russe de 2e génération', 
    'https://i.postimg.cc/jjQ6Wm7Z/tu95.jpg', 
    'Le Tupolev Tu-95 Bear est un bombardier stratégique à turbopropulseurs développé pour les forces aériennes soviétiques, puis russes. Classé dans la 2e génération, il est conçu pour des missions de frappe stratégique et nucléaire à très longue portée, grâce à ses moteurs uniques à hélices contrarotatives. En service depuis les années 1950, il a été modernisé et reste actif, notamment pour des patrouilles longue distance.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1950-01-01', '1952-11-12', '1956-04-01', 
    925.0, 15000.0, (SELECT id FROM manufacturer WHERE code = 'TUP'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Actif', 90000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM tech WHERE name = 'Radar PN-AD')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM armement WHERE name = 'Kh-55')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM armement WHERE name = 'Kh-101')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM armement WHERE name = 'Kh-102')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM armement WHERE name = 'FAB-1500')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM armement WHERE name = 'TN-1000'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-95'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));