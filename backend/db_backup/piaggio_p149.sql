-- Piaggio P.149
--
-- Photo : Malle Piaggio P-149D 03.JPG
--   licence CC BY-SA 3.0 — Ad Meskens
--   https://commons.wikimedia.org/wiki/File:Malle_Piaggio_P-149D_03.JPG

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
    'Piaggio P.149',
    'Piaggio P.149',
    'Piaggio P.149',
    'Piaggio P.149',
    'Le quadriplace italien qui fut, pendant plus de trente ans, l''avion de début et de liaison de la Luftwaffe',
    'The Italian four-seater that served the Luftwaffe as a primary trainer and liaison aircraft for over thirty years',
    '/assets/airplanes/piaggio-p149.jpg',
    E'## Genèse\nAu début des années 1950, **Piaggio** fournit à l''aviation militaire italienne le **P.148**, un biplace d''entraînement à train classique. La firme veut en tirer une version agrandie et plus polyvalente, capable de conquérir des marchés étrangers face aux avions américains, britanniques et français. Les ingénieurs abandonnent le train classique pour un train tricycle et proposent l''appareil en quadriplace, ce qui l''ouvre aussi à la liaison. Le prototype du **P.149** vole le 19 juin 1953.\n\n## Conception\nLe P.149 est un monoplan à aile basse cantilever entièrement métallique, doté d''un train tricycle escamotable. Sa cabine accueille quatre ou cinq occupants : l''élève et l''instructeur côte à côte, avec double commande, et des passagers derrière eux. Un moteur à six cylindres à plat **Lycoming GO-480** de 270 ch entraîne l''hélice. La version allemande, le P.149D, croise à 266 km/h et franchit près de 1 100 km avec une demi-heure de réserve, tout en décollant en un peu plus de 400 m.\n\n## Carrière opérationnelle\nLes premières ventes sont rares, jusqu''à ce que la **Luftwaffe** ouest-allemande retienne l''appareil pour l''entraînement et les missions de servitude. Piaggio lui livre 76 des 88 exemplaires construits en Italie, et **Focke-Wulf** en produit 190 autres sous licence, sous le nom de FWP.149D. L''armée de l''air et l''aéronavale allemandes l''utilisent de 1957 à 1990. Il sert aussi en Israël, au Nigeria, qui en aligne douze en 1967, en Tanzanie et en Ouganda, tandis que l''école de pilotage de Swissair, à Berne-Belp, y forme des élèves pilotes.\n\n## Place dans l''histoire\nAvec 278 exemplaires, dont plus des deux tiers construits en Allemagne, le P.149 a surtout été l''avion de début de la Luftwaffe pendant plus de trente ans. Sa longévité s''est vérifiée à la fin des années 1970 : la Luftwaffe fait évaluer le **RFB Fantrainer** pour le remplacer, puis juge que le P.149 suffit encore à ses besoins. Plusieurs exemplaires volent aujourd''hui entre des mains privées, sous immatriculation allemande, américaine, canadienne ou française.',
    E'## Genesis\nIn the early 1950s **Piaggio** was supplying the Italian air force with the **P.148**, a two-seat trainer with a tailwheel undercarriage. The company wanted to derive a larger, more versatile version able to win export markets against American, British and French aircraft. The engineers replaced the tailwheel layout with a tricycle undercarriage and offered the aircraft as a four-seater, which also suited it to liaison work. The **P.149** prototype flew on 19 June 1953.\n\n## Design\nThe P.149 was an all-metal, cantilever low-wing monoplane with a retractable tricycle undercarriage. Its cabin held four or five occupants: pupil and instructor side by side with dual controls, and passengers behind them. A 270 hp **Lycoming GO-480** six-cylinder flat engine drove the propeller. The German P.149D version cruised at 266 km/h and covered nearly 1,100 km with half an hour in reserve, while taking off in little more than 400 m.\n\n## Operational career\nEarly sales were few, until the West German **Luftwaffe** selected the aircraft for training and utility duties. Piaggio delivered 76 of the 88 built in Italy, and **Focke-Wulf** produced another 190 under licence as the FWP.149D. The German air force and naval aviation flew it from 1957 to 1990. It also served in Israel, in Nigeria, which fielded twelve in 1967, in Tanzania and in Uganda, while the Swissair flying school at Bern-Belp used it to train student pilots.\n\n## Place in history\nWith 278 built, more than two thirds of them in Germany, the P.149 was above all the Luftwaffe''s primary trainer for over thirty years. Its longevity showed at the end of the 1970s: the Luftwaffe had the **RFB Fantrainer** evaluated to replace it, then decided that the P.149 still met its needs. Several examples fly today in private hands, on German, American, Canadian and French registers.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    NULL,
    '1953-06-19',
    '1957-01-01',
    304,
    1090,
    (SELECT id FROM manufacturer WHERE code = 'PIA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Piaggio P.149'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Piaggio P.149'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Piaggio P.149'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.8,
  wingspan          = 11.12,
  height            = 2.9,
  wing_area         = 18.81,
  empty_weight      = 1160,
  mtow              = 1680,
  service_ceiling   = 6050,
  climb_rate        = 5.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming GO-480-B1A6 (270 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 278,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **P.148** : biplace d''entraînement à train classique dont dérive le P.149\n- **P.149** : prototype quadriplace à train tricycle, premier vol le 19 juin 1953\n- **P.149D** : version construite en Italie pour l''Allemagne (« D » pour Deutschland) ; 76 des 88 exemplaires italiens livrés à la Luftwaffe\n- **FWP.149D** : version construite sous licence par Focke-Wulf pour les forces allemandes, 190 exemplaires\n- **P.149E** : version utilisée par l''école de pilotage de Swissair à Berne-Belp',
  variants_en       = E'- **P.148**: two-seat tailwheel trainer from which the P.149 was derived\n- **P.149**: four-seat prototype with tricycle undercarriage, first flown on 19 June 1953\n- **P.149D**: version built in Italy for Germany (''D'' for Deutschland); 76 of the 88 Italian-built aircraft went to the Luftwaffe\n- **FWP.149D**: licence-built by Focke-Wulf for the German forces, 190 built\n- **P.149E**: version used by the Swissair flying school at Bern-Belp',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Piaggio_P.149',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Piaggio_P.149',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ad Meskens',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Piaggio P.149';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Piaggio P.149';
