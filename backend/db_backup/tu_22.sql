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
    'Tu-22M',
    'Tu-22M',
    'Tupolev Tu-22M Backfire',
    'Tupolev Tu-22M Backfire',
    'Bombardier stratégique soviétique/russe de 3e génération',
    'Soviet/Russian 3rd-generation strategic bomber',
    'https://i.postimg.cc/BQkBRx3c/tu22.jpg',
    'Le Tupolev Tu-22M Backfire est un bombardier stratégique à géométrie variable développé pour les forces aériennes soviétiques, puis russes. Classé dans la 3e génération, il est conçu pour des missions de frappe stratégique et antinavire à longue portée, capable de transporter des missiles de croisière et des bombes conventionnelles. Utilisé pendant la Guerre froide et dans des conflits modernes, il reste un élément clé de la flotte russe.',
    'The Tupolev Tu-22M Backfire is a variable-geometry strategic bomber developed for the Soviet and later Russian air forces. Classified as 3rd generation, it is designed for long-range strategic and anti-ship strike missions, capable of carrying cruise missiles and conventional bombs. Used during the Cold War and in modern conflicts, it remains a key element of the Russian fleet.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1964-01-01',
    '1969-08-30',
    '1972-06-01',
    2000.0,
    7000.0,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Actif',
    'Active',
    54000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM tech WHERE name = 'Radar PN-AD')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'Kh-22')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'Kh-32')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'FAB-3000')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM armement WHERE name = 'FAB-5000'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Tu-22M'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));