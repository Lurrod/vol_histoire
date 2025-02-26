-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'F-35 Lightning II', 'Lockheed Martin F-35 Lightning II', 'Avion multirôle furtif américain de 5e génération', 
    'https://i.postimg.cc/W3YWZrjL/f35-lightning-2.jpg', 
    'Le Lockheed Martin F-35 Lightning II est un avion de combat multirôle furtif conçu pour l''US Air Force, la Navy et le Marine Corps. Appartenant à la 5e génération, il excelle dans les missions air-air, air-sol et de reconnaissance grâce à sa furtivité, sa fusion de capteurs et ses capacités STOVL (décollage court et atterrissage vertical) dans certaines variantes. Utilisé par de nombreux pays alliés, il est un pilier des forces aériennes modernes.', 
    (SELECT id FROM countries WHERE code = 'USA'), '1996-01-01', '2006-12-15', '2016-08-02', 
    2000.0, 2200.0, (SELECT id FROM manufacturer WHERE code = 'LM'), 
    (SELECT id FROM generation WHERE generation = 5), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Actif', 13200.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-81')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));