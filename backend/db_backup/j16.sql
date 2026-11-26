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
    'En service',
    'In service'
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
  description = E'## Genèse\nAu milieu des années 2000, l''armée de l''air chinoise possède des Su-30MKK achetés en Russie mais veut un biplace d''attaque construit chez elle. **Shenyang Aircraft Corporation** part du **J-11BS**, biplace issu du Su-27 produit sous licence, et y reporte les solutions du Su-30MKK. Le J-16 vole le 17 octobre 2011 ; un régiment en reçoit en avril 2014, mais l''avion n''est montré au public qu''au défilé de 2017.\n\n## Conception\nLe J-16 associe deux réacteurs nationaux **WS-10**, un radar à antenne active (AESA), des composites, une peinture absorbant les ondes radar et un viseur de casque. Un pilote et un officier systèmes d''armes se partagent douze points d''emport et un canon de 30 mm : missiles air-air **PL-10** et **PL-15**, missiles antinavires YJ-83K et YJ-12, armes guidées air-sol. Sa version de guerre électronique, le **J-16D**, aurait volé en décembre 2015 ; confirmée en service fin 2021, elle rappelle l''EA-18G Growler américain.\n\n## Carrière opérationnelle\nEn 2018, le J-16 remplace le J-11B monoplace sur les chaînes. Plus de 280 étaient construits fin 2023 selon les estimations ; *The Military Balance 2026* de l''IISS en compte 430, plus 20 J-16D. Sans avoir connu la guerre, il est devenu l''instrument de la pression aérienne chinoise : du 3 septembre au 3 octobre 2021, il assure 116 des 209 sorties chinoises dans la zone d''identification de défense aérienne de Taïwan, et le 4 octobre 2021 les J-16 (34 à 38 selon les décomptes) forment le gros du record de 56 avions en un jour. En mai 2022, un J-16 lâche paillettes et leurres devant un P-8 australien en mer de Chine méridionale ; en mai 2023, un autre coupe la route d''un RC-135 américain.\n\n## Place dans l''histoire\nÉquivalent chinois du **F-15E Strike Eagle**, le J-16 marque l''aboutissement de la famille Flanker en Chine : parti d''une copie, il est devenu l''un des avions de combat les plus nombreux de l''APL, aux côtés des furtifs J-20 et J-35.',
  description_en = E'## Genesis\nBy the mid-2000s the Chinese air force flew Su-30MKKs bought from Russia but wanted a home-built two-seat strike aircraft. **Shenyang Aircraft Corporation** started from the **J-11BS**, a two-seater derived from the licence-built Su-27, and carried over the Su-30MKK''s solutions. The J-16 first flew on 17 October 2011; a regiment received the type in April 2014, but it was only shown to the public at the 2017 parade.\n\n## Design\nThe J-16 combines two indigenous **WS-10** engines, an active electronically scanned array (AESA) radar, composites, radar-absorbent paint and a helmet-mounted display. A pilot and a weapon systems officer share twelve hardpoints and a 30 mm cannon: **PL-10** and **PL-15** air-to-air missiles, YJ-83K and YJ-12 anti-ship missiles and guided air-to-surface weapons. Its electronic-warfare version, the **J-16D**, reportedly first flew in December 2015; confirmed in service in late 2021, it recalls the US EA-18G Growler.\n\n## Operational career\nIn 2018 the J-16 replaced the single-seat J-11B on the production line. More than 280 had been built by the end of 2023 according to estimates; the IISS''s *The Military Balance 2026* counts 430, plus 20 J-16Ds. Without ever going to war, it has become the instrument of Chinese air pressure: from 3 September to 3 October 2021 it flew 116 of the 209 Chinese sorties into Taiwan''s air defence identification zone, and on 4 October 2021 J-16s (34 to 38 depending on the count) made up the bulk of the one-day record of 56 aircraft. In May 2022 a J-16 released chaff and flares ahead of an Australian P-8 over the South China Sea; in May 2023 another cut across the nose of a US RC-135.\n\n## Place in history\nChina''s counterpart to the **F-15E Strike Eagle**, the J-16 is the culmination of the Flanker family in China: having started as a copy, it has become one of the PLA''s most numerous combat aircraft, alongside the stealthy J-20 and J-35.'
WHERE name = 'Shenyang J-16';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'Shenyang J-16';
