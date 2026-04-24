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
    'MiG-21 Bison',
    'MiG-21 Bison',
    'MiG-21 Bison upgrade (Indian Air Force)',
    'MiG-21 Bison upgrade (Indian Air Force)',
    'Modernisation indienne du MiG-21 avec radar Kopyo et armement moderne',
    'Indian MiG-21 upgrade with Kopyo radar and modern armament',
    '/assets/airplanes/mig21-bison.jpg',
    'Le MiG-21 Bison est la modernisation indienne majeure du MiG-21bis par HAL en coopération avec les Russes Phazotron et Sokol, débutée en 1996 et achevée en 2008 sur 125 appareils. Upgrades : radar Kopyo multi-mode, RWR Tarang, MAWS Banshee, HOTAS, missiles R-77 et R-73, pods PKK, capacité BVR. A remporté des victoires notables contre F-16PAF en février 2019 au Cachemire (engagement du Cdr Abhinandan Varthaman, Py-Award). Retrait en cours, remplacement par Tejas Mk1A.',
    'The MiG-21 Bison is the major Indian upgrade of the MiG-21bis by HAL in cooperation with Russian firms Phazotron and Sokol, begun in 1996 and completed in 2008 on 125 aircraft. Upgrades: Kopyo multi-mode radar, Tarang RWR, Banshee MAWS, HOTAS, R-77 and R-73 missiles, PKK pods, BVR capability. Notable victories against PAF F-16s in February 2019 over Kashmir (Cdr Abhinandan Varthaman engagement, Py-Award). Retirement in progress, replacement by Tejas Mk1A.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '1996-01-01',
    '1998-10-06',
    '2001-10-22',
    2175.0,
    1210.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    5890.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM tech WHERE name = 'Réacteur Tumansky R-25')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM armement WHERE name = 'R-77')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM armement WHERE name = 'R-27R')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM armement WHERE name = 'FAB-500'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 15.76, wingspan = 7.15, height = 4.12, wing_area = 23.00,
  empty_weight = 5890, mtow = 10100, service_ceiling = 17500, climb_rate = 225,
  combat_radius = 370, crew = 1, g_limit_pos = 8.5, g_limit_neg = -4.0,
  engine_name = 'Tumansky R-25-300', engine_count = 1,
  engine_type = 'Turbojet avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 40.21, thrust_wet = 69.62,
  production_start = 1996, production_end = 2008, units_built = 125,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_MiG-21',
  wikipedia_en = 'https://en.wikipedia.org/wiki/MiG-21_Bison'
WHERE name = 'MiG-21 Bison';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 7500000, unit_cost_year = 2001,
  manufacturer_page = 'https://www.migavia.ru/',
  variants    = E'- **MiG-21 Bison** : modernisation majeure du MiG-21bis indien (1996-2008) — radar Kopyo, HOTAS, RWR Tarang, liaison 16, BVR R-77\n- Effectifs IAF : 125 appareils dans 11 escadrons en 2006, retrait progressif à partir de 2022\n- Dernier escadron (No. 4 "Oorials") prévu à la retraite en 2025',
  variants_en = E'- **MiG-21 Bison** : major Indian upgrade of the MiG-21bis (1996-2008) — Kopyo radar, HOTAS, Tarang RWR, Link 16, R-77 BVR\n- IAF strength: 125 aircraft in 11 squadrons in 2006, gradual retirement from 2022\n- Last squadron (No. 4 "Oorials") scheduled for retirement in 2025'
WHERE name = 'MiG-21 Bison';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme de modernisation majeure lancé en **1996** par HAL Nashik en coopération avec les russes Phazotron (radar Kopyo), Sokol (cellule) et Ramenskoye (avionique). 125 MiG-21bis indiens transformés entre **1998 et 2008**. Cockpit entièrement revu (HOTAS, glass cockpit partiel), radar Kopyo multi-mode, capacité BVR R-77.\n\n## Carrière opérationnelle\nPièce maîtresse de la défense aérienne indienne au Cachemire depuis 20 ans — économique, agile, rodé au combat tournoyant. Engagé dans un combat aérien historique le **27 février 2019** au-dessus du Cachemire entre le Commandant Abhinandan Varthaman (MiG-21 Bison) et des F-16PAF pakistanais pendant l''**opération Balakot** : revendication indienne d''un F-16 abattu (non confirmée côté US), Bison perdu, pilote capturé puis rendu par le Pakistan, Py-Award.\n\n## Héritage\nSurnommé "Flying Coffin" dans la presse indienne après des décennies de crashes — 400+ pertes sur 872 MiG-21 indiens livrés. Retrait final prévu en 2025, remplacé par Tejas Mk1A. Symbole de l''époque de l''IAF dépendante de la Russie avant l''ère du Rafale et du Tejas.',
  description_en = E'## Genesis\nMajor upgrade programme launched in **1996** by HAL Nashik in cooperation with Russians Phazotron (Kopyo radar), Sokol (airframe) and Ramenskoye (avionics). 125 Indian MiG-21bis transformed between **1998 and 2008**. Fully revised cockpit (HOTAS, partial glass cockpit), Kopyo multi-mode radar, R-77 BVR capability.\n\n## Operational career\nMainstay of Indian air defence in Kashmir for 20 years — economical, agile, battle-tested in dogfighting. Engaged in a historic air combat on **27 February 2019** over Kashmir between Commander Abhinandan Varthaman (MiG-21 Bison) and Pakistani PAF F-16s during **Operation Balakot**: Indian claim of an F-16 shot down (unconfirmed by the US), Bison lost, pilot captured and then returned by Pakistan, Py-Award.\n\n## Legacy\nNicknamed "Flying Coffin" in the Indian press after decades of crashes — 400+ losses out of 872 Indian MiG-21s delivered. Final retirement planned for 2025, replaced by Tejas Mk1A. Symbol of the era of IAF dependence on Russia before the Rafale and Tejas era.'
WHERE name = 'MiG-21 Bison';
