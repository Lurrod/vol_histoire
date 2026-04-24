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
    'F-35I Adir',
    'F-35I Adir',
    'Lockheed Martin F-35I Adir (Israeli Air Force)',
    'Lockheed Martin F-35I Adir (Israeli Air Force)',
    'Version israélienne du F-35A Lightning II avec avionique et armement nationaux',
    'Israeli version of the F-35A Lightning II with domestic avionics and weapons',
    '/assets/airplanes/f35i-adir.jpg',
    'Le F-35I Adir ("Le Puissant" en hébreu) est la version israélienne du F-35A Lightning II. Seul partenaire autorisé par Lockheed Martin à intégrer des systèmes nationaux sur le F-35 : Command-Control-Communication-Computers-Intelligence (C4I) israélien autonome, suite EW complémentaire, armements Rafael (Spice, Rampage) et Elbit (guidance kits). Premier avion opérationnel en 2017 à la base de Nevatim. Premier engagement au combat mondial d''un F-35 (confirmé par le chef d''état-major Amikam Norkin en mai 2018) sur une cible non précisée au Moyen-Orient. 50 F-35I commandés, 25 supplémentaires commandés en 2023 pour un total de 75 prévus d''ici 2028.',
    'The F-35I Adir ("The Mighty One" in Hebrew) is the Israeli version of the F-35A Lightning II. The only partner authorised by Lockheed Martin to integrate national systems on the F-35: autonomous Israeli Command-Control-Communication-Computers-Intelligence (C4I), complementary EW suite, Rafael (Spice, Rampage) and Elbit (guidance kits) weapons. First operational aircraft in 2017 at Nevatim base. World''s first combat engagement of an F-35 (confirmed by Chief of Staff Amikam Norkin in May 2018) against an unspecified Middle East target. 50 F-35I ordered, 25 more ordered in 2023 for a total of 75 planned by 2028.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '2010-01-01',
    '2016-07-25',
    '2017-12-06',
    1930.0,
    2220.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    13290.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-81')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM armement WHERE name = 'GAU-12 Equalizer')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM armement WHERE name = 'Python 5')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM armement WHERE name = 'Spice')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM armement WHERE name = 'Rampage'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'F-35I Adir'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 15.70, wingspan = 10.70, height = 4.38, wing_area = 42.74,
  empty_weight = 13290, mtow = 31800, service_ceiling = 15240, climb_rate = 248,
  combat_radius = 1093, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'Pratt & Whitney F135-PW-100', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 125.0, thrust_wet = 191.3,
  production_start = 2016, production_end = NULL, units_built = 39,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Lockheed_Martin_F-35_Lightning_II',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Lockheed_Martin_F-35_Lightning_II#Israel'
WHERE name = 'F-35I Adir';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 110000000, unit_cost_year = 2020,
  manufacturer_page = 'https://www.lockheedmartin.com/en-us/products/f-35.html',
  variants    = E'- **F-35I Adir** : unique version israélienne — seul partenaire autorisé à intégrer des systèmes nationaux sur le F-35\n- Différences ISE : C4I autonome israélien, suite EW complémentaire, armements Rafael (Spice, Rampage) et Elbit, architecture cybersécurité indépendante\n- Commandes : 50 appareils + 25 (2023) + 25 (2024) = **100 F-35I prévus d''ici 2030**\n- Escadrons : 140 "Golden Eagle" (Nevatim, 1er escadron opérationnel 2017), 116 "Lions of the South" (Nevatim), 117 "First Jet" (Ramat David, en formation)',
  variants_en = E'- **F-35I Adir** : unique Israeli version — only partner authorised to integrate national systems on the F-35\n- ISE differences: autonomous Israeli C4I, complementary EW suite, Rafael (Spice, Rampage) and Elbit weapons, independent cyber-security architecture\n- Orders: 50 aircraft + 25 (2023) + 25 (2024) = **100 F-35I planned by 2030**\n- Squadrons: 140 "Golden Eagle" (Nevatim, 1st operational squadron 2017), 116 "Lions of the South" (Nevatim), 117 "First Jet" (Ramat David, in formation)'
WHERE name = 'F-35I Adir';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nContrat **Peace Marble VI** signé en **octobre 2010** : 19 F-35A initialement commandés par Israël (2,75 milliards USD), 14 supplémentaires en 2015, 17 en 2016, 25 en 2023, 25 en 2024. Israël est le **premier client export** du F-35 et le **seul partenaire autorisé à intégrer des systèmes nationaux** sur la cellule — privilège unique négocié en 2008 contre l''annulation du programme national Lavi. Premier Adir livré en **décembre 2016**, premier escadron opérationnel (140 "Golden Eagle") au IOC le **6 décembre 2017**.\n\n## Carrière opérationnelle\n**Première utilisation au combat mondiale du F-35** confirmée par le chef d''état-major **Amikam Norkin** le **22 mai 2018** lors du symposium international à Herzliya : 2 frappes contre des cibles non précisées au Moyen-Orient (probablement Syrie). Engagé régulièrement depuis 2019 dans l''**opération Between the Wars** contre les convois iraniens et les dépôts Hezbollah en Syrie. L''Adir a démontré sa capacité à franchir les défenses S-300/S-400 russes déployées en Syrie sans détection.\n\n## Héritage\n**100 F-35I prévus d''ici 2030** — la plus grande flotte F-35 hors USA en Moyen-Orient. Pierre angulaire de la supériorité aérienne israélienne jusqu''en **2050+**, complétée par les F-15I et F-16I modernisés. A démontré la viabilité opérationnelle du concept furtif de 5e génération dans un environnement contesté (SAM modernes, guerre électronique, cyber).',
  description_en = E'## Genesis\n**Peace Marble VI** contract signed in **October 2010**: 19 F-35A initially ordered by Israel (USD 2.75 billion), 14 more in 2015, 17 in 2016, 25 in 2023, 25 in 2024. Israel is the **first F-35 export customer** and the **only partner authorised to integrate national systems** on the airframe — unique privilege negotiated in 2008 against cancellation of the national Lavi programme. First Adir delivered in **December 2016**, first operational squadron (140 "Golden Eagle") at IOC on **6 December 2017**.\n\n## Operational career\n**World''s first F-35 combat use** confirmed by Chief of Staff **Amikam Norkin** on **22 May 2018** at the international Herzliya symposium: 2 strikes against unspecified Middle East targets (probably Syria). Regularly engaged since 2019 in **Operation Between the Wars** against Iranian convoys and Hezbollah depots in Syria. The Adir has demonstrated capability to penetrate Russian S-300/S-400 defences deployed in Syria without detection.\n\n## Legacy\n**100 F-35I planned by 2030** — largest F-35 fleet outside the USA in the Middle East. Cornerstone of Israeli air superiority until **2050+**, complemented by upgraded F-15I and F-16I. Demonstrated the operational viability of the 5th-generation stealth concept in a contested environment (modern SAM, electronic warfare, cyber).'
WHERE name = 'F-35I Adir';
