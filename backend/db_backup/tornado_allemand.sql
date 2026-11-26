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
    'Panavia Tornado Allemand',
    'German Panavia Tornado',
    'Panavia Tornado IDS/ECR (Luftwaffe)',
    'Panavia Tornado IDS/ECR (Luftwaffe)',
    'Avion d''attaque et de suppression des défenses aériennes de 4e génération',
    '4th-generation attack and air defense suppression aircraft',
    '/assets/airplanes/tornado-allemand.jpg',
    'Le Panavia Tornado allemand est la version exploitée par la Luftwaffe et la Marineflieger, déclinée en variantes IDS (Interdictor/Strike) et ECR (Electronic Combat/Reconnaissance). L''Allemagne de l''Ouest, partenaire fondateur du programme trinational avec le Royaume-Uni et l''Italie, reçut 357 appareils à partir de 1981, en grande partie assemblés par MBB (devenu DASA puis Airbus). La version IDS fut conçue pour la pénétration à très basse altitude et la frappe en profondeur derrière les lignes du Pacte de Varsovie, utilisant le radar de suivi de terrain et les ailes à géométrie variable pour voler au ras du sol à grande vitesse. La version ECR, développée spécifiquement pour la Luftwaffe, constitue une plateforme unique de suppression des défenses aériennes ennemies (SEAD), équipée du système de détection de menaces ELS et du missile anti-radar AGM-88 HARM. Déployé au Kosovo en 1999, en Afghanistan et en Syrie contre Daech, le Tornado allemand assura également la mission de partage nucléaire de l''OTAN avec des bombes B61. Il est progressivement retiré du service et remplacé par l''Eurofighter Typhoon et le F-35A Lightning II.',
    'The German Panavia Tornado is the version operated by the Luftwaffe and Marineflieger, declined in IDS (Interdictor/Strike) and ECR (Electronic Combat/Reconnaissance) variants. West Germany, a founding partner of the trinational program with the United Kingdom and Italy, received 357 aircraft from 1981, largely assembled by MBB (later DASA then Airbus). The IDS version was designed for very low-altitude penetration and deep strike behind Warsaw Pact lines, using the terrain-following radar and variable-geometry wings to fly at ground level at high speed. The ECR version, developed specifically for Germany, is specialized in electronic warfare and suppression of enemy air defenses with AGM-88 HARM missiles and ELS electronic sensors.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1968-07-01',
    '1974-08-14',
    '1981-06-01',
    2337.0,
    3890.0,
    (SELECT id FROM manufacturer WHERE code = 'ADS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Radar de suivi de terrain')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'GBU-24 Paveway III')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'Mk 83')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'B61')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'IRIS-T'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 16.72, wingspan = 8.60, height = 5.95, wing_area = 26.6,
  empty_weight = 13890, mtow = 28000, service_ceiling = 15240, climb_rate = 77,
  combat_radius = 1390, crew = 2, g_limit_pos = 7.5,
  engine_name = 'Turbo-Union RB199-34R Mk.103', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 43.8, thrust_wet = 73.5,
  production_start = 1979, production_end = 1998,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Panavia_Tornado',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Panavia_Tornado'
WHERE name = 'Panavia Tornado Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 35000000, unit_cost_year = 1988,
  operators_count = 1,
  variants    = E'- **Tornado IDS** : attaque au sol Luftwaffe + Marineflieger\n- **Tornado ECR** : seule version SEAD/reconnaissance stratégique en service Luftwaffe',
  variants_en = E'- **Tornado IDS** : Luftwaffe + Marineflieger strike\n- **Tornado ECR** : only Luftwaffe SEAD/strategic recce variant'
