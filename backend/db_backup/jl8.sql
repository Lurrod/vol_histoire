-- Insertion du nouveau constructeur
INSERT INTO manufacturer (name, country_id, code) VALUES
('Hongdu Aviation Industry', (SELECT id FROM countries WHERE code = 'CHN'), 'HONG');

-- Insertion du nouveau type (idempotent : ne réinsère pas si déjà présent)
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Entraîneur', 'Trainer',
       'Avion d''entraînement conçu pour la formation des pilotes militaires',
       'Aircraft designed for the training of military pilots'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Entraîneur');

-- Renseigne la traduction si la ligne existe déjà mais sans name_en
UPDATE type
   SET name_en = COALESCE(name_en, 'Trainer'),
       description_en = COALESCE(description_en, 'Aircraft designed for the training of military pilots')
 WHERE name = 'Entraîneur';

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
    'Hongdu JL-8',
    'Hongdu JL-8',
    'Hongdu JL-8 Karakorum',
    'Hongdu JL-8 Karakorum',
    'Avion d''entraînement et d''appui léger chinois de 3e génération',
    'Chinese 3rd-generation light trainer and support aircraft',
    '/assets/airplanes/jl8.jpg',
    'Le Hongdu JL-8, également connu sous sa désignation d''exportation K-8 Karakorum, est un avion d''entraînement avancé et d''appui aérien léger développé conjointement par la Chine et le Pakistan. Conçu par Hongdu Aviation Industry (anciennement Nanchang Aircraft Corporation), il a effectué son premier vol en 1990 et est entré en service en 1994. Biplace en tandem, le JL-8 est destiné à la formation intermédiaire et avancée des pilotes, mais possède également une capacité d''attaque légère grâce à ses cinq points d''emport. Fiable, économique et facile à entretenir, il a rencontré un grand succès à l''exportation avec plus de 500 exemplaires livrés à une quinzaine de pays, principalement en Afrique, en Asie et au Moyen-Orient. Il reste l''un des avions d''entraînement les plus exportés au monde.',
    'The Hongdu JL-8, also known by its export designation K-8 Karakorum, is an advanced trainer and light air support aircraft jointly developed by China and Pakistan. Designed by Hongdu Aviation Industry (formerly Nanchang Aircraft Corporation), it made its first flight in 1990 and entered service in 1994. Two-seat tandem, the JL-8 is intended for intermediate and advanced pilot training, but also has a light attack capability thanks to its five hardpoints. Reliable, economical and easy to maintain, it has met with great export success with more than 500 examples delivered to around fifteen countries, mainly in Africa, Asia and the Middle East.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '1986-01-01',
    '1990-11-21',
    '1994-01-01',
    800.0,
    2200.0,
    (SELECT id FROM manufacturer WHERE code = 'HONG'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Actif',
    'Active',
    2687.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM tech WHERE name = 'Réacteur Honeywell TFE731')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM armement WHERE name = 'PL-5')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM armement WHERE name = 'HF-16'));

-- Insertion des guerres
-- Le JL-8 n'a pas été engagé dans des conflits majeurs à ce jour, donc pas d'entrée dans airplane_wars

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Hongdu JL-8'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 12.32, wingspan = 9.46, height = 4.21, wing_area = 17.02,
  empty_weight = 2757, mtow = 4200, service_ceiling = 13200, climb_rate = 30,
  combat_radius = 500, crew = 2,
  engine_name = 'AI-25TLK', engine_count = 1,
  engine_type = 'Turbofan', engine_type_en = 'Turbofan',
  thrust_dry = 16.87,
  production_start = 1994, production_end = NULL, units_built = 450,
  operators_count = 6,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Hongdu_JL-8',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Hongdu_JL-8'
WHERE name = 'Hongdu JL-8';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 5000000, unit_cost_year = 2005
WHERE name = 'Hongdu JL-8';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nAvion d''entraînement avancé chinois développé à partir de 1987 par **Hongdu Aviation Industry Group**, en collaboration avec le Pakistan (désigné localement K-8 Karakorum).\n\n## Carrière opérationnelle\nExporté dans **6+ pays** : Pakistan, Égypte, Soudan, Myanmar, Namibie, Venezuela, Zambie. Utilisé comme entraîneur de chasse et pour l''acrobatie militaire. Produit également en Égypte sous licence.\n\n## Héritage\nPlus de **450 exemplaires** construits. Premier succès export significatif d''un avion d''entraînement chinois. Démontre la capacité chinoise à produire des avions légers compétitifs.',
  description_en = E'## Genesis\nChinese advanced trainer developed from 1987 by **Hongdu Aviation Industry Group**, in collaboration with Pakistan (locally designated K-8 Karakorum).\n\n## Operational career\nExported to **6+ countries**: Pakistan, Egypt, Sudan, Myanmar, Namibia, Venezuela, Zambia. Used as a fighter trainer and for military aerobatics. Also licence-built in Egypt.\n\n## Legacy\nMore than **450 built**. First significant export success of a Chinese training aircraft. Demonstrates the Chinese ability to produce competitive light aircraft.'
WHERE name = 'Hongdu JL-8';
