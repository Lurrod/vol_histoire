-- Valmet L-90 TP Redigo
--
-- Photo : Redigo 01.jpg
--   licence CC BY 3.0 — Towpilot
--   https://commons.wikimedia.org/wiki/File:Redigo_01.jpg

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
    'Valmet L-90 Redigo',
    'Valmet L-90 Redigo',
    'Valmet L-90 TP Redigo',
    'Valmet L-90 TP Redigo',
    'Biplace d''entraînement à turbopropulseur, dernier avion militaire conçu et produit en Finlande',
    'Turboprop two-seat trainer, the last military aircraft designed and built in Finland',
    '/assets/airplanes/valmet-redigo.jpg',
    E'## Genèse\nDepuis le **Valmet L-70 Vinka**, l''industriel finlandais **Valmet** développe une petite famille d''avions-écoles pour l''armée de l''air de son pays. Après le L-80 Turbo-Vinha, il pousse la formule jusqu''à une version à turbopropulseur destinée à l''entraînement de base, mais aussi à la liaison. Le prototype, un L-80 modifié, vole le 12 février 1985. Un second prototype, propulsé par un **Turbomeca TP319**, est détruit dans un accident en août 1988, lors d''une présentation en vol en Belgique ; un troisième prend sa place pour achever la mise au point. L''avion est baptisé **Redigo**, parfois écrit RediGO.\n\n## Conception\nLe L-90 est un monoplan classique à aile basse et train tricycle escamotable, mû par une turbine **Allison 250-B17F** de 450 ch. Élève et instructeur sont assis **côte à côte**, et la cabine peut accueillir deux passagers supplémentaires ou un brancard. Comme beaucoup d''avions d''entraînement militaires, il peut emporter un armement léger pour l''instruction au tir ou, au besoin, pour l''appui rapproché : six points d''emport sous voilure acceptent jusqu''à 800 kg de charges. Sa vitesse maximale atteint 354 km/h et son autonomie 1 000 km.\n\n## Carrière opérationnelle\nLa production totalise 29 avions de série et deux prototypes. L''armée de l''air finlandaise en reçoit dix, livrés en 1991-1992, qu''elle emploie comme avions de liaison. La marine mexicaine en achète sept, affectés à des escadrons de reconnaissance tactique, et l''Érythrée six en 1994 pour une escadrille d''entraînement à Asmara. Aermacchi rachète les droits de production en 1996 et rebaptise l''avion **M-290 TP**, sans jamais en relancer la fabrication. Tous les appareils militaires sont aujourd''hui retirés ; aux États-Unis, une société privée d''entraînement en exploite six sous le nom de **Valmet A-90 Raider**.\n\n## Place dans l''histoire\nLe Redigo ferme un chapitre : c''est le dernier avion militaire conçu et produit en Finlande. Il prolonge la lignée ouverte par le Vinka, premier avion militaire finlandais depuis la guerre, et la fait passer du moteur à pistons à la turbine. Ses ventes limitées, 29 avions de série et aucune commande après le rachat par Aermacchi, disent la difficulté pour une petite industrie nationale d''exister face à des concurrents comme le **SF.260**.',
    E'## Genesis\nSince the **Valmet L-70 Vinka**, the Finnish manufacturer **Valmet** had developed a small family of trainers for its country''s air force. After the L-80 Turbo-Vinha, it took the formula to a turboprop version intended for basic training but also for liaison. The prototype, a modified L-80, flew on 12 February 1985. A second prototype, powered by a **Turbomeca TP319**, was destroyed in an accident in August 1988, during a flying display in Belgium; a third took its place to complete development. The aircraft was named **Redigo**, sometimes written RediGO.\n\n## Design\nThe L-90 was a conventional low-wing monoplane with retractable tricycle undercarriage, powered by a 450 shp **Allison 250-B17F** turbine. Student and instructor sat **side by side**, and the cabin could take two extra passengers or a stretcher. Like many military trainers, it could carry light armament for weapons training or, if needed, close support: six underwing hardpoints took up to 800 kg of stores. Its top speed reached 354 km/h and its range 1,000 km.\n\n## Operational career\nProduction totalled 29 series aircraft and two prototypes. The Finnish Air Force received ten, delivered in 1991-1992, which it used as liaison aircraft. The Mexican Navy bought seven, assigned to tactical reconnaissance squadrons, and Eritrea six in 1994 for a training flight at Asmara. Aermacchi bought the production rights in 1996 and renamed the aircraft the **M-290 TP**, but never resumed manufacture. All military examples are now retired; in the United States a private training company operates six as the **Valmet A-90 Raider**.\n\n## Place in history\nThe Redigo closed a chapter: it was the last military aircraft designed and built in Finland. It extended the line opened by the Vinka, the first Finnish military aircraft since the war, taking it from piston engine to turbine. Its limited sales, 29 production aircraft and no orders after the Aermacchi takeover, show how hard it is for a small national industry to compete with rivals such as the **SF.260**.',
    (SELECT id FROM countries WHERE code = 'FIN'),
    NULL,
    '1985-02-12',
    '1991-01-01',
    354,
    1000,
    (SELECT id FROM manufacturer WHERE code = 'VAL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Valmet L-90 Redigo'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Valmet L-90 Redigo'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Valmet L-90 Redigo'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.53,
  wingspan          = 10.6,
  height            = 3.2,
  wing_area         = 14.8,
  empty_weight      = 970,
  mtow              = 1900,
  service_ceiling   = 6340,
  climb_rate        = 9.3,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.5,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Allison 250-B17F (450 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1985,
  production_end    = 1995,
  units_built       = 31,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Prototypes L-90 TP** : un L-80 modifié (premier vol en 1985), un second à turbine Turbomeca TP319 détruit en 1988, puis un troisième\n- **L-90 TP Redigo** : version de série à turbine Allison 250-B17F, 29 exemplaires pour la Finlande, le Mexique et l''Érythrée\n- **M-290 TP Redigo** : désignation après le rachat des droits par Aermacchi en 1996, jamais produit\n- **A-90 Raider** : appareils exploités aux États-Unis par une société privée d''entraînement',
  variants_en       = E'- **L-90 TP prototypes**: a modified L-80 (first flight 1985), a second with a Turbomeca TP319 turbine destroyed in 1988, then a third\n- **L-90 TP Redigo**: production version with Allison 250-B17F turbine, 29 built for Finland, Mexico and Eritrea\n- **M-290 TP Redigo**: designation after Aermacchi bought the rights in 1996, never produced\n- **A-90 Raider**: aircraft operated in the United States by a private training company',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Valmet_L-90_TP_Redigo',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Valmet_L-90_Redigo',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Towpilot',
  image_licence     = 'CC BY 3.0'
WHERE name = 'Valmet L-90 Redigo';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Valmet L-90 Redigo';
