-- Antonov An-14 Pchelka
--
-- Photo : Aviation Museum in Plovdiv 62.jpg
--   licence CC BY-SA 4.0 — Vislupus
--   https://commons.wikimedia.org/wiki/File:Aviation_Museum_in_Plovdiv_62.jpg

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
    'Antonov An-14',
    'Antonov An-14',
    'Antonov An-14 Pchelka',
    'Antonov An-14 Pchelka',
    'La « petite abeille » bimoteur d''Antonov, conçue pour succéder à l''An-2 et qui n''y parvint jamais',
    'Antonov''s twin-engined Little Bee, meant to succeed the An-2 and never managing it',
    '/assets/airplanes/antonov-an14.jpg',
    E'## Genèse\nÀ la fin des années 1950, les autorités soviétiques veulent un successeur à l''**Antonov An-2**, le grand biplan à tout faire. Le cahier des charges réclame un avion robuste et polyvalent, capable de transporter passagers et fret, de faire de l''épandage agricole ou de servir d''ambulance, de décoller court et d''être piloté après quelques heures d''apprentissage. Le prototype de l''**An-14** vole le 15 mars 1958. L''Aeroflot compte le mettre en service dès 1959, mais le bureau d''études Antonov est accaparé par les difficultés de l''**An-10**, et le prototype a ses propres défauts.\n\n## Conception\nL''An-14 est un bimoteur à aile haute contreventée, au fuselage semi-monocoque entièrement métallique. Ses deux moteurs en étoile **Ivchenko AI-14RF** de 300 ch entraînent des hélices tripales ; l''aile porte des becs automatiques et des volets d''intrados, et deux dérives, placées aux extrémités du plan horizontal, baignent dans le souffle des hélices. Il décolle et se pose sur une centaine de mètres. Le train tricycle fixe peut recevoir des skis, et une grande porte arrière donne accès à une cabine de sept passagers ou 600 kg de fret, ou six civières et un infirmier en version sanitaire. Très stable, il peut être confié à la plupart des pilotes après une courte formation.\n\n## Carrière opérationnelle\nAprès huit ans de mises au point, la production de l''**An-14A**, à l''aile et à l''empennage modifiés, commence en 1965 à l''usine d''Arseniev, et l''avion entre en service en 1966. L''armée de l''air soviétique l''emploie aux côtés de l''Aeroflot. Quinze appareils sont exportés : quatre rejoignent en 1966 l''escadrille de liaison de l''armée de l''air est-allemande à Strausberg, où ils volent jusqu''en 1980 ou 1981, l''aviation afghane en aligne douze de 1985 à 1991, la Mongolie deux, et la Guinée en reçoit aussi pour ses forces armées.\n\n## Place dans l''histoire\nLa « petite abeille » ne parvient pas à remplacer l''An-2, plus rustique, qui reste en production bien plus longtemps. Elle ouvre pourtant une lignée : son dérivé à turbopropulseurs, l''**An-14M**, au fuselage allongé et à l''aile hypersustentée, vole en 1969 et devient l''**Antonov An-28**. Construit à 332 exemplaires, l''An-14 vole encore en petit nombre.',
    E'## Genesis\nIn the late 1950s the Soviet authorities wanted a successor to the **Antonov An-2**, the big do-everything biplane. The requirement called for a rugged, versatile aircraft able to carry passengers and freight, spray crops or serve as an air ambulance, take off in a short distance and be flown after a few hours'' training. The **An-14** prototype flew on 15 March 1958. Aeroflot planned to put it into service in 1959, but the Antonov design bureau was tied up with the problems of the **An-10**, and the prototype had issues of its own.\n\n## Design\nThe An-14 is a strut-braced high-wing twin with an all-metal semi-monocoque fuselage. Its two 300 hp **Ivchenko AI-14RF** radials drive three-blade propellers; the wing carries automatic slats and split flaps, and twin fins mounted at the tips of the tailplane sit in the propeller slipstream. It takes off and lands in about a hundred metres. The fixed tricycle landing gear can be fitted with skis, and a large rear door opens onto a cabin for seven passengers or 600 kg of freight, or six stretchers and a nurse in the ambulance version. Very stable, it could be handed to most pilots after a short conversion.\n\n## Operational career\nAfter eight years of development, production of the **An-14A**, with revised wings and tail, began in 1965 at the Arsenyev factory, and the aircraft entered service in 1966. The Soviet Air Force flew it alongside Aeroflot. Fifteen were exported: four joined the East German Air Force''s liaison squadron at Strausberg in 1966, serving until 1980 or 1981, the Afghan Air Force flew twelve from 1985 to 1991, Mongolia two, and Guinea also received some for its armed forces.\n\n## Place in history\nThe Little Bee failed to replace the more rugged An-2, which stayed in production far longer. Yet it started a line: its turboprop derivative, the **An-14M**, with a stretched fuselage and high-lift wing, flew in 1969 and became the **Antonov An-28**. Built in 332 examples, the An-14 still flies in small numbers.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    NULL,
    '1958-03-15',
    '1966-01-01',
    210,
    650,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-14'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-14'), (SELECT id FROM tech WHERE name = 'Hypersustentation ADAC'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-14'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.36,
  wingspan          = 21.99,
  height            = 4.63,
  wing_area         = 39.72,
  empty_weight      = 2600,
  mtow              = 3600,
  service_ceiling   = 5000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-14RF (300 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1965,
  production_end    = 1972,
  units_built       = 332,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **An-14** : prototype, premier vol le 15 mars 1958\n- **An-14A** : version de série à aile, empennage en V et dérives modifiés, construite à Arseniev à partir de 1965\n- **An-14B** : variante à train escamotable\n- **An-14Sh** : essais d''un train à coussin d''air pour terrains non préparés\n- **An-14M** : version à turbopropulseurs, fuselage allongé, premier vol en 1969, devenue l''**An-28**',
  variants_en       = E'- **An-14**: prototype, first flight on 15 March 1958\n- **An-14A**: production version with revised wing, V-shaped tailplane and fins, built at Arsenyev from 1965\n- **An-14B**: variant with retractable landing gear\n- **An-14Sh**: air-cushion landing gear trials for unprepared strips\n- **An-14M**: turboprop version with stretched fuselage, first flight in 1969, developed into the **An-28**',

  -- Strate 4 : qualitatif
  nickname          = 'Pchelka',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-14',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-14',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Vislupus',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Antonov An-14';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-14';
