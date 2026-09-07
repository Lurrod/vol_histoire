-- Vought F-8 Crusader
--
-- Photo : Vought F-8 ECN-3276.jpg
--   licence Public domain — Glenn Research Center (NASA/DFRC)
--   https://commons.wikimedia.org/wiki/File%3AVought_F-8_ECN-3276.jpg

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
    'F-8 Crusader',
    'F-8 Crusader',
    'Vought F-8 Crusader',
    'Vought F-8 Crusader',
    'Dernier chasseur américain conçu autour de ses canons',
    'The last American fighter designed around its guns',
    '/assets/airplanes/f8-crusader.jpg',
    E'## Genèse\nL''US Navy veut en 1952 un chasseur embarqué supersonique. La difficulté est connue : plus l''avion est rapide, plus son aile doit être fine et fléchée, et plus sa vitesse d''appontage devient insoutenable. Vought résout le problème d''une manière que personne n''a reprise depuis.\n\n## Conception\nL''**aile entière bascule** de sept degrés vers le haut à l''appontage. L''incidence de l''aile augmente sans que le fuselage ne se cabre : le pilote garde une vue dégagée sur le pont, et l''appareil conserve une aile optimisée pour le vol supersonique. Quatre canons de 20 mm restent l''armement principal, à une époque où tous les concurrents misent sur le tout-missile.\n\n## Carrière opérationnelle\nC''est un **RF-8A** qui rapporte, en octobre 1962, les photographies à basse altitude des rampes de missiles soviétiques à Cuba. Au **Vietnam**, le Crusader affiche le meilleur ratio de victoires de l''aéronavale américaine face aux MiG — d''où son surnom de *dernier des pistoleros*. La France l''a exploité jusqu''en 1999.\n\n## Place dans l''histoire\nEn 1972, une cellule modifiée par la NASA devient le premier avion au monde à voler avec des **commandes de vol entièrement numériques**, sans aucune liaison mécanique de secours — la technologie qui équipe aujourd''hui tous les avions de combat modernes.',
    E'## Genesis\nIn 1952 the US Navy wanted a supersonic carrier fighter. The difficulty was well known: the faster the aircraft, the thinner and more swept its wing must be, and the more unbearable its approach speed becomes. Vought solved the problem in a way nobody has repeated since.\n\n## Design\nThe **entire wing pivots** seven degrees upward for landing. Wing incidence rises without the fuselage pitching up: the pilot keeps a clear view of the deck while the aircraft retains a wing optimised for supersonic flight. Four 20 mm cannon remained the primary armament at a time when every competitor was betting on missiles alone.\n\n## Operational career\nIt was an **RF-8A** that brought back, in October 1962, the low-level photographs of the Soviet missile sites in Cuba. Over **Vietnam** the Crusader posted US naval aviation’s best kill ratio against MiGs — hence its nickname, *last of the gunfighters*. France flew it until 1999.\n\n## Place in history\nIn 1972 an airframe modified by NASA became the first aircraft in the world to fly on **fully digital flight controls**, with no mechanical backup — the technology that equips every modern combat aircraft today.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1952-01-01',
    '1955-03-25',
    '1957-03-25',
    1975.0,
    2795.0,
    (SELECT id FROM manufacturer WHERE code = 'VOU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM tech WHERE name = 'Aile à incidence variable')),
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM armement WHERE name = 'Zuni 127 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.61,
  wingspan          = 10.87,
  height            = 4.8,
  wing_area         = 32.5,
  empty_weight      = 8000,
  mtow              = 15400,
  service_ceiling   = 17700,
  climb_rate        = 160,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.0,
  combat_radius     = 730,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J57-P-20A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 47.6,
  thrust_wet        = 80.1,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1965,
  units_built       = 1219,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **F-8E** : version de chasse définitive de l''US Navy\n- **RF-8A / G** : reconnaissance photographique, engagée sur Cuba en 1962\n- **F-8E (FN)** : version française, en service sur porte-avions jusqu''en 1999\n- **F-8 DFBW** : cellule d''essai NASA, premier avion à commandes de vol numériques (1972)',
  variants_en       = E'- **F-8E** : definitive US Navy fighter version\n- **RF-8A / G** : photographic reconnaissance, flown over Cuba in 1962\n- **F-8E (FN)** : French version, carrier-based until 1999\n- **F-8 DFBW** : NASA testbed, first digital fly-by-wire aircraft (1972)',

  -- Strate 4 : qualitatif
  nickname          = 'Last of the Gunfighters',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Vought_F-8_Crusader',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Vought_F-8_Crusader',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Glenn Research Center (NASA/DFRC)',
  image_licence     = 'Public domain'
WHERE name = 'F-8 Crusader';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-8 Crusader';
