INSERT INTO tech (name, description) VALUES
('AN/APG-77', 'Radar AESA (Active Electronically Scanned Array) avec capacité de détection furtive'),
('F119-PW-100', 'Moteurs à poussée vectorielle permettant la supercroisière'),
('IRST', 'Système de recherche et de suivi infrarouge pour la détection passive');

INSERT INTO armement (name, description) VALUES
('AIM-120 AMRAAM', 'Missile air-air à guidage radar actif (portée 120 km)'),
('AIM-9X Sidewinder', 'Missile air-air à guidage infrarouge (portée 35 km)'),
('GBU-32 JDAM', 'Bombe guidée par GPS (907 kg)'),
('GBU-39 SDB', 'Petite bombe guidée de précision (113 kg)'),
('M61A2 Vulcan', 'Canon rotatif de 20 mm (480 coups)');

INSERT INTO wars (name, date_start, date_end, description) VALUES
('Opération Inherent Resolve', '2014-08-08', NULL, 'Campagne aérienne contre l’État islamique en Irak et en Syrie');

INSERT INTO missions (name, description) VALUES
('Supériorité aérienne furtive', 'Domination de l’espace aérien avec technologie stealth'),
('Frappe de précision', 'Attaques ciblées avec armement guidé'),
('Reconnaissance tactique', 'Collecte de données en environnement hostile');

INSERT INTO airplanes (
    name, 
    complete_name, 
    little_description, 
    image_url, 
    description, 
    country_id,
    date_concept, 
    date_first_fly, 
    date_operationel, 
    max_speed, 
    max_range, 
    id_manufacturer,
    id_tech,
    id_generation, 
    type, 
    status, 
    weight
) VALUES (
    'F-22 Raptor',
    'Lockheed Martin F-22 Raptor',
    'Chasseur furtif de 5e génération pour la supériorité aérienne',
    'https://i.postimg.cc/qM3ncn0c/f22-raptor.jpg',
    'Le Lockheed Martin F-22 Raptor est un avion de chasse furtif de cinquième génération développé pour l’US Air Force, conçu principalement pour la supériorité aérienne, mais capable de missions secondaires de frappe au sol et de reconnaissance. Issu du programme Advanced Tactical Fighter (ATF) lancé dans les années 1980 pour contrer les chasseurs soviétiques avancés, le F-22 est le premier avion opérationnel à combiner furtivité, supercroisière (vitesse supersonique sans postcombustion), agilité exceptionnelle et fusion de capteurs.\n\nLe développement a débuté en 1981, avec un contrat attribué à Lockheed Martin et Boeing en 1991 après une compétition contre le Northrop YF-23. Le prototype YF-22 a volé pour la première fois le 7 septembre 1990, et le F-22 de production a effectué son premier vol le 7 septembre 1997. Il est entré en service opérationnel le 15 décembre 2005. Le coût total du programme est estimé à environ 66,7 milliards de dollars pour 187 appareils produits, bien en deçà des 650 initialement prévus, en raison de restrictions budgétaires et de l’évolution des priorités vers le F-35.\n\nLe F-22 est équipé de deux moteurs Pratt & Whitney F119-PW-100 à poussée vectorielle, d’un radar AN/APG-77 AESA, et d’un système infrarouge IRST. Sa furtivité repose sur une conception à faible signature radar, des matériaux absorbants, et des baies d’armes internes. Il peut transporter des missiles AIM-120 AMRAAM et AIM-9X Sidewinder pour le combat air-air, ainsi que des bombes guidées JDAM et SDB pour les frappes au sol, complétées par un canon M61A2 Vulcan de 20 mm.\n\nOpérationnellement, le F-22 a été déployé dans des missions limitées, notamment lors de l’opération Inherent Resolve contre l’État islamique en Syrie à partir de 2014, où il a effectué des frappes de précision et assuré la supériorité aérienne. Il n’a jamais été exporté en raison de restrictions de sécurité imposées par le Congrès américain, restant exclusif à l’US Air Force. En 2011, la production a été arrêtée, et le F-22 est progressivement remplacé par le NGAD (Next Generation Air Dominance), bien qu’il reste en service actif en 2025 avec des mises à jour continues.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1981-01-01',
    '1997-09-07',
    '2005-12-15',
    2410, -- Mach 2.25
    2960, -- env. 1840 miles
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM tech WHERE name = 'AN/APG-77'), -- Une seule tech ici, les autres via airplane_tech
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'En service',
    19700 -- poids à vide en kg
);

-- Technologies (ajout des autres techs au-delà de AN/APG-77)
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), 
    id 
FROM tech 
WHERE name IN ('F119-PW-100', 'IRST');

-- Armements
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), 
    id 
FROM armement 
WHERE name IN ('AIM-120 AMRAAM', 'AIM-9X Sidewinder', 'GBU-32 JDAM', 'GBU-39 SDB', 'M61A2 Vulcan');

-- Guerres
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), 
    id 
FROM wars 
WHERE name IN ('Opération Inherent Resolve', 'Guerre d’Afghanistan');

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), 
    id 
FROM missions 
WHERE name IN ('Supériorité aérienne furtive', 'Frappe de précision', 'Reconnaissance tactique');