-- Insertion du nouveau constructeur
INSERT INTO manufacturer (name, country_id, code) VALUES
('English Electric', (SELECT id FROM countries WHERE code = 'GBR'), 'EE');

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
    'English Electric Lightning',
    'English Electric Lightning',
    'English Electric Lightning',
    'English Electric Lightning',
    'Intercepteur supersonique britannique de 2e génération',
    'British 2nd-generation supersonic interceptor',
    'https://i.postimg.cc/3xpf136B/english-electric-lightning.jpg',
    'L''English Electric Lightning est un avion intercepteur supersonique développé pour la Royal Air Force durant la Guerre froide. Premier et unique chasseur entièrement supersonique conçu et produit par le Royaume-Uni, il se distingue par sa configuration unique à deux réacteurs Rolls-Royce Avon superposés dans le fuselage, lui conférant un rapport poussée/poids exceptionnel et une vitesse de montée remarquable. Capable d''atteindre Mach 2 et de grimper à plus de 15 000 mètres en quelques minutes, il était conçu pour intercepter les bombardiers soviétiques à haute altitude. Armé de missiles Firestreak puis Red Top et de canons ADEN, il a servi la RAF de 1960 à 1988 et a également été exporté vers l''Arabie saoudite et le Koweït. Malgré son autonomie limitée, il reste l''un des intercepteurs les plus emblématiques de la Guerre froide.',
    'The English Electric Lightning is a supersonic interceptor aircraft developed for the Royal Air Force during the Cold War. The first and only fully supersonic fighter designed and produced by the United Kingdom, it is distinguished by its unique configuration with two stacked Rolls-Royce Avon engines in the fuselage, giving it an exceptional thrust-to-weight ratio and remarkable climb rate. Capable of reaching Mach 2 and climbing to over 15,000 meters in a few minutes, it was designed to intercept Soviet bombers at high altitude. Armed with Firestreak then Red Top missiles and ADEN cannons, it served the RAF from 1960 to 1988 and was also exported to Saudi Arabia and Kuwait. Despite its limited range, it remains one of the most iconic interceptors of the Cold War.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1947-01-01',
    '1954-08-04',
    '1960-06-29',
    2415.0,
    1300.0,
    (SELECT id FROM manufacturer WHERE code = 'EE'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    NULL,
    12700.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Avon')),
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM tech WHERE name = 'Radar AI.23')),
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM armement WHERE name = 'Firestreak')),
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM armement WHERE name = 'Red Top'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'English Electric Lightning'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));