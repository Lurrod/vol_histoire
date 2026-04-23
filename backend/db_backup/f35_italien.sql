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
    'F-35 Lightning II Italien',
    'Italian F-35 Lightning II',
    'Lockheed Martin F-35A/B Lightning II (Aeronautica Militare / Marina Militare)',
    'Lockheed Martin F-35A/B Lightning II (Italian Air Force / Italian Navy)',
    'Chasseur furtif multirôle de 5e génération assemblé en Italie à Cameri',
    '5th-generation multirole stealth fighter assembled in Italy at Cameri',
    '/assets/airplanes/f35b-lightning-2-italien.jpg',
    'Le F-35 Lightning II italien est la version exploitée par l''Aeronautica Militare (F-35A conventionnel) et la Marina Militare (F-35B à décollage court et atterrissage vertical) pour remplacer les AMX, les Tornado et les AV-8B Harrier II. L''Italie est le seul partenaire européen du programme JSF à disposer d''une chaîne d''assemblage complète, la FACO (Final Assembly and Check-Out) de Cameri, exploitée par Leonardo depuis 2013. Cette installation assemble les F-35 italiens, hollandais et une partie des F-35A destinés à l''export européen. La commande italienne totalise 90 appareils : 60 F-35A pour l''AM répartis sur le 32° Stormo d''Amendola et le 6° Stormo de Ghedi, et 30 F-35B pour la Marina Militare déployés sur le porte-aéronefs Cavour et les bases navales de Grottaglie et du 6° Stormo. Le premier F-35A italien est livré en décembre 2015 (AL-1, premier F-35 assemblé hors des États-Unis), et le premier F-35B italien atterrit à Grottaglie en janvier 2018. Équipé du radar AN/APG-81 AESA, du système EOTS de ciblage infrarouge, du casque HMDS de fusion totale et du réacteur Pratt & Whitney F135, le F-35 italien offre une capacité furtive, de pénétration profonde et de renseignement inédite pour la défense européenne. La Marina a mené sa première qualification opérationnelle du F-35B sur le Cavour en mars 2021.',
    'The Italian F-35 Lightning II is the version operated by the Aeronautica Militare (conventional F-35A) and the Marina Militare (F-35B short take-off/vertical landing) to replace AMX, Tornado and AV-8B Harrier II aircraft. Italy is the only European JSF partner to operate a complete final assembly line, the FACO (Final Assembly and Check-Out) at Cameri, operated by Leonardo since 2013. This facility assembles Italian and Dutch F-35s and part of the European-export F-35As. The Italian order totals 90 airframes: 60 F-35As for the AM split between 32° Stormo at Amendola and 6° Stormo at Ghedi, and 30 F-35Bs for the Marina Militare deployed on the Cavour aircraft carrier and the naval bases at Grottaglie and 6° Stormo. The first Italian F-35A was delivered in December 2015 (AL-1, first F-35 assembled outside the United States), and the first Italian F-35B landed at Grottaglie in January 2018. Equipped with the AN/APG-81 AESA radar, the EOTS infrared targeting system, the HMDS full-fusion helmet and the Pratt & Whitney F135 engine, the Italian F-35 delivers unprecedented stealth, deep penetration and intelligence capability for European defence. The Marina conducted its first operational F-35B qualification on the Cavour in March 2021.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '2001-10-26',
    '2015-09-07',
    '2016-12-01',
    1960.0,
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
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-81')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 15.7, wingspan = 10.7, height = 4.38, wing_area = 42.7,
  empty_weight = 13290, mtow = 31800, service_ceiling = 15000, climb_rate = 232,
  combat_radius = 1240, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'Pratt & Whitney F135-PW-100/600', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 125.0, thrust_wet = 191.0,
  production_start = 2015, production_end = NULL, units_built = 30,
  operators_count = 1,
  nickname = 'Lightning II',
  rival_id = (SELECT id FROM airplanes WHERE name = 'Su-57' LIMIT 1),
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Lockheed_Martin_F-35_Lightning_II',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Lockheed_Martin_F-35_Lightning_II'
WHERE name = 'F-35 Lightning II Italien';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 82500000, unit_cost_year = 2020,
  manufacturer_page = 'https://www.lockheedmartin.com/en-us/products/f-35.html',
  variants    = E'- **F-35A italien** : version CTOL pour l''Aeronautica Militare, 60 commandés, 32° Stormo Amendola + 6° Stormo Ghedi\n- **F-35B italien** : version STOVL pour la Marina Militare, 30 commandés, embarqué Cavour / Grottaglie\n- **FACO Cameri** : ligne d''assemblage européenne exploitée par Leonardo, unique hors États-Unis',
  variants_en = E'- **Italian F-35A** : CTOL variant for the Aeronautica Militare, 60 ordered, 32° Stormo Amendola + 6° Stormo Ghedi\n- **Italian F-35B** : STOVL variant for the Marina Militare, 30 ordered, Cavour-embarked / Grottaglie\n- **FACO Cameri** : European assembly line operated by Leonardo, unique outside the United States'
