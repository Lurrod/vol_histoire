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
    'F-4 Phantom II Allemand',
    'German F-4 Phantom II',
    'McDonnell Douglas F-4F Phantom II (Luftwaffe)',
    'McDonnell Douglas F-4F Phantom II (Luftwaffe)',
    'Chasseur multirôle de 3e génération au service de la Luftwaffe',
    '3rd-generation multirole fighter in Luftwaffe service',
    '/assets/airplanes/f4-phantom-2-allemand.jpg',
    'Le McDonnell Douglas F-4F Phantom II est la variante allégée du célèbre chasseur-bombardier américain, spécialement adaptée pour la Luftwaffe ouest-allemande. Livrée à partir de 1973, cette version se distinguait par la suppression initiale de la capacité de tir de missiles AIM-7 Sparrow et par un allègement structurel pour privilégier les missions de supériorité aérienne. Au total, 175 exemplaires furent livrés à l''Allemagne de l''Ouest. Dans les années 1980, le programme ICE (Improved Combat Efficiency) modernisa profondément la flotte en intégrant le radar AN/APG-65, la capacité de tir du missile AIM-120 AMRAAM et de nouveaux systèmes de guerre électronique, propulsant l''appareil aux standards de la 4e génération. Le F-4F constitua le pilier de la défense aérienne allemande pendant plus de trois décennies de Guerre froide et au-delà, assurant des missions d''interception et de police du ciel dans le cadre de l''OTAN. Il fut définitivement retiré du service en 2013, remplacé par l''Eurofighter Typhoon.',
    'The McDonnell Douglas F-4F Phantom II is the lightened variant of the famous American fighter-bomber, specially adapted for the West German Luftwaffe. Delivered from 1973, this version was distinguished by the initial removal of AIM-7 Sparrow missile firing capability and by structural lightening to prioritize air superiority missions. A total of 175 examples were delivered to West Germany. In the 1980s, the ICE (Improved Combat Efficiency) program deeply modernized the fleet by integrating the AN/APG-65 radar, AIM-120 AMRAAM missile firing capability and new electronic warfare systems, transforming the F-4F into a formidable BVR combat aircraft.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1955-01-01',
    '1973-05-18',
    '1973-09-01',
    2370.0,
    2600.0,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Radar AN/APQ-120')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'Mk 83')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'Mk 84')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 19.2, wingspan = 11.77, height = 5.0, wing_area = 49.2,
  empty_weight = 13757, mtow = 28030, service_ceiling = 18300,
  combat_radius = 680, crew = 2, g_limit_pos = 8.5,
  engine_name = 'General Electric J79-MTU-17A', engine_count = 2,
  engine_type = 'Turboréacteur avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 52.9, thrust_wet = 79.6,
  production_start = 1971, production_end = 1981, units_built = 273,
  nickname = 'Phantom',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_F-4_Phantom_II',
  wikipedia_en = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_F-4_Phantom_II'
WHERE name = 'F-4 Phantom II Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 2400000, unit_cost_year = 1971,
  operators_count = 1,
  variants    = E'- **F-4F** : version Luftwaffe spécifique (simplifiée, AIM-9)\n- **F-4F ICE** : modernisation mid-life (AIM-120 AMRAAM, AN/APG-65)',
  variants_en = E'- **F-4F** : dedicated Luftwaffe variant (simplified, AIM-9)\n- **F-4F ICE** : mid-life upgrade (AIM-120 AMRAAM, AN/APG-65)'
