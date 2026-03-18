-- Insertion du nouveau constructeur
INSERT INTO manufacturer (name, country_id, code) VALUES
('Nanchang Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'NAMC');

-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Nanchang Q-5', 'Nanchang Q-5 Fantan', 'Avion d''attaque au sol chinois de 2e génération', 
    'https://i.postimg.cc/6pVzR8sr/q5.png', 
    'Le Nanchang Q-5 Fantan est un avion d''attaque au sol développé par Nanchang Aircraft Corporation, dérivé du chasseur Shenyang J-6 (MiG-19). Conçu dans les années 1960 pour répondre au besoin d''un appareil d''appui aérien rapproché et de frappe tactique, il se distingue par son nez redessiné intégrant une soute à bombes interne et ses entrées d''air latérales. Le Q-5 a été le premier avion d''attaque conçu et produit en Chine. Robuste et fiable, il a été largement utilisé par l''Armée populaire de libération et exporté vers plusieurs pays, notamment le Pakistan, le Bangladesh et la Birmanie. Il a participé à la guerre sino-vietnamienne de 1979 et au conflit indo-pakistanais. Bien que progressivement retiré du service, il a marqué une étape importante dans l''industrie aéronautique chinoise.', 
    (SELECT id FROM countries WHERE code = 'CHN'), '1958-01-01', '1965-06-04', '1970-01-01', 
    1210.0, 2000.0, (SELECT id FROM manufacturer WHERE code = 'NAMC'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Appui aérien'), 
    'Retiré', 6375.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM tech WHERE name = 'Réacteur WP-6')),
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM armement WHERE name = 'Canon NR-23')),
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM armement WHERE name = 'Type 90-1')),
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM armement WHERE name = 'HF-16')),
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM armement WHERE name = 'PL-2'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Nanchang Q-5'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));