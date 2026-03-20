-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'F-4 Phantom II Allemand', 'McDonnell Douglas F-4F Phantom II (Luftwaffe)', 'Chasseur multirôle de 3e génération au service de la Luftwaffe', 
    'https://i.postimg.cc/DzV9jgWV/f4-phantom-2-allemand.jpg', 
    'Le McDonnell Douglas F-4F Phantom II est la variante allégée du célèbre chasseur-bombardier américain, spécialement adaptée pour la Luftwaffe ouest-allemande. Livrée à partir de 1973, cette version se distinguait par la suppression initiale de la capacité de tir de missiles AIM-7 Sparrow et par un allègement structurel pour privilégier les missions de supériorité aérienne. Au total, 175 exemplaires furent livrés à l''Allemagne de l''Ouest. Dans les années 1980, le programme ICE (Improved Combat Efficiency) modernisa profondément la flotte en intégrant le radar AN/APG-65, la capacité de tir du missile AIM-120 AMRAAM et de nouveaux systèmes de guerre électronique, propulsant l''appareil aux standards de la 4e génération. Le F-4F constitua le pilier de la défense aérienne allemande pendant plus de trois décennies de Guerre froide et au-delà, assurant des missions d''interception et de police du ciel dans le cadre de l''OTAN. Il fut définitivement retiré du service en 2013, remplacé par l''Eurofighter Typhoon.', 
    (SELECT id FROM countries WHERE code = 'DEU'), '1955-01-01', '1973-05-18', '1973-09-01', 
    2370.0, 2600.0, (SELECT id FROM manufacturer WHERE code = 'BOE'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Retiré', 12700.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Radar AN/APQ-120')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'Mk 83')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'Mk 84')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));