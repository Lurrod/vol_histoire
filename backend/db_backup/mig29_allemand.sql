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
    'MiG-29 Allemand',
    'German MiG-29',
    'Mikoyan MiG-29A/UB Fulcrum (NVA / Luftwaffe)',
    'Mikoyan MiG-29A/UB Fulcrum (NVA / Luftwaffe)',
    'Chasseur de supériorité aérienne de 4e génération, joyau hérité de l''Allemagne de l''Est',
    '4th-generation air superiority fighter, jewel inherited from East Germany',
    '/assets/airplanes/mig29-allemand.jpg',
    'Le MiG-29 allemand constitue un cas unique dans l''histoire de l''aviation militaire : seul chasseur de 4e génération du Pacte de Varsovie à avoir été intégré et exploité opérationnellement au sein de l''OTAN. La Nationale Volksarmee (NVA) de l''Allemagne de l''Est reçut 24 appareils — 20 MiG-29A monoplaces et 4 MiG-29UB biplaces — à partir de 1988, seulement deux ans avant la chute du Mur de Berlin. Après la réunification de 1990, contrairement aux MiG-21 et MiG-23 rapidement retirés, la Luftwaffe décida de conserver les MiG-29 en service actif au sein du JG 73 « Steinhoff » basé à Laage, en Mecklembourg. Cette décision s''avéra stratégiquement précieuse : les Fulcrum allemands participèrent à de nombreux exercices OTAN, révélant les capacités redoutables du missile R-73 Archer couplé au viseur de casque, et démontrant une supériorité en combat rapproché face aux F-16 et F/A-18 occidentaux. Les appareils furent modernisés aux standards OTAN avec l''intégration de systèmes IFF, de communications sécurisées et d''un GPS. En 2003, après 15 ans de service sous les couleurs allemandes, les 22 MiG-29 restants furent cédés à la Pologne pour un euro symbolique chacun, mettant fin à ce chapitre exceptionnel de l''aviation européenne.',
    'The German MiG-29 constitutes a unique case in military aviation history: the only 4th-generation fighter from the Warsaw Pact to have been integrated and operationally operated within NATO. The East German Nationale Volksarmee (NVA) received 24 aircraft — 20 single-seat MiG-29A and 4 twin-seat MiG-29UB — from 1988, only two years before the fall of the Berlin Wall. After the 1990 reunification, unlike the MiG-21 and MiG-23 which were quickly retired, the Luftwaffe decided to keep the MiG-29s in active service within JG 73 "Steinhoff" based at Laage in Mecklenburg. This decision proved strategic.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1974-01-01',
    '1977-10-06',
    '1988-05-01',
    2450.0,
    1430.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Radar N019')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-27R')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-27T')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM armement WHERE name = 'S-8'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 17.32, wingspan = 11.36, height = 4.73, wing_area = 38.0,
  empty_weight = 11000, mtow = 20000, service_ceiling = 18013, climb_rate = 330,
  combat_radius = 700, crew = 1,
  engine_name = 'Klimov RD-33', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 49.4, thrust_wet = 81.4,
  nickname = 'Fulcrum',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mikoyan_MiG-29',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mikoyan_MiG-29'
WHERE name = 'MiG-29 Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 29000000, unit_cost_year = 1989,
  production_start = 1982, production_end = 1991,
  operators_count = 1,
  variants    = E'- **MiG-29A** : Luftwaffe est-allemande (NVA, puis intégrée Luftwaffe 1990-2004)\n- Transférés à la Pologne pour 1 € symbolique en 2003-2004',
  variants_en = E'- **MiG-29A** : East German Air Force (NVA, then Luftwaffe 1990–2004)\n- Transferred to Poland for symbolic €1 in 2003–2004'
