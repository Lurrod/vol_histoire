-- Mikoyan MiG 1.44 (Projet MFI)
--
-- Photo : MiG144 left side.jpg
--   licence CC BY-SA 4.0 — Hornet Driver
--   https://commons.wikimedia.org/wiki/File%3AMiG144_left_side.jpg

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
    'MiG 1.44',
    'MiG 1.44',
    'Mikoyan MiG 1.44 (Projet MFI)',
    'Mikoyan MiG 1.44 (MFI Project)',
    'La réponse soviétique au F-22, achevée dix ans après la chute de l’URSS',
    'The Soviet answer to the F-22, finished ten years after the USSR fell',
    '/assets/airplanes/mig144.jpg',
    E'## Genèse\nLe programme **MFI** — chasseur multirôle de première ligne — est lancé en 1983, deux ans après l''ATF américain et pour la même raison : Moscou veut son appareil de cinquième génération avant que l''adversaire n''ait le sien. Mikoyan l''emporte sur Soukhoï et commence la construction en 1989.\n\n## Conception\nLa philosophie diffère radicalement de celle du F-22. Là où Lockheed sacrifie la manœuvrabilité à la furtivité, Mikoyan fait l''inverse : **canards** de grande surface, aile delta, double dérive inclinée et deux **AL-41F** à tuyères orientables — plus de trente-cinq tonnes de poussée. La furtivité est traitée par des revêtements absorbants plutôt que par la forme, ce qui coûte moins cher et rend moins.\n\n## Carrière opérationnelle\nAucune. La cellule est achevée en 1994 ; il n''y a plus d''argent. Elle reste immobilisée **six ans** dans un hangar de Joukovski, présentée à la presse en janvier 1999 pour tenter d''attirer un financement, puis volée deux fois seulement, les 29 février et 27 avril 2000.\n\n## Place dans l''histoire\nUn exemplaire, deux vols. Le programme est enterré au profit du **Su-57**, que Soukhoï propose moins ambitieux, plus furtif et surtout finançable. Le 1.44 reste le symbole d''une décennie où l''industrie aéronautique russe a survécu sans pouvoir produire — conçu contre le F-22, il aura volé neuf ans après lui.',
    E'## Genesis\nThe **MFI** programme — multirole front-line fighter — was launched in 1983, two years after the American ATF and for the same reason: Moscow wanted its fifth-generation aircraft before its opponent had one. Mikoyan beat Sukhoi and began construction in 1989.\n\n## Design\nThe philosophy differs radically from the F-22''s. Where Lockheed sacrificed manoeuvrability to stealth, Mikoyan did the reverse: large **canards**, a delta wing, canted twin fins and two **AL-41Fs** with vectoring nozzles — more than thirty-five tonnes of thrust. Stealth is handled by absorbent coatings rather than shaping, which costs less and delivers less.\n\n## Operational career\nNone. The airframe was completed in 1994; the money was gone. It sat **six years** in a hangar at Zhukovsky, shown to the press in January 1999 in an attempt to attract funding, then flown just twice, on 29 February and 27 April 2000.\n\n## Place in history\nOne built, two flights. The programme was buried in favour of the **Su-57**, which Sukhoi offered as less ambitious, stealthier and above all fundable. The 1.44 remains the symbol of a decade in which the Russian aircraft industry survived without being able to produce — conceived against the F-22, it flew nine years after it.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1983-01-01',
    '2000-02-29',
    NULL,
    3200.0,
    4000.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG 1.44'), (SELECT id FROM tech WHERE name = 'Aile delta-canard')),
((SELECT id FROM airplanes WHERE name = 'MiG 1.44'), (SELECT id FROM tech WHERE name = 'Moteurs à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'MiG 1.44'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG 1.44'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG 1.44'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.0,
  wingspan          = 15.0,
  height            = 4.5,
  wing_area         = 97.0,
  empty_weight      = 18000,
  mtow              = 35000,
  service_ceiling   = 17000,
  climb_rate        = NULL,
  g_limit_pos       = 9.0,
  g_limit_neg       = NULL,
  combat_radius     = 1200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Lyulka-Saturn AL-41F',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion et poussée vectorielle',
  engine_type_en    = 'Afterburning turbofan with thrust vectoring',
  thrust_dry        = 117.0,
  thrust_wet        = 176.0,

  -- Strate 3 : production & service
  production_start  = 1989,
  production_end    = 1994,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **1.44** : un seul exemplaire achevé, deux vols en 2000\n- Programme **MFI** lancé en 1983, cellule terminée en 1994, immobilisée six ans faute d''argent\n- **Canards**, delta et **double dérive inclinée** : la formule russe de la manœuvrabilité\n- **AL-41F** à poussée vectorielle, moteur le plus puissant jamais monté sur un chasseur russe\n- Abandonné au profit du **Su-57**, plus furtif et moins cher à développer',
  variants_en       = E'- **1.44** : a single completed aircraft, two flights in 2000\n- **MFI** programme launched 1983, airframe finished 1994, grounded six years for lack of funds\n- **Canards**, delta and **canted twin fins**: the Russian formula for manoeuvrability\n- **AL-41F** with thrust vectoring, the most powerful engine ever fitted to a Russian fighter\n- Abandoned in favour of the **Su-57**, stealthier and cheaper to develop',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mikoyan_Projet_1.44',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mikoyan_Project_1.44',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Hornet Driver',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'MiG 1.44';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'moderee' WHERE name = 'MiG 1.44';
