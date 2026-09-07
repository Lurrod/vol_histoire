-- Mikoyan-Gourevitch MiG-19
--
-- Photo : Mikoyan-Gurevich MiG-19S Farmer USAF.jpg
--   licence Public domain — U.S. Air Force photo
--   https://commons.wikimedia.org/wiki/File%3AMikoyan-Gurevich_MiG-19S_Farmer_USAF.jpg

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
    status_en
) VALUES (
    'MiG-19',
    'MiG-19',
    'Mikoyan-Gourevitch MiG-19',
    'Mikoyan-Gurevich MiG-19',
    'Premier chasseur supersonique de série soviétique',
    'First Soviet series-production supersonic fighter',
    '/assets/airplanes/mig19.jpg',
    E'## Genèse\nLe MiG-19 est le premier avion soviétique capable de dépasser le mur du son en palier, sans piqué. Développé dans l''urgence face aux bombardiers stratégiques américains, il entre en service en 1955, quelques mois seulement après le F-100 Super Sabre américain.\n\n## Conception\nAile à forte flèche de 55°, deux réacteurs RD-9B accolés, et surtout un armement de **trois canons de 30 mm** là où les chasseurs occidentaux contemporains misaient déjà sur le missile. Ce choix, jugé rétrograde à l''époque, se révélera pertinent au Vietnam quand les premiers missiles air-air se montreront peu fiables au combat rapproché.\n\n## Carrière opérationnelle\nSa carrière soviétique est courte : le MiG-21, plus moderne, le remplace dès le début des années 1960. Mais sa version chinoise, le **Shenyang J-6**, sera produite à plus de 4 000 exemplaires et servira jusque dans les années 2010. Au Vietnam, ses canons remportent plusieurs victoires sur des Phantom. Le Pakistan l''engage en 1971 contre l''Inde.\n\n## Place dans l''histoire\nÉclipsé dans l''histoire par son successeur immédiat, il reste le maillon décisif entre la première génération subsonique et l''ère du Mach 2. Sa descendance chinoise, elle, l''a fait voler pendant plus d''un demi-siècle.',
    E'## Genesis\nThe MiG-19 was the first Soviet aircraft able to exceed the speed of sound in level flight rather than in a dive. Developed urgently against American strategic bombers, it entered service in 1955, only months after the American F-100 Super Sabre.\n\n## Design\nA 55° swept wing, two RD-9B engines side by side, and above all an armament of **three 30 mm cannon** at a time when contemporary Western fighters were already betting on missiles. That choice, considered backward-looking then, proved sound over Vietnam when early air-to-air missiles turned out to be unreliable in close combat.\n\n## Operational career\nIts Soviet career was short: the more modern MiG-21 replaced it from the early 1960s. But its Chinese version, the **Shenyang J-6**, was built in more than 4,000 examples and served into the 2010s. Over Vietnam its cannon scored several victories against Phantoms. Pakistan committed it against India in 1971.\n\n## Place in history\nOvershadowed by its immediate successor, it remains the decisive link between the first subsonic generation and the Mach 2 era. Its Chinese descendants kept it flying for more than half a century.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1951-01-01',
    '1952-09-18',
    '1955-03-01',
    1455.0,
    2200.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM tech WHERE name = 'Radar RP-9'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM armement WHERE name = 'NR-30')),
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM armement WHERE name = 'R-3S')),
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM armement WHERE name = 'S-5'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.54,
  wingspan          = 9.2,
  height            = 3.88,
  wing_area         = 25.0,
  empty_weight      = 5172,
  mtow              = 8832,
  service_ceiling   = 17500,
  climb_rate        = 180,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = 685,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Tumansky RD-9B',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 25.5,
  thrust_wet        = 31.9,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1968,
  units_built       = 2172,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 25,
  variants          = E'- **MiG-19S** : version de jour principale, trois canons de 30 mm\n- **MiG-19P / PM** : intercepteurs tout-temps à radar\n- **Shenyang J-6** : production sous licence chinoise, plus nombreuse que la soviétique\n- **Nanchang Q-5** : dérivé chinois d''attaque au sol',
  variants_en       = E'- **MiG-19S** : main day fighter version, three 30 mm cannon\n- **MiG-19P / PM** : radar-equipped all-weather interceptors\n- **Shenyang J-6** : Chinese licence production, more numerous than the Soviet one\n- **Nanchang Q-5** : Chinese ground-attack derivative',

  -- Strate 4 : qualitatif
  nickname          = 'Farmer',

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mikoyan-Gurevich_MiG-19',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mikoyan-Gurevich_MiG-19',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force photo',
  image_licence     = 'Public domain'
WHERE name = 'MiG-19';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MiG-19';
