-- Republic F-84F Thunderstreak
--
-- Photo : Republic F-84F Thunderstreak (52576636397).jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany, Germany
--   https://commons.wikimedia.org/wiki/File%3ARepublic_F-84F_Thunderstreak_%2852576636397%29.jpg

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
    'F-84F Thunderstreak',
    'F-84F Thunderstreak',
    'Republic F-84F Thunderstreak',
    'Republic F-84F Thunderstreak',
    'Chasseur-bombardier à aile en flèche, colonne vertébrale de l’OTAN des années 1950',
    'Swept-wing fighter-bomber, the backbone of 1950s NATO',
    '/assets/airplanes/f84-thunderstreak.jpg',
    E'## Genèse\nLe F-84 Thunderjet à aile droite s''est bien battu en Corée comme bombardier d''assaut, mais il y a cédé le ciel aux MiG-15. La leçon est claire : il faut la flèche. Republic entreprend donc en 1949 de greffer une **aile en flèche à 38,5°** et un empennage nouveau sur la cellule existante. On annonce un dérivé mineur ; il faudra en réalité redessiner soixante pour cent de l''appareil, et le programme prendra quatre ans de plus que prévu.\n\n## Conception\nAile en flèche, dérive haute, et surtout un réacteur **Sapphire britannique** construit sous licence par Wright, dont les difficultés de mise au point retarderont tout le programme. La cellule est robuste, lourde, taillée pour emporter des charges sous voilure plus que pour le combat tournoyant — un chasseur-bombardier assumé, capable de délivrer une arme nucléaire tactique par **bombardement en ressource**, la manœuvre qui permet au pilote de fuir avant la détonation.\n\n## Carrière opérationnelle\nIl n''a jamais servi dans l''US Air Force de première ligne bien longtemps, mais il a équipé la **France, la Belgique, les Pays-Bas, l''Italie, l''Allemagne, la Grèce et la Turquie**. Des F-84F français ont frappé les aérodromes égyptiens à **Suez** en 1956. Il a constitué, pendant une décennie, l''essentiel de la force de frappe tactique conventionnelle et nucléaire de l''Alliance en Europe.\n\n## Place dans l''histoire\nDeux mille sept cent treize exemplaires, dont la majorité cédés aux alliés européens. Son importance n''est pas technique — il n''a battu aucun record — mais politique : il a armé l''Europe de l''Ouest à un moment où elle n''avait pas encore d''industrie aéronautique reconstituée. Republic poussera la formule du chasseur-bombardier lourd jusqu''à son terme avec le **F-105 Thunderchief**.',
    E'## Genesis\nThe straight-wing F-84 Thunderjet fought well in Korea as a strike aircraft, but it surrendered the sky there to the MiG-15. The lesson was plain: it needed sweep. In 1949 Republic therefore set about grafting a **38.5° swept wing** and a new tail onto the existing airframe. It was announced as a minor derivative; in reality sixty per cent of the aircraft had to be redrawn, and the programme ran four years longer than planned.\n\n## Design\nA swept wing, a tall fin, and above all a **British Sapphire** engine built under licence by Wright, whose development troubles delayed the whole programme. The airframe is sturdy and heavy, cut out for carrying loads under the wing rather than for turning combat — an unashamed fighter-bomber, able to deliver a tactical nuclear weapon by **toss bombing**, the manoeuvre that lets the pilot escape before detonation.\n\n## Operational career\nIt never served long in the front-line US Air Force, but it equipped **France, Belgium, the Netherlands, Italy, Germany, Greece and Turkey**. French F-84Fs struck Egyptian airfields at **Suez** in 1956. For a decade it made up the bulk of the Alliance''s conventional and nuclear tactical strike force in Europe.\n\n## Place in history\nTwo thousand seven hundred and thirteen built, most of them handed to European allies. Its significance is not technical — it broke no records — but political: it armed Western Europe at a moment when the continent had not yet rebuilt its own aircraft industry. Republic would push the heavy fighter-bomber formula to its conclusion with the **F-105 Thunderchief**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1949-01-01',
    '1950-06-03',
    '1954-01-12',
    1118.0,
    1304.0,
    (SELECT id FROM manufacturer WHERE code = 'REP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-84F Thunderstreak'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-84F Thunderstreak'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'F-84F Thunderstreak'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'F-84F Thunderstreak'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'F-84F Thunderstreak'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-84F Thunderstreak'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-84F Thunderstreak'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'F-84F Thunderstreak'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-84F Thunderstreak'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.23,
  wingspan          = 10.24,
  height            = 4.39,
  wing_area         = 30.19,
  empty_weight      = 6273,
  mtow              = 12701,
  service_ceiling   = 14020,
  climb_rate        = 43.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 630,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Wright J65-W-3 Sapphire',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 32.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1952,
  production_end    = 1957,
  units_built       = 2713,
  unit_cost_usd     = 769000,
  unit_cost_year    = 1955,
  operators_count   = 13,
  variants          = E'- **F-84 Thunderjet** : le prédécesseur à aile droite, engagé en Corée\n- **F-84F Thunderstreak** : version à aile en flèche, celle de cette fiche\n- **RF-84F Thunderflash** : reconnaissance, entrées d''air déplacées en emplanture d''aile\n- **RF-84K FICON** : version expérimentale emportée sous un bombardier B-36\n- Sept pays de l''**OTAN** l''ont reçu au titre de l''aide militaire américaine',
  variants_en       = E'- **F-84 Thunderjet** : the straight-wing predecessor, committed in Korea\n- **F-84F Thunderstreak** : the swept-wing version, the subject of this entry\n- **RF-84F Thunderflash** : reconnaissance, with intakes moved to the wing roots\n- **RF-84K FICON** : experimental version carried beneath a B-36 bomber\n- Seven **NATO** countries received it under American military aid',

  -- Strate 4 : qualitatif
  nickname          = 'Hog',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Republic_F-84F_Thunderstreak',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Republic_F-84F_Thunderstreak',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clemens Vasters from Viersen, Germany, Germany',
  image_licence     = 'CC BY 2.0'
WHERE name = 'F-84F Thunderstreak';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-84F Thunderstreak';
