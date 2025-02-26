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
    'Rafale', 
    'Dassault Rafale', 
    'Chasseur multirôle français de 4e génération', 
    'https://i.postimg.cc/3NhD2ZCd/rafale.jpg', 
    'Le Dassault Rafale est un avion de combat multirôle développé par Dassault Aviation. Conçu pour opérer dans des missions air-air et air-sol, il intègre des technologies avancées comme la furtivité partielle, un radar AESA et des systèmes de guerre électronique sophistiqués. Utilisé par l''Armée de l''Air française et la Marine nationale, il excelle dans la supériorité aérienne, les frappes de précision et la reconnaissance.', 
    (SELECT id FROM countries WHERE code = 'FRA'), 
    '1982-12-01',
    '1986-07-04',
    '2001-05-18',
    2450.0,
    3700.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'), 
    (SELECT id FROM generation WHERE generation = 4), 
    (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Actif', 
    10000.0
);

INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM tech WHERE name = 'Système SPECTRA')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM tech WHERE name = 'Radar RBE2 AESA')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs'));

INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM armement WHERE name = 'GIAT 30M791')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM armement WHERE name = 'MICA IR')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM armement WHERE name = 'MICA EM')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM armement WHERE name = 'SCALP EG')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM armement WHERE name = 'AM39 Exocet'));

INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));