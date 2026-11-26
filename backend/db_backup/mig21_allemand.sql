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
    'MiG-21 Allemand',
    'German MiG-21',
    'Mikoyan-Gourevitch MiG-21 Fishbed (NVA / Luftwaffe)',
    'Mikoyan-Gurevich MiG-21 Fishbed (NVA / Luftwaffe)',
    'Chasseur supersonique soviétique de 3e génération au service de l''Allemagne de l''Est puis réunifiée',
    'Soviet 3rd-generation supersonic fighter in East German and reunified German service',
    '/assets/airplanes/mig21-allemand.jpg',
    'Le MiG-21 allemand fut l''avion de combat principal des forces aériennes de la République démocratique allemande (Nationale Volksarmee - NVA). À partir de 1962, l''Allemagne de l''Est reçut progressivement plusieurs variantes du Fishbed — MiG-21F-13, MiG-21PF, MiG-21PFM, MiG-21M, MiG-21MF, MiG-21bis et MiG-21U d''entraînement — totalisant plus de 570 appareils livrés par l''Union soviétique. Le MiG-21 constitua l''épine dorsale de la défense aérienne est-allemande pendant toute la Guerre froide, assurant l''interception et la supériorité aérienne face aux forces de l''OTAN le long du rideau de fer. La version MiG-21bis, dernière évolution majeure, disposait du réacteur Tumansky R-25-300 plus puissant et du radar RP-22 amélioré. Après la réunification allemande en 1990, la Luftwaffe hérita de 24 MiG-21bis encore opérationnels. Brièvement évalués et utilisés pour l''entraînement au combat dissimilaire — offrant aux pilotes de l''OTAN une expérience unique face à un chasseur du Pacte de Varsovie —, ils furent définitivement retirés du service en 1993 et remplacés par des appareils occidentaux.',
    'The German MiG-21 was the main combat aircraft of the East German air force (Nationale Volksarmee - NVA). From 1962, East Germany gradually received several variants of the Fishbed — MiG-21F-13, MiG-21PF, MiG-21PFM, MiG-21M, MiG-21MF, MiG-21bis and MiG-21U trainers — totaling more than 570 aircraft delivered by the Soviet Union. The MiG-21 formed the backbone of East German air defense throughout the Cold War, providing interception and air superiority against NATO forces along the Iron Curtain.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1954-01-01',
    '1956-06-14',
    '1962-06-01',
    2230.0,
    1210.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur Tumansky R-25')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Radar RP-21')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'R-3S')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'R-13M')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM armement WHERE name = 'S-24'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 14.50, wingspan = 7.15, height = 4.10, wing_area = 23.0,
  empty_weight = 5350, mtow = 9100, service_ceiling = 17800, climb_rate = 225,
  combat_radius = 370, crew = 1,
  engine_name = 'Tumanski R-25-300', engine_count = 1,
  engine_type = 'Turboréacteur avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 40.2, thrust_wet = 69.6,
  nickname = 'Fishbed',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_MiG-21',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mikoyan-Gurevich_MiG-21'
WHERE name = 'MiG-21 Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 3000000, unit_cost_year = 1975,
  production_start = 1959, production_end = 1985,
  operators_count = 1,
  variants    = E'- **MiG-21F/PF** : NVA (armée de l''air est-allemande) — retirés 1990\n- **MiG-21bis** : dernière version en service avant la réunification',
  variants_en = E'- **MiG-21F/PF** : East German Air Force — retired 1990\n- **MiG-21bis** : final variant before German reunification'
