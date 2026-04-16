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
    '/assets/airplanes/eurofighter-anglais.jpg',
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
WHERE name = 'Eurofighter Typhoon Anglais';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 100000000, unit_cost_year = 2013,
  manufacturer_page = 'https://www.eurofighter.com/',
  variants    = E'- **Tranche 1** : configuration initiale, air-air limitée\n- **Tranche 2** : intégration ciblage air-sol\n- **Tranche 3/3A** : radar AESA Captor-E, nouvelles liaisons de données\n- **Tranche 4** : dernière tranche en production (commandes 2020+)',
  variants_en = E'- **Tranche 1** : initial configuration, limited air-to-air\n- **Tranche 2** : air-to-ground integration\n- **Tranche 3/3A** : Captor-E AESA radar, new datalinks\n- **Tranche 4** : latest production tranche (2020+ orders)'
WHERE name = 'Eurofighter Typhoon Anglais';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nMême programme EFA européen lancé en 1983, livraison à la **RAF** à partir de 2003. Les Tranche 1, 2 et 3 marquent des évolutions majeures d''avionique et de capacités.\n\n## Carrière opérationnelle\nEngagé par la RAF en Libye (2011), Syrie (2015), Irak. Patrouilles **Quick Reaction Alert** depuis les îles britanniques et les Malouines. Les Typhoon saoudiens ont participé à la guerre du Yémen.\n\n## Héritage\nSuccesseur du Tornado ADV dans la RAF. Participe aux missions OTAN de police aérienne en Europe de l''Est depuis 2014. Prévu en service jusque vers 2040.',
  description_en = E'## Genesis\nSame European EFA programme launched in 1983, deliveries to the **RAF** from 2003. Tranches 1, 2 and 3 mark major avionics and capability steps.\n\n## Operational career\nUsed by the RAF in Libya (2011), Syria (2015), Iraq. **Quick Reaction Alert** sorties from the British Isles and the Falklands. Saudi Typhoons participated in the Yemen war.\n\n## Legacy\nTornado ADV successor in the RAF. Participates in NATO air-policing missions in Eastern Europe since 2014. Planned in service until around 2040.'
WHERE name = 'Eurofighter Typhoon Anglais';

-- [auto:011] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=4F-7EbzuUNY'
WHERE name = 'Eurofighter Typhoon Anglais';
