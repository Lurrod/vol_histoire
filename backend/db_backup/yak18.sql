-- Yakovlev Yak-18
--
-- Photo : Jak-18 , latający eksponat Muzeum Lotnictwa Polskiego w Krakowie.jpg
--   licence CC BY 3.0 — Zalasem1
--   https://commons.wikimedia.org/wiki/File:Jak-18_,_lataj%C4%85cy_eksponat_Muzeum_Lotnictwa_Polskiego_w_Krakowie.jpg

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
    'Yak-18',
    'Yak-18',
    'Yakovlev Yak-18',
    'Yakovlev Yak-18',
    'L''école standard des aéroclubs et des forces aériennes du bloc soviétique, et bombardier de nuit en Corée',
    'The standard trainer of Soviet bloc flying clubs and air forces, and a night bomber over Korea',
    '/assets/airplanes/yak18.jpg',
    E'## Genèse\nConnu pour ses chasseurs, **Alexandre Iakovlev** a toujours gardé un bureau consacré aux avions légers. En mai 1945, il lance l''étude d''un biplace d''école en tandem pour remplacer les **UT-2** et Yak-5 des forces aériennes soviétiques et du **DOSAAF**, la société paramilitaire qui parraine les aéroclubs dans toute l''URSS. Une version améliorée de l''UT-2, construite en 1944, en préfigurait déjà bien des traits. Le Yak-18 vole en 1946 et entre en service dans l''année.\n\n## Conception\nLe premier Yak-18 est un monoplan à aile basse propulsé par un petit moteur en étoile **Chvetsov M-11** à cinq cylindres de 160 ch, avec un train principal escamotable à commande pneumatique et une roulette de queue fixe. Simple à construire et à entretenir, il se prête à toutes les évolutions. Lorsque le besoin d''écoles à train classique disparaît, Iakovlev le redessine avec un train tricycle escamotable et un moteur en étoile **Ivtchenko AI-14** de 300 ch : c''est le **Yak-18A**, produit en grand nombre. Des versions monoplaces de voltige, les Yak-18P et Yak-18PM, en dérivent pour les aéroclubs.\n\n## Carrière opérationnelle\nLe Yak-18 devient l''avion d''école standard des écoles de l''armée de l''air soviétique et du DOSAAF ; près de trente pays l''adoptent, et la Chine le construit sous licence sous le nom de CJ-5. Son heure de gloire vient pendant la **guerre de Corée** : munis de lance-bombes, les Yak-18 nord-coréens survolent de nuit les positions de l''ONU pour les harceler. En juin 1953, quatre ou cinq d''entre eux détruisent près d''Inchon un dépôt de plus de 20 millions de litres de carburant, le plus grand succès de l''aviation nord-coréenne. Le bruit de leur moteur leur vaut le surnom de « Washing Machine Charlie ».\n\n## Place dans l''histoire\nRecordman de vitesse de sa catégorie en 1951, le Yak-18 a donné leur premier vol à des milliers de pilotes du bloc de l''Est, dont **Youri Gagarine**, et à No Kum-sok, le pilote nord-coréen qui fera défection avec son MiG-15. Construit par Iakovlev jusqu''en 1956, il a ouvert une lignée d''avions d''école et de voltige qui mène au **Yak-52**. Une quarantaine d''exemplaires d''origine existent encore, dont plusieurs en état de vol.',
    E'## Genesis\nBest known for his fighters, **Alexander Yakovlev** always kept a design office for light aircraft. In May 1945 he began work on a tandem two-seat trainer to replace the **UT-2** and Yak-5 of the Soviet Air Forces and of **DOSAAF**, the paramilitary society that sponsored flying clubs throughout the USSR. An advanced version of the UT-2, built in 1944, already foreshadowed many of its features. The Yak-18 flew in 1946 and entered service that same year.\n\n## Design\nThe first Yak-18 was a low-wing monoplane powered by a small 160 hp five-cylinder **Shvetsov M-11** radial, with a pneumatically retracted main undercarriage and a fixed tailwheel. Easy to build and maintain, it lent itself to development. When the need for tailwheel trainers faded, Yakovlev redesigned it with a retractable tricycle undercarriage and a 300 hp **Ivchenko AI-14** radial: this was the **Yak-18A**, built in large numbers. Single-seat aerobatic versions, the Yak-18P and Yak-18PM, were derived from it for the flying clubs.\n\n## Operational career\nThe Yak-18 became the standard trainer of Soviet Air Force schools and DOSAAF; nearly thirty countries adopted it, and China built it under licence as the CJ-5. Its moment of fame came during the **Korean War**: fitted with bomb racks, North Korean Yak-18s flew over UN positions at night to harass them. In June 1953 four or five of them destroyed a fuel dump of more than 20 million litres near Inchon, the greatest success of North Korean aviation. The sound of their engine earned them the nickname Washing Machine Charlie.\n\n## Place in history\nHolder of a class speed record in 1951, the Yak-18 gave thousands of Eastern bloc pilots their first flight, including **Yuri Gagarin**, and No Kum-sok, the North Korean pilot who would defect with his MiG-15. Built by Yakovlev until 1956, it opened a line of training and aerobatic aircraft leading to the **Yak-52**. Around forty original examples still exist, several of them airworthy.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1945-05-01',
    '1946-01-01',
    '1946-01-01',
    300,
    700,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-18'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-18'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Yak-18'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-18'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'Yak-18'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.35,
  wingspan          = 10.6,
  height            = 3.35,
  wing_area         = 17.8,
  empty_weight      = 1025,
  mtow              = 1320,
  service_ceiling   = 5060,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Ivtchenko AI-14RF (300 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1946,
  production_end    = 1956,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 29,
  variants          = E'- **Yak-18** : version initiale, moteur M-11 de 160 ch, train principal escamotable et roulette de queue fixe\n- **Yak-18U** : premier essai de train tricycle escamotable, construit en petit nombre\n- **Yak-18A** : train tricycle et moteur Ivtchenko AI-14, la version la plus produite\n- **Yak-18P, PM et PS** : monoplaces de voltige pour les aéroclubs\n- **Nanchang CJ-5** : version construite sous licence en Chine, 379 exemplaires jusqu''en 1958',
  variants_en       = E'- **Yak-18**: initial version, 160 hp M-11 engine, retractable main gear and fixed tailwheel\n- **Yak-18U**: first retractable tricycle undercarriage attempt, built in small numbers\n- **Yak-18A**: tricycle undercarriage and Ivchenko AI-14 engine, the most produced version\n- **Yak-18P, PM and PS**: single-seat aerobatic aircraft for flying clubs\n- **Nanchang CJ-5**: licence-built version in China, 379 built until 1958',

  -- Strate 4 : qualitatif
  nickname          = 'Max',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-18',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-18',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Zalasem1',
  image_licence     = 'CC BY 3.0'
WHERE name = 'Yak-18';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-18';
