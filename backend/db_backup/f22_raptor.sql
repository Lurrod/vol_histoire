INSERT INTO airplanes (
    name, 
    complete_name, 
    little_description, 
    image_url, 
    description, 
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
    weight
) VALUES (
    'F-22 Raptor', 
    'Lockheed Martin F-22 Raptor', 
    'Chasseur furtif américain de 5e génération', 
    'https://i.postimg.cc/qM3ncn0c/f22-raptor.jpg', 
    'Le Lockheed Martin F-22 Raptor est un avion de chasse furtif de supériorité aérienne développé pour l''US Air Force. Premier avion opérationnel de 5e génération, il combine furtivité, supercroisière, agilité exceptionnelle et une intégration avancée de capteurs pour dominer les combats aériens. Utilisé principalement pour des missions de supériorité aérienne, il a aussi des capacités air-sol limitées.', 
    (SELECT id FROM countries WHERE code = 'USA'), 
    '1985-01-01',
    '1997-09-07',
    '2005-12-15',
    3065.0,
    2960.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Chasseur'), 
    'Actif', 
    19700.0
);

INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-77')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM tech WHERE name = 'Moteurs à poussée vectorielle'));

INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM armement WHERE name = 'GBU-32 JDAM')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB'));

INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));