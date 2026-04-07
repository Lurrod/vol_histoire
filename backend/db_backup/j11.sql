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
    'Shenyang J-11',
    'Shenyang J-11',
    'Shenyang J-11 Flanker',
    'Shenyang J-11 Flanker',
    'Chasseur de supériorité aérienne chinois de 4e génération',
    'Chinese 4th-generation air superiority fighter',
    'https://i.postimg.cc/NfCQtjCx/j11.jpg',
    'Le Shenyang J-11 est un chasseur de supériorité aérienne produit par Shenyang Aircraft Corporation, dérivé du Sukhoi Su-27 russe sous licence. Le programme a débuté dans les années 1990 avec l''assemblage sous licence de Su-27SK, avant d''évoluer vers le J-11B, une version entièrement sinisée intégrant des systèmes avioniques chinois, un radar AESA national et des réacteurs WS-10. Plus lourd et mieux armé que le J-10, le J-11 constitue l''épine dorsale de la chasse lourde de l''Armée populaire de libération et reste en production active avec des variantes modernisées.',
    'The Shenyang J-11 is an air superiority fighter produced by Shenyang Aircraft Corporation, derived from the Russian Sukhoi Su-27 under license. The program began in the 1990s with the licensed assembly of Su-27SK, before evolving into the J-11B, a fully sinicized version integrating Chinese avionics systems, a national AESA radar and WS-10 engines. Heavier and better armed than the J-10, the J-11 forms the backbone of the People',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '1995-01-01',
    '1998-12-16',
    '2000-06-01',
    2500.0,
    3530.0,
    (SELECT id FROM manufacturer WHERE code = 'SAC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Actif',
    'Active',
    16380.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM tech WHERE name = 'Réacteur WS-10')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM armement WHERE name = 'PL-8')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM armement WHERE name = 'PL-12')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM armement WHERE name = 'R-77')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM armement WHERE name = 'FAB-500'));

-- Insertion des guerres
-- Le J-11 n'a pas été engagé dans des conflits majeurs à ce jour, donc pas d'entrée dans airplane_wars

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), (SELECT id FROM missions WHERE name = 'Escorte'));