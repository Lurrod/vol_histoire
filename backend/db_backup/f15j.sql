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
    'Mitsubishi F-15J',
    'Mitsubishi F-15J',
    'Mitsubishi F-15J Eagle (Japan Air Self-Defense Force)',
    'Mitsubishi F-15J Eagle (Japan Air Self-Defense Force)',
    'Version japonaise du F-15C Eagle, construite sous licence par Mitsubishi',
    'Japanese version of the F-15C Eagle, licence-built by Mitsubishi',
    '/assets/airplanes/mitsubishi-f15j.jpg',
    'Le Mitsubishi F-15J est la version japonaise du McDonnell Douglas F-15C Eagle construite sous licence par Mitsubishi entre 1981 et 1999 (213 appareils). Épine dorsale de la supériorité aérienne nippone, stationné sur l''ensemble de l''archipel face à la Russie, la Chine et la Corée du Nord. Modernisé au standard MSIP II (AN/APG-63(V)1 AESA, AIM-120 AMRAAM, IRST) puis JSI (Japanese Super Interceptor — AN/APG-82(V)1, EPAWSS, intégration AIM-260) à partir de 2020 sur 98 appareils, prévu en service jusqu''en 2045+.',
    'The Mitsubishi F-15J is the Japanese version of the McDonnell Douglas F-15C Eagle licence-built by Mitsubishi between 1981 and 1999 (213 aircraft). Backbone of Japanese air superiority, based across the entire archipelago facing Russia, China and North Korea. Upgraded to the MSIP II standard (AN/APG-63(V)1 AESA, AIM-120 AMRAAM, IRST) then JSI (Japanese Super Interceptor — AN/APG-82(V)1, EPAWSS, AIM-260 integration) from 2020 on 98 aircraft, expected in service until 2045+.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1978-01-01',
    '1981-06-04',
    '1981-12-01',
    2655.0,
    3500.0,
    (SELECT id FROM manufacturer WHERE code = 'MHI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Actif',
    'Active',
    12700.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-63')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM armement WHERE name = 'JM61A1')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM armement WHERE name = 'AAM-3')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM armement WHERE name = 'AAM-4')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM armement WHERE name = 'AAM-5'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 19.43, wingspan = 13.05, height = 5.63, wing_area = 56.50,
  empty_weight = 12700, mtow = 30845, service_ceiling = 20000, climb_rate = 315,
  combat_radius = 1967, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'IHI F100-IHI-100 / -220 (licence Pratt & Whitney F100)', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 65.3, thrust_wet = 105.7,
  production_start = 1981, production_end = 1999, units_built = 213,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_F-15_Eagle',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mitsubishi_F-15J'
WHERE name = 'Mitsubishi F-15J';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 100000000, unit_cost_year = 1985,
  manufacturer_page = 'https://www.mhi.com/',
  variants    = E'- **F-15J** : monoplace construit sous licence Mitsubishi (139 appareils, 1981-1999)\n- **F-15DJ** : biplace d''entraînement (48 appareils)\n- **F-15J MSIP II** : upgrade radar APG-63(V)1 AESA, AIM-120 AMRAAM, IRST (1997-2010, ~90 appareils)\n- **F-15JSI (Japanese Super Interceptor)** : upgrade ultime — radar APG-82(V)1, EPAWSS, intégration AIM-260 JATM (98 appareils, 2020-2030)\n- 7 escadrons opérationnels + 1 escadron d''entraînement',
  variants_en = E'- **F-15J** : licence-built single-seat by Mitsubishi (139 aircraft, 1981-1999)\n- **F-15DJ** : two-seat trainer (48 aircraft)\n- **F-15J MSIP II** : APG-63(V)1 AESA radar, AIM-120 AMRAAM, IRST upgrade (1997-2010, ~90 aircraft)\n- **F-15JSI (Japanese Super Interceptor)** : ultimate upgrade — APG-82(V)1 radar, EPAWSS, AIM-260 JATM integration (98 aircraft, 2020-2030)\n- 7 operational squadrons + 1 training squadron'
WHERE name = 'Mitsubishi F-15J';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nContrat de licence signé entre McDonnell Douglas et Mitsubishi en **1978**. 187 F-15J + 32 F-15DJ produits au Japon (213 total). Premier vol d''un F-15J assemblé à Komaki le **4 juin 1981**. Les premiers exemplaires livrés directement par St. Louis. L''F-15J intègre dès l''origine les **missiles japonais AAM-3** (dérivé national de l''AIM-9L) et ses variantes successives.\n\n## Carrière opérationnelle\n**Épine dorsale de la supériorité aérienne japonaise** depuis 40 ans. Basé dans l''ensemble de l''archipel face à la Russie (Chitose, Hyakuri), la Chine (Naha, Tsuiki) et la Corée du Nord (Misawa). Record mondial d''interceptions actives — 1 000+ sorties/an face aux intrusions chinoises et russes depuis 2010.\n\n## Héritage\nUpgrade **JSI (Japanese Super Interceptor)** en cours jusqu''en 2035 pour 98 appareils — radar APG-82(V)1, EPAWSS, AIM-260 JATM, intégration capacité de frappe stand-off AGM-158 JASSM-ER. Le F-15J restera l''arme principale de supériorité aérienne de la JASDF jusqu''aux années 2045, en complément du F-35A et du futur F-X (GCAP avec UK et Italie).',
  description_en = E'## Genesis\nLicence contract signed between McDonnell Douglas and Mitsubishi in **1978**. 187 F-15J + 32 F-15DJ produced in Japan (213 total). First flight of a Komaki-assembled F-15J on **4 June 1981**. The first examples delivered directly from St. Louis. The F-15J integrates from the outset **Japanese AAM-3 missiles** (national derivative of the AIM-9L) and its successive variants.\n\n## Operational career\n**Backbone of Japanese air superiority** for 40 years. Based across the archipelago facing Russia (Chitose, Hyakuri), China (Naha, Tsuiki) and North Korea (Misawa). World record of active interceptions — 1,000+ sorties/year against Chinese and Russian intrusions since 2010.\n\n## Legacy\n**JSI (Japanese Super Interceptor)** upgrade in progress until 2035 for 98 aircraft — APG-82(V)1 radar, EPAWSS, AIM-260 JATM, AGM-158 JASSM-ER stand-off strike integration. The F-15J will remain the main JASDF air superiority weapon until the 2045s, complementing the F-35A and the future F-X (GCAP with UK and Italy).'
WHERE name = 'Mitsubishi F-15J';
