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
    'Panavia Tornado',
    'Panavia Tornado',
    'Panavia Tornado',
    'Panavia Tornado',
    'Avion multirôle européen de 4e génération à géométrie variable',
    'European 4th-generation variable-geometry multirole aircraft',
    '/assets/airplanes/tornado.jpg',
    'Le Panavia Tornado est un avion de combat multirôle développé conjointement par le Royaume-Uni, l''Allemagne de l''Ouest et l''Italie dans le cadre du consortium Panavia Aircraft GmbH. Classé dans la 4e génération, il se distingue par ses ailes à géométrie variable et son radar de suivi de terrain, lui permettant des pénétrations à très basse altitude et grande vitesse. Décliné en trois variantes principales — IDS (interdiction/frappe), ECR (suppression des défenses aériennes) et ADV (défense aérienne) —, il a été un pilier des forces aériennes européennes et de l''OTAN pendant plus de quatre décennies, participant à de nombreux conflits depuis la Guerre du Golfe.',
    'The Panavia Tornado is a multirole combat aircraft jointly developed by the United Kingdom, West Germany and Italy as part of the Panavia Aircraft GmbH consortium. Classified as 4th generation, it is distinguished by its variable-geometry wings and its terrain-following radar, allowing it to penetrate at very low altitude and high speed. Declined in three main variants — IDS (interdiction/strike), ECR (suppression of enemy air defenses) and ADV (air defense) —, it was a pillar of European and NATO air forces for more than four decades, participating in numerous conflicts since the Gulf War.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1968-07-01',
    '1974-08-14',
    '1979-07-06',
    2337.0,
    3890.0,
    (SELECT id FROM manufacturer WHERE code = 'BAE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    NULL,
    13890.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM tech WHERE name = 'Radar de suivi de terrain')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'Storm Shadow')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'Brimstone')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'Paveway IV')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM armement WHERE name = 'BL755'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 16.72, wingspan = 8.60, height = 5.95, wing_area = 26.6,
  empty_weight = 13890, mtow = 28000, service_ceiling = 15240, climb_rate = 77,
  combat_radius = 1390, crew = 2, g_limit_pos = 7.5,
  engine_name = 'Turbo-Union RB199-34R Mk.103', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 43.8, thrust_wet = 73.5,
  production_start = 1979, production_end = 1998, units_built = 990,
  operators_count = 4,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Panavia_Tornado',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Panavia_Tornado'
WHERE name = 'Panavia Tornado';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 35000000, unit_cost_year = 1988,
  variants    = E'- **Tornado IDS** : attaque au sol/frappe (RAF/GR, Luftwaffe, Aeronautica Militare)\n- **Tornado ADV / F.3** : intercepteur longue portée (RAF)\n- **Tornado ECR** : guerre électronique + SEAD (Luftwaffe, Italie)\n- **Tornado GR.4** : modernisation mi-vie RAF',
  variants_en = E'- **Tornado IDS** : interdictor/strike (RAF/GR, Luftwaffe, AM)\n- **Tornado ADV / F.3** : long-range interceptor (RAF)\n- **Tornado ECR** : electronic warfare + SEAD (Luftwaffe, Italy)\n- **Tornado GR.4** : RAF mid-life upgrade'
WHERE name = 'Panavia Tornado';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nRésultat du programme **Panavia** trinational (Royaume-Uni, Allemagne, Italie) des années 1970 pour créer un avion multi-rôle à aile à géométrie variable. Trois variantes distinctes pour trois missions : **IDS** (strike), **ADV** (intercepteur), **ECR** (guerre électronique).\n\n## Carrière opérationnelle\nEngagé massivement durant la guerre du Golfe (1991), au Kosovo, en Irak (2003), en Libye (2011), en Syrie (2015). Grande précision en frappe de nuit tous temps.\n\n## Héritage\nRetiré par la RAF en 2019 (remplacé par le Typhoon et le F-35), encore en service en Allemagne et Italie. Base technologique du Typhoon et de l''Eurofighter.',
  description_en = E'## Genesis\nResult of the trinational **Panavia** programme (UK, Germany, Italy) of the 1970s to create a variable-sweep-wing multi-role aircraft. Three distinct variants for three missions: **IDS** (strike), **ADV** (interceptor), **ECR** (electronic warfare).\n\n## Operational career\nHeavily used during the Gulf War (1991), Kosovo, Iraq (2003), Libya (2011), Syria (2015). High precision in all-weather night strikes.\n\n## Legacy\nRetired by the RAF in 2019 (replaced by the Typhoon and F-35), still in service in Germany and Italy. Technology base for the Typhoon and Eurofighter.'
WHERE name = 'Panavia Tornado';
