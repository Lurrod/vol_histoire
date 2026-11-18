-- IAI Scout
--
-- Photo : IAIScout.jpg
--   licence CC BY-SA 3.0 — aick
--   https://commons.wikimedia.org/wiki/File:IAIScout.jpg

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
    'IAI Scout',
    'IAI Scout',
    'IAI Scout',
    'IAI Scout',
    'Drone de champ de bataille israélien qui a aidé à démanteler les défenses sol-air syriennes de la Bekaa',
    'Israeli battlefield drone that helped dismantle the Syrian air defences in the Bekaa',
    '/assets/airplanes/iai-scout.jpg',
    E'## Genèse\nDans les années 1970, l''armée israélienne s''intéresse de plus en plus aux drones de champ de bataille, et la direction d''**Israel Aircraft Industries** finit par s''y intéresser à son tour. Un premier appareil télécommandé portant une caméra vole en 1974 sans convaincre ; c''est le premier vol du **Tadiran Mastiff** qui décide IAI à lancer en 1977 le développement du Scout, son concurrent direct, présenté au salon du Bourget en 1979. Le projet est dirigé par **Charley Attali**, **David Harari** et **Michael Shefer**, tous trois lauréats du prix de la Défense d''Israël en 1981. En Israël, l''appareil porte un nom hébreu qui signifie « loriot ».\n\n## Conception\nLe Scout reprend la formule du Mastiff : une hélice propulsive à l''arrière du fuselage et un empennage bipoutre. Construit en matériaux composites, il mesure 3,68 m pour près de 5 m d''envergure, pèse 159 kg et emporte 38 kg de charge utile, dont des capteurs d''imagerie logés dans une tourelle sous le fuselage. Un petit moteur à pistons de 22 ch lui donne 176 km/h et sept heures et demie d''autonomie. Doté d''un train fixe, il opère généralement depuis une piste et se pose court en accrochant un câble d''arrêt, mais il peut aussi être catapulté depuis l''arrière d''un camion et récupéré dans un filet.\n\n## Carrière opérationnelle\nSon baptême du feu n''a pas lieu en Israël : en 1981, la South African Defence Force l''engage contre l''Angola pendant l''**opération Protea**. L''année suivante, pendant la **guerre du Liban de 1982**, les Israéliens affrontent les missiles sol-air syriens massés dans la plaine de la **Bekaa**. Les 28 sites sont détruits, en partie grâce aux leurres **Samson** qui les forcent à se dévoiler, en partie grâce au renseignement recueilli par les Mastiff et les Scout. Le Scout reste en service dans l''armée israélienne et dans l''armée de l''air de Singapour jusqu''au début des années 1990, quand l''**IAI Searcher** le remplace.\n\n## Place dans l''histoire\nLe succès des drones israéliens au Liban attire l''attention de l''armée américaine, surtout après son intervention au Liban en 1983. En 1984, l''US Navy demande un drone de champ de bataille, et Tadiran et IAI réunissent leurs efforts dans une division d''IAI baptisée **Mazlat**, aujourd''hui Malat. Associée à l''américain **AAI**, elle en tire le **Pioneer**, qui remporte la compétition. Après avoir regroupé la production du Mastiff et du Scout, Malat vend encore ce dernier, sous des formes à peine retouchées, pendant plus d''une décennie.',
    E'## Genesis\nDuring the 1970s the Israeli military became increasingly interested in battlefield drones, and the management of **Israel Aircraft Industries** finally decided it was interested too. A first camera-carrying remotely piloted aircraft flew in 1974 without convincing anyone; it was the first flight of the **Tadiran Mastiff** that led IAI to launch the Scout, its direct competitor, in 1977, and to show it at the Paris Air Show in 1979. The project was led by **Charley Attali**, **David Harari** and **Michael Shefer**, who all received the 1981 Israel Defense Prize. In Israel the aircraft carries a Hebrew name meaning ''oriole''.\n\n## Design\nThe Scout followed the Mastiff''s layout: a pusher propeller at the rear of the fuselage and a twin-boom tail. Built of composite materials, it is 3.68 m long with a span of almost 5 m, weighs 159 kg and carries a 38 kg payload, including imaging sensors in a turret under the fuselage. A small 22 hp piston engine gives it 176 km/h and seven and a half hours'' endurance. With fixed landing gear, it usually operates from runways and makes short landings by catching an arresting wire, but it can also be launched by a hydraulic catapult from the back of a truck and recovered in a net.\n\n## Operational career\nIts combat debut did not take place in Israel: in 1981 the South African Defence Force used it against Angola during **Operation Protea**. The following year, in the **1982 Lebanon War**, the Israelis faced the Syrian surface-to-air missiles massed in the **Bekaa** Valley. All 28 sites were destroyed, partly thanks to **Samson** decoys that made them reveal their presence and partly thanks to intelligence gathered by the Mastiff and Scout drones. The Scout remained in service with the Israeli Army and the Republic of Singapore Air Force until the early 1990s, when the **IAI Searcher** replaced it.\n\n## Place in history\nThe success of the Israeli drones over Lebanon caught the attention of the American military, particularly after its own intervention in Lebanon in 1983. In 1984 the US Navy asked for a battlefield drone, and Tadiran and IAI joined forces in an IAI division called **Mazlat**, now Malat. Teamed with the American firm **AAI**, it developed the **Pioneer**, which won the competition. Having consolidated production of the Mastiff and Scout, Malat went on selling the Scout in slightly refined versions for more than a decade.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1977-01-01',
    NULL,
    NULL,
    176,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Scout'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'IAI Scout'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Scout'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Scout'), (SELECT id FROM wars WHERE name = 'Guerre de la frontière sud-africaine')),
((SELECT id FROM airplanes WHERE name = 'IAI Scout'), (SELECT id FROM wars WHERE name = 'Guerre du Liban'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 3.68,
  wingspan          = 4.96,
  height            = 0.94,
  wing_area         = NULL,
  empty_weight      = 96,
  mtow              = 159,
  service_ceiling   = 4600,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Moteur à pistons (22 ch)',
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
  operators_count   = 3,
  variants          = E'- **Scout** : drone de reconnaissance de l''armée et de l''armée de l''air israéliennes, développé à partir de 1977\n- **Scout sud-africain** : engagé en 1981 par la South African Defence Force pendant l''opération Protea\n- **Scout singapourien** : en service dans l''armée de l''air de Singapour jusqu''au début des années 1990\n- **Pioneer** : dérivé conçu par Mazlat et AAI pour l''US Navy à partir de 1984',
  variants_en       = E'- **Scout**: reconnaissance drone of the Israeli Army and Air Force, developed from 1977\n- **South African Scout**: used in 1981 by the South African Defence Force during Operation Protea\n- **Singaporean Scout**: in service with the Republic of Singapore Air Force until the early 1990s\n- **Pioneer**: derivative developed by Mazlat and AAI for the US Navy from 1984',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/IAI_Scout',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAI_Scout',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'aick',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'IAI Scout';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAI Scout';
