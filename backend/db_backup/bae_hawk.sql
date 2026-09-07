-- BAE Systems Hawk
--
-- Photo : Hawk - RIAT 2011 (6122004254).jpg
--   licence CC BY-SA 2.0 — Tim Felce (Airwolfhound)
--   https://commons.wikimedia.org/wiki/File%3AHawk_-_RIAT_2011_%286122004254%29.jpg

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
    'BAE Hawk',
    'BAE Hawk',
    'BAE Systems Hawk',
    'BAE Systems Hawk',
    'Avion d’entraînement avancé et d’attaque légère le plus exporté d’Europe',
    'Europe’s most-exported advanced trainer and light attack aircraft',
    '/assets/airplanes/bae-hawk.jpg',
    E'## Genèse\nAu début des années 1970, la RAF cherche à remplacer deux appareils par un seul : le Gnat d''entraînement avancé et le Hunter d''entraînement aux armes. Hawker Siddeley propose le HS.1182, conçu d''emblée pour être simple à maintenir et bon marché à l''heure de vol.\n\n## Conception\nAile en flèche légère à faible allongement, réacteur unique sans postcombustion, cockpit en tandem avec un siège arrière surélevé qui donne à l''instructeur une vue réelle sur l''avant. Le Hawk vole honnêtement jusqu''à Mach 0,88 et supporte 8 g, ce qui permet d''y enseigner presque tout le domaine de vol d''un chasseur de combat pour une fraction du coût horaire.\n\n## Carrière opérationnelle\nPlus de **1 000 exemplaires** livrés à dix-huit forces aériennes. La RAF en fait la monture de sa patrouille acrobatique, les **Red Arrows**. L''US Navy en commande une version navalisée, le T-45 Goshawk — cas rare d''un avion d''entraînement européen adopté par l''aéronavale américaine. L''Inde, l''Australie, le Canada, l''Afrique du Sud et la Finlande l''utilisent également.\n\n## Place dans l''histoire\nCinquante ans de production continue. Sa réussite tient moins à ses performances qu''à une intuition juste : dans une flotte moderne, le coût de formation d''un pilote pèse autant que le prix de son avion de combat.',
    E'## Genesis\nIn the early 1970s the RAF wanted one aircraft to replace two: the Gnat advanced trainer and the Hunter weapons trainer. Hawker Siddeley offered the HS.1182, designed from the outset to be simple to maintain and cheap per flying hour.\n\n## Design\nA modestly swept, low aspect ratio wing, a single non-afterburning engine, and a tandem cockpit with a raised rear seat giving the instructor a genuine forward view. The Hawk flies honestly to Mach 0.88 and takes 8 g, which allows almost the entire flight envelope of a combat fighter to be taught at a fraction of the hourly cost.\n\n## Operational career\nMore than **1,000 delivered** to eighteen air forces. The RAF made it the mount of its display team, the **Red Arrows**. The US Navy ordered a navalised version, the T-45 Goshawk — a rare case of a European trainer adopted by American naval aviation. India, Australia, Canada, South Africa and Finland also operate it.\n\n## Place in history\nFifty years of continuous production. Its success owes less to performance than to a correct insight: in a modern air force, the cost of training a pilot weighs as much as the price of the fighter.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1968-01-01',
    '1974-08-21',
    '1976-11-01',
    1037.0,
    2520.0,
    (SELECT id FROM manufacturer WHERE code = 'BAE'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce/Turbomeca Adour')),
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM armement WHERE name = 'CRV7'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'BAE Hawk'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.96,
  wingspan          = 9.94,
  height            = 3.98,
  wing_area         = 16.7,
  empty_weight      = 4400,
  mtow              = 9100,
  service_ceiling   = 13560,
  climb_rate        = 47,
  g_limit_pos       = 8.0,
  g_limit_neg       = -4.0,
  combat_radius     = 900,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Adour Mk 951',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 29.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1976,
  production_end    = NULL,
  units_built       = 1000,
  unit_cost_usd     = 26000000,
  unit_cost_year    = 2013,
  operators_count   = 18,
  variants          = E'- **Hawk T1** : version initiale de la RAF, monture des Red Arrows\n- **Hawk 200** : monoplace de combat léger avec radar\n- **T-45 Goshawk** : version navalisée de l''US Navy\n- **Hawk T2 / AJT** : cockpit numérique et simulation de capteurs embarquée',
  variants_en       = E'- **Hawk T1** : initial RAF version, mount of the Red Arrows\n- **Hawk 200** : single-seat light combat version with radar\n- **T-45 Goshawk** : navalised US Navy version\n- **Hawk T2 / AJT** : digital cockpit with embedded sensor simulation',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/BAE_Systems_Hawk',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/BAE_Systems_Hawk',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Tim Felce (Airwolfhound)',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'BAE Hawk';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'BAE Hawk';
