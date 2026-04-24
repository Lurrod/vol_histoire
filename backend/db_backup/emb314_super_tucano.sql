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
    'Embraer EMB-314 Super Tucano',
    'Embraer EMB-314 Super Tucano',
    'Embraer A-29 Super Tucano (Força Aérea Brasileira et exports)',
    'Embraer A-29 Super Tucano (Brazilian Air Force and exports)',
    'Avion d''appui-feu léger turbopropulseur brésilien pour missions COIN',
    'Brazilian light attack turboprop aircraft for COIN missions',
    '/assets/airplanes/emb-314-super-tucano.jpg',
    'L''EMB-314 Super Tucano (désignation militaire A-29) est un avion d''appui-feu léger développé à partir du Tucano pour répondre aux besoins du programme SIVAM de surveillance amazonienne brésilienne. Son turbopropulseur Pratt & Whitney Canada PT6A-68C de 1600 shp, son cockpit blindé, sa liaison de données, son pod désignateur laser et sa compatibilité avec armements guidés (GBU-12, MAR-1) en font l''outil COIN (contre-insurrection) de référence en service dans 16 pays : Colombie, États-Unis (Tucano Project), Indonésie, Philippines, Afghanistan, Burkina Faso, Liban, etc. 260+ appareils produits.',
    'The EMB-314 Super Tucano (A-29 military designation) is a light attack aircraft developed from the Tucano to meet the needs of the Brazilian SIVAM Amazon surveillance programme. Its Pratt & Whitney Canada PT6A-68C 1,600 shp turboprop, armoured cockpit, data link, laser designator pod and compatibility with guided weapons (GBU-12, MAR-1) make it the reference COIN (counter-insurgency) tool in service in 16 countries: Colombia, United States (Tucano Project), Indonesia, Philippines, Afghanistan, Burkina Faso, Lebanon, etc. 260+ aircraft produced.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1991-01-01',
    '1999-06-02',
    '2003-12-18',
    593.0,
    1330.0,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Actif',
    'Active',
    3200.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM tech WHERE name = 'Pod désignateur laser')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM armement WHERE name = 'Python 4')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM armement WHERE name = 'MAR-1')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 11.38, wingspan = 11.14, height = 3.97, wing_area = 19.40,
  empty_weight = 3200, mtow = 5400, service_ceiling = 10668, climb_rate = 24,
  combat_radius = 550, crew = 2, g_limit_pos = 7.0, g_limit_neg = -3.5,
  engine_name = 'Pratt & Whitney Canada PT6A-68C', engine_count = 1,
  engine_type = 'Turbopropulseur', engine_type_en = 'Turboprop',
  thrust_dry = NULL, thrust_wet = NULL,
  production_start = 2003, production_end = NULL, units_built = 270,
  operators_count = 16,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Embraer_EMB-314_Super_Tucano',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Embraer_EMB_314_Super_Tucano'
WHERE name = 'Embraer EMB-314 Super Tucano';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 18000000, unit_cost_year = 2020,
  manufacturer_page = 'https://www.embraer.com/global/en/defense-super-tucano',
  variants    = E'- **A-29A** : monoplace (désignation export et FAB)\n- **A-29B** : biplace d''entraînement/combat\n- **AT-29** : désignation FAB brésilienne (~100 appareils)\n- Opérateurs : Brésil, Colombie, Afghanistan, Angola, Burkina Faso, Chili, Équateur, Ghana, Indonésie, Liban, Mauritanie, Nigéria, Paraguay, Philippines, USA (Tucano Project), République dominicaine',
  variants_en = E'- **A-29A** : single-seat (export and FAB designation)\n- **A-29B** : two-seat trainer/combat\n- **AT-29** : Brazilian FAB designation (~100 aircraft)\n- Operators: Brazil, Colombia, Afghanistan, Angola, Burkina Faso, Chile, Ecuador, Ghana, Indonesia, Lebanon, Mauritania, Nigeria, Paraguay, Philippines, USA (Tucano Project), Dominican Republic'
WHERE name = 'Embraer EMB-314 Super Tucano';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nDéveloppement lancé en **1991** dans le cadre du programme **SIVAM** (Sistema de Vigilância da Amazônia) de surveillance amazonienne brésilienne nécessitant un avion de patrouille armé capable de décoller de pistes sommaires. Fuselage et aile héritées du Tucano mais agrandies, turbopropulseur PT6A-68C de 1 600 shp (x3 par rapport au Tucano). Premier vol le **2 juin 1999**, mise en service FAB le **18 décembre 2003**.\n\n## Carrière opérationnelle\n**270+ appareils produits** pour 16 pays sur 4 continents. Pilier moderne de la contre-insurrection (**COIN**) — pod désignateur laser, bombes guidées GBU-12, missile Mectron MAR-1 (anti-radar brésilien). Engagé en Afghanistan par les US Special Operations (26 appareils "Tucano Project" livrés à l''armée afghane), par la Colombie contre les FARC, par le Brésil contre les narcotrafiquants. Contracté par l''US Air Force pour le programme **Light Attack (OA-X)** en 2017.\n\n## Héritage\nRéférence mondiale du **light attack à hélice** pour les conflits asymétriques. Coût d''exploitation 10× inférieur aux chasseurs à réaction, ciblage précision équivalent. Base technique du **Super Tucano Armed Utility** (Panavia) et du programme **USAF Armed Overwatch**.',
  description_en = E'## Genesis\nDevelopment launched in **1991** within the Brazilian **SIVAM** (Sistema de Vigilância da Amazônia) Amazon surveillance programme requiring an armed patrol aircraft able to operate from rough strips. Fuselage and wing inherited from the Tucano but enlarged, PT6A-68C turboprop of 1,600 shp (×3 compared to the Tucano). First flight on **2 June 1999**, FAB service entry on **18 December 2003**.\n\n## Operational career\n**270+ aircraft built** for 16 countries across 4 continents. Modern pillar of counter-insurgency (**COIN**) — laser designator pod, GBU-12 guided bombs, Mectron MAR-1 missile (Brazilian anti-radar). Deployed in Afghanistan by US Special Operations (26 "Tucano Project" aircraft delivered to the Afghan army), by Colombia against FARC, by Brazil against drug traffickers. Contracted by the US Air Force for the **Light Attack (OA-X)** programme in 2017.\n\n## Legacy\nWorld reference for **propeller light attack** in asymmetric conflicts. Operating cost 10× lower than jet fighters, equivalent precision targeting. Technical basis for the **Super Tucano Armed Utility** (Panavia) and the **USAF Armed Overwatch** programme.'
WHERE name = 'Embraer EMB-314 Super Tucano';
