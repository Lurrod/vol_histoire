INSERT INTO type (name, description) 
VALUES ('Attaque naval', 'Avion conçu pour des frappes navales et terrestres depuis un porte-avions');

-- Technologies spécifiques au Super Étendard
INSERT INTO tech (name, description) VALUES
('Radar Agave', 'Radar naval pour la détection et le guidage de missiles anti-navires'),
('Système INS', 'Système de navigation inertielle pour une précision en vol'),
('Cockpit analogique', 'Instrumentation traditionnelle avec affichages analogiques');

-- Armements du Super Étendard
INSERT INTO armement (name, description) VALUES
('AM39 Exocet', 'Missile anti-navire à longue portée (70 km)'),
('Canon DEFA 553', 'Canon de 30 mm avec 125 coups'),
('Bombe Mk 82', 'Bombe non guidée de 227 kg'),
('Matra Magic', 'Missile air-air à courte portée infrarouge'),
('AS.30', 'Missile air-sol guidé (portée 12 km)');

-- Guerres impliquant le Super Étendard
INSERT INTO wars (name, date_start, date_end, description) VALUES
('Guerre des Malouines', '1982-04-02', '1982-06-14', 'Utilisé par l''Argentine contre les forces britanniques'),
('Guerre Iran-Irak', '1980-09-22', '1988-08-20', 'Utilisé par l''Irak avec des missiles Exocet'),
('Opération Olifant', '1981-10-07', '1981-10-07', 'Attaque irakienne sur des navires iraniens');

-- Missions spécifiques
INSERT INTO missions (name, description) VALUES
('Appui au sol', 'Soutien des forces terrestres par frappes ciblées'),

-- Insertion du Super Étendard dans la table airplanes
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
    'Super Étendard',
    'Dassault Super Étendard',
    'Avion d''attaque naval de 4ème génération',
    'Le Super Étendard est un avion d''attaque naval monoplace développé par Dassault Aviation pour la Marine nationale française. Conçu comme une évolution de l''Étendard IVM, il a été introduit pour remplacer les anciens chasseurs embarqués et remplir des missions d''attaque au sol et anti-navires. Entré en service en 1978, il est devenu célèbre pour son utilisation du missile Exocet, notamment lors de la guerre des Malouines par la marine argentine, qui en avait acquis cinq exemplaires auprès de la France en 1981.
    Le programme a débuté dans les années 1970 pour répondre aux besoins de la Marine française d''un appareil capable d''opérer depuis le porte-avions Foch et Clemenceau. Le prototype a volé pour la première fois le 28 octobre 1974, et l''avion a été officiellement mis en service en juin 1978. Il est équipé d''un radar Agave pour le guidage des missiles Exocet et d''un système de navigation inertielle. Sa vitesse maximale atteint 1 200 km/h (Mach 1.0), et sa portée est d''environ 1 800 km avec des réservoirs supplémentaires.
    Le Super Étendard a été utilisé par la France lors d''opérations au Liban dans les années 1980 et dans le Golfe Persique. L''Irak, qui en a loué cinq exemplaires en 1983, les a employés contre des pétroliers iraniens durant la guerre Iran-Irak. L''Argentine, quant à elle, a marqué l''histoire en coulant le HMS Sheffield britannique avec un Exocet tiré depuis un Super Étendard le 4 mai 1982.
    Au total, 85 appareils ont été produits, dont 71 pour la France. Retiré du service français en 2016, il a été remplacé par le Rafale M. L''Argentine a utilisé ses derniers exemplaires jusqu''en 2018. Malgré son design des années 1970, le Super Étendard reste une icône grâce à sa fiabilité et son rôle dans des conflits modernes.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1972-01-01',
    '1974-10-28',
    '1978-06-01',
    1200,
    1800,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Attaque naval'),
    'Retiré',
    9500,
    'https://i.postimg.cc/QCzwqh9m/super-etendard.jpg'
);

-- Liaison avec les technologies
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Super Étendard'), 
    id 
FROM tech 
WHERE name IN ('Radar Agave', 'Système INS', 'Cockpit analogique');

-- Liaison avec les armements
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Super Étendard'), 
    id 
FROM armement 
WHERE name IN ('AM39 Exocet', 'Canon DEFA 553', 'Bombe Mk 82', 'Matra Magic', 'AS.30');

-- Liaison avec les guerres
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Super Étendard'), 
    id 
FROM wars 
WHERE name IN ('Guerre des Malouines', 'Guerre Iran-Irak', 'Opération Olifant');

-- Liaison avec les missions
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'Super Étendard'), 
    id 
FROM missions 
WHERE name IN ('Attaque anti-navire', 'Appui au sol', 'Interdiction');