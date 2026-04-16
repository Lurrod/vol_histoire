-- Insertion des nouveaux armements spécifiques au J-16
INSERT INTO armement (name, description) VALUES
('YJ-91', 'Missile anti-radar/antinavire, portée 120 km'),
('KD-88', 'Missile air-sol de précision, guidage TV/IR, portée 180 km');

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
    'Shenyang J-16',
    'Shenyang J-16',
    'Shenyang J-16 Strike Flanker',
    'Shenyang J-16 Strike Flanker',
    'Chasseur-bombardier multirôle chinois de 4e génération avancée',
    'Chinese advanced 4th-generation multirole fighter-bomber',
    '/assets/airplanes/j16.jpg',
    'Le Shenyang J-16 est un chasseur-bombardier multirôle biplace développé par Shenyang Aircraft Corporation, dérivé du Su-30MKK russe. Entré en service en 2015, il représente la version la plus avancée de la lignée Flanker produite en Chine, intégrant des systèmes entièrement nationaux : radar AESA, réacteurs WS-10B et avionique de dernière génération. Capable d''emporter jusqu''à 12 tonnes de charge externe, le J-16 excelle dans les missions de frappe en profondeur, de suppression des défenses aériennes et de supériorité aérienne. Une variante spécialisée en guerre électronique, le J-16D, a également été développée. Il constitue aujourd''hui l''un des appareils les plus polyvalents et les plus produits de l''aviation militaire chinoise.',
    'The Shenyang J-16 is a twin-seat multirole fighter-bomber developed by Shenyang Aircraft Corporation, derived from the Russian Su-30MKK. Entered into service in 2015, it represents the most advanced version of the Flanker lineage produced in China, integrating fully national systems: AESA radar, WS-10B engines and latest-generation avionics. Capable of carrying up to 12 tons of external load, the J-16 excels in deep strike, suppression of enemy air defenses and air superiority missions. A specialized electronic warfare variant, the J-16D, has also been developed. It is today one of the most versatile and lethal aircraft in the Chinese inventory.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2005-01-01',
    '2011-10-17',
    '2015-03-01',
    2400.0,
    3500.0,
    (SELECT id FROM manufacturer WHERE code = 'SAC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    17500.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM tech WHERE name = 'Réacteur WS-10')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM armement WHERE name = 'PL-10')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM armement WHERE name = 'PL-12')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM armement WHERE name = 'PL-15')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM armement WHERE name = 'YJ-91')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM armement WHERE name = 'KD-88')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM armement WHERE name = 'LS-6'));

-- Insertion des guerres
-- Le J-16 n'a pas été engagé dans des conflits majeurs à ce jour, donc pas d'entrée dans airplane_wars

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 22.0, wingspan = 14.7, height = 6.4, wing_area = 62.0,
  empty_weight = 17700, mtow = 35000, service_ceiling = 17500,
  combat_radius = 1500, crew = 2,
  engine_name = 'WS-10B', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 74.5, thrust_wet = 140.0,
  production_start = 2011, production_end = NULL, units_built = 300,
  operators_count = 1,
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-11' LIMIT 1),
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Shenyang_J-16',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Shenyang_J-16'
WHERE name = 'Shenyang J-16';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 60000000, unit_cost_year = 2020,
  variants    = E'- **J-16** : chasseur multi-rôle biplace\n- **J-16D** : guerre électronique (analogue au EA-18G Growler)',
  variants_en = E'- **J-16** : two-seat multi-role fighter\n- **J-16D** : electronic warfare (EA-18G Growler analogue)'
WHERE name = 'Shenyang J-16';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nÉquivalent chinois du **F-15E Strike Eagle** et du Su-30. Biplace multi-rôle lourd développé à partir du J-11B à la fin des années 2000. Premier vol en 2011.\n\n## Carrière opérationnelle\nPilier de l''aviation tactique chinoise moderne. Version J-16D de guerre électronique analogue à l''EA-18G Growler américain. Intégré dans les exercices de projection de puissance vers Taïwan et en mer de Chine méridionale.\n\n## Héritage\nPlus de **300 exemplaires** produits. Représente l''aboutissement de la famille Flanker chinoise, avant l''arrivée progressive des J-20 et J-35 furtifs.',
  description_en = E'## Genesis\nChinese equivalent of the **F-15E Strike Eagle** and the Su-30. Heavy two-seat multi-role aircraft developed from the J-11B in the late 2000s. First flew in 2011.\n\n## Operational career\nBackbone of modern Chinese tactical aviation. J-16D electronic-warfare variant analogous to the US EA-18G Growler. Integrated in power-projection exercises toward Taiwan and in the South China Sea.\n\n## Legacy\nMore than **300 built**. Represents the culmination of the Chinese Flanker family, before the progressive arrival of the stealth J-20 and J-35.'
WHERE name = 'Shenyang J-16';
