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
    'Rafale EH',
    'Rafale EH',
    'Dassault Rafale EH/DH (Indian Air Force)',
    'Dassault Rafale EH/DH (Indian Air Force)',
    'Version indienne du Rafale, chasseur omnirôle français de 4e génération++',
    'Indian variant of the Rafale, French 4th-generation++ omnirole fighter',
    '/assets/airplanes/rafale-eh.jpg',
    'Le Rafale EH (monoplace) et DH (biplace) est la version indienne du Dassault Rafale commandée en 2016 (contrat inter-gouvernemental signé avec la France pour 36 appareils et 7,87 milliards d''euros). Livraison achevée fin 2022, basés aux bases d''Ambala et Hashimara face à la Chine. Spécificités India-Specific Enhancements (ISE) : pylônes nucléaires, intégration missile SCALP, Meteor, AASM Hammer, MICA IR/EM, liaisons de données cold-start à haute altitude, cryptographie indienne. Engagé lors des tensions Inde-Chine du Ladakh en 2020. 26 Rafale Marine supplémentaires commandés en 2024.',
    'The Rafale EH (single-seat) and DH (two-seat) are the Indian variants of the Dassault Rafale ordered in 2016 (inter-governmental contract signed with France for 36 aircraft and €7.87 billion). Delivery completed end 2022, based at Ambala and Hashimara facing China. India-Specific Enhancements (ISE): nuclear pylons, SCALP missile integration, Meteor, AASM Hammer, MICA IR/EM, high-altitude cold-start data links, Indian cryptography. Engaged during the 2020 India-China Ladakh tensions. 26 additional Rafale Marine ordered in 2024.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '2012-01-01',
    '2020-07-23',
    '2020-09-10',
    1912.0,
    3700.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    10300.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM tech WHERE name = 'Radar RBE2 AESA')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM tech WHERE name = 'Système SPECTRA')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM armement WHERE name = 'GIAT 30M791')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM armement WHERE name = 'MICA IR')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM armement WHERE name = 'MICA EM')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM armement WHERE name = 'SCALP EG')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM armement WHERE name = 'AASM Hammer')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM armement WHERE name = 'AM39 Exocet')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM armement WHERE name = 'ASMP-A'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Rafale EH'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 15.30, wingspan = 10.90, height = 5.30, wing_area = 45.70,
  empty_weight = 10300, mtow = 24500, service_ceiling = 15235, climb_rate = 305,
  combat_radius = 1850, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.6,
  engine_name = 'SNECMA M88-2', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 50.04, thrust_wet = 75.02,
  production_start = 2016, production_end = 2022, units_built = 36,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Dassault_Rafale',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Dassault_Rafale'
WHERE name = 'Rafale EH';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 242000000, unit_cost_year = 2016,
  manufacturer_page = 'https://www.dassault-aviation.com/fr/defense/rafale/',
  variants    = E'- **Rafale EH** : monoplace India-Specific Enhancement (28 appareils)\n- **Rafale DH** : biplace d''entraînement/frappe (8 appareils)\n- India-Specific Enhancements (ISE) : pylônes nucléaires, SCALP, Meteor, MICA IR/EM, cryptographie indienne, liaisons haute altitude (Ladakh)\n- 26 **Rafale Marine** commandés en 2024 pour porte-avions INS Vikrant\n- 2 escadrons : No. 17 "Golden Arrows" (Ambala) et No. 101 "Falcons" (Hashimara)',
  variants_en = E'- **Rafale EH** : single-seat India-Specific Enhancement (28 aircraft)\n- **Rafale DH** : two-seat trainer/strike (8 aircraft)\n- India-Specific Enhancements (ISE): nuclear pylons, SCALP, Meteor, MICA IR/EM, Indian cryptography, high-altitude data links (Ladakh)\n- 26 **Rafale Marine** ordered in 2024 for INS Vikrant carrier\n- 2 squadrons: No. 17 "Golden Arrows" (Ambala) and No. 101 "Falcons" (Hashimara)'
WHERE name = 'Rafale EH';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nContrat **inter-gouvernemental** signé le **23 septembre 2016** entre Jean-Yves Le Drian et Manohar Parrikar : 36 Rafale pour **7,87 milliards d''euros** (coût flyaway ~120 M€, support/armement ~120 M€ chacun). Résultat du long programme MMRCA (2007-2015) où le Rafale avait gagné contre Typhoon mais où Paris avait renoncé au cadre export commercial au profit du G2G.\n\n## Carrière opérationnelle\n**36 appareils livrés** entre juillet 2020 et décembre 2022 — livraison la plus rapide de l''histoire Dassault pour un client export (un avion par mois en moyenne). Escadron 17 "Golden Arrows" à **Ambala** (face au Pakistan) et escadron 101 "Falcons" à **Hashimara** (face à la Chine). Engagé lors des tensions Ladakh (2020) — **premier vol opérationnel d''un Rafale de combat moderne contre la Chine**.\n\n## Héritage\nPremier chasseur de **4++ génération** de l''IAF, ouvre l''accès Meteor BVR (portée ~200 km no-escape zone) et SCALP cruise missile à l''arsenal indien. Commande supplémentaire de **26 Rafale Marine** en juillet 2024 pour porte-avions INS Vikrant (Tejas Navy Mk1 insuffisant). Exercices internationaux : Red Flag Alaska 2024, Garuda avec l''Armée de l''Air française.',
  description_en = E'## Genesis\n**Inter-governmental contract** signed on **23 September 2016** between Jean-Yves Le Drian and Manohar Parrikar: 36 Rafale for **€7.87 billion** (flyaway cost ~€120M, support/weapons ~€120M each). Result of the long MMRCA programme (2007-2015) where the Rafale had won against Typhoon but where Paris eventually gave up the commercial export framework in favour of G2G.\n\n## Operational career\n**36 aircraft delivered** between July 2020 and December 2022 — the fastest delivery in Dassault history for an export customer (one aircraft per month on average). 17th "Golden Arrows" squadron at **Ambala** (facing Pakistan) and 101st "Falcons" squadron at **Hashimara** (facing China). Deployed during the Ladakh tensions (2020) — **first operational flight of a modern Rafale combat aircraft against China**.\n\n## Legacy\nFirst **4++ generation** fighter of the IAF, opens Meteor BVR access (range ~200 km no-escape zone) and SCALP cruise missile to the Indian arsenal. Additional order of **26 Rafale Marine** in July 2024 for INS Vikrant carrier (Tejas Navy Mk1 insufficient). International exercises: Red Flag Alaska 2024, Garuda with the French Air Force.'
WHERE name = 'Rafale EH';