WHERE name = 'MiG-29 Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nPeu avant la chute du Mur, la RDA commande 20 MiG-29A monoplaces et 4 MiG-29UB biplaces, dernier chasseur reçu par son armée. Ils entrent en service en 1988 au **Jagdfliegergeschwader 3** de Preschen, près de la frontière polonaise, et y volent environ 4 000 heures jusqu''au dernier vol de la NVA, le 27 septembre 1990.\n\n## Conception\nVersion d''exportation, le MiG-29A est-allemand n''a ni liaison de données ni transpondeur d''identification soviétique. Il conserve en revanche ce qui intrigue les Occidentaux : le missile **R-73** asservi à un viseur de casque, capable d''accrocher une cible à 45 degrés de l''axe, et une agilité qui le rend redoutable en combat tournoyant. Rayon d''action court, radar limité et radio unique en font surtout un avion de défense ponctuelle.\n\n## Carrière opérationnelle\nPendant la **guerre froide**, les MiG-29 du JG-3 servent au sein du pacte de Varsovie. Le 3 octobre 1990, la Bundeswehr reprend les 24 avions ; le régiment devient une escadre d''essais, et en juillet 1991 le gouvernement décide d''intégrer le monoplace à la défense aérienne de l''OTAN. Aucun autre pays de l''Alliance ne possède alors d''avion de combat d''origine soviétique. Rattachés en 1993 au **JG 73 « Steinhoff »**, testés et modifiés à Manching, les MiG installés à Laage en 1994 y tiennent l''alerte aux côtés des F-4F. Ils deviennent surtout des adversaires très demandés dans les exercices de l''OTAN, aux États-Unis notamment, où les pilotes alliés découvrent l''efficacité du couple R-73 et viseur de casque. Un appareil est perdu le 25 juin 1996.\n\n## Place dans l''histoire\nL''arrivée de l''Eurofighter scelle leur sort : le 24 juin 2003, l''Allemagne cède à la **Pologne** les avions restants, 22 ou 23 selon les sources, pour un euro symbolique chacun. Les derniers rejoignent Bydgoszcz le 4 août 2004, après plus de 30 000 heures de vol sous les couleurs allemandes. En 2023, Berlin autorise Varsovie à transférer certains de ces anciens MiG-29 allemands à l''Ukraine.',
  description_en = E'## Genesis\nShortly before the fall of the Wall, East Germany ordered 20 single-seat MiG-29As and 4 two-seat MiG-29UBs, the last fighter its forces would receive. They entered service in 1988 with **Jagdfliegergeschwader 3** at Preschen, near the Polish border, and logged about 4,000 hours there until the NVA''s last flight on 27 September 1990.\n\n## Design\nAn export version, the East German MiG-29A had neither data link nor Soviet IFF transponder. It did keep what intrigued the West: the **R-73** missile cued by a helmet-mounted sight, able to lock on 45 degrees off boresight, and an agility that made it formidable in a turning fight. Short range, a limited radar and a single radio made it above all a point-defence aircraft.\n\n## Operational career\nDuring the **Cold War**, JG-3''s MiG-29s served within the Warsaw Pact. On 3 October 1990 the Bundeswehr took over all 24 aircraft; the regiment became a test wing, and in July 1991 the government decided to integrate the single-seater into NATO air defence. No other Alliance member then owned a Soviet-built combat aircraft. Joined to **JG 73 "Steinhoff"** in 1993, tested and modified at Manching, the MiGs settled at Laage in 1994, where they stood alert alongside the F-4Fs. Above all they became sought-after adversaries in NATO exercises, notably in the United States, where allied pilots discovered how effective the R-73 and helmet sight combination was. One aircraft was lost on 25 June 1996.\n\n## Place in history\nThe arrival of the Eurofighter sealed their fate: on 24 June 2003 Germany handed the remaining aircraft, 22 or 23 depending on the source, to **Poland** for a symbolic euro each. The last ones reached Bydgoszcz on 4 August 2004, after more than 30,000 flying hours in German colours. In 2023 Berlin allowed Warsaw to pass some of these former German MiG-29s on to Ukraine.'
WHERE name = 'MiG-29 Allemand';

-- [auto:012] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=sWGjdtKv2kk'
WHERE name = 'MiG-29 Allemand';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MiG-29 Allemand';
