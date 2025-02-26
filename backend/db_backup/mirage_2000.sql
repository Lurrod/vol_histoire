-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Mirage 2000', 'Dassault Mirage 2000', 'Chasseur multirôle français de 4e génération', 
    'https://i.postimg.cc/s2TdnMyK/mirage2000.jpg', 
    'Le Dassault Mirage 2000 est un avion de chasse multirôle développé par Dassault Aviation pour l''Armée de l''Air française. Appartenant à la 4e génération, il est conçu pour la supériorité aérienne et les frappes au sol, avec une aile delta, un système fly-by-wire et une grande maniabilité. Utilisé dans de nombreux conflits, il est également exporté vers plusieurs pays.', 
    (SELECT id FROM countries WHERE code = 'FRA'), '1975-01-01', '1978-03-10', '1984-07-02', 
    2338.0, 1550.0, (SELECT id FROM manufacturer WHERE code = 'DAS'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Actif', 7500.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM tech WHERE name = 'Radar RDM/RDI')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM armement WHERE name = 'DEFA 554')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM armement WHERE name = 'Matra R550 Magic')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM armement WHERE name = 'Matra Super 530D')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM armement WHERE name = 'AS-30L')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));