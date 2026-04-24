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
    'IAI Nesher',
    'IAI Nesher',
    'IAI Nesher (Israeli Air Force)',
    'IAI Nesher (Israeli Air Force)',
    'Réplique israélienne clandestine du Mirage 5 français, base du programme Kfir',
    'Clandestine Israeli copy of the French Mirage 5, basis for the Kfir programme',
    '/assets/airplanes/iai-nesher.jpg',
    'L''IAI Nesher ("Aigle" en hébreu) est la copie non-licenciée israélienne du Mirage 5 Dassault produite entre 1971 et 1974 (61 exemplaires) en réponse à l''embargo français décrété par De Gaulle en 1967. Les plans auraient été obtenus par l''espion israélien Alfred Frauenknecht chez Sulzer à Winterthur (affaire célèbre de 1969). Le Nesher a été engagé lors de la Guerre du Kippour en octobre 1973 où il a remporté de nombreuses victoires aériennes. Revendu au Chili sous le nom de Dagger et d''Argentine où il a combattu lors de la Guerre des Malouines en 1982 (nom Finger).',
    'The IAI Nesher ("Eagle" in Hebrew) is the unlicensed Israeli copy of the Dassault Mirage 5 produced between 1971 and 1974 (61 examples) in response to the French embargo decreed by de Gaulle in 1967. The plans were reportedly obtained by Israeli spy Alfred Frauenknecht at Sulzer in Winterthur (famous 1969 affair). The Nesher was deployed during the Yom Kippur War in October 1973, where it scored numerous air victories. Resold to Chile under the name Dagger and to Argentina where it fought during the 1982 Falklands War (Finger name).',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1969-01-01',
    '1971-09-01',
    '1972-05-01',
    2350.0,
    2500.0,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired',
    6600.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM armement WHERE name = 'Shafrir 2'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'IAI Nesher'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 15.65, wingspan = 8.22, height = 4.50, wing_area = 35.00,
  empty_weight = 6600, mtow = 13500, service_ceiling = 17000, climb_rate = 83,
  combat_radius = 1300, crew = 1, g_limit_pos = 7.0, g_limit_neg = -3.5,
  engine_name = 'SNECMA Atar 9C (licence IAI non autorisée)', engine_count = 1,
  engine_type = 'Turbojet avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 43.1, thrust_wet = 58.9,
  production_start = 1971, production_end = 1974, units_built = 61,
  operators_count = 3,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/IAI_Nesher',
  wikipedia_en = 'https://en.wikipedia.org/wiki/IAI_Nesher'
WHERE name = 'IAI Nesher';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 2200000, unit_cost_year = 1972,
  manufacturer_page = 'https://www.iai.co.il/',
  variants    = E'- **Nesher S** : monoplace (51 appareils)\n- **Nesher T** : biplace d''entraînement (10 appareils)\n- Exports après 1978 (sous désignation différente) :\n  - **IAI Dagger** : 35 appareils vendus à l''Argentine en 1978-1982\n  - **IAI Finger** : mise à niveau argentine par IAI 1981-1989\n  - 12 à la Force aérienne chilienne (FAC Chile)',
  variants_en = E'- **Nesher S** : single-seat (51 aircraft)\n- **Nesher T** : two-seat trainer (10 aircraft)\n- Post-1978 exports (under different designation):\n  - **IAI Dagger** : 35 aircraft sold to Argentina in 1978-1982\n  - **IAI Finger** : Argentine upgrade by IAI 1981-1989\n  - 12 to the Chilean Air Force (FAC Chile)'
WHERE name = 'IAI Nesher';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nAprès l''**embargo français de juin 1967** bloquant la livraison de 50 Mirage 5 déjà payés par Israël, IAI lance secrètement le programme **Raam-A** ("Tonnerre-A") en 1968 pour produire une **copie non-licenciée** du Mirage 5. Les plans du Mirage et de l''Atar 9C sont obtenus via l''**espion israélien Alfred Frauenknecht** chez Sulzer à Winterthur en 1969 — 200 000 pages photocopiées, plus grand vol industriel des années 1960. Premier vol du Nesher ("Aigle") en **septembre 1971**.\n\n## Carrière opérationnelle\n**61 exemplaires produits** en 3 ans. Engagé lors de la **Guerre du Kippour (octobre 1973)** où il obtient **115+ victoires aériennes confirmées** contre MiG-21/17/19 syriens et égyptiens. Rapidement remplacé dans l''IAF par le **Kfir** (version améliorée avec moteur J79). Exporté à l''Argentine en 1978 sous le nom **Dagger** (35 exemplaires) où il combat lors de la **Guerre des Malouines 1982** contre la Royal Navy.\n\n## Héritage\nPremier avion de combat **entièrement construit en Israël**. A prouvé la capacité de l''industrie IAI à produire en volume sans dépendance externe — fondement de l''autonomie israélienne qui aboutit au Kfir, au Lavi puis aux F-15I/F-16I/F-35I.',
  description_en = E'## Genesis\nAfter the **French embargo of June 1967** blocking delivery of 50 Mirage 5s already paid for by Israel, IAI secretly launches the **Raam-A** ("Thunder-A") programme in 1968 to produce an **unlicensed copy** of the Mirage 5. The Mirage and Atar 9C plans are obtained via the **Israeli spy Alfred Frauenknecht** at Sulzer in Winterthur in 1969 — 200,000 pages photocopied, the largest industrial theft of the 1960s. First flight of the Nesher ("Eagle") in **September 1971**.\n\n## Operational career\n**61 examples built** in 3 years. Deployed during the **Yom Kippur War (October 1973)** where it scores **115+ confirmed air victories** against Syrian and Egyptian MiG-21/17/19. Quickly replaced in the IAF by the **Kfir** (upgraded version with J79 engine). Exported to Argentina in 1978 under the **Dagger** name (35 units) where it fought during the **1982 Falklands War** against the Royal Navy.\n\n## Legacy\nFirst combat aircraft **entirely built in Israel**. Proved IAI''s capability to produce in volume without external dependence — foundation of Israeli autonomy leading to the Kfir, Lavi then F-15I/F-16I/F-35I.'
WHERE name = 'IAI Nesher';
