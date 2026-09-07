-- British Aircraft Corporation TSR-2
--
-- Photo : British Aircraft Corporation TSR-2 ‘XR220’ (32111217567).jpg
--   licence CC BY 2.0 — Mike McBey
--   https://commons.wikimedia.org/wiki/File%3ATSR2_XR222_%2840049629783%29.jpg

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
    'BAC TSR-2',
    'BAC TSR-2',
    'British Aircraft Corporation TSR-2',
    'British Aircraft Corporation TSR-2',
    'Bombardier de pénétration britannique annulé en 1965',
    'British strike aircraft cancelled in 1965',
    '/assets/airplanes/bac-tsr2.jpg',
    E'## Genèse\n**TSR** signifie *Tactical Strike and Reconnaissance*. En 1957, la RAF veut un appareil capable de pénétrer les défenses soviétiques à **60 mètres du sol et à Mach 1,1**, de délivrer une arme nucléaire tactique et de rentrer — le tout depuis des terrains sommaires. Le cahier des charges est le plus ambitieux jamais rédigé par la Grande-Bretagne.\n\n## Conception\nAile delta minuscule à extrémités abaissées pour amortir les turbulences à basse altitude, radar de suivi de terrain automatique, centrale à inertie, système de navigation-attaque intégré : le TSR-2 anticipe de dix ans ce que le Tornado apportera. Le prix de cette avance est une complexité inédite, répartie entre des industriels rivaux forcés de fusionner pour le programme.\n\n## Carrière opérationnelle\nIl n''y en aura pas. Le prototype **XR219** vole 24 fois entre septembre 1964 et l''annulation, démontrant des qualités remarquables. Le 6 avril 1965, le gouvernement Wilson arrête le programme pour raisons budgétaires, au profit du F-111 américain — commande elle-même annulée en 1968. La RAF n''obtiendra un équivalent qu''avec le **Tornado**, quinze ans plus tard.\n\n## Place dans l''histoire\nL''ordre fut donné de détruire les outillages et la plupart des cellules, pour rendre toute reprise impossible. Deux appareils survivent en musée. Le TSR-2 est resté dans la mémoire britannique le symbole d''une industrie aéronautique sacrifiée — et l''exemple canonique du programme techniquement réussi, politiquement perdu.',
    E'## Genesis\n**TSR** stood for *Tactical Strike and Reconnaissance*. In 1957 the RAF wanted an aircraft able to penetrate Soviet defences at **60 metres and Mach 1.1**, deliver a tactical nuclear weapon and return — all from rough airstrips. The specification was the most ambitious Britain ever wrote.\n\n## Design\nA tiny delta wing with drooped tips to damp low-level turbulence, automatic terrain-following radar, an inertial platform and an integrated nav-attack system: the TSR-2 anticipated by ten years what the Tornado would deliver. The price of that lead was unprecedented complexity, split between rival firms forced to merge for the programme.\n\n## Operational career\nThere was none. Prototype **XR219** flew 24 times between September 1964 and cancellation, showing remarkable qualities. On 6 April 1965 the Wilson government stopped the programme on budgetary grounds in favour of the American F-111 — an order itself cancelled in 1968. The RAF would not get an equivalent until the **Tornado**, fifteen years later.\n\n## Place in history\nOrders were given to destroy the tooling and most airframes, to make any revival impossible. Two aircraft survive in museums. In British memory the TSR-2 remains the symbol of a sacrificed aviation industry — and the canonical example of a programme technically won and politically lost.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1957-01-01',
    '1964-09-27',
    NULL,
    2390.0,
    4630.0,
    (SELECT id FROM manufacturer WHERE code = 'BAC'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'BAC TSR-2'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'BAC TSR-2'), (SELECT id FROM tech WHERE name = 'Radar de suivi de terrain')),
((SELECT id FROM airplanes WHERE name = 'BAC TSR-2'), (SELECT id FROM tech WHERE name = 'Système de navigation attaque à basse altitude'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'BAC TSR-2'), (SELECT id FROM armement WHERE name = 'WE.177')),
((SELECT id FROM airplanes WHERE name = 'BAC TSR-2'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'BAC TSR-2'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'BAC TSR-2'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'BAC TSR-2'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 27.13,
  wingspan          = 11.28,
  height            = 7.32,
  wing_area         = 65.3,
  empty_weight      = 24834,
  mtow              = 46357,
  service_ceiling   = 16500,
  climb_rate        = 254,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1850,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Siddeley Olympus 22R',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 87.2,
  thrust_wet        = 136.0,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1965,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XR219** : seul prototype à avoir volé, 24 vols d''essai\n- **XR220 / XR222** : cellules achevées mais jamais mises en vol, conservées en musée\n- **Programme annulé** le 6 avril 1965 ; les outillages de production furent détruits',
  variants_en       = E'- **XR219** : the only prototype to fly, 24 test flights\n- **XR220 / XR222** : airframes completed but never flown, preserved in museums\n- **Programme cancelled** on 6 April 1965; the production tooling was destroyed',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/BAC_TSR-2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/BAC_TSR-2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'BAC TSR-2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'BAC TSR-2';
