-- Insertion du nouveau constructeur
INSERT INTO manufacturer (name, country_id, code) VALUES
('Hongdu Aviation Industry', (SELECT id FROM countries WHERE code = 'CHN'), 'HONG');

-- Insertion du nouveau type
INSERT INTO type (name, description) VALUES
('Entraîneur', 'Avion d''entraînement conçu pour la formation des pilotes militaires');

-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Hongdu JL-8', 'Hongdu JL-8 Karakorum', 'Avion d''entraînement et d''appui léger chinois de 3e génération', 
    'https://i.postimg.cc/vBCShC0f/jl8.jpg', 
    'Le Hongdu JL-8, également connu sous sa désignation d''exportation K-8 Karakorum, est un avion d''entraînement avancé et d''appui aérien léger développé conjointement par la Chine et le Pakistan. Conçu par Hongdu Aviation Industry (anciennement Nanchang Aircraft Corporation), il a effectué son premier vol en 1990 et est entré en service en 1994. Biplace en tandem, le JL-8 est destiné à la formation intermédiaire et avancée des pilotes, mais possède également une capacité d''attaque légère grâce à ses cinq points d''emport. Fiable, économique et facile à entretenir, il a rencontré un grand succès à l''exportation avec plus de 500 exemplaires livrés à une quinzaine de pays, principalement en Afrique, en Asie et au Moyen-Orient. Il reste l''un des avions d''entraînement les plus exportés au monde.', 
    (SELECT id FROM countries WHERE code = 'CHN'), '1986-01-01', '1990-11-21', '1994-01-01', 
    800.0, 2200.0, (SELECT id FROM manufacturer WHERE code = 'HONG'), 
    (SELECT id FROM generation WHERE generation = 3), (SELECT id FROM type WHERE name = 'Entraîneur'), 
    'Actif', 2687.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM tech WHERE name = 'Réacteur Honeywell TFE731')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM armement WHERE name = 'PL-5')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM armement WHERE name = 'HF-16'));

-- Insertion des guerres
-- Le JL-8 n'a pas été engagé dans des conflits majeurs à ce jour, donc pas d'entrée dans airplane_wars

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));