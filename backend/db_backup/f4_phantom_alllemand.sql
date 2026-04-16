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
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    NULL,
    12700.0
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
  description = E'## Genèse\nVersion Luftwaffe livrée entre 1973 et 1976, produite sous licence allemande. Le F-4F simplifié abandonne certaines capacités (radar AIM-7 Sparrow) pour alléger le coût.\n\n## Carrière opérationnelle\nPrincipal chasseur de défense aérienne de la **Bundesluftwaffe** jusqu''à la fin des années 2000. Programme de modernisation **ICE** (Improved Combat Efficiency) dans les années 1990 : radar AN/APG-65, missiles AIM-120 AMRAAM.\n\n## Héritage\nRetiré en 2013, remplacé par l''Eurofighter Typhoon. Dernier opérateur européen majeur du Phantom.',
  description_en = E'## Genesis\nLuftwaffe variant delivered between 1973 and 1976, licence-built in Germany. The simplified F-4F dropped some capabilities (AIM-7 Sparrow radar) to reduce cost.\n\n## Operational career\nPrimary air-defence fighter of the **Bundesluftwaffe** until the late 2000s. Upgraded under the **ICE** (Improved Combat Efficiency) programme in the 1990s: AN/APG-65 radar, AIM-120 AMRAAM missiles.\n\n## Legacy\nRetired in 2013, replaced by the Eurofighter Typhoon. Last major European operator of the Phantom.'
WHERE name = 'F-4 Phantom II Allemand';

-- [auto:012] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=2bzjFDmLETc'
WHERE name = 'F-4 Phantom II Allemand';
