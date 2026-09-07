-- North American F-100 Super Sabre
--
-- Photo : F-100 Airventure 2015.jpg
--   licence CC BY 2.0 — Michaela Pereckas
--   https://commons.wikimedia.org/wiki/File%3AF-100_Airventure_2015.jpg

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
    'F-100 Super Sabre',
    'F-100 Super Sabre',
    'North American F-100 Super Sabre',
    'North American F-100 Super Sabre',
    'Premier chasseur supersonique en palier de l’US Air Force',
    'First USAF fighter supersonic in level flight',
    '/assets/airplanes/f100-super-sabre.jpg',
    E'## Genèse\nSuccesseur direct du F-86 Sabre, le F-100 ouvre la **série des Century** de l''US Air Force. Il est le premier chasseur américain capable de franchir le mur du son en vol horizontal, sans piqué — quelques mois avant le MiG-19 soviétique.\n\n## Conception\nAile à 45° de flèche, entrée d''air frontale ovale, fuselage affiné selon la loi des aires. Cette recherche de vitesse a un prix : le F-100 est instable en lacet à haute incidence et se met en vrille sans prévenir, un phénomène que les pilotes baptisent le **Sabre Dance**. Les pertes à l''entraînement sont parmi les plus lourdes de l''histoire de l''USAF.\n\n## Carrière opérationnelle\nLe F-100 est le premier avion à réaction américain engagé au **Vietnam**, où il effectue plus de **360 000 sorties** — davantage que tous les P-51 Mustang de la Seconde Guerre mondiale réunis. Cantonné à l''appui au sol après l''arrivée des F-4 et F-105, il y termine sa carrière en 1971.\n\n## Place dans l''histoire\nC''est sur des F-100F biplaces que naissent les premiers équipages **Wild Weasel**, avant que la mission ne passe au F-105. Retiré de la Garde nationale en 1979, il aura servi de plastron radiocommandé jusqu''aux années 1980.',
    E'## Genesis\nDirect successor to the F-86 Sabre, the F-100 opened the US Air Force **Century series**. It was the first American fighter able to break the sound barrier in level flight rather than in a dive — a few months before the Soviet MiG-19.\n\n## Design\nA 45° swept wing, an oval nose intake and an area-ruled fuselage. That pursuit of speed came at a price: the F-100 was directionally unstable at high angles of attack and departed without warning, a behaviour pilots named the **Sabre Dance**. Training losses were among the heaviest in USAF history.\n\n## Operational career\nThe F-100 was the first American jet committed to **Vietnam**, where it flew more than **360,000 sorties** — more than every P-51 Mustang of the Second World War combined. Relegated to ground attack once F-4s and F-105s arrived, it ended its combat career there in 1971.\n\n## Place in history\nThe first **Wild Weasel** crews formed on two-seat F-100Fs before the mission passed to the F-105. Retired from the Air National Guard in 1979, it went on serving as a radio-controlled target drone into the 1980s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1949-01-01',
    '1953-05-25',
    '1954-09-27',
    1390.0,
    3210.0,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM armement WHERE name = 'M39')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM armement WHERE name = 'AGM-12 Bullpup')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM armement WHERE name = 'Zuni 127 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.2,
  wingspan          = 11.81,
  height            = 4.95,
  wing_area         = 35.8,
  empty_weight      = 9500,
  mtow              = 15800,
  service_ceiling   = 15000,
  climb_rate        = 111,
  g_limit_pos       = 7.33,
  g_limit_neg       = -3.0,
  combat_radius     = 885,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J57-P-21A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 47.6,
  thrust_wet        = 75.4,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1959,
  units_built       = 2294,
  unit_cost_usd     = 697000,
  unit_cost_year    = 1960,
  operators_count   = 8,
  variants          = E'- **F-100A** : chasseur de jour initial\n- **F-100C** : chasseur-bombardier, ravitaillable en vol\n- **F-100D** : version principale, la plus produite\n- **F-100F** : biplace ; les premiers *Wild Weasel* en dérivent',
  variants_en       = E'- **F-100A** : initial day fighter\n- **F-100C** : fighter-bomber with air refuelling\n- **F-100D** : main and most-produced version\n- **F-100F** : two-seat; the first *Wild Weasels* were derived from it',

  -- Strate 4 : qualitatif
  nickname          = 'Hun',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_F-100_Super_Sabre',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_F-100_Super_Sabre',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Michaela Pereckas',
  image_licence     = 'CC BY 2.0'
WHERE name = 'F-100 Super Sabre';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-100 Super Sabre';
