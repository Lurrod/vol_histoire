-- Dassault Mirage G8
--
-- Photo : Dassault Mirage G8 ‘01’ (53426345971).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3ADassault_Mirage_G8_%E2%80%9801%E2%80%99_%2853426345971%29.jpg

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
    'Mirage G8',
    'Mirage G8',
    'Dassault Mirage G8',
    'Dassault Mirage G8',
    'Le seul Mirage à géométrie variable, sacrifié au budget',
    'The only swing-wing Mirage, sacrificed to the budget',
    '/assets/airplanes/mirage-g8.jpg',
    E'## Genèse\nLa fin des années 1960 croit à la **géométrie variable** : l''aile déployée pour décoller court et voler loin, repliée pour foncer. Les Américains lancent le F-111, les Soviétiques le MiG-23, les Européens négocient l''AFVG franco-britannique. La France se retire de ce dernier en 1967 mais conserve la technologie et charge Dassault de la mener seul.\n\n## Conception\nLe Mirage G abandonne le delta caractéristique de la maison pour une aile pivotant de **vingt à soixante-dix degrés** — la plus grande amplitude jamais essayée en France. Déployée, elle permet de décoller en cinq cents mètres ; repliée, elle autorise Mach 2,3. Les versions G4 puis G8 adoptent deux **Atar 9K-50** et un radar Cyrano, faisant du démonstrateur un véritable intercepteur.\n\n## Carrière opérationnelle\nAucune. Trois cellules, dont le G d''origine détruit en janvier 1971. Le **13 juillet 1973**, le G8 atteint **Mach 2,34** — vitesse la plus élevée jamais atteinte par un avion de conception européenne, record qui tient encore. L''armée de l''air est convaincue et envisage une commande.\n\n## Place dans l''histoire\nTrois exemplaires. Le mécanisme de pivot coûte cher, alourdit la cellule de près de deux tonnes et complique l''entretien. En 1975, la France arbitre : elle abandonne la géométrie variable et commande le **Mirage 2000**, delta simple et bien moins cher. Le G8 est aujourd''hui au musée du Bourget, aile repliée.',
    E'## Genesis\nThe late 1960s believed in **variable geometry**: the wing spread to take off short and fly far, swept to dash. The Americans launched the F-111, the Soviets the MiG-23, the Europeans negotiated the Anglo-French AFVG. France withdrew from the latter in 1967 but kept the technology and told Dassault to carry it alone.\n\n## Design\nThe Mirage G abandoned the house delta for a wing pivoting from **twenty to seventy degrees** — the widest range ever tried in France. Spread, it allows a five-hundred-metre take-off; swept, it permits Mach 2.3. The G4 and then G8 versions adopted two **Atar 9K-50s** and a Cyrano radar, turning the demonstrator into a real interceptor.\n\n## Operational career\nNone. Three airframes, of which the original G was destroyed in January 1971. On **13 July 1973** the G8 reached **Mach 2.34** — the highest speed ever attained by a European-designed aircraft, a record that still stands. The air force was convinced and considered an order.\n\n## Place in history\nThree built. The pivot mechanism is expensive, adds nearly two tonnes to the airframe and complicates maintenance. In 1975 France decided: it dropped variable geometry and ordered the **Mirage 2000**, a simple delta and far cheaper. The G8 sits today at the Le Bourget museum, wings swept.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1965-01-01',
    '1971-05-08',
    NULL,
    2495.0,
    3800.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage G8'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Mirage G8'), (SELECT id FROM tech WHERE name = 'Radar Cyrano'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage G8'), (SELECT id FROM armement WHERE name = 'DEFA 553')),
((SELECT id FROM airplanes WHERE name = 'Mirage G8'), (SELECT id FROM armement WHERE name = 'Matra Super 530F')),
((SELECT id FROM airplanes WHERE name = 'Mirage G8'), (SELECT id FROM armement WHERE name = 'Matra R550 Magic'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage G8'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Mirage G8'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Mirage G8'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 18.8,
  wingspan          = 15.4,
  height            = 5.35,
  wing_area         = 37.0,
  empty_weight      = 13500,
  mtow              = 23800,
  service_ceiling   = 18000,
  climb_rate        = 270.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA Atar 9K-50',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 49.2,
  thrust_wet        = 70.6,

  -- Strate 3 : production & service
  production_start  = 1967,
  production_end    = 1971,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Mirage G** : premier démonstrateur biplace, 1967, détruit en 1971\n- **Mirage G4 puis G8** : versions bimoteurs, deux exemplaires construits\n- Aile pivotant de **20° à 70°**, la plus grande plage de flèche testée en France\n- Atteint **Mach 2,34** le 13 juillet 1973, record de vitesse pour un avion européen\n- Abandonné en 1975 : trop cher, remplacé au programme par le **Mirage 2000**',
  variants_en       = E'- **Mirage G** : first two-seat demonstrator, 1967, destroyed in 1971\n- **Mirage G4 then G8** : twin-engined versions, two aircraft built\n- Wing pivoting from **20° to 70°**, the widest sweep range tested in France\n- Reached **Mach 2.34** on 13 July 1973, a speed record for a European aircraft\n- Abandoned in 1975: too expensive, replaced in the programme by the **Mirage 2000**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_Mirage_G',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_Mirage_G',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Mirage G8';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mirage G8';
