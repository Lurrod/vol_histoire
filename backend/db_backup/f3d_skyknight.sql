-- Douglas F3D Skyknight
--
-- Photo : F3D-2Q Skyknights of VMCJ-3 in flight in 1958.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3AF3D-2Q_Skyknights_of_VMCJ-3_in_flight_in_1958.jpg

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
    'F3D Skyknight',
    'F3D Skyknight',
    'Douglas F3D Skyknight',
    'Douglas F3D Skyknight',
    'Auteur de la première victoire nocturne entre avions à réaction',
    'Scorer of the first night victory between jet aircraft',
    '/assets/airplanes/f3d-skyknight.jpg',
    E'## Genèse\nL''US Navy veut, dès 1945, un chasseur de nuit à réaction capable d''opérer depuis un porte-avions. La contrainte dominante n''est pas la vitesse mais le **radar** : les équipements de l''époque sont volumineux, et il faut un opérateur assis à côté du pilote pour les exploiter. Douglas conçoit donc autour du radar, pas autour des performances.\n\n## Conception\nFuselage large et haut, deux hommes côte à côte, aile droite épaisse et deux réacteurs en racine de voilure. L''ensemble est lent, lourd et sans grâce — d''où le surnom de *Willie the Whale*, Willie la baleine. Il emporte en revanche **trois radars distincts** : recherche, poursuite et alerte arrière, ce dernier prévenant le pilote qu''il est lui-même poursuivi. Il n''y a pas de sièges éjectables : l''équipage s''évacue par une goulotte ventrale.\n\n## Carrière opérationnelle\nLe **2 novembre 1952**, au-dessus de la Corée, un F3D des Marines abat un Yak-15 de nuit : première victoire nocturne de l''histoire entre deux avions à réaction. Les Skyknight y détruiront plus d''appareils ennemis de nuit que tout autre type américain, et n''en perdront aucun en combat aérien. Leur troisième vie sera la plus longue : convertis au brouillage, ils escortent les raids au-dessus du **Vietnam** jusqu''en 1970, dix-neuf ans après leur mise en service.\n\n## Place dans l''histoire\nDeux cent soixante-cinq exemplaires seulement, et pourtant deux premières mondiales : la victoire nocturne à réaction en 1952, et le premier abattage par **missile air-air guidé** en 1953, lors d''essais du Sparrow I. Un avion médiocre en vol, qui aura inauguré deux formes de combat aérien encore pratiquées aujourd''hui.',
    E'## Genesis\nFrom 1945 the US Navy wanted a jet night fighter able to operate from a carrier. The governing constraint was not speed but **radar**: the equipment of the day was bulky, and an operator had to sit beside the pilot to work it. Douglas therefore designed around the radar, not around performance.\n\n## Design\nA wide, deep fuselage, two men side by side, a thick straight wing and two engines in the wing roots. The whole is slow, heavy and graceless — hence the nickname *Willie the Whale*. It carries, on the other hand, **three separate radars**: search, track and tail warning, the last telling the pilot he is himself being chased. There are no ejection seats: the crew leaves by a belly chute.\n\n## Operational career\nOn **2 November 1952**, over Korea, a Marine F3D shot down a Yak-15 at night: the first night victory in history between two jet aircraft. Skyknights would destroy more enemy aircraft at night than any other American type there, and lose none in air combat. Their third life was the longest: converted for jamming, they escorted raids over **Vietnam** until 1970, nineteen years after entering service.\n\n## Place in history\nOnly two hundred and sixty-five built, and yet two world firsts: the jet night victory in 1952, and the first kill by **guided air-to-air missile** in 1953, during Sparrow I trials. A mediocre aircraft in the air, which inaugurated two forms of air combat still practised today.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-09-01',
    '1948-03-23',
    '1951-02-01',
    909.0,
    1930.0,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'F3D Skyknight'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.84,
  wingspan          = 15.24,
  height            = 4.9,
  wing_area         = 37.2,
  empty_weight      = 6813,
  mtow              = 12000,
  service_ceiling   = 11640,
  climb_rate        = 20.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse J34-WE-36',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 15.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1948,
  production_end    = 1953,
  units_built       = 265,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **F3D-1** : version initiale, employée surtout à l''entraînement\n- **F3D-2** : réacteurs plus puissants et pilote automatique, version de combat\n- **F3D-2M** : premier chasseur au monde à abattre une cible avec un missile guidé, en 1953\n- **EF-10B** : version de guerre électronique, engagée au **Vietnam** jusqu''en 1970\n- Sortie de secours par **goulotte ventrale** au lieu de sièges éjectables',
  variants_en       = E'- **F3D-1** : initial version, used mainly for training\n- **F3D-2** : more powerful engines and autopilot, the combat version\n- **F3D-2M** : first fighter in the world to down a target with a guided missile, in 1953\n- **EF-10B** : electronic warfare version, committed over **Vietnam** until 1970\n- Escape by **belly chute** rather than ejection seats',

  -- Strate 4 : qualitatif
  nickname          = 'Willie the Whale',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_F3D_Skyknight',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_F3D_Skyknight',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'F3D Skyknight';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F3D Skyknight';
