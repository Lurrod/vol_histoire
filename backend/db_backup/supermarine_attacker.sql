-- Supermarine Attacker F.1
--
-- Photo : Supemarine Attacker F.1 ‘WA473 J-102’ (49935295838).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   

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
    'Supermarine Attacker',
    'Supermarine Attacker',
    'Supermarine Attacker F.1',
    'Supermarine Attacker F.1',
    'Premier jet embarqué de la Royal Navy, monté sur roulette de queue',
    'The Royal Navy’s first carrier jet, still on a tailwheel',
    '/assets/airplanes/supermarine-attacker.jpg',
    E'## Genèse\nSupermarine sort de la guerre avec le Spiteful, ultime évolution du Spitfire à aile laminaire — et un échec, l''hélice ayant atteint ses limites. Plutôt que de jeter l''aile, la firme la conserve et lui greffe un fuselage neuf autour du réacteur **Nene**. Le résultat porte donc, en 1946, une aile conçue pour un chasseur à hélices de 1944.\n\n## Conception\nCet héritage se voit surtout au train : l''Attacker garde la **roulette de queue** du Spiteful, si bien qu''au sol il pointe le nez vers le ciel. Sur un pont d''envol, cela signifie une visibilité nulle au roulage, une assiette d''appontage délicate, et des gaz de réacteur dirigés vers le pont qu''ils brûlent. Aucun autre jet embarqué de série n''a répété l''erreur.\n\n## Carrière opérationnelle\nIl équipe la Fleet Air Arm de 1951 à 1954 — trois ans seulement, le temps que le Sea Hawk arrive. Sa carrière la plus longue est pakistanaise : trente-six exemplaires servent à Karachi jusqu''en 1964, faisant du **Pakistan** l''un des premiers pays d''Asie à exploiter un chasseur à réaction.\n\n## Place dans l''histoire\nCent quatre-vingt-cinq exemplaires. Son mérite est d''être arrivé : il est le **premier jet à équiper une escadre embarquée de la Royal Navy**, et à ce titre il ouvre la voie au Sea Hawk, au Scimitar et au Sea Vixen. Supermarine, elle, avait déjà entamé la descente qui la mènera au **Swift** puis à la disparition.',
    E'## Genesis\nSupermarine came out of the war with the Spiteful, the final laminar-wing evolution of the Spitfire — and a failure, the propeller having reached its limits. Rather than discard the wing, the firm kept it and grafted a new fuselage around the **Nene** engine. The result therefore carried, in 1946, a wing designed for a 1944 propeller fighter.\n\n## Design\nThat inheritance shows most in the undercarriage: the Attacker keeps the Spiteful''s **tailwheel**, so on the ground it points its nose at the sky. On a flight deck that means no visibility while taxiing, an awkward landing attitude, and jet efflux aimed at the deck, which it scorched. No other production carrier jet repeated the mistake.\n\n## Operational career\nIt equipped the Fleet Air Arm from 1951 to 1954 — three years only, just long enough for the Sea Hawk to arrive. Its longest career was Pakistani: thirty-six aircraft served at Karachi until 1964, making **Pakistan** one of the first countries in Asia to operate a jet fighter.\n\n## Place in history\nOne hundred and eighty-five built. Its merit is to have arrived at all: it is the **first jet to equip a Royal Navy carrier squadron**, and as such it opened the way to the Sea Hawk, the Scimitar and the Sea Vixen. Supermarine itself had already begun the decline that would lead to the **Swift** and then to extinction.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1944-01-01',
    '1946-07-27',
    '1951-08-22',
    950.0,
    1900.0,
    (SELECT id FROM manufacturer WHERE code = 'SUP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.43,
  wingspan          = 11.25,
  height            = 3.02,
  wing_area         = 21.0,
  empty_weight      = 3826,
  mtow              = 5539,
  service_ceiling   = 13715,
  climb_rate        = 32.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Nene 3',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 22.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1950,
  production_end    = 1953,
  units_built       = 185,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Attacker F.1** : chasseur pur, première version embarquée\n- **Attacker FB.2** : chasseur-bombardier, points d''emport sous voilure\n- **Attacker Mk 8** : version livrée au **Pakistan**, 36 exemplaires\n- Aile reprise du **Supermarine Spiteful**, dernier avatar du Spitfire\n- Seul jet embarqué de série à **roulette de queue**, héritage encombrant',
  variants_en       = E'- **Attacker F.1** : pure fighter, the first carrier version\n- **Attacker FB.2** : fighter-bomber, with underwing hardpoints\n- **Attacker Mk 8** : version delivered to **Pakistan**, 36 aircraft\n- Wing taken from the **Supermarine Spiteful**, the last avatar of the Spitfire\n- The only production carrier jet with a **tailwheel**, an awkward inheritance',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Supermarine_Attacker',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Supermarine_Attacker',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Supermarine Attacker';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Supermarine Attacker';