WHERE name = 'F-35 Lightning II Italien';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nL''Italie rejoint le programme **JSF** en 1998 (phase Concept), devient partenaire de **niveau 2** en 2002 (investissement 1 milliard USD) aux côtés du Royaume-Uni. Choix stratégique confirmé en 2009 : 90 appareils (60 F-35A pour l''AM + 30 F-35B pour la Marina). Construction de la **FACO Cameri** (Final Assembly and Check-Out), lignée de montage européenne ouverte en 2013 par Leonardo.\n\n## Carrière opérationnelle\nPremier F-35A italien (AL-1) livré en **décembre 2015** — premier F-35 assemblé hors USA. Premier F-35B italien à Grottaglie en **janvier 2018**. Qualification embarquée Cavour en **mars 2021** (premier F-35B européen sur pont). Déploiements opérationnels : **Islande 2019, 2023**, **Estonie / Pologne 2022** (Baltic Air Policing post-invasion russe).\n\n## Héritage\n**Seul partenaire européen** à assembler le F-35. Cameri produit aussi des composants pour le monde entier (50 % des ailes livrées). **Remplacement stratégique** des AMX (frappe tactique), Tornado (frappe profonde) et AV-8B Harrier II (Marina). Capacité furtive + réseau Link-16 + nouvelle doctrine multi-domaines. Noyau de la défense aérienne italienne jusqu''à 2060+.',
  description_en = E'## Genesis\nItaly joins the **JSF** programme in 1998 (Concept phase), becomes a **Tier 2 partner** in 2002 (1 billion USD investment) alongside the UK. Strategic decision confirmed in 2009: 90 airframes (60 F-35A for the AM + 30 F-35B for the Marina). Construction of the **FACO Cameri** (Final Assembly and Check-Out), European assembly line opened in 2013 by Leonardo.\n\n## Operational career\nFirst Italian F-35A (AL-1) delivered in **December 2015** — first F-35 assembled outside the USA. First Italian F-35B at Grottaglie in **January 2018**. Cavour carrier qualification in **March 2021** (first European F-35B on deck). Operational deployments: **Iceland 2019, 2023**, **Estonia / Poland 2022** (Baltic Air Policing post-Russian invasion).\n\n## Legacy\n**Sole European partner** assembling the F-35. Cameri also produces components worldwide (50% of delivered wings). **Strategic replacement** of AMX (tactical strike), Tornado (deep strike) and AV-8B Harrier II (Marina). Stealth capability + Link-16 network + new multi-domain doctrine. Core of Italian air defence through 2060+.'
WHERE name = 'F-35 Lightning II Italien';

-- [auto:011] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=8ZoMVZhyq1U'
WHERE name = 'F-35 Lightning II Italien';
