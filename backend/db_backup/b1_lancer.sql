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
    'B-1 Lancer',
    'B-1 Lancer',
    'Rockwell B-1 Lancer',
    'Rockwell B-1 Lancer',
    'Bombardier stratégique américain de 4e génération',
    'American 4th-generation strategic bomber',
    'https://i.postimg.cc/tgmfcsBK/b1-lancer.jpg',
    'Le Rockwell B-1 Lancer est un bombardier stratégique à géométrie variable développé pour l''US Air Force. Classé dans la 4e génération, il est conçu pour des missions de pénétration à basse altitude et à haute vitesse, capable de transporter une large gamme d''armes conventionnelles et nucléaires. Utilisé dans des conflits modernes, il excelle dans les frappes stratégiques de précision.',
    'The Rockwell B-1 Lancer is a variable-geometry strategic bomber developed for the US Air Force. Classified as 4th generation, it is designed for low-altitude high-speed penetration missions, capable of carrying a wide range of conventional and nuclear weapons. Used in modern conflicts, it excels in precision strategic strikes.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1970-01-01',
    '1974-12-23',
    '1986-10-01',
    1330.0,
    12000.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Actif',
    'Active',
    87000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM armement WHERE name = 'B61')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM armement WHERE name = 'B83')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM armement WHERE name = 'Mk 84')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM armement WHERE name = 'CBU-87'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'B-1 Lancer'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));