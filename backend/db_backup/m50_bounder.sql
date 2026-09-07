-- Miassichtchev M-50 (Bounder)
--
-- Photo : Myasischev M-50 ’12 blue’ (24615587547).jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany
--   https://commons.wikimedia.org/wiki/File%3AMyasishchev_M-50%2C_NATO_%22Bounder%22_%288911844529%29.jpg

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
    'Myasishchev M-50',
    'Myasishchev M-50',
    'Miassichtchev M-50 (Bounder)',
    'Myasishchev M-50 (Bounder)',
    'Bombardier supersonique montré une fois à un défilé, jamais mis au point',
    'Supersonic bomber shown once at a flypast, never brought to maturity',
    '/assets/airplanes/m50-bounder.jpg',
    E'## Genèse\nLe **M-4** de Miassichtchev, entré en service en 1955, n''a pas l''allonge pour atteindre l''Amérique et en revenir. Le bureau propose donc un successeur supersonique, capable de franchir les défenses à Mach 2. Le projet est immense pour une firme qui n''a que quelques années d''existence, et il arrive au pire moment : Khrouchtchev est en train de se convaincre que l''avenir appartient aux fusées.\n\n## Conception\nDelta pur, quatre réacteurs dont deux en bout d''aile, et un équipage réduit à **deux hommes** grâce à une automatisation poussée — le système de transfert de carburant gère seul le centrage, qui recule fortement au passage du mur. Le problème est le moteur : les VD-7 prévus ne sont pas prêts, et les moteurs de substitution ne permettront jamais d''atteindre le supersonique en palier.\n\n## Carrière opérationnelle\nAucune. Un seul exemplaire vole, onze fois. Sa seule apparition publique est aussi sa dernière sortie : le **9 juillet 1961**, il survole le défilé de Toushino escorté de deux MiG-21. Les observateurs occidentaux, impressionnés, en concluent que l''URSS dispose d''un bombardier supersonique opérationnel — l''appareil ne volera plus jamais. Le programme est arrêté la même année.\n\n## Place dans l''histoire\nUn exemplaire, onze vols, et une place singulière : celle d''un avion dont la principale fonction aura été d''exister aux yeux de l''adversaire. Il a contribué à entretenir en Occident la croyance en un *bomber gap* qui n''a jamais existé. Miassichtchev, lui, est dissous en 1960 ; son bureau est absorbé par Tchelomeï et se consacrera désormais aux missiles.',
    E'## Genesis\nMyasishchev''s **M-4**, in service from 1955, lacked the reach to strike America and return. The bureau therefore proposed a supersonic successor able to cross the defences at Mach 2. The project was vast for a firm only a few years old, and it came at the worst possible moment: Khrushchev was convincing himself that the future belonged to rockets.\n\n## Design\nA pure delta, four engines of which two on the wingtips, and a crew cut to **two men** through heavy automation — the fuel transfer system manages trim on its own, the centre of lift moving sharply aft through the sound barrier. The problem was the engine: the intended VD-7s were not ready, and the substitutes would never allow level supersonic flight.\n\n## Operational career\nNone. A single aircraft flew, eleven times. Its only public appearance was also its last outing: on **9 July 1961** it overflew the Tushino flypast escorted by two MiG-21s. Western observers, duly impressed, concluded that the USSR had an operational supersonic bomber — the aircraft never flew again. The programme was stopped that same year.\n\n## Place in history\nOne aircraft, eleven flights, and a singular place: that of an aeroplane whose main function was to exist in the adversary''s eyes. It helped sustain in the West a belief in a *bomber gap* that never existed. Myasishchev itself was dissolved in 1960; the bureau was absorbed by Chelomey and turned to missiles.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1954-01-01',
    '1959-10-27',
    NULL,
    1950.0,
    3150.0,
    (SELECT id FROM manufacturer WHERE code = 'MYA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-50'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-50'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-50'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-50'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 57.48,
  wingspan          = 35.1,
  height            = 8.25,
  wing_area         = 290.6,
  empty_weight      = 85000,
  mtow              = 200000,
  service_ceiling   = 16500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Dobrynin VD-7',
  engine_count      = 4,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 98.0,
  thrust_wet        = 137.0,

  -- Strate 3 : production & service
  production_start  = 1958,
  production_end    = 1960,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **M-50A** : unique exemplaire volant, réacteurs VD-7 de puissance insuffisante\n- **M-52** : version améliorée à empennage en T, achevée mais jamais autorisée à voler\n- **M-56** : projet de bombardier de Mach 3, resté sur la planche à dessin\n- Présenté au **défilé de Toushino** le 9 juillet 1961, escorté de deux MiG-21\n- Système de transfert de carburant automatique pour gérer le centrage en supersonique',
  variants_en       = E'- **M-50A** : the only flying aircraft, with VD-7 engines of insufficient power\n- **M-52** : improved version with a T-tail, completed but never cleared to fly\n- **M-56** : proposed Mach 3 bomber, never left the drawing board\n- Shown at the **Tushino flypast** on 9 July 1961, escorted by two MiG-21s\n- Automatic fuel transfer system to manage trim in supersonic flight',

  -- Strate 4 : qualitatif
  nickname          = 'Bounder',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Miassichtchev_M-50',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Myasishchev_M-50',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Myasishchev M-50';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Myasishchev M-50';