WHERE name = 'MiG-21 Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nIntégrée depuis 1961 au système d''alerte permanente de la défense aérienne du pacte de Varsovie, l''aviation de la **NVA**, l''armée populaire de RDA, reçoit en 1962 ses premiers **MiG-21F-13**. Soixante-seize arrivent jusqu''en 1964 ; ils équipent les escadres de chasse JG-8 et JG-9 et une escadrille de la JG-3, qui garde les siens jusqu''en 1974. Le Fishbed devient dès lors le chasseur de la RDA.\n\n## Conception\nLes livraisons suivent l''évolution du type en URSS. 53 MiG-21PF arrivent à partir de 1964, puis environ 84 PFM, appelés SPS en RDA, et quelque 55 SPS-K à canon en nacelle. Viennent ensuite 87 MiG-21M entre décembre 1968 et octobre 1970, puis 62 MiG-21MF de 1972 à 1975, dont les douze derniers étaient prévus pour le Vietnam. À partir de 1975 arrivent les **MiG-21bis**, en versions « Lasur » et « SAU », finalement regroupés à la JG-8 de Marxwalde. Des biplaces forment les pilotes, et des F-13 équipés de caméras assurent la reconnaissance de 1974 à 1985. Au total, la RDA acquiert 557 MiG-21, révisés toutes les 650 heures de vol à la Flugzeugwerft de Dresde.\n\n## Carrière opérationnelle\nPendant la **guerre froide**, le MiG-21 forme l''essentiel de la chasse est-allemande, face à l''OTAN, au sein de la défense aérienne commune du pacte : la JG-1 à Holzdorf, la JG-2 à Trollenhagen, la JG-3 à Preschen et la JG-8 à Marxwalde en volent. En 1989, l''inventaire compte encore 227 MiG-21. Le prix humain est lourd : 126 appareils perdus, près d''un quart de la flotte, et au moins 54 morts ; l''éjection à basse altitude, en particulier, reste dangereuse si la verrière n''a pas été larguée d''abord.\n\n## Place dans l''histoire\nLe 3 octobre 1990, la Bundeswehr hérite du matériel de la NVA. Elle ne garde en ligne que les MiG-29 : les MiG-21, dont 41 MiG-21bis inscrits à son inventaire, sont rayés en 1992-1993, et 140 sont démantelés à Dresde au titre des traités de désarmement. Quelques-uns survivent dans des musées allemands, comme Sinsheim, Rothenburg ou Berlin-Gatow, et un a été offert au Canada, où il est exposé à Trenton.',
  description_en = E'## Genesis\nPart of the Warsaw Pact''s permanent air defence duty system since 1961, the air arm of East Germany''s **National People''s Army (NVA)** received its first **MiG-21F-13s** in 1962. Seventy-six arrived by 1964, equipping fighter wings JG-8 and JG-9 and one squadron of JG-3, which kept them until 1974. From then on the Fishbed was East Germany''s fighter.\n\n## Design\nDeliveries followed the type''s evolution in the Soviet Union. Fifty-three MiG-21PFs arrived from 1964, then about 84 PFMs, known locally as SPS, and some 55 SPS-Ks with a gun pod. Next came 87 MiG-21Ms between December 1968 and October 1970, then 62 MiG-21MFs from 1972 to 1975, the last twelve originally meant for Vietnam. From 1975 came the **MiG-21bis**, in "Lasur" and "SAU" versions, eventually concentrated in JG-8 at Marxwalde. Two-seaters trained the pilots, and camera-equipped F-13s flew reconnaissance from 1974 to 1985. In all East Germany acquired 557 MiG-21s, overhauled every 650 flight hours at the Dresden aircraft works.\n\n## Operational career\nThroughout the **Cold War** the MiG-21 made up most of the East German fighter force, facing NATO within the Pact''s joint air defence: JG-1 at Holzdorf, JG-2 at Trollenhagen, JG-3 at Preschen and JG-8 at Marxwalde all flew it. In 1989 the inventory still held 227 MiG-21s. The human cost was heavy: 126 aircraft lost, nearly a quarter of the fleet, and at least 54 killed; low-level ejection in particular was dangerous unless the canopy had been jettisoned first.\n\n## Place in history\nOn 3 October 1990 the Bundeswehr inherited the NVA''s equipment. It kept only the MiG-29s in service: the MiG-21s, including 41 MiG-21bis taken onto its books, were struck off in 1992-93, and 140 were dismantled at Dresden under the disarmament treaties. A few survive in German museums such as Sinsheim, Rothenburg and Berlin-Gatow, and one was given to Canada, where it is on display at Trenton.'
WHERE name = 'MiG-21 Allemand';

-- [auto:012] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=9lTkAK3bhOU'
WHERE name = 'MiG-21 Allemand';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MiG-21 Allemand';
