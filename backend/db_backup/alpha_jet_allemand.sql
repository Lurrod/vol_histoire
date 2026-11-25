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
    'Retired'
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
  description = E'## Genèse\nÀ la fin des années 1960, la Luftwaffe cherche à remplacer ses **Fiat G.91R** d''appui léger, quand la France veut un avion d''école. En juillet 1969, Bonn et Paris signent un accord de développement commun, et le projet TA501 de **Breguet**, **Dassault** et **Dornier** l''emporte le 23 juillet 1970. Échaudés par les pertes du F-104 Starfighter, un monoréacteur, les Allemands imposent deux moteurs. D''une même cellule naissent deux avions : l''école pour la France, l''appui rapproché pour l''Allemagne.\n\n## Conception\nL''Alpha Jet A se reconnaît à son nez effilé. Il emporte sous le fuselage une nacelle canon **Mauser BK-27** de 27 mm, un système de navigation et d''attaque plus complet avec radar Doppler, des points d''emport supplémentaires et des sièges éjectables Stencel. Le premier exemplaire de série allemand vole le 12 avril 1978 ; les livraisons commencent en mars 1979 et la Luftwaffe en reçoit 175 jusqu''en 1983.\n\n## Carrière opérationnelle\nPendant la **guerre froide**, de 1980 au début des années 1990, les Alpha Jet arment trois escadres de chasseurs-bombardiers : le **JaboG 49** à Fürstenfeldbruck dès 1980, le **JaboG 43** à Oldenburg à partir de 1981 et le **JaboG 41** à Husum, qui reçoit son premier appareil le 4 janvier 1982. Leur mission : l''appui rapproché à très basse altitude face à une percée blindée du pacte de Varsovie. Le tir s''entraîne à Beja, au Portugal. Un programme d''amélioration lancé en 1985 est abandonné en 1988 au profit d''une mise à niveau plus modeste, qui ajoute l''**AIM-9L Sidewinder**. En 1991, pendant la **guerre du Golfe**, dix-huit Alpha Jet du JaboG 43 sont déployés en Turquie pour couvrir l''allié de l''OTAN.\n\n## Place dans l''histoire\nLa fin de la guerre froide rend la mission caduque. Le retrait commence en 1992 ; le JaboG 41 est dissous le 31 mars 1993, le JaboG 43 le 30 septembre 1993, le JaboG 49 le 31 mars 1994, et le dernier Alpha Jet allemand quitte le service en 1998. La flotte fait alors carrière ailleurs : cinquante appareils au Portugal, environ vingt-cinq en Thaïlande en 1999, douze au centre d''essais britannique DERA, d''autres chez des collectionneurs comme les Flying Bulls autrichiens.',
  description_en = E'## Genesis\nIn the late 1960s the Luftwaffe needed to replace its **Fiat G.91R** light attack aircraft, while France wanted a jet trainer. In July 1969 Bonn and Paris signed a joint development agreement, and the TA501 design from **Breguet**, **Dassault** and **Dornier** was selected on 23 July 1970. Stung by its losses of single-engined F-104 Starfighters, Germany insisted on two engines. One airframe gave rise to two aircraft: a trainer for France, a close air support jet for Germany.\n\n## Design\nThe Alpha Jet A is recognisable by its pointed nose. It carries a **Mauser BK-27** 27 mm cannon pod under the fuselage, a more extensive navigation and attack system with Doppler radar, extra hardpoints and Stencel ejection seats. The first German production aircraft flew on 12 April 1978; deliveries began in March 1979, and the Luftwaffe had received 175 by 1983.\n\n## Operational career\nDuring the **Cold War**, from 1980 to the early 1990s, the Alpha Jet equipped three fighter-bomber wings: **JaboG 49** at Fürstenfeldbruck from 1980, **JaboG 43** at Oldenburg from 1981 and **JaboG 41** at Husum, which received its first aircraft on 4 January 1982. Their task was low-level close air support against a Warsaw Pact armoured thrust. Weapons training took place at Beja in Portugal. An improvement programme launched in 1985 was cancelled in 1988 in favour of a more modest upgrade that added the **AIM-9L Sidewinder**. In 1991, during the **Gulf War**, eighteen JaboG 43 Alpha Jets were deployed to Turkey to protect the NATO ally.\n\n## Place in history\nThe end of the Cold War made the mission obsolete. Withdrawal began in 1992; JaboG 41 was disbanded on 31 March 1993, JaboG 43 on 30 September 1993 and JaboG 49 on 31 March 1994, and the last German Alpha Jet left service in 1998. The fleet then found new careers: fifty aircraft went to Portugal, about twenty-five to Thailand in 1999, twelve to the British test establishment DERA, and others to private owners such as Austria''s Flying Bulls.'
WHERE name = 'Alpha Jet Allemand';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Alpha Jet Allemand';
