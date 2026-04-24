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
    'Mitsubishi T-2',
    'Mitsubishi T-2',
    'Mitsubishi T-2 (Japan Air Self-Defense Force)',
    'Mitsubishi T-2 (Japan Air Self-Defense Force)',
    'Premier avion d''entraînement supersonique biplace japonais d''après-guerre',
    'First Japanese post-war supersonic two-seat trainer',
    '/assets/airplanes/mitsubishi-t2.jpg',
    'Le Mitsubishi T-2 est le premier avion d''entraînement supersonique japonais d''après-guerre, dérivé conceptuel du SEPECAT Jaguar. Propulsé par deux réacteurs Ishikawajima-Harima TF40-IHI-801A (licence Rolls-Royce/Turbomeca Adour), il a formé la quasi-totalité des pilotes de chasse de la JASDF entre 1975 et 2006. 96 exemplaires produits. Son successeur est le Kawasaki T-4 (subsonique) pour l''entraînement avancé. A servi de base au chasseur F-1.',
    'The Mitsubishi T-2 is Japan''s first post-war supersonic trainer, a conceptual derivative of the SEPECAT Jaguar. Powered by two Ishikawajima-Harima TF40-IHI-801A engines (licence-built Rolls-Royce/Turbomeca Adour), it trained almost all JASDF fighter pilots between 1975 and 2006. 96 examples built. Its successor is the Kawasaki T-4 (subsonic) for advanced training. It served as the basis for the F-1 fighter.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1967-01-01',
    '1971-07-20',
    '1975-03-29',
    1700.0,
    2870.0,
    (SELECT id FROM manufacturer WHERE code = 'MHI'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired',
    6307.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce/Turbomeca Adour')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM armement WHERE name = 'JM61A1')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 17.86, wingspan = 7.88, height = 4.39, wing_area = 21.17,
  empty_weight = 6307, mtow = 12800, service_ceiling = 15240, climb_rate = 175,
  combat_radius = 560, crew = 2, g_limit_pos = 7.33, g_limit_neg = -3.0,
  engine_name = 'Ishikawajima-Harima TF40-IHI-801A (licence Adour)', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 22.8, thrust_wet = 32.5,
  production_start = 1971, production_end = 1988, units_built = 96,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mitsubishi_T-2',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mitsubishi_T-2'
WHERE name = 'Mitsubishi T-2';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 10000000, unit_cost_year = 1980,
  manufacturer_page = 'https://www.mhi.com/',
  variants    = E'- **T-2A** : version d''entraînement avancé pilote\n- **T-2B** : version d''entraînement armement\n- **T-2CCV** : prototype de commande de vol électrique (1984), base technologique pour le Mitsubishi F-2\n- **Blue Impulse T-2** : patrouille acrobatique de la JASDF de 1982 à 1995',
  variants_en = E'- **T-2A** : pilot advanced trainer variant\n- **T-2B** : weapons training variant\n- **T-2CCV** : fly-by-wire prototype (1984), technological basis for the Mitsubishi F-2\n- **Blue Impulse T-2** : JASDF aerobatic team from 1982 to 1995'
WHERE name = 'Mitsubishi T-2';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme lancé en **1967** pour doter la JASDF d''un entraîneur supersonique national remplaçant les Lockheed T-33. Configuration inspirée du SEPECAT Jaguar. Premier vol le **20 juillet 1971**, mise en service au **29 mars 1975** au 22° Hikōtai de Matsushima.\n\n## Carrière opérationnelle\n**96 exemplaires produits** (32 T-2A + 62 T-2B + 2 prototypes). Formation de tous les pilotes de chasse de la JASDF pendant 30 ans (F-104, F-4EJ, F-15J, F-2). Ambassadeur des acrobaties : **Blue Impulse** sur T-2 de 1982 à 1995 (vol en formation 6 avions).\n\n## Héritage\nLe **T-2CCV** (Control Configured Vehicle) a servi de banc d''essai au système fly-by-wire qui équipe le F-2. Fin d''époque pour l''aviation militaire supersonique japonaise de conception nationale — remplacé par le Kawasaki T-4 (subsonique) pour l''entraînement avancé. Retrait définitif en **2006**.',
  description_en = E'## Genesis\nProgramme launched in **1967** to give the JASDF a domestic supersonic trainer replacing Lockheed T-33s. Configuration inspired by the SEPECAT Jaguar. First flight on **20 July 1971**, service entry on **29 March 1975** with the 22° Hikōtai at Matsushima.\n\n## Operational career\n**96 examples built** (32 T-2A + 62 T-2B + 2 prototypes). Trained all JASDF fighter pilots for 30 years (F-104, F-4EJ, F-15J, F-2). Aerobatic ambassador: **Blue Impulse** on T-2 from 1982 to 1995 (six-aircraft formation flight).\n\n## Legacy\nThe **T-2CCV** (Control Configured Vehicle) served as a testbed for the fly-by-wire system fitted on the F-2. End of an era for Japanese-designed supersonic military aviation — replaced by the Kawasaki T-4 (subsonic) for advanced training. Final retirement in **2006**.'
WHERE name = 'Mitsubishi T-2';
