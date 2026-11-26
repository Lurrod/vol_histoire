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
    'Avro Vulcan',
    'Avro Vulcan',
    'Avro Vulcan B.2',
    'Avro Vulcan B.2',
    'Bombardier stratégique nucléaire britannique de 2e génération à aile delta',
    'British 2nd-generation strategic nuclear bomber with delta wing',
    '/assets/airplanes/avro_vulcan.jpg',
    'L''Avro Vulcan est un bombardier stratégique à aile delta développé pour la Royal Air Force dans le cadre de la force de dissuasion nucléaire britannique, les célèbres « V-Bombers ». Classé dans la 2e génération, il se distingue par sa spectaculaire voilure delta sans empennage, lui offrant une grande altitude opérationnelle et une maniabilité surprenante pour un bombardier de cette taille. Propulsé par quatre réacteurs Rolls-Royce Olympus, il était capable de pénétrer l''espace aérien soviétique à haute altitude pour délivrer des armes nucléaires. Avec l''évolution des défenses antiaériennes, son rôle a évolué vers la pénétration à basse altitude. Le Vulcan s''est illustré de manière spectaculaire lors de la guerre des Malouines en 1982 avec les raids « Black Buck », les missions de bombardement les plus longues de l''histoire à cette époque, frappant l''aérodrome de Port Stanley. Retiré en 1984, il reste l''un des avions militaires britanniques les plus emblématiques.',
    'The Avro Vulcan is a delta-wing strategic bomber developed for the Royal Air Force as part of the British nuclear deterrent force, the famous "V-Bombers". Classified as 2nd generation, it is distinguished by its spectacular tailless delta wing, offering it high operational altitude and surprising maneuverability for a bomber of this size. Powered by four Rolls-Royce Olympus engines, it was capable of penetrating Soviet airspace at high altitude to deliver nuclear weapons. With the evolution of air defenses, its role evolved towards low-altitude penetration. The Vulcan distinguished itself spectacularly during the Falklands War in 1982 with the "Black Buck" raids, the longest bombing missions in history at the time, striking Port Stanley airfield. Retired in 1984, it remains one of the most iconic British military aircraft.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1947-01-01',
    '1952-08-30',
    '1957-05-20',
    1038.0,
    7400.0,
    (SELECT id FROM manufacturer WHERE code = 'AVR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Radar H2S')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM armement WHERE name = 'WE.177')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM armement WHERE name = '1000 lb GP')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM armement WHERE name = 'AGM-45 Shrike'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Avro Vulcan'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 32.15, wingspan = 33.83, height = 8.28, wing_area = 368.3,
  empty_weight = 37144, mtow = 92534, service_ceiling = 16800, climb_rate = 20.3,
  combat_radius = 2600, crew = 5,
  engine_name = 'Rolls-Royce Olympus 301', engine_count = 4,
  engine_type = 'Turboréacteur', engine_type_en = 'Turbojet',
  thrust_dry = 88.96,
  production_start = 1952, production_end = 1965, units_built = 136,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Avro_Vulcan',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Avro_Vulcan'
WHERE name = 'Avro Vulcan';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 2000000, unit_cost_year = 1960,
  variants    = E'- **Vulcan B.1** : version initiale, bombe nucléaire à chute libre\n- **Vulcan B.2** : version modernisée, missile Blue Steel\n- **Vulcan K.2** : conversion ravitailleur (post-Falklands)'
