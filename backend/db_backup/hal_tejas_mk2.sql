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
    'HAL Tejas Mk2',
    'HAL Tejas Mk2',
    'HAL Tejas Mk2 MWF (Indian Air Force)',
    'HAL Tejas Mk2 MWF (Indian Air Force)',
    'Chasseur multirôle indien de catégorie medium, dérivé amplifié du Tejas',
    'Indian medium-weight multirole fighter, enlarged derivative of the Tejas',
    '/assets/airplanes/hal-tejas-mk2.jpg',
    'Le HAL Tejas Mk2 (Medium Weight Fighter — MWF) est une évolution profonde du Tejas, passant dans la catégorie des 17,5 tonnes au décollage maximal. Dotée d''un fuselage rallongé, de canards delta, d''un réacteur GE F414-INS6 (98 kN) et d''une capacité d''emport de 6500 kg sur 13 points, cette plateforme vise à remplacer les Mirage 2000, MiG-29 et Jaguar de l''Indian Air Force. Premier vol prévu en 2026, service opérationnel en 2030. Radar Uttam AESA indigène, suite EW intégrée, Meteor et BrahMos-NG compatibles.',
    'The HAL Tejas Mk2 (Medium Weight Fighter — MWF) is a deep evolution of the Tejas, moving into the 17.5-tonne maximum take-off weight class. With a stretched fuselage, delta canards, a GE F414-INS6 engine (98 kN) and a 6500 kg payload across 13 hardpoints, this platform aims to replace the Indian Air Force''s Mirage 2000, MiG-29 and Jaguar. First flight scheduled for 2026, operational service in 2030. Indigenous Uttam AESA radar, integrated EW suite, Meteor and BrahMos-NG compatible.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '2009-01-01',
    NULL,
    NULL,
    2385.0,
    3500.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En développement',
    'In development'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'Derby')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'Python 5')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'SCALP EG')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'Astra Mk1')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM armement WHERE name = 'BrahMos-A'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 14.65, wingspan = 8.50, height = 4.80, wing_area = 43.00,
  empty_weight = 7850, mtow = 17500, service_ceiling = 17000, climb_rate = 65,
  combat_radius = 1500, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.5,
  engine_name = 'General Electric F414-INS6', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 62.3, thrust_wet = 98.0,
  production_start = NULL, production_end = NULL, units_built = 0,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_Tejas_Mark_2',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_Tejas_Mk2'
WHERE name = 'HAL Tejas Mk2';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 72000000, unit_cost_year = 2025,
  manufacturer_page = 'https://hal-india.co.in/',
  variants    = E'- **MWF (Medium Weight Fighter)** : version de production monoplace\n- 13 pylônes, 6500 kg de charge utile, canards delta, radar Uttam AESA indigène\n- Compatible Astra Mk1/Mk2, Meteor, SCALP, BrahMos-NG, Rudram-1\n- 6 escadrons prévus (~108 appareils) pour remplacer Mirage 2000, MiG-29, Jaguar',
  variants_en = E'- **MWF (Medium Weight Fighter)** : single-seat production version\n- 13 pylons, 6,500 kg payload, delta canards, indigenous Uttam AESA radar\n- Compatible with Astra Mk1/Mk2, Meteor, SCALP, BrahMos-NG, Rudram-1\n- 6 squadrons planned (~108 aircraft) to replace Mirage 2000, MiG-29, Jaguar'
WHERE name = 'HAL Tejas Mk2';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nLe Tejas Mk2 naît en novembre 2009, quand l''Inde autorise une troisième phase du programme d''avion de combat léger. Il ne devait être qu''un Tejas allongé par un tronçon de fuselage ; les exigences successives de l''armée de l''air en font un appareil nouveau, un chasseur de catégorie moyenne de 17,5 tonnes dévoilé au salon **Aero India** de 2019. Le Comité du Cabinet pour la sécurité approuve son développement fin août 2022 : 6 500 crore de roupies de crédits nouveaux, s''ajoutant à 2 500 crore déjà engagés, soit environ 9 000 crore au total, et jusqu''à 10 000 crore selon d''autres sources.\n\n## Conception\nLong de 14,65 mètres, le Mk2 garde l''aile delta sans empennage horizontal du Tejas, mais l''associe à des plans canard rapprochés et à des commandes de vol électriques. Il reçoit un **General Electric F414-INS6** de 98 kN avec postcombustion, retenu dès octobre 2010 ; **HAL** et GE ont signé en juin 2023 un protocole pour le produire en Inde. Treize points d''emport portent jusqu''à 6 500 kg de charge, et l''électronique est largement nationale : radar à antenne active **Uttam**, capteur infrarouge de veille, suite de guerre électronique intégrée. La part indienne doit passer de 82 % à plus de 90 % avec la fabrication locale du réacteur. L''armée de l''air vise d''abord six escadrons, soit 110 à 120 avions selon un rapport de 2022, puis dix escadrons au total, pour relever les **Jaguar**, **Mirage 2000** et **MiG-29**.\n\n## Essais\nLe calendrier glisse sans cesse : sortie d''usine annoncée pour 2022, premier vol pour 2023, puis avant octobre 2025. Des annonces contradictoires ont ensuite évoqué une sortie du prototype début 2026. En septembre 2026, la cellule est déclarée terminée ; les premiers essais moteur au sol sont visés pour mars 2027 et le premier vol, selon le secrétaire indien à la Défense, pour le milieu de 2027.\n\n## Place dans l''histoire\nPont entre le Tejas Mk1A et le chasseur furtif **AMCA**, le Mk2 doit montrer que l''industrie indienne sait passer du chasseur léger au chasseur moyen. Il n''a pas encore volé.',
  description_en = E'## Genesis\nThe Tejas Mk2 was born in November 2009, when India authorised a third phase of the Light Combat Aircraft programme. It was meant to be no more than a Tejas stretched by a fuselage plug; the air force''s growing requirements turned it into a new aircraft, a 17.5-tonne medium-weight fighter unveiled at **Aero India** 2019. The Cabinet Committee on Security approved its development at the end of August 2022: 6,500 crore rupees of new money on top of 2,500 crore already committed, about 9,000 crore in all, and up to 10,000 crore according to other sources.\n\n## Design\nAt 14.65 metres long, the Mk2 keeps the Tejas''s tailless delta wing but pairs it with close-coupled canards and fly-by-wire controls. It is powered by a **General Electric F414-INS6** rated at 98 kN with afterburner, chosen as early as October 2010; **HAL** and GE signed a memorandum in June 2023 to build it in India. Thirteen hardpoints carry up to 6,500 kg, and the avionics are largely Indian: the **Uttam** active array radar, an infrared search and track sensor and an integrated electronic warfare suite. Indian content is to rise from 82% to over 90% once the engine is built locally. The air force first wants six squadrons, 110 to 120 aircraft according to a 2022 report, then ten squadrons in all, to replace the **Jaguar**, **Mirage 2000** and **MiG-29**.\n\n## Testing\nThe schedule has kept slipping: rollout was announced for 2022, first flight for 2023, then for before October 2025. Contradictory reports later spoke of a prototype rollout in early 2026. In September 2026 the airframe was declared complete; the first engine ground runs are targeted for March 2027 and the first flight, according to India''s Defence Secretary, for mid-2027.\n\n## Place in history\nA bridge between the Tejas Mk1A and the stealthy **AMCA**, the Mk2 is meant to show that Indian industry can move from light to medium fighters. It has yet to fly.'
WHERE name = 'HAL Tejas Mk2';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'HAL Tejas Mk2';
