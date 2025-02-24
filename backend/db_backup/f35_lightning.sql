INSERT INTO tech (name, description) VALUES
('AN/APG-81', 'Radar AESA (Active Electronically Scanned Array) avec capacités avancées de détection'),
('F135-PW-100', 'Moteur Pratt & Whitney avec option de poussée vectorielle pour le STOVL'),
('EOTS', 'Système de ciblage électro-optique pour frappes de précision et reconnaissance');

INSERT INTO armement (name, description) 
SELECT 'GBU-31 JDAM', 'Bombe guidée par GPS (907 kg)' 
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-31 JDAM');

INSERT INTO armement (name, description) 
SELECT 'GAU-22/A', 'Canon interne de 25 mm (180-220 coups)' 
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GAU-22/A');

INSERT INTO missions (name, description) VALUES
('Supériorité aérienne furtive', 'Domination de l’espace aérien avec technologie stealth'),
('Frappe multirôle', 'Attaques au sol et missions air-air combinées'),
('ISR', 'Intelligence, surveillance et reconnaissance');

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
    'F-35 Lightning II',
    'Lockheed Martin F-35A Lightning II',
    'Chasseur furtif multirôle de 5e génération',
    'https://i.postimg.cc/W3YWZrjL/f35-lightning.jpg',
    'Le Lockheed Martin F-35 Lightning II est un avion de chasse furtif de cinquième génération, conçu pour des missions multirôles incluant la supériorité aérienne, la frappe au sol, et la collecte de renseignement. Développé dans le cadre du programme Joint Strike Fighter (JSF) pour remplacer des avions comme le F-16, l’A-10, et le F/A-18, il est produit en trois variantes principales : F-35A (CTOL), F-35B (STOVL), et F-35C (CATOBAR). Le programme, lancé en 1996, a vu le X-35 battre le Boeing X-32 en 2001. Le premier vol du F-35A a eu lieu le 15 décembre 2006, et il est entré en service opérationnel avec l’US Air Force le 2 août 2016. Le coût total du programme dépasse les 400 milliards de dollars, avec plus de 900 unités livrées à ce jour.\n\nLe F-35 est équipé du radar AN/APG-81 AESA, d’un système EOTS pour la visée, et du moteur F135-PW-100. Sa furtivité est assurée par sa conception, ses matériaux absorbants, et ses baies d’armes internes. Il peut emporter des missiles AIM-120 AMRAAM et AIM-9X pour le combat air-air, des bombes JDAM et Paveway pour les frappes au sol, et un canon GAU-22/A de 25 mm. Utilisé dans des opérations comme Inherent Resolve contre l’État islamique, le F-35 est en service dans plusieurs pays alliés (États-Unis, Royaume-Uni, Australie, Israël, etc.), bien que son développement ait été marqué par des retards et des critiques sur son coût et ses performances.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1996-01-01',
    '2006-12-15',
    '2016-08-02',
    1960, -- Mach 1.6
    2200, -- env. 1370 miles
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM tech WHERE name = 'AN/APG-81'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    13200 -- poids à vide en kg
);

-- Technologies (ajout des autres techs au-delà de AN/APG-81)
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), 
    id 
FROM tech 
WHERE name IN ('F135-PW-100', 'EOTS');

-- Armements (réutilisation des existants + nouveaux)
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), 
    id 
FROM armement 
WHERE name IN ('AIM-120 AMRAAM', 'AIM-9X Sidewinder', 'GBU-31 JDAM', 'GBU-12 Paveway II', 'GAU-22/A');

-- Guerres
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), 
    id 
FROM wars 
WHERE name IN ('Opération Inherent Resolve', 'Guerre d’Afghanistan');

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT 
    (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'), 
    id 
FROM missions 
WHERE name IN ('Supériorité aérienne furtive', 'Frappe multirôle', 'ISR');

