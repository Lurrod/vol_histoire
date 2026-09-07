-- Lockheed D-21 (Tagboard / Senior Bowl)
--
-- Photo : Lockheed M-21 with D-21 drone in flight c1965.JPEG
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3ALockheed_M-21_with_D-21_drone_in_flight_c1965.JPEG

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
    'Lockheed D-21',
    'Lockheed D-21',
    'Lockheed D-21 (Tagboard / Senior Bowl)',
    'Lockheed D-21 (Tagboard / Senior Bowl)',
    'Drone à Mach 3,3 lancé du dos d’un SR-71, quatre missions, zéro succès',
    'A Mach 3.3 drone launched off an SR-71’s back: four missions, no success',
    '/assets/airplanes/d21-tagboard.jpg',
    E'## Genèse\nLa perte du U-2 de Gary Powers en 1960 a démontré qu''aucun appareil piloté n''est à l''abri. La Skunk Works de Lockheed propose une solution radicale : un drone à **Mach 3,3** qui survolerait la Chine sans risquer personne, prendrait ses photos et **larguerait la pellicule** avant de s''autodétruire. Le programme est classé au plus haut niveau sous le nom de **Tagboard**.\n\n## Conception\nLe D-21 est un A-12 miniature sans pilote, en titane, propulsé par un **statoréacteur** — un moteur sans pièce mobile qui ne produit de poussée qu''au-delà de Mach 3. Il faut donc l''amener à cette vitesse : le drone est monté **sur le dos** d''un porteur M-21, lui-même dérivé de l''A-12, et largué en vol supersonique. Manœuvre d''une difficulté extrême.\n\n## Carrière opérationnelle\nLe 30 juillet 1966, un D-21 heurte son porteur au largage ; les deux appareils sont détruits et l''officier de systèmes se noie. Le lancement dorsal est abandonné au profit d''un largage sous **B-52**. **Quatre missions** réelles ont lieu au-dessus de la Chine entre 1969 et 1971 : la première perd le drone, les trois autres échouent à la récupération de la pellicule.\n\n## Place dans l''histoire\nTrente-huit exemplaires, aucun renseignement rapporté. Le programme est annulé en 1971, quand le **satellite de reconnaissance** rend la démarche entière obsolète. Le D-21 reste l''appareil sans pilote le plus rapide jamais construit, et un rappel que l''audace technique ne garantit pas l''utilité opérationnelle.',
    E'## Genesis\nThe loss of Gary Powers''s U-2 in 1960 had shown that no piloted aircraft is safe. Lockheed''s Skunk Works proposed a radical answer: a **Mach 3.3** drone that would overfly China risking nobody, take its photographs and **eject the film** before destroying itself. The programme was classified at the highest level as **Tagboard**.\n\n## Design\nThe D-21 is a miniature unmanned A-12 in titanium, powered by a **ramjet** — an engine with no moving parts that produces thrust only beyond Mach 3. It therefore had to be brought to that speed: the drone rides **on the back** of an M-21 mothership, itself an A-12 derivative, and is released in supersonic flight. A manoeuvre of extreme difficulty.\n\n## Operational career\nOn 30 July 1966 a D-21 struck its mothership at launch; both aircraft were destroyed and the systems officer drowned. Dorsal launch was abandoned for release under a **B-52**. **Four** real missions were flown over China between 1969 and 1971: the first lost the drone, the other three failed at film recovery.\n\n## Place in history\nThirty-eight built, no intelligence brought home. The programme was cancelled in 1971, when the **reconnaissance satellite** made the whole approach obsolete. The D-21 remains the fastest unmanned aircraft ever built, and a reminder that technical daring does not guarantee operational use.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1962-10-01',
    '1964-12-22',
    '1969-11-09',
    3560.0,
    5550.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed D-21'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Lockheed D-21'), (SELECT id FROM tech WHERE name = 'Conception furtive'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed D-21'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed D-21'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.8,
  wingspan          = 5.79,
  height            = 2.19,
  wing_area         = 19.0,
  empty_weight      = 5000,
  mtow              = 5000,
  service_ceiling   = 29000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2700,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Marquardt RJ43-MA-11',
  engine_count      = 1,
  engine_type       = 'Statoréacteur',
  engine_type_en    = 'Ramjet',
  thrust_dry        = 6.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1964,
  production_end    = 1969,
  units_built       = 38,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **D-21 (Tagboard)** : version lancée du dos d''un **M-21**, dérivé biplace du A-12\n- **D-21B (Senior Bowl)** : lancée sous l''aile d''un **B-52H** avec un propulseur-fusée\n- **Statoréacteur** : sans compresseur, il n''a de poussée qu''au-delà de Mach 3\n- Le 30 juillet 1966, un D-21 heurte son porteur au largage : un équipier est tué\n- **Quatre missions** au-dessus de la Chine en 1969-1971, **aucune** pellicule récupérée',
  variants_en       = E'- **D-21 (Tagboard)** : launched from the back of an **M-21**, a two-seat A-12 derivative\n- **D-21B (Senior Bowl)** : launched under a **B-52H** wing with a rocket booster\n- **Ramjet** : having no compressor, it produces thrust only beyond Mach 3\n- On 30 July 1966 a D-21 struck its mothership at launch, killing a crew member\n- **Four missions** over China in 1969–1971, **no** film ever recovered',

  -- Strate 4 : qualitatif
  nickname          = 'Tagboard',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_D-21',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_D-21',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed D-21';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'Lockheed D-21';
