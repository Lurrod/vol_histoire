DROP DATABASE vol_histoire;

CREATE DATABASE vol_histoire;

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
    name VARCHAR(255) NOT NULL UNIQUE,
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

-- Insertion des guerres
INSERT INTO wars (name, date_start, date_end, country_id, description) VALUES
-- Guerre du Vietnam (1955-1975)
('Guerre du Vietnam', '1955-11-01', '1975-04-30', (SELECT id FROM countries WHERE code = 'USA'), 'Conflit prolongé entre le Nord-Vietnam communiste et le Sud-Vietnam soutenu par les États-Unis.'),

-- Guerre des Six Jours (1967)
('Guerre des Six Jours', '1967-06-05', '1967-06-10', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et une coalition de pays arabes (Égypte, Jordanie, Syrie).'),

-- Guerre du Kippour (1973)
('Guerre du Kippour', '1973-10-06', '1973-10-25', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et une coalition de pays arabes menée par l''Égypte et la Syrie.'),

-- Guerre froide (1947-1991)
('Guerre froide', '1947-03-12', '1991-12-26', (SELECT id FROM countries WHERE code = 'USA'), 'Confrontation indirecte entre les États-Unis et l''Union soviétique, marquée par des tensions géopolitiques et des conflits par procuration.'),

-- Guerre Iran-Irak (1980-1988)
('Guerre Iran-Irak', '1980-09-22', '1988-08-20', (SELECT id FROM countries WHERE code = 'IRN'), 'Conflit prolongé entre l''Iran et l''Irak, marqué par des batailles aériennes et terrestres intenses.'),

-- Guerre du Golfe (1990-1991)
('Guerre du Golfe', '1990-08-02', '1991-02-28', (SELECT id FROM countries WHERE code = 'USA'), 'Conflit entre une coalition internationale dirigée par les États-Unis et l''Irak après l''invasion du Koweït.'),

-- Guerre de Yougoslavie (1991-2001)
('Guerre de Yougoslavie', '1991-03-31', '2001-06-21', (SELECT id FROM countries WHERE code = 'USA'), 'Série de conflits ethniques et politiques dans les Balkans, impliquant plusieurs pays et factions.'),

-- Guerre d''Afghanistan (2001-2021)
('Guerre d''Afghanistan', '2001-10-07', '2021-08-30', (SELECT id FROM countries WHERE code = 'USA'), 'Conflit prolongé en Afghanistan impliquant les États-Unis et leurs alliés contre les talibans et Al-Qaïda.'),

-- Guerre d''Irak (2003-2011)
('Guerre d''Irak', '2003-03-20', '2011-12-18', (SELECT id FROM countries WHERE code = 'USA'), 'Conflit en Irak mené par une coalition dirigée par les États-Unis pour renverser le régime de Saddam Hussein.'),

-- Conflit israélo-arabe (1948-présent)
('Conflit israélo-arabe', '1948-05-15', NULL, (SELECT id FROM countries WHERE code = 'ISR'), 'Série de conflits et tensions entre Israël et les pays arabes voisins.'),

-- Guerre de Corée (1950-1953)
('Guerre de Corée', '1950-06-25', '1953-07-27', (SELECT id FROM countries WHERE code = 'USA'), 'Conflit entre la Corée du Nord (soutenue par la Chine et l''URSS) et la Corée du Sud (soutenue par les États-Unis et l''ONU).'),

-- Guerre des Malouines (1982)
('Guerre des Malouines', '1982-04-02', '1982-06-14', (SELECT id FROM countries WHERE code = 'GBR'), 'Conflit entre l''Argentine et le Royaume-Uni pour le contrôle des îles Malouines.'),

-- Guerre civile syrienne (2011-présent)
('Guerre civile syrienne', '2011-03-15', NULL, (SELECT id FROM countries WHERE code = 'SYR'), 'Conflit complexe en Syrie impliquant le gouvernement syrien, des rebelles, et des forces internationales.'),

-- Guerre du Liban (1982)
('Guerre du Liban', '1982-06-06', '1982-09-30', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et des factions libanaises et palestiniennes.'),

-- Guerre du Yom Kippour (1973)
('Guerre du Yom Kippour', '1973-10-06', '1973-10-25', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et une coalition de pays arabes menée par l''Égypte et la Syrie.'),

-- Guerre d''Indochine (1946-1954)
('Guerre d''Indochine', '1946-12-19', '1954-07-20', (SELECT id FROM countries WHERE code = 'FRA'), 'Conflit entre la France et le Viet Minh pour le contrôle de l''Indochine.'),

-- Guerre d''Algérie (1954-1962)
('Guerre d''Algérie', '1954-11-01', '1962-03-19', (SELECT id FROM countries WHERE code = 'FRA'), 'Conflit entre la France et le Front de libération nationale (FLN) pour l''indépendance de l''Algérie.'),

-- Guerre des Six Jours (1967)
('Guerre des Six Jours', '1967-06-05', '1967-06-10', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et une coalition de pays arabes (Égypte, Jordanie, Syrie).'),

-- Guerre du Kippour (1973)
('Guerre du Kippour', '1973-10-06', '1973-10-25', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et une coalition de pays arabes menée par l''Égypte et la Syrie.'),

-- Guerre Iran-Irak (1980-1988)
('Guerre Iran-Irak', '1980-09-22', '1988-08-20', (SELECT id FROM countries WHERE code = 'IRN'), 'Conflit prolongé entre l''Iran et l''Irak, marqué par des batailles aériennes et terrestres intenses.'),

-- Guerre du Golfe (1990-1991)
('Guerre du Golfe', '1990-08-02', '1991-02-28', (SELECT id FROM countries WHERE code = 'USA'), 'Conflit entre une coalition internationale dirigée par les États-Unis et l''Irak après l''invasion du Koweït.'),

-- Guerre de Yougoslavie (1991-2001)
('Guerre de Yougoslavie', '1991-03-31', '2001-06-21', (SELECT id FROM countries WHERE code = 'USA'), 'Série de conflits ethniques et politiques dans les Balkans, impliquant plusieurs pays et factions.'),

-- Guerre d''Afghanistan (2001-2021)
('Guerre d''Afghanistan', '2001-10-07', '2021-08-30', (SELECT id FROM countries WHERE code = 'USA'), 'Conflit prolongé en Afghanistan impliquant les États-Unis et leurs alliés contre les talibans et Al-Qaïda.'),

-- Guerre d''Irak (2003-2011)
('Guerre d''Irak', '2003-03-20', '2011-12-18', (SELECT id FROM countries WHERE code = 'USA'), 'Conflit en Irak mené par une coalition dirigée par les États-Unis pour renverser le régime de Saddam Hussein.'),

-- Conflit israélo-arabe (1948-présent)
('Conflit israélo-arabe', '1948-05-15', NULL, (SELECT id FROM countries WHERE code = 'ISR'), 'Série de conflits et tensions entre Israël et les pays arabes voisins.'),

-- Guerre de Corée (1950-1953)
('Guerre de Corée', '1950-06-25', '1953-07-27', (SELECT id FROM countries WHERE code = 'USA'), 'Conflit entre la Corée du Nord (soutenue par la Chine et l''URSS) et la Corée du Sud (soutenue par les États-Unis et l''ONU).'),

-- Guerre des Malouines (1982)
('Guerre des Malouines', '1982-04-02', '1982-06-14', (SELECT id FROM countries WHERE code = 'GBR'), 'Conflit entre l''Argentine et le Royaume-Uni pour le contrôle des îles Malouines.'),

-- Guerre civile syrienne (2011-présent)
('Guerre civile syrienne', '2011-03-15', NULL, (SELECT id FROM countries WHERE code = 'SYR'), 'Conflit complexe en Syrie impliquant le gouvernement syrien, des rebelles, et des forces internationales.'),

-- Guerre du Liban (1982)
('Guerre du Liban', '1982-06-06', '1982-09-30', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et des factions libanaises et palestiniennes.'),

-- Guerre d''Indochine (1946-1954)
('Guerre d''Indochine', '1946-12-19', '1954-07-20', (SELECT id FROM countries WHERE code = 'FRA'), 'Conflit entre la France et le Viet Minh pour le contrôle de l''Indochine.'),

-- Guerre d''Algérie (1954-1962)
('Guerre d''Algérie', '1954-11-01', '1962-03-19', (SELECT id FROM countries WHERE code = 'FRA'), 'Conflit entre la France et le Front de libération nationale (FLN) pour l''indépendance de l''Algérie.');

-- Insertion des missions
INSERT INTO missions (name, description) VALUES
('Supériorité aérienne', 'Contrôle de l’espace aérien par l’élimination des menaces ennemies.'),
('Interception', 'Engagement rapide d’avions ennemis pour protéger l’espace aérien.'),
('Frappe stratégique', 'Attaques de précision sur des cibles stratégiques à longue portée.'),
('Frappe tactique', 'Attaques ciblées sur des objectifs militaires au sol pour soutenir les opérations immédiates.'),
('Appui aérien rapproché', 'Soutien direct aux troupes au sol avec des frappes précises.'),
('Reconnaissance armée', 'Surveillance avec capacité d’engagement en cas de menace détectée.'),
('Reconnaissance stratégique', 'Collecte d’informations sur des zones ou cibles éloignées sans engagement.'),
('Guerre électronique', 'Perturbation des systèmes ennemis via brouillage ou attaques électroniques.'),
('Patrouille aérienne de combat', 'Surveillance prolongée et défense proactive de l’espace aérien.'),
('Attaque antinavire', 'Engagement de navires ennemis avec des missiles ou des bombes spécialisées.'),
('Suppression des défenses aériennes ennemies', 'Destruction ou neutralisation des systèmes antiaériens ennemis.'),
('Largage de secours', 'Livraison de matériel ou de provisions dans des zones difficiles d’accès.'),
('Escorte', 'Protection d’autres aéronefs (bombardiers, transports) contre les menaces aériennes.'),
('Entraînement au combat', 'Simulation de missions pour préparer les pilotes au combat réel.'),
('Dissuasion nucléaire', 'Transport et éventuel largage d’armes nucléaires pour des missions stratégiques.');

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



--Français
INSERT INTO armement (name, description) VALUES
-- Canons
('DEFA 552', 'Canon de 30 mm, 125 coups par canon'),
('DEFA 553', 'Canon de 30 mm, 135-150 coups par canon'),
('DEFA 554', 'Canon de 30 mm amélioré, 125 coups par canon'),
('GIAT 30M791', 'Canon de 30 mm, 125 coups, utilisé sur le Rafale'),
('Colt Mk 12', 'Canon de 20 mm, 125 coups par canon, utilisé sur le F-8 Crusader'),
('M61 Vulcan', 'Canon rotatif 20 mm, 6000 coups/min, capacité adaptée selon avion'), -- Présent ici pour référence future

-- Missiles air-air
('Matra R530', 'Missile moyenne portée, guidage radar semi-actif ou infrarouge'),
('Matra R550 Magic', 'Missile courte portée, guidage infrarouge'),
('Matra Super 530F', 'Missile moyenne portée, guidage radar semi-actif'),
('Matra Super 530D', 'Missile moyenne portée, guidage radar semi-actif, version améliorée'),
('MICA IR', 'Missile air-air à guidage infrarouge, portée 80 km'),
('MICA EM', 'Missile air-air à guidage radar actif, portée 80 km'),
('Meteor', 'Missile air-air longue portée, guidage radar actif, 100-150 km'),
('AIM-9 Sidewinder', 'Missile air-air courte portée, guidage infrarouge, 18 km'),

-- Missiles air-sol
('AS-30', 'Missile air-sol, guidage radio'),
('AS-30L', 'Missile air-sol, guidage laser, portée 11 km'),
('AS-37 Martel', 'Missile air-sol anti-radar ou guidage TV, portée 60 km'),
('Apache', 'Missile de croisière anti-piste, portée 140 km'),
('SCALP EG', 'Missile de croisière, portée 500 km'),
('AGM-65 Maverick', 'Missile air-sol à guidage optique/TV, portée 27 km'),
('AASM Hammer', 'Bombe guidée avec kit de propulsion, portée 70 km'),
('AS-20', 'Missile air-sol, guidage radio, portée 7 km'),

-- Missiles antinavires
('AM39 Exocet', 'Missile antinavire, portée 70 km'),

-- Armement nucléaire
('AN-11', 'Bombe nucléaire à chute libre, utilisée sur Mirage IV'),
('AN-22', 'Bombe nucléaire à chute libre améliorée, utilisée sur Mirage IV'),
('ASMP', 'Missile nucléaire, portée 300 km'),
('ASMP-A', 'Missile nucléaire amélioré, portée 500 km'),

-- Bombes
('Bombe lisse 250 kg', 'Bombe conventionnelle non guidée, 250 kg'),
('Bombe lisse 400 kg', 'Bombe conventionnelle non guidée, 400 kg'),
('Bombe lisse 500 kg', 'Bombe conventionnelle non guidée, 500 kg'),
('Bombe lisse 1000 kg', 'Bombe conventionnelle non guidée, 1000 kg'),
('GBU-12 Paveway II', 'Bombe guidée laser, 224 kg'),
('GBU-24 Paveway III', 'Bombe guidée laser, portée accrue'),
('BL755', 'Bombe à sous-munitions, utilisée sur Jaguar'),
('JDAM', 'Kit de guidage GPS pour bombes, portée 24 km'),

-- Roquettes
('SNEB 68 mm', 'Roquettes non guidées, pod de 68 mm'),
('Zuni 127 mm', 'Roquettes non guidées, pod de 127 mm, utilisées sur F-8 Crusader')
ON CONFLICT (name) DO NOTHING;

--États-Unis
INSERT INTO armement (name, description) VALUES
-- Canons
('M61 Vulcan', 'Canon rotatif 20 mm, 6000 coups/min, capacité adaptée selon avion'),
('GAU-8 Avenger', 'Canon rotatif 30 mm, 3900 coups/min, utilisé sur A-10'),
('Colt Mk 12', 'Canon de 20 mm, 125 coups par canon'), -- Déjà présent mais inclus pour référence

-- Missiles air-air
('AIM-7 Sparrow', 'Missile moyenne portée, guidage radar semi-actif, 70 km'),
('AIM-9 Sidewinder', 'Missile courte portée, guidage infrarouge, 18 km'),
('AIM-54 Phoenix', 'Missile longue portée, guidage radar actif, 190 km'),
('AIM-120 AMRAAM', 'Missile moyenne/longue portée, guidage radar actif, 120 km'),

-- Missiles air-sol
('AGM-12 Bullpup', 'Missile air-sol, guidage radio, 10 km'),
('AGM-45 Shrike', 'Missile anti-radar, portée 40 km'),
('AGM-65 Maverick', 'Missile air-sol, guidage optique/TV/IR, 27 km'),
('AGM-78 Standard ARM', 'Missile anti-radar, portée 90 km'),
('AGM-84 Harpoon', 'Missile antinavire, portée 124 km'),
('AGM-88 HARM', 'Missile anti-radar, portée 150 km'),
('AGM-114 Hellfire', 'Missile air-sol, guidage laser, 8 km'),
('AGM-130', 'Missile air-sol guidé, portée 64 km'),
('AGM-154 JSOW', 'Arme stand-off, guidage GPS/INS, 130 km'),
('AGM-158 JASSM', 'Missile de croisière furtif, portée 370-1000 km'),

-- Bombes nucléaires
('B28', 'Bombe nucléaire à chute libre, 1.45 Mt'),
('B43', 'Bombe nucléaire à chute libre, 1 Mt'),
('B61', 'Bombe nucléaire tactique, rendement variable'),
('B83', 'Bombe nucléaire stratégique, 1.2 Mt'),

-- Bombes conventionnelles
('Mk 82', 'Bombe lisse 227 kg'),
('Mk 83', 'Bombe lisse 454 kg'),
('Mk 84', 'Bombe lisse 907 kg'),
('GBU-10 Paveway II', 'Bombe guidée laser, 907 kg'),
('GBU-12 Paveway II', 'Bombe guidée laser, 227 kg'),
('GBU-16 Paveway II', 'Bombe guidée laser, 454 kg'),
('GBU-24 Paveway III', 'Bombe guidée laser, 907 kg'),
('GBU-27 Paveway III', 'Bombe guidée laser furtive, 907 kg'),
('GBU-31 JDAM', 'Bombe guidée GPS, 907 kg'),
('GBU-38 JDAM', 'Bombe guidée GPS, 227 kg'),
('GBU-39 SDB', 'Petite bombe guidée, 113 kg'),
('CBU-87', 'Bombe à sous-munitions, 430 kg'),
('CBU-97', 'Bombe à sous-munitions avec capteurs, 430 kg'),

-- Roquettes
('Zuni 127 mm', 'Roquettes non guidées, pod de 127 mm'),
('Hydra 70', 'Roquettes non guidées, 70 mm')
ON CONFLICT (name) DO NOTHING;

-- Russie
INSERT INTO armement (name, description) VALUES
-- Canons
('GSh-23', 'Canon double de 23 mm, 3400 coups/min, utilisé sur MiG-21/23, Su-15/17/24'),
('GSh-30-1', 'Canon de 30 mm, 1500 coups/min, utilisé sur MiG-29, Su-25/27/30/34/35'),
('GSh-30-2', 'Canon double de 30 mm, 3000 coups/min, utilisé sur Su-25'),
('NR-30', 'Canon de 30 mm, 850 coups/min, utilisé sur MiG-25/31'),
('GSh-6-23', 'Canon rotatif 23 mm, 6000 coups/min, utilisé sur MiG-31, Tu-22M'),

-- Missiles air-air
('R-3S', 'Missile courte portée, guidage infrarouge, 8 km, équivalent AA-2 Atoll'),
('R-13M', 'Missile courte portée, guidage infrarouge, 15 km, amélioration du R-3S'),
('R-23R', 'Missile moyenne portée, guidage radar semi-actif, 35 km'),
('R-23T', 'Missile moyenne portée, guidage infrarouge, 35 km'),
('R-24R', 'Missile moyenne portée, guidage radar semi-actif, 50 km, version améliorée du R-23'),
('R-24T', 'Missile moyenne portée, guidage infrarouge, 50 km'),
('R-27R', 'Missile moyenne portée, guidage radar semi-actif, 80 km'),
('R-27T', 'Missile moyenne portée, guidage infrarouge, 70 km'),
('R-33', 'Missile longue portée, guidage radar semi-actif, 120 km'),
('R-37', 'Missile très longue portée, guidage radar actif, 300 km'),
('R-40R', 'Missile longue portée, guidage radar semi-actif, 80 km'),
('R-40T', 'Missile longue portée, guidage infrarouge, 80 km'),
('R-60', 'Missile courte portée, guidage infrarouge, 8 km, équivalent AA-8 Aphid'),
('R-73', 'Missile courte portée, guidage infrarouge, 30 km, équivalent AA-11 Archer'),
('R-77', 'Missile moyenne/longue portée, guidage radar actif, 110 km, équivalent AA-12 Adder'),

-- Missiles air-sol
('Kh-23', 'Missile air-sol, guidage radio, 10 km'),
('Kh-25ML', 'Missile air-sol, guidage laser, 20 km'),
('Kh-29L', 'Missile air-sol, guidage laser, 30 km'),
('Kh-29T', 'Missile air-sol, guidage TV, 30 km'),
('Kh-31P', 'Missile anti-radar, portée 110 km'),
('Kh-31A', 'Missile antinavire, portée 110 km'),
('Kh-35', 'Missile antinavire, portée 130 km'),
('Kh-58', 'Missile anti-radar, portée 120 km'),
('Kh-59', 'Missile air-sol, guidage TV, 115 km'),
('Kh-66', 'Missile air-sol, guidage radio, 10 km'),
('S-25L', 'Roquette guidée laser, 340 mm'),

-- Missiles antinavires et de croisière
('Kh-15', 'Missile balistique air-sol, portée 300 km'),
('Kh-22', 'Missile antinavire supersonique, portée 600 km'),
('Kh-55', 'Missile de croisière, portée 2500 km'),
('Kh-101', 'Missile de croisière conventionnel, portée 3000 km'),
('Kh-102', 'Missile de croisière nucléaire, portée 3000 km'),

-- Armement nucléaire
('RN-28', 'Bombe nucléaire tactique à chute libre'),
('TN-1000', 'Bombe nucléaire à chute libre, 1 Mt'),

-- Bombes conventionnelles
('FAB-250', 'Bombe lisse 250 kg'),
('FAB-500', 'Bombe lisse 500 kg'),
('FAB-1000', 'Bombe lisse 1000 kg'),
('FAB-1500', 'Bombe lisse 1500 kg'),
('KAB-500L', 'Bombe guidée laser, 500 kg'),
('KAB-1500L', 'Bombe guidée laser, 1500 kg'),
('BetAB-500', 'Bombe anti-bunker, 500 kg'),
('ODAB-500', 'Bombe thermobarique, 500 kg'),

-- Roquettes
('S-5', 'Roquettes non guidées, 57 mm'),
('S-8', 'Roquettes non guidées, 80 mm'),
('S-13', 'Roquettes non guidées, 122 mm'),
('S-24', 'Roquettes non guidées, 240 mm'),
('S-25', 'Roquettes non guidées, 340 mm')
ON CONFLICT (name) DO NOTHING;

--Chine
INSERT INTO armement (name, description) VALUES
-- Canons
('NR-23', 'Canon de 23 mm, 900 coups/min, utilisé sur J-5/J-6'),
('NR-30', 'Canon de 30 mm, 850 coups/min, utilisé sur J-6/J-7'),
('Type 23-1', 'Canon de 23 mm, copie chinoise du NR-23, utilisé sur J-7/J-8'),
('Type 30-1', 'Canon de 30 mm, copie chinoise du NR-30, utilisé sur J-8/Q-5'),
('GSh-23', 'Canon double de 23 mm, 3400 coups/min, utilisé sur J-11/J-15/J-16'),
('GSh-30-1', 'Canon de 30 mm, 1500 coups/min, utilisé sur J-10/JF-17'),

-- Missiles air-air
('PL-2', 'Missile courte portée, guidage infrarouge, 6 km, copie du R-3S'),
('PL-5', 'Missile courte portée, guidage infrarouge, 16 km'),
('PL-7', 'Missile courte portée, guidage infrarouge, 15 km, basé sur Matra R550 Magic'),
('PL-8', 'Missile courte portée, guidage infrarouge, 20 km, basé sur Python-3'),
('PL-9', 'Missile courte portée, guidage infrarouge, 22 km'),
('PL-10', 'Missile courte portée, guidage infrarouge, 20 km, haute manœuvrabilité'),
('PL-12', 'Missile moyenne/longue portée, guidage radar actif, 100 km'),
('PL-15', 'Missile longue portée, guidage radar actif, 200-300 km'),
('PL-17', 'Missile très longue portée, guidage radar actif, 400 km'),

-- Missiles air-sol
('KD-88', 'Missile air-sol, guidage TV/électro-optique, 180 km'),
('Kh-29L', 'Missile air-sol, guidage laser, 30 km'),
('Kh-29T', 'Missile air-sol, guidage TV, 30 km'),
('Kh-31P', 'Missile anti-radar, portée 110 km'),
('Kh-31A', 'Missile antinavire, portée 110 km'),
('Kh-59', 'Missile air-sol, guidage TV, 115 km'),
('YJ-83', 'Missile antinavire, portée 180 km'),
('YJ-91', 'Missile anti-radar/antinavire, portée 120 km'),
('C-701', 'Missile air-sol/antinavire, guidage TV/IR, 25 km'),
('C-802', 'Missile antinavire, portée 120 km'),
('TL-10', 'Missile antinavire léger, guidage TV/IR, 18 km'),

-- Missiles de croisière
('CJ-10', 'Missile de croisière, portée 2000 km, utilisé sur H-6'),
('Kh-55', 'Missile de croisière, portée 2500 km, utilisé sur H-6'),
('KD-20', 'Missile de croisière, portée 1800-2500 km, dérivé du CJ-10'),

-- Bombes
('FAB-250', 'Bombe lisse 250 kg'),
('FAB-500', 'Bombe lisse 500 kg'),
('FAB-1000', 'Bombe lisse 1000 kg'),
('LT-2', 'Bombe guidée laser, 500 kg'),
('LS-6', 'Bombe guidée par GPS/glide, 500 kg'),
('GBU-250', 'Bombe guidée chinoise, 250 kg'),
('KAB-500L', 'Bombe guidée laser, 500 kg'),
('Type 200A', 'Bombe anti-piste, 500 kg'),

-- Roquettes
('S-5', 'Roquettes non guidées, 57 mm'),
('S-8', 'Roquettes non guidées, 80 mm'),
('Type 90-1', 'Roquettes non guidées, 90 mm'),
('HF-16', 'Roquettes non guidées, 57 mm, copie chinoise du S-5')
ON CONFLICT (name) DO NOTHING;

--Royaume-Unis
INSERT INTO armement (name, description) VALUES
-- Canons
('ADEN 30 mm', 'Canon de 30 mm, 1300 coups/min, utilisé sur Lightning, Harrier, Sea Harrier, Buccaneer'),
('GAU-12 Equalizer', 'Canon rotatif 25 mm, 3600 coups/min, utilisé sur Harrier GR.9/AV-8B'),
('Mauser BK-27', 'Canon de 27 mm, 1700 coups/min, utilisé sur Tornado et Typhoon'),
('M61 Vulcan', 'Canon rotatif 20 mm, 6000 coups/min, utilisé sur F-35B'),

-- Missiles air-air
('Firestreak', 'Missile courte portée, guidage infrarouge, 15 km, utilisé sur Lightning'),
('Red Top', 'Missile courte portée, guidage infrarouge, 12 km, utilisé sur Lightning'),
('Skyflash', 'Missile moyenne portée, guidage radar semi-actif, 45 km, basé sur AIM-7'),
('AIM-9 Sidewinder', 'Missile courte portée, guidage infrarouge, 18 km'),
('AIM-120 AMRAAM', 'Missile moyenne/longue portée, guidage radar actif, 120 km'),
('Meteor', 'Missile longue portée, guidage radar actif, 100-150 km'),
('ASRAAM', 'Missile courte portée, guidage infrarouge, 50 km'),

-- Missiles air-sol
('Martel AJ-168', 'Missile air-sol, guidage TV, 60 km, utilisé sur Buccaneer'),
('Martel AS-37', 'Missile anti-radar, portée 60 km, utilisé sur Buccaneer'),
('AGM-65 Maverick', 'Missile air-sol, guidage optique/TV/IR, 27 km'),
('Brimstone', 'Missile air-sol, guidage radar/laser, 60 km'),
('Storm Shadow', 'Missile de croisière, portée 560 km, équivalent britannique du SCALP EG'),
('AGM-114 Hellfire', 'Missile air-sol, guidage laser, 8 km'),
('AGM-154 JSOW', 'Arme stand-off, guidage GPS/INS, 130 km'),

-- Missiles antinavires
('Sea Eagle', 'Missile antinavire, portée 110 km, utilisé sur Buccaneer, Sea Harrier, Tornado'),
('Sea Skua', 'Missile antinavire léger, portée 25 km, utilisé sur Sea Harrier'),

-- Armement nucléaire
('WE.177', 'Bombe nucléaire à chute libre, 10-400 kt, utilisée sur Vulcan, Buccaneer, Tornado'),
('B61', 'Bombe nucléaire tactique, rendement variable, utilisée sur F-35B'),

-- Bombes conventionnelles
('BL755', 'Bombe à sous-munitions, 430 kg'),
('Paveway II', 'Bombe guidée laser, 227-454 kg, équivalent GBU-12/16'),
('Paveway III', 'Bombe guidée laser, 907 kg, équivalent GBU-24'),
('Paveway IV', 'Bombe guidée laser/GPS, 227 kg'),
('GBU-10 Paveway II', 'Bombe guidée laser, 907 kg'),
('GBU-12 Paveway II', 'Bombe guidée laser, 227 kg'),
('GBU-16 Paveway II', 'Bombe guidée laser, 454 kg'),
('GBU-31 JDAM', 'Bombe guidée GPS, 907 kg'),
('GBU-38 JDAM', 'Bombe guidée GPS, 227 kg'),
('Mk 82', 'Bombe lisse 227 kg'),
('Mk 83', 'Bombe lisse 454 kg'),
('Mk 84', 'Bombe lisse 907 kg'),
('1000 lb GP', 'Bombe lisse 454 kg, utilisée sur Vulcan, Buccaneer'),

-- Roquettes
('CRV7', 'Roquettes non guidées, 70 mm, utilisées sur Harrier'),
('SNEB 68 mm', 'Roquettes non guidées, pod de 68 mm'),
('Zuni 127 mm', 'Roquettes non guidées, pod de 127 mm')
ON CONFLICT (name) DO NOTHING;

--Allemagne
INSERT INTO armement (name, description) VALUES
-- Canons
('M61 Vulcan', 'Canon rotatif 20 mm, 6000 coups/min, utilisé sur F-104, F-4, Typhoon'),
('GSh-23', 'Canon double de 23 mm, 3400 coups/min, utilisé sur MiG-21/23'),
('NR-30', 'Canon de 30 mm, 850 coups/min, utilisé sur MiG-21'),
('GSh-30-1', 'Canon de 30 mm, 1500 coups/min, utilisé sur MiG-29'),
('Mauser BK-27', 'Canon de 27 mm, 1700 coups/min, utilisé sur Tornado et Typhoon'),
('DEFA 553', 'Canon de 30 mm, 1350 coups/min, utilisé sur Alpha Jet'),

-- Missiles air-air
('AIM-9 Sidewinder', 'Missile courte portée, guidage infrarouge, 18 km'),
('AIM-7 Sparrow', 'Missile moyenne portée, guidage radar semi-actif, 70 km'),
('AIM-120 AMRAAM', 'Missile moyenne/longue portée, guidage radar actif, 120 km'),
('Meteor', 'Missile longue portée, guidage radar actif, 100-150 km'),
('ASRAAM', 'Missile courte portée, guidage infrarouge, 50 km'),
('R-3S', 'Missile courte portée, guidage infrarouge, 8 km, équivalent AA-2 Atoll'),
('R-13M', 'Missile courte portée, guidage infrarouge, 15 km'),
('R-23R', 'Missile moyenne portée, guidage radar semi-actif, 35 km'),
('R-23T', 'Missile moyenne portée, guidage infrarouge, 35 km'),
('R-24R', 'Missile moyenne portée, guidage radar semi-actif, 50 km'),
('R-24T', 'Missile moyenne portée, guidage infrarouge, 50 km'),
('R-27R', 'Missile moyenne portée, guidage radar semi-actif, 80 km'),
('R-27T', 'Missile moyenne portée, guidage infrarouge, 70 km'),
('R-60', 'Missile courte portée, guidage infrarouge, 8 km, équivalent AA-8 Aphid'),
('R-73', 'Missile courte portée, guidage infrarouge, 30 km, équivalent AA-11 Archer'),
('R-77', 'Missile moyenne/longue portée, guidage radar actif, 110 km, équivalent AA-12 Adder'),

-- Missiles air-sol
('AGM-12 Bullpup', 'Missile air-sol, guidage radio, 10 km'),
('AGM-65 Maverick', 'Missile air-sol, guidage optique/TV/IR, 27 km'),
('Brimstone', 'Missile air-sol, guidage radar/laser, 60 km'),
('Storm Shadow', 'Missile de croisière, portée 560 km, équivalent britannique du SCALP EG'),
('Kh-23', 'Missile air-sol, guidage radio, 10 km'),
('Kh-25ML', 'Missile air-sol, guidage laser, 20 km'),
('Kh-29L', 'Missile air-sol, guidage laser, 30 km'),
('Kh-66', 'Missile air-sol, guidage radio, 10 km'),

-- Armement nucléaire
('B61', 'Bombe nucléaire tactique, rendement variable, utilisée sur F-4, Tornado'),
('WE.177', 'Bombe nucléaire à chute libre, 10-400 kt, utilisée sur Tornado'),

-- Bombes conventionnelles
('Mk 82', 'Bombe lisse 227 kg'),
('Mk 83', 'Bombe lisse 454 kg'),
('Mk 84', 'Bombe lisse 907 kg'),
('GBU-10 Paveway II', 'Bombe guidée laser, 907 kg'),
('GBU-12 Paveway II', 'Bombe guidée laser, 227 kg'),
('GBU-16 Paveway II', 'Bombe guidée laser, 454 kg'),
('GBU-24 Paveway III', 'Bombe guidée laser, 907 kg'),
('Paveway IV', 'Bombe guidée laser/GPS, 227 kg'),
('FAB-250', 'Bombe lisse 250 kg'),
('FAB-500', 'Bombe lisse 500 kg'),
('BL755', 'Bombe à sous-munitions, 430 kg'),

-- Roquettes
('Zuni 127 mm', 'Roquettes non guidées, pod de 127 mm'),
('S-5', 'Roquettes non guidées, 57 mm'),
('S-8', 'Roquettes non guidées, 80 mm'),
('SNEB 68 mm', 'Roquettes non guidées, pod de 68 mm')
ON CONFLICT (name) DO NOTHING;

--Italie
INSERT INTO armement (name, description) VALUES
-- Canons
('M61 Vulcan', 'Canon rotatif 20 mm, 6000 coups/min, utilisé sur F-104, F-35'),
('Mauser BK-27', 'Canon de 27 mm, 1700 coups/min, utilisé sur Tornado et Typhoon'),
('DEFA 553', 'Canon de 30 mm, 1350 coups/min, utilisé sur AMX'),
('Beretta-Colt M12', 'Canon de 20 mm, utilisé sur MB-339, variante italienne'),

-- Missiles air-air
('AIM-7 Sparrow', 'Missile moyenne portée, guidage radar semi-actif, 70 km'),
('AIM-9 Sidewinder', 'Missile courte portée, guidage infrarouge, 18 km'),
('AIM-120 AMRAAM', 'Missile moyenne/longue portée, guidage radar actif, 120 km'),
('Meteor', 'Missile longue portée, guidage radar actif, 100-150 km'),
('ASRAAM', 'Missile courte portée, guidage infrarouge, 50 km'),
('Aspide', 'Missile moyenne portée, guidage radar semi-actif, 40 km, dérivé italien de l’AIM-7'),

-- Missiles air-sol
('AGM-65 Maverick', 'Missile air-sol, guidage optique/TV/IR, 27 km'),
('AGM-88 HARM', 'Missile anti-radar, portée 150 km'),
('Brimstone', 'Missile air-sol, guidage radar/laser, 60 km'),
('Storm Shadow', 'Missile de croisière, portée 560 km, équivalent britannique du SCALP EG'),
('MAR-1', 'Missile anti-radar, portée 60 km, utilisé sur AMX exporté'),

-- Armement nucléaire
('B61', 'Bombe nucléaire tactique, rendement variable, utilisée sur F-104, Tornado, F-35'),

-- Bombes conventionnelles
('Mk 82', 'Bombe lisse 227 kg'),
('Mk 83', 'Bombe lisse 454 kg'),
('Mk 84', 'Bombe lisse 907 kg'),
('GBU-10 Paveway II', 'Bombe guidée laser, 907 kg'),
('GBU-12 Paveway II', 'Bombe guidée laser, 227 kg'),
('GBU-16 Paveway II', 'Bombe guidée laser, 454 kg'),
('GBU-24 Paveway III', 'Bombe guidée laser, 907 kg'),
('GBU-31 JDAM', 'Bombe guidée GPS, 907 kg'),
('GBU-38 JDAM', 'Bombe guidée GPS, 227 kg'),
('GBU-39 SDB', 'Petite bombe guidée, 113 kg'),
('Paveway IV', 'Bombe guidée laser/GPS, 227 kg'),
('BL755', 'Bombe à sous-munitions, 430 kg'),

-- Roquettes
('SNEB 68 mm', 'Roquettes non guidées, pod de 68 mm'),
('Zuni 127 mm', 'Roquettes non guidées, pod de 127 mm'),
('Hydra 70', 'Roquettes non guidées, 70 mm')
ON CONFLICT (name) DO NOTHING;

--Suède
INSERT INTO armement (name, description) VALUES
-- Canons
('ADEN 30 mm', 'Canon de 30 mm, 1300 coups/min, utilisé sur Draken et Viggen'),
('Mauser BK-27', 'Canon de 27 mm, 1700 coups/min, utilisé sur Gripen'),

-- Missiles air-air
('AIM-9 Sidewinder', 'Missile courte portée, guidage infrarouge, 18 km, versions Rb 24/74 sur Draken/Viggen'),
('Rb 24', 'Missile courte portée, guidage infrarouge, basé sur AIM-9B, utilisé sur Draken'),
('Rb 74', 'Missile courte portée, guidage infrarouge, basé sur AIM-9L, utilisé sur Viggen'),
('Rb 71', 'Missile moyenne portée, guidage radar semi-actif, 45 km, basé sur Skyflash'),
('Rb 99', 'Missile moyenne/longue portée, guidage radar actif, 120 km, basé sur AIM-120 AMRAAM'),
('Meteor', 'Missile longue portée, guidage radar actif, 100-150 km'),
('IRIS-T', 'Missile courte portée, guidage infrarouge, 25 km, équivalent ASRAAM'),

-- Missiles air-sol
('Rb 04', 'Missile antinavire, portée 32 km, utilisé sur Draken et Viggen'),
('Rb 05', 'Missile air-sol, guidage manuel/radio, 9 km, utilisé sur Draken et Viggen'),
('Rb 15', 'Missile antinavire, portée 70-200 km, utilisé sur Viggen et Gripen'),
('Rb 75', 'Missile air-sol, guidage TV, 27 km, basé sur AGM-65 Maverick'),
('KEPD 350', 'Missile de croisière, portée 500 km, équivalent suédois du Storm Shadow'),
('RBS-17', 'Missile antinavire, guidage laser/radar, 8 km, adaptation du Hellfire'),
('GBU-49', 'Bombe guidée laser/GPS, 227 kg, utilisée sur Gripen'),

-- Bombes conventionnelles
('M/71 120 kg', 'Bombe lisse 120 kg, utilisée sur Draken et Viggen'),
('M/71 500 kg', 'Bombe lisse 500 kg, utilisée sur Viggen'),
('GBU-12 Paveway II', 'Bombe guidée laser, 227 kg'),
('GBU-16 Paveway II', 'Bombe guidée laser, 454 kg'),
('GBU-39 SDB', 'Petite bombe guidée, 113 kg'),
('Mk 82', 'Bombe lisse 227 kg'),
('Mk 83', 'Bombe lisse 454 kg'),
('Mk 84', 'Bombe lisse 907 kg'),

-- Roquettes
('SNEB 68 mm', 'Roquettes non guidées, pod de 68 mm'),
('Bofors 135 mm', 'Roquettes non guidées, 135 mm, utilisées sur Draken et Viggen')
ON CONFLICT (name) DO NOTHING;

--Inde
-- Canons
INSERT INTO armement (name, description) VALUES
('ADEN 30 mm', 'Canon de 30 mm, 1300 coups/min'),
('GSh-23L', 'Canon double de 23 mm, 3400 coups/min'),
('GSh-30-1', 'Canon de 30 mm, 1500 coups/min'),
('GIAT 30M791', 'Canon de 30 mm, 125 coups'),

-- Missiles air-air
('R.550 Magic', 'Missile air-air courte portée, guidage infrarouge, 15 km'),
('Derby', 'Missile air-air moyenne portée, guidage radar actif, 50 km'),
('R-73', 'Missile courte portée, guidage infrarouge, 30 km'),
('R-77', 'Missile moyenne/longue portée, guidage radar actif, 110 km'),
('MICA IR', 'Missile air-air à guidage infrarouge, portée 80 km'),
('Meteor', 'Missile longue portée, guidage radar actif, 150 km'),

-- Missiles air-sol
('Griffin', 'Bombe guidée laser, 225 kg'),
('Brahmos', 'Missile antinavire supersonique, portée 290 km'),
('Kh-29T', 'Missile air-sol, guidage TV, 30 km'),
('Kh-31P', 'Missile anti-radar, portée 110 km'),
('SCALP EG', 'Missile de croisière, portée 500 km'),
('AASM Hammer', 'Bombe guidée avec kit de propulsion, portée 70 km'),
('Martel AJ-168', 'Missile air-sol, guidage TV, 60 km'),

-- Missiles antinavires
('Exocet AM39', 'Missile antinavire, portée 70 km'),
('Kh-35', 'Missile antinavire, portée 130 km'),

-- Bombes
('OFAB-250', 'Bombe lisse 250 kg'),
('OFAB-500', 'Bombe lisse 500 kg'),
('KAB-500L', 'Bombe guidée laser, 500 kg'),
('FAB-1500', 'Bombe lisse 1500 kg, capacité stratégique'),
('BL755', 'Bombe à sous-munitions, 430 kg'),
('BAP 100', 'Bombe anti-piste'),
('WE.177', 'Bombe nucléaire à chute libre, 10-400 kt'),

-- Roquettes
('HVAR 70 mm', 'Roquettes non guidées, 70 mm'),
('SNEB 68 mm', 'Roquettes non guidées, pod de 68 mm'),

-- Torpilles et armes anti-sous-marines
('APR-3', 'Torpille légère anti-sous-marine, guidage acoustique'),
('RGB-75', 'Bouée acoustique pour détection sous-marine')
ON CONFLICT (name) DO NOTHING;

--Japon
-- Canons
INSERT INTO armement (name, description) VALUES
('M61 Vulcan', 'Canon rotatif 20 mm, 6000 coups/min'),
('JM61A1', 'Variante japonaise du M61 Vulcan'),

-- Missiles air-air
('AIM-9 Sidewinder', 'Missile courte portée, guidage infrarouge, 18 km'),
('AIM-7 Sparrow', 'Missile moyenne portée, guidage radar semi-actif, 70 km'),
('AIM-120 AMRAAM', 'Missile moyenne/longue portée, guidage radar actif, 120 km'),
('AAM-3', 'Missile courte portée, guidage infrarouge, version japonaise améliorée de l’AIM-9'),
('AAM-4', 'Missile moyenne/longue portée, guidage radar actif, version japonaise de l’AIM-120'),
('AAM-5', 'Missile courte portée, guidage infrarouge, version japonaise avancée'),

-- Missiles air-sol
('ASM-1', 'Missile antinavire, guidage radar actif, portée 50 km'),
('ASM-2', 'Missile antinavire, guidage radar actif, portée 100 km'),
('AGM-65 Maverick', 'Missile air-sol, guidage optique/TV/IR, 27 km'),
('JDAM', 'Kit de guidage GPS pour bombes, portée 24 km'),
('GBU-12 Paveway II', 'Bombe guidée laser, 227 kg'),
('GBU-31 JDAM', 'Bombe guidée GPS, 907 kg'),

-- Bombes
('Mk 82', 'Bombe lisse 227 kg'),
('Mk 84', 'Bombe lisse 907 kg'),
('CBU-87', 'Bombe à sous-munitions, 430 kg'),
('CBU-97', 'Bombe à sous-munitions avec capteurs, 430 kg'),

-- Roquettes
('CRV7', 'Roquettes non guidées, 70 mm'),
('Hydra 70', 'Roquettes non guidées, 70 mm')
ON CONFLICT (name) DO NOTHING;

--Brésil
-- Canons
INSERT INTO armement (name, description) VALUES
('M39', 'Canon de 20 mm'),
('DEFA 552', 'Canon de 30 mm'),
('GIAT 30M791', 'Canon de 30 mm'),
('Mauser BK-27', 'Canon de 27 mm'),
('GAU-12 Equalizer', 'Canon rotatif 25 mm'),

-- Missiles air-air
('AIM-9 Sidewinder', 'Missile courte portée, guidage infrarouge, 18 km'),
('Matra R550 Magic', 'Missile courte portée, guidage infrarouge, 15 km'),
('MICA IR', 'Missile air-air à guidage infrarouge, portée 80 km'),
('MICA EM', 'Missile air-air à guidage radar actif, portée 80 km'),
('Meteor', 'Missile longue portée, guidage radar actif, 100-150 km'),
('IRIS-T', 'Missile courte portée, guidage infrarouge, 25 km'),
('AIM-120 AMRAAM', 'Missile moyenne/longue portée, guidage radar actif, 120 km'),

-- Missiles air-sol
('AGM-65 Maverick', 'Missile air-sol, guidage optique/TV/IR, 27 km'),
('AS-30L', 'Missile air-sol, guidage laser, portée 11 km'),
('SCALP EG', 'Missile de croisière, portée 500 km'),
('AASM Hammer', 'Bombe guidée avec kit de propulsion, portée 70 km'),
('Brimstone', 'Missile air-sol, guidage radar/laser, 60 km'),
('Marte Mk2A', 'Missile antinavire, portée 30 km'),

-- Bombes
('Mk 82', 'Bombe lisse 227 kg'),
('Mk 84', 'Bombe lisse 907 kg'),
('GBU-12 Paveway II', 'Bombe guidée laser, 227 kg'),
('GBU-16 Paveway II', 'Bombe guidée laser, 454 kg'),
('GBU-24 Paveway III', 'Bombe guidée laser, 907 kg'),
('BL755', 'Bombe à sous-munitions, 430 kg'),
('CBU-97', 'Bombe à sous-munitions avec capteurs, 430 kg'),

-- Roquettes
('SNEB 68 mm', 'Roquettes non guidées, pod de 68 mm'),
('Hydra 70', 'Roquettes non guidées, 70 mm'),
('CRV7', 'Roquettes non guidées, 70 mm')
ON CONFLICT (name) DO NOTHING;

--Israël
-- Canons
INSERT INTO armement (name, description) VALUES
('DEFA 552', 'Canon de 30 mm, 125 coups par canon'),
('DEFA 553', 'Canon de 30 mm, 135-150 coups par canon'),
('M61 Vulcan', 'Canon rotatif 20 mm, 6000 coups/min'),
('GAU-12 Equalizer', 'Canon rotatif 25 mm, 3600 coups/min'),
('Mauser BK-27', 'Canon de 27 mm, 1700 coups/min'),

-- Missiles air-air
('Matra R530', 'Missile moyenne portée, guidage radar semi-actif ou infrarouge'),
('Matra R550 Magic', 'Missile courte portée, guidage infrarouge'),
('MICA IR', 'Missile air-air à guidage infrarouge, portée 80 km'),
('MICA EM', 'Missile air-air à guidage radar actif, portée 80 km'),
('AIM-9 Sidewinder', 'Missile courte portée, guidage infrarouge, 18 km'),
('AIM-7 Sparrow', 'Missile moyenne portée, guidage radar semi-actif, 70 km'),
('AIM-120 AMRAAM', 'Missile moyenne/longue portée, guidage radar actif, 120 km'),
('Python 3', 'Missile courte portée, guidage infrarouge, 15 km'),
('Python 4', 'Missile courte portée, guidage infrarouge, 20 km'),
('Python 5', 'Missile courte portée, guidage infrarouge, 20 km, haute manœuvrabilité'),
('Derby', 'Missile moyenne portée, guidage radar actif, 50 km'),
('Meteor', 'Missile longue portée, guidage radar actif, 100-150 km'),

-- Missiles air-sol
('AS-30', 'Missile air-sol, guidage radio'),
('AS-30L', 'Missile air-sol, guidage laser, portée 11 km'),
('AGM-65 Maverick', 'Missile air-sol, guidage optique/TV/IR, 27 km'),
('AGM-45 Shrike', 'Missile anti-radar, portée 40 km'),
('AGM-78 Standard ARM', 'Missile anti-radar, portée 90 km'),
('AGM-88 HARM', 'Missile anti-radar, portée 150 km'),
('AGM-114 Hellfire', 'Missile air-sol, guidage laser, 8 km'),
('AGM-154 JSOW', 'Arme stand-off, guidage GPS/INS, 130 km'),
('AGM-158 JASSM', 'Missile de croisière furtif, portée 370-1000 km'),
('SCALP EG', 'Missile de croisière, portée 500 km'),
('Popeye', 'Missile air-sol, guidage TV, portée 78 km'),
('Spice', 'Bombe guidée avec kit de propulsion, portée 60-100 km'),

-- Missiles antinavires
('AM39 Exocet', 'Missile antinavire, portée 70 km'),
('AGM-84 Harpoon', 'Missile antinavire, portée 124 km'),
('Gabriel', 'Missile antinavire, portée 36 km'),

-- Bombes
('Mk 82', 'Bombe lisse 227 kg'),
('Mk 83', 'Bombe lisse 454 kg'),
('Mk 84', 'Bombe lisse 907 kg'),
('GBU-10 Paveway II', 'Bombe guidée laser, 907 kg'),
('GBU-12 Paveway II', 'Bombe guidée laser, 227 kg'),
('GBU-16 Paveway II', 'Bombe guidée laser, 454 kg'),
('GBU-24 Paveway III', 'Bombe guidée laser, 907 kg'),
('GBU-31 JDAM', 'Bombe guidée GPS, 907 kg'),
('GBU-38 JDAM', 'Bombe guidée GPS, 227 kg'),
('GBU-39 SDB', 'Petite bombe guidée, 113 kg'),
('CBU-87', 'Bombe à sous-munitions, 430 kg'),
('CBU-97', 'Bombe à sous-munitions avec capteurs, 430 kg'),
('BL755', 'Bombe à sous-munitions, 430 kg'),

-- Roquettes
('SNEB 68 mm', 'Roquettes non guidées, pod de 68 mm'),
('Hydra 70', 'Roquettes non guidées, 70 mm'),
('Zuni 127 mm', 'Roquettes non guidées, pod de 127 mm')
ON CONFLICT (name) DO NOTHING;

-- Technologies génériques réutilisables
INSERT INTO tech (name, description) VALUES
-- Mirage III
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur à postcombustion', 'Moteur SNECMA Atar permettant des performances supersoniques'),
('Radar Cyrano', 'Radair monopulse Cyrano I/II pour interception et tir air-air'),
('Système de navigation semi-automatique', 'Intégration précoce d''un système de navigation inertielle'),

-- Mirage F1
('Aile en flèche', 'Configuration aérodynamique améliorant la maniabilité à basse vitesse'),
('Radar Cyrano IV', 'Radar multimode amélioré avec capacité de cartographie terrain'),
('Perche de ravitaillement en vol', 'Système de ravitaillement en vol fixe'),

-- Mirage 2000
('Commande de vol électrique (fly-by-wire)', 'Système numérique de contrôle de stabilité'),
('Radar RDM/RDI', 'Radar Doppler multi-mode pour détection air-air/air-sol'),
('Matériaux composites', 'Utilisation de carbone et kevlar dans la structure'),

-- Rafale
('Aile canard delta', 'Configuration aérodynamique combinant canards et aile delta'),
('Système SPECTRA', 'Suite complète de guerre électronique et contre-mesures'),
('Radar RBE2 AESA', 'Premier radar à antenne active européenne en service'),
('Fusion de capteurs', 'Intégration avancée des données radar/IR/ROEM'),

-- Super Étendard
('Système navalisé', 'Renforcement structurel et corrosion contrôlée pour porte-avions'),
('Liaison de données tactique', 'Système d''échange d''informations avec la flotte'),

-- F-8 Crusader
('Aile à incidence variable', 'Dispositif mécanique modifiant l''angle de l''aile en vol'),
('Système de caméra intégré', 'Caméra gunshot pour enregistrement des combats'),

-- Jaguar
('Système de navigation attaque à basse altitude', 'Couplage radar altimètre/ordinateur de navigation'),
('Pod désignateur laser', 'Capacité d''illumination laser pour bombes guidées'),

-- Mirage IV
('Système de ravitaillement en vol automatique', 'Perche de ravitaillement avec automate de connexion'),
('Soute à armement pressurisée', 'Soute spéciale pour armes nucléaires stratégiques')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tech (name, description) VALUES
-- F-4 Phantom II
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar AN/APQ-120', 'Radar de tir et de navigation multifonction'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- F-5 Freedom Fighter
('Aile en flèche légère', 'Conception légère pour une grande maniabilité'),
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),
('Canon M39', 'Canon de 20 mm à haute cadence de tir'),

-- F-111 Aardvark
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar de suivi de terrain', 'Radar permettant un vol à basse altitude en suivant le relief'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- F-14 Tomcat
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar AN/AWG-9', 'Radar à longue portée pour missiles AIM-54 Phoenix'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- F-15 Eagle
('Radar AN/APG-63', 'Radar Doppler à impulsions pour détection longue portée'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),
('Moteurs à poussée vectorielle', 'Moteurs permettant une grande maniabilité'),

-- F-16 Fighting Falcon
('Commande de vol électrique (fly-by-wire)', 'Système numérique de contrôle de stabilité'),
('Siège incliné', 'Siège incliné pour réduire les effets de la gravité sur le pilote'),
('Radar AN/APG-68', 'Radar Doppler multi-mode pour détection air-air/air-sol'),

-- B-1 Lancer
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- B-2 Spirit
('Conception furtive', 'Forme et matériaux réduisant la signature radar'),
('Système de gestion de mission avancé', 'Système intégré de navigation, d''attaque et de contre-mesures'),
('Matériaux composites', 'Utilisation de matériaux composites pour réduire la signature radar'),

-- F-22 Raptor
('Conception furtive', 'Forme et matériaux réduisant la signature radar'),
('Radar AN/APG-77', 'Radar à antenne active (AESA) pour détection longue portée'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- F-35 Lightning II
('Conception furtive', 'Forme et matériaux réduisant la signature radar'),
('Radar AN/APG-81', 'Radar à antenne active (AESA) pour détection longue portée'),
('Système de fusion de capteurs', 'Intégration des données radar, IR et ROEM'),

-- A-10 Thunderbolt II
('Canon GAU-8 Avenger', 'Canon rotatif de 30 mm à haute cadence de tir'),
('Blindage en titane', 'Blindage lourd pour protéger le pilote et les systèmes vitaux'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- SR-71 Blackbird
('Conception aérodynamique pour haute altitude', 'Forme optimisée pour le vol à haute altitude et haute vitesse'),
('Matériaux résistants à la chaleur', 'Utilisation de titane et de matériaux composites résistants à la chaleur'),
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),

-- B-52 Stratofortress
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),
('Moteurs à turbofan', 'Moteurs modernes pour améliorer l''efficacité et la portée')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tech (name, description) VALUES
-- MiG-21
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur Tumansky R-25', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar RP-21', 'Radar de tir et de navigation pour interception'),

-- MiG-23
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar RP-23', 'Radar de tir et de navigation multifonction'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- MiG-25
('Conception en acier inoxydable', 'Structure en acier pour résister aux hautes vitesses et températures'),
('Radar RP-25', 'Radar à longue portée pour interception à haute altitude'),
('Moteurs Tumansky R-15', 'Moteurs à postcombustion pour des vitesses supérieures à Mach 3'),

-- MiG-29
('Aile à forte flèche', 'Conception aérodynamique pour une grande maniabilité'),
('Radar N019', 'Radar Doppler pour détection air-air et air-sol'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- MiG-31
('Radar Zaslon', 'Radar à balayage électronique passif (PESA) pour détection longue portée'),
('Moteurs D-30F6', 'Moteurs à postcombustion pour des performances supersoniques'),
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),

-- Su-15
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Radar RP-15', 'Radar de tir et de navigation pour interception'),
('Moteurs Tumansky R-11', 'Moteurs à postcombustion pour des performances supersoniques'),

-- Su-17
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar Klen', 'Radar de tir et de navigation pour attaque au sol'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- Su-24
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar Puma', 'Radar de suivi de terrain pour vol à basse altitude'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- Su-25
('Blindage en titane', 'Blindage lourd pour protéger le pilote et les systèmes vitaux'),
('Canon GSh-30-2', 'Canon double de 30 mm à haute cadence de tir'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- Su-27
('Aile à forte flèche', 'Conception aérodynamique pour une grande maniabilité'),
('Radar N001', 'Radar Doppler pour détection air-air et air-sol'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- Su-30
('Radar N011M Bars', 'Radar à balayage électronique passif (PESA) pour détection longue portée'),
('Système de ravitaillement en vol', 'Perche de ravitaillement en vol intégrée'),
('Système de fusion de capteurs', 'Intégration des données radar, IR et ROEM'),

-- Su-34
('Poste de pilotage côte à côte', 'Configuration côte à côte pour les missions longues durées'),
('Radar V004', 'Radar à balayage électronique passif (PESA) pour détection air-air/air-sol'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- Su-35
('Radar Irbis-E', 'Radar à balayage électronique passif (PESA) pour détection longue portée'),
('Moteurs à poussée vectorielle', 'Moteurs permettant une grande maniabilité'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- Su-57
('Conception furtive', 'Forme et matériaux réduisant la signature radar'),
('Radar N036', 'Radar à antenne active (AESA) pour détection longue portée'),
('Système de fusion de capteurs', 'Intégration des données radar, IR et ROEM'),

-- Tu-22M
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar PN-AD', 'Radar de navigation et d''attaque pour missions de bombardement'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- Tu-95
('Moteurs à turbopropulseurs', 'Moteurs à hélices contrarotatives pour une grande autonomie'),
('Radar PN-AD', 'Radar de navigation et d''attaque pour missions de bombardement'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- Tu-160
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar Obzor-K', 'Radar de navigation et d''attaque pour missions de bombardement'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tech (name, description) VALUES
-- Shenyang J-5
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur Klimov VK-1', 'Moteur à postcombustion pour des performances supersoniques'),
('Canon NR-23', 'Canon de 23 mm à haute cadence de tir'),

-- Shenyang J-6
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur Tumansky R-9', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar RP-9', 'Radar de tir et de navigation pour interception'),

-- Shenyang J-7
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur WP-7', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar Type 226', 'Radar de tir et de navigation pour interception'),

-- Shenyang J-8
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur WP-13', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar Type 1471', 'Radar de tir et de navigation pour interception'),

-- Chengdu J-10
('Aile canard delta', 'Configuration aérodynamique combinant canards et aile delta'),
('Réacteur AL-31FN', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar Type 1473', 'Radar Doppler pour détection air-air et air-sol'),

-- Chengdu J-20
('Conception furtive', 'Forme et matériaux réduisant la signature radar'),
('Radar AESA', 'Radar à antenne active pour détection longue portée'),
('Système de fusion de capteurs', 'Intégration des données radar, IR et ROEM'),

-- Shenyang J-11
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur AL-31F', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar N001', 'Radar Doppler pour détection air-air et air-sol'),

-- Shenyang J-15
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur WS-10', 'Moteur à postcombustion pour des performances supersoniques'),
('Système de décollage et d''atterrissage sur porte-avions', 'Renforcement structurel et corrosion contrôlée pour porte-avions'),

-- Shenyang J-16
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur WS-10', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar AESA', 'Radar à antenne active pour détection longue portée'),

-- Xian H-6
('Moteurs à turbofan', 'Moteurs modernes pour améliorer l''efficacité et la portée'),
('Radar Type 242', 'Radar de navigation et d''attaque pour missions de bombardement'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- Nanchang Q-5
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur WP-6', 'Moteur à postcombustion pour des performances supersoniques'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- Hongdu JL-8
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur Honeywell TFE731', 'Moteur à turbofan pour des performances subsoniques'),
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),

-- Chengdu FC-1/JF-17
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur RD-93', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar KLJ-7', 'Radar Doppler pour détection air-air et air-sol')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tech (name, description) VALUES
-- English Electric Lightning
('Configuration bi-moteurs superposés', 'Moteurs empilés verticalement pour réduire la traînée'),
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Radar AI.23', 'Radar de tir et de navigation pour interception'),

-- Hawker Siddeley Harrier
('Moteur à poussée vectorielle', 'Moteur Rolls-Royce Pegasus permettant le décollage et l''atterrissage vertical (VTOL)'),
('Système de contrôle de réacteur', 'Système de contrôle numérique pour la gestion de la poussée vectorielle'),
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),

-- Panavia Tornado
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar multi-mode', 'Radar de suivi de terrain et de navigation pour missions air-air et air-sol'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- BAE Sea Harrier
('Moteur à poussée vectorielle', 'Moteur Rolls-Royce Pegasus permettant le décollage et l''atterrissage vertical (VTOL)'),
('Système de contrôle de réacteur', 'Système de contrôle numérique pour la gestion de la poussée vectorielle'),
('Radar Blue Fox', 'Radar de tir et de navigation pour interception'),

-- Eurofighter Typhoon
('Aile delta-canard', 'Configuration aérodynamique combinant canards et aile delta'),
('Radar CAPTOR', 'Radar à balayage électronique mécanique pour détection air-air et air-sol'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- Lockheed Martin F-35B Lightning II
('Moteur à poussée vectorielle', 'Moteur Pratt & Whitney F135 permettant le décollage et l''atterrissage vertical (VTOL)'),
('Conception furtive', 'Forme et matériaux réduisant la signature radar'),
('Radar AN/APG-81', 'Radar à antenne active (AESA) pour détection longue portée'),

-- Blackburn Buccaneer
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),
('Radar Blue Parrot', 'Radar de suivi de terrain pour missions de bombardement'),

-- Avro Vulcan
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),
('Radar H2S', 'Radar de navigation et de bombardement pour missions stratégiques')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tech (name, description) VALUES
-- Lockheed F-104 Starfighter
('Aile droite à faible allongement', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur General Electric J79', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar AN/ASG-14', 'Radar de tir et de navigation pour interception'),

-- McDonnell Douglas F-4 Phantom II
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Radar AN/APQ-120', 'Radar de tir et de navigation multifonction'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- Panavia Tornado
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar multi-mode', 'Radar de suivi de terrain et de navigation pour missions air-air et air-sol'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- Eurofighter Typhoon
('Aile delta-canard', 'Configuration aérodynamique combinant canards et aile delta'),
('Radar CAPTOR', 'Radar à balayage électronique mécanique pour détection air-air et air-sol'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- Mikoyan-Gourevitch MiG-21
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur Tumansky R-25', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar RP-21', 'Radar de tir et de navigation pour interception'),

-- Mikoyan-Gourevitch MiG-23
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar RP-23', 'Radar de tir et de navigation multifonction'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- Mikoyan-Gourevitch MiG-29
('Aile à forte flèche', 'Conception aérodynamique pour une grande maniabilité'),
('Radar N019', 'Radar Doppler pour détection air-air et air-sol'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- Dassault/Dornier Alpha Jet
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur Larzac 04', 'Moteur à double flux pour des performances subsoniques'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tech (name, description) VALUES
-- Lockheed F-104 Starfighter
('Aile droite à faible allongement', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur General Electric J79', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar AN/ASG-14', 'Radar de tir et de navigation pour interception'),

-- Aeritalia F-104S Starfighter
('Aile droite à faible allongement', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur General Electric J79', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar R21G/M1', 'Radar de tir et de navigation amélioré pour interception'),

-- Panavia Tornado
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar multi-mode', 'Radar de suivi de terrain et de navigation pour missions air-air et air-sol'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- Eurofighter Typhoon
('Aile delta-canard', 'Configuration aérodynamique combinant canards et aile delta'),
('Radar CAPTOR', 'Radar à balayage électronique mécanique pour détection air-air et air-sol'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- Lockheed Martin F-35 Lightning II
('Conception furtive', 'Forme et matériaux réduisant la signature radar'),
('Radar AN/APG-81', 'Radar à antenne active (AESA) pour détection longue portée'),
('Système de fusion de capteurs', 'Intégration des données radar, IR et ROEM'),

-- Aermacchi MB-339
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur Rolls-Royce Viper', 'Moteur à turboréacteur pour des performances subsoniques'),
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),

-- AMX International AMX
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur Rolls-Royce Spey', 'Moteur à turboréacteur pour des performances subsoniques'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tech (name, description) VALUES
-- Saab J 35 Draken
('Configuration aérodynamique en double delta', 'Combinaison de deux ailes delta pour une grande maniabilité et des performances à haute vitesse'),
('Réacteur Rolls-Royce Avon', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar PS-02/A', 'Radar de tir et de navigation pour interception'),

-- Saab AJ 37 Viggen
('Aile en flèche avec canards', 'Configuration aérodynamique combinant canards et aile en flèche pour une grande maniabilité'),
('Réacteur Volvo RM8', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar PS-37/A', 'Radar de suivi de terrain et de navigation pour missions air-air et air-sol'),

-- Saab JAS 39 Gripen
('Aile delta-canard', 'Configuration aérodynamique combinant canards et aile delta'),
('Réacteur Volvo RM12', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar PS-05/A', 'Radar à balayage électronique mécanique pour détection air-air et air-sol'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),
('Système de fusion de capteurs', 'Intégration des données radar, IR et ROEM')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tech (name, description) VALUES
-- HAL HF-24 Marut
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur Rolls-Royce Orpheus', 'Moteur à turboréacteur pour des performances subsoniques'),
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),

-- Mikoyan-Gourevitch MiG-21
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur Tumansky R-25', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar RP-21', 'Radar de tir et de navigation pour interception'),

-- Mikoyan-Gourevitch MiG-23
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Radar RP-23', 'Radar de tir et de navigation multifonction'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- Mikoyan-Gourevitch MiG-29
('Aile à forte flèche', 'Conception aérodynamique pour une grande maniabilité'),
('Radar N019', 'Radar Doppler pour détection air-air et air-sol'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- Dassault Mirage 2000
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Radar RDM/RDI', 'Radar Doppler multi-mode pour détection air-air/air-sol'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- Soukhoï Su-30MKI
('Aile à forte flèche', 'Conception aérodynamique pour une grande maniabilité'),
('Radar N011M Bars', 'Radar à balayage électronique passif (PESA) pour détection longue portée'),
('Système de ravitaillement en vol', 'Perche de ravitaillement en vol intégrée'),

-- HAL Tejas
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur General Electric F404', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar EL/M-2032', 'Radar Doppler multi-mode pour détection air-air/air-sol'),

-- Dassault Rafale
('Aile canard delta', 'Configuration aérodynamique combinant canards et aile delta'),
('Système SPECTRA', 'Suite complète de guerre électronique et contre-mesures'),
('Radar RBE2 AESA', 'Premier radar à antenne active européenne en service'),

-- SEPECAT Jaguar
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur Rolls-Royce/Turbomeca Adour', 'Moteur à double flux pour des performances subsoniques'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),

-- Ilyushin Il-28
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur Klimov VK-1', 'Moteur à turboréacteur pour des performances subsoniques'),
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),

-- Tupolev Tu-142
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur Kuznetsov NK-12', 'Moteur à turbopropulseur pour une grande autonomie'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tech (name, description) VALUES
-- Mitsubishi F-104J Starfighter
('Aile droite à faible allongement', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur General Electric J79', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar AN/ASG-14', 'Radar de tir et de navigation pour interception'),

-- Mitsubishi F-4EJ Phantom II
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Radar AN/APQ-120', 'Radar de tir et de navigation multifonction'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- Mitsubishi F-15J Eagle
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Radar AN/APG-63', 'Radar Doppler à impulsions pour détection longue portée'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- Mitsubishi F-2
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Radar J/APG-1', 'Radar à antenne active (AESA) pour détection longue portée'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- Kawasaki T-4
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Réacteur Ishikawajima-Harima F3-IHI-30', 'Moteur à turboréacteur pour des performances subsoniques'),
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),

-- Lockheed Martin F-35 Lightning II
('Conception furtive', 'Forme et matériaux réduisant la signature radar'),
('Radar AN/APG-81', 'Radar à antenne active (AESA) pour détection longue portée'),
('Système de fusion de capteurs', 'Intégration des données radar, IR et ROEM')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tech (name, description) VALUES
-- Dassault Mirage III
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur SNECMA Atar', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar Cyrano', 'Radar monopulse Cyrano I/II pour interception et tir air-air'),

-- Dassault Mirage 5
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur SNECMA Atar', 'Moteur à postcombustion pour des performances supersoniques'),
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),

-- IAI Nesher
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur SNECMA Atar', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar Cyrano', 'Radar monopulse Cyrano I/II pour interception et tir air-air'),

