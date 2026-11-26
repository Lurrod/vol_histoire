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
    'Eurofighter Typhoon Allemand',
    'German Eurofighter Typhoon',
    'Eurofighter Typhoon (Luftwaffe)',
    'Eurofighter Typhoon (Luftwaffe)',
    'Chasseur multirôle européen de 4e génération au service de la Luftwaffe',
    'European 4th-generation multirole fighter in Luftwaffe service',
    '/assets/airplanes/eurofighter-allemand.jpg',
    'L''Eurofighter Typhoon allemand est la version exploitée par la Luftwaffe, assemblée par Airbus Defence and Space sur le site de Manching en Bavière. L''Allemagne, partenaire fondateur du programme aux côtés du Royaume-Uni, de l''Italie et de l''Espagne, a commandé 143 appareils répartis en quatre tranches successives. Conçu autour d''une configuration canard-delta instable et d''une commande de vol entièrement électrique, le Typhoon offre des performances exceptionnelles en combat aérien rapproché grâce à sa maniabilité et son rapport poussée/poids élevé. La Luftwaffe a progressivement fait évoluer ses Typhoon du rôle initial de supériorité aérienne vers une capacité multirôle complète, intégrant le radar CAPTOR-E à antenne active (AESA), le missile Meteor à longue portée et des armements air-sol comme le GBU-49 et le Taurus KEPD 350. L''appareil assure la police du ciel au-dessus de l''Allemagne et contribue régulièrement aux missions de police aérienne renforcée de l''OTAN dans les pays baltes et en Europe de l''Est. Le Typhoon constitue l''épine dorsale de la chasse allemande et restera en service au-delà de 2060 grâce au programme d''évolution Quadriga.',
    'The German Eurofighter Typhoon is the version operated by the Luftwaffe, assembled by Airbus Defence and Space at the Manching facility in Bavaria. Germany, a founding partner of the program alongside the United Kingdom, Italy and Spain, ordered 143 aircraft divided into four successive tranches. Designed around an unstable canard-delta configuration and a fully electric flight control system, the Typhoon offers exceptional performance in close air combat thanks to its maneuverability and high thrust-to-weight ratio. The Luftwaffe has gradually evolved its Typhoons from the initial air superiority role to a full multirole capability, integrating the CAPTOR-E active array radar (AESA), the long-range Meteor missile and air-to-ground armaments such as the GBU-49 and Taurus KEPD 350. The aircraft provides air policing over Germany and regularly contributes to NATO enhanced air policing missions in the Baltic states and Eastern Europe. The Typhoon is the backbone of German fighter aviation and will remain in service beyond 2060 thanks to the Quadriga evolution program.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1983-01-01',
    '1994-03-27',
    '2004-08-04',
    2495.0,
    2900.0,
    (SELECT id FROM manufacturer WHERE code = 'ADS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Radar CAPTOR')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'IRIS-T')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'GBU-49')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 15.96, wingspan = 10.95, height = 5.28, wing_area = 50.0,
  empty_weight = 11000, mtow = 23500, service_ceiling = 19810, climb_rate = 315,
  combat_radius = 1389, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'Eurojet EJ200', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 60.0, thrust_wet = 90.0,
  production_start = 1994, production_end = NULL, units_built = 594,
  operators_count = 10,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Eurofighter_Typhoon',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Eurofighter_Typhoon'
WHERE name = 'Eurofighter Typhoon Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 100000000, unit_cost_year = 2013,
  manufacturer_page = 'https://www.eurofighter.com/',
  variants    = E'- **Tranche 1** : configuration initiale, air-air limitée\n- **Tranche 2** : intégration ciblage air-sol\n- **Tranche 3/3A** : radar AESA Captor-E, nouvelles liaisons de données\n- **Tranche 4** : dernière tranche en production (commandes 2020+)',
  variants_en = E'- **Tranche 1** : initial configuration, limited air-to-air\n- **Tranche 2** : air-to-ground integration\n- **Tranche 3/3A** : Captor-E AESA radar, new datalinks\n- **Tranche 4** : latest production tranche (2020+ orders)'
