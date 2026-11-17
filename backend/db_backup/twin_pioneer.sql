-- Scottish Aviation Twin Pioneer
--
-- Photo : Twin Pioneer (14366962006).jpg
--   licence CC BY 2.0 — Ozzy Delaney
--   https://commons.wikimedia.org/wiki/File:Twin_Pioneer_(14366962006).jpg

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
    'Scottish Aviation Twin Pioneer',
    'Scottish Aviation Twin Pioneer',
    'Scottish Aviation Twin Pioneer',
    'Scottish Aviation Twin Pioneer',
    'Un bimoteur à décollage court taillé pour la jungle de Bornéo et les déserts d''Aden, avec la RAF',
    'A twin-engined STOL transport built for the jungles of Borneo and the deserts of Aden with the RAF',
    '/assets/airplanes/twin-pioneer.jpg',
    E'## Genèse\nÀ Prestwick, en Écosse, **Scottish Aviation** produit déjà le Pioneer, un monomoteur de transport léger à décollage court. Le **Twin Pioneer** en est la version bimoteur, pensée d''emblée pour les opérateurs civils comme militaires : comme son aîné, il ne demande qu''une bande de 30 m sur 275 m pour opérer. Le prototype G-ANTP vole à Prestwick le 25 juin 1955 ; les essais confirment une course à l''atterrissage très courte, et l''avion se montre au salon de Farnborough en septembre.\n\n## Conception\nC''est un monoplan à aile haute et cabine, à trois dérives et train classique fixe. Deux moteurs en étoile **Alvis Leonides** de 540 ch entraînent des hélices tripales ; la version militaire emporte seize passagers, douze soldats équipés, dix parachutistes, douze civières ou 1 542 kg de fret largable, et peut porter jusqu''à 907 kg de bombes sous les carénages du train. La série 2 reçoit des Pratt & Whitney R-1340 pour Philippine Air Lines, la série 3 des Leonides 531 améliorés. En 1957, deux accidents mortels dus à la rupture en fatigue de la partie extérieure de l''aile imposent une profonde reprise de la structure, qui pèse sur les ventes.\n\n## Carrière opérationnelle\nLa **Royal Air Force** commande 39 appareils, construits en 1958 et 1959 et déployés à Aden et en Extrême-Orient. À Khormaksar, le No. 78 Squadron en reçoit en août 1959 pour transporter troupes et ravitaillement dans le désert et soutenir à l''occasion le sultan d''Oman ; des doubles pannes moteur et des pistes inadaptées y coûtent des appareils. Depuis Seletar, le No. 209 Squadron opère en Malaisie et à Bornéo : le Twin Pioneer est largement employé pendant l''**insurrection malaise**, puis pendant la **confrontation de Bornéo** avec l''Indonésie. Le 16 janvier 1962, l''un d''eux devient le premier avion de la toute jeune force aérienne malaisienne, qui en reçoit quinze et les garde douze ans.\n\n## Place dans l''histoire\nQuatre-vingt-sept Twin Pioneer sont construits. Outre la RAF et la Malaisie, ils servent les forces d''Oman, d''Indonésie et du Népal, mais aussi des compagnies aériennes et des sociétés de prospection pétrolière ou de levés, de la Nouvelle-Guinée néerlandaise à la Suisse. L''Empire Test Pilots'' School en garde un pour l''entraînement au vol court jusqu''en 1974. Il incarne le transport tactique léger des derniers théâtres impériaux britanniques, à l''aise sur les terrains improvisés.',
    E'## Genesis\nAt Prestwick, in Scotland, **Scottish Aviation** was already building the Pioneer, a short take-off single-engined light transport. The **Twin Pioneer** is its twin-engined version, intended from the start for both civil and military operators: like its predecessor, it needed a strip only 30 m by 275 m. The prototype G-ANTP flew at Prestwick on 25 June 1955; trials confirmed a very short landing run, and the aircraft was shown at the Farnborough show in September.\n\n## Design\nIt is a high-wing cabin monoplane with three fins and fixed tailwheel landing gear. Two 540 hp **Alvis Leonides** radials drive three-blade propellers; the military version carries sixteen passengers, twelve equipped troops, ten paratroops, twelve stretchers or 1,542 kg of air-droppable cargo, and can carry up to 907 kg of bombs under the undercarriage sponsons. The Series 2 received Pratt & Whitney R-1340s for Philippine Air Lines, the Series 3 improved Leonides 531s. In 1957 two fatal accidents caused by fatigue failure of the outer wing forced a major structural redesign, which hurt sales.\n\n## Operational career\nThe **Royal Air Force** ordered 39 aircraft, built in 1958 and 1959 and deployed to Aden and the Far East. At Khormaksar, No. 78 Squadron received some in August 1959 to move troops and supplies across the desert and occasionally support the Sultan of Oman; double engine failures and unsuitable strips cost it aircraft. From Seletar, No. 209 Squadron operated in Malaya and Borneo: the Twin Pioneer was used extensively during the **Malayan Emergency** and then the **Borneo confrontation** with Indonesia. On 16 January 1962 one became the first aircraft of the newly formed Royal Malaysian Air Force, which received fifteen and kept them twelve years.\n\n## Place in history\nEighty-seven Twin Pioneers were built. Besides the RAF and Malaysia, they served the forces of Oman, Indonesia and Nepal, as well as airlines and oil-prospecting or survey companies, from Netherlands New Guinea to Switzerland. The Empire Test Pilots'' School kept one for short-field training until 1974. It embodies the light tactical transport of Britain''s last imperial theatres, at home on improvised strips.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    NULL,
    '1955-06-25',
    '1956-01-01',
    266,
    1273,
    (SELECT id FROM manufacturer WHERE code = 'SAL'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Twin Pioneer'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Twin Pioneer'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Twin Pioneer'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Twin Pioneer'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Twin Pioneer'), (SELECT id FROM wars WHERE name = 'Insurrection malaise')),
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Twin Pioneer'), (SELECT id FROM wars WHERE name = 'Confrontation indonésio-malaisienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.79,
  wingspan          = 23.32,
  height            = 3.73,
  wing_area         = 62,
  empty_weight      = 4354,
  mtow              = 6622,
  service_ceiling   = 5200,
  climb_rate        = 6.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Alvis Leonides 514/8 (540 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 87,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **Série 1** : version de production à Alvis Leonides 514 de 560 ch, 23 exemplaires\n- **CC.Mk 1** : version militaire de la série 1 pour la RAF, 32 exemplaires\n- **Série 2** : version à Pratt & Whitney R-1340 de 600 ch, 6 exemplaires\n- **Série 3** : version à Alvis Leonides 531 de 640 ch, 18 exemplaires, standard auquel sont portés les CC.Mk 1 restants\n- **CC.Mk 2** : version militaire de la série 3 pour la RAF, 7 exemplaires',
  variants_en       = E'- **Series 1**: production version with 560 hp Alvis Leonides 514s, 23 built\n- **CC.Mk 1**: military Series 1 for the RAF, 32 built\n- **Series 2**: version with 600 hp Pratt & Whitney R-1340s, 6 built\n- **Series 3**: version with 640 hp Alvis Leonides 531s, 18 built, the standard to which the remaining CC.Mk 1s were converted\n- **CC.Mk 2**: military Series 3 for the RAF, 7 built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Scottish_Aviation_Twin_Pioneer',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ozzy Delaney',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Scottish Aviation Twin Pioneer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Scottish Aviation Twin Pioneer';
