-- Insertion des nouveaux armements spécifiques au J-15
INSERT INTO armement (name, description) VALUES
('YJ-83', 'Missile antinavire subsonique, guidage radar actif, portée 180 km');

-- Insertion dans airplanes
INSERT INTO airplanes (
    name,
    name_en,
    complete_name,
    complete_name_en,
    little_description,
    little_description_en,
    image_url,
    description,
    description_en,
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
    status_en,
    weight
) VALUES (
    'Shenyang J-15',
    'Shenyang J-15',
    'Shenyang J-15 Flying Shark',
    'Shenyang J-15 Flying Shark',
    'Chasseur embarqué chinois de 4e génération',
    'Chinese 4th-generation carrier-based fighter',
    'https://i.postimg.cc/YS6cvrRZ/j15.jpg',
    'Le Shenyang J-15 Flying Shark est le premier chasseur embarqué opérationnel de la marine chinoise, développé par Shenyang Aircraft Corporation. Dérivé du prototype T-10K du Sukhoi Su-33 russe, il a été adapté et modernisé avec des systèmes avioniques et un armement chinois. Le J-15 est conçu pour opérer depuis les porte-avions de la classe Liaoning et Shandong, utilisant un tremplin ski-jump pour le décollage. Capable de missions de supériorité aérienne, d''attaque antinavire et de frappe tactique, il est équipé d''ailes repliables, d''une crosse d''appontage et d''un train d''atterrissage renforcé. Il constitue un élément clé de la projection de puissance navale chinoise.',
    'The Shenyang J-15 Flying Shark is the first operational carrier-based fighter of the Chinese Navy, developed by Shenyang Aircraft Corporation. Derived from the Russian Sukhoi Su-33 T-10K prototype, it has been adapted and modernized with Chinese avionics systems and armament. The J-15 is designed to operate from Liaoning and Shandong-class aircraft carriers, using a ski-jump ramp for take-off. Capable of air superiority, anti-ship attack and tactical strike missions, it is equipped with folding wings, an arrestor hook and reinforced landing gear. It constitutes a key element of Chinese naval power projection.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2001-01-01',
    '2009-08-31',
    '2013-11-01',
    2400.0,
    3500.0,
    (SELECT id FROM manufacturer WHERE code = 'SAC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    17500.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Réacteur WS-10')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'PL-8')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'PL-12')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'YJ-83')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'LS-6'));

-- Insertion des guerres
-- Le J-15 n'a pas été engagé dans des conflits majeurs à ce jour, donc pas d'entrée dans airplane_wars

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Escorte'));