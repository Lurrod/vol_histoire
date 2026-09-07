-- Convair XFY-1 Pogo
--
-- Photo : Convair XFY-1 in flight.jpg
--   licence Public domain — USN
--   https://commons.wikimedia.org/wiki/File%3AConvair_XFY-1_in_flight.jpg

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
    'XFY Pogo',
    'XFY Pogo',
    'Convair XFY-1 Pogo',
    'Convair XFY-1 Pogo',
    'Seul appareil de l’histoire à avoir réussi la transition sur hélices',
    'The only aircraft in history to complete the transition on propellers',
    '/assets/airplanes/xfy-pogo.jpg',
    E'## Genèse\nEn 1950, l''US Navy lance un concours pour un chasseur capable d''opérer depuis la plateforme d''un **navire ordinaire** — un cargo, un destroyer, n''importe quoi de plus petit qu''un porte-avions. Deux firmes répondent avec la même formule, le tail-sitter à hélices : Convair avec le XFY, Lockheed avec le **XFV**. Les deux appareils partagent jusqu''au moteur.\n\n## Conception\nL''appareil repose sur quatre roulettes fixées aux extrémités de son aile delta et de ses dérives, nez pointé vers le ciel. Un turbopropulseur Allison entraîne deux **hélices contrarotatives** de près de cinq mètres, qui fournissent toute la portance au décollage. Le pilote est assis dans un siège pivotant, mais à l''atterrissage il doit tout de même juger sa hauteur en regardant en arrière et vers le bas, sans repère.\n\n## Carrière opérationnelle\nAucune. Le **2 novembre 1954**, le pilote d''essai James « Skeets » Coleman décolle verticalement, bascule à l''horizontale, vole, rebascule et se pose sur sa queue : la première — et à ce jour l''unique — transition complète réussie par un appareil à hélices. Il faudra une quarantaine de vols pour n''en réussir que quelques-unes.\n\n## Place dans l''histoire\nDeux exemplaires. Le rapport final est sans appel : la manœuvre exige un pilote d''essai d''exception, la descente à la verticale se fait à l''aveugle, et une panne moteur en approche ne laisse aucune issue. La marine renonce aux tail-sitters en 1956 — et attendra le **Harrier** pour obtenir enfin ce qu''elle cherchait.',
    E'## Genesis\nIn 1950 the US Navy opened a competition for a fighter able to operate from the deck of an **ordinary ship** — a freighter, a destroyer, anything smaller than a carrier. Two firms answered with the same formula, the propeller tail-sitter: Convair with the XFY, Lockheed with the **XFV**. The two aircraft even shared an engine.\n\n## Design\nThe aircraft rests on four castors fixed to the tips of its delta wing and fins, nose pointed at the sky. An Allison turboprop drives two **contra-rotating propellers** nearly five metres across, which provide all the lift on take-off. The pilot sits in a swivelling seat, but on landing he must still judge his height by looking back and down, with no reference.\n\n## Operational career\nNone. On **2 November 1954** test pilot James ''Skeets'' Coleman took off vertically, pitched over to horizontal, flew, pitched back and landed on his tail: the first — and to this day the only — complete transition achieved by a propeller aircraft. It took some forty flights to manage only a handful of them.\n\n## Place in history\nTwo built. The final report was damning: the manoeuvre demands an exceptional test pilot, the vertical descent is flown blind, and an engine failure on approach leaves no way out. The Navy abandoned tail-sitters in 1956 — and would wait for the **Harrier** to finally get what it had been after.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1950-01-01',
    '1954-08-01',
    NULL,
    982.0,
    1046.0,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'XFY Pogo'), (SELECT id FROM tech WHERE name = 'Aile delta'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'XFY Pogo'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'XFY Pogo'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.66,
  wingspan          = 8.43,
  height            = 7.0,
  wing_area         = 39.3,
  empty_weight      = 5330,
  mtow              = 7370,
  service_ceiling   = 13300,
  climb_rate        = 52.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison YT40-A-16',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur à hélices contrarotatives',
  engine_type_en    = 'Contra-rotating turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1954,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XFY-1** : un exemplaire volant, un second resté au sol\n- **Hélices contrarotatives** de 4,90 m, seule source de portance au décollage\n- **2 novembre 1954** : première transition complète de l''histoire sur hélices\n- Concurrent direct du **Lockheed XFV**, qui n''a jamais décollé verticalement\n- Programme arrêté en 1956 : appontage jugé impossible pour un pilote de ligne',
  variants_en       = E'- **XFY-1** : one flying aircraft, a second that stayed on the ground\n- **Contra-rotating propellers** 4.90 m across, the only source of lift on take-off\n- **2 November 1954**: the first complete transition in history on propellers\n- Direct competitor of the **Lockheed XFV**, which never took off vertically\n- Stopped in 1956: landing judged impossible for an average squadron pilot',

  -- Strate 4 : qualitatif
  nickname          = 'Pogo',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_XFY_Pogo',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_XFY_Pogo',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USN',
  image_licence     = 'Public domain'
WHERE name = 'XFY Pogo';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'XFY Pogo';
