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
    'AMX A-1 Brésilien',
    'AMX A-1 Brazilian',
    'Embraer A-1 (AMX International) — Força Aérea Brasileira',
    'Embraer A-1 (AMX International) — Brazilian Air Force',
    'Version brésilienne de l''AMX International pour la Força Aérea Brasileira',
    'Brazilian version of the AMX International for the Brazilian Air Force',
    '/assets/airplanes/amx-bresilien.jpg',
    'L''A-1 est la désignation brésilienne de l''AMX International, avion d''attaque tactique issu du programme tri-national Italie-Brésil-Embraer lancé en 1980. Embraer a produit 56 appareils pour la Força Aérea Brasileira entre 1990 et 1999, dont la modernisation A-1M (2013-2023) a introduit un radar Elta EL/M-2032, un cockpit tout écran, de nouvelles liaisons de données et la compatibilité bombes guidées GBU-12 et Mectron MAR-1. L''A-1 a été engagé dans des missions de surveillance aux frontières amazoniennes et lors d''exercices OTAN (CRUZEX). Retrait progressif prévu face à l''arrivée du Gripen E.',
    'The A-1 is the Brazilian designation of the AMX International, a tactical attack aircraft from the tri-national Italy-Brazil-Embraer programme launched in 1980. Embraer produced 56 aircraft for the Brazilian Air Force between 1990 and 1999, with the A-1M upgrade (2013-2023) introducing an Elta EL/M-2032 radar, a fully digital cockpit, new data links and compatibility with GBU-12 and Mectron MAR-1 guided bombs. The A-1 has been deployed in Amazon border surveillance missions and NATO exercises (CRUZEX). Gradual retirement planned with the arrival of the Gripen E.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1980-04-01',
    '1985-05-15',
    '1990-10-05',
    1053.0,
    3330.0,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'En service',
    'In service'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Spey')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM tech WHERE name = 'Radar EL/M-2032')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'MAR-1')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'Mk 83')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM armement WHERE name = 'Mk 84'));

-- Insertion des guerres

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 13.57, wingspan = 8.87, height = 4.58, wing_area = 21.00,
  empty_weight = 6700, mtow = 13000, service_ceiling = 13000, climb_rate = 51,
  combat_radius = 520, crew = 1, g_limit_pos = 8.0, g_limit_neg = -3.0,
  engine_name = 'Rolls-Royce Spey Mk 807 (licence Fiat)', engine_count = 1,
  engine_type = 'Turbofan', engine_type_en = 'Turbofan',
  thrust_dry = 49.1, thrust_wet = NULL,
  production_start = 1989, production_end = 1999, units_built = 56,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/AMX_International_AMX',
  wikipedia_en = 'https://en.wikipedia.org/wiki/AMX_International_AMX'
WHERE name = 'AMX A-1 Brésilien';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 22000000, unit_cost_year = 1995,
  manufacturer_page = 'https://www.embraer.com/',
  variants    = E'- **A-1A** : monoplace d''attaque FAB (40 appareils)\n- **A-1B** : biplace d''entraînement (16 appareils)\n- **A-1M (AMX/M-AMX)** : modernisation 2013-2023 par Embraer avec radar Elta EL/M-2032, cockpit tout écran, MAR-1, GBU-12\n- **A-1R/TA-1R** : version reconnaissance avec pod Condor\n- Part brésilienne : 29,7 % du programme AMX International (aile + pylônes + pré-production)',
  variants_en = E'- **A-1A** : single-seat FAB attacker (40 aircraft)\n- **A-1B** : two-seat trainer (16 aircraft)\n- **A-1M (AMX/M-AMX)** : 2013-2023 Embraer upgrade with Elta EL/M-2032 radar, full-screen cockpit, MAR-1, GBU-12\n- **A-1R/TA-1R** : reconnaissance version with Condor pod\n- Brazilian share: 29.7 % of the AMX International programme (wing + pylons + pre-production)'
