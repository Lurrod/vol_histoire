-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'MiG-29 Allemand', 'Mikoyan MiG-29A/UB Fulcrum (NVA / Luftwaffe)', 'Chasseur de supériorité aérienne de 4e génération, joyau hérité de l''Allemagne de l''Est', 
    'https://i.postimg.cc/QML24bBs/mig29-allemand.jpg', 
    'Le MiG-29 allemand constitue un cas unique dans l''histoire de l''aviation militaire : seul chasseur de 4e génération du Pacte de Varsovie à avoir été intégré et exploité opérationnellement au sein de l''OTAN. La Nationale Volksarmee (NVA) de l''Allemagne de l''Est reçut 24 appareils — 20 MiG-29A monoplaces et 4 MiG-29UB biplaces — à partir de 1988, seulement deux ans avant la chute du Mur de Berlin. Après la réunification de 1990, contrairement aux MiG-21 et MiG-23 rapidement retirés, la Luftwaffe décida de conserver les MiG-29 en service actif au sein du JG 73 « Steinhoff » basé à Laage, en Mecklembourg. Cette décision s''avéra stratégiquement précieuse : les Fulcrum allemands participèrent à de nombreux exercices OTAN, révélant les capacités redoutables du missile R-73 Archer couplé au viseur de casque, et démontrant une supériorité en combat rapproché face aux F-16 et F/A-18 occidentaux. Les appareils furent modernisés aux standards OTAN avec l''intégration de systèmes IFF, de communications sécurisées et d''un GPS. En 2003, après 15 ans de service sous les couleurs allemandes, les 22 MiG-29 restants furent cédés à la Pologne pour un euro symbolique chacun, mettant fin à ce chapitre exceptionnel de l''aviation européenne.', 
    (SELECT id FROM countries WHERE code = 'DEU'), '1974-01-01', '1977-10-06', '1988-05-01', 
    2450.0, 1430.0, (SELECT id FROM manufacturer WHERE code = 'MIG'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Chasseur'), 
    'Retiré', 11000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Radar N019')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-27R')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-27T')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'S-8'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Escorte'));