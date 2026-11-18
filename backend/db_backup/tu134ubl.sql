-- Tupolev Tu-134UBL (Crusty)
--
-- Photo : Меморіальний комплекс.Військові літаки. 059..JPG
--   licence CC BY-SA 3.0 — Vlad2003
--   https://commons.wikimedia.org/wiki/File:%D0%9C%D0%B5%D0%BC%D0%BE%D1%80%D1%96%D0%B0%D0%BB%D1%8C%D0%BD%D0%B8%D0%B9_%D0%BA%D0%BE%D0%BC%D0%BF%D0%BB%D0%B5%D0%BA%D1%81.%D0%92%D1%96%D0%B9%D1%81%D1%8C%D0%BA%D0%BE%D0%B2%D1%96_%D0%BB%D1%96%D1%82%D0%B0%D0%BA%D0%B8._059..JPG

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
    'Tupolev Tu-134UBL',
    'Tupolev Tu-134UBL',
    'Tupolev Tu-134UBL (Crusty)',
    'Tupolev Tu-134UBL (Crusty)',
    'Biréacteur de ligne coiffé du nez du Tu-160 pour former les équipages des bombardiers stratégiques',
    'Twinjet airliner fitted with a Tu-160 nose to train strategic bomber crews',
    '/assets/airplanes/tupolev-tu134ubl.jpg',
    E'## Genèse\nLe **Tu-134** est le biréacteur court et moyen-courrier de l''Union soviétique, construit de 1966 à 1989 à 854 exemplaires. Comme la Caravelle française qui a lancé la mode, il porte ses réacteurs à l''arrière du fuselage et son empennage horizontal en haut de la dérive ; ses premières versions gardent même, héritage des bombardiers Tupolev, un nez vitré pour le navigateur. Robuste, capable d''utiliser des terrains non revêtus, il sert aussi dans de nombreuses armées de l''air, de terre et marines, notamment pour former pilotes et navigateurs. Le **Tu-134UBL** pousse cette logique jusqu''au bout : il sert à entraîner les équipages du bombardier supersonique **Tu-160**.\n\n## Conception\nL''idée est simple : former les équipages d''un bombardier sans mobiliser le bombardier lui-même. Le Tu-134UBL reçoit à cette fin le **cône de nez du Tu-160**, long et effilé, qui lui donne une silhouette unique parmi les avions de ligne. Il garde les deux réacteurs Soloviev D-30 de 66,7 kN, l''aile en flèche et le train à pneus basse pression de l''avion de ligne. Il appartient à toute une famille d''avions-écoles dérivés du Tu-134 : le Tu-134BSh porte le radar du Tu-22M, le Tu-134Sh-1 des lance-bombes, le Tu-134Sh-2 forme les navigateurs des bombardiers tactiques.\n\n## Carrière opérationnelle\nLes Tu-134UBL forment les équipages du Tu-160 aux côtés des autres avions-écoles de la famille. Une version navale, le **Tu-134UBK**, n''est construite qu''à un seul exemplaire. Pendant que le Tu-134 civil quitte peu à peu les lignes, après l''ordre de retrait donné par le président Medvedev en 2011 puis le dernier vol commercial russe en 2019, l''armée de l''air russe continue d''exploiter des Tu-134. Plusieurs UBL sont aujourd''hui préservés, dont l''exemplaire RF-12037 surnommé « **Perle noire** » au musée de l''aviation à long rayon d''action de Tambov, et le « 43 bleu » au musée national de l''aviation de Kiev.\n\n## Place dans l''histoire\nLe Tu-134UBL illustre une solution économique et durable : un avion de ligne transformé en simulateur volant pour les équipages les plus précieux d''une aviation stratégique. La même cellule a ainsi servi au transport de passagers, à l''entraînement des cosmonautes et à la formation des équipages du grand bombardier supersonique soviétique.',
    E'## Genesis\nThe **Tu-134** was the Soviet Union''s short and medium-haul twinjet, built from 1966 to 1989 with 854 produced. Like the French Caravelle that set the trend, it carried its engines on the rear fuselage and its tailplane on top of the fin; its early versions even kept, as a legacy of Tupolev bombers, a glazed nose for the navigator. Rugged and able to use unpaved airfields, it also served many air forces, armies and navies, notably to train pilots and navigators. The **Tu-134UBL** took this logic to its conclusion: it was used to train the crews of the **Tu-160** supersonic bomber.\n\n## Design\nThe idea was simple: train a bomber''s crews without tying up the bomber itself. To that end the Tu-134UBL received the long, pointed **Tu-160 nose cone**, which gave it a silhouette unique among airliners. It kept the two 66.7 kN Soloviev D-30 engines, the swept wing and the low-pressure tyres of the airliner. It belonged to a whole family of Tu-134-based trainers: the Tu-134BSh carried the Tu-22M radar, the Tu-134Sh-1 bomb racks, and the Tu-134Sh-2 trained navigators for tactical bombers.\n\n## Operational career\nThe Tu-134UBLs trained Tu-160 crews alongside the family''s other trainers. A naval version, the **Tu-134UBK**, was built as a single example. While the civil Tu-134 gradually left the airlines, after the withdrawal order issued by President Medvedev in 2011 and the last Russian passenger flight in 2019, the Russian Air Force kept operating Tu-134s. Several UBLs are now preserved, including RF-12037, nicknamed the "**Black Pearl**", at the Tambov Long Range Aviation Museum, and "Blue 43" at the Ukraine State Aviation Museum in Kyiv.\n\n## Place in history\nThe Tu-134UBL illustrates an economical and lasting solution: an airliner turned into a flying simulator for the most valuable crews of a strategic air arm. The same airframe thus served to carry passengers, to train cosmonauts and to train the crews of the great Soviet supersonic bomber.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    NULL,
    NULL,
    950,
    3000,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-134UBL'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-134UBL'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-134UBL'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = 29.01,
  height            = 9.02,
  wing_area         = 127.3,
  empty_weight      = 27960,
  mtow              = 47600,
  service_ceiling   = 12100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Soloviev D-30',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 66.68,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Tu-134UBL** : entraînement des équipages du Tu-160, cône de nez du bombardier\n- **Tu-134UBK** : version navale du Tu-134UBL, un seul exemplaire\n- **Tu-134BSh** : entraînement des équipages du Tu-22M, avec le radar du bombardier dans le nez\n- **Tu-134Sh-1** : école des équipages de bombardiers lourds, avec lance-bombes\n- **Tu-134Sh-2** : école de navigation des équipages de bombardiers tactiques',
  variants_en       = E'- **Tu-134UBL**: training aircraft for Tu-160 crews, with the bomber''s nose cone\n- **Tu-134UBK**: naval version of the Tu-134UBL, a single example\n- **Tu-134BSh**: Tu-22M crew trainer, with the bomber''s radar in the nose\n- **Tu-134Sh-1**: heavy bomber crew trainer with bomb racks\n- **Tu-134Sh-2**: navigation trainer for tactical bomber crews',

  -- Strate 4 : qualitatif
  nickname          = 'Crusty',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tupolev_Tu-134',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tupolev_Tu-134',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Vlad2003',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Tupolev Tu-134UBL';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tupolev Tu-134UBL';
