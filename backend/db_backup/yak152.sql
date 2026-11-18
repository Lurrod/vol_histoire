-- Yakovlev Yak-152
--
-- Photo : YaK-152.jpg
--   licence CC BY-SA 4.0 — Alexander Kopitar
--   https://commons.wikimedia.org/wiki/File:YaK-152.jpg

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
    'Yak-152',
    'Yak-152',
    'Yakovlev Yak-152',
    'Yakovlev Yak-152',
    'L''école élémentaire russe à moteur diesel qui doit succéder au Yak-52, rattrapée par les sanctions',
    'The diesel-engined Russian primary trainer meant to succeed the Yak-52, caught up by sanctions',
    '/assets/airplanes/yak-152.jpg',
    E'## Genèse\nL''étude du **Yak-152** commence dans les années 1990 au bureau **Yakovlev**, en même temps que celle de l''avion-école à réaction **Yak-130**. Les deux appareils doivent avoir des postes de pilotage semblables, pour que l''élève passe sans rupture du premier au second ; le nouveau biplace s''inspire de l''avion de voltige **Yak-54**. En 2001, il est désigné comme le futur avion d''entraînement élémentaire principal de l''armée de l''air, mais le programme progresse peu au début des années 2000, faute de financement. En 2006, des investisseurs chinois relancent le développement, qui donne naissance chez eux au **Hongdu Yakovlev CJ-7** à moteur en étoile.\n\n## Conception\nPour la version russe, Yakovlev, rattaché à **Irkut**, choisit le **RED A03**, un moteur diesel en V de 500 ch conçu par l''ingénieur **Vladimir Raikhlin**, ancien motoriste automobile de VAZ installé en Allemagne. Ce moteur, financé par le groupe russe FINAM, est fabriqué à Adenau. Le biplace pèse 1 700 kg au maximum, tient jusqu''à +8 et −6 g, monte à 10 m/s et franchit 1 500 km ; le constructeur annonce une vitesse maximale de 500 km/h. Le moteur entraîne une hélice tripale MT.\n\n## Essais\nLe prototype vole pour la première fois le 29 septembre 2016. La même année, le ministère russe de la Défense annonce son intention d''acheter au moins 150 appareils une fois la production en série lancée, pour remplacer les **Yak-52** vieillissants des forces aérospatiales. Mais les sanctions internationales qui frappent la Russie rendent impossible l''importation du moteur allemand : Yakovlev doit se tourner vers des solutions russes, le moteur à pistons VMZ M-9F ou la turbine Klimov VK-800, au prix d''adaptations importantes. Les essais en vol pour les militaires s''achèvent en janvier 2024, et l''avion est construit à Irkoutsk.\n\n## Place dans l''histoire\nLe Yak-152 doit clore une lignée d''écoles élémentaires Yakovlev qui va du **Yak-18** au Yak-52, en l''adossant au Yak-130 pour former un parcours de formation cohérent. Son histoire illustre aussi la dépendance de l''industrie aéronautique russe envers des composants étrangers : un avion conçu autour d''un moteur allemand a dû en changer après coup. Au-delà de l''armée, la DOSAAF russe prévoyait d''en commander 105 pour former des pilotes civils, et son homologue biélorusse s''y est intéressée.',
    E'## Genesis\nWork on the **Yak-152** began in the 1990s at the **Yakovlev** bureau, alongside the **Yak-130** jet trainer. The two aircraft were to have similar cockpits, so that students could move seamlessly from the first to the second; the new two-seater drew on the **Yak-54** aerobatic aircraft. In 2001 it was named as the air force''s future main primary trainer, but the programme made little progress in the early 2000s for lack of funding. In 2006 Chinese investors revived development, which produced in China the radial-engined **Hongdu Yakovlev CJ-7**.\n\n## Design\nFor the Russian version, Yakovlev, part of **Irkut**, chose the **RED A03**, a 500 hp V-type diesel engine designed by **Vladimir Raikhlin**, a former VAZ automotive engineer who had moved to Germany. The engine, financed by the Russian FINAM group, was built at Adenau. The two-seater weighs up to 1,700 kg, is stressed to +8 and −6 g, climbs at 10 m/s and covers 1,500 km; the manufacturer quotes a maximum speed of 500 km/h. The engine drives a three-blade MT propeller.\n\n## Testing\nThe prototype first flew on 29 September 2016. The same year the Russian Ministry of Defence announced its intention to buy at least 150 aircraft once series production began, to replace the ageing **Yak-52s** of the Aerospace Forces. But the international sanctions against Russia made importing the German engine impossible: Yakovlev had to turn to Russian alternatives, the VMZ M-9F piston engine or the Klimov VK-800 turboshaft, at the cost of major adaptations. Flight tests for the military were completed in January 2024, and the aircraft is built at Irkutsk.\n\n## Place in history\nThe Yak-152 is meant to close a line of Yakovlev primary trainers running from the **Yak-18** to the Yak-52, while linking it to the Yak-130 to form a coherent training path. Its story also illustrates the Russian aviation industry''s dependence on foreign components: an aircraft designed around a German engine had to change it after the fact. Beyond the military, Russia''s DOSAAF planned to order 105 to train civil pilots, and its Belarusian counterpart showed interest.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '2016-09-29',
    NULL,
    500,
    1500,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En développement',
    'In development'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-152'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.72,
  wingspan          = 8.82,
  height            = 3.11,
  wing_area         = 12.9,
  empty_weight      = NULL,
  mtow              = 1700,
  service_ceiling   = 4000,
  climb_rate        = 10.0,
  g_limit_pos       = 8.0,
  g_limit_neg       = -6.0,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'RED A03 V12 diesel (500 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Yak-152** : prototype à moteur diesel RED A03, premier vol le 29 septembre 2016\n- **Yak-152 à motorisation russe** : versions étudiées avec le moteur à pistons VMZ M-9F ou la turbine Klimov VK-800 après les sanctions\n- **Hongdu Yakovlev CJ-7** : dérivé chinois financé en 2006, à moteur en étoile Vedeneyev M14X',
  variants_en       = E'- **Yak-152**: prototype with the RED A03 diesel engine, first flown on 29 September 2016\n- **Russian-engined Yak-152**: versions studied with the VMZ M-9F piston engine or the Klimov VK-800 turbine after sanctions\n- **Hongdu Yakovlev CJ-7**: Chinese derivative funded in 2006, with a Vedeneyev M14X radial engine',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-152',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-152',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alexander Kopitar',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Yak-152';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-152';