WHERE name = 'Panavia Tornado Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nPartenaire fondateur de **Panavia** avec le Royaume-Uni et l''Italie, l''Allemagne de l''Ouest prévoit en 1968 jusqu''à 550 avions, puis ramène sa part à 324 en 1972. Elle reçoit finalement 357 Tornado, 359 selon certaines sources, entre 1980 et 1991, pour la Luftwaffe et l''aéronavale, la Marineflieger. La première escadre opérationnelle de la Bundeswehr est navale, à Jagel ; côté Luftwaffe, la JaboG 31 de Nörvenich ouvre la marche en 1983-1984.\n\n## Conception\nLe Tornado IDS allemand est taillé pour pénétrer à très basse altitude, grâce à son aile à géométrie variable et à son radar de suivi de terrain, derrière les lignes du pacte de Varsovie ; la Marine le dote du missile antinavire **Kormoran**. L''Allemagne commande aussi 35 **Tornado ECR**, livrés de 1990 à 1991 : privés de canon, ils détectent les radars ennemis et les détruisent au missile **HARM**. Les programmes ASSTA ajoutent ensuite la nacelle Litening, les bombes guidées et le missile de croisière **Taurus**.\n\n## Carrière opérationnelle\nPendant la **guerre froide**, le Tornado peut emporter la bombe américaine **B61** : c''est la mission de la JaboG 33 de Büchel dès 1985. Dans la **guerre de Yougoslavie**, quatorze Tornado basés à Piacenza photographient la Bosnie en 1995 ; en 1999, lors de la première mission offensive de la Luftwaffe depuis 1945, les ECR escortent les raids et tirent 236 HARM en 446 sorties.\n\nEn **Afghanistan**, six Tornado de reconnaissance basés à Mazar-i-Charif photographient le terrain pour la FIAS d''avril 2007 à novembre 2010, sans bombarder. Contre l''**État islamique**, six Tornado équipés de nacelles RecceLite volent depuis Incirlik à partir du 8 janvier 2016, au-dessus de la **Syrie** et de l''Irak, puis depuis la Jordanie à partir de 2017 ; leur mission s''achève le 31 mars 2020, l''Allemagne quittant le théâtre syrien en janvier 2022.\n\n## Place dans l''histoire\nLa Marine rend ses derniers Tornado en 2005. La Luftwaffe en garde 93 en mars 2022, quand Berlin choisit 35 F-35A pour reprendre la mission nucléaire à Büchel et 15 Eurofighter ECR pour la guerre électronique ; le Tornado doit quitter le service d''ici 2030.',
  description_en = E'## Genesis\nA founding partner of **Panavia** with the United Kingdom and Italy, West Germany planned for up to 550 aircraft in 1968, then cut its share to 324 in 1972. It eventually received 357 Tornados, 359 according to some sources, between 1980 and 1991, for the Luftwaffe and naval aviation, the Marineflieger. The Bundeswehr''s first operational Tornado wing was a naval one, at Jagel; for the Luftwaffe, JaboG 31 at Nörvenich led the way in 1983-1984.\n\n## Design\nThe German Tornado IDS was built to penetrate at very low level, thanks to its swing wing and terrain-following radar, behind Warsaw Pact lines; the Navy armed it with the **Kormoran** anti-ship missile. Germany also ordered 35 **Tornado ECRs**, delivered in 1990-1991: stripped of their cannon, they located enemy radars and destroyed them with **HARM** missiles. The ASSTA upgrades later added the Litening pod, guided bombs and the **Taurus** cruise missile.\n\n## Operational career\nIn the **Cold War**, the Tornado could carry the US **B61** bomb, the mission of JaboG 33 at Büchel from 1985. In the **Yugoslav wars**, fourteen Tornados based at Piacenza photographed Bosnia in 1995; in 1999, in the Luftwaffe''s first offensive mission since 1945, the ECRs escorted the strikes and fired 236 HARMs in 446 sorties.\n\nIn **Afghanistan**, six reconnaissance Tornados based at Mazar-i-Sharif photographed the ground for ISAF from April 2007 to November 2010, with no bombing role. Against **Islamic State**, six Tornados with RecceLite pods flew from Incirlik from 8 January 2016 over **Syria** and Iraq, then from Jordan from 2017; their mission ended on 31 March 2020, and Germany left the Syrian theatre in January 2022.\n\n## Place in history\nThe Navy gave up its last Tornados in 2005. The Luftwaffe still had 93 in March 2022, when Berlin chose 35 F-35As to take over the nuclear mission at Büchel and 15 Eurofighter ECRs for electronic warfare; the Tornado is to leave service by 2030.'
WHERE name = 'Panavia Tornado Allemand';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Panavia Tornado Allemand';
