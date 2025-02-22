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
    'Mirage III',
    'Dassault Mirage III',
    'Chasseur-intercepteur de 2ème génération',
    'Le Mirage III est un avion de combat légendaire développé par Dassault Aviation dans les années 1950. Premier chasseur européen à atteindre Mach 2, il a marqué l''histoire de l''aéronautique militaire avec son aile delta caractéristique. Exporté dans 21 pays et produit à 1422 exemplaires, il a participé à de nombreux conflits majeurs de la Guerre Froide.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1952-01-01',
    '1956-11-17',
    '1961-07-09',
    2350,
    2400,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré du service actif',
    7050,
    'https://i.postimg.cc/cCFqSbZ2/mirage3.jpg'
);

INSERT INTO tech (name, description) VALUES
('Cyrano II', 'Premier radar monopulse aéroporté français (1959)'),
('SEPR 844', 'Moteur-fusée d''appoint pour interception rapide'),
('Sirène IV', 'Système d''alerte radar primitif');

INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage III'), 
    id 
FROM tech 
WHERE name IN ('Cyrano II', 'SEPR 844', 'Sirène IV');

INSERT INTO armement (name, description) VALUES
('Matra R.530', 'Premier missile air-air français à guidage radar (1962)'),
('DEFA 552', 'Canon de 30 mm (125 coups par canon)'),
('Bombe AN-52', 'Arme nucléaire tactique (1972)');

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage III'), 
    id 
FROM armement 
WHERE name IN ('Matra R.530', 'DEFA 552', 'Bombe AN-52');

INSERT INTO wars (name, date_start, date_end, description) VALUES
('Guerre des Six Jours', '1967-06-05', '1967-06-10', 'Utilisation par Israël contre forces arabes'),
('Guerre du Kippour', '1973-10-06', '1973-10-25', 'Combats aériens intensifs'),
('Guerre des Malouines', '1982-04-02', '1982-06-14', 'Engagé par l''Argentine');

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage III'), 
    id 
FROM wars 
WHERE name IN ('Guerre des Six Jours', 'Guerre du Kippour', 'Guerre des Malouines');

INSERT INTO missions (name, description) VALUES
('Alerte nucléaire', 'Mise en œuvre de la dissuasion nucléaire'),
('Interception haute-altitude', 'Défense aérienne territoire national');

INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Mirage III'), 
    id 
FROM missions 
WHERE name IN ('Alerte nucléaire', 'Interception haute-altitude', 'Supériorité aérienne');