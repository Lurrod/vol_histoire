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
    'F-35B Lightning II Anglais',
    'British F-35B Lightning II',
    'Lockheed Martin F-35B Lightning II (Royal Air Force / Royal Navy)',
    'Lockheed Martin F-35B Lightning II (Royal Air Force / Royal Navy)',
    'Avion furtif STOVL de 5e génération au service du Royaume-Uni',
    '5th-generation STOVL stealth aircraft in UK service',
    '/assets/airplanes/f35b-lightning-2-anglais.jpg',
    'Le F-35B Lightning II britannique est la variante à décollage court et atterrissage vertical (STOVL) du programme Joint Strike Fighter, exploitée conjointement par la Royal Air Force et la Royal Navy. Classé dans la 5e génération, il combine furtivité, fusion de capteurs avancée et capacités STOVL grâce à son réacteur Pratt & Whitney F135 et sa soufflante de sustentation Rolls-Royce LiftFan. Opérant depuis les porte-avions de classe Queen Elizabeth et les bases terrestres, il remplace le Harrier dans le rôle d''avion de combat embarqué britannique. Le Royaume-Uni est un partenaire industriel majeur du programme, avec environ 15% de la production confiée à des entreprises britanniques. Capable de missions air-air, air-sol et de reconnaissance, le F-35B constitue la pièce maîtresse de la puissance aérienne expéditionnaire britannique pour les décennies à venir.',
    'The British F-35B Lightning II is the short take-off and vertical landing (STOVL) variant of the Joint Strike Fighter program, jointly operated by the Royal Air Force and the Royal Navy. Classified as 5th generation, it combines stealth, advanced sensor fusion and STOVL capabilities thanks to its Pratt & Whitney F135 engine and Rolls-Royce LiftFan lift fan. Operating from Queen Elizabeth-class aircraft carriers and land bases, it replaces the Harrier in the British carrier-based combat aircraft role. The United Kingdom is a major industrial partner in the program, with approximately 15% of the work share.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1996-01-01',
    '2008-06-11',
    '2018-01-10',
    1975.0,
    1670.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-81')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'ASRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'Paveway IV')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM armement WHERE name = 'Storm Shadow'));

-- Insertion des guerres
-- Pas de participation à des conflits majeurs répertoriés à ce jour pour la version britannique

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 15.6, wingspan = 10.7, height = 4.36, wing_area = 42.7,
  empty_weight = 14700, mtow = 27200, service_ceiling = 15240,
  combat_radius = 833, crew = 1, g_limit_pos = 7.0,
  engine_name = 'Pratt & Whitney F135-PW-600 (avec LiftFan)', engine_count = 1,
  engine_type = 'Turbofan STOVL avec postcombustion', engine_type_en = 'STOVL afterburning turbofan',
  thrust_dry = 128.1, thrust_wet = 191.3,
  production_start = 2006, production_end = NULL,
  stealth_level = 'elevee',
  nickname = 'Lightning II',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Lockheed_Martin_F-35_Lightning_II',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Lockheed_Martin_F-35_Lightning_II'
WHERE name = 'F-35B Lightning II Anglais';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 109000000, unit_cost_year = 2023,
  operators_count = 4,
  manufacturer_page = 'https://www.lockheedmartin.com/en-us/products/f-35.html'
WHERE name = 'F-35B Lightning II Anglais';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nSeul partenaire de « niveau 1 » du **Joint Strike Fighter**, le Royaume-Uni apporte 2,5 milliards de dollars, environ 10 % du développement. Il choisit la version à décollage court et appontage vertical pour succéder aux **Harrier** et armer les deux porte-avions de la classe **Queen Elizabeth**, commandés en 2007. La revue de défense d''octobre 2010 bascule vers le F-35C à catapulte ; en mai 2012, Londres revient au F-35B, moins coûteux et disponible plus tôt.\n\n## Conception\nLe F-35B associe une cellule furtive et la fusion de capteurs du programme à une propulsion unique : le réacteur **F135** entraîne une soufflante de sustentation **LiftFan** de **Rolls-Royce** placée derrière le cockpit, tandis que la tuyère arrière pivote vers le bas. Une première tranche de 48 appareils est commandée ; en 2025, la seconde est ramenée à 15 F-35B auxquels s''ajoutent 12 F-35A destinés à l''entraînement et à la dissuasion nucléaire aéroportée.\n\n## Carrière opérationnelle\nLe **617e escadron**, les « Dambusters », renaît en avril 2018 à Marham et déclare sa capacité opérationnelle initiale à terre en janvier 2019. Le 16 juin 2019, en pleine **guerre civile syrienne**, deux de ses F-35B partis d''Akrotiri patrouillent au-dessus de la Syrie : c''est la première mission opérationnelle du type au Royaume-Uni, suivie de douze autres sorties aux côtés des Typhoon. En 2021, huit appareils du 617 et dix F-35B des Marines embarquent sur le HMS *Queen Elizabeth* ; en juin, depuis la Méditerranée orientale, ils reprennent la lutte contre l''État islamique, les premiers avions d''un porte-avions britannique au combat depuis les Balkans. Le 17 novembre suivant, un F-35B tombe en mer au décollage, une protection d''entrée d''air oubliée ; le pilote s''éjecte. En 2025, l''opération *Highmast* conduit le HMS *Prince of Wales* jusqu''à l''Indo-Pacifique ; en novembre, avec vingt-quatre F-35B à bord, le groupe aéronaval atteint sa pleine capacité opérationnelle.\n\n## Place dans l''histoire\nLe F-35B rend au Royaume-Uni l''aviation embarquée à voilure fixe perdue en décembre 2010, quand la revue de défense retire les Harrier.',
  description_en = E'## Genesis\nThe only "Level 1" partner in the **Joint Strike Fighter**, the United Kingdom contributed $2.5 billion, about 10% of development costs. It chose the short take-off and vertical landing variant to succeed the **Harrier** and equip the two **Queen Elizabeth**-class carriers ordered in 2007. The October 2010 defence review switched to the catapult-launched F-35C; in May 2012 London returned to the F-35B, cheaper and available sooner.\n\n## Design\nThe F-35B combines the programme''s stealthy airframe and sensor fusion with a unique propulsion system: the **F135** engine drives a **Rolls-Royce** **LiftFan** behind the cockpit while the rear nozzle swivels downward. A first tranche of 48 aircraft was ordered; in 2025 the second was reduced to 15 F-35Bs, joined by 12 F-35As for training and the airborne nuclear deterrent.\n\n## Operational career\nNo. **617 Squadron**, the "Dambusters", re-formed at Marham in April 2018 and declared initial operating capability on land in January 2019. On 16 June 2019, during the **Syrian Civil War**, two of its F-35Bs from Akrotiri flew a patrol over Syria, the type''s first British operational mission, followed by twelve more sorties alongside Typhoons. In 2021 eight 617 Squadron jets and ten US Marine Corps F-35Bs embarked on HMS *Queen Elizabeth*; in June, from the eastern Mediterranean, they flew against the Islamic State again, the first British carrier aircraft in combat since the Balkans. On 17 November that year an F-35B went into the sea on take-off because an engine intake cover had been left in place; the pilot ejected. In 2025 Operation *Highmast* took HMS *Prince of Wales* to the Indo-Pacific, and in November, with twenty-four F-35Bs aboard, the carrier strike group reached full operating capability.\n\n## Place in history\nThe F-35B gave the United Kingdom back the fixed-wing carrier aviation it lost in December 2010, when the defence review retired the Harrier.'
WHERE name = 'F-35B Lightning II Anglais';
