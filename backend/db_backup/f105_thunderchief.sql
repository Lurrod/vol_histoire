-- Republic F-105 Thunderchief
--
-- Photo : Republic F-105D-30-RE (SN 62-4234) in flight with full bomb load 060901-F-1234S-013.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3ARepublic_F-105D-30-RE_%28SN_62-4234%29_in_flight_with_full_bomb_load_060901-F-1234S-013.jpg

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
    'F-105 Thunderchief',
    'F-105 Thunderchief',
    'Republic F-105 Thunderchief',
    'Republic F-105 Thunderchief',
    'Chasseur-bombardier lourd, cheval de bataille du Vietnam',
    'Heavy fighter-bomber, workhorse of the Vietnam War',
    '/assets/airplanes/f105-thunderchief.jpg',
    E'## Genèse\nConçu comme un bombardier nucléaire tactique capable de pénétrer à très basse altitude et à vitesse supersonique, le F-105 est le plus gros monoréacteur monoplace de combat jamais construit. Sa **soute interne**, prévue pour une arme nucléaire, sera presque toujours utilisée pour un réservoir supplémentaire.\n\n## Conception\nSes entrées d''air en flèche vers l''avant, caractéristiques, optimisent l''écoulement à haute vitesse. Lourd, rapide et stable en basse altitude, il est en revanche peu manœuvrant : ses pilotes le surnomment le **Thud**. Il emporte jusqu''à 6,4 tonnes de bombes, davantage qu''une forteresse volante de la Seconde Guerre mondiale.\n\n## Carrière opérationnelle\nLe F-105 assure environ **75 % des frappes** de l''US Air Force sur le Nord-Vietnam. Le prix est terrible : **334 appareils perdus** sur 833 construits, le taux d''attrition le plus élevé de la guerre. C''est aussi sur F-105F/G que naissent les **Wild Weasels**, ces équipages qui se laissent délibérément accrocher par un radar SAM pour le localiser et le détruire — une mission inventée pour lui et toujours pratiquée aujourd''hui.\n\n## Place dans l''histoire\nRetiré dès 1984, il a été remplacé dans la frappe tactique par le F-111 puis le F-15E. Son héritage n''est pas l''appareil lui-même mais une doctrine : la suppression des défenses aériennes ennemies est devenue depuis un préalable obligatoire à toute campagne aérienne occidentale.',
    E'## Genesis\nDesigned as a tactical nuclear bomber able to penetrate at very low altitude and supersonic speed, the F-105 is the largest single-seat, single-engine combat aircraft ever built. Its **internal bay**, intended for a nuclear weapon, was almost always used for an extra fuel tank instead.\n\n## Design\nIts distinctive forward-swept intakes optimise airflow at high speed. Heavy, fast and steady at low level, it was not agile: its crews nicknamed it the **Thud**. It could carry up to 6.4 tonnes of bombs — more than a Second World War heavy bomber.\n\n## Operational career\nThe F-105 flew roughly **75% of US Air Force strikes** against North Vietnam. The cost was brutal: **334 aircraft lost** out of 833 built, the highest attrition rate of the war. It was also on the F-105F/G that the **Wild Weasels** were born — crews who deliberately let a SAM radar lock onto them in order to locate and destroy it, a mission invented for this aircraft and still flown today.\n\n## Place in history\nRetired in 1984, it was succeeded in tactical strike by the F-111 and then the F-15E. Its legacy is not the aircraft itself but a doctrine: suppression of enemy air defences has since become a mandatory opening move in every Western air campaign.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1951-01-01',
    '1955-10-22',
    '1958-05-27',
    2208.0,
    3550.0,
    (SELECT id FROM manufacturer WHERE code = 'REP'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM armement WHERE name = 'AGM-45 Shrike')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM armement WHERE name = 'AGM-78 Standard ARM')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM armement WHERE name = 'B61')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.63,
  wingspan          = 10.65,
  height            = 5.99,
  wing_area         = 35.8,
  empty_weight      = 12470,
  mtow              = 23967,
  service_ceiling   = 14800,
  climb_rate        = 195,
  g_limit_pos       = 8.67,
  g_limit_neg       = -3.0,
  combat_radius     = 1250,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J75-P-19W',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 76.5,
  thrust_wet        = 118.0,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1964,
  units_built       = 833,
  unit_cost_usd     = 2140000,
  unit_cost_year    = 1960,
  operators_count   = 1,
  variants          = E'- **F-105B** : première version de série\n- **F-105D** : version principale, tout-temps, radar de navigation-attaque\n- **F-105F** : biplace de conversion\n- **F-105G Wild Weasel** : suppression des défenses antiaériennes',
  variants_en       = E'- **F-105B** : first production version\n- **F-105D** : main all-weather version with nav-attack radar\n- **F-105F** : two-seat conversion trainer\n- **F-105G Wild Weasel** : suppression of enemy air defences',

  -- Strate 4 : qualitatif
  nickname          = 'Thud',

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Republic_F-105_Thunderchief',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Republic_F-105_Thunderchief',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'F-105 Thunderchief';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-105 Thunderchief';
