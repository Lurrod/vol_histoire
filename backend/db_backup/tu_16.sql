-- Tupolev Tu-16 Badger
--
-- Photo : Tupolev Tu-16 flies over USS Hewitt (DD-966) c1978.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3ATupolev_Tu-16_flies_over_USS_Hewitt_%28DD-966%29_c1978.jpg

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
    'Tu-16',
    'Tu-16',
    'Tupolev Tu-16 Badger',
    'Tupolev Tu-16 Badger',
    'Bombardier moyen soviétique, matrice du Xian H-6 chinois',
    'Soviet medium bomber, template of the Chinese Xian H-6',
    '/assets/airplanes/tu16-badger.jpg',
    E'## Genèse\nPremier bombardier à réaction soviétique réellement opérationnel, le Tu-16 naît de la nécessité d''atteindre l''Europe occidentale et les bases américaines périphériques. Tupolev reprend l''aile en flèche et l''architecture générale du programme d''après-guerre, avec deux réacteurs enterrés à l''emplanture.\n\n## Conception\nLes moteurs sont logés contre le fuselage plutôt que sous l''aile : la traînée baisse, mais toute évolution de motorisation devient quasi impossible. L''équipage de six comprend des mitrailleurs de tourelles téléopérées. La grande innovation viendra des versions **K**, porteuses de missiles antinavires lourds tirés à des centaines de kilomètres.\n\n## Carrière opérationnelle\nCœur de l''aviation à long rayon d''action soviétique pendant trente ans, il escorte régulièrement les porte-avions américains — une pratique dont sont issues d''innombrables photographies d''interception. L''Égypte et l''Irak l''engagent au combat ; l''URSS l''utilise en **Afghanistan** pour des bombardements de saturation.\n\n## Place dans l''histoire\nSa vraie postérité est chinoise : produit sous licence sous le nom de **Xian H-6**, il vole toujours aujourd''hui, remotorisé et armé de missiles de croisière, plus de soixante-dix ans après son premier vol. Peu d''avions de combat peuvent en dire autant.',
    E'## Genesis\nThe first genuinely operational Soviet jet bomber, the Tu-16 was born of the need to reach Western Europe and America’s peripheral bases. Tupolev reused the swept wing and general architecture of the post-war programme, with two engines buried at the wing roots.\n\n## Design\nThe engines sit against the fuselage rather than under the wing: drag falls, but any change of powerplant becomes nearly impossible. The crew of six included gunners for remotely operated turrets. The real innovation came with the **K** versions, carrying heavy anti-ship missiles fired from hundreds of kilometres away.\n\n## Operational career\nThe core of Soviet long-range aviation for thirty years, it routinely shadowed American carriers — a practice that produced countless intercept photographs. Egypt and Iraq used it in combat; the USSR employed it in **Afghanistan** for saturation bombing.\n\n## Place in history\nIts real legacy is Chinese: licence-built as the **Xian H-6**, it still flies today, re-engined and armed with cruise missiles, more than seventy years after its first flight. Few combat aircraft can say as much.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1948-01-01',
    '1952-04-27',
    '1954-04-01',
    1050.0,
    7200.0,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM tech WHERE name = 'Radar Obzor-K')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM armement WHERE name = 'NR-23')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM armement WHERE name = 'Kh-20')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM armement WHERE name = 'Kh-22')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM armement WHERE name = 'FAB-1500')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM armement WHERE name = 'FAB-3000'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak')),
((SELECT id FROM airplanes WHERE name = 'Tu-16'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 34.8,
  wingspan          = 33.0,
  height            = 10.36,
  wing_area         = 164.65,
  empty_weight      = 37200,
  mtow              = 79000,
  service_ceiling   = 12800,
  climb_rate        = 21,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3000,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Mikulin AM-3M-500',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 93.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1963,
  units_built       = 1509,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **Tu-16A** : bombardier nucléaire\n- **Tu-16K** : porteur de missiles antinavires\n- **Tu-16R** : reconnaissance et renseignement électronique\n- **Xian H-6** : production sous licence chinoise, toujours en service et modernisée',
  variants_en       = E'- **Tu-16A** : nuclear bomber\n- **Tu-16K** : anti-ship missile carrier\n- **Tu-16R** : reconnaissance and electronic intelligence\n- **Xian H-6** : Chinese licence production, still in service and modernised',

  -- Strate 4 : qualitatif
  nickname          = 'Badger',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tupolev_Tu-16',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tupolev_Tu-16',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Tu-16';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tu-16';
