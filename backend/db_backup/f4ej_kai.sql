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
    'F-4EJ Kai',
    'F-4EJ Kai',
    'Mitsubishi F-4EJ Kai Phantom II (Japan Air Self-Defense Force)',
    'Mitsubishi F-4EJ Kai Phantom II (Japan Air Self-Defense Force)',
    'Version japonaise modernisée du F-4E Phantom II, produite sous licence',
    'Licence-built Japanese upgrade of the F-4E Phantom II',
    '/assets/airplanes/f4ej-kai.jpg',
    'Le F-4EJ est la version japonaise du F-4E Phantom II produite sous licence par Mitsubishi entre 1971 et 1981 (140 appareils). Le F-4EJ Kai (改 — "amélioré") est la modernisation complète entamée en 1984 avec un nouveau radar AN/APG-66J, HUD numérique, INS, capacité d''emport ASM-2, AIM-7F et liaison de données. Dernier exemplaire retiré en mars 2021, symbole de la fin de 50 ans de Phantoms au service de la JASDF. Remplacé progressivement par F-15J, F-2 et F-35A.',
    'The F-4EJ is the Japanese version of the F-4E Phantom II licence-built by Mitsubishi between 1971 and 1981 (140 aircraft). The F-4EJ Kai (改 — "improved") is the full upgrade begun in 1984 with a new AN/APG-66J radar, digital HUD, INS, ASM-2, AIM-7F and data link capability. Last example retired in March 2021, symbolising the end of 50 years of JASDF Phantom service. Gradually replaced by F-15J, F-2 and F-35A.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1967-01-01',
    '1971-01-14',
    '1971-07-01',
    2370.0,
    2600.0,
    (SELECT id FROM manufacturer WHERE code = 'MHI'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired',
    13757.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-68')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM armement WHERE name = 'JM61A1')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM armement WHERE name = 'AAM-3')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM armement WHERE name = 'ASM-1')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM armement WHERE name = 'ASM-2')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM armement WHERE name = 'Mk 84'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 19.20, wingspan = 11.77, height = 5.00, wing_area = 49.20,
  empty_weight = 13757, mtow = 28030, service_ceiling = 18000, climb_rate = 210,
  combat_radius = 680, crew = 2, g_limit_pos = 7.5, g_limit_neg = -3.0,
  engine_name = 'General Electric J79-IHI-17 (licence)', engine_count = 2,
  engine_type = 'Turbojet avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 52.8, thrust_wet = 79.6,
  production_start = 1971, production_end = 1981, units_built = 140,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_F-4_Phantom_II',
  wikipedia_en = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_F-4_Phantom_II#Japan'
WHERE name = 'F-4EJ Kai';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 18000000, unit_cost_year = 1975,
  manufacturer_page = 'https://www.boeing.com/',
  variants    = E'- **F-4EJ** : version initiale, construite sous licence Mitsubishi (138 appareils, 1971-1981)\n- **F-4EJ Kai** : upgrade complet à partir de 1984 — radar APG-66J, HUD, INS, ASM-1/2 (95 appareils)\n- **RF-4E/EJ Kai** : version reconnaissance avec pod Tactical Air Reconnaissance Pod System\n- Dernier retrait en mars 2021 — fin de 50 ans de Phantoms japonais',
  variants_en = E'- **F-4EJ** : initial version, licence-built by Mitsubishi (138 aircraft, 1971-1981)\n- **F-4EJ Kai** : complete upgrade from 1984 — APG-66J radar, HUD, INS, ASM-1/2 (95 aircraft)\n- **RF-4E/EJ Kai** : reconnaissance version with Tactical Air Reconnaissance Pod System\n- Last retirement in March 2021 — end of 50 years of Japanese Phantoms'
WHERE name = 'F-4EJ Kai';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nContrat de licence signé en **1968** entre McDonnell Douglas et Mitsubishi pour la production japonaise de 138 F-4EJ. Premier F-4EJ assemblé au Japon le **14 janvier 1971**. 14 autres cellules livrées directement par St. Louis comme appareils de pré-série. Programme de modernisation **F-4EJ Kai** lancé en **1984** pour doter l''avion d''un radar et d''une avionique modernes (APG-66J, HUD, système d''arme ASM-1/2).\n\n## Carrière opérationnelle\n**95 appareils modernisés Kai**, service jusqu''en **mars 2021** (retrait du dernier escadron RF-4EJ Kai du 501° Hikōtai à Hyakuri). Phantom japonais engagé en interceptions quasi-quotidiennes contre bombardiers russes Tu-95 Bear et chinois H-6 pendant 50 ans. Pilier de la défense aérienne japonaise jusqu''à la pleine capacité F-15J.\n\n## Héritage\nPlus long service opérationnel du F-4 Phantom dans le monde (50 ans). Remplacé par F-15J Pre-MSIP (défense aérienne), F-2 (antinavire) et F-35A (général). Un escadron Phantom (302° Hikōtai) a été réactivé en **2020 comme premier escadron F-35A japonais** — symbole de la transition générationnelle.',
  description_en = E'## Genesis\nLicence contract signed in **1968** between McDonnell Douglas and Mitsubishi for Japanese production of 138 F-4EJs. First F-4EJ assembled in Japan on **14 January 1971**. 14 more airframes delivered directly from St. Louis as pre-production aircraft. **F-4EJ Kai** upgrade programme launched in **1984** to equip the aircraft with a modern radar and avionics (APG-66J, HUD, ASM-1/2 weapon system).\n\n## Operational career\n**95 upgraded Kai aircraft**, service until **March 2021** (retirement of the last RF-4EJ Kai squadron of 501° Hikōtai at Hyakuri). Japanese Phantom deployed in near-daily interceptions against Russian Tu-95 Bear and Chinese H-6 bombers over 50 years. Pillar of Japanese air defence until full F-15J capability.\n\n## Legacy\nLongest operational service of the F-4 Phantom in the world (50 years). Replaced by F-15J Pre-MSIP (air defence), F-2 (anti-ship) and F-35A (general). A Phantom squadron (302° Hikōtai) was reactivated in **2020 as the first Japanese F-35A squadron** — symbol of the generational transition.'
WHERE name = 'F-4EJ Kai';
