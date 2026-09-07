-- McDonnell Douglas F-15 Eagle
--
-- Photo : F-15C Eagle from the 44th Fighter Squadron flies during a routine training exercise April 15, 2019.jpg
--   licence Public domain — Airman 1st Class Matthew Seefeldt
--   https://commons.wikimedia.org/wiki/File%3AF-15C_Eagle_from_the_44th_Fighter_Squadron_flies_during_a_routine_training_exercise_April_15%2C_2019.jpg

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
    'F-15 Eagle',
    'F-15 Eagle',
    'McDonnell Douglas F-15 Eagle',
    'McDonnell Douglas F-15 Eagle',
    'Chasseur de supériorité aérienne invaincu en combat',
    'Air superiority fighter undefeated in combat',
    '/assets/airplanes/f15c-eagle.jpg',
    E'## Genèse\nEn 1967, l''apparition du **MiG-25** au salon de Domodedovo provoque une alerte à Washington : l''appareil semble plus rapide et plus haut volant que tout ce que possède l''US Air Force. La réponse sera un chasseur sans compromis, dédié à un seul métier, résumé par le mot d''ordre du programme : *not a pound for air-to-ground*.\n\n## Conception\nAile immense de 56 m² pour une charge alaire très faible, deux F100 offrant un rapport poussée/poids supérieur à 1, et le premier radar occidental capable de détecter une cible volant plus bas que le chasseur sans être noyé par l''écho du sol — le **look-down / shoot-down**. Le pilote dispose d''une verrière en bulle intégrale, sans montant arrière.\n\n## Carrière opérationnelle\nLe F-15 revendique **plus de 100 victoires aériennes pour aucune perte en combat aérien**, un bilan sans équivalent. L''essentiel revient à l''aviation israélienne, au Liban en 1982 puis contre la Syrie ; l''US Air Force y ajoute une trentaine de MiG irakiens en 1991, et deux MiG-29 serbes en 1999.\n\n## Place dans l''histoire\nCinquante ans après son premier vol, la cellule est toujours en production sous la forme du **F-15EX**. Le F-15 a fixé le standard de la 4e génération occidentale et rendu au chasseur monomission une légitimité que le F-4 Phantom, polyvalent et décevant en combat tournant, avait entamée.',
    E'## Genesis\nIn 1967 the appearance of the **MiG-25** at the Domodedovo air show caused alarm in Washington: the aircraft seemed faster and higher-flying than anything the US Air Force owned. The answer would be an uncompromising fighter dedicated to one job, summed up by the programme’s watchword: *not a pound for air-to-ground*.\n\n## Design\nA vast 56 m² wing for very low wing loading, two F100s giving a thrust-to-weight ratio above 1, and the first Western radar able to detect a target flying below the fighter without drowning in ground clutter — **look-down / shoot-down**. The pilot sits under a full bubble canopy with no rear frame.\n\n## Operational career\nThe F-15 claims **more than 100 aerial victories for no losses in air combat**, a record without equal. Most belong to the Israeli Air Force, over Lebanon in 1982 and then against Syria; the US Air Force added some thirty Iraqi MiGs in 1991 and two Serbian MiG-29s in 1999.\n\n## Place in history\nFifty years after its first flight the airframe is still in production as the **F-15EX**. The F-15 set the standard for the Western fourth generation and restored the legitimacy of the single-mission fighter, which the versatile but disappointing F-4 Phantom had undermined.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1967-01-01',
    '1972-07-27',
    '1976-01-09',
    2655.0,
    5550.0,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-63')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM wars WHERE name = 'Guerre du Liban')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'F-15 Eagle'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.43,
  wingspan          = 13.05,
  height            = 5.63,
  wing_area         = 56.5,
  empty_weight      = 12700,
  mtow              = 30845,
  service_ceiling   = 20000,
  climb_rate        = 254,
  g_limit_pos       = 9.0,
  g_limit_neg       = -3.0,
  combat_radius     = 1900,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney F100-PW-220',
  engine_count      = 2,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 65.3,
  thrust_wet        = 105.7,

  -- Strate 3 : production & service
  production_start  = 1972,
  production_end    = NULL,
  units_built       = 1198,
  unit_cost_usd     = 29900000,
  unit_cost_year    = 1998,
  operators_count   = 5,
  variants          = E'- **F-15A / B** : versions initiales, monoplace et biplace\n- **F-15C / D** : radar et carburant améliorés, version de chasse définitive\n- **F-15E Strike Eagle** : dérivé biplace de frappe, mission entièrement différente\n- **F-15J / F-15I / F-15EX** : versions japonaise, israélienne et dernière évolution américaine',
  variants_en       = E'- **F-15A / B** : initial single- and two-seat versions\n- **F-15C / D** : improved radar and fuel, definitive fighter version\n- **F-15E Strike Eagle** : two-seat strike derivative with a wholly different mission\n- **F-15J / F-15I / F-15EX** : Japanese, Israeli and latest American versions',

  -- Strate 4 : qualitatif
  nickname          = 'Eagle',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_F-15_Eagle',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_F-15_Eagle',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Airman 1st Class Matthew Seefeldt',
  image_licence     = 'Public domain'
WHERE name = 'F-15 Eagle';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-15 Eagle';
