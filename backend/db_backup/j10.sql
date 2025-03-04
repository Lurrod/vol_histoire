-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Chengdu J-10', 'Chengdu J-10 Vigorous Dragon', 'Chasseur multirôle chinois de 4e génération', 
    'https://i.postimg.cc/XvGJmCVF/j10.jpg', 
    'Le Chengdu J-10 Vigorous Dragon est un chasseur multirôle développé par Chengdu Aerospace Corporation pour l''Armée populaire de libération. Classé dans la 4e génération, il est conçu pour la supériorité aérienne et les missions air-sol, avec une configuration delta-canard et un système fly-by-wire. Introduit dans les années 2000, il est un pilier moderne de l''aviation chinoise et a été exporté sous des variantes comme le J-10C.', 
    (SELECT id FROM countries WHERE code = 'CHN'), '1994-01-01', '1998-03-23', '2004-07-01', 
    2200.0, 1850.0, (SELECT id FROM manufacturer WHERE code = 'CAC'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Actif', 9750.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM tech WHERE name = 'Réacteur AL-31FN')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM tech WHERE name = 'Radar KLJ-7'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM armement WHERE name = 'PL-8')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM armement WHERE name = 'PL-12')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM armement WHERE name = 'Kh-31P')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM armement WHERE name = 'FAB-500'));

-- Insertion des guerres
-- Le J-10 n'a pas été engagé dans des conflits majeurs à ce jour, donc pas d'entrée dans airplane_wars

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));