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
    'HAL Tejas Mk1',
    'HAL Tejas Mk1',
    'HAL Tejas Mk1 LCA (Indian Air Force)',
    'HAL Tejas Mk1 LCA (Indian Air Force)',
    'Chasseur léger multirôle indien à aile delta, de 4e génération',
    '4th-generation Indian lightweight multirole delta-wing fighter',
    '/assets/airplanes/hal-tejas-mk1.jpg',
    'Le HAL Tejas ("Splendeur") est un avion de combat léger (Light Combat Aircraft — LCA) conçu par l''Aeronautical Development Agency (ADA) et produit par HAL pour remplacer les MiG-21 dans l''Indian Air Force. Premier avion de combat entièrement indien de 4e génération, il adopte une aile delta cropped sans empennage horizontal, une commande de vol électrique numérique quadruple redondance et une structure composite à 45 %. Propulsé par un General Electric F404-GE-IN20, il est mis en service en 2015 dans le cadre de l''Initial Operational Clearance. 40 Mk1 livrés.',
    'The HAL Tejas ("Radiance") is a Light Combat Aircraft (LCA) designed by the Aeronautical Development Agency (ADA) and produced by HAL to replace the MiG-21 in the Indian Air Force. The first entirely Indian 4th-generation combat aircraft, it adopts a cropped delta wing without horizontal tail, a digital quadruplex fly-by-wire flight control and a 45 % composite structure. Powered by a General Electric F404-GE-IN20, it entered service in 2015 as part of the Initial Operational Clearance. 40 Mk1 delivered.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '1983-01-01',
    '2001-01-04',
    '2015-07-01',
    1975.0,
    3000.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    6560.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric F404')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM tech WHERE name = 'Radar EL/M-2032')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM armement WHERE name = 'Derby')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM armement WHERE name = 'Python 5')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 13.20, wingspan = 8.20, height = 4.40, wing_area = 38.40,
  empty_weight = 6560, mtow = 13500, service_ceiling = 15240, climb_rate = 53,
  combat_radius = 500, crew = 1, g_limit_pos = 8.0, g_limit_neg = -3.5,
  engine_name = 'General Electric F404-GE-IN20', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 53.9, thrust_wet = 84.0,
  production_start = 2015, production_end = NULL, units_built = 40,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_Tejas',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_Tejas'
WHERE name = 'HAL Tejas Mk1';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 30000000, unit_cost_year = 2016,
  manufacturer_page = 'https://hal-india.co.in/tejas',
  variants    = E'- **Tejas Mk1 IOC** : Initial Operational Clearance (2015), 20 appareils\n- **Tejas Mk1 FOC** : Final Operational Clearance (2019), perche ravitaillement, AIM-132 ASRAAM\n- **Tejas Trainer** : biplace d''entraînement\n- **Tejas Navy** : prototype embarqué (programme N-LCA)',
  variants_en = E'- **Tejas Mk1 IOC** : Initial Operational Clearance (2015), 20 aircraft\n- **Tejas Mk1 FOC** : Final Operational Clearance (2019), refueling probe, AIM-132 ASRAAM\n- **Tejas Trainer** : two-seat trainer\n- **Tejas Navy** : carrier prototype (N-LCA programme)'
WHERE name = 'HAL Tejas Mk1';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme **LCA (Light Combat Aircraft)** lancé en **1983** par l''Aeronautical Development Agency (ADA) et HAL pour remplacer les MiG-21 de l''Indian Air Force. Développement long (sanctions américaines post-essais nucléaires 1998, embargo moteur Kaveri indigène finalement abandonné au profit du GE F404). Premier vol du TD-1 le **4 janvier 2001**. Livraison de série en **juillet 2015**.\n\n## Carrière opérationnelle\n**40 appareils Mk1** livrés aux 45 Sqn ("Flying Daggers") et 18 Sqn ("Flying Bullets") de l''IAF. Cellule ultra-légère (45 % composites), commande de vol électrique quadruple redondance conçue en Inde après l''interruption de l''assistance américaine Lockheed. Premier avion indien avec radar multimode numérique (EL/M-2032).\n\n## Héritage\nPremier avion de combat indien de 4e génération — l''aboutissement de 32 ans de développement national. A posé les bases du Tejas Mk1A, Mk2 (MWF) puis du programme AMCA de 5e génération.',
  description_en = E'## Genesis\n**LCA (Light Combat Aircraft)** programme launched in **1983** by the Aeronautical Development Agency (ADA) and HAL to replace the Indian Air Force''s MiG-21s. Long development (US sanctions after 1998 nuclear tests, indigenous Kaveri engine embargo eventually abandoned in favour of the GE F404). First flight of TD-1 on **4 January 2001**. Serial delivery in **July 2015**.\n\n## Operational career\n**40 Mk1 aircraft** delivered to 45 Sqn ("Flying Daggers") and 18 Sqn ("Flying Bullets") of the IAF. Ultra-light airframe (45 % composites), quadruplex fly-by-wire designed in India after the interruption of US Lockheed assistance. First Indian aircraft with a digital multi-mode radar (EL/M-2032).\n\n## Legacy\nFirst Indian 4th-generation combat aircraft — the culmination of 32 years of national development. Laid the foundations for the Tejas Mk1A, Mk2 (MWF) then the 5th-generation AMCA programme.'
WHERE name = 'HAL Tejas Mk1';
