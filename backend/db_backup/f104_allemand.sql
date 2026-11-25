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
    'Retired'
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
  description = E'## Genèse\nEn 1957, l''état-major de la jeune **Luftwaffe** veut un seul avion pour la chasse, l''attaque et la reconnaissance. **Walter Krupinski** compare le Starfighter au Grumman F11F et au Mirage III ; le ministre de la Défense **Franz Josef Strauss** pousse le choix du Lockheed, arrêté en octobre 1958, même si l''autonomie demandée n''est pas atteinte. Un avion américain offre aussi à la RFA un porteur pour les armes nucléaires de l''OTAN.\n\n## Conception\nLockheed répond par le F-104G, « Super Starfighter » renforcé, doté d''un radar d''attaque et d''un point d''emport ventral pour une « arme spéciale ». Il vole le 5 octobre 1960. Les consortiums ARGE Sud (Messerschmitt, Dornier, Heinkel) et ARGE Nord le construisent sous licence, sous la coordination du bureau OTAN de Coblence. La Bundeswehr reçoit 916 Starfighter : 30 F-104F, 586 F-104G, 163 RF-104G et 137 TF-104G.\n\n## Carrière opérationnelle\nPendant la **guerre froide**, le Starfighter sert partout : chasse (JG 71, JG 74), reconnaissance (AG 51, AG 52), attaque antinavire dans la Marine (MFG 1, MFG 2) et frappe, y compris nucléaire, de la JaboG 31, opérationnelle le 20 juin 1962, à la JaboG 36. Mais l''aile minuscule pardonne peu, surtout à basse altitude et par mauvais temps : selon les sources, 269 appareils sont détruits en vol ou 292 perdus au total, et 116 pilotes sont tués. Le public le surnomme « **Witwenmacher** », le faiseur de veuves.\n\nEn 1966, après une série noire, le ministre Kai-Uwe von Hassel limoge l''inspecteur de la Luftwaffe Werner Panitzki ; son successeur **Johannes Steinhoff** réorganise formation et maintenance, et les pertes reculent. La JaboG 34, dernière escadre de combat, rend ses F-104G en octobre 1987 pour le Tornado ; le dernier vol allemand a lieu le 22 mai 1991, au centre d''essais WTD 61.\n\n## Place dans l''histoire\nEn près de 2 millions d''heures de vol, le Starfighter a fait de la Luftwaffe une force de l''OTAN à part entière, au prix d''une crise politique durable. Les Phantom F-4F et RF-4E, puis le Tornado, l''ont remplacé ; les accusations de corruption révélées par le scandale Lockheed ont achevé d''en faire un symbole controversé.',
  description_en = E'## Genesis\nIn 1957 the staff of the young **Luftwaffe** wanted a single aircraft for fighter, strike and reconnaissance work. **Walter Krupinski** compared the Starfighter with the Grumman F11F and the Mirage III; Defence Minister **Franz Josef Strauss** pushed for the Lockheed, chosen in October 1958 even though it fell short of the range required. An American aircraft also gave West Germany a carrier for NATO''s nuclear weapons.\n\n## Design\nLockheed answered with the F-104G, a strengthened "Super Starfighter" with an attack radar and a centreline station for a "special store". It flew on 5 October 1960. The ARGE South (Messerschmitt, Dornier, Heinkel) and ARGE North consortia built it under licence, coordinated by a NATO office in Koblenz. The Bundeswehr received 916 Starfighters: 30 F-104Fs, 586 F-104Gs, 163 RF-104Gs and 137 TF-104Gs.\n\n## Operational career\nThroughout the **Cold War** the Starfighter did everything: air defence (JG 71, JG 74), reconnaissance (AG 51, AG 52), anti-ship strike with the Navy (MFG 1, MFG 2) and strike, including nuclear, from JaboG 31, operational on 20 June 1962, to JaboG 36. But its tiny wing was unforgiving, especially low and in bad weather: depending on the source, 269 aircraft crashed or 292 were lost in all, and 116 pilots were killed. The public called it the "**Witwenmacher**", the widowmaker.\n\nIn 1966, after a run of crashes, minister Kai-Uwe von Hassel dismissed the Luftwaffe''s chief, Werner Panitzki; his successor **Johannes Steinhoff** overhauled training and maintenance, and losses fell. JaboG 34, the last combat wing, gave up its F-104Gs in October 1987 for the Tornado; the last German flight took place on 22 May 1991 at the WTD 61 test centre.\n\n## Place in history\nOver nearly two million flight hours, the Starfighter turned the Luftwaffe into a full NATO force, at the cost of a lasting political crisis. F-4F and RF-4E Phantoms, then the Tornado, replaced it; the corruption allegations exposed by the Lockheed scandal sealed its controversial image.'
WHERE name = 'F-104 Starfighter Allemand';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-104 Starfighter Allemand';