WHERE name = 'Eurofighter Typhoon Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nL''Allemagne est l''un des quatre piliers du programme **European Fighter Aircraft**, avec le Royaume-Uni, l''Italie et l''Espagne. Au milieu des années 1980, Bonn prévoit 250 appareils ; la fin de la guerre froide pousse le ministre **Volker Rühe** à proposer en 1992 de descendre à 140, et le contrat de production de 1997 fixe la part allemande à 180. Le premier Typhoon de série est présenté le 13 juin 2003 et réceptionné par la Bundeswehr le 4 août suivant.\n\n## Conception\nAssemblé par **Airbus Defence and Space** à Manching, le Typhoon allemand est un canard-delta instable à commandes de vol électriques, poussé par deux **EJ200**. Il est commandé par tranches : 44 appareils en 1998, 68 en 2004, 31 en 2009 ; les 37 de la Tranche 3B sont abandonnés en 2011. Le contrat **Quadriga**, signé le 11 novembre 2020, ajoute 38 avions neufs de Tranche 4 dotés du radar à antenne active **Captor-E**, et 20 appareils de Tranche 5 sont approuvés le 8 octobre 2025. Le missile **Meteor** équipe la flotte depuis avril 2021, et une version de guerre électronique doit relever le Tornado ECR vers 2030.\n\n## Carrière opérationnelle\nL''entrée officielle en service a lieu le 30 avril 2004 au **JG 73 « Steinhoff »** de Laage. Suivent Neuburg en 2006, Nörvenich en 2009 et Wittmund en 2013 ; Neuburg et Wittmund tiennent l''alerte de défense aérienne du sud et du nord du pays. La Luftwaffe ne l''a jamais engagé au combat : l''Allemagne s''est abstenue lors du vote sur l''intervention en Libye en 2011. Son terrain est la police du ciel alliée. Après les F-4F Phantom à partir de 2005, des Eurofighter assurent dès 2009 la **police aérienne balte** ; depuis l''annexion de la Crimée en 2014, des détachements allemands se relaient à Ämari, en Estonie. Depuis 2021, d''autres rotations protègent la Roumanie, le long de la frontière ukrainienne, à Mihail Kogălniceanu ; en 2024, des Typhoon allemands traversent le monde jusqu''au Japon pour l''exercice *Pacific Skies*.\n\n## Place dans l''histoire\nÉpine dorsale de la chasse allemande, le Typhoon doit rester en service au-delà de 2055 grâce au programme d''évolution à long terme, financé en décembre 2024.',
  description_en = E'## Genesis\nGermany was one of the four pillars of the **European Fighter Aircraft** programme, alongside the United Kingdom, Italy and Spain. In the mid-1980s Bonn planned on 250 aircraft; the end of the Cold War led defence minister **Volker Rühe** to propose cutting this to 140 in 1992, and the 1997 production contract set the German share at 180. The first production Typhoon was unveiled on 13 June 2003 and accepted by the Bundeswehr on 4 August that year.\n\n## Design\nAssembled by **Airbus Defence and Space** at Manching, the German Typhoon is an unstable canard-delta with fly-by-wire controls, powered by two **EJ200** engines. It was ordered in tranches: 44 aircraft in 1998, 68 in 2004, 31 in 2009, while the 37 Tranche 3B aircraft were dropped in 2011. The **Quadriga** contract, signed on 11 November 2020, added 38 new Tranche 4 aircraft with the **Captor-E** active array radar, and 20 Tranche 5 aircraft were approved on 8 October 2025. The **Meteor** missile has armed the fleet since April 2021, and an electronic warfare version is to replace the Tornado ECR around 2030.\n\n## Operational career\nThe type officially entered service on 30 April 2004 with **JG 73 "Steinhoff"** at Laage, followed by Neuburg in 2006, Nörvenich in 2009 and Wittmund in 2013; Neuburg and Wittmund hold the quick reaction alert for southern and northern Germany. The Luftwaffe has never taken it into combat: Germany abstained in the 2011 vote on intervention in Libya. Its field is allied air policing. After F-4F Phantoms from 2005, Eurofighters took over **Baltic Air Policing** duties in 2009, and since the annexation of Crimea in 2014 German detachments have rotated through Ämari in Estonia. Since 2021 further rotations have protected Romania along the Ukrainian border from Mihail Kogălniceanu, and in 2024 German Typhoons flew as far as Japan for exercise *Pacific Skies*.\n\n## Place in history\nThe backbone of German fighter aviation, the Typhoon is due to remain in service beyond 2055 thanks to the Long Term Evolution programme, funded in December 2024.'
WHERE name = 'Eurofighter Typhoon Allemand';

-- [auto:011] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=4F-7EbzuUNY'
WHERE name = 'Eurofighter Typhoon Allemand';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'Eurofighter Typhoon Allemand';
