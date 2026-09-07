-- AIDC AT-3 Tzu Chung
--
-- Photo : Thundertigers AT-3 Flight over Hualien AFB.jpg
--   licence CC BY-SA 4.0 — 玄史生
--   https://commons.wikimedia.org/wiki/File%3AThundertigers_AT-3_Flight_over_Hualien_AFB.jpg

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
    'AIDC AT-3 Tzu Chung',
    'AIDC AT-3 Tzu Chung',
    'AIDC AT-3 Tzu Chung',
    'AIDC AT-3 Tzu Chung',
    'Premier avion à réaction entièrement conçu à Taïwan',
    'The first jet aircraft designed entirely in Taiwan',
    '/assets/airplanes/aidc-at3.jpg',
    E'## Genèse\nEn 1975, Taïwan sait que son isolement diplomatique va lui couper l''accès aux avions américains — ce qui arrivera effectivement quatre ans plus tard, quand Washington reconnaîtra Pékin. L''île décide donc de construire elle-même, en commençant par le moins risqué : un **avion-école**. AIDC conçoit l''AT-3 avec l''assistance technique de Northrop, mais la cellule, elle, est entièrement taïwanaise.\n\n## Conception\nAile en flèche montée en position médiane, deux sièges en tandem surélevés pour la visibilité de l''instructeur, et surtout **deux réacteurs** là où la plupart des avions-école n''en ont qu''un — un choix coûteux mais qui offre une marge de sécurité au-dessus du détroit. Les TFE731, empruntés à l''aviation d''affaires, sont économiques et fiables. Cinq points d''emport et une soute ventrale amovible permettent d''en faire un appareil d''attaque léger.\n\n## Carrière opérationnelle\nSoixante-trois exemplaires forment depuis quarante ans tous les pilotes de chasse taïwanais, avant leur passage sur F-16, Mirage 2000 ou F-CK-1. L''appareil équipe également la patrouille acrobatique nationale, les **Thunder Tigers**. Il n''a jamais connu le combat, mais il n''a jamais cessé de voler.\n\n## Place dans l''histoire\nSa valeur n''est pas dans ses performances mais dans ce qu''il a rendu possible : c''est en le concevant qu''AIDC a formé les ingénieurs et bâti les méthodes qui donneront, dix ans plus tard, le **F-CK-1 Ching-kuo**, chasseur national né lui aussi de l''embargo. Un avion-école qui aura servi d''école à toute une industrie.',
    E'## Genesis\nIn 1975 Taiwan knew that its diplomatic isolation would cut off its access to American aircraft — which is exactly what happened four years later, when Washington recognised Beijing. The island therefore decided to build for itself, starting with the least risky option: a **training aircraft**. AIDC designed the AT-3 with technical assistance from Northrop, but the airframe itself is entirely Taiwanese.\n\n## Design\nA mid-mounted swept wing, two tandem seats stepped up for the instructor''s visibility, and above all **two engines** where most trainers have one — a costly choice, but one giving a margin of safety over the strait. The TFE731s, borrowed from business aviation, are economical and reliable. Five hardpoints and a removable belly bay allow it to serve as a light attack aircraft.\n\n## Operational career\nSixty-three aircraft have for forty years trained every Taiwanese fighter pilot before they move on to the F-16, Mirage 2000 or F-CK-1. The type also equips the national display team, the **Thunder Tigers**. It has never seen combat, but it has never stopped flying.\n\n## Place in history\nIts value lies not in its performance but in what it made possible: designing it was how AIDC trained the engineers and built the methods that would produce, ten years later, the **F-CK-1 Ching-kuo**, a national fighter likewise born of the embargo. A training aircraft that served as a school for an entire industry.',
    (SELECT id FROM countries WHERE code = 'TWN'),
    '1975-01-01',
    '1980-09-16',
    '1984-03-01',
    904.0,
    2280.0,
    (SELECT id FROM manufacturer WHERE code = 'AIDC'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'), (SELECT id FROM tech WHERE name = 'Réacteur Honeywell TFE731'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.9,
  wingspan          = 10.46,
  height            = 4.36,
  wing_area         = 21.93,
  empty_weight      = 3310,
  mtow              = 7938,
  service_ceiling   = 14625,
  climb_rate        = 50.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett TFE731-2-2L',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 31.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1982,
  production_end    = 1990,
  units_built       = 63,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **AT-3A** : version d''entraînement avancé standard\n- **AT-3B** : version d''attaque légère à conduite de tir et points d''emport renforcés\n- **AT-3 Tzu Chiang** : désignation employée pour la patrouille acrobatique Thunder Tigers\n- **XA-3 Lui Meng** : prototype d''attaque au sol dédié, resté sans suite\n- Modernisation avionique menée à partir de 2010 pour prolonger la flotte jusqu''en 2030',
  variants_en       = E'- **AT-3A** : the standard advanced training version\n- **AT-3B** : light attack version with fire control and strengthened hardpoints\n- **AT-3 Tzu Chiang** : designation used by the Thunder Tigers display team\n- **XA-3 Lui Meng** : dedicated ground attack prototype, taken no further\n- Avionics upgrade begun in 2010 to extend the fleet to 2030',

  -- Strate 4 : qualitatif
  nickname          = 'Tzu Chung',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/AIDC_AT-3',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AIDC_AT-3',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '玄史生',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'AIDC AT-3 Tzu Chung';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AIDC AT-3 Tzu Chung';
