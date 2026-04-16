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
    'F-104 Starfighter Allemand',
    'German F-104 Starfighter',
    'Lockheed F-104G Starfighter (Luftwaffe)',
    'Lockheed F-104G Starfighter (Luftwaffe)',
    'Intercepteur supersonique de 2e génération surnommé le "Witwenmacher"',
    '2nd-generation supersonic interceptor nicknamed the "Widowmaker"',
    '/assets/airplanes/f104-allemand.jpg',
    'Le Lockheed F-104G Starfighter est la variante multirôle du célèbre intercepteur américain, produite sous licence en Allemagne de l''Ouest pour la Luftwaffe. Surnommé le « Witwenmacher » (faiseur de veuves) en raison de son taux d''accidents élevé — plus de 290 appareils perdus sur 916 livrés — le F-104G se distingue par ses ailes minuscules en lame de rasoir, son fuselage en forme de missile et ses performances supersoniques exceptionnelles à Mach 2. Conçu à l''origine par Clarence "Kelly" Johnson chez Lockheed comme un pur intercepteur de jour, la version G fut adaptée en chasseur-bombardier tout-temps capable d''emporter des armes nucléaires tactiques dans le cadre de la doctrine OTAN. Équipé du réacteur General Electric J79, d''un radar NASARR F15A et du canon M61 Vulcan, il constitua l''épine dorsale de la défense aérienne ouest-allemande pendant la Guerre froide. Malgré sa réputation controversée, le Starfighter permit à la Luftwaffe de se moderniser et de s''intégrer pleinement dans le dispositif de défense de l''Alliance atlantique. Il fut retiré du service allemand en 1987, remplacé par le Panavia Tornado.',
    'The Lockheed F-104G Starfighter is the multirole variant of the famous American interceptor, produced under license in West Germany for the Luftwaffe. Nicknamed the "Widowmaker" due to its high accident rate — more than 290 aircraft lost out of 916 delivered — the F-104G is distinguished by its tiny razor-blade wings, its missile-shaped fuselage and its exceptional supersonic performance at Mach 2. Originally designed by Clarence "Kelly" Johnson at Lockheed as a pure day interceptor, the G version was adapted into an all-weather fighter-bomber capable of carrying tactical nuclear weapons as part of NATO doctrine. Equipped with the General Electric J79 engine, a NASARR F15A radar and the M61 Vulcan cannon, it formed the backbone of West German air defense during the Cold War. Despite its controversial reputation, the Starfighter allowed the Luftwaffe to modernize and fully integrate into the Atlantic Alliance defense structure. It was retired from German service in 1987, replaced by the Panavia Tornado.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1952-01-01',
    '1960-10-05',
    '1961-06-01',
    2334.0,
    1740.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    NULL,
    6350.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM tech WHERE name = 'Radar AN/ASG-14')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM tech WHERE name = 'Siège incliné')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM armement WHERE name = 'AGM-12 Bullpup')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM armement WHERE name = 'B61')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM armement WHERE name = 'Mk 83')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 16.69, wingspan = 6.63, height = 4.11, wing_area = 18.22,
  empty_weight = 6390, mtow = 13170, service_ceiling = 17680, climb_rate = 254,
  combat_radius = 463, crew = 1, g_limit_pos = 7.33,
  engine_name = 'General Electric J79-MTU-J1K', engine_count = 1,
  engine_type = 'Turboréacteur avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 44.48, thrust_wet = 70.3,
  production_start = 1958, production_end = 1979, units_built = 2578,
  nickname = 'Starfighter',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Lockheed_F-104_Starfighter',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Lockheed_F-104_Starfighter'
WHERE name = 'F-104 Starfighter Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 1500000, unit_cost_year = 1960,
  operators_count = 1,
  variants    = E'- **F-104G** : version majoritaire Luftwaffe (915 ex. sur 2 578 produits)\n- **RF-104G** : reconnaissance\n- **TF-104G** : biplace d''entraînement',
  variants_en = E'- **F-104G** : Luftwaffe majority variant (915 of 2 578 built)\n- **RF-104G** : reconnaissance\n- **TF-104G** : two-seat trainer'
WHERE name = 'F-104 Starfighter Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nFourni massivement à la **Luftwaffe ouest-allemande** dans les années 1960 comme chasseur-bombardier tous temps. 915 exemplaires livrés — plus gros client export du F-104. Surnommé « **Witwenmacher** » (« faiseur de veuves ») après 292 accidents mortels.\n\n## Carrière opérationnelle\nPrincipal avion de la Luftwaffe pendant 25 ans. Capable de voler à Mach 2 avec un delta extrêmement fin, mais exigeant en pilotage, surtout en mission basse altitude. Porteur nucléaire tactique (bombes US B43/B61).\n\n## Héritage\nRetiré en 1987, remplacé par le F-4F et le Tornado. Symbole controversé de la remilitarisation allemande dans l''OTAN. Affecté la relation entre Lockheed et l''Allemagne.',
  description_en = E'## Genesis\nMassively supplied to the **West German Luftwaffe** in the 1960s as an all-weather fighter-bomber. 915 delivered — the F-104''s biggest export customer. Nicknamed "**Witwenmacher**" ("widow-maker") after 292 fatal accidents.\n\n## Operational career\nPrimary Luftwaffe aircraft for 25 years. Capable of Mach 2 with an extremely thin delta wing, but demanding to fly, especially on low-level missions. Tactical nuclear delivery (US B43/B61 bombs).\n\n## Legacy\nRetired in 1987, replaced by the F-4F and the Tornado. A controversial symbol of German rearmament within NATO. Strained the Lockheed-Germany relationship.'
WHERE name = 'F-104 Starfighter Allemand';
