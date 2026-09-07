-- Douglas F4D Skyray
--
-- Photo : Douglas F4D-1 Skyray in flight c1957.jpeg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3ADouglas_F4D-1_Skyray_in_flight_c1957.jpeg

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
    'F4D Skyray',
    'F4D Skyray',
    'Douglas F4D Skyray',
    'Douglas F4D Skyray',
    'Seul chasseur embarqué à aile delta de l’US Navy',
    'The US Navy’s only delta-winged carrier fighter',
    '/assets/airplanes/f4d-skyray.jpg',
    E'## Genèse\nL''US Navy veut un intercepteur capable de décoller du pont et d''atteindre un bombardier à haute altitude en moins de deux minutes — sans quoi la flotte est perdue avant d''avoir réagi. Douglas s''appuie sur les travaux de l''aérodynamicien allemand **Alexander Lippisch**, récupérés en 1945, et propose une aile delta modifiée, formule alors inédite sur un porte-avions.\n\n## Conception\nL''aile en delta arrondi occupe presque toute la cellule : il n''y a pas d''empennage horizontal, la gouverne de profondeur et les ailerons sont fondus en surfaces uniques. Cette immense surface portante donne une **vitesse ascensionnelle prodigieuse** — quatre-vingt-treize mètres par seconde, supérieure à celle de bien des chasseurs de la génération suivante — et une vitesse d''approche assez basse pour l''appontage. Le prix à payer est une traînée élevée et une autonomie médiocre.\n\n## Carrière opérationnelle\nIl équipe seize escadrons de l''US Navy et du Corps des Marines, et devient en 1958 le seul chasseur de la marine intégré au **NORAD**, la défense aérienne du continent — un rôle habituellement réservé à l''Air Force. Il n''a jamais combattu : retiré en 1964, il quitte le service juste avant le Vietnam.\n\n## Place dans l''histoire\nQuatre cent vingt-deux exemplaires, et cinq records mondiaux de montée en 1958. C''est le seul chasseur à aile delta jamais mis en service sur un porte-avions américain — la formule sera abandonnée au profit de l''aile en flèche du **F-8 Crusader** et du F-4 Phantom II, plus polyvalente.',
    E'## Genesis\nThe US Navy wanted an interceptor able to leave the deck and reach a high-altitude bomber in under two minutes — without which the fleet would be lost before it could react. Douglas drew on the work of the German aerodynamicist **Alexander Lippisch**, recovered in 1945, and proposed a modified delta wing, a layout then unheard of aboard a carrier.\n\n## Design\nThe rounded delta wing takes up almost the whole airframe: there is no horizontal tail, elevator and ailerons being merged into single surfaces. That vast lifting area gives a **prodigious rate of climb** — ninety-three metres per second, better than many fighters of the following generation — and an approach speed low enough for deck landings. The price is high drag and mediocre range.\n\n## Operational career\nIt equipped sixteen US Navy and Marine Corps squadrons and in 1958 became the only naval fighter assigned to **NORAD**, the continent''s air defence — a role normally reserved for the Air Force. It never saw combat: retired in 1964, it left service just before Vietnam.\n\n## Place in history\nFour hundred and twenty-two built, and five world time-to-climb records in 1958. It is the only delta-winged fighter ever to serve aboard an American carrier — the formula was dropped in favour of the swept wing of the **F-8 Crusader** and the F-4 Phantom II, which was more versatile.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1947-01-01',
    '1951-01-23',
    '1956-04-16',
    1162.0,
    1930.0,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F4D Skyray'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'F4D Skyray'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F4D Skyray'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'F4D Skyray'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F4D Skyray'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'F4D Skyray'), (SELECT id FROM armement WHERE name = 'FFAR Mighty Mouse')),
((SELECT id FROM airplanes WHERE name = 'F4D Skyray'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F4D Skyray'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F4D Skyray'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F4D Skyray'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.79,
  wingspan          = 10.21,
  height            = 3.96,
  wing_area         = 51.75,
  empty_weight      = 7268,
  mtow              = 11340,
  service_ceiling   = 16764,
  climb_rate        = 93.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 460,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J57-P-8',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 45.0,
  thrust_wet        = 71.6,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1958,
  units_built       = 422,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **F4D-1 / F-6A** : version de série unique, redésignée en 1962\n- **F5D Skylancer** : évolution supersonique, quatre exemplaires, programme annulé\n- Deux Skylancer furent cédés à la **NASA** ; Neil Armstrong en a piloté un\n- Détient en 1958 cinq **records mondiaux de montée**, dont 15 000 m en 2 min 36 s\n- Premier chasseur embarqué américain capable de dépasser Mach 1 en palier',
  variants_en       = E'- **F4D-1 / F-6A** : the sole production version, redesignated in 1962\n- **F5D Skylancer** : supersonic evolution, four built, programme cancelled\n- Two Skylancers went to **NASA**; Neil Armstrong flew one\n- Held five **world time-to-climb records** in 1958, including 15,000 m in 2 min 36 s\n- The first American carrier fighter able to exceed Mach 1 in level flight',

  -- Strate 4 : qualitatif
  nickname          = 'Ford',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_F4D_Skyray',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_F4D_Skyray',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'F4D Skyray';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F4D Skyray';
