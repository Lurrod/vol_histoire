-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Tu-160', 'Tupolev Tu-160 Blackjack', 'Bombardier stratégique russe de 4e génération', 
    'https://i.postimg.cc/fRYmFpBD/tu160.jpg', 
    'Le Tupolev Tu-160 Blackjack est un bombardier stratégique supersonique à géométrie variable développé pour les forces aériennes soviétiques, puis russes. Classé dans la 4e génération, il est conçu pour des missions de frappe stratégique et nucléaire à longue portée, capable de transporter des missiles de croisière et des bombes lourdes à une vitesse dépassant Mach 2. Surnommé "Cygne blanc", il est le plus grand bombardier supersonique au monde et reste actif dans l’arsenal russe.', 
    (SELECT id FROM countries WHERE code = 'RUS'), '1975-01-01', '1981-12-18', '1987-04-01', 
    2220.0, 12300.0, (SELECT id FROM manufacturer WHERE code = 'TUP'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Actif', 110000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM tech WHERE name = 'Radar Obzor-K')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM armement WHERE name = 'Kh-55')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM armement WHERE name = 'Kh-101')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM armement WHERE name = 'Kh-102')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM armement WHERE name = 'FAB-1500')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM armement WHERE name = 'TN-1000'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Tu-160'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));