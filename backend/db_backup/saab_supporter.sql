-- Saab MFI-17 Supporter
--
-- Photo : Saab MFI-17 Supporter ‘806 2’ “YOGI” (43567457965).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Saab_MFI-17_Supporter_‘806_2’_“YOGI”_(43567457965).jpg

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
    'Saab MFI-17 Supporter',
    'Saab MFI-17 Supporter',
    'Saab MFI-17 Supporter',
    'Saab MFI-17 Supporter',
    'Biplace suédois à aile haute en flèche inversée, école, observation et appui léger, père des Mushshak pakistanais',
    'Swedish two-seater with a forward-swept high wing, trainer, observer and light attacker, father of Pakistan''s Mushshaks',
    '/assets/airplanes/saab-mfi17-supporter.jpg',
    E'## Genèse\nEn 1968, **Saab** rachète Malmö Flygindustri et, avec elle, l''expérience du petit **MFI-9**. Le 11 juillet 1969 vole le prototype d''un biplace d''école et de servitude, civil comme militaire, le **MFI-15**, mû par un Lycoming de 160 ch. Le moteur se révèle trop juste et l''empennage classique trop exposé sur les terrains sommaires : le prototype reçoit un empennage en T et, le 26 février 1971, le Lycoming IO-360 de 200 ch qui équipera la série, baptisée **Safari**. La version militaire, d''abord désignée MFI-17 puis nommée **Supporter**, vole le 6 juillet 1972.\n\n## Conception\nLe Supporter est un monoplan à aile haute haubanée et train tricycle fixe, où l''instructeur et l''élève sont assis côte à côte avec doubles commandes. Son aile présente une légère flèche inversée, pour que l''emplanture ne masque pas la vue latérale de l''équipage. La version militaire s''en distingue par ses équipements d''école, d''observation d''artillerie, de guidage aérien avancé et de liaison, et par six points d''emport sous voilure pour 300 kg de charges. L''expérience du MFI-9B **MiniCOIN** pendant la guerre du Biafra pousse Saab à en faire aussi un avion d''appui rapproché, armé de roquettes et de nacelles de mitrailleuses.\n\n## Carrière opérationnelle\nLe Supporter entre dans les forces aériennes du Danemark, qui en reçoit 32 sous le nom de **T-17**, de la Norvège, qui achète les siens en 1981, de la Zambie et de la Sierra Leone. Le Pakistan en reçoit 28 de Saab puis assemble 92 appareils à partir de lots en pièces détachées, avant de les construire entièrement chez lui sous le nom de **Mushshak**. En Norvège, seize appareils sont aujourd''hui basés à Bardufoss, et quatre d''entre eux forment la patrouille des **Yellow Sparrows**. Sur les 250 avions entièrement assemblés par Saab, la majorité est pourtant allée à des pilotes privés.\n\n## Place dans l''histoire\nEn comptant les appareils pakistanais, 462 exemplaires de la famille ont été produits. Avec ses descendants, le Mushshak et le **PAC Super Mushshak**, le Safari compte 477 avions en service en 2022, ce qui en fait l''un des avions d''entraînement militaire les plus répandus au monde. Sa formule, aile haute en flèche inversée et cabine panoramique, tranche avec celle des écoles à aile basse de sa génération.',
    E'## Genesis\nIn 1968 **Saab** bought Malmö Flygindustri and, with it, the experience of the small **MFI-9**. On 11 July 1969 the prototype of a two-seat civil and military trainer and utility aircraft, the **MFI-15**, flew with a 160 hp Lycoming. The engine proved too weak and the conventional tail too exposed on rough strips: the prototype received a T-tail and, on 26 February 1971, the 200 hp Lycoming IO-360 adopted for production, under the name **Safari**. The military version, first designated MFI-17 and later named **Supporter**, flew on 6 July 1972.\n\n## Design\nThe Supporter is a braced high-wing monoplane with a fixed tricycle undercarriage, the instructor and student sitting side by side with dual controls. Its wing has a slight forward sweep, so that the wing root does not obscure the crew''s view to the side. The military version differs in its equipment for training, artillery observation, forward air control and liaison, and in six underwing hardpoints for 300 kg of stores. Experience with the MFI-9B **MiniCOIN** in the Biafran war led Saab to make it a close support aircraft as well, armed with rockets and gun pods.\n\n## Operational career\nThe Supporter entered the air forces of Denmark, which received 32 as the **T-17**, Norway, which bought its aircraft in 1981, Zambia and Sierra Leone. Pakistan received 28 from Saab and then assembled 92 from knock-down kits, before building them entirely at home as the **Mushshak**. In Norway sixteen aircraft are now based at Bardufoss, and four of them form the **Yellow Sparrows** display team. Of the 250 aircraft fully assembled by Saab, however, most went to private flyers.\n\n## Place in history\nCounting the Pakistani aircraft, 462 members of the family were produced. Together with its descendants, the Mushshak and the **PAC Super Mushshak**, the Safari had 477 aircraft in service in 2022, making it one of the most widely used military trainers in the world. Its formula, a forward-swept high wing over a panoramic cabin, stands apart from the low-wing trainers of its generation.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    NULL,
    '1972-07-06',
    NULL,
    236,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab MFI-17 Supporter'), (SELECT id FROM tech WHERE name = 'Aile en flèche inversée')),
((SELECT id FROM airplanes WHERE name = 'Saab MFI-17 Supporter'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab MFI-17 Supporter'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Saab MFI-17 Supporter'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Saab MFI-17 Supporter'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Saab MFI-17 Supporter'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.0,
  wingspan          = 8.85,
  height            = 2.6,
  wing_area         = 11.9,
  empty_weight      = 646,
  mtow              = 1200,
  service_ceiling   = 4100,
  climb_rate        = 4.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming IO-360-A1B6 (200 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **MFI-15 Safari** : version civile d''origine, à empennage en T et moteur de 200 ch\n- **MFI-17 Supporter** : version militaire à six points d''emport, désignée T-17 au Danemark\n- **Safari TS** : prototype à moteur suralimenté de 210 ch, non produit\n- **MFI-17 Mushshak** : version construite sous licence au Pakistan, d''abord en kits puis entièrement sur place\n- **PAC Super Mushshak** : évolution pakistanaise remotorisée du Mushshak',
  variants_en       = E'- **MFI-15 Safari**: original civil version, with a T-tail and a 200 hp engine\n- **MFI-17 Supporter**: military version with six hardpoints, designated T-17 in Denmark\n- **Safari TS**: prototype with a 210 hp turbocharged engine, not produced\n- **MFI-17 Mushshak**: version built under licence in Pakistan, first from kits then entirely locally\n- **PAC Super Mushshak**: re-engined Pakistani development of the Mushshak',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Saab_MFI-15_Safari',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saab_Safari',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Saab MFI-17 Supporter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saab MFI-17 Supporter';
