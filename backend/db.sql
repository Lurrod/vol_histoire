CREATE TABLE countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(3) UNIQUE NOT NULL
);

CREATE TABLE manufacturer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country_id INTEGER REFERENCES countries(id) ON DELETE SET NULL,
    code VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE generation (
    id SERIAL PRIMARY KEY,
    generation SMALLINT NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE tech (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE airplanes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    complete_name VARCHAR(255),
    little_description VARCHAR(255),
    image_url VARCHAR(255),
    description TEXT,
    country_id INTEGER REFERENCES countries(id) ON DELETE SET NULL,
    date_concept DATE,
    date_first_fly DATE,
    date_operationel DATE,
    max_speed FLOAT,
    max_range FLOAT,
    id_manufacturer INTEGER REFERENCES manufacturer(id) ON DELETE SET NULL,
    id_tech INTEGER REFERENCES tech(id) ON DELETE SET NULL,
    id_generation SMALLINT REFERENCES generation(id) ON DELETE SET NULL,
    type INTEGER REFERENCES type(id) ON DELETE SET NULL,
    status VARCHAR(50),
    weight FLOAT
);

CREATE TABLE wars (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date_start DATE,
    date_end DATE,
    country_id INTEGER REFERENCES countries(id) ON DELETE SET NULL,
    description TEXT
);

CREATE TABLE armement (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE missions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE airplane_armement (
    id_airplane INTEGER REFERENCES airplanes(id) ON DELETE CASCADE,
    id_armement INTEGER REFERENCES armement(id) ON DELETE CASCADE,
    PRIMARY KEY (id_airplane, id_armement)
);

CREATE TABLE airplane_wars (
    id_airplane INTEGER REFERENCES airplanes(id) ON DELETE CASCADE,
    id_wars INTEGER REFERENCES wars(id) ON DELETE CASCADE,
    PRIMARY KEY (id_airplane, id_wars)
);

CREATE TABLE airplane_missions (
    id_airplane INTEGER REFERENCES airplanes(id) ON DELETE CASCADE,
    id_mission INTEGER REFERENCES missions(id) ON DELETE CASCADE,
    PRIMARY KEY (id_airplane, id_mission)
);

CREATE TABLE airplane_tech (
    id_airplane INTEGER REFERENCES airplanes(id) ON DELETE CASCADE,
    id_tech INTEGER REFERENCES tech(id) ON DELETE CASCADE,
    PRIMARY KEY (id_airplane, id_tech)
);

INSERT INTO countries (name, code) VALUES
('États-Unis', 'USA'),
('Russie', 'RUS'),
('Chine', 'CHN'),
('France', 'FRA'),
('Royaume-Uni', 'GBR'),
('Allemagne', 'DEU'),
('Italie', 'ITA'),
('Suède', 'SWE'),
('Inde', 'IND'),
('Japon', 'JPN'),
('Brésil', 'BRA'),
('Israël', 'ISR');

INSERT INTO manufacturer (name, country_id, code) VALUES
('Lockheed Martin', (SELECT id FROM countries WHERE code = 'USA'), 'LM'),
('Boeing', (SELECT id FROM countries WHERE code = 'USA'), 'BOE'),
('Sukhoi', (SELECT id FROM countries WHERE code = 'RUS'), 'SUK'),
('Mikoyan (MiG)', (SELECT id FROM countries WHERE code = 'RUS'), 'MIG'),
('Chengdu Aerospace Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'CAC'),
('Shenyang Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'SAC'),
('Dassault Aviation', (SELECT id FROM countries WHERE code = 'FRA'), 'DAS'),
('BAE Systems', (SELECT id FROM countries WHERE code = 'GBR'), 'BAE'),
('Airbus Defence and Space', (SELECT id FROM countries WHERE code = 'DEU'), 'ADS'),
('Leonardo S.p.A.', (SELECT id FROM countries WHERE code = 'ITA'), 'LEO'),
('Saab AB', (SELECT id FROM countries WHERE code = 'SWE'), 'SAAB'),
('HAL (Hindustan Aeronautics Limited)', (SELECT id FROM countries WHERE code = 'IND'), 'HAL'),
('Mitsubishi Heavy Industries', (SELECT id FROM countries WHERE code = 'JPN'), 'MHI'),
('Embraer', (SELECT id FROM countries WHERE code = 'BRA'), 'EMB'),
('IAI (Israel Aerospace Industries)', (SELECT id FROM countries WHERE code = 'ISR'), 'IAI');

INSERT INTO generation (generation, description) VALUES
(1, 'Première génération : Avions à réaction subsoniques des années 1940-1950'),
(2, 'Deuxième génération : Améliorations de l’aérodynamique et de l’armement dans les années 1950-1960'),
(3, 'Troisième génération : Introduction des missiles guidés et meilleure maniabilité dans les années 1960-1970'),
(4, 'Quatrième génération : Hautes performances, systèmes fly-by-wire et radars avancés des années 1970-1990'),
(5, 'Cinquième génération : Technologie furtive, supercroisière et fusion de capteurs depuis les années 2000');

INSERT INTO type (name, description) VALUES
('Chasseur', 'Avion de combat conçu pour la supériorité aérienne'),
('Bombardier', 'Avion militaire destiné à attaquer des cibles au sol'),
('Reconnaissance', 'Avion utilisé pour la surveillance et la collecte d’informations'),
('Intercepteur', 'Avion rapide conçu pour intercepter et neutraliser les menaces aériennes'),
('Multirôle', 'Avion capable d’effectuer plusieurs types de missions'),
('Appui aérien', 'Avion conçu pour soutenir les troupes au sol avec des frappes ciblées');

INSERT INTO wars (name, date_start, date_end, description) VALUES
('Première Guerre mondiale', '1914-07-28', '1918-11-11', 'Conflit mondial impliquant les grandes puissances de l’époque.'),
('Seconde Guerre mondiale', '1939-09-01', '1945-09-02', 'Le plus grand conflit militaire de l’histoire impliquant de nombreux pays.'),
('Guerre de Corée', '1950-06-25', '1953-07-27', 'Conflit entre la Corée du Nord et la Corée du Sud, impliquant les États-Unis et la Chine.'),
('Guerre du Vietnam', '1955-11-01', '1975-04-30', 'Conflit prolongé entre le Nord Vietnam communiste et le Sud Vietnam soutenu par les États-Unis.'),
('Guerre du Golfe', '1990-08-02', '1991-02-28', 'Conflit déclenché par l’invasion du Koweït par l’Irak et la réponse de la coalition internationale.'),
('Guerre d’Afghanistan', '2001-10-07', '2021-08-30', 'Conflit entre les forces occidentales et les talibans en Afghanistan.'),
('Guerre d’Irak', '2003-03-20', '2011-12-15', 'Invasion de l’Irak menée par une coalition menée par les États-Unis pour renverser Saddam Hussein.');

CREATE USER admin WITH ENCRYPTED PASSWORD 'Titouan1.';
GRANT ALL PRIVILEGES ON DATABASE votre_base TO admin;
GRANT USAGE ON SCHEMA public TO admin;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;

-- Insertions pour le Rafale
INSERT INTO countries (name, code) VALUES
('France', 'FRA');

INSERT INTO manufacturer (name, country_id, code) VALUES
('Dassault Aviation', (SELECT id FROM countries WHERE code = 'FRA'), 'DAS');

INSERT INTO generation (generation, description) VALUES
(4, 'Quatrième génération : Hautes performances, systèmes fly-by-wire et radars avancés des années 1970-1990');

INSERT INTO type (name, description) VALUES
('Multirôle', 'Avion capable d’effectuer plusieurs types de missions');

INSERT INTO tech (name, description) VALUES
('RBE2-AA Radar', 'Radar AESA (Active Electronically Scanned Array) de dernière génération'),
('SPECTRA', 'Système de guerre électronique intégré'),
('OSF', 'Système optronique secteur frontal avec capacités IR et TV');

INSERT INTO armement (name, description) VALUES
('MICA IR', 'Missile air-air à guidage infrarouge (portée 80 km)'),
('MICA EM', 'Missile air-air à guidage radar actif (portée 80 km)'),
('Meteor', 'Missile air-air longue portée (100-150 km)'),
('SCALP EG', 'Missile de croisière (portée 500 km)'),
('AM39 Exocet', 'Missile anti-navire (portée 70 km)'),
('GBU-12 Paveway II', 'Bombe guidée laser (224 kg)'),
('30M791', 'Canon interne de 30 mm (125 coups)');

INSERT INTO wars (name, date_start, date_end, description) VALUES
('Intervention en Libye', '2011-03-19', '2011-10-31', 'Opération Harmattan'),
('Opération Serval', '2013-01-11', '2014-07-15', 'Intervention au Mali'),
('Opération Chammal', '2014-09-19', NULL, 'Lutte contre Daech');

INSERT INTO missions (name, description) VALUES
('Supériorité aérienne', 'Contrôle de l''espace aérien'),
('Frappe stratégique', 'Attaques de précision'),
('Reconnaissance armée', 'Surveillance avec capacité d''engagement');

-- Insertion du Rafale
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
    'Rafale',
    'Dassault Rafale',
    'Chasseur multirôle omnirole 4.5ème génération',
    'Avion de combat français polyvalent avec architecture modulaire',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1983-01-01',
    '1986-07-04',
    '2001-05-18',
    1912,
    3700,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    10000,
    'https://i.postimg.cc/3NhD2ZCd/rafale.jpg'
);

-- Liaisons many-to-many
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Rafale'), 
    id 
FROM tech 
WHERE name IN ('RBE2-AA Radar', 'SPECTRA', 'OSF');

INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Rafale'), 
    id 
FROM armement 
WHERE name IN ('MICA IR', 'MICA EM', 'Meteor', 'SCALP EG', 'AM39 Exocet', 'GBU-12 Paveway II', '30M791');

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Rafale'), 
    id 
FROM wars 
WHERE name IN ('Intervention en Libye', 'Opération Serval', 'Opération Chammal');

INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Rafale'), 
    id 
FROM missions;