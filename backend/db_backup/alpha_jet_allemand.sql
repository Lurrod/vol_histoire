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
    'https://i.postimg.cc/fb4G2K3N/alpha-jet-allemand.jpg',
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