WHERE name = 'AMX A-1 Brésilien';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nQuand l''Italie et le Brésil s''associent pour un avion d''attaque léger, le Brésil annonce sa participation en 1980 et **Embraer** rejoint **Aeritalia** et **Aermacchi** dans le programme **AMX**. L''avionneur de São José dos Campos assure 29,7 % du travail de chaque avion de série. Le premier prototype vole en Italie le 15 mai 1984 ; le premier exemplaire assemblé au Brésil prend l''air en 1985. La Força Aérea Brasileira (FAB) le désigne **A-1**.\n\n## Conception\nMonoréacteur subsonique propulsé par un **Rolls-Royce Spey** construit sous licence, l''A-1 est taillé pour l''attaque à basse altitude et à long rayon d''action. Les appareils brésiliens peuvent être ravitaillés en vol et emporter une palette de capteurs qui en fait aussi des avions de reconnaissance. Le Brésil espérait 79 avions ; il en reçoit 56, monoplaces A-1A et biplaces A-1B, livrés jusqu''en 1999.\n\n## Carrière opérationnelle\nLe premier A-1 est livré à la base de Santa Cruz, près de Rio, en octobre 1989, au **1º/16º GAv « Adelphi »** ; deux escadrons de Santa Maria, « Poker » et « Centauro », suivent. En 1998, des A-1 de l''Adelphi participent à l''exercice *Red Flag* aux États-Unis. La modernisation **A-1M**, confiée à Embraer par un contrat du 29 décembre 2003, devait toucher 53 avions : réduite à 43 en 2008 puis à 14 en 2016 faute de crédits, elle ne livre que 11 appareils entre 2013 et 2021, dotés d''un cockpit numérique, d''un viseur de casque et de bombes guidées laser. Faute de pièces et de budget, la flotte fond : en 2022, au moins 21 avions avaient été perdus ou retirés, dont cinq dans des accidents. Les A-1M figurent encore parmi les avions de l''exercice multinational **CRUZEX** de Natal en novembre 2024.\n\n## Place dans l''histoire\nL''Adelphi est dissous fin 2016 dans l''attente du **Gripen**. Seul utilisateur de l''AMX depuis le retrait italien, la FAB n''en garde plus qu''une unité, le « Poker » de Santa Maria ; son retrait, annoncé un temps pour 2025, est désormais attendu fin 2027, voire 2028, avant l''arrivée des F-39 Gripen à partir de 2029. L''A-1 aura fait d''Embraer un coconcepteur d''avion de combat.',
  description_en = E'## Genesis\nWhen Italy and Brazil joined forces on a light attack aircraft, Brazil announced its participation in 1980 and **Embraer** joined **Aeritalia** and **Aermacchi** in the **AMX** programme. The São José dos Campos manufacturer performed 29.7 per cent of the work on each production aircraft. The first prototype flew in Italy on 15 May 1984; the first Brazilian-assembled example took to the air in 1985. The Força Aérea Brasileira (FAB) designated it **A-1**.\n\n## Design\nA subsonic single-engine jet powered by a licence-built **Rolls-Royce Spey**, the A-1 was built for long-range, low-level attack. Brazilian aircraft can be refuelled in flight and carry a sensor pallet that also makes them reconnaissance platforms. Brazil had hoped for 79 aircraft; it received 56, single-seat A-1As and two-seat A-1Bs, delivered until 1999.\n\n## Operational career\nThe first A-1 was delivered to Santa Cruz air base, near Rio, in October 1989, to **1º/16º GAv "Adelphi"**; two squadrons at Santa Maria, "Poker" and "Centauro", followed. In 1998 Adelphi A-1s took part in *Red Flag* in the United States. The **A-1M** upgrade, awarded to Embraer on 29 December 2003, was meant to cover 53 aircraft: cut to 43 in 2008 and to 14 in 2016 for lack of funds, it delivered only 11 aircraft between 2013 and 2021, with a digital cockpit, a helmet-mounted display and laser-guided bombs. Short of spares and money, the fleet shrank: by 2022 at least 21 aircraft had been lost or withdrawn, five of them in accidents. A-1Ms were still among the aircraft of the multinational **CRUZEX** exercise at Natal in November 2024.\n\n## Place in history\nAdelphi was disbanded at the end of 2016 to await the **Gripen**. The AMX''s only user since Italy retired the type, the FAB now keeps a single unit, "Poker" at Santa Maria; its retirement, once announced for 2025, is now expected at the end of 2027, possibly 2028, ahead of F-39 Gripens arriving from 2029. The A-1 turned Embraer into a co-designer of combat aircraft.'
WHERE name = 'AMX A-1 Brésilien';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AMX A-1 Brésilien';
