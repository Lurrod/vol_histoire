INSERT INTO airplanes (
    name, 
    complete_name, 
    little_description, 
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
    weight,
    image_url
) VALUES (
    'Étendard IV',
    'Dassault Étendard IVM',
    'Chasseur embarqué polyvalent de 2ème génération',
    'L''Étendard IV est un avion d''attaque embarqué développé pour la Marine nationale française. Entré en service en 1962, il équipa les porte-avions Clemenceau et Foch pendant 35 ans. Spécialisé dans l''attaque maritime et la reconnaissance, 90 exemplaires furent produits. Son design robuste et sa capacité à opérer en environnement marin en firent un appareil clé de la puissance aéronavale française.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1956-01-01',
    '1958-05-21',
    '1962-07-01',
    1099,
    1700,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Attaque au sol'),
    'Retiré du service (1991)',
    5900,
    'https://i.postimg.cc/pdJq4nP1/etendard4.jpg'
);

INSERT INTO tech (name, description) VALUES
('DRAA-10A', 'Radar de navigation et d''attaque maritime'),
('TACAN AN/ARN-52', 'Système de navigation tactique embarqué'),
('SERPE à poudre', 'Système d''éjection de siège zéro-zéro');

INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Étendard IV'), 
    id 
FROM tech 
WHERE name IN ('DRAA-10A', 'TACAN AN/ARN-52', 'SERPE à poudre');

INSERT INTO armement (name, description) VALUES
('Missile AS-30', 'Missile air-sol guidé (1961)'),
('Roquettes SNEB 68mm', 'Pod de roquettes non guidées'),
('Bombe AN-M64', 'Bombe générale de 500 livres');

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Étendard IV'), 
    id 
FROM armement 
WHERE name IN ('Missile AS-30', 'Roquettes SNEB 68mm', 'Bombe AN-M64', 'Canon DEFA 553');

INSERT INTO wars (name, date_start, date_end, description) VALUES
('Guerre d''Algérie', '1954-11-01', '1962-03-19', 'Appui-feu depuis le porte-avions Arromanches'),
('Crise de Bizerte', '1961-07-19', '1961-07-23', 'Opérations au-dessus de la Tunisie');

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Étendard IV'), 
    id 
FROM wars 
WHERE name IN ('Guerre d''Algérie', 'Crise de Bizerte', 'Guerre du Golfe');

INSERT INTO missions (name, description) VALUES
('Reconnaissance maritime', 'Surveillance des zones côtières'),
('Attaque anti-navire', 'Neutralisation de bâtiments ennemis');

INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Étendard IV'), 
    id 
FROM missions 
WHERE name IN ('Reconnaissance maritime', 'Attaque anti-navire', 'Appui aérien');

UPDATE airplanes
SET type = 6 
WHERE name = 'Étendard IV';