WHERE name = 'F-4 Phantom II Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nPour relever une partie de ses F-104G, la Luftwaffe compare le Phantom au F-5 et au Jaguar. Après 88 RF-4E de reconnaissance commandés en 1968, elle choisit en juin 1971 une version simplifiée, moins chère, du chasseur : 175 **F-4F**, présentés comme une solution d''attente dictée par un budget serré. Le premier exemplaire, 37+01, est livré en 1973 et arrive à Wittmund le 31 août.\n\n## Conception\nLe F-4F renonce à l''AIM-7 Sparrow, faute de câblage et de rails de lancement, à l''arme nucléaire et à un réservoir de fuselage ; son radar simplifié ne guide aucun missile semi-actif. Allégé d''environ 1 500 kg par rapport au F-4E, il est classé par l''OTAN intercepteur de beau temps. Ses J79 sont produits sous licence par **MTU**. Le programme *Peace Rhine* (1980-1984) lui donne l''AIM-9L, un détecteur radar et un calculateur numérique ; l''**ICE** (Improved Combat Efficiency) modernise ensuite 110 avions entre 1991 et 1996 avec le radar **AN/APG-65** et l''**AIM-120 AMRAAM**.\n\n## Carrière opérationnelle\nPendant la **guerre froide**, à partir de 1974, les F-4F deviennent les intercepteurs de l''OTAN au-dessus de l''Allemagne de l''Ouest, au **JG 71** de Wittmund, premier équipé en mars 1974, et au **JG 74** de Neuburg, et des chasseurs-bombardiers aux **JaboG 35** et **36**, dans un dispositif où deux avions armés restent prêts à décoller face au pacte de Varsovie. Dix appareils restent aux États-Unis pour la formation ; 27 sont détruits par accident en quarante ans. Après la réunification, les F-4F volent à Laage aux côtés des MiG-29 hérités de l''Est, puis assurent la police du ciel des pays baltes en 2005, 2008, 2009, 2011 et 2012. Le JG 74 se sépare de ses Phantom le 12 juin 2008.\n\n## Place dans l''histoire\nLe 29 juin 2013, le JG 71 « Richthofen » fait ses adieux au Phantom à Wittmund avec 37+01, peint pour l''occasion : près de quarante ans après la première livraison, l''**Eurofighter Typhoon** prend le relais. L''Allemagne avait reçu 263 Phantom, reconnaissance comprise ; la Grèce et la Turquie, elles, en alignaient encore.',
  description_en = E'## Genesis\nTo replace part of its F-104G fleet, the Luftwaffe weighed the Phantom against the F-5 and the Jaguar. After ordering 88 RF-4E reconnaissance aircraft in 1968, it chose in June 1971 a simplified, cheaper version of the fighter: 175 **F-4Fs**, presented as a stopgap imposed by a tight budget. The first, 37+01, was delivered in 1973 and reached Wittmund on 31 August.\n\n## Design\nThe F-4F gave up the AIM-7 Sparrow, lacking the wiring and launch rails, nuclear capability and one fuselage tank; its simplified radar could guide no semi-active missile. Some 1,500 kg lighter than the F-4E, it was rated by NATO as a clear-weather interceptor. Its J79s were licence-built by **MTU**. The *Peace Rhine* programme (1980-1984) added the AIM-9L, a radar warning receiver and a digital weapons computer; **ICE** (Improved Combat Efficiency) then upgraded 110 aircraft between 1991 and 1996 with the **AN/APG-65** radar and the **AIM-120 AMRAAM**.\n\n## Operational career\nDuring the **Cold War**, from 1974, the F-4Fs became NATO interceptors over West Germany, with **JG 71** at Wittmund, first equipped in March 1974, and **JG 74** at Neuburg, and fighter-bombers with **JaboG 35** and **36**, within a system that kept two armed jets ready to launch facing the Warsaw Pact. Ten aircraft stayed in the United States for training; 27 were destroyed in accidents over forty years. After reunification, F-4Fs flew at Laage alongside the MiG-29s inherited from the East, then policed Baltic airspace in 2005, 2008, 2009, 2011 and 2012. JG 74 retired its Phantoms on 12 June 2008.\n\n## Place in history\nOn 29 June 2013 JG 71 "Richthofen" bade farewell to the Phantom at Wittmund with 37+01 in a special scheme: almost forty years after the first delivery, the **Eurofighter Typhoon** took over. Germany had received 263 Phantoms, reconnaissance jets included; Greece and Turkey still flew theirs.'
WHERE name = 'F-4 Phantom II Allemand';

-- [auto:012] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=2bzjFDmLETc'
WHERE name = 'F-4 Phantom II Allemand';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-4 Phantom II Allemand';
