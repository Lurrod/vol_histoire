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
    'Blackburn Buccaneer',
    'Blackburn Buccaneer',
    'Blackburn (Hawker Siddeley) Buccaneer',
    'Blackburn (Hawker Siddeley) Buccaneer',
    'Bombardier embarqué britannique de 2e génération spécialisé dans l''attaque à basse altitude',
    'British 2nd-generation carrier-based bomber specialized in low-altitude attack',
    '/assets/airplanes/blackburn_buccaneer.jpg',
    'Le Blackburn Buccaneer est un avion d''attaque embarqué conçu pour la Royal Navy afin de mener des frappes antinavires à très basse altitude sous la couverture radar ennemie. Classé dans la 2e génération, il se distingue par son système de soufflage de couche limite sur les ailes et les gouvernes, lui conférant d''excellentes performances à basse vitesse indispensables aux opérations sur porte-avions. Propulsé par deux réacteurs Rolls-Royce Spey, il possède une soute à bombes rotative interne et peut emporter une charge offensive considérable. Après le retrait des porte-avions britanniques, le Buccaneer a été transféré à la RAF où il a servi comme bombardier tactique à pénétration basse altitude. Il s''est illustré pendant la guerre du Golfe en 1991 comme désignateur laser pour les Tornado, prouvant sa valeur jusqu''à sa retraite en 1994. L''Afrique du Sud l''a également employé au combat.',
    'The Blackburn Buccaneer is a carrier-based attack aircraft designed for the Royal Navy to carry out anti-ship strikes at very low altitude under enemy radar cover. Classified as 2nd generation, it is distinguished by its boundary layer blowing system on wings and control surfaces, giving it excellent low-speed performance essential for carrier operations. Powered by two Rolls-Royce Spey engines, it has an internal rotating bomb bay and can carry a considerable offensive load. After the withdrawal of British aircraft carriers, the Buccaneer was transferred to the RAF where it served as a low-altitude penetration tactical bomber. It distinguished itself during the Gulf War in 1991 as a laser designator for Tornados, proving its value until its retirement in 1994. South Africa also employed it in combat.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1955-01-01',
    '1958-04-30',
    '1962-07-17',
    1040.0,
    3700.0,
    (SELECT id FROM manufacturer WHERE code = 'BAE'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    NULL,
    13608.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Spey')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Radar Blue Parrot')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'Martel AJ-168')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'Sea Eagle')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'WE.177')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'BL755')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = '1000 lb GP')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 19.33, wingspan = 13.41, height = 4.97, wing_area = 47.82,
  empty_weight = 13640, mtow = 28120, service_ceiling = 12200, climb_rate = 35.6,
  combat_radius = 966, crew = 2,
  engine_name = 'Rolls-Royce Spey Mk.101', engine_count = 2,
  engine_type = 'Turbofan', engine_type_en = 'Turbofan',
  thrust_dry = 49.0,
  production_start = 1960, production_end = 1977, units_built = 211,
  operators_count = 2,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Blackburn_Buccaneer',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Blackburn_Buccaneer'
WHERE name = 'Blackburn Buccaneer';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 3000000, unit_cost_year = 1970,
  variants    = E'- **Buccaneer S.1** : version initiale Royal Navy (moteurs Gyron Junior)\n- **Buccaneer S.2** : remoteurisation Spey, export Afrique du Sud\n- **Buccaneer S.2B** : version RAF (transfert après retrait des porte-avions)'
WHERE name = 'Blackburn Buccaneer';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nAvion d''attaque embarqué britannique développé dans les années 1950 pour la Royal Navy. Conçu pour le vol à très basse altitude à grande vitesse (sous la couverture radar soviétique) depuis les porte-avions HMS Victorious et HMS Ark Royal.\n\n## Carrière opérationnelle\nTransféré à la **RAF** après le retrait des porte-avions britanniques en 1978. Engagé massivement durant la guerre du Golfe (1991) pour la désignation laser. Son profil de vol très bas en faisait un pénétrateur redoutable.\n\n## Héritage\nRetiré en 1994. Souvent cité comme l''un des meilleurs avions d''attaque jamais conçus. Clone fonctionnel du F-111 américain.',
  description_en = E'## Genesis\nBritish carrier-based strike aircraft developed in the 1950s for the Royal Navy. Designed for very low-altitude high-speed flight (below Soviet radar coverage) from HMS Victorious and HMS Ark Royal.\n\n## Operational career\nTransferred to the **RAF** after the retirement of British carriers in 1978. Heavily used during the Gulf War (1991) for laser designation. Its very low-level profile made it a formidable penetrator.\n\n## Legacy\nRetired in 1994. Often cited as one of the best strike aircraft ever designed. A functional counterpart to the American F-111.'
WHERE name = 'Blackburn Buccaneer';

-- [auto:008] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  variants_en = E'- **Buccaneer S.1** : initial Royal Navy variant (Gyron Junior engines)\n- **Buccaneer S.2** : Spey re-engining, South African export\n- **Buccaneer S.2B** : RAF variant (transferred after carrier retirement)'
WHERE name = 'Blackburn Buccaneer';
