-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Tu-22M', 'Tupolev Tu-22M Backfire', 'Bombardier stratégique soviétique/russe de 3e génération', 
    'https://i.postimg.cc/BQkBRx3c/tu22.jpg', 
    'Le Tupolev Tu-22M Backfire est un bombardier stratégique à géométrie variable développé pour les forces aériennes et navales soviétiques, puis russes. Classé dans la 3e génération, il est conçu pour des missions de frappe stratégique et antinavire à longue portée, capable de transporter des missiles de croisière et des bombes lourdes. Utilisé pendant la Guerre froide et dans des conflits modernes, il reste un atout clé de la Russie.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1965-01-01', '1969-08-30', '1972-01-01', 
    2050.0, 6800.0, (SELECT id FROM manufacturer WHERE code = 'TUP'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Actif', 54000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM tech WHERE name = 'Radar PN-AD')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'GSh-6-23')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'Kh-22')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'Kh-15')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'Kh-32')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'Kh-47M2 Kinzhal')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'FAB-1500')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'FAB-3000')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'FAB-5000')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'TN-1000'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));