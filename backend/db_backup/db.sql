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
    name VARCHAR(255) NOT NULL,
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
('Israël', 'ISR'),
('Vietnam', 'VNM'),
('Afghanistan', 'AFG'),
('Irak', 'IRQ'),
('Yougoslavie', 'YUG'),
('Corée', 'KOR'),
('Îles Malouines', 'FLK'),
('Liban', 'LBN'),
('Algérie', 'DZA'),
('Syrie', 'SYR'),
('Iran', 'IRN');

INSERT INTO wars (name, date_start, date_end, country_id, description) VALUES
-- Guerre du Vietnam (1955-1975)
('Guerre du Vietnam', '1955-11-01', '1975-04-30', (SELECT id FROM countries WHERE code = 'VNM'), 'Conflit prolongé entre le Nord-Vietnam communiste et le Sud-Vietnam soutenu par les États-Unis.'),

-- Guerre des Six Jours (1967)
('Guerre des Six Jours', '1967-06-05', '1967-06-10', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et une coalition de pays arabes (Égypte, Jordanie, Syrie).'),

-- Guerre du Kippour (1973)
('Guerre du Kippour', '1973-10-06', '1973-10-25', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et une coalition de pays arabes menée par l''Égypte et la Syrie.'),

-- Guerre froide (1947-1991)
('Guerre froide', '1947-03-12', '1991-12-26', NULL, 'Confrontation indirecte entre les États-Unis et l''Union soviétique, marquée par des tensions géopolitiques et des conflits par procuration à travers le monde.'),

-- Guerre Iran-Irak (1980-1988)
('Guerre Iran-Irak', '1980-09-22', '1988-08-20', (SELECT id FROM countries WHERE code = 'IRQ'), 'Conflit prolongé entre l''Iran et l''Irak, marqué par des batailles aériennes et terrestres intenses.'),

-- Guerre du Golfe (1990-1991)
('Guerre du Golfe', '1990-08-02', '1991-02-28', (SELECT id FROM countries WHERE code = 'IRQ'), 'Conflit entre une coalition internationale dirigée par les États-Unis et l''Irak après l''invasion du Koweït.'),

-- Guerre de Yougoslavie (1991-2001)
('Guerre de Yougoslavie', '1991-03-31', '2001-06-21', (SELECT id FROM countries WHERE code = 'YUG'), 'Série de conflits ethniques et politiques dans les Balkans, impliquant plusieurs pays et factions.'),

-- Guerre d''Afghanistan (2001-2021)
('Guerre d''Afghanistan', '2001-10-07', '2021-08-30', (SELECT id FROM countries WHERE code = 'AFG'), 'Conflit prolongé en Afghanistan impliquant les États-Unis et leurs alliés contre les talibans et Al-Qaïda.'),

-- Guerre d''Irak (2003-2011)
('Guerre d''Irak', '2003-03-20', '2011-12-18', (SELECT id FROM countries WHERE code = 'IRQ'), 'Conflit en Irak mené par une coalition dirigée par les États-Unis pour renverser le régime de Saddam Hussein.'),

-- Conflit israélo-arabe (1948-présent)
('Conflit israélo-arabe', '1948-05-15', NULL, (SELECT id FROM countries WHERE code = 'ISR'), 'Série de conflits et tensions entre Israël et les pays arabes voisins.'),

-- Guerre de Corée (1950-1953)
('Guerre de Corée', '1950-06-25', '1953-07-27', (SELECT id FROM countries WHERE code = 'KOR'), 'Conflit entre la Corée du Nord (soutenue par la Chine et l''URSS) et la Corée du Sud (soutenue par les États-Unis et l''ONU).'),

-- Guerre des Malouines (1982)
('Guerre des Malouines', '1982-04-02', '1982-06-14', (SELECT id FROM countries WHERE code = 'FLK'), 'Conflit entre l''Argentine et le Royaume-Uni pour le contrôle des îles Malouines.'),

-- Guerre civile syrienne (2011-présent)
('Guerre civile syrienne', '2011-03-15', NULL, (SELECT id FROM countries WHERE code = 'SYR'), 'Conflit complexe en Syrie impliquant le gouvernement syrien, des rebelles, et des forces internationales.'),

-- Guerre du Liban (1982)
('Guerre du Liban', '1982-06-06', '1982-09-30', (SELECT id FROM countries WHERE code = 'LBN'), 'Conflit entre Israël et des factions libanaises et palestiniennes.'),

-- Guerre d''Indochine (1946-1954)
('Guerre d''Indochine', '1946-12-19', '1954-07-20', (SELECT id FROM countries WHERE code = 'VNM'), 'Conflit entre la France et le Viet Minh pour le contrôle de l''Indochine.'),

-- Guerre d''Algérie (1954-1962)
('Guerre d''Algérie', '1954-11-01', '1962-03-19', (SELECT id FROM countries WHERE code = 'DZA'), 'Conflit entre la France et le Front de libération nationale (FLN) pour l''indépendance de l''Algérie.');

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

INSERT INTO armement (name, description) VALUES
-- Canons
('DEFA 552', 'Canon de 30 mm, 125 coups par canon'),
('DEFA 553', 'Canon de 30 mm, 135-150 coups par canon'),
('DEFA 554', 'Canon de 30 mm amélioré, 125 coups par canon'),
('GIAT 30M791', 'Canon de 30 mm, 125 coups'),
('Colt Mk 12', 'Canon de 20 mm, 125 coups par canon'),
('M61 Vulcan', 'Canon rotatif 20 mm, 6000 coups/min'),
('GAU-8 Avenger', 'Canon rotatif 30 mm, 3900 coups/min'),
('GSh-23', 'Canon double de 23 mm, 3400 coups/min'),
('GSh-30-1', 'Canon de 30 mm, 1500 coups/min'),
('GSh-30-2', 'Canon double de 30 mm, 3000 coups/min'),
('NR-30', 'Canon de 30 mm, 850 coups/min'),
('GSh-6-23', 'Canon rotatif 23 mm, 6000 coups/min'),
('ADEN 30 mm', 'Canon de 30 mm, 1300 coups/min'),
('GAU-12 Equalizer', 'Canon rotatif 25 mm, 3600 coups/min'),
('Mauser BK-27', 'Canon de 27 mm, 1700 coups/min'),
('JM61A1', 'Variante japonaise du M61 Vulcan'),
('M39', 'Canon de 20 mm'),

-- Missiles air-air
('Matra R530', 'Missile moyenne portée, guidage radar semi-actif ou infrarouge'),
('Matra R550 Magic', 'Missile courte portée, guidage infrarouge'),
('Matra Super 530F', 'Missile moyenne portée, guidage radar semi-actif'),
('Matra Super 530D', 'Missile moyenne portée, guidage radar semi-actif'),
('MICA IR', 'Missile air-air à guidage infrarouge, portée 80 km'),
('MICA EM', 'Missile air-air à guidage radar actif, portée 80 km'),
('Meteor', 'Missile air-air longue portée, guidage radar actif, 100-150 km'),
('AIM-9 Sidewinder', 'Missile air-air courte portée, guidage infrarouge, 18 km'),
('AIM-7 Sparrow', 'Missile moyenne portée, guidage radar semi-actif, 70 km'),
('AIM-54 Phoenix', 'Missile longue portée, guidage radar actif, 190 km'),
('AIM-120 AMRAAM', 'Missile moyenne/longue portée, guidage radar actif, 120 km'),
('R-3S', 'Missile courte portée, guidage infrarouge, 8 km'),
('R-13M', 'Missile courte portée, guidage infrarouge, 15 km'),
('R-23R', 'Missile moyenne portée, guidage radar semi-actif, 35 km'),
('R-23T', 'Missile moyenne portée, guidage infrarouge, 35 km'),
('R-24R', 'Missile moyenne portée, guidage radar semi-actif, 50 km'),
('R-24T', 'Missile moyenne portée, guidage infrarouge, 50 km'),
('R-27R', 'Missile moyenne portée, guidage radar semi-actif, 80 km'),
('R-27T', 'Missile moyenne portée, guidage infrarouge, 70 km'),
('R-33', 'Missile longue portée, guidage radar semi-actif, 120 km'),
('R-37', 'Missile très longue portée, guidage radar actif, 300 km'),
('R-40R', 'Missile longue portée, guidage radar semi-actif, 80 km'),
('R-40T', 'Missile longue portée, guidage infrarouge, 80 km'),
('R-60', 'Missile courte portée, guidage infrarouge, 8 km'),
('R-73', 'Missile courte portée, guidage infrarouge, 30 km'),
('R-77', 'Missile moyenne/longue portée, guidage radar actif, 110 km'),
('Firestreak', 'Missile courte portée, guidage infrarouge, 15 km'),
('Red Top', 'Missile courte portée, guidage infrarouge, 12 km'),
('Skyflash', 'Missile moyenne portée, guidage radar semi-actif, 45 km'),
('ASRAAM', 'Missile courte portée, guidage infrarouge, 50 km'),
('Python 3', 'Missile courte portée, guidage infrarouge, 15 km'),
('Python 4', 'Missile courte portée, guidage infrarouge, 20 km'),
('Python 5', 'Missile courte portée, guidage infrarouge, 20 km, haute manœuvrabilité'),
('Derby', 'Missile moyenne portée, guidage radar actif, 50 km'),
('AAM-3', 'Missile courte portée, guidage infrarouge'),
('AAM-4', 'Missile moyenne/longue portée, guidage radar actif'),
('AAM-5', 'Missile courte portée, guidage infrarouge'),
('IRIS-T', 'Missile courte portée, guidage infrarouge, 25 km'),

-- Missiles air-sol
('AS-30', 'Missile air-sol, guidage radio'),
('AS-30L', 'Missile air-sol, guidage laser, portée 11 km'),
('AS-37 Martel', 'Missile air-sol anti-radar ou guidage TV, portée 60 km'),
('Apache', 'Missile de croisière anti-piste, portée 140 km'),
('SCALP EG', 'Missile de croisière, portée 500 km'),
('AGM-65 Maverick', 'Missile air-sol à guidage optique/TV, portée 27 km'),
('AASM Hammer', 'Bombe guidée avec kit de propulsion, portée 70 km'),
('AS-20', 'Missile air-sol, guidage radio, portée 7 km'),
('AGM-12 Bullpup', 'Missile air-sol, guidage radio, 10 km'),
('AGM-45 Shrike', 'Missile anti-radar, portée 40 km'),
('AGM-78 Standard ARM', 'Missile anti-radar, portée 90 km'),
('AGM-84 Harpoon', 'Missile antinavire, portée 124 km'),
('AGM-88 HARM', 'Missile anti-radar, portée 150 km'),
('AGM-114 Hellfire', 'Missile air-sol, guidage laser, 8 km'),
('AGM-130', 'Missile air-sol guidé, portée 64 km'),
('AGM-154 JSOW', 'Arme stand-off, guidage GPS/INS, 130 km'),
('AGM-158 JASSM', 'Missile de croisière furtif, portée 370-1000 km'),
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
('Martel AJ-168', 'Missile air-sol, guidage TV, 60 km'),
('Martel AS-37', 'Missile anti-radar, portée 60 km'),
('Brimstone', 'Missile air-sol, guidage radar/laser, 60 km'),
('Storm Shadow', 'Missile de croisière, portée 560 km'),
('MAR-1', 'Missile anti-radar, portée 60 km'),
('Popeye', 'Missile air-sol, guidage TV, portée 78 km'),
('Spice', 'Bombe guidée avec kit de propulsion, portée 60-100 km'),

-- Missiles antinavires
('AM39 Exocet', 'Missile antinavire, portée 70 km'),
('Sea Eagle', 'Missile antinavire, portée 110 km'),
('Sea Skua', 'Missile antinavire léger, portée 25 km'),
('Gabriel', 'Missile antinavire, portée 36 km'),
('ASM-1', 'Missile antinavire, guidage radar actif, portée 50 km'),
('ASM-2', 'Missile antinavire, guidage radar actif, portée 100 km'),
('Marte Mk2A', 'Missile antinavire, portée 30 km'),

-- Armement nucléaire
('AN-11', 'Bombe nucléaire à chute libre'),
('AN-22', 'Bombe nucléaire à chute libre'),
('ASMP', 'Missile nucléaire, portée 300 km'),
('ASMP-A', 'Missile nucléaire amélioré, portée 500 km'),
('B28', 'Bombe nucléaire à chute libre, 1.45 Mt'),
('B43', 'Bombe nucléaire à chute libre, 1 Mt'),
('B61', 'Bombe nucléaire tactique, rendement variable'),
('B83', 'Bombe nucléaire stratégique, 1.2 Mt'),
('WE.177', 'Bombe nucléaire à chute libre, 10-400 kt'),
('RN-28', 'Bombe nucléaire tactique à chute libre'),
('TN-1000', 'Bombe nucléaire à chute libre, 1 Mt'),

-- Bombes
('Bombe lisse 250 kg', 'Bombe conventionnelle non guidée, 250 kg'),
('Bombe lisse 400 kg', 'Bombe conventionnelle non guidée, 400 kg'),
('Bombe lisse 500 kg', 'Bombe conventionnelle non guidée, 500 kg'),
('Bombe lisse 1000 kg', 'Bombe conventionnelle non guidée, 1000 kg'),
('GBU-12 Paveway II', 'Bombe guidée laser, 224 kg'),
('GBU-24 Paveway III', 'Bombe guidée laser, portée accrue'),
('BL755', 'Bombe à sous-munitions'),
('JDAM', 'Kit de guidage GPS pour bombes, portée 24 km'),
('Mk 82', 'Bombe lisse 227 kg'),
('Mk 83', 'Bombe lisse 454 kg'),
('Mk 84', 'Bombe lisse 907 kg'),
('GBU-10 Paveway II', 'Bombe guidée laser, 907 kg'),
('GBU-16 Paveway II', 'Bombe guidée laser, 454 kg'),
('GBU-27 Paveway III', 'Bombe guidée laser furtive, 907 kg'),
('GBU-31 JDAM', 'Bombe guidée GPS, 907 kg'),
('GBU-32 JDAM', 'Bombe guidée GPS, 454 kg'),
('GBU-38 JDAM', 'Bombe guidée GPS, 227 kg'),
('GBU-39 SDB', 'Petite bombe guidée, 113 kg'),
('CBU-87', 'Bombe à sous-munitions, 430 kg'),
('CBU-97', 'Bombe à sous-munitions avec capteurs, 430 kg'),
('FAB-250', 'Bombe lisse 250 kg'),
('FAB-500', 'Bombe lisse 500 kg'),
('FAB-1000', 'Bombe lisse 1000 kg'),
('FAB-1500', 'Bombe lisse 1500 kg'),
('KAB-500L', 'Bombe guidée laser, 500 kg'),
('KAB-1500L', 'Bombe guidée laser, 1500 kg'),
('BetAB-500', 'Bombe anti-bunker, 500 kg'),
('ODAB-500', 'Bombe thermobarique, 500 kg'),
('LT-2', 'Bombe guidée laser, 500 kg'),
('LS-6', 'Bombe guidée par GPS/glide, 500 kg'),
('GBU-250', 'Bombe guidée chinoise, 250 kg'),
('Type 200A', 'Bombe anti-piste, 500 kg'),
('Paveway IV', 'Bombe guidée laser/GPS, 227 kg'),
('1000 lb GP', 'Bombe lisse 454 kg'),
('M/71 120 kg', 'Bombe lisse 120 kg'),
('M/71 500 kg', 'Bombe lisse 500 kg'),
('GBU-49', 'Bombe guidée laser/GPS, 227 kg'),
('OFAB-250', 'Bombe lisse 250 kg'),
('OFAB-500', 'Bombe lisse 500 kg'),
('FAB-1500', 'Bombe lisse 1500 kg, capacité stratégique'),
('BAP 100', 'Bombe anti-piste'),

-- Roquettes
('SNEB 68 mm', 'Roquettes non guidées, pod de 68 mm'),
('Zuni 127 mm', 'Roquettes non guidées, pod de 127 mm'),
('Hydra 70', 'Roquettes non guidées, 70 mm'),
('S-5', 'Roquettes non guidées, 57 mm'),
('S-8', 'Roquettes non guidées, 80 mm'),
('S-13', 'Roquettes non guidées, 122 mm'),
('S-24', 'Roquettes non guidées, 240 mm'),
('S-25', 'Roquettes non guidées, 340 mm'),
('CRV7', 'Roquettes non guidées, 70 mm'),
('Bofors 135 mm', 'Roquettes non guidées, 135 mm'),
('Type 90-1', 'Roquettes non guidées, 90 mm'),
('HF-16', 'Roquettes non guidées, 57 mm'),
('HVAR 70 mm', 'Roquettes non guidées, 70 mm'),

-- Torpilles et armes anti-sous-marines
('APR-3', 'Torpille légère anti-sous-marine, guidage acoustique'),
('RGB-75', 'Bouée acoustique pour détection sous-marine');

-- Technologies génériques réutilisables
INSERT INTO tech (name, description) VALUES
-- Configurations aérodynamiques (Ailes)
('Aile delta', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses'),
('Aile en flèche', 'Configuration aérodynamique pour les hautes vitesses'),
('Aile à géométrie variable', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses'),
('Aile canard delta', 'Configuration aérodynamique combinant canards et aile delta'),
('Aile à forte flèche', 'Conception aérodynamique pour une grande maniabilité'),
('Aile droite à faible allongement', 'Configuration aérodynamique pour les hautes vitesses'),
('Aile en flèche légère', 'Conception légère pour une grande maniabilité'),
('Aile à incidence variable', 'Dispositif mécanique modifiant l''angle de l''aile en vol'),
('Aile delta-canard', 'Configuration aérodynamique combinant canards et aile delta'),
('Aile en flèche avec canards', 'Configuration aérodynamique combinant canards et aile en flèche pour une grande maniabilité'),
('Configuration aérodynamique en double delta', 'Combinaison de deux ailes delta pour une grande maniabilité et des performances à haute vitesse'),

-- Moteurs
('Réacteur à postcombustion', 'Moteur SNECMA Atar permettant des performances supersoniques'),
('Réacteur Tumansky R-25', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur General Electric J79', 'Moteur à postcombustion pour des performances supersoniques'),
('Moteurs à poussée vectorielle', 'Moteurs permettant une grande maniabilité'),
('Moteurs à turbofan', 'Moteurs modernes pour améliorer l''efficacité et la portée'),
('Moteur à poussée vectorielle', 'Moteur Rolls-Royce Pegasus permettant le décollage et l''atterrissage vertical (VTOL)'),
('Réacteur Klimov VK-1', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur Tumansky R-9', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur WP-7', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur WP-13', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur AL-31FN', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur WS-10', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur RD-93', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur Rolls-Royce Avon', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur Volvo RM8', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur Volvo RM12', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur Rolls-Royce Orpheus', 'Moteur à turboréacteur pour des performances subsoniques'),
('Réacteur General Electric F404', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur Rolls-Royce/Turbomeca Adour', 'Moteur à double flux pour des performances subsoniques'),
('Réacteur Kuznetsov NK-12', 'Moteur à turbopropulseur pour une grande autonomie'),
('Réacteur Ishikawajima-Harima F3-IHI-30', 'Moteur à turboréacteur pour des performances subsoniques'),
('Réacteur Larzac 04', 'Moteur à double flux pour des performances subsoniques'),
('Réacteur Rolls-Royce Viper', 'Moteur à turboréacteur pour des performances subsoniques'),
('Réacteur Rolls-Royce Spey', 'Moteur à turboréacteur pour des performances subsoniques'),
('Réacteur Honeywell TFE731', 'Moteur à turbofan pour des performances subsoniques'),
('Moteurs Tumansky R-15', 'Moteurs à postcombustion pour des vitesses supérieures à Mach 3'),
('Moteurs D-30F6', 'Moteurs à postcombustion pour des performances supersoniques'),
('Moteurs Tumansky R-11', 'Moteurs à postcombustion pour des performances supersoniques'),
('Moteurs à turbopropulseurs', 'Moteurs à hélices contrarotatives pour une grande autonomie'),
('Réacteur AL-31F', 'Moteur à postcombustion pour des performances supersoniques'),
('Réacteur WP-6', 'Moteur à postcombustion pour des performances supersoniques'),

-- Radars
('Radar Cyrano', 'Radar monopulse Cyrano I/II pour interception et tir air-air'),
('Radar Cyrano IV', 'Radar multimode amélioré avec capacité de cartographie terrain'),
('Radar RDM/RDI', 'Radar Doppler multi-mode pour détection air-air/air-sol'),
('Radar RBE2 AESA', 'Premier radar à antenne active européenne en service'),
('Radar AN/APQ-120', 'Radar de tir et de navigation multifonction'),
('Radar AN/ASG-14', 'Radar de tir et de navigation pour interception'),
('Radar AN/APG-63', 'Radar Doppler à impulsions pour détection longue portée'),
('Radar AN/APG-68', 'Radar Doppler multi-mode pour détection air-air/air-sol'),
('Radar AN/APG-77', 'Radar à antenne active (AESA) pour détection longue portée'),
('Radar AN/APG-81', 'Radar à antenne active (AESA) pour détection longue portée'),
('Radar RP-21', 'Radar de tir et de navigation pour interception'),
('Radar RP-23', 'Radar de tir et de navigation multifonction'),
('Radar RP-25', 'Radar à longue portée pour interception à haute altitude'),
('Radar N019', 'Radar Doppler pour détection air-air et air-sol'),
('Radar Zaslon', 'Radar à balayage électronique passif (PESA) pour détection longue portée'),
('Radar RP-15', 'Radar de tir et de navigation pour interception'),
('Radar Klen', 'Radar de tir et de navigation pour attaque au sol'),
('Radar Puma', 'Radar de suivi de terrain pour vol à basse altitude'),
('Radar N001', 'Radar Doppler pour détection air-air et air-sol'),
('Radar N011M Bars', 'Radar à balayage électronique passif (PESA) pour détection longue portée'),
('Radar V004', 'Radar à balayage électronique passif (PESA) pour détection air-air/air-sol'),
('Radar Irbis-E', 'Radar à balayage électronique passif (PESA) pour détection longue portée'),
('Radar N036', 'Radar à antenne active (AESA) pour détection longue portée'),
('Radar PN-AD', 'Radar de navigation et d''attaque pour missions de bombardement'),
('Radar Obzor-K', 'Radar de navigation et d''attaque pour missions de bombardement'),
('Radar RP-9', 'Radar de tir et de navigation pour interception'),
('Radar Type 226', 'Radar de tir et de navigation pour interception'),
('Radar Type 1471', 'Radar de tir et de navigation pour interception'),
('Radar Type 1473', 'Radar Doppler pour détection air-air et air-sol'),
('Radar AESA', 'Radar à antenne active pour détection longue portée'),
('Radar KLJ-7', 'Radar Doppler pour détection air-air et air-sol'),
('Radar AI.23', 'Radar de tir et de navigation pour interception'),
('Radar Blue Fox', 'Radar de tir et de navigation pour interception'),
('Radar CAPTOR', 'Radar à balayage électronique mécanique pour détection air-air et air-sol'),
('Radar Blue Parrot', 'Radar de suivi de terrain pour missions de bombardement'),
('Radar H2S', 'Radar de navigation et de bombardement pour missions stratégiques'),
('Radar R21G/M1', 'Radar de tir et de navigation amélioré pour interception'),
('Radar PS-02/A', 'Radar de tir et de navigation pour interception'),
('Radar PS-37/A', 'Radar de suivi de terrain et de navigation pour missions air-air et air-sol'),
('Radar PS-05/A', 'Radar à balayage électronique mécanique pour détection air-air et air-sol'),
('Radar EL/M-2032', 'Radar Doppler multi-mode pour détection air-air/air-sol'),
('Radar J/APG-1', 'Radar à antenne active (AESA) pour détection longue portée'),
('Radar AN/AWG-9', 'Radar à longue portée pour missiles AIM-54 Phoenix'),
('Radar de suivi de terrain', 'Radar permettant un vol à basse altitude en suivant le relief'),
('Radar multi-mode', 'Radar de suivi de terrain et de navigation pour missions air-air et air-sol'),
('Radar Type 242', 'Radar de navigation et d''attaque pour missions de bombardement'),

-- Systèmes de navigation
('Système de navigation inertielle', 'Système de navigation autonome sans GPS'),
('Système de navigation semi-automatique', 'Intégration précoce d''un système de navigation inertielle'),
('Système de navigation et d''attaque intégré', 'Système combinant navigation inertielle et radar'),
('Système de navigation attaque à basse altitude', 'Couplage radar altimètre/ordinateur de navigation'),

-- Systèmes de contrôle
('Commande de vol électrique (fly-by-wire)', 'Système numérique de contrôle de stabilité'),
('Système de contrôle de vol numérique', 'Système de contrôle de vol assisté par ordinateur'),
('Système de contrôle de réacteur', 'Système de contrôle numérique pour la gestion de la poussée vectorielle'),

-- Systèmes de contre-mesures et furtivité
('Système SPECTRA', 'Suite complète de guerre électronique et contre-mesures'),
('Système de contre-mesures électroniques', 'Système intégré de brouillage et de leurres'),
('Conception furtive', 'Forme et matériaux réduisant la signature radar'),

-- Systèmes avancés
('Fusion de capteurs', 'Intégration des données radar, IR et ROEM'),
('Système de fusion de capteurs', 'Intégration des données radar, IR et ROEM'),
('Système de gestion de mission avancé', 'Système intégré de navigation, d''attaque et de contre-mesures'),
('Système de caméra intégré', 'Caméra gunshot pour enregistrement des combats'),
('Liaison de données tactique', 'Système d''échange d''informations avec la flotte'),

-- Armement intégré
('Canon M39', 'Canon de 20 mm à haute cadence de tir'),
('Canon GAU-8 Avenger', 'Canon rotatif de 30 mm à haute cadence de tir'),
('Canon GSh-30-2', 'Canon double de 30 mm à haute cadence de tir'),
('Canon NR-23', 'Canon de 23 mm à haute cadence de tir'),

-- Structure et matériaux
('Matériaux composites', 'Utilisation de carbone et kevlar dans la structure'),
('Blindage en titane', 'Blindage lourd pour protéger le pilote et les systèmes vitaux'),
('Conception en acier inoxydable', 'Structure en acier pour résister aux hautes vitesses et températures'),
('Matériaux résistants à la chaleur', 'Utilisation de titane et de matériaux composites résistants à la chaleur'),
('Système navalisé', 'Renforcement structurel et corrosion contrôlée pour porte-avions'),
('Soute à armement pressurisée', 'Soute spéciale pour armes nucléaires stratégiques'),

-- Équipements spécifiques
('Perche de ravitaillement en vol', 'Système de ravitaillement en vol fixe'),
('Système de ravitaillement en vol automatique', 'Perche de ravitaillement avec automate de connexion'),
('Siège incliné', 'Siège incliné pour réduire les effets de la gravité sur le pilote'),
('Pod désignateur laser', 'Capacité d''illumination laser pour bombes guidées'),
('Poste de pilotage côte à côte', 'Configuration côte à côte pour les missions longues durées'),
('Configuration bi-moteurs superposés', 'Moteurs empilés verticalement pour réduire la traînée'),
('Système de décollage et d''atterrissage sur porte-avions', 'Renforcement structurel et corrosion contrôlée pour porte-avions'),
('Conception aérodynamique pour haute altitude', 'Forme optimisée pour le vol à haute altitude et haute vitesse');

CREATE USER admin WITH ENCRYPTED PASSWORD 'Titouan1.';
GRANT ALL PRIVILEGES ON DATABASE vol_histoire TO admin;
GRANT USAGE ON SCHEMA public TO admin;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;