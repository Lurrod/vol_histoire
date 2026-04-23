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
    'Panavia Tornado Italien',
    'Italian Panavia Tornado',
    'Panavia Tornado IDS/ECR (Aeronautica Militare)',
    'Panavia Tornado IDS/ECR (Italian Air Force)',
    'Chasseur-bombardier à géométrie variable de 4e génération en service dans l''Aeronautica Militare',
    '4th-generation variable-geometry strike fighter in Aeronautica Militare service',
    '/assets/airplanes/tornado-italien.jpg',
    'Le Tornado italien est la version exploitée par l''Aeronautica Militare, produite par Aeritalia (future Leonardo) en partenariat avec BAE et MBB au sein du consortium Panavia. L''Italie, partenaire à 15 % du programme aux côtés du Royaume-Uni et de l''Allemagne, a reçu 100 Tornado IDS (Interdictor/Strike) à partir de 1982, affectés aux 6°, 36° et 50° Stormo à Ghedi, Gioia del Colle et Piacenza. En complément, 16 cellules IDS ont été converties en Tornado ECR (Electronic Combat/Reconnaissance) pour les missions SEAD au sein du 155° Gruppo, rôle qui confère à l''Italie une capacité unique en Europe. Le programme d''évolution MLU (Mid-Life Update) conduit entre 2005 et 2019 a intégré les missiles Storm Shadow, les bombes GBU-24/GBU-49, la liaison de données Link-16 et le pod désignateur Litening III. Engagé pendant la Guerre du Golfe (opération Locusta 1991), la Guerre du Kosovo (opération Allied Force 1999), la Guerre civile libyenne (opération Unified Protector 2011) et l''opération Prima Parthica (2015-2017) contre Daesh en Irak, le Tornado italien est retiré progressivement entre 2022 et 2025 au profit de l''Eurofighter Typhoon et du F-35.',
    'The Italian Tornado is the version operated by the Aeronautica Militare, produced by Aeritalia (future Leonardo) in partnership with BAE and MBB within the Panavia consortium. Italy, a 15% partner in the programme alongside the United Kingdom and Germany, received 100 Tornado IDS (Interdictor/Strike) from 1982, assigned to 6°, 36° and 50° Stormo at Ghedi, Gioia del Colle and Piacenza. Additionally, 16 IDS airframes were converted to Tornado ECR (Electronic Combat/Reconnaissance) for SEAD missions within the 155° Gruppo — a role giving Italy a unique European capability. The Mid-Life Update programme conducted between 2005 and 2019 integrated Storm Shadow missiles, GBU-24/GBU-49 bombs, the Link-16 datalink and the Litening III designator pod. Engaged during the Gulf War (Operation Locusta 1991), the Kosovo War (Operation Allied Force 1999), the Libyan Civil War (Operation Unified Protector 2011) and Operation Prima Parthica (2015-2017) against Daesh in Iraq, the Italian Tornado is being progressively retired between 2022 and 2025 in favour of the Eurofighter Typhoon and the F-35.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1968-07-01',
    '1974-08-14',
    '1982-08-01',
    2337.0,
    3890.0,
    (SELECT id FROM manufacturer WHERE code = 'LEO'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    13890.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM tech WHERE name = 'Radar de suivi de terrain')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM armement WHERE name = 'IRIS-T')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM armement WHERE name = 'GBU-16 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM armement WHERE name = 'GBU-49')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM armement WHERE name = 'Storm Shadow')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM armement WHERE name = 'Mk 83'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Italien'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 16.72, wingspan = 8.60, height = 5.95, wing_area = 26.6,
  empty_weight = 13890, mtow = 28000, service_ceiling = 15240, climb_rate = 77,
  combat_radius = 1390, crew = 2, g_limit_pos = 7.5, g_limit_neg = -3.0,
  engine_name = 'Turbo-Union RB199-34R Mk.103', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 43.8, thrust_wet = 73.5,
  production_start = 1979, production_end = 1998, units_built = 100,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Panavia_Tornado',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Panavia_Tornado'
