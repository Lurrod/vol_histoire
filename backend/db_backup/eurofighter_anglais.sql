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
    'Eurofighter Typhoon Anglais',
    'British Eurofighter Typhoon',
    'Eurofighter Typhoon (Royal Air Force)',
    'Eurofighter Typhoon (Royal Air Force)',
    'Chasseur multirôle européen de 4e génération au service de la RAF',
    'European 4th-generation multirole fighter in RAF service',
    '/assets/airplanes/eurofighter-anglais.jpg',
    'L''Eurofighter Typhoon est un avion de combat multirôle développé par un consortium européen regroupant le Royaume-Uni, l''Allemagne, l''Italie et l''Espagne. Classé dans la 4e génération avancée, il se distingue par sa configuration canard-delta, sa commande de vol électrique et ses performances exceptionnelles en combat aérien rapproché. La version britannique, opérée par la Royal Air Force, a été déployée en opérations réelles au-dessus de la Libye, de l''Irak et de la Syrie. Équipé du radar CAPTOR évoluant vers une antenne AESA, de missiles Meteor à longue portée et du système de fusion de capteurs, le Typhoon constitue l''épine dorsale de la défense aérienne britannique et restera en service au-delà de 2040.',
    'The Eurofighter Typhoon is a multirole combat aircraft developed by a European consortium bringing together the United Kingdom, Germany, Italy and Spain. Classified as advanced 4th generation, it is distinguished by its canard-delta configuration, its electric flight control system and its exceptional performance in close air combat. The British version, operated by the Royal Air Force, has been deployed in real operations over Libya, Iraq and Syria. Equipped with the CAPTOR radar evolving towards an AESA array, long-range Meteor missiles and the sensor fusion system, the Typhoon forms the backbone of British air defense and will remain in service beyond 2040.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1983-01-01',
    '1994-03-27',
    '2003-12-04',
    2495.0,
    2900.0,
    (SELECT id FROM manufacturer WHERE code = 'BAE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM tech WHERE name = 'Radar CAPTOR')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'ASRAAM')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'Storm Shadow')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'Brimstone')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'Paveway IV')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 15.96, wingspan = 10.95, height = 5.28, wing_area = 50.0,
  empty_weight = 11000, mtow = 23500, service_ceiling = 19810, climb_rate = 315,
  combat_radius = 1389, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'Eurojet EJ200', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 60.0, thrust_wet = 90.0,
  production_start = 1994, production_end = NULL, units_built = 594,
  operators_count = 10,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Eurofighter_Typhoon',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Eurofighter_Typhoon'
WHERE name = 'Eurofighter Typhoon Anglais';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 100000000, unit_cost_year = 2013,
  manufacturer_page = 'https://www.eurofighter.com/',
  variants    = E'- **Tranche 1** : configuration initiale, air-air limitée\n- **Tranche 2** : intégration ciblage air-sol\n- **Tranche 3/3A** : radar AESA Captor-E, nouvelles liaisons de données\n- **Tranche 4** : dernière tranche en production (commandes 2020+)',
  variants_en = E'- **Tranche 1** : initial configuration, limited air-to-air\n- **Tranche 2** : air-to-ground integration\n- **Tranche 3/3A** : Captor-E AESA radar, new datalinks\n- **Tranche 4** : latest production tranche (2020+ orders)'
WHERE name = 'Eurofighter Typhoon Anglais';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nPartenaire du programme européen lancé en 1983 avec l''Allemagne, l''Italie et l''Espagne, le Royaume-Uni prévoit d''abord 232 avions ; il en commandera 160, tous livrés en septembre 2019. Le premier Typhoon de série de la **RAF** vole le 14 février 2003 et le 17e escadron, unité d''évaluation, reçoit ses premiers avions fin 2003.\n\n## Conception\nDelta-canard instable piloté par commandes électriques, mû par deux **EJ200**, le Typhoon britannique naît chasseur : le 3e escadron, première unité de ligne le 31 mars 2006, prend l''alerte (QRA) aux Tornado F3 le 29 juin 2007. Il est déclaré apte à l''attaque au sol le 1er juillet 2008, et le programme **Centurion** (425 millions de livres) lui transfère les armes du Tornado GR4, retiré en mars 2019. Quatre Typhoon relèvent aussi les Tornado F3 aux **Malouines** fin 2009.\n\n## Carrière opérationnelle\nEn **Libye** (*Ellamy*), les Typhoon de Gioia del Colle effectuent leur toute première mission de combat le 21 mars 2011, leur première attaque au sol le 12 avril, et totalisent 91 frappes à la mi-juillet. Contre l''**État islamique** (*Shader*), ils arrivent à Akrotiri en décembre 2015, remplacent seuls les Tornado fin janvier 2019 et tirent en 2021 leurs premiers Storm Shadow sur des grottes près d''Erbil. En **Syrie**, ils escortent les Tornado lors des frappes du 14 avril 2018 ; le 14 décembre 2021, l''un d''eux abat un drone hostile près d''Al-Tanf, premier combat aérien d''un Typhoon britannique, et le 3 janvier 2026 ils bombardent un site souterrain de l''EI près de Palmyre. Au **Yémen**, quatre Typhoon FGR4 frappent le 12 janvier 2024 le site de drones de Bani et l''aérodrome d''Abbs à la Paveway IV ; ils reviennent en février et en mai 2024, puis visent le 29 avril 2025 une usine de drones près de Sanaa.\n\n## Place dans l''histoire\nLe Typhoon tient aussi la police du ciel de l''OTAN, comme en Estonie en 2019. Les avions de la Tranche 1 doivent quitter le service d''ici 2025 ; la revue de défense de 2015 a repoussé le retrait de la flotte de 2030 à 2040 et porté le nombre d''escadrons de ligne de cinq à sept.',
  description_en = E'## Genesis\nA partner in the European programme launched in 1983 with Germany, Italy and Spain, the United Kingdom first planned for 232 aircraft; it ordered 160, all delivered by September 2019. The first **RAF** production Typhoon flew on 14 February 2003, and No. 17 Squadron, the evaluation unit, received its first aircraft at the end of 2003.\n\n## Design\nAn unstable canard-delta flown by fly-by-wire and powered by two **EJ200s**, the British Typhoon began life as a fighter: No. 3 Squadron, the first front-line unit on 31 March 2006, took over quick reaction alert (QRA) from the Tornado F3 on 29 June 2007. It was declared combat ready for ground attack on 1 July 2008, and **Project Centurion** (GBP 425 million) gave it the weapons of the Tornado GR4, retired in March 2019. Four Typhoons also replaced the Tornado F3s in the **Falklands** in late 2009.\n\n## Operational career\nOver **Libya** (*Ellamy*), Typhoons from Gioia del Colle flew their first ever combat mission on 21 March 2011, their first ground attack on 12 April, and 91 strikes by mid-July. Against the **Islamic State** (*Shader*), they reached Akrotiri in December 2015, took over from the Tornados in late January 2019 and fired their first Storm Shadows in 2021 at caves near Erbil. Over **Syria**, they escorted the Tornados in the strikes of 14 April 2018; on 14 December 2021 one shot down a hostile drone near al-Tanf, the British Typhoon''s first air-to-air engagement, and on 3 January 2026 they bombed an underground ISIS site near Palmyra. Over **Yemen**, four Typhoon FGR4s struck the Bani drone site and Abbs airfield with Paveway IVs on 12 January 2024; they returned in February and May 2024, then hit a drone factory near Sanaa on 29 April 2025.\n\n## Place in history\nThe Typhoon also flies NATO air policing, as in Estonia in 2019. Tranche 1 aircraft are due to leave service by 2025; the 2015 defence review pushed the fleet''s out-of-service date from 2030 to 2040 and raised the front-line squadrons from five to seven.'
WHERE name = 'Eurofighter Typhoon Anglais';

-- [auto:011] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=4F-7EbzuUNY'
WHERE name = 'Eurofighter Typhoon Anglais';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'Eurofighter Typhoon Anglais';
