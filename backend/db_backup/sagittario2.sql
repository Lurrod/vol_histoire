-- Aerfer Sagittario 2
--
-- Photo : Sagittario 2 MUSAM.jpg
--   licence CC BY-SA 4.0 — Allions
--   https://commons.wikimedia.org/wiki/File:Sagittario_2_MUSAM.jpg

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
    'Aerfer Sagittario 2',
    'Aerfer Sagittario 2',
    'Aerfer Sagittario 2',
    'Aerfer Sagittario 2',
    'Chasseur léger à réacteur dans le nez, recalé au concours de l''OTAN mais premier avion italien supersonique',
    'Nose-engined light fighter that lost NATO''s competition but became the first Italian aircraft to go supersonic',
    '/assets/airplanes/sagittario-2.jpg',
    E'## Genèse\nEn décembre 1953, tirant les leçons de la guerre de Corée, le commandement suprême de l''OTAN publie la **NBMR-1**, programme d''avion d''appui tactique léger : décollage court depuis des pistes en herbe ou des routes, Mach 0,95, blindage du pilote et des réservoirs, et une masse maximale de 4 700 kg. **Aerfer**, à Pomigliano d''Arco près de Naples, y répond avec un projet de l''ingénieur **Sergio Stefanutti** : le Sagittario 2, tiré du **Sagittario** d''Ambrosini, lui-même dérivé de l''avion-école à moteur à pistons S.7. Le 30 juin 1955, les lauréats sont annoncés : le Breguet Taon, le **Fiat G.91** et le Mystère XXVI. Le Sagittario 2 n''en fait pas partie.\n\n## Conception\nCompact et entièrement métallique, ce qui explique sa construction chez Aerfer plutôt que chez Ambrosini, le Sagittario 2 conserve la formule de son aîné : voilure et empennages en forte flèche, réacteur logé dans le nez et tuyère débouchant sous le fuselage central. Le Bristol Siddeley Orpheus retenu pour la série n''étant pas prêt, les prototypes reçoivent un **Rolls-Royce Derwent 9** centrifuge de 16 kN. Le poste de pilotage avance sous une verrière en bulle, le train devient tricycle, et l''armement prévu comprend deux canons Hispano-Suiza HSS 825 de 30 mm et deux points d''emport pour bombes de 227 kg, bidons de napalm ou roquettes.\n\n## Essais\nMalgré l''échec au concours, Aerfer poursuit le programme et achève deux prototypes. Le premier vol a lieu le 19 mai 1956. Le 4 décembre 1956, piloté par le lieutenant-colonel **Giovanni Franchini**, un prototype atteint Mach 1,1 en piqué depuis 13 725 m : c''est la première fois qu''un avion italien franchit le mur du son. L''un des avions est présenté au Salon du Bourget en 1957 aux couleurs de l''Aeronautica Militare, dont les pilotes évaluent l''appareil sans qu''aucune commande ne suive. Les essais s''achèvent à la fin des années 1950.\n\n## Place dans l''histoire\nLe Sagittario 2 illustre l''effervescence suscitée par le concours de l''OTAN, qui a vu dix projets s''affronter, dont neuf motorisés par l''Orpheus. Battu par le G.91, il n''en a pas moins offert à l''Italie son premier vol supersonique, avec un simple réacteur centrifuge provisoire et un dessin hérité d''un avion-école à moteur à pistons. Le travail d''Aerfer se poursuit avec l''**Ariete**, qui en dérive directement.',
    E'## Genesis\nIn December 1953, drawing on the lessons of the Korean War, NATO''s Supreme Command issued **NBMR-1**, a requirement for a light tactical support aircraft: short take-off from grass strips or roads, Mach 0.95, armour for the pilot and fuel tanks, and a maximum weight of 4,700 kg. **Aerfer**, at Pomigliano d''Arco near Naples, answered with a design by the engineer **Sergio Stefanutti**: the Sagittario 2, developed from Ambrosini''s **Sagittario**, itself derived from the piston-engined S.7 trainer. On 30 June 1955 the winners were announced: the Breguet Taon, the **Fiat G.91** and the Mystère XXVI. The Sagittario 2 was not among them.\n\n## Design\nCompact and all-metal, which is why it was built by Aerfer rather than by Ambrosini, the Sagittario 2 kept the layout of its forebear: highly swept wings and tail, an engine mounted in the nose and an exhaust under the mid-fuselage. As the Bristol Siddeley Orpheus chosen for production was not ready, the prototypes were fitted with a 16 kN **Rolls-Royce Derwent 9** centrifugal-flow turbojet. The cockpit moved forward under a bubble canopy, the undercarriage became a tricycle, and the planned armament comprised two 30 mm Hispano-Suiza HSS 825 cannon and two hardpoints for 227 kg bombs, napalm tanks or rockets.\n\n## Testing\nDespite losing the competition, Aerfer pressed on and completed two prototypes. The first flight took place on 19 May 1956. On 4 December 1956, flown by Lieutenant Colonel **Giovanni Franchini**, a prototype reached Mach 1.1 in a dive from 13,725 m: the first time an Italian aircraft had broken the sound barrier. One aircraft was shown at the 1957 Paris Air Show in Italian Air Force markings, and air force pilots evaluated the type, but no order followed. Testing ended in the late 1950s.\n\n## Place in history\nThe Sagittario 2 reflects the ferment stirred up by the NATO competition, in which ten designs took part, nine of them powered by the Orpheus. Beaten by the G.91, it nonetheless gave Italy its first supersonic flight, with a stopgap centrifugal-flow engine and a lineage going back to a piston-engined trainer. Aerfer''s work continued with the **Ariete**, directly derived from it.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1953-12-01',
    '1956-05-19',
    NULL,
    1006,
    765,
    (SELECT id FROM manufacturer WHERE code = 'AERF'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aerfer Sagittario 2'), (SELECT id FROM tech WHERE name = 'Aile à forte flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aerfer Sagittario 2'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Aerfer Sagittario 2'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Aerfer Sagittario 2'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.5,
  wingspan          = 7.5,
  height            = 2.02,
  wing_area         = 14.73,
  empty_weight      = 2300,
  mtow              = 3293,
  service_ceiling   = 14000,
  climb_rate        = 42,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Derwent 9',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 16,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Sagittario** (Ambrosini) : prédécesseur à réacteur Turbomeca, dérivé de l''avion-école S.7\n- **Sagittario 2** : deux prototypes (MM560 et MM561) à réacteur Rolls-Royce Derwent 9\n- **Version de série prévue** : réacteur Bristol Siddeley Orpheus, jamais construite\n- **Ariete** : développement ultérieur d''Aerfer, dérivé du Sagittario 2',
  variants_en       = E'- **Sagittario** (Ambrosini): Turbomeca-powered forebear, derived from the S.7 trainer\n- **Sagittario 2**: two prototypes (MM560 and MM561) powered by the Rolls-Royce Derwent 9\n- **Planned production version**: Bristol Siddeley Orpheus engine, never built\n- **Ariete**: later Aerfer development, derived from the Sagittario 2',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aerfer_Sagittario_II',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aerfer_Sagittario_2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Allions',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Aerfer Sagittario 2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aerfer Sagittario 2';
