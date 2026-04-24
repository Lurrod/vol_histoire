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
    'HAL AMCA',
    'HAL AMCA',
    'HAL AMCA Advanced Medium Combat Aircraft (Indian Air Force)',
    'HAL AMCA Advanced Medium Combat Aircraft (Indian Air Force)',
    'Chasseur furtif bimoteur indien de 5e génération en développement',
    'Indian twin-engine 5th-generation stealth fighter in development',
    '/assets/airplanes/hal-amca.jpg',
    'L''AMCA (Advanced Medium Combat Aircraft) est le programme de chasseur furtif de 5e génération de l''Inde, conduit par l''Aeronautical Development Agency (ADA) et HAL. Bimoteur (GE F414 Mk1, puis moteur indigène de 110 kN Mk2), soute interne à armement, radar AESA Uttam, supercruise et fusion de capteurs sont au programme. Premier prototype attendu en 2026, premier vol en 2028, service opérationnel vers 2035. 125 appareils prévus pour l''Indian Air Force.',
    'The AMCA (Advanced Medium Combat Aircraft) is India''s 5th-generation stealth fighter programme, conducted by the Aeronautical Development Agency (ADA) and HAL. Twin-engine (GE F414 Mk1, then a 110 kN indigenous engine for Mk2), internal weapons bay, Uttam AESA radar, supercruise and sensor fusion are on the agenda. First prototype expected in 2026, first flight in 2028, operational service around 2035. 125 aircraft planned for the Indian Air Force.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '2010-01-01',
    NULL,
    NULL,
    2100.0,
    2800.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En développement',
    'In development',
    12000.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'Python 5')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'SCALP EG')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'Astra Mk1'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 17.60, wingspan = 11.08, height = 4.80, wing_area = 55.00,
  empty_weight = 12000, mtow = 25000, service_ceiling = 17500, climb_rate = 350,
  combat_radius = 1620, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.5,
  engine_name = 'General Electric F414-INS6 (Mk1) / Moteur indigène 110 kN (Mk2)', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 58.0, thrust_wet = 98.0,
  production_start = NULL, production_end = NULL, units_built = 0,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_AMCA',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_AMCA'
WHERE name = 'HAL AMCA';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 180000000, unit_cost_year = 2030,
  manufacturer_page = 'https://hal-india.co.in/',
  variants    = E'- **AMCA Mk1** : version initiale, moteurs F414-INS6 (2× 98 kN)\n- **AMCA Mk2** : moteurs indigènes de 110 kN, super-croisière, EOTS indigène\n- Soute interne : 1500 kg (4 BVR + 2 PGM)\n- Pylônes externes : 4500 kg en mode non-furtif\n- 125 appareils prévus sur 7 escadrons',
  variants_en = E'- **AMCA Mk1** : initial variant, F414-INS6 engines (2× 98 kN)\n- **AMCA Mk2** : indigenous 110 kN engines, supercruise, indigenous EOTS\n- Internal bay : 1500 kg (4 BVR + 2 PGM)\n- External pylons : 4500 kg in non-stealth mode\n- 125 aircraft planned across 7 squadrons'
WHERE name = 'HAL AMCA';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme **Advanced Medium Combat Aircraft (AMCA)** approuvé par le Cabinet de sécurité indien le **7 mars 2024** avec un budget de **15 000 crore INR** (≈ 1,8 milliard USD) pour le développement de 5 prototypes et 3 cellules statiques. Conduit par l''ADA et HAL en coopération avec DRDO. Premier prototype attendu en **2026**, premier vol en **2028**, service opérationnel vers **2035**.\n\n## Carrière opérationnelle\nPas encore en service. Cible : **125 appareils** (~7 escadrons) — Mk1 avec moteur F414-INS6 partagé avec Tejas Mk2 pour accélérer la chaîne industrielle, puis Mk2 avec moteur indigène de 110 kN (collaboration possible avec Safran ou Rolls-Royce).\n\n## Héritage\nPremier chasseur de 5e génération entièrement indien. Applique les leçons du Tejas (architecture ouverte, avionique modulaire) à une plateforme furtive bimoteur. Positionne l''Inde comme la 5e nation au monde capable de développer un chasseur de 5e génération (après USA, Russie, Chine, Turquie).',
  description_en = E'## Genesis\n**Advanced Medium Combat Aircraft (AMCA)** programme approved by the Indian Cabinet Committee on Security on **7 March 2024** with a budget of **INR 15,000 crore** (≈ USD 1.8 billion) for the development of 5 prototypes and 3 static airframes. Led by ADA and HAL in cooperation with DRDO. First prototype expected in **2026**, first flight in **2028**, operational service around **2035**.\n\n## Operational career\nNot yet in service. Target: **125 aircraft** (~7 squadrons) — Mk1 with F414-INS6 engine shared with Tejas Mk2 to accelerate the industrial chain, then Mk2 with indigenous 110 kN engine (possible collaboration with Safran or Rolls-Royce).\n\n## Legacy\nFirst fully Indian 5th-generation fighter. Applies lessons from the Tejas (open architecture, modular avionics) to a stealth twin-engine platform. Positions India as the 5th nation globally capable of developing a 5th-generation fighter (after USA, Russia, China, Turkey).'
WHERE name = 'HAL AMCA';
