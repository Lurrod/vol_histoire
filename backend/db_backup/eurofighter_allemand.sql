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
    '/assets/airplanes/eurofighter-allemand.jpg',
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

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 15.96, wingspan = 10.95, height = 5.28, wing_area = 50.0,
  empty_weight = 11000, mtow = 23500, service_ceiling = 19810, climb_rate = 315,
  combat_radius = 1389, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'Eurojet EJ200', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 60.0, thrust_wet = 90.0,
  production_start = 1994, production_end = NULL, units_built = 594,
  operators_count = 10,
  rival_id = (SELECT id FROM airplanes WHERE name = 'Rafale' LIMIT 1),
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Eurofighter_Typhoon',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Eurofighter_Typhoon'
WHERE name = 'Eurofighter Typhoon Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 100000000, unit_cost_year = 2013,
  manufacturer_page = 'https://www.eurofighter.com/',
  variants    = E'- **Tranche 1** : configuration initiale, air-air limitée\n- **Tranche 2** : intégration ciblage air-sol\n- **Tranche 3/3A** : radar AESA Captor-E, nouvelles liaisons de données\n- **Tranche 4** : dernière tranche en production (commandes 2020+)',
  variants_en = E'- **Tranche 1** : initial configuration, limited air-to-air\n- **Tranche 2** : air-to-ground integration\n- **Tranche 3/3A** : Captor-E AESA radar, new datalinks\n- **Tranche 4** : latest production tranche (2020+ orders)'
WHERE name = 'Eurofighter Typhoon Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nIssu du programme européen **EFA** (European Fighter Aircraft) lancé en 1983, réunissant Royaume-Uni, Allemagne, Italie et Espagne après le retrait de la France (qui développera seule le Rafale). Plus de 20 ans de développement, premier vol opérationnel en 2003.\n\n## Carrière opérationnelle\nEngagé en Libye (2011), Syrie, Irak. Exporté en Arabie saoudite, Autriche, Oman, Koweït, Qatar. Déployé en mission **Baltic Air Policing** face aux incursions russes. Radar AESA **Captor-E** sur les versions récentes.\n\n## Héritage\nPlus de **590 exemplaires** produits ou commandés. Rival européen du Rafale sur le marché export (souvent en concurrence directe — Qatar, Émirats, Indonésie). Prépare le programme FCAS 6e génération.',
  description_en = E'## Genesis\nBorn from the European **EFA** (European Fighter Aircraft) programme launched in 1983, joining the UK, Germany, Italy and Spain after France''s withdrawal (which would develop the Rafale alone). More than 20 years of development, first operational flight in 2003.\n\n## Operational career\nEngaged in Libya (2011), Syria, Iraq. Exported to Saudi Arabia, Austria, Oman, Kuwait, Qatar. Deployed on **Baltic Air Policing** duty against Russian incursions. **Captor-E** AESA radar on recent variants.\n\n## Legacy\nMore than **590 built or ordered**. European rival of the Rafale on export markets (often in direct competition — Qatar, UAE, Indonesia). Leading into the 6th-generation FCAS programme.'
WHERE name = 'Eurofighter Typhoon Allemand';

-- [auto:011] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=4F-7EbzuUNY'
WHERE name = 'Eurofighter Typhoon Allemand';
