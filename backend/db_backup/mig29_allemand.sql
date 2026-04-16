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
    'MiG-29 Allemand',
    'German MiG-29',
    'Mikoyan MiG-29A/UB Fulcrum (NVA / Luftwaffe)',
    'Mikoyan MiG-29A/UB Fulcrum (NVA / Luftwaffe)',
    'Chasseur de supériorité aérienne de 4e génération, joyau hérité de l''Allemagne de l''Est',
    '4th-generation air superiority fighter, jewel inherited from East Germany',
    '/assets/airplanes/mig29-allemand.jpg',
    'Le MiG-29 allemand constitue un cas unique dans l''histoire de l''aviation militaire : seul chasseur de 4e génération du Pacte de Varsovie à avoir été intégré et exploité opérationnellement au sein de l''OTAN. La Nationale Volksarmee (NVA) de l''Allemagne de l''Est reçut 24 appareils — 20 MiG-29A monoplaces et 4 MiG-29UB biplaces — à partir de 1988, seulement deux ans avant la chute du Mur de Berlin. Après la réunification de 1990, contrairement aux MiG-21 et MiG-23 rapidement retirés, la Luftwaffe décida de conserver les MiG-29 en service actif au sein du JG 73 « Steinhoff » basé à Laage, en Mecklembourg. Cette décision s''avéra stratégiquement précieuse : les Fulcrum allemands participèrent à de nombreux exercices OTAN, révélant les capacités redoutables du missile R-73 Archer couplé au viseur de casque, et démontrant une supériorité en combat rapproché face aux F-16 et F/A-18 occidentaux. Les appareils furent modernisés aux standards OTAN avec l''intégration de systèmes IFF, de communications sécurisées et d''un GPS. En 2003, après 15 ans de service sous les couleurs allemandes, les 22 MiG-29 restants furent cédés à la Pologne pour un euro symbolique chacun, mettant fin à ce chapitre exceptionnel de l''aviation européenne.',
    'The German MiG-29 constitutes a unique case in military aviation history: the only 4th-generation fighter from the Warsaw Pact to have been integrated and operationally operated within NATO. The East German Nationale Volksarmee (NVA) received 24 aircraft — 20 single-seat MiG-29A and 4 twin-seat MiG-29UB — from 1988, only two years before the fall of the Berlin Wall. After the 1990 reunification, unlike the MiG-21 and MiG-23 which were quickly retired, the Luftwaffe decided to keep the MiG-29s in active service within JG 73 "Steinhoff" based at Laage in Mecklenburg. This decision proved strategic.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1974-01-01',
    '1977-10-06',
    '1988-05-01',
    2450.0,
    1430.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    NULL,
    11000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Radar N019')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-27R')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-27T')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'S-8'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 17.32, wingspan = 11.36, height = 4.73, wing_area = 38.0,
  empty_weight = 11000, mtow = 20000, service_ceiling = 18013, climb_rate = 330,
  combat_radius = 700, crew = 1,
  engine_name = 'Klimov RD-33', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 49.4, thrust_wet = 81.4,
  nickname = 'Fulcrum',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mikoyan_MiG-29',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mikoyan_MiG-29'
WHERE name = 'MiG-29 Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 29000000, unit_cost_year = 1989,
  operators_count = 1,
  variants    = E'- **MiG-29A** : Luftwaffe est-allemande (NVA, puis intégrée Luftwaffe 1990-2004)\n- Transférés à la Pologne pour 1 € symbolique en 2003-2004',
  variants_en = E'- **MiG-29A** : East German Air Force (NVA, then Luftwaffe 1990–2004)\n- Transferred to Poland for symbolic €1 in 2003–2004'
WHERE name = 'MiG-29 Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nLivrés à la **NVA** est-allemande à partir de 1988 comme chasseur le plus moderne du Pacte de Varsovie. 24 exemplaires reçus, intégrés à la Luftwaffe après la réunification.\n\n## Carrière opérationnelle\nPrécieux pour l''OTAN : permet d''évaluer les performances réelles du MiG-29 face aux chasseurs occidentaux. Intégrés à l''entraînement de combat Luftwaffe jusqu''à leur transfert à la Pologne.\n\n## Héritage\nTransférés à la **Pologne** en 2003-2004 pour 1 € symbolique. Fin de l''aventure allemande du MiG-29. Une des rares occasions où une armée OTAN a opéré un avion soviétique pendant plus de 10 ans.',
  description_en = E'## Genesis\nDelivered to the **East German NVA** from 1988 as the most modern Warsaw Pact fighter. 24 airframes received, integrated into the Luftwaffe after reunification.\n\n## Operational career\nValuable for NATO: allowed evaluation of real MiG-29 performance against Western fighters. Integrated into Luftwaffe combat training until their transfer to Poland.\n\n## Legacy\nTransferred to **Poland** in 2003-2004 for a symbolic €1. End of the German MiG-29 story. One of the rare cases where a NATO air force operated a Soviet aircraft for more than 10 years.'
WHERE name = 'MiG-29 Allemand';

-- [auto:012] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=sWGjdtKv2kk'
WHERE name = 'MiG-29 Allemand';