WHERE name = 'Panavia Tornado Italien';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 35000000, unit_cost_year = 1988,
  manufacturer_page = 'https://www.leonardo.com/',
  variants    = E'- **Tornado IDS** : version interdiction/frappe, standard Aeronautica Militare\n- **Tornado ECR italien** : 16 cellules IDS converties pour SEAD + reconnaissance électronique, 155° Gruppo\n- **Tornado IT-ECR MLU** : upgrade 2013, GBU-49, Link-16, Litening III',
  variants_en = E'- **Tornado IDS** : interdiction/strike variant, Aeronautica Militare standard\n- **Italian Tornado ECR** : 16 IDS airframes converted for SEAD + electronic reconnaissance, 155° Gruppo\n- **Tornado IT-ECR MLU** : 2013 upgrade, GBU-49, Link-16, Litening III'
WHERE name = 'Panavia Tornado Italien';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nL''Italie rejoint en 1969 le programme **MRCA** (Multi-Role Combat Aircraft) aux côtés du Royaume-Uni, de l''Allemagne et initialement des Pays-Bas. Aeritalia prend 15 % du consortium **Panavia**, produit la partie arrière du fuselage et assemble les avions italiens à Turin-Caselle. Premier vol d''un Tornado italien : **1981**.\n\n## Carrière opérationnelle\n100 Tornado IDS livrés à partir de **1982**, plus 16 conversions ECR (seul opérateur européen hors Allemagne). Engagé en **Guerre du Golfe 1991** (opération Locusta, 8 appareils depuis la base saoudienne d''Al Dhafra — un abattu au dessus de l''Irak), **Kosovo 1999** (opération Allied Force, frappes SEAD ECR), **Libye 2011** (opération Unified Protector, premières frappes Storm Shadow italiennes), **Irak 2015-2017** (opération Prima Parthica contre Daesh).\n\n## Héritage\n**Principal chasseur-bombardier italien pendant 40 ans**. Retrait progressif 2022-2025 au profit de l''**Eurofighter Typhoon** (multirôle) et du **F-35A** (frappe stratégique). L''ECR italien reste une capacité SEAD unique difficile à remplacer — la succession s''appuie sur les Typhoon et les F-35B de la Marina, en attendant le programme GCAP (Global Combat Air Programme) de 6e génération.',
  description_en = E'## Genesis\nItaly joins the **MRCA** (Multi-Role Combat Aircraft) programme in 1969 alongside the UK, Germany and initially the Netherlands. Aeritalia takes 15% of the **Panavia** consortium, produces the rear fuselage and final-assembles Italian aircraft in Turin-Caselle. First Italian Tornado flight: **1981**.\n\n## Operational career\n100 Tornado IDS delivered from **1982**, plus 16 ECR conversions (only European operator besides Germany). Engaged in **Gulf War 1991** (Operation Locusta, 8 airframes from Al Dhafra in Saudi Arabia — one shot down over Iraq), **Kosovo 1999** (Operation Allied Force, ECR SEAD strikes), **Libya 2011** (Operation Unified Protector, first Italian Storm Shadow strikes), **Iraq 2015-2017** (Operation Prima Parthica against Daesh).\n\n## Legacy\n**Italy''s primary strike fighter for 40 years**. Progressive retirement 2022-2025 in favour of the **Eurofighter Typhoon** (multirole) and **F-35A** (strategic strike). The Italian ECR remains a unique SEAD capability difficult to replace — succession rests on Typhoons and Marina F-35Bs, pending the 6th-generation GCAP (Global Combat Air Programme).'
WHERE name = 'Panavia Tornado Italien';

-- [auto:011] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=hpBQZCqtMOk'
WHERE name = 'Panavia Tornado Italien';
