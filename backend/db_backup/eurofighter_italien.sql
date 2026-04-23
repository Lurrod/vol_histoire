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
    'Eurofighter Typhoon Italien',
    'Italian Eurofighter Typhoon',
    'Eurofighter Typhoon (Aeronautica Militare)',
    'Eurofighter Typhoon (Italian Air Force)',
    'Chasseur multirôle européen de 4e génération au service de l''Aeronautica Militare',
    'European 4th-generation multirole fighter in Italian Air Force service',
    '/assets/airplanes/eurofighter-italien.jpg',
    'L''Eurofighter Typhoon italien est la version exploitée par l''Aeronautica Militare, assemblée par Leonardo sur le site de Turin-Caselle. L''Italie, partenaire fondateur du programme aux côtés du Royaume-Uni, de l''Allemagne et de l''Espagne avec 21 % des parts industrielles, a commandé 96 appareils répartis sur trois tranches. Leonardo produit notamment l''aile gauche, la section arrière du fuselage et intègre 15 % de la cellule totale. Conçu autour d''une configuration canard-delta instable et d''une commande de vol entièrement électrique, le Typhoon offre des performances exceptionnelles en combat aérien rapproché. L''Aeronautica Militare a déployé ses Typhoon au sein des 4°, 36° et 37° Stormo (Grosseto, Gioia del Colle, Trapani) et a fait évoluer ses appareils vers une capacité multirôle complète depuis la Tranche 3, intégrant le radar CAPTOR-E AESA, le missile Meteor à longue portée et des armements air-sol comme le GBU-16 et le Storm Shadow. L''Italie assure la police du ciel au-dessus de la péninsule, des Balkans (Albanie, Slovénie, Monténégro) et participe régulièrement aux missions de police aérienne renforcée de l''OTAN (Baltic Air Policing, Islande). Le Typhoon italien est également engagé contre Daesh en Irak (opération Prima Parthica) et effectue ses premières frappes air-sol Paveway en 2017.',
    'The Italian Eurofighter Typhoon is the version operated by the Aeronautica Militare, assembled by Leonardo at the Turin-Caselle facility. Italy, a founding partner of the programme alongside the United Kingdom, Germany and Spain with 21% of industrial shares, ordered 96 aircraft spread across three tranches. Leonardo produces the left wing, rear fuselage section and integrates 15% of the total airframe. Designed around an unstable canard-delta configuration and a fully electric flight control system, the Typhoon offers exceptional close air combat performance. The Aeronautica Militare has deployed its Typhoons within the 4°, 36° and 37° Stormo (Grosseto, Gioia del Colle, Trapani) and has evolved its aircraft towards full multirole capability since Tranche 3, integrating the CAPTOR-E AESA radar, the long-range Meteor missile and air-to-ground armaments such as the GBU-16 and Storm Shadow. Italy provides air policing over the peninsula, the Balkans (Albania, Slovenia, Montenegro) and regularly contributes to NATO enhanced air policing missions (Baltic Air Policing, Iceland). The Italian Typhoon is also engaged against Daesh in Iraq (Operation Prima Parthica) and performed its first Paveway air-to-ground strikes in 2017.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1983-01-01',
    '1994-03-27',
    '2004-12-16',
    2495.0,
    2900.0,
    (SELECT id FROM manufacturer WHERE code = 'LEO'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    11000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM tech WHERE name = 'Radar CAPTOR')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM armement WHERE name = 'IRIS-T')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM armement WHERE name = 'GBU-16 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM armement WHERE name = 'GBU-49')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM armement WHERE name = 'Storm Shadow'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 15.96, wingspan = 10.95, height = 5.28, wing_area = 50.0,
  empty_weight = 11000, mtow = 23500, service_ceiling = 19810, climb_rate = 315,
  combat_radius = 1389, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'Eurojet EJ200', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 60.0, thrust_wet = 90.0,
  production_start = 2000, production_end = NULL, units_built = 96,
  operators_count = 1,
  rival_id = (SELECT id FROM airplanes WHERE name = 'Rafale' LIMIT 1),
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Eurofighter_Typhoon',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Eurofighter_Typhoon'
WHERE name = 'Eurofighter Typhoon Italien';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 100000000, unit_cost_year = 2013,
  manufacturer_page = 'https://www.eurofighter.com/',
  variants    = E'- **Tranche 1** : configuration initiale, supériorité aérienne, 28 exemplaires\n- **Tranche 2** : capacité air-sol Paveway, intégration Litening III\n- **Tranche 3/3A** : radar CAPTOR-E AESA, Meteor, Storm Shadow, 21 exemplaires',
  variants_en = E'- **Tranche 1** : initial configuration, air superiority, 28 airframes\n- **Tranche 2** : Paveway air-to-ground capability, Litening III integration\n- **Tranche 3/3A** : CAPTOR-E AESA radar, Meteor, Storm Shadow, 21 airframes'
WHERE name = 'Eurofighter Typhoon Italien';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nIssu du programme européen **EFA** (European Fighter Aircraft) lancé en 1983, réunissant Royaume-Uni, Allemagne, Italie et Espagne après le retrait de la France. Leonardo (ex-Alenia Aermacchi) assure **21 %** de la cellule, l''aile gauche et la section arrière du fuselage, assemble les cellules italiennes à Turin-Caselle. Premier Typhoon italien livré en **décembre 2004** au 4° Stormo de Grosseto.\n\n## Carrière opérationnelle\n96 commandés, livraisons jusqu''à 2023. Déployé sur **Baltic Air Policing** (2015, 2018, 2022), **Islande**, **Bulgarie**. Premières frappes air-sol contre Daesh en Irak en 2017 (opération Prima Parthica). L''Italie exploite 3 Stormo Typhoon (4°, 36°, 37°) et assure **QRA** permanente depuis Grosseto, Gioia del Colle et Trapani.\n\n## Héritage\n**Épine dorsale de la chasse italienne** pour les 20 prochaines années au moins. Remplace progressivement les F-104S puis AMX. Complète le F-35A sur les missions de supériorité aérienne. Prépare l''entrée dans le programme **GCAP** (Global Combat Air Programme) 6e génération avec le Royaume-Uni et le Japon à horizon 2035.',
  description_en = E'## Genesis\nBorn from the European **EFA** (European Fighter Aircraft) programme launched in 1983, joining the UK, Germany, Italy and Spain after France''s withdrawal. Leonardo (formerly Alenia Aermacchi) handles **21%** of the airframe, the left wing and the rear fuselage section, and final-assembles Italian airframes in Turin-Caselle. First Italian Typhoon delivered in **December 2004** to the 4° Stormo in Grosseto.\n\n## Operational career\n96 ordered, deliveries through 2023. Deployed on **Baltic Air Policing** (2015, 2018, 2022), **Iceland**, **Bulgaria**. First air-to-ground strikes against Daesh in Iraq in 2017 (Operation Prima Parthica). Italy operates 3 Typhoon Stormo (4°, 36°, 37°) and provides permanent **QRA** from Grosseto, Gioia del Colle and Trapani.\n\n## Legacy\n**Backbone of Italian fighter aviation** for at least the next 20 years. Progressively replaces F-104S then AMX. Complements the F-35A on air superiority missions. Paves the way into the **GCAP** (Global Combat Air Programme) 6th-generation programme with the UK and Japan by 2035.'
WHERE name = 'Eurofighter Typhoon Italien';

-- [auto:011] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=4F-7EbzuUNY'
WHERE name = 'Eurofighter Typhoon Italien';
