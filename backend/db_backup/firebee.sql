-- Ryan BQM-34 / AQM-34 Firebee
--
-- Photo : BQM-34A Firebee I 1.JPEG
--   licence Public domain — SSGT DANIEL PEREZ
--   https://commons.wikimedia.org/wiki/File%3ABQM-34A_Firebee_I_1.JPEG

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
    'Ryan Firebee',
    'Ryan Firebee',
    'Ryan BQM-34 / AQM-34 Firebee',
    'Ryan BQM-34 / AQM-34 Firebee',
    'Le premier drone de reconnaissance de l’histoire, et le plus produit',
    'The first reconnaissance drone in history, and the most produced',
    '/assets/airplanes/firebee.jpg',
    E'## Genèse\nEn 1948, l''US Air Force veut une cible volante réaliste pour l''entraînement de ses artilleurs et de ses pilotes : quelque chose qui vole vite, haut, et qu''on peut détruire sans regret. Ryan livre le Firebee. Personne n''imagine alors que cette cible deviendra le premier drone de combat opérationnel de l''histoire.\n\n## Conception\nSept mètres de long, un petit turboréacteur, pas de train d''atterrissage : le Firebee est **largué en vol** sous l''aile d''un DC-130 Hercules et **récupéré au parachute**, cueilli en l''air par un hélicoptère. La cellule est réutilisable une vingtaine de fois. Le passage à la reconnaissance ne demande qu''un changement de charge utile : caméra à la place du matériel de détection.\n\n## Carrière opérationnelle\nPlus de sept mille exemplaires. La version **AQM-34 Lightning Bug** vole plus de **trois mille quatre cents missions** au-dessus du Nord-Vietnam et de la Chine entre 1964 et 1975, là où l''on ne veut pas risquer un pilote. Certains larguent des tracts, d''autres brouillent, d''autres servent de leurres — en 1971, un MiG-21 lancé à la poursuite d''un Lightning Bug s''écrase en tentant de le suivre.\n\n## Place dans l''histoire\nSept mille exemplaires, une production ouverte depuis **1951** : soixante-quinze ans, un record absolu. Le Firebee a établi tout le vocabulaire du drone militaire — largage, mission programmée, récupération, charge utile interchangeable — vingt-cinq ans avant que le mot ne devienne courant.',
    E'## Genesis\nIn 1948 the US Air Force wanted a realistic flying target for its gunners and pilots: something fast and high that could be destroyed without regret. Ryan delivered the Firebee. Nobody then imagined that this target would become the first operational combat drone in history.\n\n## Design\nSeven metres long, a small turbojet, no undercarriage: the Firebee is **air-launched** from under the wing of a DC-130 Hercules and **recovered by parachute**, plucked out of the air by helicopter. The airframe is reusable some twenty times. Converting it to reconnaissance takes only a payload change: a camera in place of the tracking gear.\n\n## Operational career\nMore than seven thousand built. The **AQM-34 Lightning Bug** version flew over **three thousand four hundred missions** over North Vietnam and China between 1964 and 1975, where no pilot could be risked. Some dropped leaflets, some jammed, some acted as decoys — in 1971 a MiG-21 chasing a Lightning Bug crashed trying to follow it.\n\n## Place in history\nSeven thousand built and a production line open since **1951**: seventy-five years, an absolute record. The Firebee established the whole vocabulary of the military drone — air launch, programmed mission, recovery, interchangeable payload — twenty-five years before the word became common currency.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1948-01-01',
    '1951-01-01',
    '1955-01-01',
    1110.0,
    1300.0,
    (SELECT id FROM manufacturer WHERE code = 'RYA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan Firebee'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan Firebee'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Ryan Firebee'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Ryan Firebee'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan Firebee'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'Ryan Firebee'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.01,
  wingspan          = 3.93,
  height            = 2.04,
  wing_area         = 3.3,
  empty_weight      = 680,
  mtow              = 1134,
  service_ceiling   = 18300,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 600,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Continental J69-T-29',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 8.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = NULL,
  units_built       = 7000,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **BQM-34 Firebee** : version cible, encore produite aujourd''hui\n- **AQM-34 Lightning Bug** : version de reconnaissance, plus de **3 400 missions** au Vietnam\n- Largué en vol d''un **DC-130 Hercules**, récupéré au parachute par hélicoptère\n- Premier drone à effectuer des missions de combat réelles, dès 1964\n- Un AQM-34 aurait été le **premier appareil à abattre un chasseur** en 1971, par leurre',
  variants_en       = E'- **BQM-34 Firebee** : target version, still in production today\n- **AQM-34 Lightning Bug** : reconnaissance version, over **3,400 sorties** in Vietnam\n- Air-launched from a **DC-130 Hercules**, recovered by parachute and helicopter\n- The first drone to fly real combat missions, from 1964\n- An AQM-34 is credited with the **first drone-caused fighter loss** in 1971, by decoy',

  -- Strate 4 : qualitatif
  nickname          = 'Lightning Bug',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Ryan_Firebee',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ryan_Firebee',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'SSGT DANIEL PEREZ',
  image_licence     = 'Public domain'
WHERE name = 'Ryan Firebee';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Ryan Firebee';
