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
    'Le Rafale de Dassault Aviation est un avion de combat multirôle qualifié d''omnirôle par son constructeur développé pour la Marine nationale et l''Armée de l''air françaises, livré à partir du 18 mai 2001 et entré en service en 2002 dans la Marine. Il équipe également les forces aériennes égyptiennes, qataris, indiennes, grecques et croates et a été commandé par les Émirats arabes unis, l''Indonésie et la Serbie.

Le constructeur Renault est propriétaire du nom Rafale depuis le Caudron C.460, et il a autorisé Dassault à l''utiliser pour baptiser son avion de combat.

À la fin des années 1970, les forces armées françaises expriment le besoin d''un nouvel avion de combat polyvalent qu''il est envisagé de développer avec l''Allemagne de l''Ouest, le Royaume-Uni, l''Espagne et l''Italie, mais les divergences de besoins, notamment la capacité d''opérer depuis un porte-avions, amènent la France à se désolidariser de ses partenaires en 1985. Le démonstrateur Rafale A vole le 4 juillet 1986 et le programme est lancé le 26 janvier 1988 : le monoplace Rafale C vole le 19 mai 1991, la version marine M, le 12 décembre de la même année, et le biplace B, le 30 avril 1993. Le coût total du programme est de 46.4 milliards d''euros.

L''avion est à aile delta et plans canard, à commandes de vol électriques et utilise des éléments de furtivité passifs et actifs ; il est équipé d''un radar à balayage électronique RBE2 et de deux moteurs Snecma M88. Pour la supériorité aérienne, il utilise des missiles air-air et un canon. En bombardement tactique, il utilise des bombes guidées laser, des missiles de croisière, des missiles antinavires et, en bombardement stratégique, un missile nucléaire ASMP-A.

La France avait prévu initialement de commander 286 appareils, dont 58 pour sa marine. Au 31 décembre 2022, 153 avions ont été livrés sur les 192 commandés au titre des quatre premières tranches et de la commande passée pour remplacer les 12 appareils prélevés pour être livrés à la Grèce.

Les contrats à l''export du Rafale à partir de 2015 ont fait fortement progresser les exportations militaires françaises, dont le principal bénéficiaire est Dassault Aviation, puis Thales, Safran, MBDA, qui fournit les missiles des Rafale, et les 500 PME qui travaillent sur le projet Rafale. Premier client à l''export, l''Égypte fait l''acquisition de 24 appareils en février 2015, puis de 31 avions supplémentaires en mai 2021 pour un total cumulé de 8.5 milliards d''euros. Le 4 mai 2015, le Qatar commande dans un premier temps 24 appareils, puis portera en 2017 son total à 36 pour un prix total de 7.4 milliards d''euros. Bien que le 10 avril 2015, l''Inde annonce son intention d''acheter 36 appareils, la commande ne se concrétise que le 23 septembre 2016 pour 7.8 milliards d''euros. Fin 2020, dans le cadre de tensions croissantes en mer Méditerranée, la Grèce se décide à commander 18 appareils (dont 12 d''occasion) et un ensemble de munitions, puis également 6 supplémentaires en 2022 pour un montant total de 3 milliards d''euros. En 2021, la Croatie annonce acquérir, pour approximativement 1 milliard d''euros, 12 appareils d''occasion. Le 3 décembre 2021, Dassault Aviation annonce la vente de 80 unités au standard F4 aux Émirats arabes unis, pour un total de 17 milliards d''euros pour un ensemble qui inclut également des munitions et des hélicoptères Caracal d''Airbus. L''Indonésie annonce en février 2022 l''achat de 42 unités pour une somme supérieure à 7 milliards d''euros. Les contrats successifs à l''export ont donc engrangé au total un chiffre d''affaires de 48.7 milliards d''euros.

Le Rafale a réalisé des missions de bombardement durant la guerre d''Afghanistan (2001-2021), lors de l''opération Serval au Mali et lors de l''opération Chammal contre l''État islamique en Irak et en Syrie, ainsi que des missions d''interdiction et de bombardement au cours de l''intervention militaire de 2011 en Libye.

En 2018, Dassault a annoncé le successeur du Rafale. Actuellement en développement par Dassault Aviation et Airbus Defence and Space dans le cadre du programme SCAF, le Chasseur de nouvelle génération devrait remplacer les Rafale français, les Eurofighter Typhoon allemands et les F/A-18 Hornet espagnols à l''horizon 2035-2040.

En octobre 2024, le ministère des Armées lance le développement d''un drone de combat qui accompagnera le Rafale F5 à partir de 2033, afin de le doter de la capacité à supprimer et à détruire les défenses aériennes adverses [SEAD]. « pour que sa capacité de pénétration reste crédible au moins jusqu''en 2060 ». Il « bénéficiera des acquis » du nEUROn selon Dassault qui est chargé de le construire.',
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