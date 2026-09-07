-- Ryan X-13 Vertijet
--
-- Photo : X-13 91602017.jpg
--   licence Public domain — San Diego Air & Space Museum
--   https://commons.wikimedia.org/wiki/File%3AX-13_91602017.jpg

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
    'X-13 Vertijet',
    'X-13 Vertijet',
    'Ryan X-13 Vertijet',
    'Ryan X-13 Vertijet',
    'Un chasseur qui décolle suspendu à un câble, la queue en bas',
    'A fighter that takes off hanging from a cable, tail down',
    '/assets/airplanes/x13-vertijet.jpg',
    E'## Genèse\nL''idée vient de la marine américaine à la fin des années 1940 : si un chasseur pouvait décoller à la verticale, n''importe quel navire deviendrait un porte-avions. Ryan, spécialiste des prototypes audacieux, propose le **tail-sitter** — un appareil qui repose sur sa queue et qui décolle comme une fusée. L''US Air Force reprend le programme en 1953.\n\n## Conception\nLe X-13 n''a pas de train d''atterrissage. Il est transporté sur une remorque qui se relève à la verticale et tend un câble ; l''appareil s''y **accroche par un crochet de nez**, moteur au ralenti. Pour décoller, il monte le long du câble puis s''en détache. Pour se poser, le pilote doit revenir en vol stationnaire, se retourner cabré à quatre-vingt-dix degrés, reculer à l''estime et raccrocher le crochet — en regardant par-dessus son épaule.\n\n## Carrière opérationnelle\nAucune. Le 11 avril **1957**, le X-13 réussit l''enchaînement complet : décollage vertical, transition, vol horizontal, transition inverse, appontage sur son câble. En juillet, il est amené à Washington et exécute la manœuvre devant le Pentagone. Le Congrès n''est pas convaincu, et le programme s''arrête en 1958.\n\n## Place dans l''histoire\nDeux exemplaires. Le X-13 a prouvé que la formule fonctionne — et, du même mouvement, qu''elle est inexploitable : un pilote de ligne moyen ne peut pas apponter à reculons sur un câble, encore moins de nuit, en mer, sous le feu. Comme le **XFY Pogo** et le **XFV**, il meurt de sa propre démonstration.',
    E'## Genesis\nThe idea came from the US Navy in the late 1940s: if a fighter could take off vertically, any ship would become a carrier. Ryan, a specialist in audacious prototypes, proposed the **tail-sitter** — an aircraft that rests on its tail and takes off like a rocket. The US Air Force took the programme over in 1953.\n\n## Design\nThe X-13 has no undercarriage. It is carried on a trailer that rises to the vertical and tensions a cable; the aircraft **hooks on by the nose**, engine idling. To take off it climbs along the cable and lets go. To land, the pilot must return to the hover, pitch up ninety degrees, back up by feel and re-engage the hook — while looking over his shoulder.\n\n## Operational career\nNone. On 11 April **1957** the X-13 completed the full sequence: vertical take-off, transition, horizontal flight, reverse transition, landing on its cable. In July it was taken to Washington and flew the manoeuvre in front of the Pentagon. Congress was unconvinced, and the programme ended in 1958.\n\n## Place in history\nTwo built. The X-13 proved the formula works — and, in the same motion, that it is unusable: an average squadron pilot cannot land backwards onto a cable, still less at night, at sea, under fire. Like the **XFY Pogo** and the **XFV**, it died of its own demonstration.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1947-01-01',
    '1955-12-10',
    NULL,
    560.0,
    307.0,
    (SELECT id FROM manufacturer WHERE code = 'RYA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'X-13 Vertijet'), (SELECT id FROM tech WHERE name = 'Aile delta'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'X-13 Vertijet'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.14,
  wingspan          = 6.4,
  height            = 4.62,
  wing_area         = 16.2,
  empty_weight      = 2320,
  mtow              = 3272,
  service_ceiling   = 6100,
  climb_rate        = 45.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 150,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Avon RA.28-49',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 44.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1956,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **X-13** : deux exemplaires, désignation constructeur **Ryan Model 69**\n- Décolle et se pose **accroché par un crochet de nez** à un câble tendu sur une remorque\n- Réalise la **transition complète** le 11 avril 1957, du câble au vol et retour\n- Démontré au-dessus du **Pentagone** en juillet 1957 pour convaincre le Congrès\n- Aucune suite : la formule du tail-sitter est jugée impilotable en opérations',
  variants_en       = E'- **X-13** : two aircraft, manufacturer''s designation **Ryan Model 69**\n- Takes off and lands **hooked by the nose** to a cable strung on a trailer\n- Achieved the **full transition** on 11 April 1957, cable to flight and back\n- Demonstrated over the **Pentagon** in July 1957 to convince Congress\n- No sequel: the tail-sitter formula was judged unflyable in service',

  -- Strate 4 : qualitatif
  nickname          = 'Vertijet',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Ryan_X-13_Vertijet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ryan_X-13_Vertijet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'San Diego Air & Space Museum',
  image_licence     = 'Public domain'
WHERE name = 'X-13 Vertijet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'X-13 Vertijet';
