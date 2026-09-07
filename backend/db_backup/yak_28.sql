-- Yakovlev Yak-28 Brewer
--
-- Photo : YaK 28 "Brewer C".jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File%3AYaK_28_%22Brewer_C%22.jpg

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
    'Yak-28',
    'Yak-28',
    'Yakovlev Yak-28 Brewer',
    'Yakovlev Yak-28 Brewer',
    'Bombardier tactique supersonique, décliné en cinq métiers',
    'Supersonic tactical bomber, developed into five different roles',
    '/assets/airplanes/yak28.jpg',
    E'## Genèse\nL''Il-28 est subsonique et vulnérable dès la fin des années 1950. Yakovlev propose son remplaçant en reprenant la cellule du Yak-26 : deux réacteurs en nacelles sous une aile haute, et surtout un train **en tandem** dans le fuselage avec des balancines en bout d''aile, hérité des bombardiers de l''époque.\n\n## Conception\nL''architecture est inhabituelle et contraignante : le train en vélo impose un décollage à plat et une assiette d''atterrissage précise. En contrepartie, l''aile reste fine et non encombrée, ce qui autorise le vol supersonique. Le nez vitré du bombardier-navigateur cède la place, sur les versions d''interception, à un radar.\n\n## Carrière opérationnelle\nPrès de **1 200 exemplaires**, tous soviétiques : le Yak-28 n''a jamais été exporté. Il sert en Allemagne de l''Est face à l''OTAN et en **Afghanistan**, où les versions de guerre électronique brouillent les défenses. En 1966, l''équipage d''un Yak-28 s''écrasant sur Berlin-Ouest reste aux commandes pour éviter les quartiers habités ; l''épave est repêchée par les Britanniques, qui l''examinent avant restitution.\n\n## Place dans l''histoire\nLe Yak-28 est le dernier bombardier tactique de Yakovlev : le bureau se recentre ensuite sur l''entraînement et le décollage vertical. Le **Su-24**, à géométrie variable et bien plus capable, reprend la mission à partir de 1974.',
    E'## Genesis\nBy the late 1950s the Il-28 was subsonic and vulnerable. Yakovlev offered its replacement by reusing the Yak-26 airframe: two engines in nacelles under a high wing and, above all, **tandem** landing gear in the fuselage with outrigger wheels at the wingtips, inherited from the bombers of the period.\n\n## Design\nThe layout was unusual and demanding: bicycle gear forces a flat take-off and a precise landing attitude. In exchange the wing stays thin and uncluttered, which allows supersonic flight. The bombardier’s glazed nose gives way to a radar on the interceptor versions.\n\n## Operational career\nNearly **1,200 built**, all Soviet: the Yak-28 was never exported. It served in East Germany facing NATO and in **Afghanistan**, where the electronic warfare versions jammed the defences. In 1966 the crew of a Yak-28 crashing over West Berlin stayed at the controls to avoid inhabited districts; the wreck was recovered by the British, who examined it before returning it.\n\n## Place in history\nThe Yak-28 was Yakovlev’s last tactical bomber: the bureau then refocused on trainers and vertical take-off. The far more capable variable-geometry **Su-24** took over the mission from 1974.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1956-01-01',
    '1958-03-05',
    '1960-01-01',
    1850.0,
    2630.0,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM armement WHERE name = 'NR-23')),
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM armement WHERE name = 'FAB-1500'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Yak-28'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.02,
  wingspan          = 12.95,
  height            = 4.3,
  wing_area         = 37.6,
  empty_weight      = 9967,
  mtow              = 16160,
  service_ceiling   = 16750,
  climb_rate        = 55,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1100,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Tumansky R-11AF2-300',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 40.2,
  thrust_wet        = 60.8,

  -- Strate 3 : production & service
  production_start  = 1960,
  production_end    = 1971,
  units_built       = 1180,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Yak-28B / L / I** : bombardiers tactiques à systèmes de visée successifs\n- **Yak-28R** : reconnaissance\n- **Yak-28PP** : guerre électronique, brouillage de barrage\n- **Yak-28P Firebar** : intercepteur biplace, cellule allongée',
  variants_en       = E'- **Yak-28B / L / I** : tactical bombers with successive aiming systems\n- **Yak-28R** : reconnaissance\n- **Yak-28PP** : electronic warfare, barrage jamming\n- **Yak-28P Firebar** : two-seat interceptor with a lengthened airframe',

  -- Strate 4 : qualitatif
  nickname          = 'Brewer',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-28',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-28',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Yak-28';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-28';
