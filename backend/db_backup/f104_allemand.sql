-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'F-104 Starfighter Allemand', 'Lockheed F-104G Starfighter (Luftwaffe)', 'Intercepteur supersonique de 2e génération surnommé le "Witwenmacher"', 
    'https://i.postimg.cc/s2Fk6cBC/f104-allemand.jpg', 
    'Le Lockheed F-104G Starfighter est la variante multirôle du célèbre intercepteur américain, produite sous licence en Allemagne de l''Ouest pour la Luftwaffe. Surnommé le « Witwenmacher » (faiseur de veuves) en raison de son taux d''accidents élevé — plus de 290 appareils perdus sur 916 livrés — le F-104G se distingue par ses ailes minuscules en lame de rasoir, son fuselage en forme de missile et ses performances supersoniques exceptionnelles à Mach 2. Conçu à l''origine par Clarence "Kelly" Johnson chez Lockheed comme un pur intercepteur de jour, la version G fut adaptée en chasseur-bombardier tout-temps capable d''emporter des armes nucléaires tactiques dans le cadre de la doctrine OTAN. Équipé du réacteur General Electric J79, d''un radar NASARR F15A et du canon M61 Vulcan, il constitua l''épine dorsale de la défense aérienne ouest-allemande pendant la Guerre froide. Malgré sa réputation controversée, le Starfighter permit à la Luftwaffe de se moderniser et de s''intégrer pleinement dans le dispositif de défense de l''Alliance atlantique. Il fut retiré du service allemand en 1987, remplacé par le Panavia Tornado.', 
    (SELECT id FROM countries WHERE code = 'DEU'), '1952-01-01', '1960-10-05', '1961-06-01', 
    2334.0, 1740.0, (SELECT id FROM manufacturer WHERE code = 'LM'), 
    (SELECT id FROM generation WHERE generation = 2), (SELECT id FROM type WHERE name = 'Intercepteur'), 
    'Retiré', 6350.0
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