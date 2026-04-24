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
    'Actif',
    'Active',
    13890.0
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
  description = E'## Genèse\nTornado allemand (Luftwaffe + Marineflieger) en versions **IDS** et **ECR** (suppression des défenses ennemies). Seul opérateur du Tornado ECR au monde avec l''Italie.\n\n## Carrière opérationnelle\nEngagé au Kosovo (1999) — premiers combats aériens de la Luftwaffe depuis 1945. En Afghanistan (reconnaissance), en Syrie (2015-2017 contre Daech). Couverture OTAN en Europe de l''Est.\n\n## Héritage\nRemplacement programmé par des F-35A et des Eurofighter à partir de 2025-2030. Marineflieger retiré en 2005. La Tornado reste en service Luftwaffe pour la mission nucléaire tactique (bombe B61 américaine).',
  description_en = E'## Genesis\nGerman Tornado (Luftwaffe + Marineflieger) in **IDS** and **ECR** (Suppression of Enemy Air Defences) variants. The only Tornado ECR operator alongside Italy.\n\n## Operational career\nUsed in Kosovo (1999) — Luftwaffe''s first air combat since 1945. In Afghanistan (reconnaissance), Syria (2015-2017 against ISIS). NATO coverage in Eastern Europe.\n\n## Legacy\nPlanned replacement by F-35As and Eurofighters from 2025-2030. Marineflieger retired in 2005. The Tornado remains in Luftwaffe service for the tactical nuclear role (US B61 bomb).'
WHERE name = 'Panavia Tornado Allemand';
