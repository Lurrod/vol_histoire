-- Insertion des nouveaux armements spécifiques au FC-1/JF-17
INSERT INTO armement (name, description) VALUES
('C-802A', 'Missile antinavire subsonique, guidage radar actif, portée 180 km');

-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Chengdu FC-1/JF-17', 'Chengdu FC-1 Xiaolong / JF-17 Thunder', 'Chasseur multirôle léger sino-pakistanais de 4e génération', 
    'https://i.postimg.cc/dtj4Z7c8/jf17.jpg', 
    'Le Chengdu FC-1 Xiaolong (Fierce Dragon), désigné JF-17 Thunder au Pakistan, est un chasseur multirôle léger développé conjointement par Chengdu Aerospace Corporation et le Pakistan Aeronautical Complex. Conçu pour être un appareil abordable et performant, il vise à remplacer les flottes vieillissantes de F-7, Mirage III et A-5 de la Pakistan Air Force. Monoréacteur équipé du Klimov RD-93, il dispose d''un radar KLJ-7 et peut emporter un large éventail d''armements air-air et air-sol. Entré en service en 2007, le JF-17 est produit en série au Pakistan et a été exporté vers plusieurs pays dont la Birmanie et le Nigeria. Le Block 3, doté d''un radar AESA et de capacités améliorées, marque une évolution significative du programme.', 
    (SELECT id FROM countries WHERE code = 'CHN'), '1991-01-01', '2003-08-25', '2007-03-12', 
    1960.0, 1352.0, (SELECT id FROM manufacturer WHERE code = 'CAC'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Actif', 6586.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM tech WHERE name = 'Réacteur RD-93')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM tech WHERE name = 'Radar KLJ-7'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'PL-5')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'PL-8')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'PL-12')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'C-802A')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'LS-6'));

-- Insertion des guerres
-- Le FC-1/JF-17 n'a pas été engagé dans des conflits majeurs à ce jour (les escarmouches indo-pakistanaises de 2019 ne constituent pas un conflit répertorié)

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));