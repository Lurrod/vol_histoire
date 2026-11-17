-- Avro Type 707
--
-- Photo : Avro 707 (27353741764).jpg
--   licence CC BY 2.0 — Tony Hisgett from Birmingham, UK
--   https://commons.wikimedia.org/wiki/File:Avro_707_(27353741764).jpg

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
    'Avro 707',
    'Avro 707',
    'Avro Type 707',
    'Avro Type 707',
    'Vulcan au tiers, construit pour apprivoiser l''aile delta du futur bombardier, puis pionnier des commandes électriques',
    'A one-third scale Vulcan built to tame the bomber''s thick delta wing, later a fly-by-wire pioneer',
    '/assets/airplanes/avro-707.jpg',
    E'## Genèse\nPour son bombardier stratégique **Avro 698**, le futur **Vulcan**, **Avro** a choisi une aile delta épaisse sans empennage horizontal, une formule dont le comportement à basse vitesse est alors mal connu. Le ministère de l''Approvisionnement commande donc, au titre de la spécification **E.15/48**, un avion de recherche à basse vitesse reproduisant l''aérodynamique du bombardier à l''échelle un tiers. Le projet est principalement l''œuvre de **Stuart D. Davies**, chef designer d''Avro. Un modèle à mi-échelle, l''Avro 710, est abandonné : il est plus rapide de dériver du 707 une version à grande vitesse.\n\n## Conception\nLe 707 est un petit avion à construction métallique, doté d''une aile delta d''environ 50° de flèche et d''une dérive, mais sans plan horizontal. Le bord de fuite porte des gouvernes de profondeur à l''intérieur et des ailerons à l''extérieur, et des aérofreins sortent au-dessus et au-dessous de l''aile. Pour aller vite, il emprunte des pièces à d''autres avions, comme la verrière du **Gloster Meteor** sur le premier prototype. Tous les 707 sont propulsés par un unique **Rolls-Royce Derwent**, alimenté par une entrée d''air dorsale sur les premiers, puis par des entrées dans l''emplanture des ailes sur le 707A.\n\n## Essais\nLe premier 707 vole le 4 septembre 1949 à Boscombe Down, mais il s''écrase le 30 septembre près de Blackbushe, tuant son pilote, **Eric Esler**. Le **707B**, au nez allongé et à la jambe de train avant rallongée, vole le 6 septembre 1950 et se montre docile. Le **707A**, destiné aux vitesses plus élevées, ressemble à un Vulcan réduit et sert à essayer la flèche brisée du bord d''attaque adoptée sur tous les Vulcan ; un second 707A vole le 20 février 1953. En 1953, les quatre 707 survivants, peints en bleu, rouge, orange et métal naturel, volent à Farnborough aux côtés des deux premiers prototypes du Vulcan.\n\n## Place dans l''histoire\nLe 707 a fourni de précieuses données sur le comportement du Vulcan, surtout grâce aux deux prototypes qui ont volé avant lui. Les avions poursuivent ensuite d''autres recherches : l''un des 707A part en Australie étudier l''écoulement sur une aile delta à basse vitesse, et le **707C** biplace, seul construit des quatre commandés par la RAF, contribue au Royal Aircraft Establishment au développement de l''une des premières commandes de vol électriques, avec mini-manche latéral, jusqu''en 1966. Trois exemplaires sont conservés, en Angleterre et en Australie.',
    E'## Genesis\nFor its **Avro 698** strategic bomber, the future **Vulcan**, **Avro** had chosen a thick tailless delta wing, a layout whose low-speed behaviour was then poorly understood. The Ministry of Supply therefore ordered, under Specification **E.15/48**, a low-speed research aircraft reproducing the bomber''s aerodynamics at one-third scale. The project was mainly the work of **Stuart D. Davies**, Avro''s chief designer. A half-scale aircraft, the Avro 710, was dropped: it was quicker to derive a high-speed version from the 707.\n\n## Design\nThe 707 was a small all-metal aircraft with a delta wing of about 50 degrees of sweep and a fin, but no tailplane. The trailing edge carried inboard elevators and outboard ailerons, and air brakes extended above and below the wing. To save time it borrowed parts from other aircraft, such as the **Gloster Meteor** canopy on the first prototype. Every 707 was powered by a single **Rolls-Royce Derwent**, fed by a dorsal intake on the early aircraft, then by wing-root intakes on the 707A.\n\n## Testing\nThe first 707 flew on 4 September 1949 at Boscombe Down, but crashed near Blackbushe on 30 September, killing its pilot, **Eric Esler**. The **707B**, with a longer nose and a lengthened nosewheel leg, flew on 6 September 1950 and proved docile. The **707A**, intended for higher speeds, looked like a scaled-down Vulcan and was used to test the compound leading-edge sweep adopted on all Vulcans; a second 707A flew on 20 February 1953. In 1953 the four surviving 707s, painted blue, red, orange and natural metal, flew at Farnborough alongside the first two Vulcan prototypes.\n\n## Place in history\nThe 707 provided valuable data on the Vulcan''s handling, mostly from the two prototypes that flew before it. The aircraft then went on to other research: one 707A went to Australia to study low-speed airflow over a delta wing, and the two-seat **707C**, the only one built of the four ordered by the RAF, contributed at the Royal Aircraft Establishment to the development of one of the first fly-by-wire control systems, with a side-stick, until 1966. Three aircraft survive, in England and Australia.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1948-01-01',
    '1949-09-04',
    NULL,
    747,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'AVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro 707'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Avro 707'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro 707'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.9,
  wingspan          = 10.41,
  height            = 3.53,
  wing_area         = 39.0,
  empty_weight      = NULL,
  mtow              = 4536,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Derwent 8',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 16.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **707** (VX784) : premier prototype à entrée d''air dorsale, premier vol le 4 septembre 1949, détruit le 30 septembre 1949\n- **707B** (VX790) : nez allongé, nouvelle verrière, aile à 51° de flèche, premier vol le 6 septembre 1950, endommagé en 1956\n- **707A** (WD280, WZ736) : version à grande vitesse à entrées d''air dans l''emplanture, conservées à Point Cook et à Old Sarum\n- **707C** (WZ744) : biplace côte à côte à double commande, premier vol le 1er juillet 1953, banc d''essai des commandes électriques',
  variants_en       = E'- **707** (VX784): first prototype with a dorsal intake, first flight on 4 September 1949, destroyed on 30 September 1949\n- **707B** (VX790): longer nose, new canopy, 51-degree swept wing, first flight on 6 September 1950, damaged in 1956\n- **707A** (WD280, WZ736): high-speed version with wing-root intakes, preserved at Point Cook and Old Sarum\n- **707C** (WZ744): side-by-side two-seater with dual controls, first flight on 1 July 1953, fly-by-wire testbed',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Avro_707',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Avro_707',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Tony Hisgett',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Avro 707';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Avro 707';
