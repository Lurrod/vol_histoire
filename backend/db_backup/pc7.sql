-- Pilatus PC-7 Turbo Trainer
--
-- Photo : Austrian PC-7 3H-FK.jpg
--   licence CC BY 4.0 — GerardvdSchaaf
--   https://commons.wikimedia.org/wiki/File%3AAustrian_PC-7_3H-FK.jpg

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
    'Pilatus PC-7',
    'Pilatus PC-7',
    'Pilatus PC-7 Turbo Trainer',
    'Pilatus PC-7 Turbo Trainer',
    'Le turbopropulseur qui a rendu l’école à réaction inutile',
    'The turboprop that made the jet trainer unnecessary',
    '/assets/airplanes/pc7.jpg',
    E'## Genèse\nL''école à réaction coûte cher : carburant, entretien, infrastructure. Dans les années 1970, plusieurs forces aériennes s''aperçoivent qu''un **turbopropulseur** offre une réponse aux commandes et une consommation qui rendent le réacteur superflu pour la formation de base. Pilatus, qui produit déjà le P-3 à pistons, en tire la conclusion et le remotorise.\n\n## Conception\nUn PT6 de six cent cinquante chevaux, une verrière en deux parties, un train rentrant et une aile contrainte à **plus six et moins trois g**. La ressemblance avec un jet est délibérée : mêmes manœuvres, même préparation mentale, mais un coût horaire cinq à dix fois inférieur. Le PC-7 vole aussi plus longtemps sans se poser — deux mille six cents kilomètres de rayon d''action.\n\n## Carrière opérationnelle\nEnviron six cent cinquante exemplaires, vingt et une forces aériennes. Il est aussi armé et engagé pour de bon : le **Tchad** contre la Libye, le **Guatemala** et le **Mexique** contre des groupes armés intérieurs — usages qui vaudront à la Suisse neutre des débats parlementaires nourris sur ses exportations d''armement.\n\n## Place dans l''histoire\nSix cent cinquante exemplaires et une famille — **PC-9**, **PC-21** — qui domine aujourd''hui le marché mondial de la formation. Le PC-7 a lancé le mouvement général de retour au turbopropulseur qui a mis fin à la carrière du **T-37** et du **Jet Provost**.',
    E'## Genesis\nJet training is expensive: fuel, maintenance, infrastructure. In the 1970s several air forces realised that a **turboprop** offers control response and fuel consumption that make the jet engine unnecessary for basic training. Pilatus, already building the piston-engined P-3, drew the conclusion and re-engined it.\n\n## Design\nA six-hundred-and-fifty-horsepower PT6, a two-piece canopy, retractable gear and a wing stressed to **plus six and minus three g**. The resemblance to a jet is deliberate: the same manoeuvres, the same mental preparation, but an hourly cost five to ten times lower. The PC-7 also stays up longer — twenty-six hundred kilometres of range.\n\n## Operational career\nSome six hundred and fifty built, twenty-one air forces. It has also been armed and used in earnest: **Chad** against Libya, **Guatemala** and **Mexico** against internal armed groups — uses that would earn neutral Switzerland vigorous parliamentary debate over its arms exports.\n\n## Place in history\nSix hundred and fifty built and a family — **PC-9**, **PC-21** — that now dominates the world training market. The PC-7 started the general move back to the turboprop that ended the careers of the **T-37** and the **Jet Provost**.',
    (SELECT id FROM countries WHERE code = 'CHE'),
    '1966-01-01',
    '1978-08-18',
    '1979-01-01',
    412.0,
    2630.0,
    (SELECT id FROM manufacturer WHERE code = 'PIL'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-7'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-7'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-7'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-7'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-7'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.78,
  wingspan          = 10.4,
  height            = 3.21,
  wing_area         = 16.6,
  empty_weight      = 1330,
  mtow              = 2700,
  service_ceiling   = 10000,
  climb_rate        = 10.9,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = 800,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-25A',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1978,
  production_end    = NULL,
  units_built       = 650,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 21,
  variants          = E'- **PC-7** : version d''origine, dérivée du **P-3** à moteur à pistons\n- **PC-7 Mk II** : cellule de **PC-9** et moteur de PC-7, vendue à l''Afrique du Sud\n- **PC-9** puis **PC-21** : successeurs directs, plus puissants et plus chers\n- Vingt et une forces aériennes, dont l''**Autriche**, le **Mexique** et l''**Inde**\n- Utilisé au combat par le **Tchad**, le **Guatemala** et le **Mexique**',
  variants_en       = E'- **PC-7** : original version, derived from the piston-engined **P-3**\n- **PC-7 Mk II** : **PC-9** airframe with a PC-7 engine, sold to South Africa\n- **PC-9** then **PC-21** : direct successors, more powerful and more expensive\n- Twenty-one air forces, including **Austria**, **Mexico** and **India**\n- Used in combat by **Chad**, **Guatemala** and **Mexico**',

  -- Strate 4 : qualitatif
  nickname          = 'Turbo Trainer',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Pilatus_PC-7',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Pilatus_PC-7',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'GerardvdSchaaf',
  image_licence     = 'CC BY 4.0'
WHERE name = 'Pilatus PC-7';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Pilatus PC-7';
