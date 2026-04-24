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
    'Jaguar IS',
    'Jaguar IS',
    'SEPECAT Jaguar IS/IM DARIN III (Indian Air Force)',
    'SEPECAT Jaguar IS/IM DARIN III (Indian Air Force)',
    'Version indienne du SEPECAT Jaguar, avion d''attaque au sol biplace',
    'Indian variant of the SEPECAT Jaguar, two-seat ground attack aircraft',
    '/assets/airplanes/sepecat-jaguar-is.jpg',
    'Le Jaguar IS (Indian Strike) est la version indienne du SEPECAT Jaguar fabriquée sous licence par HAL à partir de 1981 (161 appareils). Pierre angulaire de la frappe conventionnelle à basse altitude de l''IAF, il a été successivement modernisé aux standards DARIN (Display Attack Ranging Inertial Navigation) I, II et III, ce dernier introduisant un radar EL/M-2052 AESA, une nouvelle avionique et des missiles air-air modernes (ASRAAM). Maritime Jaguar IM équipé de radars Agave pour la lutte antinavire. Retrait progressif à partir de 2030, remplacement par Tejas Mk2.',
    'The Jaguar IS (Indian Strike) is the Indian variant of the SEPECAT Jaguar built under licence by HAL from 1981 (161 aircraft). Cornerstone of the IAF''s low-altitude conventional strike, it was successively upgraded to the DARIN (Display Attack Ranging Inertial Navigation) I, II and III standards, the latter introducing an EL/M-2052 AESA radar, new avionics and modern air-to-air missiles (ASRAAM). Maritime Jaguar IM equipped with Agave radars for anti-ship warfare. Progressive retirement from 2030, replacement by Tejas Mk2.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '1975-01-01',
    '1979-03-31',
    '1981-07-27',
    1699.0,
    3524.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Actif',
    'Active',
    7000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce/Turbomeca Adour')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM armement WHERE name = 'ASRAAM')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM armement WHERE name = 'Sea Eagle')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Jaguar IS'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 16.83, wingspan = 8.69, height = 4.89, wing_area = 24.00,
  empty_weight = 7000, mtow = 15700, service_ceiling = 14000, climb_rate = 213,
  combat_radius = 908, crew = 1, g_limit_pos = 8.6, g_limit_neg = -3.6,
  engine_name = 'Rolls-Royce/Turbomeca Adour Mk 811 / Mk 821', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 24.4, thrust_wet = 33.0,
  production_start = 1979, production_end = 2014, units_built = 161,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/SEPECAT_Jaguar',
  wikipedia_en = 'https://en.wikipedia.org/wiki/SEPECAT_Jaguar'
WHERE name = 'Jaguar IS';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 35000000, unit_cost_year = 1995,
  manufacturer_page = 'https://hal-india.co.in/',
  variants    = E'- **Jaguar IS** : Strike monoplace (IAF, 1981)\n- **Jaguar IB** : biplace d''entraînement\n- **Jaguar IM** : Maritime, radar Agave, missile Sea Eagle (6 appareils)\n- **Jaguar DARIN I/II/III** : modernisations successives (1993, 2003, 2013-2020) — DARIN III : radar EL/M-2052 AESA, HOTAS, ASRAAM\n- 161 appareils HAL-construits (1981-2014), 6 escadrons IAF',
  variants_en = E'- **Jaguar IS** : Strike single-seat (IAF, 1981)\n- **Jaguar IB** : two-seat trainer\n- **Jaguar IM** : Maritime, Agave radar, Sea Eagle missile (6 aircraft)\n- **Jaguar DARIN I/II/III** : successive upgrades (1993, 2003, 2013-2020) — DARIN III: EL/M-2052 AESA radar, HOTAS, ASRAAM\n- 161 HAL-built aircraft (1981-2014), 6 IAF squadrons'
WHERE name = 'Jaguar IS';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nAccord de transfert de technologie signé entre HAL, SEPECAT (BAE/Dassault-Bréguet) et l''IAF en **1978**. Premier lot (40 appareils) importé directement de BAE Warton, puis production sous licence de **161 appareils** à HAL Bangalore entre **1981 et 2014** — l''un des plus longs programmes de production sous licence en Inde.\n\n## Carrière opérationnelle\nPierre angulaire de la frappe conventionnelle à basse altitude de l''IAF. Engagé durant la **guerre de Kargil (1999)** en appui au sol et reconnaissance. Engagé aussi dans des missions maritimes avec la variante IM (Jamnagar). Modernisations successives DARIN I (1993), DARIN II (2003) et **DARIN III (2013-2020)** : 59 appareils re-winger + radar EL/M-2052 AESA + avionique Elbit + compatibilité ASRAAM. Retrait progressif prévu à partir de **2030**, remplacement Tejas Mk2.\n\n## Héritage\nSeul Jaguar au monde encore en service en 2026 après le retrait britannique, français et omanais. Démontre la capacité indienne à prolonger une cellule des années 1970 avec de l''avionique de pointe pendant 50+ ans.',
  description_en = E'## Genesis\nTechnology transfer agreement signed between HAL, SEPECAT (BAE/Dassault-Bréguet) and the IAF in **1978**. First batch (40 aircraft) imported directly from BAE Warton, then licence production of **161 aircraft** at HAL Bangalore between **1981 and 2014** — one of India''s longest licence production programmes.\n\n## Operational career\nCornerstone of the IAF''s low-altitude conventional strike. Deployed during the **Kargil War (1999)** in ground support and reconnaissance. Also deployed in maritime missions with the IM variant (Jamnagar). Successive upgrades DARIN I (1993), DARIN II (2003) and **DARIN III (2013-2020)**: 59 aircraft re-winged + EL/M-2052 AESA radar + Elbit avionics + ASRAAM compatibility. Gradual retirement planned from **2030**, replaced by Tejas Mk2.\n\n## Legacy\nOnly Jaguar worldwide still in service in 2026 after British, French and Omani retirements. Demonstrates Indian capability to extend a 1970s airframe with cutting-edge avionics over 50+ years.'
WHERE name = 'Jaguar IS';
