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
    'HAL Ajeet',
    'HAL Ajeet',
    'HAL Ajeet (Indian Air Force)',
    'HAL Ajeet (Indian Air Force)',
    'Chasseur léger indien dérivé amélioré du Folland Gnat',
    'Indian light fighter derived from an improved Folland Gnat',
    '/assets/airplanes/hal-ajeet.jpg',
    'Le HAL Ajeet ("Invincible") est une version indienne améliorée du Folland Gnat Mk.1, produite sous licence puis redéveloppée par HAL. Ses améliorations principales portent sur une avionique modernisée, des réservoirs de carburant additionnels dans les ailes et quatre points d''emport au lieu de deux. 79 exemplaires produits entre 1976 et 1982 pour l''Indian Air Force. Retiré en 1991. Le Folland Gnat/Ajeet s''est notamment illustré lors de la guerre indo-pakistanaise de 1971, où il s''est vu décerner le surnom de "Sabre Slayer" (tueur de F-86 Sabre).',
    'The HAL Ajeet ("Invincible") is an improved Indian version of the Folland Gnat Mk.1, produced under licence then redeveloped by HAL. Its main improvements concern modernised avionics, additional fuel tanks in the wings and four hardpoints instead of two. 79 airframes produced between 1976 and 1982 for the Indian Air Force. Retired in 1991. The Folland Gnat/Ajeet notably distinguished itself during the 1971 Indo-Pakistani War, where it earned the nickname "Sabre Slayer".',
    (SELECT id FROM countries WHERE code = 'IND'),
    '1972-01-01',
    '1975-03-05',
    '1977-09-30',
    1150.0,
    800.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired',
    2810.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Orpheus')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 9.07, wingspan = 6.75, height = 2.46, wing_area = 12.69,
  empty_weight = 2810, mtow = 4170, service_ceiling = 13720, climb_rate = 106,
  combat_radius = 370, crew = 1, g_limit_pos = 8.0, g_limit_neg = -3.0,
  engine_name = 'HAL Orpheus 701-01 (licence Bristol Siddeley)', engine_count = 1,
  engine_type = 'Turbojet', engine_type_en = 'Turbojet',
  thrust_dry = 20.0, thrust_wet = NULL,
  production_start = 1975, production_end = 1982, units_built = 89,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_Ajeet',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_Ajeet'
WHERE name = 'HAL Ajeet';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 1500000, unit_cost_year = 1976,
  manufacturer_page = 'https://hal-india.co.in/',
  variants    = E'- **Ajeet Mk1** : monoplace d''interception et d''appui-feu\n- **Ajeet Trainer** : biplace d''entraînement (2 prototypes uniquement)',
  variants_en = E'- **Ajeet Mk1** : single-seat interceptor and ground attack\n- **Ajeet Trainer** : two-seat trainer (2 prototypes only)'
WHERE name = 'HAL Ajeet';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nDéveloppement lancé en **1972** par HAL comme évolution indienne profonde du Folland Gnat Mk.1 produit sous licence depuis 1962. Principales améliorations : quatre points d''emport au lieu de deux, réservoirs de voilure accrus (18,2 % de capacité en plus), avionique modernisée. Premier vol le **5 mars 1975**.\n\n## Carrière opérationnelle\n**89 exemplaires produits** (79 de série + 10 conversions de Gnat). Le Gnat et l''Ajeet étaient réputés pour leur supériorité au combat tournoyant contre les F-86 Sabre et F-104 Starfighter pakistanais — le Gnat avait reçu le surnom de "Sabre Slayer" en 1965 et 1971. L''Ajeet a servi en première ligne jusqu''en 1991.\n\n## Héritage\nDernier chasseur de la lignée Folland Gnat / HAL Ajeet. A cristallisé l''expertise HAL avant le HF-24 Marut et plus tard le Tejas.',
  description_en = E'## Genesis\nDevelopment launched in **1972** by HAL as a deep Indian evolution of the Folland Gnat Mk.1 produced under licence since 1962. Main improvements: four hardpoints instead of two, increased wing tanks (18.2 % more capacity), upgraded avionics. First flight on **5 March 1975**.\n\n## Operational career\n**89 airframes built** (79 production + 10 Gnat conversions). The Gnat and Ajeet were renowned for their dogfight superiority against Pakistani F-86 Sabres and F-104 Starfighters — the Gnat earned the "Sabre Slayer" nickname in 1965 and 1971. The Ajeet served on the front line until 1991.\n\n## Legacy\nLast fighter of the Folland Gnat / HAL Ajeet lineage. Crystallised HAL expertise before the HF-24 Marut and later the Tejas.'
WHERE name = 'HAL Ajeet';
