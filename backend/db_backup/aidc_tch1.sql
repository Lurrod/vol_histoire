-- AIDC T-CH-1 Chung Hsing
--
-- Photo : T-CH-1 in Chengkungling Side View Oct2011.jpg
--   licence Public domain — 玄史生
--   https://commons.wikimedia.org/wiki/File:T-CH-1_in_Chengkungling_Side_View_Oct2011.jpg

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
    'AIDC T-CH-1 Chung Hsing',
    'AIDC T-CH-1 Chung Hsing',
    'AIDC T-CH-1 Chung Hsing',
    'AIDC T-CH-1 Chung Hsing',
    'Le T-28 Trojan repensé à Taïwan autour d''un turbopropulseur, école et avion d''attaque légère',
    'The T-28 Trojan reworked in Taiwan around a turboprop, as trainer and light attack aircraft',
    '/assets/airplanes/aidc-tch1-chung-hsing.jpg',
    E'## Genèse\nAu début des années 1970, Taïwan veut produire lui-même les avions d''entraînement de son armée de l''air. L''étude du futur **T-CH-1 Chung Hsing** commence en novembre 1970 chez **AIDC**, l''Aerospace Industrial Development Corporation, en partant d''un appareil bien connu : le **T-28 Trojan** nord-américain. Le premier prototype, XT-CH-1A, est achevé en septembre 1973 et vole le 23 novembre suivant. Un second prototype, XT-CH-1B, capable d''emporter de l''armement, vole le 27 novembre 1974.\n\n## Conception\nLe Chung Hsing garde la formule du T-28 : un monoplan à aile basse, avec deux places en tandem et un train d''atterrissage tricycle. La grande différence est sous le capot, où le moteur en étoile laisse la place à un turbopropulseur **Avco Lycoming T53** de 1 451 ch, produit sous licence à l''usine de Kang Shan. Le second prototype reçoit une voilure agrandie et des points d''emport sous les ailes. L''avion atteint 590 km/h à 4 600 m, monte à 17 m/s et franchit plus de 2 000 km avec le plein complet, pour une masse maximale de cinq tonnes.\n\n## Carrière opérationnelle\nLa production commence en mai 1976. En plus des deux prototypes, l''armée de l''air de la république de Chine commande 50 appareils, dont le dernier est livré à la fin de 1981. Le T-CH-1 assure l''entraînement de base des pilotes et peut aussi servir à l''attaque légère. Deux variantes en sont tirées : l''**A-CH-1**, destiné à l''instruction au tir et à l''armement, et le **R-CH-1** de reconnaissance. Plusieurs exemplaires sont aujourd''hui exposés, notamment au musée de l''armée de l''air de Gangshan.\n\n## Place dans l''histoire\nConstruit à 52 exemplaires, prototypes compris, le Chung Hsing est né d''une volonté claire : fabriquer à Taïwan, avec un moteur assemblé sur place, les avions des écoles militaires plutôt que de les importer. Il prolonge la carrière d''une formule américaine éprouvée en la modernisant par la turbine, ce qui lui donne des performances d''avion d''appui léger. Dans la même logique, AIDC enchaîne avec l''avion-école à réaction **AIDC AT-3 Tzu Chung**.',
    E'## Genesis\nIn the early 1970s Taiwan wanted to build its own air force trainers. Work on the future **T-CH-1 Chung Hsing** began in November 1970 at **AIDC**, the Aerospace Industrial Development Corporation, starting from a familiar aircraft: the North American **T-28 Trojan**. The first prototype, the XT-CH-1A, was completed in September 1973 and flew on 23 November that year. A second prototype, the XT-CH-1B, able to carry weapons, flew on 27 November 1974.\n\n## Design\nThe Chung Hsing kept the T-28''s formula: a low-wing monoplane with two seats in tandem and a tricycle undercarriage. The big difference lay under the cowling, where the radial engine gave way to a 1,451 hp **Avco Lycoming T53** turboprop, built under licence at the Kang Shan factory. The second prototype received a larger wing and underwing hardpoints. The aircraft reached 590 km/h at 4,600 m, climbed at 17 m/s and covered more than 2,000 km with maximum fuel, for a maximum weight of five tonnes.\n\n## Operational career\nProduction began in May 1976. In addition to the two prototypes, the Republic of China Air Force ordered 50 aircraft, the last delivered in late 1981. The T-CH-1 handled basic pilot training and could also serve in the light attack role. Two variants were derived from it: the **A-CH-1** for gunnery and weapons training, and the **R-CH-1** for reconnaissance. Several examples are now on display, notably at the Air Force Museum in Gangshan.\n\n## Place in history\nBuilt in 52 examples, prototypes included, the Chung Hsing stemmed from a clear aim: to build military school aircraft in Taiwan, with a locally assembled engine, rather than import them. It extended the life of a proven American formula by modernising it with a turbine, giving it the performance of a light attack aircraft. In the same spirit, AIDC went on to the **AIDC AT-3 Tzu Chung** jet trainer.',
    (SELECT id FROM countries WHERE code = 'TWN'),
    '1970-11-01',
    '1973-11-23',
    NULL,
    590,
    2010,
    (SELECT id FROM manufacturer WHERE code = 'AIDC'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AIDC T-CH-1 Chung Hsing'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AIDC T-CH-1 Chung Hsing'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'AIDC T-CH-1 Chung Hsing'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'AIDC T-CH-1 Chung Hsing'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.26,
  wingspan          = 12.19,
  height            = 3.66,
  wing_area         = 25.18,
  empty_weight      = 2608,
  mtow              = 5057,
  service_ceiling   = 9800,
  climb_rate        = 17.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Avco Lycoming T53-L-701 (1 451 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1976,
  production_end    = 1981,
  units_built       = 52,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XT-CH-1A** : premier prototype, premier vol le 23 novembre 1973\n- **XT-CH-1B** : second prototype à voilure agrandie et points d''emport, premier vol le 27 novembre 1974\n- **T-CH-1** : version de série d''entraînement de base et d''attaque légère, 50 exemplaires livrés de 1976 à 1981\n- **A-CH-1** : version d''instruction au tir et à l''armement\n- **R-CH-1** : version de reconnaissance',
  variants_en       = E'- **XT-CH-1A**: first prototype, first flown on 23 November 1973\n- **XT-CH-1B**: second prototype with larger wing and hardpoints, first flown on 27 November 1974\n- **T-CH-1**: production basic trainer and light attack version, 50 delivered from 1976 to 1981\n- **A-CH-1**: gunnery and weapons training version\n- **R-CH-1**: reconnaissance version',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/AIDC_T-CH-1_Chung-Hsing',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AIDC_T-CH-1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '玄史生',
  image_licence     = 'Public domain'
WHERE name = 'AIDC T-CH-1 Chung Hsing';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AIDC T-CH-1 Chung Hsing';
