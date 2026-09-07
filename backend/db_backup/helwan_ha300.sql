-- Helwan HA-300
--
-- Photo : Helwan HA-300, Flugwerft Schleißheim.jpg
--   licence CC BY 3.0 de — High Contrast
--   https://commons.wikimedia.org/wiki/File%3AHelwan_HA-300%2C_Flugwerft_Schlei%C3%9Fheim.jpg

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
    'Helwan HA-300',
    'Helwan HA-300',
    'Helwan HA-300',
    'Helwan HA-300',
    'Seul chasseur de conception arabe, dessiné par l’ingénieur du Messerschmitt 262',
    'The only Arab-designed fighter, drawn by the engineer behind the Messerschmitt 262',
    '/assets/airplanes/ha300.jpg',
    E'## Genèse\nNasser veut une industrie aéronautique nationale, et il a les moyens de recruter : **Willy Messerschmitt**, interdit de construction aéronautique en Allemagne après 1945, dessine pour l''Espagne un chasseur léger, le HA-300, dont Madrid ne veut finalement pas. L''Égypte rachète le projet en 1960, fait venir Messerschmitt et une équipe d''ingénieurs allemands et autrichiens, et installe le tout à Helwan, au sud du Caire.\n\n## Conception\nUn intercepteur **minuscule** : cinq mètres quatre-vingt-quatre d''envergure, deux tonnes à vide, soit la moitié d''un MiG-21 contemporain. Delta pur, entrée d''air frontale à cône central, empennage entièrement mobile. La philosophie est celle du chasseur léger de point : monter vite, intercepter, se poser. Le réacteur **E-300** est développé en parallèle à Helwan par Ferdinand Brandner, ancien de Junkers passé par les bureaux d''études soviétiques.\n\n## Carrière opérationnelle\nAucune. Le premier vol a lieu le 7 mars 1964, aux mains d''un pilote d''essai indien. Trois prototypes sont construits, dont deux volent. La **guerre des Six Jours** en 1967 ruine les finances égyptiennes et détruit une partie de l''aviation du pays ; l''URSS livre alors des MiG-21 en masse et à crédit. Le programme est arrêté en 1969, Messerschmitt rentre en Allemagne.\n\n## Place dans l''histoire\nTrois exemplaires, et le seul avion de combat jamais conçu dans le monde arabe. Il illustre une trajectoire fréquente : l''ambition industrielle d''un pays émergent, réelle et sérieusement financée, que la disponibilité immédiate d''un **MiG-21** soviétique rend économiquement absurde. Le V1 survivant a été offert à l''Allemagne en 1985.',
    E'## Genesis\nNasser wanted a national aircraft industry, and he had the means to recruit: **Willy Messerschmitt**, barred from aircraft construction in Germany after 1945, drew a light fighter for Spain, the HA-300, which Madrid ultimately did not want. Egypt bought the project in 1960, brought over Messerschmitt and a team of German and Austrian engineers, and set the whole thing up at Helwan, south of Cairo.\n\n## Design\nA **tiny** interceptor: five metres eighty-four of span, two tonnes empty, half a contemporary MiG-21. A pure delta, a nose intake with a centre cone, an all-moving tail. The philosophy is that of the light point-defence fighter: climb fast, intercept, land. The **E-300** engine was developed in parallel at Helwan by Ferdinand Brandner, formerly of Junkers by way of the Soviet design bureaux.\n\n## Operational career\nNone. The first flight took place on 7 March 1964, in the hands of an Indian test pilot. Three prototypes were built, two of which flew. The **Six-Day War** of 1967 ruined Egypt''s finances and destroyed part of the country''s air force; the USSR then delivered MiG-21s in quantity and on credit. The programme was stopped in 1969 and Messerschmitt went home to Germany.\n\n## Place in history\nThree aircraft, and the only combat aircraft ever designed in the Arab world. It illustrates a frequent trajectory: the industrial ambition of an emerging country, real and seriously funded, made economically absurd by the immediate availability of a Soviet **MiG-21**. The surviving V1 was presented to Germany in 1985.',
    (SELECT id FROM countries WHERE code = 'EGY'),
    '1959-01-01',
    '1964-03-07',
    NULL,
    2100.0,
    1400.0,
    (SELECT id FROM manufacturer WHERE code = 'HEL'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Helwan HA-300'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Helwan HA-300'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Helwan HA-300'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Helwan HA-300'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.4,
  wingspan          = 5.84,
  height            = 3.15,
  wing_area         = 16.7,
  empty_weight      = 2100,
  mtow              = 5443,
  service_ceiling   = 17000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 350,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Brandner E-300',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 32.4,
  thrust_wet        = 42.6,

  -- Strate 3 : production & service
  production_start  = 1962,
  production_end    = 1969,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **HA-300 V1** : premier prototype, réacteur Bristol Orpheus provisoire\n- **HA-300 V2** : second exemplaire, vol en juillet 1965\n- **HA-300 V3** : premier à recevoir le réacteur égyptien **E-300**, jamais achevé\n- Conçu par **Willy Messerschmitt**, auteur du Bf 109 et du Me 262\n- Le V1 survivant est exposé au musée Deutsches de Munich, rendu à l''Allemagne en 1985',
  variants_en       = E'- **HA-300 V1** : first prototype, with a stopgap Bristol Orpheus engine\n- **HA-300 V2** : second aircraft, flown in July 1965\n- **HA-300 V3** : first to receive the Egyptian **E-300** engine, never completed\n- Designed by **Willy Messerschmitt**, creator of the Bf 109 and the Me 262\n- The surviving V1 is displayed at the Deutsches Museum in Munich, returned to Germany in 1985',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Helwan_HA-300',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Helwan_HA-300',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'High Contrast',
  image_licence     = 'CC BY 3.0 de'
WHERE name = 'Helwan HA-300';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Helwan HA-300';
