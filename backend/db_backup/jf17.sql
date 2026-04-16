-- Insertion des nouveaux armements spécifiques au FC-1/JF-17
INSERT INTO armement (name, description) VALUES
('C-802A', 'Missile antinavire subsonique, guidage radar actif, portée 180 km');

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
    'Chengdu FC-1/JF-17',
    'Chengdu FC-1/JF-17',
    'Chengdu FC-1 Xiaolong / JF-17 Thunder',
    'Chengdu FC-1 Xiaolong / JF-17 Thunder',
    'Chasseur multirôle léger sino-pakistanais de 4e génération',
    'Sino-Pakistani 4th-generation light multirole fighter',
    '/assets/airplanes/jf17.jpg',
    'Le Chengdu FC-1 Xiaolong (Fierce Dragon), désigné JF-17 Thunder au Pakistan, est un chasseur multirôle léger développé conjointement par Chengdu Aerospace Corporation et le Pakistan Aeronautical Complex. Conçu pour être un appareil abordable et performant, il vise à remplacer les flottes vieillissantes de F-7, Mirage III et A-5 de la Pakistan Air Force. Monoréacteur équipé du Klimov RD-93, il dispose d''un radar KLJ-7 et peut emporter un large éventail d''armements air-air et air-sol. Entré en service en 2007, le JF-17 est produit en série au Pakistan et a été exporté vers plusieurs pays dont la Birmanie et le Nigeria. Le Block 3, doté d''un radar AESA et de capacités améliorées, marque une évolution significative du programme.',
    'The Chengdu FC-1 Xiaolong (Fierce Dragon), designated JF-17 Thunder in Pakistan, is a light multirole fighter jointly developed by Chengdu Aerospace Corporation and Pakistan Aeronautical Complex. Designed to be an affordable and capable aircraft, it aims to replace the aging fleets of F-7, Mirage III and A-5 of the Pakistan Air Force. Single-engine equipped with the Klimov RD-93, it has a KLJ-7 radar and can carry a wide range of air-to-air and air-to-ground armaments. Entered into service in 2007, the JF-17 is mass-produced in Pakistan and has been exported to several countries including Myanmar and Nigeria. Block 3, with an AESA radar and enhanced capabilities, marks a significant leap forward.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '1991-01-01',
    '2003-08-25',
    '2007-03-12',
    1960.0,
    1352.0,
    (SELECT id FROM manufacturer WHERE code = 'CAC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    6586.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM tech WHERE name = 'Réacteur RD-93')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM tech WHERE name = 'Radar KLJ-7'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'PL-5')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'PL-8')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'PL-12')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'C-802A')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM armement WHERE name = 'LS-6'));

-- Insertion des guerres
-- Le FC-1/JF-17 n'a pas été engagé dans des conflits majeurs à ce jour (les escarmouches indo-pakistanaises de 2019 ne constituent pas un conflit répertorié)

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 14.93, wingspan = 9.45, height = 4.77, wing_area = 24.43,
  empty_weight = 6586, mtow = 12383, service_ceiling = 16700, climb_rate = 300,
  combat_radius = 1200, crew = 1, g_limit_pos = 8.0,
  engine_name = 'Klimov RD-93 ou WS-13', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 49.4, thrust_wet = 84.4,
  production_start = 2007, production_end = NULL, units_built = 200,
  operators_count = 5,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/PAC_JF-17_Thunder',
  wikipedia_en = 'https://en.wikipedia.org/wiki/CAC/PAC_JF-17_Thunder'
WHERE name = 'Chengdu FC-1/JF-17';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 25000000, unit_cost_year = 2015,
  variants    = E'- **Block I** : version initiale\n- **Block II** : ravitaillement en vol, liaison de données\n- **Block III** : radar AESA KLJ-7A (2020+)\n- **JF-17B** : biplace d''entraînement',
  variants_en = E'- **Block I** : initial version\n- **Block II** : in-flight refuelling, datalink\n- **Block III** : KLJ-7A AESA radar (2020+)\n- **JF-17B** : two-seat trainer'
WHERE name = 'Chengdu FC-1/JF-17';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nChasseur léger développé conjointement par la **Chine** (CAC) et le **Pakistan** (PAC) dans les années 2000 comme alternative abordable au F-16 américain (soumis à l''embargo pour le Pakistan).\n\n## Carrière opérationnelle\nChasseur principal de la **Pakistan Air Force** (depuis 2007). Exporté en Birmanie, Nigeria, Azerbaïdjan, Irak. Version **Block III** (depuis 2020) avec radar AESA KLJ-7A, missiles PL-15 chinois, liaison de données moderne.\n\n## Héritage\nPlus de **200 exemplaires** produits. Succès commercial notable : chasseur chinois le plus exporté hors de Chine. Engagé dans l''incident **Balakot 2019** contre l''Inde.',
  description_en = E'## Genesis\nLight fighter jointly developed by **China** (CAC) and **Pakistan** (PAC) in the 2000s as an affordable alternative to the US F-16 (subject to embargo for Pakistan).\n\n## Operational career\nMain fighter of the **Pakistan Air Force** (since 2007). Exported to Myanmar, Nigeria, Azerbaijan, Iraq. **Block III** variant (since 2020) with KLJ-7A AESA radar, Chinese PL-15 missiles, modern datalink.\n\n## Legacy\nMore than **200 built**. Notable commercial success: the most exported Chinese fighter outside China. Involved in the **Balakot 2019** incident against India.'
WHERE name = 'Chengdu FC-1/JF-17';

-- [auto:012] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=uvsp0zKhPV4'
WHERE name = 'Chengdu FC-1/JF-17';
