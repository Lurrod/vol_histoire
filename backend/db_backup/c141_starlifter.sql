-- Lockheed C-141 Starlifter
--
-- Photo : An air-to-air left side view of a C-141 Starlifter aircraft over Norton Air Force Base - DPLA - 0bd3606bae5fc5b07c0f23918fa4f28b.jpeg
--   licence CC0 — Balon Greyjoy
--   https://commons.wikimedia.org/wiki/File%3A20180214_C-141B_Starlifter_Air_Mobility_Command_Museum-2.jpg

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
    'C-141 Starlifter',
    'C-141 Starlifter',
    'Lockheed C-141 Starlifter',
    'Lockheed C-141 Starlifter',
    'Premier transport à réaction pur de l’aviation militaire américaine',
    'The first pure jet transport of American military aviation',
    '/assets/airplanes/c141-starlifter.jpg',
    E'## Genèse\nEn 1960, tout le transport militaire américain vole à l''hélice. Kennedy fait de la **mobilité stratégique** une priorité de sa campagne : il faut pouvoir renforcer l''Europe en heures plutôt qu''en jours. Lockheed propose un quadriréacteur conçu dès l''origine pour le fret militaire — plancher haut, rampe arrière, réacteurs sous voilure — et non une conversion d''avion de ligne.\n\n## Conception\nLa cellule révèle vite un défaut instructif : la soute est **trop étroite pour son propre potentiel**. Les chargements atteignent le volume maximal bien avant la masse maximale, si bien que l''appareil vole systématiquement plein mais léger. La correction, décidée en 1977, consiste à insérer **sept mètres dix de fuselage** sur les deux cent soixante-dix appareils de la flotte — l''équivalent de treize avions gagnés sans en construire un seul.\n\n## Carrière opérationnelle\nIl assure le pont aérien du Vietnam, y transporte les blessés et, le 12 février 1973, ramène les premiers prisonniers de guerre libérés : l''appareil qui les portait, surnommé le **Hanoi Taxi**, est aujourd''hui conservé. Il ravitaille Israël en 1973, dépose les troupes en Grenade, à Panama, au Koweït et en Somalie. Il vole aussi vers l''Antarctique, où il se pose sur la glace.\n\n## Place dans l''histoire\nDeux cent quatre-vingt-cinq exemplaires, retirés en 2006. Il a fait passer le transport militaire américain à la réaction et rendu la projection intercontinentale routinière. Son remplacement par le **C-17** aura pris quinze ans, le temps que l''on apprenne à faire tenir sa capacité dans un appareil capable, lui, de se poser sur une piste sommaire.',
    E'## Genesis\nIn 1960 all American military transport flew on propellers. Kennedy made **strategic mobility** a campaign priority: Europe had to be reinforceable in hours rather than days. Lockheed proposed a four-jet aircraft designed from the start for military freight — high floor, rear ramp, underwing engines — rather than an airliner conversion.\n\n## Design\nThe airframe soon revealed an instructive flaw: the hold is **too narrow for its own potential**. Loads reached maximum volume well before maximum weight, so the aircraft habitually flew full but light. The fix, decided in 1977, was to insert **seven metres ten of fuselage** into the fleet''s two hundred and seventy aircraft — the equivalent of thirteen aircraft gained without building one.\n\n## Operational career\nIt ran the Vietnam air bridge, carried the wounded, and on 12 February 1973 brought home the first released prisoners of war: the aircraft that carried them, nicknamed the **Hanoi Taxi**, is now preserved. It resupplied Israel in 1973, delivered troops to Grenada, Panama, Kuwait and Somalia. It also flew to Antarctica, landing on ice.\n\n## Place in history\nTwo hundred and eighty-five built, retired in 2006. It took American military transport into the jet age and made intercontinental projection routine. Its replacement by the **C-17** took fifteen years, the time needed to learn how to fit its capacity into an aircraft that could also land on a rough strip.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1960-05-01',
    '1963-12-17',
    '1965-04-23',
    912.0,
    9880.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 51.29,
  wingspan          = 48.74,
  height            = 11.96,
  wing_area         = 300.0,
  empty_weight      = 67186,
  mtow              = 155580,
  service_ceiling   = 12680,
  climb_rate        = 13.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4720,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney TF33-P-7',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 93.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1968,
  units_built       = 285,
  unit_cost_usd     = 8100000,
  unit_cost_year    = 1965,
  operators_count   = 1,
  variants          = E'- **C-141A** : version initiale, dont la soute se remplissait avant d''être pleine en masse\n- **C-141B** : fuselage **allongé de 7,1 m** sur toute la flotte, perche de ravitaillement ajoutée\n- **C-141C** : avionique numérique, dernière évolution\n- **NC-141A** : banc d''essai de la NASA pour l''astronomie infrarouge\n- Le *Hanoi Taxi* a ramené les premiers prisonniers de guerre du Vietnam en 1973',
  variants_en       = E'- **C-141A** : initial version, whose hold filled up before reaching its weight limit\n- **C-141B** : fuselage **stretched by 7.1 m** across the fleet, refuelling receptacle added\n- **C-141C** : digital avionics, the final evolution\n- **NC-141A** : NASA testbed for infrared astronomy\n- The *Hanoi Taxi* brought home the first Vietnam prisoners of war in 1973',

  -- Strate 4 : qualitatif
  nickname          = 'Starlizard',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_C-141_Starlifter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_C-141_Starlifter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Department of Defense',
  image_licence     = 'Public domain'
WHERE name = 'C-141 Starlifter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'C-141 Starlifter';
