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
    'MiG-23 Allemand',
    'German MiG-23',
    'Mikoyan-Gourevitch MiG-23MF/BN Flogger (NVA / Luftwaffe)',
    'Mikoyan-Gurevich MiG-23MF/BN Flogger (NVA / Luftwaffe)',
    'Chasseur multirôle soviétique de 3e génération à géométrie variable au service de l''Allemagne de l''Est',
    'Soviet 3rd-generation variable-geometry multirole fighter in East German service',
    '/assets/airplanes/mig23-allemand.jpg',
    'Le MiG-23 allemand fut exploité par les forces aériennes de la République démocratique allemande (Luftstreitkräfte der NVA) en deux variantes principales : le MiG-23MF Flogger-B pour l''interception et la supériorité aérienne, et le MiG-23BN Flogger-H dédié à l''attaque au sol. À partir de 1978, l''Allemagne de l''Est reçut environ 50 MiG-23 qui remplacèrent progressivement une partie des MiG-21 vieillissants. Doté d''ailes à géométrie variable — une première pour les forces est-allemandes —, le MiG-23 offrait une portée et des capacités radar supérieures à son prédécesseur grâce au radar Saphir-21 (RP-23) et aux missiles R-23/R-24 à moyenne portée. La variante BN disposait d''un système de navigation et d''attaque Sokol permettant des frappes précises à basse altitude. Après la réunification de 1990, la Luftwaffe récupéra les appareils encore opérationnels. Comme pour les MiG-21, ils furent brièvement utilisés pour l''évaluation et l''entraînement dissimilaire, offrant aux pilotes occidentaux une connaissance directe des capacités du Pacte de Varsovie. L''ensemble de la flotte fut retirée du service en 1993, certains exemplaires étant cédés aux États-Unis pour des programmes d''évaluation classifiés.',
    'The German MiG-23 was operated by the East German air forces (Luftstreitkräfte der NVA) in two main variants: the MiG-23MF Flogger-B for interception and air superiority, and the MiG-23BN Flogger-H dedicated to ground attack. From 1978, East Germany received approximately 50 MiG-23s which gradually replaced some of the aging MiG-21s. Equipped with variable-geometry wings — a first for East German forces — the MiG-23 offered superior range and radar capabilities to its predecessor thanks to the Saphir-21 radar.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1964-01-01',
    '1967-06-10',
    '1978-06-01',
    2500.0,
    1900.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM tech WHERE name = 'Radar RP-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'R-23R')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'R-23T')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'R-3S')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'Kh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM armement WHERE name = 'S-24'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 16.70, wingspan = 13.97, height = 4.82, wing_area = 37.35,
  empty_weight = 9595, mtow = 17800, service_ceiling = 18500, climb_rate = 240,
  combat_radius = 1150, crew = 1,
  engine_name = 'Khatchatourov R-35F-300', engine_count = 1,
  engine_type = 'Turboréacteur avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 83.6, thrust_wet = 127.5,
  nickname = 'Flogger',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_MiG-23',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mikoyan-Gurevich_MiG-23'
WHERE name = 'MiG-23 Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 6500000, unit_cost_year = 1982,
  production_start = 1969, production_end = 1985,
  operators_count = 1
WHERE name = 'MiG-23 Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nAu milieu des années 1970, l''armée populaire nationale de RDA, la **NVA**, ajoute le MiG-23 à ses forces aériennes, jusque-là dominées par le MiG-21 ; les premiers MiG-23MF arrivent en 1978 selon les sources occidentales. C''est la première aile à géométrie variable de l''aviation est-allemande, et le premier chasseur de la RDA capable d''engager une cible à moyenne distance.\n\n## Conception\nDeux familles cohabitent. Les MiG-23MF et MiG-23ML d''interception portent le radar **Saphir-21** et des missiles R-23 et R-24 ; le MiG-23BN d''attaque, sans radar, mise sur un système de navigation et de tir pour frapper à basse altitude. Des biplaces MiG-23UB servent à la transformation. Selon les décomptes, la NVA a aligné 12 MF, 32 ML, 22 BN et 11 UB, dont 13 perdus.\n\n## Carrière opérationnelle\nPendant la **guerre froide**, les MiG-23MF et ML arment le **JG-9 « Heinrich Rau »** de Peenemünde, sur la Baltique, à raison de deux escadrilles de ML et d''une de MF, tandis que les MiG-23BN équipent le **JBG-37** de Cottbus-Drewitz. Tous s''insèrent dans la défense aérienne intégrée du pacte de Varsovie. À la fin des années 1980, on envisage de confier le JG-9 à la marine est-allemande, avant d''y renoncer : le MiG-23 ne s''y prête pas. L''avion est exigeant ; le 13 septembre 1990, un MiG-23ML s''écrase à Peenemünde lors d''une démonstration devant la commission de défense du Bundestag, et son pilote, le major Sascha Syrbe, est tué. C''est le dernier accident mortel de la NVA. Le JG-9 vole pour la dernière fois le 26 septembre 1990 et l''armée est-allemande disparaît le 2 octobre.\n\n## Place dans l''histoire\nÀ la réunification, la Bundeswehr hérite de 18 MiG-23BN, 12 MF, 28 ML et de quelques biplaces, mais ne les garde pas, à la différence des MiG-29. Le centre d''essais WTD 61 en étudie un exemplaire de chaque version ; neuf ML et un BN partent aux États-Unis pour l''entraînement contre un adversaire simulé, un BN au Royaume-Uni, et les autres finissent en musée ou à la ferraille.',
  description_en = E'## Genesis\nIn the mid-1970s East Germany''s National People''s Army, the **NVA**, added the MiG-23 to an air force until then dominated by the MiG-21; Western sources date the first MiG-23MFs to 1978. It was the East German air arm''s first variable-geometry aircraft, and the first GDR fighter able to engage targets at medium range.\n\n## Design\nTwo families served side by side. The MiG-23MF and MiG-23ML interceptors carried the **Sapfir-21** radar and R-23 and R-24 missiles; the MiG-23BN attack version had no radar and relied on a navigation and weapon-aiming system for low-level strikes. Two-seat MiG-23UBs were used for conversion. By the usual counts the NVA fielded 12 MFs, 32 MLs, 22 BNs and 11 UBs, 13 of which were lost.\n\n## Operational career\nDuring the **Cold War**, MiG-23MFs and MLs equipped **JG-9 "Heinrich Rau"** at Peenemünde on the Baltic, with two ML squadrons and one MF squadron, while MiG-23BNs equipped **JBG-37** at Cottbus-Drewitz. All were part of the Warsaw Pact''s integrated air defence. In the late 1980s there were plans to hand JG-9 to the East German navy, but they were dropped because the MiG-23 was unsuited to the role. The aircraft was demanding: on 13 September 1990 a MiG-23ML crashed at Peenemünde during a display for the Bundestag defence committee, killing its pilot, Major Sascha Syrbe, in the NVA''s last fatal accident. JG-9 flew for the last time on 26 September 1990, and the East German army ceased to exist on 2 October.\n\n## Place in history\nOn reunification the Bundeswehr inherited 18 MiG-23BNs, 12 MFs, 28 MLs and a few two-seaters, but did not keep them, unlike the MiG-29. The WTD 61 test centre evaluated one example of each version; nine MLs and a BN went to the United States for adversary training, a BN to the United Kingdom, and the rest ended up in museums or as scrap.'
WHERE name = 'MiG-23 Allemand';

-- [auto:012] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=sKeE5zT_XpM'
WHERE name = 'MiG-23 Allemand';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MiG-23 Allemand';
