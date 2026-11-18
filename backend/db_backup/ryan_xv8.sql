-- Ryan XV-8 Flexible Wing Aerial Utility Vehicle « Fleep »
--
-- Photo : XV-8A Fleep Prototype - GPN-2000-001271.jpg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File:XV-8A_Fleep_Prototype_-_GPN-2000-001271.jpg

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
    'Ryan XV-8 Fleep',
    'Ryan XV-8 Fleep',
    'Ryan XV-8 Flexible Wing Aerial Utility Vehicle « Fleep »',
    'Ryan XV-8 Flexible Wing Aerial Utility Vehicle ''Fleep''',
    'La « jeep volante » de Ryan, un utilitaire à décollage court porté par une aile souple de type Rogallo',
    'Ryan''s ''Flying Jeep'', a short take-off utility vehicle carried by a flexible Rogallo wing',
    '/assets/airplanes/ryan-xv8-fleep.jpg',
    E'## Genèse\nL''**US Army** et l''**US Air Force** cherchent un appareil simple, à décollage court, pour la patrouille, la reconnaissance et le transport léger de personnes ou de fret, quand aucun avion plus spécialisé n''est nécessaire ou disponible. **Ryan Aeronautical** y répond, en collaboration avec la **NASA**, par une machine d''un genre nouveau : un véhicule utilitaire porté par une aile souple. Un premier engin, le **Flex-Wing**, ouvre la voie. Sa version améliorée, désignée XV-8 et surnommée « **Fleep** », contraction de *Flying Jeep* (« jeep volante »), est essayée en 1961.\n\n## Conception\nLe Fleep est porté par une aile delta en toile de type **Rogallo**, du nom de l''ingénieur **Francis Rogallo**, tendue sur une armature repliable : pour le transport, elle se replie en un paquet relativement compact. Elle surmonte une nacelle de pilotage installée sur une plateforme de chargement à roues. Par rapport au Flex-Wing, qui avait un train à quatre roues, un nez plus petit derrière lequel s''asseyait le pilote et une seule dérive, le Fleep reçoit un train tricycle, un nez plus volumineux et un empennage en V ; il est d''ailleurs essayé avec les deux formules d''empennage. Un moteur **Continental IO-360-A** de 210 ch assure la propulsion.\n\n## Essais\nConstruit à un seul exemplaire, le Fleep vole en 1961. En 1962, il est installé en grandeur réelle dans la grande soufflerie du centre de recherche **Langley** de la NASA, où l''on étudie le comportement de son aile souple. Ses performances restent modestes : 105 km/h en vitesse maximale et 193 km de distance franchissable, pour une envergure de 10,18 m. Aucune série ne suit.\n\n## Place dans l''histoire\nLe XV-8 tente de faire d''une aile Rogallo motorisée un véhicule militaire ; il est contemporain du **Paresev**, le planeur d''essai de la NASA. Comme les autres « jeeps volantes » étudiées pour l''Army, il reste sans suite, mais sa formule, une aile souple repliable au-dessus d''un chariot motorisé, annonce celle du deltaplane et de l''ULM pendulaire.',
    E'## Genesis\nThe **US Army** and the **US Air Force** wanted a simple short take-off aircraft for patrol, reconnaissance and light transport of people or freight, whenever a more specialised aircraft was not required or available. **Ryan Aeronautical** answered, in collaboration with **NASA**, with a new kind of machine: a utility vehicle carried by a flexible wing. A first craft, the **Flex-Wing**, led the way. Its improved version, designated XV-8 and nicknamed ''**Fleep**'', short for ''Flying Jeep'', was tested in 1961.\n\n## Design\nThe Fleep was carried by a fabric delta wing of the **Rogallo** type, named after the engineer **Francis Rogallo**, stretched over a foldable frame: for transport it folded into a relatively small package. Beneath it sat a pod-like cockpit on a wheeled cargo platform. Compared with the Flex-Wing, which had four-wheel landing gear, a smaller nose behind which the pilot sat and a single fin, the Fleep had tricycle gear, a larger nose section and a V-tail; it was in fact tested with both tail configurations. Power came from a 210 hp **Continental IO-360-A** engine.\n\n## Testing\nBuilt as a single example, the Fleep flew in 1961. In 1962 it was installed full-size in the large wind tunnel of NASA''s **Langley** Research Center, where the behaviour of its flexible wing was studied. Its performance was modest: a maximum speed of 105 km/h and a range of 193 km, for a span of 10.18 m. No production followed.\n\n## Place in history\nThe XV-8 set out to turn a powered Rogallo wing into a military vehicle; it was contemporary with the **Paresev**, NASA''s research glider. Like the other ''flying jeeps'' studied for the Army, it led nowhere, but its layout, a foldable flexible wing above a powered cart, foreshadowed the hang glider and the weight-shift microlight.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1961-01-01',
    NULL,
    105,
    193,
    (SELECT id FROM manufacturer WHERE code = 'RYA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan XV-8 Fleep'), (SELECT id FROM tech WHERE name = 'Aile souple Rogallo'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan XV-8 Fleep'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = 10.18,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Continental IO-360-A (210 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Flex-Wing** : premier démonstrateur, train à quatre roues, petit nez derrière lequel s''asseyait le pilote, dérive unique\n- **XV-8 (Fleep)** : version améliorée, train tricycle, nez plus volumineux, empennage en V\n- **Essais d''empennage** : le Fleep vole avec une dérive classique puis avec un empennage en V\n- **Essais à Langley** : appareil complet installé en 1962 dans la grande soufflerie de la NASA',
  variants_en       = E'- **Flex-Wing**: first demonstrator, four-wheel landing gear, small nose behind which the pilot sat, single fin\n- **XV-8 (Fleep)**: improved version, tricycle gear, larger nose section, V-tail\n- **Tail trials**: the Fleep was tested with a conventional fin and with a V-tail\n- **Langley tests**: complete aircraft installed in NASA''s full-scale wind tunnel in 1962',

  -- Strate 4 : qualitatif
  nickname          = 'Fleep',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ryan_XV-8',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'Ryan XV-8 Fleep';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Ryan XV-8 Fleep';
