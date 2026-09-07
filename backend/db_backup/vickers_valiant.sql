-- Vickers Valiant
--
-- Photo : Vickers Valiant B(K).1 1962.png
--   licence CC BY-SA 3.0 — Umeyou
--   https://commons.wikimedia.org/wiki/File%3AVickers_Valiant_B%28K%29.1_1962.png

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
    'Vickers Valiant',
    'Vickers Valiant',
    'Vickers Valiant',
    'Vickers Valiant',
    'Premier des trois V-bombers britanniques, et le premier retiré',
    'First of Britain’s three V-bombers, and the first withdrawn',
    '/assets/airplanes/vickers-valiant.jpg',
    E'## Genèse\nLe Valiant est la **solution de sécurité** du programme V-bomber : quand la RAF commande le Vulcan à aile delta et le Victor à aile en croissant, elle sait que ces deux paris technologiques peuvent échouer. Vickers propose un appareil conventionnel, livrable vite. Il vole trois ans avant les autres.\n\n## Conception\nAile en flèche classique, quatre Avon enterrés à l''emplanture, structure sans audace. Cette sobriété est son mérite et sa limite : il est prêt en 1955, mais ses performances plafonnent là où le Vulcan et le Victor progressent encore.\n\n## Carrière opérationnelle\nC''est le seul V-bomber à avoir largué une arme nucléaire réelle : les essais **Buffalo** en Australie et **Grapple** dans le Pacifique, entre 1956 et 1957. Il est aussi le seul à avoir bombardé en conventionnel, lors de la crise de **Suez** en 1956.\n\n## Place dans l''histoire\nSa carrière s''achève brutalement. Le passage forcé au vol à basse altitude, après l''apparition des missiles sol-air, impose à la voilure des contraintes pour lesquelles elle n''a pas été calculée : en 1964 des **fissures de fatigue** sont découvertes sur toute la flotte. Le Valiant est retiré en 1965, d''un seul coup, dix ans après son entrée en service.',
    E'## Genesis\nThe Valiant was the V-bomber programme’s **insurance policy**: when the RAF ordered the delta-winged Vulcan and the crescent-winged Victor, it knew both technological gambles could fail. Vickers offered a conventional aircraft, deliverable quickly. It flew three years before the others.\n\n## Design\nA conventional swept wing, four Avons buried at the roots, an unadventurous structure. That sobriety was its merit and its limit: it was ready in 1955, but its performance plateaued where the Vulcan and Victor were still improving.\n\n## Operational career\nIt is the only V-bomber to have dropped a live nuclear weapon: the **Buffalo** tests in Australia and **Grapple** in the Pacific, between 1956 and 1957. It is also the only one to have bombed conventionally, during the **Suez** crisis in 1956.\n\n## Place in history\nIts career ended abruptly. The forced switch to low-level flight, after surface-to-air missiles appeared, imposed loads on a wing never calculated for them: in 1964 **fatigue cracks** were found across the fleet. The Valiant was withdrawn in 1965, all at once, ten years after entering service.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1948-01-01',
    '1951-05-18',
    '1955-01-08',
    913.0,
    7245.0,
    (SELECT id FROM manufacturer WHERE code = 'VIC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers Valiant'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Vickers Valiant'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers Valiant'), (SELECT id FROM armement WHERE name = 'WE.177')),
((SELECT id FROM airplanes WHERE name = 'Vickers Valiant'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers Valiant'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Vickers Valiant'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Vickers Valiant'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers Valiant'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 32.99,
  wingspan          = 34.85,
  height            = 9.8,
  wing_area         = 219.4,
  empty_weight      = 34419,
  mtow              = 63500,
  service_ceiling   = 16500,
  climb_rate        = 20,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2400,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Avon RA.28',
  engine_count      = 4,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 45.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1957,
  units_built       = 107,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Valiant B.1** : bombardier nucléaire de série\n- **Valiant B(PR).1** : version mixte bombardement et reconnaissance photographique\n- **Valiant B(K).1** : version ravitailleur\n- Seul V-bomber à avoir **largué une arme nucléaire réelle**, lors des essais britanniques de 1956-1957',
  variants_en       = E'- **Valiant B.1** : production nuclear bomber\n- **Valiant B(PR).1** : combined bombing and photographic reconnaissance version\n- **Valiant B(K).1** : tanker version\n- The only V-bomber to have **dropped a live nuclear weapon**, during the British tests of 1956-1957',

  -- Strate 4 : qualitatif
  nickname          = 'Valiant',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Vickers_Valiant',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Vickers_Valiant',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Umeyou',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Vickers Valiant';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Vickers Valiant';
