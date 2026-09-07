-- IAR-99 Șoim
--
-- Photo : Romanian Air Force IAR-99 Soim 100th anniversary of aviation colours.jpg
--   licence CC BY-SA 4.0 — Cătălin Cocîrlă
--   https://commons.wikimedia.org/wiki/File%3ARomanian_Air_Force_IAR-99_Soim_100th_anniversary_of_aviation_colours.jpg

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
    'IAR-99 Șoim',
    'IAR-99 Șoim',
    'IAR-99 Șoim',
    'IAR-99 Șoim',
    'Avion-école et d’attaque légère roumain, conçu pour affranchir Bucarest de Moscou',
    'Romanian trainer and light attack aircraft, built to free Bucharest from Moscow',
    '/assets/airplanes/iar99-soim.jpg',
    E'## Genèse\nLa Roumanie de Ceaușescu mène, seule dans le bloc de l''Est, une politique d''indépendance industrielle assumée : elle refuse d''acheter à Moscou ce qu''elle peut construire. Après avoir développé l''**IAR-93 Orao** avec la Yougoslavie, Bucarest décide en 1975 de se doter de son propre avion-école plutôt que de commander des L-39 tchécoslovaques comme le reste du pacte de Varsovie.\n\n## Conception\nFormule classique et sobre : aile légèrement en flèche montée bas, deux places en tandem, un seul réacteur **Viper** britannique construit sous licence à Bucarest — un choix révélateur, puisqu''il s''agit d''un moteur occidental acquis en pleine guerre froide. Quatre points d''emport permettent l''attaque légère. La cellule est simple, sans ambition technique particulière, mais entièrement roumaine.\n\n## Carrière opérationnelle\nCinquante et un exemplaires forment depuis près de quarante ans tous les pilotes de chasse roumains, avant leur passage sur MiG-21 puis sur **F-16**. L''appareil équipe aussi la patrouille acrobatique nationale. Il n''a jamais combattu, et la chute du régime en 1989 a mis fin aux espoirs d''exportation qui justifiaient une partie du programme.\n\n## Place dans l''histoire\nC''est le seul avion à réaction entièrement conçu et produit en Roumanie, et l''un des rares programmes du bloc de l''Est menés **hors du cadre soviétique**. Sa modernisation, engagée en 2021, en fera l''un des avions-école les plus anciens encore en première ligne en Europe. Son voisin et contemporain yougoslave est le **Soko G-4 Super Galeb**.',
    E'## Genesis\nCeaușescu''s Romania pursued, alone in the Eastern Bloc, a deliberate policy of industrial independence: it refused to buy from Moscow what it could build itself. Having developed the **IAR-93 Orao** with Yugoslavia, Bucharest decided in 1975 to build its own training aircraft rather than order Czechoslovak L-39s like the rest of the Warsaw Pact.\n\n## Design\nA conventional, sober layout: a lightly swept low wing, two seats in tandem, and a single British **Viper** engine built under licence in Bucharest — a telling choice, since this was a Western engine acquired in the middle of the Cold War. Four hardpoints allow light attack. The airframe is simple, with no particular technical ambition, but entirely Romanian.\n\n## Operational career\nFifty-one aircraft have for nearly forty years trained every Romanian fighter pilot before they move on to the MiG-21 and then the **F-16**. The type also equips the national display team. It has never seen combat, and the fall of the regime in 1989 ended the export hopes that had justified part of the programme.\n\n## Place in history\nIt is the only jet aircraft designed and built entirely in Romania, and one of the few Eastern Bloc programmes conducted **outside the Soviet framework**. Its upgrade, begun in 2021, will make it one of the oldest trainers still in front-line use in Europe. Its Yugoslav neighbour and contemporary is the **Soko G-4 Super Galeb**.',
    (SELECT id FROM countries WHERE code = 'ROU'),
    '1975-01-01',
    '1985-12-21',
    '1987-01-01',
    865.0,
    1100.0,
    (SELECT id FROM manufacturer WHERE code = 'IAR'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAR-99 Șoim'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'IAR-99 Șoim'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Viper'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'IAR-99 Șoim'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'IAR-99 Șoim'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'IAR-99 Șoim'), (SELECT id FROM armement WHERE name = 'R-60'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAR-99 Șoim'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'IAR-99 Șoim'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.01,
  wingspan          = 9.85,
  height            = 3.9,
  wing_area         = 18.71,
  empty_weight      = 3200,
  mtow              = 5560,
  service_ceiling   = 12900,
  climb_rate        = 36.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 380,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Turbomecanica Rolls-Royce Viper 632-41M',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 17.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1985,
  production_end    = 1999,
  units_built       = 51,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **IAR-99 Standard** : version d''entraînement de base\n- **IAR-99 Șoim** : avionique israélienne Elbit, écrans multifonctions et navigation moderne\n- **IAR-109 Swift** : proposition d''export à avionique occidentale, restée sans commande\n- Un programme de modernisation lancé en **2021** doit prolonger la flotte au-delà de 2040\n- Successeur du **IAR-93 Orao**, développé conjointement avec la Yougoslavie',
  variants_en       = E'- **IAR-99 Standard** : basic training version\n- **IAR-99 Șoim** : Israeli Elbit avionics, multifunction displays and modern navigation\n- **IAR-109 Swift** : export proposal with Western avionics, never ordered\n- An upgrade programme launched in **2021** is to extend the fleet beyond 2040\n- Successor to the **IAR-93 Orao**, developed jointly with Yugoslavia',

  -- Strate 4 : qualitatif
  nickname          = 'Șoim',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/IAR-99',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAR_99',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Cătălin Cocîrlă',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'IAR-99 Șoim';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAR-99 Șoim';
