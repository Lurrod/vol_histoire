-- Grumman F9F-8 Cougar
--
-- Photo : F9F-8B Cougars of VMA-121 in flight c1958.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3AF9F-8B_Cougars_of_VMA-121_in_flight_c1958.jpg

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
    'F9F Cougar',
    'F9F Cougar',
    'Grumman F9F-8 Cougar',
    'Grumman F9F-8 Cougar',
    'Le Panther redessiné en flèche, en huit mois',
    'The Panther redrawn with swept wings, in eight months',
    '/assets/airplanes/f9f-cougar.jpg',
    E'## Genèse\nLa Corée règle le débat en quelques semaines : l''aile droite du **F9F Panther** ne tient pas devant l''aile en flèche du MiG-15. Grumman n''a pas le temps de repartir de zéro. En mars 1950, la firme entreprend de greffer une flèche de 35° sur la cellule existante — et fait voler le résultat **dix-huit mois plus tard**.\n\n## Conception\nL''aile nouvelle impose plus qu''un simple angle : bords d''attaque à becs, aérofreins déplacés, empennage également en flèche. La marine, échaudée, refuse un nouveau nom — l''appareil reste officiellement une variante du Panther, ce qui accélère les crédits. Le gain est net : cent cinquante kilomètres-heure et une vitesse limite portée près de Mach 1.\n\n## Carrière opérationnelle\nIl arrive trop tard pour la Corée mais équipe l''aéronavale pendant toute la décennie, et devient le premier chasseur embarqué américain à tirer un **Sidewinder** en unité. Sa version biplace TF-9J connaît une seconde vie inattendue : au **Vietnam**, elle sert de contrôleur aérien avancé, guidant les frappes depuis la place arrière jusqu''en 1968.\n\n## Place dans l''histoire\nMille neuf cent quatre-vingt-huit exemplaires. Il est l''exemple type de la modernisation d''urgence : ni un avion neuf ni tout à fait l''ancien, mais disponible à temps. Grumman poussera la cellule une génération plus loin avec le **F11F Tiger**, avant de la laisser au Crusader.',
    E'## Genesis\nKorea settled the argument within weeks: the straight wing of the **F9F Panther** could not live with the MiG-15''s swept wing. Grumman had no time to start again. In March 1950 the firm set about grafting a 35° sweep onto the existing airframe — and flew the result **eighteen months later**.\n\n## Design\nThe new wing demanded more than an angle: leading-edge slats, relocated airbrakes, a swept tail as well. The Navy, once bitten, refused a new name — the aircraft stayed officially a Panther variant, which sped the funding along. The gain was clear: a hundred and fifty kilometres an hour, and a limiting Mach number close to one.\n\n## Operational career\nIt arrived too late for Korea but equipped naval aviation throughout the decade, and became the first American carrier fighter to fire a **Sidewinder** in squadron service. Its two-seat TF-9J version had an unexpected second life: over **Vietnam** it served as a forward air controller, directing strikes from the back seat until 1968.\n\n## Place in history\nOne thousand nine hundred and eighty-eight built. It is the textbook emergency upgrade: neither a new aircraft nor quite the old one, but available in time. Grumman would push the airframe one generation further with the **F11F Tiger**, before leaving the field to the Crusader.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1950-03-01',
    '1951-09-20',
    '1952-11-01',
    1041.0,
    1600.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.54,
  wingspan          = 10.52,
  height            = 3.73,
  wing_area         = 31.3,
  empty_weight      = 5382,
  mtow              = 11232,
  service_ceiling   = 15240,
  climb_rate        = 30.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 550,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J48-P-8A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 32.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1960,
  units_built       = 1988,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **F9F-6 / -7** : premières versions à aile en flèche\n- **F9F-8** : fuselage allongé, aile agrandie, la version la plus produite\n- **F9F-8T / TF-9J** : biplace d''entraînement, en service jusqu''en **1974**\n- **F9F-8P** : reconnaissance photographique, nez allongé\n- Premier chasseur embarqué américain à tirer un **Sidewinder** en opérations',
  variants_en       = E'- **F9F-6 / -7** : first swept-wing versions\n- **F9F-8** : lengthened fuselage, enlarged wing, the most produced version\n- **F9F-8T / TF-9J** : two-seat trainer, in service until **1974**\n- **F9F-8P** : photographic reconnaissance, with a lengthened nose\n- First American carrier fighter to fire a **Sidewinder** operationally',

  -- Strate 4 : qualitatif
  nickname          = 'Cougar',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_F9F_Cougar',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_F9F_Cougar',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'F9F Cougar';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F9F Cougar';
