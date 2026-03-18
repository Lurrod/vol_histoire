-- Insertion du nouveau constructeur
INSERT INTO manufacturer (name, country_id, code) VALUES
('Xian Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'XAC');

-- Insertion des nouveaux armements spécifiques au H-6
INSERT INTO armement (name, description) VALUES
('CJ-10', 'Missile de croisière à lancement aérien, portée 1500-2000 km'),
('CJ-20', 'Missile de croisière furtif à lancement aérien, portée 2000+ km');

-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Xian H-6', 'Xian H-6 Badger', 'Bombardier stratégique chinois de 2e génération', 
    'https://i.postimg.cc/CLqchvm6/h6.jpg', 
    'Le Xian H-6 est un bombardier stratégique à moyenne et longue portée produit par Xian Aircraft Corporation, dérivé du Tupolev Tu-16 soviétique. Produit sous licence à partir des années 1960, il a été continuellement modernisé et reste l''épine dorsale de la force de bombardement stratégique chinoise. Les variantes modernes comme le H-6K et le H-6N ont été profondément transformées avec de nouveaux réacteurs, une avionique moderne et la capacité d''emporter des missiles de croisière à longue portée. Le H-6N est la première variante capable d''effectuer le ravitaillement en vol et de transporter des missiles balistiques aéroportés. Il joue un rôle central dans la dissuasion nucléaire et la projection de puissance chinoise, notamment en mer de Chine méridionale.', 
    (SELECT id FROM countries WHERE code = 'CHN'), '1957-01-01', '1959-09-27', '1969-01-01', 
    1014.0, 6000.0, (SELECT id FROM manufacturer WHERE code = 'XAC'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Bombardier'), 
    'Actif', 75800.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM tech WHERE name = 'Radar AESA'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM armement WHERE name = 'CJ-10')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM armement WHERE name = 'CJ-20')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM armement WHERE name = 'YJ-83')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM armement WHERE name = 'KD-88')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM armement WHERE name = 'FAB-500'));

-- Insertion des guerres
-- Le H-6 n'a pas été engagé dans des conflits majeurs à ce jour, donc pas d'entrée dans airplane_wars

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Xian H-6'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));