-- IAI Kfir
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Réacteur General Electric J79', 'Moteur à postcombustion pour des performances supersoniques'),
('Radar EL/M-2001', 'Radar Doppler pour détection air-air et air-sol'),

-- McDonnell Douglas F-4 Phantom II
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Radar AN/APQ-120', 'Radar de tir et de navigation multifonction'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),

-- McDonnell Douglas F-15 Eagle
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Radar AN/APG-63', 'Radar Doppler à impulsions pour détection longue portée'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),

-- General Dynamics F-16 Fighting Falcon
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Commande de vol électrique (fly-by-wire)', 'Système numérique de contrôle de stabilité'),
('Radar AN/APG-68', 'Radar Doppler multi-mode pour détection air-air/air-sol'),

-- Lockheed Martin F-35I Adir
('Conception furtive', 'Forme et matériaux réduisant la signature radar'),
('Radar AN/APG-81', 'Radar à antenne active (AESA) pour détection longue portée'),
('Système de fusion de capteurs', 'Intégration des données radar, IR et ROEM')
ON CONFLICT (name) DO NOTHING;

CREATE USER admin WITH ENCRYPTED PASSWORD 'Titouan1.';
GRANT ALL PRIVILEGES ON DATABASE vol_histoire TO admin;
GRANT USAGE ON SCHEMA public TO admin;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;