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
    'Eurofighter Typhoon Anglais',
    'British Eurofighter Typhoon',
    'Eurofighter Typhoon (Royal Air Force)',
    'Eurofighter Typhoon (Royal Air Force)',
    'Chasseur multirôle européen de 4e génération au service de la RAF',
    'European 4th-generation multirole fighter in RAF service',
    'https://i.postimg.cc/c1Mv6KW1/eurofighter-anglais.jpg',
    'L''Eurofighter Typhoon est un avion de combat multirôle développé par un consortium européen regroupant le Royaume-Uni, l''Allemagne, l''Italie et l''Espagne. Classé dans la 4e génération avancée, il se distingue par sa configuration canard-delta, sa commande de vol électrique et ses performances exceptionnelles en combat aérien rapproché. La version britannique, opérée par la Royal Air Force, a été déployée en opérations réelles au-dessus de la Libye, de l''Irak et de la Syrie. Équipé du radar CAPTOR évoluant vers une antenne AESA, de missiles Meteor à longue portée et du système de fusion de capteurs, le Typhoon constitue l''épine dorsale de la défense aérienne britannique et restera en service au-delà de 2040.',
    'The Eurofighter Typhoon is a multirole combat aircraft developed by a European consortium bringing together the United Kingdom, Germany, Italy and Spain. Classified as advanced 4th generation, it is distinguished by its canard-delta configuration, its electric flight control system and its exceptional performance in close air combat. The British version, operated by the Royal Air Force, has been deployed in real operations over Libya, Iraq and Syria. Equipped with the CAPTOR radar evolving towards an AESA array, long-range Meteor missiles and the sensor fusion system, the Typhoon forms the backbone of British air defense and will remain in service beyond 2040.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1983-01-01',
    '1994-03-27',
    '2003-12-04',
    2495.0,
    2900.0,
    (SELECT id FROM manufacturer WHERE code = 'BAE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    11000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM tech WHERE name = 'Radar CAPTOR')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'ASRAAM')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'Storm Shadow')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'Brimstone')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'Paveway IV')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));