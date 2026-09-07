-- Britten-Norman BN-2 Defender / Islander
--
-- Photo : ZH002 Britten-Norman Defender AL 2 British Armys 651 Sqdn landing at RAF Waddington (cropped).jpg
--   licence CC BY-SA 4.0 — Jerry Gunner
--   https://commons.wikimedia.org/wiki/File%3AZH002_Britten-Norman_Defender_AL_2_British_Armys_651_Sqdn_landing_at_RAF_Waddington_%28cropped%29.jpg

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
    'Britten-Norman Defender',
    'Britten-Norman Defender',
    'Britten-Norman BN-2 Defender / Islander',
    'Britten-Norman BN-2 Defender / Islander',
    'L’utilitaire d’île anglais devenu avion de renseignement',
    'The English island utility turned intelligence aircraft',
    '/assets/airplanes/bn-defender.jpg',
    E'## Genèse\nJohn Britten et Desmond Norman conçoivent en 1963, sur l''île de Wight, un bimoteur destiné à relier les petites îles britanniques : dix passagers, un train fixe, une piste de quatre cents mètres et une simplicité de tracteur agricole. L''**Islander** est un succès civil immédiat, et les militaires s''y intéressent pour les mêmes raisons.\n\n## Conception\nL''appareil est le contraire d''un avion militaire : aile haute rectangulaire sans dièdre, deux moteurs à pistons, portes latérales pour chaque rangée de sièges. La version **Defender** ajoute quatre points d''emport ; les versions de renseignement de l''armée britannique, elles, remplacent l''armement par une **boule optronique** et des capteurs d''écoute discrets.\n\n## Carrière opérationnelle\nPlus de mille trois cents exemplaires, une trentaine de forces armées. Les **Islander AL.1** et **Defender AL.2** du 651e escadron de l''Army Air Corps ont volé au-dessus de l''Irlande du Nord, des Balkans, de l''Irak et de l''Afghanistan — appareils volontairement anodins, ce qui est précisément l''intérêt pour une mission de surveillance.\n\n## Place dans l''histoire\nMille trois cents exemplaires et une production ouverte depuis **1965** — soixante et un ans. L''Islander est l''avion britannique le plus produit de l''après-guerre, toutes catégories confondues. Sa carrière militaire tient à une qualité rare : il ne ressemble pas à un avion militaire.',
    E'## Genesis\nJohn Britten and Desmond Norman designed in 1963, on the Isle of Wight, a twin to link Britain''s small islands: ten passengers, fixed gear, a four-hundred-metre strip and the simplicity of a farm tractor. The **Islander** was an immediate civil success, and the military took an interest for the same reasons.\n\n## Design\nThe aircraft is the opposite of a military design: a rectangular high wing with no dihedral, two piston engines, side doors for every row of seats. The **Defender** version adds four hardpoints; the British Army''s intelligence versions replace the armament with a **sensor ball** and discreet listening equipment.\n\n## Operational career\nMore than thirteen hundred built, some thirty armed forces. The **Islander AL.1** and **Defender AL.2** of 651 Squadron, Army Air Corps, have flown over Northern Ireland, the Balkans, Iraq and Afghanistan — deliberately unremarkable aircraft, which is precisely the point for a surveillance mission.\n\n## Place in history\nThirteen hundred built and a production run open since **1965** — sixty-one years. The Islander is the most produced post-war British aircraft in any category. Its military career rests on a rare quality: it does not look like a military aircraft.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1963-01-01',
    '1965-06-13',
    '1971-01-01',
    273.0,
    1400.0,
    (SELECT id FROM manufacturer WHERE code = 'BN'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Britten-Norman Defender'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Britten-Norman Defender'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Britten-Norman Defender'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Britten-Norman Defender'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.86,
  wingspan          = 14.94,
  height            = 4.18,
  wing_area         = 30.19,
  empty_weight      = 1866,
  mtow              = 3175,
  service_ceiling   = 4023,
  climb_rate        = 5.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming O-540-E4C5',
  engine_count      = 2,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1965,
  production_end    = NULL,
  units_built       = 1300,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 30,
  variants          = E'- **BN-2 Islander** : version civile d''origine, produite depuis 1965\n- **BN-2 Defender** : version militaire à quatre points d''emport\n- **Islander AL.1 / Defender AL.2** : versions de **renseignement de l''armée britannique**\n- **Maritime Defender** : version de surveillance côtière à radar de nez\n- Plus de **1 300 exemplaires** : le bimoteur léger britannique le plus produit',
  variants_en       = E'- **BN-2 Islander** : original civil version, in production since 1965\n- **BN-2 Defender** : military version with four hardpoints\n- **Islander AL.1 / Defender AL.2** : **British Army intelligence** versions\n- **Maritime Defender** : coastal surveillance version with a nose radar\n- More than **1,300 built**: the most produced British light twin',

  -- Strate 4 : qualitatif
  nickname          = 'Islander',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Britten-Norman_BN-2_Islander',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Britten-Norman_Defender',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jerry Gunner',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Britten-Norman Defender';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Britten-Norman Defender';
