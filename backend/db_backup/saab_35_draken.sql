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
    'Saab 35 Draken',
    'Saab 35 Draken',
    'Saab 35 Draken (Flygvapnet)',
    'Saab 35 Draken (Swedish Air Force)',
    'Intercepteur supersonique suédois à configuration double delta',
    'Swedish supersonic interceptor with double-delta wing configuration',
    '/assets/airplanes/saab-35-draken.jpg',
    'Le Saab 35 Draken est un chasseur intercepteur monoplace conçu par Saab pour la Flygvapnet (force aérienne suédoise). Premier avion de combat occidental à franchir Mach 2 en production, il se distingue par sa configuration aérodynamique "double delta" unique qui combine performances supersoniques et capacité de décollage court depuis des routes civiles (doctrine Bas 90). Propulsé par un Rolls-Royce Avon construit sous licence par Volvo, il atteint 2125 km/h. Mis en service en 1960, retiré du service suédois en 1999 (jusqu''en 2005 en Autriche).',
    'The Saab 35 Draken is a single-seat interceptor designed by Saab for the Flygvapnet (Swedish Air Force). The first Western combat aircraft to exceed Mach 2 in production, it is distinguished by its unique "double-delta" aerodynamic configuration combining supersonic performance with short take-off capability from civilian roads (Bas 90 doctrine). Powered by a Rolls-Royce Avon built under licence by Volvo, it reaches 2125 km/h. Entered service in 1960, retired from Swedish service in 1999 (until 2005 in Austria).',
    (SELECT id FROM countries WHERE code = 'SWE'),
    '1949-01-01',
    '1955-10-25',
    '1960-03-08',
    2125.0,
    3250.0,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired',
    7425.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM tech WHERE name = 'Configuration aérodynamique en double delta')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Avon')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM tech WHERE name = 'Radar R21G/M1')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM armement WHERE name = 'Bofors 135 mm')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block — fiche technique étendue / motorisation / service
UPDATE airplanes SET
  length = 15.35, wingspan = 9.42, height = 3.89, wing_area = 49.20,
  empty_weight = 7425, mtow = 16000, service_ceiling = 20000, climb_rate = 175,
  combat_radius = 720, crew = 1, g_limit_pos = 9.0, g_limit_neg = -4.0,
  engine_name = 'Volvo Flygmotor RM6C (licence Rolls-Royce Avon 300)', engine_count = 1,
  engine_type = 'Turbojet avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 56.9, thrust_wet = 78.4,
  production_start = 1955, production_end = 1974, units_built = 651,
  operators_count = 4,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Saab_35_Draken',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Saab_35_Draken'
WHERE name = 'Saab 35 Draken';

-- [auto:006] enrichment block — production, coût, variantes
UPDATE airplanes SET
  unit_cost_usd = 6000000, unit_cost_year = 1960,
  manufacturer_page = 'https://www.saab.com/',
  variants    = E'- **J 35A/B** : versions initiales (1960-1962), radar PS-02\n- **J 35D** : moteur RM6C plus puissant, radar PS-03 (1963)\n- **J 35F** : variante principale, missile Falcon Rb 27/28 (1965)\n- **J 35J** : modernisation de 54 J 35F (1987-1991)\n- **Saab 35XD/MK 50** : versions export Danemark, Finlande\n- **RF-35** : reconnaissance photographique\n- **SK 35C** : biplace d''entraînement',
  variants_en = E'- **J 35A/B** : initial variants (1960-1962), PS-02 radar\n- **J 35D** : more powerful RM6C engine, PS-03 radar (1963)\n- **J 35F** : main variant, Falcon Rb 27/28 missile (1965)\n- **J 35J** : upgrade of 54 J 35F aircraft (1987-1991)\n- **Saab 35XD/MK 50** : export versions Denmark, Finland\n- **RF-35** : photo reconnaissance\n- **SK 35C** : two-seat trainer'
WHERE name = 'Saab 35 Draken';

-- [auto:007] enrichment block — description narrative
UPDATE airplanes SET
  description = E'## Genèse\nConçu par Erik Bratt chez Saab dès **1949** pour intercepter les bombardiers soviétiques de haute altitude, le Draken adopte une configuration révolutionnaire à **double delta** permettant à la fois des décollages courts, un vol transsonique efficace et des performances supersoniques. Premier vol le **25 octobre 1955**, mise en service en **1960**.\n\n## Carrière opérationnelle\nPremier avion occidental de série à dépasser Mach 2. La doctrine suédoise **Bas 90** imposait des décollages depuis des routes civiles pour survivre à une frappe nucléaire soviétique — le Draken y excellait. **651 exemplaires** produits (1955-1974), exportés au Danemark, à la Finlande et à l''Autriche. Retiré du service suédois en 1999, la Finlande en 2000, l''Autriche en 2005.\n\n## Héritage\nPremier symbole de l''industrie aéronautique suédoise indépendante de la Guerre froide. A ouvert la voie technologique au Viggen puis au Gripen — lignée Saab ininterrompue depuis 75 ans.',
  description_en = E'## Genesis\nDesigned by Erik Bratt at Saab from **1949** to intercept Soviet high-altitude bombers, the Draken adopts a revolutionary **double-delta** configuration allowing short take-offs, efficient transonic flight and supersonic performance. First flight on **25 October 1955**, service entry in **1960**.\n\n## Operational career\nFirst Western production aircraft to exceed Mach 2. The Swedish **Bas 90** doctrine mandated take-offs from civilian roads to survive a Soviet nuclear strike — the Draken excelled at this. **651 airframes** built (1955-1974), exported to Denmark, Finland and Austria. Retired from Swedish service in 1999, Finland in 2000, Austria in 2005.\n\n## Legacy\nFirst symbol of the independent Swedish Cold War aerospace industry. Paved the technological way for the Viggen then the Gripen — an unbroken Saab lineage spanning 75 years.'
WHERE name = 'Saab 35 Draken';
