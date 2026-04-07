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
    'MiG-23 Allemand',
    'German MiG-23',
    'Mikoyan-Gourevitch MiG-23MF/BN Flogger (NVA / Luftwaffe)',
    'Mikoyan-Gurevich MiG-23MF/BN Flogger (NVA / Luftwaffe)',
    'Chasseur multirôle soviétique de 3e génération à géométrie variable au service de l''Allemagne de l''Est',
    'Soviet 3rd-generation variable-geometry multirole fighter in East German service',
    'https://i.postimg.cc/jjVpgXWT/mig23-allemand.jpg',
    'Le MiG-23 allemand fut exploité par les forces aériennes de la République démocratique allemande (Luftstreitkräfte der NVA) en deux variantes principales : le MiG-23MF Flogger-B pour l''interception et la supériorité aérienne, et le MiG-23BN Flogger-H dédié à l''attaque au sol. À partir de 1978, l''Allemagne de l''Est reçut environ 50 MiG-23 qui remplacèrent progressivement une partie des MiG-21 vieillissants. Doté d''ailes à géométrie variable — une première pour les forces est-allemandes —, le MiG-23 offrait une portée et des capacités radar supérieures à son prédécesseur grâce au radar Saphir-21 (RP-23) et aux missiles R-23/R-24 à moyenne portée. La variante BN disposait d''un système de navigation et d''attaque Sokol permettant des frappes précises à basse altitude. Après la réunification de 1990, la Luftwaffe récupéra les appareils encore opérationnels. Comme pour les MiG-21, ils furent brièvement utilisés pour l''évaluation et l''entraînement dissimilaire, offrant aux pilotes occidentaux une connaissance directe des capacités du Pacte de Varsovie. L''ensemble de la flotte fut retirée du service en 1993, certains exemplaires étant cédés aux États-Unis pour des programmes d''évaluation classifiés.',
    'The German MiG-23 was operated by the East German air forces (Luftstreitkräfte der NVA) in two main variants: the MiG-23MF Flogger-B for interception and air superiority, and the MiG-23BN Flogger-H dedicated to ground attack. From 1978, East Germany received approximately 50 MiG-23s which gradually replaced some of the aging MiG-21s. Equipped with variable-geometry wings — a first for East German forces — the MiG-23 offered superior range and radar capabilities to its predecessor thanks to the Saphir-21 radar.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1964-01-01',
    '1967-06-10',
    '1978-06-01',
    2500.0,
    1900.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    NULL,
    11780.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM tech WHERE name = 'Radar RP-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'R-23R')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'R-23T')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'R-3S')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'Kh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'S-24'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));