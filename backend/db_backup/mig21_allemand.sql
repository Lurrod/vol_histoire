-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'MiG-21 Allemand', 'Mikoyan-Gourevitch MiG-21 Fishbed (NVA / Luftwaffe)', 'Chasseur supersonique soviétique de 3e génération au service de l''Allemagne de l''Est puis réunifiée', 
    'https://i.postimg.cc/VNyxGRJ2/mig21-allemand.jpg', 
    'Le MiG-21 allemand fut l''avion de combat principal des forces aériennes de la République démocratique allemande (Nationale Volksarmee - NVA). À partir de 1962, l''Allemagne de l''Est reçut progressivement plusieurs variantes du Fishbed — MiG-21F-13, MiG-21PF, MiG-21PFM, MiG-21M, MiG-21MF, MiG-21bis et MiG-21U d''entraînement — totalisant plus de 570 appareils livrés par l''Union soviétique. Le MiG-21 constitua l''épine dorsale de la défense aérienne est-allemande pendant toute la Guerre froide, assurant l''interception et la supériorité aérienne face aux forces de l''OTAN le long du rideau de fer. La version MiG-21bis, dernière évolution majeure, disposait du réacteur Tumansky R-25-300 plus puissant et du radar RP-22 amélioré. Après la réunification allemande en 1990, la Luftwaffe hérita de 24 MiG-21bis encore opérationnels. Brièvement évalués et utilisés pour l''entraînement au combat dissimilaire — offrant aux pilotes de l''OTAN une expérience unique face à un chasseur du Pacte de Varsovie —, ils furent définitivement retirés du service en 1993 et remplacés par des appareils occidentaux.', 
    (SELECT id FROM countries WHERE code = 'DEU'), '1954-01-01', '1956-06-14', '1962-06-01', 
    2230.0, 1210.0, (SELECT id FROM manufacturer WHERE code = 'MIG'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Chasseur'), 
    'Retiré', 5843.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur Tumansky R-25')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Radar RP-21')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'R-3S')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'R-13M')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'S-24'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));