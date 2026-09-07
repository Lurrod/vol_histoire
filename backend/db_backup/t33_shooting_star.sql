-- Lockheed T-33 Shooting Star
--
-- Photo : Arctic Thunder 160729-F-YH552-021 - edit1.jpg
--   licence Public domain — Alejandro Pena Edited by: FOX 52 and Bammesk
--   https://commons.wikimedia.org/wiki/File%3AArctic_Thunder_160729-F-YH552-021_-_edit1.jpg

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
    'T-33 Shooting Star',
    'T-33 Shooting Star',
    'Lockheed T-33 Shooting Star',
    'Lockheed T-33 Shooting Star',
    'Le jet d’entraînement le plus produit du monde occidental',
    'The most-produced jet trainer of the Western world',
    '/assets/airplanes/t33-shooting-star.jpg',
    E'## Genèse\nLockheed constate en 1947 un problème simple : on forme des pilotes sur des avions à hélice et on les lâche seuls, au premier vol, sur un chasseur à réaction. La solution l''est tout autant — allonger le fuselage du **F-80** de quatre-vingt-douze centimètres, y loger un second siège en tandem sous une verrière commune, et laisser l''élève et l''instructeur voler ensemble. L''appareil n''est pas conçu, il est dérivé ; c''est ce qui le rend immédiatement disponible.\n\n## Conception\nTout vient du chasseur : la même aile droite, le même J33, la même douceur. La cellule est délibérément **tolérante** — elle prévient avant de décrocher, encaisse les atterrissages ratés et pardonne les erreurs, exactement ce qu''on attend d''un avion-école. Deux réservoirs de bout d''aile portent l''autonomie à un niveau qui autorise les longues navigations.\n\n## Carrière opérationnelle\n**Trente-huit forces aériennes** l''ont employé, du Canada au Japon en passant par la Grèce, la Turquie et la moitié de l''Amérique latine. Il a formé les pilotes de la guerre de Corée, ceux du Vietnam, ceux de toute la guerre froide occidentale. En version armée, il a aussi combattu — la Bolivie et le Guatemala l''ont utilisé en appui au sol jusque dans les années 2000.\n\n## Place dans l''histoire\nSix mille cinq cent cinquante-sept exemplaires, soixante-neuf ans de service dans certaines forces, et un nombre de pilotes formés qu''on ne sait pas chiffrer. Aucun chasseur de sa génération n''a duré aussi longtemps. Le **T-38 Talon** lui succédera dans le rôle, mais le T-Bird restera l''avion sur lequel l''Occident a appris à voler en jet.',
    E'## Genesis\nIn 1947 Lockheed identified a simple problem: pilots were trained on propeller aircraft and then sent up alone, on their first flight, in a jet fighter. The solution was just as simple — stretch the **F-80** fuselage by ninety-two centimetres, fit a second seat in tandem under a shared canopy, and let student and instructor fly together. The aircraft was not designed so much as derived; that is what made it immediately available.\n\n## Design\nEverything came from the fighter: the same straight wing, the same J33, the same smoothness. The airframe is deliberately **forgiving** — it warns before it stalls, absorbs botched landings and excuses mistakes, exactly what a training aircraft should do. Two wingtip tanks give it the range for long cross-country navigation.\n\n## Operational career\n**Thirty-eight air forces** flew it, from Canada to Japan by way of Greece, Turkey and half of Latin America. It trained the pilots of the Korean War, those of Vietnam, those of the entire Western Cold War. In armed form it also fought — Bolivia and Guatemala used it for ground support into the 2000s.\n\n## Place in history\nSix thousand five hundred and fifty-seven built, sixty-nine years of service in some air forces, and a number of pilots trained that nobody can put a figure to. No fighter of its generation lasted as long. The **T-38 Talon** would succeed it in the role, but the T-Bird remains the aircraft on which the West learned to fly jets.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1947-01-01',
    '1948-03-22',
    '1948-08-01',
    966.0,
    2050.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.51,
  wingspan          = 11.85,
  height            = 3.56,
  wing_area         = 21.81,
  empty_weight      = 3667,
  mtow              = 6832,
  service_ceiling   = 14600,
  climb_rate        = 23.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J33-A-35',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 24.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1948,
  production_end    = 1959,
  units_built       = 6557,
  unit_cost_usd     = 100000,
  unit_cost_year    = 1955,
  operators_count   = 38,
  variants          = E'- **T-33A** : version d''entraînement standard de l''US Air Force\n- **AT-33** : version armée légère, employée en contre-insurrection\n- **T-33 SilverStar** : version canadienne à réacteur Nene, 656 exemplaires\n- **Kawasaki T-33A** : 210 exemplaires construits sous licence au **Japon**\n- **T-33 Mk 3** : la **Bolivie** en a volé jusqu''en 2017, soixante-neuf ans après le premier vol',
  variants_en       = E'- **T-33A** : the standard US Air Force training version\n- **AT-33** : lightly armed version, used in counter-insurgency\n- **T-33 SilverStar** : Canadian version with a Nene engine, 656 built\n- **Kawasaki T-33A** : 210 built under licence in **Japan**\n- **T-33 Mk 3** : **Bolivia** flew it until 2017, sixty-nine years after the first flight',

  -- Strate 4 : qualitatif
  nickname          = 'T-Bird',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_T-33_Shooting_Star',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_T-33_Shooting_Star',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alejandro Pena Edited by: FOX 52 and Bammesk',
  image_licence     = 'Public domain'
WHERE name = 'T-33 Shooting Star';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'T-33 Shooting Star';
