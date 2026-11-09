-- Nord 1500 Griffon
--
-- Photo : Nord 1500 Griffon II (11717519276).jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany, Germany
--   https://commons.wikimedia.org/wiki/File:Nord_1500_Griffon_II_(11717519276).jpg

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
    'Nord 1500 Griffon',
    'Nord 1500 Griffon',
    'Nord Aviation 1500 Griffon',
    'Nord Aviation 1500 Griffon',
    'Un turboréacteur logé dans un statoréacteur : le Griffon II atteint Mach 2,19',
    'A turbojet housed inside a ramjet: the Griffon II reached Mach 2.19',
    '/assets/airplanes/nord-griffon.jpg',
    E'## Genèse\nAu début des années 1950, l''armée de l''air française veut un intercepteur capable de dépasser Mach 2, alors que les turboréacteurs nationaux plafonnent autour de trois tonnes et demie de poussée. **Nord Aviation** propose de contourner l''obstacle par la propulsion mixte : un turboréacteur pour décoller et accélérer, un statoréacteur pour la grande vitesse, là où il devient plus efficace que tout autre moteur. Une lettre d''intention est signée en 1953, le contrat de deux prototypes en 1955.\n\n## Conception\nUne aile delta, de petits plans canard à l''avant et, sous le poste de pilotage, une large entrée d''air qui alimente un gros conduit cylindrique, véritable fuselage de l''avion. Au centre de ce conduit est logé un **SNECMA Atar 101E-3** ; autour de lui, le statoréacteur brûle l''air qui le contourne. À grande vitesse, le statoréacteur fournit l''essentiel de la poussée, environ 68 kN contre 34 kN pour l''Atar.\n\n## Carrière opérationnelle\nAucune. Le **Griffon I**, doté du seul turboréacteur, vole le **20 septembre 1955** aux mains d''**André Turcat**. Le **Griffon II**, équipé de la propulsion mixte, vole le 23 janvier 1957 et allume son statoréacteur au printemps 1957. Il atteint **Mach 2,19**, et le **25 février 1959**, Turcat établit avec lui le record du monde de vitesse sur 100 km en circuit fermé, à 1 643 km/h. Mais le statoréacteur ne se règle pas finement : il fonctionne presque en tout ou rien, ce qui interdit le pilotage précis qu''exige un chasseur. L''armée de l''air retient le **Mirage III**, plus simple, et les essais du Griffon s''achèvent au début des années 1960.\n\n## Place dans l''histoire\nDeux prototypes, un record et une impasse. Le Griffon a montré qu''un avion piloté pouvait tirer parti du statoréacteur que **René Leduc** avait fait voler en 1949, mais aussi que cette puissance ne se maîtrisait pas encore. Son pilote, André Turcat, fera voler dix ans plus tard le premier **Concorde**. Le principe d''un moteur qui se comporte en statoréacteur à grande vitesse reviendra sur le J58 du **SR-71 Blackbird**. Le Griffon II est conservé au musée de l''Air et de l''Espace du Bourget.',
    E'## Genesis\nIn the early 1950s the French Air Force wanted an interceptor able to exceed Mach 2, while French turbojets topped out at around three and a half tonnes of thrust. **Nord Aviation** proposed to get round the obstacle with mixed propulsion: a turbojet for take-off and acceleration, a ramjet for high speed, where it becomes more efficient than any other engine. A letter of intent was signed in 1953, the contract for two prototypes in 1955.\n\n## Design\nA delta wing, small canard foreplanes and, beneath the cockpit, a large intake feeding a big cylindrical duct that is, in effect, the aircraft’s fuselage. At the centre of this duct sat a **SNECMA Atar 101E-3**; around it, the ramjet burned the air flowing past. At high speed the ramjet supplied most of the thrust, about 68 kN against 34 kN for the Atar.\n\n## Operational career\nNone. The **Griffon I**, fitted with the turbojet alone, flew on **20 September 1955** with **André Turcat** at the controls. The **Griffon II**, with the mixed powerplant, flew on 23 January 1957 and lit its ramjet in the spring of 1957. It reached **Mach 2.19**, and on **25 February 1959** Turcat used it to set the world speed record over a 100 km closed circuit, at 1,643 km/h. But the ramjet could not be finely regulated: it worked almost all-or-nothing, ruling out the precise handling a fighter demands. The Air Force chose the simpler **Mirage III**, and Griffon testing ended in the early 1960s.\n\n## Place in history\nTwo prototypes, a record and a dead end. The Griffon showed that a piloted aircraft could exploit the ramjet **René Leduc** had flown in 1949, but also that such power could not yet be tamed. Its pilot, André Turcat, would fly the first **Concorde** ten years later. The principle of an engine that behaves as a ramjet at high speed would return on the J58 of the **SR-71 Blackbird**. The Griffon II is preserved at the Musée de l’Air et de l’Espace at Le Bourget.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1953-01-01',
    '1955-09-20',
    NULL,
    2330.0,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'NRD'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Nord 1500 Griffon'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Nord 1500 Griffon'), (SELECT id FROM tech WHERE name = 'Aile canard delta'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Nord 1500 Griffon'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Nord 1500 Griffon'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.54,
  wingspan          = 8.1,
  height            = 5.0,
  wing_area         = 32,
  empty_weight      = NULL,
  mtow              = 6745,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA Atar 101E-3 + statoréacteur Nord',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à double flux hybride',
  engine_type_en    = 'Hybrid turbo-ramjet',
  thrust_dry        = 34.3,
  thrust_wet        = 67.8,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Nord 1500-01 Griffon I** : premier prototype, turboréacteur Atar 101 seul, premier vol le 20 septembre 1955\n- **Nord 1500-02 Griffon II** : second prototype à propulsion mixte, premier vol le 23 janvier 1957\n- **Mach 2,19** atteint par le Griffon II\n- **1 643 km/h** sur 100 km en circuit fermé, record du monde d''André Turcat le 25 février 1959\n- **Super Griffon** : version Mach 3 étudiée, jamais construite',
  variants_en       = E'- **Nord 1500-01 Griffon I** : first prototype, Atar 101 turbojet only, first flight on 20 September 1955\n- **Nord 1500-02 Griffon II** : second prototype with mixed propulsion, first flight on 23 January 1957\n- **Mach 2.19** reached by the Griffon II\n- **1,643 km/h** over a 100 km closed circuit, André Turcat’s world record on 25 February 1959\n- **Super Griffon** : Mach 3 version studied, never built',

  -- Strate 4 : qualitatif
  nickname          = 'Griffon',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Nord_1500_Griffon_II',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Nord_1500_Griffon',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clemens Vasters from Viersen, Germany, Germany',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Nord 1500 Griffon';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Nord 1500 Griffon';
