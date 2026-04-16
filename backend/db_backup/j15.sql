-- Insertion des nouveaux armements spécifiques au J-15
INSERT INTO armement (name, description) VALUES
('YJ-83', 'Missile antinavire subsonique, guidage radar actif, portée 180 km');

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
    'Shenyang J-15',
    'Shenyang J-15',
    'Shenyang J-15 Flying Shark',
    'Shenyang J-15 Flying Shark',
    'Chasseur embarqué chinois de 4e génération',
    'Chinese 4th-generation carrier-based fighter',
    '/assets/airplanes/j15.jpg',
    'Le Shenyang J-15 Flying Shark est le premier chasseur embarqué opérationnel de la marine chinoise, développé par Shenyang Aircraft Corporation. Dérivé du prototype T-10K du Sukhoi Su-33 russe, il a été adapté et modernisé avec des systèmes avioniques et un armement chinois. Le J-15 est conçu pour opérer depuis les porte-avions de la classe Liaoning et Shandong, utilisant un tremplin ski-jump pour le décollage. Capable de missions de supériorité aérienne, d''attaque antinavire et de frappe tactique, il est équipé d''ailes repliables, d''une crosse d''appontage et d''un train d''atterrissage renforcé. Il constitue un élément clé de la projection de puissance navale chinoise.',
    'The Shenyang J-15 Flying Shark is the first operational carrier-based fighter of the Chinese Navy, developed by Shenyang Aircraft Corporation. Derived from the Russian Sukhoi Su-33 T-10K prototype, it has been adapted and modernized with Chinese avionics systems and armament. The J-15 is designed to operate from Liaoning and Shandong-class aircraft carriers, using a ski-jump ramp for take-off. Capable of air superiority, anti-ship attack and tactical strike missions, it is equipped with folding wings, an arrestor hook and reinforced landing gear. It constitutes a key element of Chinese naval power projection.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2001-01-01',
    '2009-08-31',
    '2013-11-01',
    2400.0,
    3500.0,
    (SELECT id FROM manufacturer WHERE code = 'SAC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    17500.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Réacteur WS-10')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM tech WHERE name = 'Système de fusion de capteurs'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'PL-8')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'PL-12')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'YJ-83')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM armement WHERE name = 'LS-6'));

-- Insertion des guerres
-- Le J-15 n'a pas été engagé dans des conflits majeurs à ce jour, donc pas d'entrée dans airplane_wars

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Shenyang J-15'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 21.9, wingspan = 14.7, height = 5.9, wing_area = 62.0,
  empty_weight = 17500, mtow = 33000, service_ceiling = 17500,
  combat_radius = 1500, crew = 1,
  engine_name = 'WS-10H', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 74.5, thrust_wet = 140.0,
  production_start = 2009, production_end = NULL, units_built = 60,
  operators_count = 1,
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-11' LIMIT 1),
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Shenyang_J-15',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Shenyang_J-15'
WHERE name = 'Shenyang J-15';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 61000000, unit_cost_year = 2013,
  variants    = E'- **J-15** : version navalisée Flanker chinois\n- **J-15B** : version modernisée, AESA\n- **J-15D** : variante guerre électronique',
  variants_en = E'- **J-15** : Chinese navalised Flanker\n- **J-15B** : upgraded AESA variant\n- **J-15D** : electronic warfare variant'
WHERE name = 'Shenyang J-15';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nVersion navalisée du J-11 (dérivé du Su-33 ukrainien), développée à partir d''un prototype ukrainien T-10K-3 vendu à la Chine en 2001. Premier vol en 2009.\n\n## Carrière opérationnelle\nOpère depuis les porte-avions chinois **Liaoning**, **Shandong** et **Fujian**. Rôle central dans la projection navale chinoise en mer de Chine méridionale. Nouvelles variantes J-15B et J-15D (guerre électronique).\n\n## Héritage\nSeul chasseur navalisé chinois actuel. Permet à la Chine de devenir la 2e puissance navale aéronautique au monde (après les États-Unis). Remplaçant possible à terme par un dérivé navalisé du J-35 furtif.',
  description_en = E'## Genesis\nCarrier-borne J-11 variant (derived from the Ukrainian Su-33), developed from a Ukrainian T-10K-3 prototype sold to China in 2001. First flew in 2009.\n\n## Operational career\nOperates from Chinese carriers **Liaoning**, **Shandong** and **Fujian**. Central role in Chinese naval projection in the South China Sea. New J-15B and J-15D (electronic warfare) variants.\n\n## Legacy\nChina''s only current carrier-borne fighter. Enables China to become the 2nd naval aviation power in the world (after the US). Possible eventual replacement by a navalised derivative of the stealth J-35.'
WHERE name = 'Shenyang J-15';
