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
    'Alpha Jet Allemand',
    'German Alpha Jet',
    'Dassault/Dornier Alpha Jet A (Luftwaffe)',
    'Dassault/Dornier Alpha Jet A (Luftwaffe)',
    'Avion d''appui aérien léger et d''entraînement avancé franco-allemand',
    'Franco-German light ground attack and advanced trainer aircraft',
    '/assets/airplanes/alpha-jet-allemand.jpg',
    'L''Alpha Jet A est la variante allemande de l''avion d''entraînement et d''appui tactique développé conjointement par Dassault-Breguet en France et Dornier en Allemagne. Contrairement à la version française destinée principalement à l''entraînement avancé, la Luftwaffe configura ses Alpha Jet A pour un rôle d''appui aérien rapproché et d''attaque légère en première ligne face aux forces du Pacte de Varsovie. L''Allemagne de l''Ouest commanda 175 appareils, assemblés sur le site Dornier de Oberpfaffenhofen en Bavière, qui entrèrent en service à partir de 1979. Équipé de deux réacteurs SNECMA/Turbomeca Larzac 04, d''un système de navigation et d''attaque intégré avec calculateur balistique, et d''un canon Mauser BK-27 en pod ventral, l''Alpha Jet A pouvait emporter une charge offensive variée incluant bombes, roquettes et missiles. Déployé au sein des escadrons d''appui tactique léger (Leichte Kampfgeschwader), il devait assurer des frappes à basse altitude sur les colonnes blindées soviétiques en cas de conflit en Europe centrale. Avec la fin de la Guerre froide et la réduction des forces armées allemandes, la mission d''attaque au sol devint obsolète. Les Alpha Jet furent progressivement reconvertis en avions d''entraînement avancé avant d''être retirés du service de la Luftwaffe en 1993. De nombreux exemplaires furent exportés ou cédés à des pays alliés, notamment le Portugal et la Thaïlande.',
    'The Alpha Jet A is the German variant of the training and tactical support aircraft jointly developed by Dassault-Breguet in France and Dornier in Germany. Unlike the French version intended primarily for advanced training, the Luftwaffe configured its Alpha Jet A for a close air support and light attack role on the front line against Warsaw Pact forces. West Germany ordered 175 aircraft, assembled at the Dornier facility in Oberpfaffenhofen, Bavaria, entering service from 1979. Equipped with two SNECMA/Turbomeca Larzac 04 engines, an integrated navigation and attack system with ballistic computer, and a ventral Mauser BK-27 cannon pod, the Alpha Jet A could carry a varied offensive load including bombs, rockets and missiles. Deployed within the Light Tactical Attack Wings (Leichte Kampfgeschwader), it was to carry out low-altitude strikes on Soviet armored columns in case of conflict in Central Europe. With the end of the Cold War and the reduction of German armed forces, the ground attack mission became obsolete. The Alpha Jets were gradually converted to advanced trainers before being retired from Luftwaffe service in 1993. Many examples were exported or transferred to allied nations, notably Portugal and Thailand.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1969-01-01',
    '1973-10-26',
    '1979-03-01',
    1000.0,
    2780.0,
    (SELECT id FROM manufacturer WHERE code = 'ADS'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    NULL,
    3515.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur Larzac 04')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM armement WHERE name = 'BL755'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 11.75, wingspan = 9.11, height = 4.19, wing_area = 17.5,
  empty_weight = 3345, mtow = 8000, service_ceiling = 14000, climb_rate = 57,
  combat_radius = 583, crew = 2, g_limit_pos = 7.3,
  engine_name = 'SNECMA / Turbomeca Larzac 04', engine_count = 2,
  engine_type = 'Turbofan', engine_type_en = 'Turbofan',
  thrust_dry = 13.24,
  production_start = 1973, production_end = 1991, units_built = 480,
  operators_count = 12,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Alpha_Jet',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Dassault/Dornier_Alpha_Jet'
WHERE name = 'Alpha Jet Allemand';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 6000000, unit_cost_year = 1975,
  variants    = E'- **Alpha Jet A** : version attaque Luftwaffe (retirée 1997)\n- **Alpha Jet E** : version entraînement Armée de l''air française\n- **Alpha Jet MS1/MS2** : export Égypte\n- **Alpha Jet NGEA** : modernisation radar APX-R',
  variants_en = E'- **Alpha Jet A** : Luftwaffe attack variant (retired 1997)\n- **Alpha Jet E** : French Air Force trainer\n- **Alpha Jet MS1/MS2** : Egyptian export\n- **Alpha Jet NGEA** : APX-R radar upgrade'
WHERE name = 'Alpha Jet Allemand';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nProgramme franco-allemand **Dassault/Dornier** des années 1970 pour créer un avion d''entraînement avancé et d''attaque tactique, concurrent de l''italien Aermacchi MB-339.\n\n## Carrière opérationnelle\nExporté dans **12 pays** (France, Belgique, Cameroun, Égypte, Qatar, Côte d''Ivoire, Nigeria, Maroc, Togo, Thaïlande, Portugal). Utilisé par l''Armée de l''air française pour l''école de chasse (Cazaux, Tours) et la Patrouille de France.\n\n## Héritage\nAvion officiel de la **Patrouille de France** depuis 1980. Retrait progressif prévu à partir de 2026-2028. Son élégance et sa fiabilité en ont fait un classique européen.',
  description_en = E'## Genesis\nFranco-German **Dassault/Dornier** programme of the 1970s to create an advanced trainer and tactical attack aircraft, competing with the Italian Aermacchi MB-339.\n\n## Operational career\nExported to **12 countries** (France, Belgium, Cameroon, Egypt, Qatar, Ivory Coast, Nigeria, Morocco, Togo, Thailand, Portugal). Used by the French Air Force at the fighter school (Cazaux, Tours) and by the Patrouille de France aerobatic team.\n\n## Legacy\nOfficial aircraft of the **Patrouille de France** since 1980. Progressive retirement planned from 2026-2028. Its elegance and reliability made it a European classic.'
WHERE name = 'Alpha Jet Allemand';
