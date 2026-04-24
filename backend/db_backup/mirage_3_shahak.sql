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
    'Mirage IIICJ Shahak',
    'Mirage IIICJ Shahak',
    'Dassault Mirage IIICJ Shahak (Israeli Air Force)',
    'Dassault Mirage IIICJ Shahak (Israeli Air Force)',
    'Mirage III israélien, artisan de la victoire aérienne de la Guerre des Six Jours',
    'Israeli Mirage III, architect of the air victory in the Six-Day War',
    '/assets/airplanes/mirage-3cj-shahak.jpg',
    'Le Mirage IIICJ Shahak ("Ciel" en hébreu) est la version israélienne du Dassault Mirage III livrée en 1962 (72 exemplaires). Intercepteur-chasseur delta supersonique, il a été l''artisan principal de la suprématie aérienne israélienne lors de la Guerre des Six Jours (juin 1967), durant laquelle il a détruit plus de 450 avions arabes en 6 jours — l''une des campagnes aériennes les plus décisives de l''histoire. Egalement engagé lors de la Guerre d''usure (1967-1970) et au Kippour (1973). Retiré en 1982, remplacé par le Kfir et le F-15. Son retrait coïncide avec l''embargo français suivant la Guerre des Six Jours, motivant le développement des Nesher et Kfir nationaux.',
    'The Mirage IIICJ Shahak ("Sky" in Hebrew) is the Israeli version of the Dassault Mirage III delivered in 1962 (72 examples). Supersonic delta-wing interceptor-fighter, it was the main architect of Israeli air supremacy during the Six-Day War (June 1967), destroying over 450 Arab aircraft in 6 days — one of the most decisive air campaigns in history. Also engaged during the War of Attrition (1967-1970) and Yom Kippur (1973). Retired in 1982, replaced by the Kfir and F-15. Its retirement coincided with the French embargo following the Six-Day War, motivating the development of the domestic Nesher and Kfir.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1961-01-01',
    '1962-04-07',
    '1962-04-07',
    2350.0,
    2400.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired',
    7050.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM tech WHERE name = 'Radar Cyrano')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM armement WHERE name = 'Matra R530')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM armement WHERE name = 'Shafrir 2'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 15.03, wingspan = 8.22, height = 4.50, wing_area = 34.85,
  empty_weight = 7050, mtow = 13700, service_ceiling = 17000, climb_rate = 83,
  combat_radius = 1200, crew = 1, g_limit_pos = 7.0, g_limit_neg = -3.5,
  engine_name = 'SNECMA Atar 9B', engine_count = 1,
  engine_type = 'Turbojet avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 42.1, thrust_wet = 58.9,
  production_start = 1961, production_end = 1966, units_built = 72,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Dassault_Mirage_III',
  wikipedia_en = 'https://en.wikipedia.org/wiki/IAI_Nesher#Israeli_Mirage_IIICJ_Shahak'
WHERE name = 'Mirage IIICJ Shahak';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 1600000, unit_cost_year = 1962,
  manufacturer_page = 'https://www.dassault-aviation.com/',
  variants    = E'- **Mirage IIICJ Shahak** : version israélienne livrée en 1962-1964 (72 appareils)\n- Modifications locales IAF : missile **Shafrir 1/2** (indigène), radar Cyrano I, siège Martin-Baker Mk 6\n- Certains convertis en **Nesher** après 1971 (greffe moteur Atar 9C)\n- Retiré en 1982, remplacé par Kfir et F-15',
  variants_en = E'- **Mirage IIICJ Shahak** : Israeli version delivered 1962-1964 (72 aircraft)\n- Local IAF modifications: indigenous **Shafrir 1/2** missile, Cyrano I radar, Martin-Baker Mk 6 seat\n- Some converted to **Nesher** after 1971 (Atar 9C engine graft)\n- Retired in 1982, replaced by Kfir and F-15'
WHERE name = 'Mirage IIICJ Shahak';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nContrat signé entre Israël et Dassault en **1960** pour 72 Mirage IIICJ — premier chasseur supersonique livré à l''Armée de l''air israélienne. Livraison de mai **1962** à juillet 1964. Nom hébreu **Shahak** ("Ciel"). Première victoire aérienne : un MiG-21 syrien abattu le 14 juillet 1966 par Yair Neumann (la première victoire d''un Mirage IIICJ et d''un Mach 2 israélien).\n\n## Carrière opérationnelle\n**Artisan principal de l''annihilation aérienne arabe** lors de la **Guerre des Six Jours (5-10 juin 1967)** — opération Moked. En 190 minutes, les Shahaks détruisent ~300 avions égyptiens au sol. Total conflit : plus de **450 appareils arabes abattus**. Participation active à la **Guerre d''usure (1967-1970)** et à la **Guerre du Kippour (1973)** où 52 Shahaks sont perdus face aux défenses SAM soviétiques. Engagé en Liban en 1982.\n\n## Héritage\nL''**embargo français du 3 juin 1967** (De Gaulle) bloque la livraison de 50 Mirage 5 payés et déclenche le programme indigène **Nesher** (copie non autorisée Mirage 5) puis **Kfir** (Mirage 5 + J79). Mère de l''industrie aéronautique israélienne moderne. 13 Shahak survivants vendus au Chili (Mirage 50 Chile), 5 à l''Argentine.',
  description_en = E'## Genesis\nContract signed between Israel and Dassault in **1960** for 72 Mirage IIICJ — first supersonic fighter delivered to the Israeli Air Force. Delivery from May **1962** to July 1964. Hebrew name **Shahak** ("Sky"). First air victory: a Syrian MiG-21 shot down on 14 July 1966 by Yair Neumann (the first Mirage IIICJ victory and the first Israeli Mach 2).\n\n## Operational career\n**Main architect of Arab air annihilation** during the **Six-Day War (5-10 June 1967)** — Operation Moked. In 190 minutes, Shahaks destroy ~300 Egyptian aircraft on the ground. Total conflict: over **450 Arab aircraft shot down**. Active participation in the **War of Attrition (1967-1970)** and the **Yom Kippur War (1973)** where 52 Shahaks are lost facing Soviet SAM defences. Deployed in Lebanon in 1982.\n\n## Legacy\nThe **French embargo of 3 June 1967** (de Gaulle) blocks the delivery of 50 paid-for Mirage 5 and triggers the indigenous **Nesher** (unlicensed Mirage 5 copy) then **Kfir** (Mirage 5 + J79) programme. Mother of the modern Israeli aerospace industry. 13 surviving Shahaks sold to Chile (Mirage 50 Chile), 5 to Argentina.'
WHERE name = 'Mirage IIICJ Shahak';
