-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'F-8E (FN) Crusader', 'Vought F-8E (FN) Crusader', 'Chasseur naval français de 3e génération', 
    'https://i.postimg.cc/3NncDkmt/f8-crusader-fr.jpg', 
    'Le Vought F-8E (FN) Crusader est une version modifiée du F-8 Crusader américain, adaptée pour la Marine nationale française (Aéronavale). Classé dans la 3e génération, il a été utilisé comme intercepteur embarqué sur les porte-avions Clemenceau et Foch. Avec ses ailes à incidence variable et sa capacité tous temps, il a servi pendant 35 ans avant d’être remplacé par le Rafale Marine.', 
    (SELECT id FROM countries WHERE code = 'FRA'), '1952-01-01', '1964-02-27', '1964-11-01', 
    1915.0, 1730.0, (SELECT id FROM manufacturer WHERE code = 'LM'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Intercepteur'), 
    'Retiré', 10990.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM tech WHERE name = 'Aile à incidence variable')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM tech WHERE name = 'Radar AN/APQ-94'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM armement WHERE name = 'Matra R530')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM armement WHERE name = 'Matra R550 Magic')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM armement WHERE name = 'Zuni 127 mm'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM wars WHERE name = 'Guerre du Liban')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'F-8E (FN) Crusader'), (SELECT id FROM missions WHERE name = 'Escorte'));