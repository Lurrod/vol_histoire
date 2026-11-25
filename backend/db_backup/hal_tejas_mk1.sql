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
    status_en
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
    'En service',
    'In service'
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
  description = E'## Genèse\nEn 1983, New Delhi décide de concevoir un **avion de combat léger** (LCA) entièrement national pour remplacer les MiG-21 de l''Indian Air Force. L''**Aeronautical Development Agency** (ADA) est créée en 1984, avec **HAL** comme maître d''œuvre industriel. Le démonstrateur TD-1 vole le 4 janvier 2001, et l''avion reçoit peu après le nom de **Tejas** (« éclat »).\n\n## Conception\nLe Tejas est un delta sans empennage horizontal, fait de composites à 45 % de sa masse et à 90 % de sa surface. Après les essais nucléaires de 1998, l''embargo américain prive le programme de l''aide de Lockheed Martin : la commande de vol électrique quadruplex est alors mise au point en Inde par les **National Aerospace Laboratories**, au prix d''environ dix-huit mois de retard. Le réacteur national **Kaveri** accumulant les déboires, le Mk1 vole avec un **General Electric F404-GE-IN20**. Le radar israélien **EL/M-2032** est associé aux missiles R-73, Python-5 et Derby.\n\n## Essais\nLa qualification opérationnelle initiale est accordée par étapes (2011, puis décembre 2013) ; la qualification finale, qui ajoute notamment le ravitaillement en vol, l''est le 20 février 2019.\n\n## Carrière opérationnelle\nDeux contrats de 20 avions, 16 monoplaces et 4 biplaces chacun, portent la série à 40. Le 45 Squadron « Flying Daggers » est déclaré opérationnel à Sulur en juillet 2016 ; le 18 Squadron « Flying Bullets » est reformé le 27 mai 2020 avec les premiers avions au standard final. En août 2020, le 45 Squadron part pour le front occidental, premier déploiement opérationnel du type. Du 27 février au 17 mars 2023, cinq Tejas participent à *Desert Flag* aux Émirats arabes unis, premier exercice international hors de l''Inde. Le premier accident survient le 12 mars 2024 près de Jaisalmer (pilote éjecté) ; le 21 novembre 2025, un Tejas s''écrase en démonstration au salon de Dubaï, tuant son pilote.\n\n## Place dans l''histoire\nTrente-deux ans séparent le lancement du programme de la mise en service. Le Tejas Mk1 ouvre la voie au **Mk1A**, commandé à 73 exemplaires en 2021 puis à 97 en 2025, dont les livraisons glissent faute de moteurs F404.',
  description_en = E'## Genesis\nIn 1983 New Delhi decided to design an all-Indian **Light Combat Aircraft** (LCA) to replace the Indian Air Force''s MiG-21s. The **Aeronautical Development Agency** (ADA) was set up in 1984, with **HAL** as prime industrial contractor. Technology demonstrator TD-1 first flew on 4 January 2001, and the aircraft was soon named **Tejas** ("radiance").\n\n## Design\nThe Tejas is a tailless delta, 45 per cent composite by weight and 90 per cent by surface area. After India''s 1998 nuclear tests, the US embargo cut off Lockheed Martin''s help, so the quadruplex fly-by-wire system was developed in India by the **National Aerospace Laboratories**, at the cost of some eighteen months. With the indigenous **Kaveri** engine mired in setbacks, the Mk1 flies on a **General Electric F404-GE-IN20**. The Israeli **EL/M-2032** radar is paired with R-73, Python-5 and Derby missiles.\n\n## Testing\nInitial operational clearance came in stages (2011, then December 2013); final operational clearance, adding air-to-air refuelling among other things, was granted on 20 February 2019.\n\n## Operational career\nTwo contracts for 20 aircraft each, 16 single-seaters and 4 trainers apiece, brought production to 40. No. 45 Squadron "Flying Daggers" became operational at Sulur in July 2016; No. 18 Squadron "Flying Bullets" was re-formed on 27 May 2020 with the first final-standard jets. In August 2020 No. 45 Squadron deployed to the western front, the type''s first operational deployment. From 27 February to 17 March 2023 five Tejas flew in *Desert Flag* in the United Arab Emirates, their first international exercise outside India. The first loss came on 12 March 2024 near Jaisalmer (the pilot ejected); on 21 November 2025 a Tejas crashed during a display at the Dubai Airshow, killing its pilot.\n\n## Place in history\nThirty-two years passed between the programme''s launch and service entry. The Tejas Mk1 paved the way for the **Mk1A**, ordered in batches of 73 in 2021 and 97 in 2025, whose deliveries keep slipping for want of F404 engines.'
WHERE name = 'HAL Tejas Mk1';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'HAL Tejas Mk1';
