-- Lockheed Martin X-55 Advanced Composite Cargo Aircraft
--
-- Photo : Lockheed Martin X-55 ACCA 001.jpg
--   licence Public domain — NASA/DFRC/Carla Thomas
--   https://commons.wikimedia.org/wiki/File:Lockheed_Martin_X-55_ACCA_001.jpg

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
    'Lockheed Martin X-55',
    'Lockheed Martin X-55',
    'Lockheed Martin X-55 Advanced Composite Cargo Aircraft',
    'Lockheed Martin X-55 Advanced Composite Cargo Aircraft',
    'Un Dornier 328JET doté aux Skunk Works d''un fuselage neuf en composites, pour réinventer la fabrication des cargos',
    'A Dornier 328JET given a new composite fuselage by the Skunk Works, to rethink how cargo aircraft are built',
    '/assets/airplanes/x55-acca.jpg',
    E'## Genèse\nLe laboratoire de recherche de l''US Air Force, l''**Air Force Research Laboratory**, veut démontrer de nouvelles capacités pour les avions cargo grâce aux composites avancés. Son programme **Advanced Composite Cargo Aircraft** (ACCA) oppose **Lockheed Martin** à Aurora Flight Sciences, dont le projet repose sur un **Antonov An-72** ; en 2007, la proposition de Lockheed Martin l''emporte. L''avion est un exemplaire unique, construit aux **Skunk Works** de Palmdale, en Californie, sans aucun projet de série : il s''agit de prouver une méthode de fabrication, pas de lancer un nouveau cargo.\n\n## Conception\nLe point de départ est un biréacteur régional à aile haute, le **Fairchild Dornier 328JET**. Derrière la porte d''entrée, tout son fuselage en alliage d''aluminium est remplacé par une section neuve en composites, fabriquée d''une seule pièce dérive comprise : deux demi-coques à peu près ovales, en forme de canoë, collées sur des cadres circulaires. Les matériaux retenus polymérisent hors autoclave, à des températures et des pressions plus basses que les composites précédents. Une fois raccordé au nez métallique d''origine par des fixations, le fuselage élargi mesure 16,8 m de long pour 2,74 m de diamètre et reçoit une rampe de chargement arrière. Deux turboréacteurs double flux Pratt & Whitney Canada PW306B propulsent l''avion.\n\n## Essais\nEn avril 2008, le fuselage est en cours de fabrication et le premier vol est attendu pour l''hiver 2008-2009. Un collage insuffisant du revêtement sur la partie inférieure oblige pourtant à fabriquer un second fuselage, et le calendrier glisse. L''avion vole finalement le 2 juin 2009 à l''Air Force Plant 42 de Palmdale, mené par l''AFRL avec Lockheed Martin, puis reçoit en octobre 2009 la désignation X-55A. Le programme prévoit quinze à vingt vols.\n\n## Place dans l''histoire\nLe X-55 est un avion X d''un genre particulier : son enjeu n''est ni la vitesse ni la furtivité, mais la manière de construire. Selon les estimations, il a été réalisé pour moitié moins cher qu''un appareil comparable de conception classique, ce qui était précisément la démonstration attendue d''une grande structure de transport en composites. Depuis le 12 septembre 2014, il est exposé au **Joe Davies Heritage Airpark** de Palmdale, en Californie.',
    E'## Genesis\nThe US Air Force''s research arm, the **Air Force Research Laboratory**, wanted to demonstrate new air cargo capabilities using advanced composite materials. Its **Advanced Composite Cargo Aircraft** (ACCA) programme pitted **Lockheed Martin** against Aurora Flight Sciences, whose design was based on the **Antonov An-72**; in 2007 Lockheed Martin''s proposal won. The aircraft was a one-off, built at the **Skunk Works** in Palmdale, California, with no plans for production: the point was to prove a manufacturing method, not to launch a new freighter.\n\n## Design\nThe starting point was a high-wing regional twinjet, the **Fairchild Dornier 328JET**. Aft of the entrance door, its aluminium alloy fuselage was replaced by a new composite section, built as a single component including the fin: two roughly oval, canoe-shaped halves bonded to circular frames. The chosen materials cured out of autoclave, at lower temperatures and pressures than earlier composites. Once fastened to the original metal nose, the widened fuselage measured 16.8 m long and 2.74 m in diameter and gained a rear loading ramp. Two Pratt & Whitney Canada PW306B turbofans powered the aircraft.\n\n## Testing\nIn April 2008 the fuselage was being fabricated and the first flight was expected in the winter of 2008-2009. An unsatisfactory bond of the skin on the lower fuselage, however, forced a second fuselage to be built, and the schedule slipped. The aircraft finally flew on 2 June 2009 at Air Force Plant 42 in Palmdale, flown by the AFRL with Lockheed Martin, and in October 2009 it was designated X-55A. The programme called for fifteen to twenty flights.\n\n## Place in history\nThe X-55 is an X-plane of an unusual kind: what it tested was neither speed nor stealth, but the way aircraft are built. It is estimated to have cost half as much as a conventionally designed aircraft of similar size, which was exactly the demonstration expected of a large composite transport structure. Since 12 September 2014 it has been on display at the **Joe Davies Heritage Airpark** in Palmdale, California.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2007-01-01',
    '2009-06-02',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-55'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-55'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-55'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PW306B',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Fairchild Dornier 328JET** : avion de départ, dont le nez métallique est conservé\n- **Fuselage composite** d''une seule pièce, dérive comprise, avec rampe de chargement arrière\n- **Second fuselage** fabriqué après un défaut de collage du premier\n- **X-55A** : désignation attribuée en octobre 2009, quatre mois après le premier vol',
  variants_en       = E'- **Fairchild Dornier 328JET**: base aircraft, whose metal nose was retained\n- **Composite fuselage** in a single piece, fin included, with a rear loading ramp\n- **Second fuselage** built after a bonding defect on the first\n- **X-55A**: designation given in October 2009, four months after the first flight',

  -- Strate 4 : qualitatif
  nickname          = 'ACCA',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_Martin_X-55',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_Martin_X-55',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Carla Thomas, NASA',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed Martin X-55';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed Martin X-55';
