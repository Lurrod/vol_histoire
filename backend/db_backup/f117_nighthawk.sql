-- Lockheed F-117 Nighthawk
--
-- Photo : F-117 Nighthawk Front.jpg
--   licence Public domain — Staff Sgt. Aaron Allmon II
--   https://commons.wikimedia.org/wiki/File%3AF-117_Nighthawk_Front.jpg

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
    'F-117 Nighthawk',
    'F-117 Nighthawk',
    'Lockheed F-117 Nighthawk',
    'Lockheed F-117 Nighthawk',
    'Premier avion furtif opérationnel au monde',
    'The world’s first operational stealth aircraft',
    '/assets/airplanes/f117-nighthawk.jpg',
    E'## Genèse\nÀ la fin des années 1970, l''US Air Force cherche à pénétrer les défenses antiaériennes soviétiques, devenues quasi imperméables aux bombardiers classiques. Le programme secret **Senior Trend** part des travaux du mathématicien soviétique **Piotr Oufimtsev**, dont les équations sur la diffraction des ondes avaient été publiées librement à Moscou en 1964 — et ignorées chez lui.\n\n## Conception\nFaute d''ordinateurs capables de modéliser des surfaces courbes, Lockheed **Skunk Works** conçoit un fuselage en **facettes planes** qui renvoient les ondes radar loin de leur émetteur. Le résultat est aérodynamiquement instable : quatre calculateurs de vol le maintiennent en l''air en permanence. Aucun radar embarqué, aucune postcombustion, des tuyères aplaties pour diluer la signature infrarouge : tout est sacrifié à la discrétion. La vitesse plafonne sous Mach 1.\n\n## Carrière opérationnelle\nOpérationnel dès 1983, son existence n''est reconnue qu''en **1988**. Baptême du feu au Panama en 1989, puis consécration lors de la **guerre du Golfe** : 2,5 % des sorties de la coalition, mais plus de 40 % des cibles stratégiques frappées, sans une seule perte. Un unique appareil sera abattu, au-dessus de la **Serbie** le 27 mars 1999, par un missile SA-3 dont les servants avaient adapté leur fréquence.\n\n## Place dans l''histoire\nRetiré en 2008 au profit du F-22 et du B-2, il a prouvé qu''un avion pouvait devenir presque invisible et a redéfini la planification aérienne occidentale. Quelques exemplaires continuent de voler discrètement au Nevada comme plastrons d''entraînement.',
    E'## Genesis\nBy the late 1970s the US Air Force needed a way through Soviet air defences that had become nearly impenetrable to conventional bombers. The classified **Senior Trend** programme built on the work of Soviet mathematician **Pyotr Ufimtsev**, whose equations on wave diffraction had been openly published in Moscow in 1964 — and ignored at home.\n\n## Design\nLacking computers able to model curved surfaces, Lockheed **Skunk Works** designed a fuselage of **flat facets** that bounce radar waves away from their source. The result is aerodynamically unstable: four flight computers keep it flying at all times. No onboard radar, no afterburner, flattened exhausts to spread the infrared signature — everything is sacrificed to discretion. Top speed stays below Mach 1.\n\n## Operational career\nOperational from 1983, its existence was only acknowledged in **1988**. It saw first combat over Panama in 1989, then came into its own in the **Gulf War**: 2.5% of coalition sorties but more than 40% of the strategic targets struck, without a single loss. One aircraft was shot down over **Serbia** on 27 March 1999 by an SA-3 crew that had adapted their radar frequency.\n\n## Place in history\nRetired in 2008 in favour of the F-22 and B-2, it proved an aircraft could become nearly invisible and reshaped Western air planning. A handful still fly quietly over Nevada as training aggressors.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1978-11-01',
    '1981-06-18',
    '1983-10-15',
    993.0,
    1720.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM tech WHERE name = 'Soute à armement pressurisée')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric F404'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM armement WHERE name = 'GBU-10 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM armement WHERE name = 'GBU-27 Paveway III')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM armement WHERE name = 'B61'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.09,
  wingspan          = 13.2,
  height            = 3.78,
  wing_area         = 73.0,
  empty_weight      = 13380,
  mtow              = 23814,
  service_ceiling   = 13716,
  climb_rate        = NULL,
  g_limit_pos       = 6.0,
  g_limit_neg       = NULL,
  combat_radius     = 860,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F404-F1D2',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux sans postcombustion',
  engine_type_en    = 'Non-afterburning turbofan',
  thrust_dry        = 48.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1981,
  production_end    = 1990,
  units_built       = 64,
  unit_cost_usd     = 42600000,
  unit_cost_year    = 1983,
  operators_count   = 1,
  variants          = E'- **YF-117A** : cinq prototypes d''essai\n- **F-117A** : version de série, 59 exemplaires\n- **Programme Senior Trend** : désignation officielle du développement secret',
  variants_en       = E'- **YF-117A** : five test prototypes\n- **F-117A** : production version, 59 built\n- **Senior Trend programme** : official designation of the classified development effort',

  -- Strate 4 : qualitatif
  nickname          = 'Wobblin’ Goblin',

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_F-117_Nighthawk',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_F-117_Nighthawk',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. Aaron Allmon II',
  image_licence     = 'Public domain'
WHERE name = 'F-117 Nighthawk';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'tres_elevee' WHERE name = 'F-117 Nighthawk';
