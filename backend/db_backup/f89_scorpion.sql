-- Northrop F-89 Scorpion
--
-- Photo : 59fis-f-89-goosebay.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3A59fis-f-89-goosebay.jpg

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
    'F-89 Scorpion',
    'F-89 Scorpion',
    'Northrop F-89 Scorpion',
    'Northrop F-89 Scorpion',
    'Seul avion de l’histoire à avoir tiré une roquette air-air nucléaire',
    'The only aircraft in history to have fired a nuclear air-to-air rocket',
    '/assets/airplanes/f89-scorpion.jpg',
    E'## Genèse\nTrois semaines après Hiroshima, l''US Air Force lance la spécification d''un chasseur de nuit capable de remplacer le P-61 Black Widow à hélices. La menace anticipée est précise : des bombardiers soviétiques traversant l''Arctique de nuit, par tous les temps. Northrop, qui a déjà construit le P-61, remporte le marché.\n\n## Conception\nAile droite fine montée bas, deux hommes en tandem, un radar volumineux dans le nez. La particularité tient aux **« decelerons »**, des ailerons fendus qui s''ouvrent en deux pour servir d''aérofreins — une invention Northrop qu''on retrouvera sur le B-2. L''appareil est lourd, peu manœuvrant, et sa carrière débute mal : une désintégration en vol au salon de Détroit en 1952 cloue toute la flotte au sol le temps de renforcer la voilure.\n\n## Carrière opérationnelle\nIl tient la défense aérienne du continent nord-américain et de l''Alaska pendant douze ans. Son moment reste le **19 juillet 1957** : au-dessus du site d''essais du Nevada, un F-89J tire une roquette AIR-2 Genie à charge nucléaire de 1,5 kilotonne, qui explose à cinq mille mètres. Cinq officiers se tiennent volontairement au sol sous le point d''explosion, sans protection, pour démontrer l''innocuité de l''essai. C''est le seul tir air-air nucléaire de l''histoire.\n\n## Place dans l''histoire\nMille cinquante-deux exemplaires, et une doctrine qui n''a heureusement jamais servi : détruire une formation entière de bombardiers d''un seul tir, sans avoir à viser. Le **F-102 Delta Dagger** lui succède avec une aile delta et un système de conduite de tir automatisé.',
    E'## Genesis\nThree weeks after Hiroshima the US Air Force issued the specification for a night fighter to replace the propeller-driven P-61 Black Widow. The anticipated threat was specific: Soviet bombers crossing the Arctic at night, in any weather. Northrop, which had already built the P-61, won the contract.\n\n## Design\nA thin straight wing mounted low, two men in tandem, a bulky radar in the nose. Its distinctive feature is the **“decelerons”**, split ailerons that open in two to act as airbrakes — a Northrop invention that would reappear on the B-2. The aircraft is heavy, not very agile, and its career began badly: an in-flight break-up at the 1952 Detroit air show grounded the whole fleet while the wing was strengthened.\n\n## Operational career\nIt held the air defence of the North American continent and Alaska for twelve years. Its defining moment remains **19 July 1957**: over the Nevada test site, an F-89J fired an AIR-2 Genie rocket with a 1.5-kiloton nuclear warhead, which detonated at five thousand metres. Five officers stood voluntarily on the ground beneath the burst, unprotected, to demonstrate the test was harmless. It is the only nuclear air-to-air shot in history.\n\n## Place in history\nOne thousand and fifty-two built, and a doctrine that mercifully never had to be used: destroy an entire bomber formation with a single shot, without needing to aim. The **F-102 Delta Dagger** succeeded it with a delta wing and an automated fire control system.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-08-28',
    '1948-08-16',
    '1950-09-01',
    1023.0,
    2200.0,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'), (SELECT id FROM armement WHERE name = 'AIR-2 Genie')),
((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'), (SELECT id FROM armement WHERE name = 'AIM-4 Falcon')),
((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'), (SELECT id FROM armement WHERE name = 'FFAR Mighty Mouse'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.41,
  wingspan          = 18.19,
  height            = 5.36,
  wing_area         = 56.3,
  empty_weight      = 11428,
  mtow              = 21400,
  service_ceiling   = 14995,
  climb_rate        = 45.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J35-A-35',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 32.0,
  thrust_wet        = 43.6,

  -- Strate 3 : production & service
  production_start  = 1950,
  production_end    = 1956,
  units_built       = 1052,
  unit_cost_usd     = 801602,
  unit_cost_year    = 1952,
  operators_count   = 1,
  variants          = E'- **F-89A / B / C** : versions initiales à six canons de 20 mm dans le nez\n- **F-89D** : armement remplacé par cent quatre roquettes en bidons de bout d''aile\n- **F-89H** : missiles guidés Falcon, première association radar-missile de l''US Air Force\n- **F-89J** : porteur de la roquette nucléaire **AIR-2 Genie**, version finale\n- Le **19 juillet 1957**, un F-89J tire un Genie à charge nucléaire au-dessus du Nevada',
  variants_en       = E'- **F-89A / B / C** : initial versions with six 20 mm cannon in the nose\n- **F-89D** : armament replaced by one hundred and four rockets in wingtip pods\n- **F-89H** : Falcon guided missiles, the US Air Force''s first radar-missile pairing\n- **F-89J** : carrier of the nuclear **AIR-2 Genie** rocket, the final version\n- On **19 July 1957** an F-89J fired a nuclear-armed Genie over Nevada',

  -- Strate 4 : qualitatif
  nickname          = 'Scorpion',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_F-89_Scorpion',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_F-89_Scorpion',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'F-89 Scorpion';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-89 Scorpion';
