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
    'Eurofighter Typhoon Allemand',
    'German Eurofighter Typhoon',
    'Eurofighter Typhoon (Luftwaffe)',
    'Eurofighter Typhoon (Luftwaffe)',
    'Chasseur multirôle européen de 4e génération au service de la Luftwaffe',
    'European 4th-generation multirole fighter in Luftwaffe service',
    'https://i.postimg.cc/vmRJqz1F/eurofighter-allemand.jpg',
    'L''Eurofighter Typhoon allemand est la version exploitée par la Luftwaffe, assemblée par Airbus Defence and Space sur le site de Manching en Bavière. L''Allemagne, partenaire fondateur du programme aux côtés du Royaume-Uni, de l''Italie et de l''Espagne, a commandé 143 appareils répartis en quatre tranches successives. Conçu autour d''une configuration canard-delta instable et d''une commande de vol entièrement électrique, le Typhoon offre des performances exceptionnelles en combat aérien rapproché grâce à sa maniabilité et son rapport poussée/poids élevé. La Luftwaffe a progressivement fait évoluer ses Typhoon du rôle initial de supériorité aérienne vers une capacité multirôle complète, intégrant le radar CAPTOR-E à antenne active (AESA), le missile Meteor à longue portée et des armements air-sol comme le GBU-49 et le Taurus KEPD 350. L''appareil assure la police du ciel au-dessus de l''Allemagne et contribue régulièrement aux missions de police aérienne renforcée de l''OTAN dans les pays baltes et en Europe de l''Est. Le Typhoon constitue l''épine dorsale de la chasse allemande et restera en service au-delà de 2060 grâce au programme d''évolution Quadriga.',
    'The German Eurofighter Typhoon is the version operated by the Luftwaffe, assembled by Airbus Defence and Space at the Manching facility in Bavaria. Germany, a founding partner of the program alongside the United Kingdom, Italy and Spain, ordered 143 aircraft divided into four successive tranches. Designed around an unstable canard-delta configuration and a fully electric flight control system, the Typhoon offers exceptional performance in close air combat thanks to its maneuverability and high thrust-to-weight ratio. The Luftwaffe has gradually evolved its Typhoons from the initial air superiority role to a full multirole capability, integrating the CAPTOR-E active array radar (AESA), the long-range Meteor missile and air-to-ground armaments such as the GBU-49 and Taurus KEPD 350. The aircraft provides air policing over Germany and regularly contributes to NATO enhanced air policing missions in the Baltic states and Eastern Europe. The Typhoon is the backbone of German fighter aviation and will remain in service beyond 2060 thanks to the Quadriga evolution program.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1983-01-01',
    '1994-03-27',
    '2004-08-04',
    2495.0,
    2900.0,
    (SELECT id FROM manufacturer WHERE code = 'ADS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    11000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Radar CAPTOR')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'IRIS-T')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'GBU-49')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));