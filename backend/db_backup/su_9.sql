-- Soukhoï Su-9
--
-- Photo : Su-9 at Central Air Force Museum Monino pic1.JPG
--   licence Public domain — Alf van Beem
--   https://commons.wikimedia.org/wiki/File%3ASu-9_at_Central_Air_Force_Museum_Monino_pic1.JPG

-- Entrée de référentiel propre à cette fiche.
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'RS-2US', NULL, 'Missile air-air à guidage radar par faisceau directeur, portée 6 km', 'Beam-riding radar-guided air-to-air missile, 6 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'RS-2US');

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
    'Su-9',
    'Su-9',
    'Soukhoï Su-9',
    'Sukhoi Su-9',
    'Intercepteur delta soviétique, conçu autour de son système de conduite de tir',
    'Soviet delta interceptor, designed around its fire control system',
    '/assets/airplanes/su9.jpg',
    E'## Genèse\nSoukhoï développe simultanément deux cellules autour du même réacteur AL-7 : l''une à aile en flèche, qui donnera le Su-7 d''attaque, l''autre à **aile delta**, destinée à l''interception. Le Su-9 est cette seconde branche, conçue pour arrêter les bombardiers américains à haute altitude.\n\n## Conception\nAile delta pure de 57°, entrée d''air frontale à cône central mobile logeant le radar. Comme le F-102 américain de la même époque, il n''emporte **aucun canon** : quatre missiles à guidage par faisceau et rien d''autre. Le rayon d''action est très court, mais l''appareil est conçu pour être guidé depuis le sol jusqu''au contact.\n\n## Carrière opérationnelle\nOnze cent cinquante exemplaires servent exclusivement la défense aérienne soviétique — le Su-9 n''a jamais été exporté, y compris vers les pays du Pacte de Varsovie. C''est un Su-9 qui poursuit sans succès l''U-2 de Francis Gary Powers le **1er mai 1960**, faute d''armement disponible ce jour-là ; l''appareil sera abattu par un missile sol-air.\n\n## Place dans l''histoire\nLe Su-9 fonde la famille des intercepteurs Soukhoï : le **Su-11** en dérive directement, puis le **Su-15**, bimoteur, qui le remplace dans les années 1970. Son aile delta et son cône d''entrée d''air resteront la signature de la maison pendant vingt ans.',
    E'## Genesis\nSukhoi developed two airframes simultaneously around the same AL-7 engine: one with a swept wing, which became the Su-7 attack aircraft, the other with a **delta wing** intended for interception. The Su-9 is that second branch, designed to stop American bombers at high altitude.\n\n## Design\nA pure 57° delta wing and a nose intake with a movable centre cone housing the radar. Like the contemporary American F-102, it carried **no gun at all**: four beam-riding missiles and nothing else. Its radius was very short, but the aircraft was designed to be guided from the ground all the way to contact.\n\n## Operational career\nEleven hundred and fifty aircraft served Soviet air defence exclusively — the Su-9 was never exported, not even to Warsaw Pact countries. It was a Su-9 that unsuccessfully chased Francis Gary Powers’s U-2 on **1 May 1960**, having no weapons available that day; the aircraft was brought down by a surface-to-air missile instead.\n\n## Place in history\nThe Su-9 founded the Sukhoi interceptor family: the **Su-11** derives directly from it, then the twin-engine **Su-15**, which replaced it in the 1970s. Its delta wing and intake cone remained the firm’s signature for twenty years.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1953-01-01',
    '1956-05-26',
    '1959-01-01',
    2135.0,
    1350.0,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-9'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Su-9'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Su-9'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-9'), (SELECT id FROM armement WHERE name = 'RS-2US'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-9'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Su-9'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-9'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 18.06,
  wingspan          = 8.54,
  height            = 4.82,
  wing_area         = 34.0,
  empty_weight      = 7675,
  mtow              = 13500,
  service_ceiling   = 16760,
  climb_rate        = 138,
  g_limit_pos       = 7.0,
  g_limit_neg       = NULL,
  combat_radius     = 550,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Lyulka AL-7F-1',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 66.6,
  thrust_wet        = 94.1,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1962,
  units_built       = 1150,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Su-9** : version de série, quatre missiles RS-2US\n- **Su-11** : évolution à radar Oriol et missiles R-8, nez allongé\n- **Su-9U** : biplace d''entraînement\n- **T-431** : cellule modifiée ayant battu les records d''altitude et de vitesse en 1962',
  variants_en       = E'- **Su-9** : production version with four RS-2US missiles\n- **Su-11** : evolution with Oriol radar and R-8 missiles, lengthened nose\n- **Su-9U** : two-seat trainer\n- **T-431** : modified airframe that set altitude and speed records in 1962',

  -- Strate 4 : qualitatif
  nickname          = 'Fishpot',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soukho%C3%AF_Su-9',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Sukhoi_Su-9',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alf van Beem',
  image_licence     = 'Public domain'
WHERE name = 'Su-9';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Su-9';
