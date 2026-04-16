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
    'Avro Vulcan',
    'Avro Vulcan',
    'Avro Vulcan B.2',
    'Avro Vulcan B.2',
    'Bombardier stratégique nucléaire britannique de 2e génération à aile delta',
    'British 2nd-generation strategic nuclear bomber with delta wing',
    '/assets/airplanes/avro_vulcan.jpg',
    'L''Avro Vulcan est un bombardier stratégique à aile delta développé pour la Royal Air Force dans le cadre de la force de dissuasion nucléaire britannique, les célèbres « V-Bombers ». Classé dans la 2e génération, il se distingue par sa spectaculaire voilure delta sans empennage, lui offrant une grande altitude opérationnelle et une maniabilité surprenante pour un bombardier de cette taille. Propulsé par quatre réacteurs Rolls-Royce Olympus, il était capable de pénétrer l''espace aérien soviétique à haute altitude pour délivrer des armes nucléaires. Avec l''évolution des défenses antiaériennes, son rôle a évolué vers la pénétration à basse altitude. Le Vulcan s''est illustré de manière spectaculaire lors de la guerre des Malouines en 1982 avec les raids « Black Buck », les missions de bombardement les plus longues de l''histoire à cette époque, frappant l''aérodrome de Port Stanley. Retiré en 1984, il reste l''un des avions militaires britanniques les plus emblématiques.',
    'The Avro Vulcan is a delta-wing strategic bomber developed for the Royal Air Force as part of the British nuclear deterrent force, the famous "V-Bombers". Classified as 2nd generation, it is distinguished by its spectacular tailless delta wing, offering it high operational altitude and surprising maneuverability for a bomber of this size. Powered by four Rolls-Royce Olympus engines, it was capable of penetrating Soviet airspace at high altitude to deliver nuclear weapons. With the evolution of air defenses, its role evolved towards low-altitude penetration. The Vulcan distinguished itself spectacularly during the Falklands War in 1982 with the "Black Buck" raids, the longest bombing missions in history at the time, striking Port Stanley airfield. Retired in 1984, it remains one of the most iconic British military aircraft.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1947-01-01',
    '1952-08-30',
    '1957-05-20',
    1038.0,
    7400.0,
    (SELECT id FROM manufacturer WHERE code = 'BAE'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    NULL,
    37144.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Radar H2S')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM armement WHERE name = 'WE.177')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM armement WHERE name = '1000 lb GP')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM armement WHERE name = 'AGM-45 Shrike'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 32.15, wingspan = 33.83, height = 8.28, wing_area = 368.3,
  empty_weight = 37144, mtow = 92534, service_ceiling = 16800, climb_rate = 20.3,
  combat_radius = 2600, crew = 5,
  engine_name = 'Rolls-Royce Olympus 301', engine_count = 4,
  engine_type = 'Turboréacteur', engine_type_en = 'Turbojet',
  thrust_dry = 88.96,
  production_start = 1952, production_end = 1965, units_built = 136,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Avro_Vulcan',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Avro_Vulcan'
WHERE name = 'Avro Vulcan';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 2000000, unit_cost_year = 1960,
  variants    = E'- **Vulcan B.1** : version initiale, bombe nucléaire à chute libre\n- **Vulcan B.2** : version modernisée, missile Blue Steel\n- **Vulcan K.2** : conversion ravitailleur (post-Falklands)'
WHERE name = 'Avro Vulcan';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nBombardier stratégique **V-force** (Vulcan, Valiant, Victor) développé dans les années 1950 pour porter les bombes nucléaires britanniques. Premier bombardier à aile delta jamais produit.\n\n## Carrière opérationnelle\nRôle principal : **dissuasion nucléaire britannique** pendant toute la guerre froide. Exploit historique : les missions **Black Buck** lors de la guerre des Malouines (1982), avec 14 000 km aller-retour vers l''Argentine, plus long raid de bombardement de l''histoire jusqu''alors.\n\n## Héritage\nRetiré en 1984. Dernier représentant volant (Vulcan XH558) a effectué son dernier vol en 2015. Symbole de l''aviation militaire britannique d''après-guerre.',
  description_en = E'## Genesis\nStrategic **V-force** bomber (Vulcan, Valiant, Victor) developed in the 1950s to carry British nuclear bombs. The first delta-wing bomber ever produced.\n\n## Operational career\nPrimary role: **British nuclear deterrent** throughout the Cold War. Historic feat: the **Black Buck** missions during the Falklands War (1982), 14,000 km round trips to Argentina, the longest bombing raid in history at that point.\n\n## Legacy\nRetired in 1984. The last flying example (Vulcan XH558) made its final flight in 2015. A symbol of British post-war military aviation.'
WHERE name = 'Avro Vulcan';

-- [auto:008] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  variants_en = E'- **Vulcan B.1** : initial version, free-fall nuclear bomb\n- **Vulcan B.2** : upgraded variant, Blue Steel missile\n- **Vulcan K.2** : tanker conversion (post-Falklands)'
WHERE name = 'Avro Vulcan';

-- [auto:012] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=a_VDLWQ1Pgw'
WHERE name = 'Avro Vulcan';
