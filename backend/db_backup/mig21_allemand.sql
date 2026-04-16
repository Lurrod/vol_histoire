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
    'MiG-21 Allemand',
    'German MiG-21',
    'Mikoyan-Gourevitch MiG-21 Fishbed (NVA / Luftwaffe)',
    'Mikoyan-Gurevich MiG-21 Fishbed (NVA / Luftwaffe)',
    'Chasseur supersonique soviétique de 3e génération au service de l''Allemagne de l''Est puis réunifiée',
    'Soviet 3rd-generation supersonic fighter in East German and reunified German service',
    '/assets/airplanes/mig21-allemand.jpg',
    'Le MiG-21 allemand fut l''avion de combat principal des forces aériennes de la République démocratique allemande (Nationale Volksarmee - NVA). À partir de 1962, l''Allemagne de l''Est reçut progressivement plusieurs variantes du Fishbed — MiG-21F-13, MiG-21PF, MiG-21PFM, MiG-21M, MiG-21MF, MiG-21bis et MiG-21U d''entraînement — totalisant plus de 570 appareils livrés par l''Union soviétique. Le MiG-21 constitua l''épine dorsale de la défense aérienne est-allemande pendant toute la Guerre froide, assurant l''interception et la supériorité aérienne face aux forces de l''OTAN le long du rideau de fer. La version MiG-21bis, dernière évolution majeure, disposait du réacteur Tumansky R-25-300 plus puissant et du radar RP-22 amélioré. Après la réunification allemande en 1990, la Luftwaffe hérita de 24 MiG-21bis encore opérationnels. Brièvement évalués et utilisés pour l''entraînement au combat dissimilaire — offrant aux pilotes de l''OTAN une expérience unique face à un chasseur du Pacte de Varsovie —, ils furent définitivement retirés du service en 1993 et remplacés par des appareils occidentaux.',
    'The German MiG-21 was the main combat aircraft of the East German air force (Nationale Volksarmee - NVA). From 1962, East Germany gradually received several variants of the Fishbed — MiG-21F-13, MiG-21PF, MiG-21PFM, MiG-21M, MiG-21MF, MiG-21bis and MiG-21U trainers — totaling more than 570 aircraft delivered by the Soviet Union. The MiG-21 formed the backbone of East German air defense throughout the Cold War, providing interception and air superiority against NATO forces along the Iron Curtain.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1954-01-01',
    '1956-06-14',
    '1962-06-01',
    2230.0,
    1210.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    NULL,
    5843.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur Tumansky R-25')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Radar RP-21')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'R-3S')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'R-13M')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'S-24'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 14.50, wingspan = 7.15, height = 4.10, wing_area = 23.0,
  empty_weight = 5350, mtow = 9100, service_ceiling = 17800, climb_rate = 225,
  combat_radius = 370, crew = 1,
  engine_name = 'Tumanski R-25-300', engine_count = 1,
  engine_type = 'Turboréacteur avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 40.2, thrust_wet = 69.6,
  nickname = 'Fishbed',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_MiG-21',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mikoyan-Gurevich_MiG-21'
WHERE name = 'MiG-21 Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 3000000, unit_cost_year = 1975,
  operators_count = 1,
  variants    = E'- **MiG-21F/PF** : NVA (armée de l''air est-allemande) — retirés 1990\n- **MiG-21bis** : dernière version en service avant la réunification',
  variants_en = E'- **MiG-21F/PF** : East German Air Force — retired 1990\n- **MiG-21bis** : final variant before German reunification'
WHERE name = 'MiG-21 Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nLivrés à la **NVA** (armée de l''air est-allemande) dans les années 1960-70 comme principal chasseur de supériorité aérienne. Versions MiG-21F, MiG-21PF, puis MiG-21bis dernière génération.\n\n## Carrière opérationnelle\nCouverture du ciel est-allemand durant la guerre froide, missions d''interception face aux intrusions OTAN. Après la **réunification allemande** (1990), intégration brève à la Luftwaffe pour évaluation, avant retrait définitif.\n\n## Héritage\nRetirés en 1990-1991 après analyse technique par l''OTAN — source d''informations précieuses sur les capacités MiG soviétiques. Quelques exemplaires préservés en musée.',
  description_en = E'## Genesis\nDelivered to the **NVA** (East German Air Force) in the 1960s-70s as the main air-superiority fighter. MiG-21F, MiG-21PF, then MiG-21bis final variants.\n\n## Operational career\nCovered East German airspace during the Cold War, flying interception against NATO intrusions. After **German reunification** (1990), briefly integrated into the Luftwaffe for evaluation before final retirement.\n\n## Legacy\nRetired 1990-1991 after technical analysis by NATO — a valuable source of intelligence on Soviet MiG capabilities. A few airframes preserved in museums.'
WHERE name = 'MiG-21 Allemand';

-- [auto:012] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=9lTkAK3bhOU'
WHERE name = 'MiG-21 Allemand';