WHERE name = 'Avro Vulcan';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nEn janvier 1947, le ministère britannique de l''Approvisionnement publie la spécification **B.35/46** : la **Royal Air Force** veut un bombardier à réaction capable de porter la future bombe atomique britannique au cœur de l''Union soviétique. Trois appareils en naîtront, les « V-bombers » : Valiant, Victor et Vulcan. La réponse d''**Avro** est la plus audacieuse.\n\n## Conception\nLe Vulcan est une immense aile **delta** dans laquelle s''enfouissent quatre réacteurs **Olympus**. Le prototype VX770 vole le 30 août 1952. Au B.1 succède le B.2, à voilure agrandie et moteurs plus puissants ; 136 exemplaires sont construits, prototypes compris. Cinq hommes d''équipage, un radar de bombardement **H2S** et une soute capable d''accueillir une arme nucléaire ou vingt et une bombes de 1 000 livres.\n\n## Carrière opérationnelle\nEntré en escadron en 1957, le Vulcan devient un pilier de la dissuasion pendant la **guerre froide**. Dès 1962, un appareil par escadron et par base reste armé en alerte permanente, prêt à décoller en quinze minutes ; en octobre, la crise de Cuba place le Bomber Command en alerte 3. De 1963 à 1970, trois escadrons de B.2 emportent le missile **Blue Steel**. Face aux missiles sol-air, l''avion apprend au milieu des années 1960 à pénétrer à basse altitude, puis reçoit la bombe **WE.177**.\n\nSa seule guerre survient à la veille de la retraite. Pendant la **guerre des Malouines**, quatre B.2 détachés à l''île de l''Ascension mènent les raids *Black Buck*. Le 1er mai 1982, l''équipage du flight lieutenant **Martin Withers**, ravitaillé à de multiples reprises par une noria de Victor, parcourt environ 12 200 km aller-retour en seize heures : l''une de ses vingt et une bombes crève la piste de Port Stanley, désormais interdite aux chasseurs. Deux missions suivantes attaquent les radars argentins au missile **Shrike** ; le 3 juin, l''une d''elles détruit un radar de tir Skyguard.\n\n## Place dans l''histoire\nSix Vulcan sont ensuite convertis en ravitailleurs K.2 ; le No. 50 Squadron, dernier à les employer, est dissous en mars 1984. Le XH558, ultime exemplaire en état de vol, effectue son dernier vol le 28 octobre 2015. *Black Buck* fut le plus long raid de bombardement jamais tenté, jusqu''aux B-2 américains de 2001.',
  description_en = E'## Genesis\nIn January 1947 Britain''s Ministry of Supply issued specification **B.35/46**: the **Royal Air Force** wanted a jet bomber able to carry the future British atomic bomb deep into the Soviet Union. Three aircraft came out of it, the "V-bombers": Valiant, Victor and Vulcan. **Avro**''s answer was the boldest.\n\n## Design\nThe Vulcan is a huge **delta** wing with four **Olympus** engines buried inside it. The VX770 prototype flew on 30 August 1952. The B.1 gave way to the B.2, with a larger wing and more powerful engines; 136 were built, prototypes included. It carried a crew of five, an **H2S** bombing radar and a bay big enough for a nuclear weapon or twenty-one 1,000 lb bombs.\n\n## Operational career\nReaching squadrons in 1957, the Vulcan became a mainstay of deterrence in the **Cold War**. From 1962 one aircraft per squadron at each base stood armed on permanent alert, ready to take off within fifteen minutes; that October the Cuban crisis put Bomber Command on Alert Condition 3. From 1963 to 1970 three B.2 squadrons carried the **Blue Steel** missile. As surface-to-air missiles spread, crews switched to low-level penetration in the mid-1960s, and the aircraft later received the **WE.177** bomb.\n\nIts only war came on the eve of retirement. In the **Falklands War**, four B.2s detached to Ascension Island flew the *Black Buck* raids. On 1 May 1982 Flight Lieutenant **Martin Withers**'' crew, refuelled again and again by a relay of Victor tankers, covered some 12,200 km there and back in sixteen hours: one of their twenty-one bombs cratered the Port Stanley runway, closing it to fighters. Two later missions attacked Argentine radars with **Shrike** missiles; on 3 June one of them destroyed a Skyguard fire-control radar.\n\n## Place in history\nSix Vulcans were then converted into K.2 tankers; No. 50 Squadron, the last to fly them, disbanded in March 1984. XH558, the last airworthy example, made its final flight on 28 October 2015. *Black Buck* remained the longest bombing raid ever attempted until American B-2s surpassed it in 2001.'
WHERE name = 'Avro Vulcan';

-- [auto:008] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  variants_en = E'- **Vulcan B.1** : initial version, free-fall nuclear bomb\n- **Vulcan B.2** : upgraded variant, Blue Steel missile\n- **Vulcan K.2** : tanker conversion (post-Falklands)'
WHERE name = 'Avro Vulcan';

-- [auto:012] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=a_VDLWQ1Pgw'
WHERE name = 'Avro Vulcan';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Avro Vulcan';
