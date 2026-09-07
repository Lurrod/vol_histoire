-- Douglas A-26 / B-26 Invader
--
-- Photo : B-26 Invaders over Japan July 1950.JPEG
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3AB-26_Invaders_over_Japan_July_1950.JPEG

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
    'A-26 Invader',
    'A-26 Invader',
    'Douglas A-26 / B-26 Invader',
    'Douglas A-26 / B-26 Invader',
    'Seul bombardier américain engagé dans trois guerres successives',
    'The only American bomber committed to three successive wars',
    '/assets/airplanes/a26-invader.jpg',
    E'## Genèse\nDouglas conçoit l''Invader en 1940 pour remplacer d''un coup trois appareils : le A-20 d''attaque, le B-25 et le B-26 de bombardement moyen. Le pari est de faire aussi vite qu''un chasseur avec une soute de bombardier. Il aboutit — l''Invader est, à sa sortie, **le bombardier le plus rapide** de l''aviation américaine.\n\n## Conception\nAile laminaire de conception nouvelle, deux Double Wasp de deux mille chevaux, et un équipage réduit à trois hommes grâce à des **tourelles télécommandées** — le mitrailleur vise depuis un poste central au lieu d''occuper la tourelle. Le nez est interchangeable en quelques heures : vitré pour viser, ou plein et garni de huit mitrailleuses pour le mitraillage au sol.\n\n## Carrière opérationnelle\nIl arrive en Europe en 1944, bombarde l''Allemagne, puis revient en **Corée** où il vole essentiellement de nuit contre les convois. En **Indochine**, la France en reçoit une centaine. Au **Vietnam** enfin, la version B-26K modernisée patrouille la piste Hô Chi Minh jusqu''en 1969 — vingt-cinq ans après le premier vol de combat. Des Invader agissent aussi pour la CIA au Guatemala, à Cuba et au Congo.\n\n## Place dans l''histoire\nDeux mille cinq cent trois exemplaires, quinze forces aériennes, et un cas unique : **aucun autre bombardier américain n''a combattu dans la Seconde Guerre mondiale, en Corée et au Vietnam**. Sa longévité tient à une cellule surdimensionnée et à une mission — l''interdiction de nuit à basse altitude — que le passage à la réaction n''a pas su reprendre.',
    E'## Genesis\nDouglas designed the Invader in 1940 to replace three aircraft at once: the A-20 attack bomber and the B-25 and B-26 medium bombers. The gamble was to be as fast as a fighter with a bomber''s bay. It came off — on entering service the Invader was **the fastest bomber** in American aviation.\n\n## Design\nA new laminar-flow wing, two two-thousand-horsepower Double Wasps, and a crew cut to three thanks to **remotely controlled turrets** — the gunner aims from a central station instead of sitting in the turret. The nose is interchangeable within hours: glazed for aiming, or solid and packed with eight machine guns for strafing.\n\n## Operational career\nIt reached Europe in 1944 and bombed Germany, then returned over **Korea**, where it flew mostly at night against convoys. In **Indochina** France received about a hundred. Over **Vietnam** finally, the upgraded B-26K patrolled the Ho Chi Minh trail until 1969 — twenty-five years after its first combat flight. Invaders also operated for the CIA in Guatemala, Cuba and the Congo.\n\n## Place in history\nTwo thousand five hundred and three built, fifteen air forces, and a unique record: **no other American bomber fought in the Second World War, Korea and Vietnam**. Its longevity rests on an oversized airframe and on a mission — low-level night interdiction — that the move to jets never properly took over.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1940-01-01',
    '1942-07-10',
    '1944-05-19',
    571.0,
    2300.0,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.24,
  wingspan          = 21.34,
  height            = 5.64,
  wing_area         = 50.17,
  empty_weight      = 10147,
  mtow              = 12519,
  service_ceiling   = 6700,
  climb_rate        = 6.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 900,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-79 Double Wasp',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1942,
  production_end    = 1945,
  units_built       = 2503,
  unit_cost_usd     = 242595,
  unit_cost_year    = 1944,
  operators_count   = 15,
  variants          = E'- **A-26B** : nez plein garni de **huit mitrailleuses** de 12,7 mm\n- **A-26C** : nez vitré pour le bombardier-viseur\n- **B-26K Counter Invader** : refonte pour la contre-insurrection, ailes renforcées\n- Redésigné **B-26** en 1948, ce qui le confond avec le Martin B-26 Marauder, sans lien\n- Employé clandestinement à la **baie des Cochons** en 1961, insignes cubains peints',
  variants_en       = E'- **A-26B** : solid nose packed with **eight** 12.7 mm machine guns\n- **A-26C** : glazed nose for the bomb-aimer\n- **B-26K Counter Invader** : rebuilt for counter-insurgency, strengthened wings\n- Redesignated **B-26** in 1948, confusing it with the unrelated Martin B-26 Marauder\n- Used covertly at the **Bay of Pigs** in 1961, painted in Cuban markings',

  -- Strate 4 : qualitatif
  nickname          = 'Invader',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_A-26_Invader',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_A-26_Invader',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'A-26 Invader';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'A-26 Invader';
