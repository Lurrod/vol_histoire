-- Fokker S.11 Instructor
--
-- Photo : Fokker S-11 (27964585812).jpg
--   licence CC BY-SA 2.0 — Rob Schleiffert from Holland
--   https://commons.wikimedia.org/wiki/File:Fokker_S-11_(27964585812).jpg

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
    'Fokker S.11 Instructor',
    'Fokker S.11 Instructor',
    'Fokker S.11 Instructor',
    'Fokker S.11 Instructor',
    'Le premier avion militaire de Fokker après la guerre, école élémentaire des Pays-Bas, d''Israël, d''Italie et du Brésil',
    'Fokker''s first post-war military aircraft, elementary trainer for the Netherlands, Israel, Italy and Brazil',
    '/assets/airplanes/fokker-s11.jpg',
    E'## Genèse\nAu lendemain de la Seconde Guerre mondiale, l''une des premières tâches que se donne **Fokker** est d''étudier un avion militaire neuf pour l''instruction élémentaire des pilotes : le **S.11 Instructor**. Le pari trouve preneur avant même le premier coup de rivet, puisqu''un négociant en avions en commande cent exemplaires dès 1946. Le premier prototype décolle de Schiphol le 18 décembre 1947. Les essais du début de 1948 imposent quelques retouches aérodynamiques pour améliorer son comportement.\n\n## Conception\nLe S.11 est un monoplan biplace à moteur à pistons, propulsé par un Lycoming O-435A à six cylindres à plat de 190 ch. Sa masse en charge ne dépasse pas 1 100 kg, et l''avion atteint 209 km/h, croise à 164 km/h et franchit 630 km. Il lui faut un peu plus de cinq minutes pour monter à 1 000 m, et son plafond pratique s''établit à 3 850 m. Ces performances modestes suffisent à sa mission : donner aux élèves leurs premières heures de vol sur un appareil sûr et simple. Une version à train tricycle, le **S.12**, en est ensuite dérivée.\n\n## Carrière opérationnelle\nDès 1948, des vols de démonstration sont présentés à plusieurs forces aériennes. La force aérienne et l''aéronavale néerlandaises reçoivent 48 appareils, et l''armée de l''air israélienne en exploite 41 de 1951 à 1957. En Italie, l''appareil est produit sous licence par **Aermacchi** et **IMAM** sous le nom de **Macchi M.416**, à plus de 170 exemplaires, et sert à partir de 1951. Au Brésil, une filiale locale de Fokker construit 95 S.11 et 49 S.12, désignés T-21 et T-22, qui servent dans les années 1960 et au début des années 1970 avant de passer en partie à la Bolivie et au Paraguay.\n\n## Place dans l''histoire\nLe S.11 marque le retour de Fokker dans l''aviation militaire et lui ouvre des marchés sur trois continents. Le prototype du S.12 connaît une seconde vie de laboratoire volant : l''université de Delft l''utilise dans les années 1950 et 1960 pour des recherches sur l''aspiration de la couche limite. Au Brésil, c''est l''**Aerotec T-23 Uirapuru** qui remplace les S.11 et S.12 de l''Académie de l''air. Plusieurs Instructor volent encore, notamment les quatre appareils de la fondation néerlandaise **Fokker Four**, qui les présente en meeting.',
    E'## Genesis\nIn the immediate aftermath of the Second World War, one of the first tasks **Fokker** set itself was to design a new military aircraft for elementary pilot training: the **S.11 Instructor**. The gamble found a buyer before a single rivet was driven, as an aircraft trader ordered one hundred examples as early as 1946. The first prototype took off from Schiphol on 18 December 1947. Tests in early 1948 called for some aerodynamic changes to improve its handling.\n\n## Design\nThe S.11 is a two-seat piston-engined monoplane powered by a 190 hp Lycoming O-435A flat-six. Its loaded weight was no more than 1,100 kg, and the aircraft reached 209 km/h, cruised at 164 km/h and covered 630 km. It took a little over five minutes to climb to 1,000 m, and its service ceiling stood at 3,850 m. These modest figures were enough for its task: giving students their first flying hours on a safe and simple aircraft. A tricycle-undercarriage version, the **S.12**, was later derived from it.\n\n## Operational career\nFrom 1948 demonstration flights were made for several air forces. The Dutch air force and naval air service received 48 aircraft, and the Israeli Air Force operated 41 from 1951 to 1957. In Italy the aircraft was built under licence by **Aermacchi** and **IMAM** as the **Macchi M.416**, in more than 170 examples, and served from 1951. In Brazil a local Fokker subsidiary built 95 S.11s and 49 S.12s, designated T-21 and T-22, which served through the 1960s and early 1970s before some passed to Bolivia and Paraguay.\n\n## Place in history\nThe S.11 marked Fokker''s return to military aviation and opened markets on three continents for it. The S.12 prototype had a second life as a flying laboratory: Delft University used it in the 1950s and 1960s for boundary-layer suction research. In Brazil it was the **Aerotec T-23 Uirapuru** that replaced the Air Force Academy''s S.11s and S.12s. Several Instructors still fly, notably the four aircraft of the Dutch **Fokker Four** foundation, which shows them at air displays.',
    (SELECT id FROM countries WHERE code = 'NLD'),
    '1946-01-01',
    '1947-12-18',
    '1951-01-01',
    209,
    630,
    (SELECT id FROM manufacturer WHERE code = 'FOK'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fokker S.11 Instructor'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.18,
  wingspan          = 11.0,
  height            = 2.22,
  wing_area         = 18.5,
  empty_weight      = 810,
  mtow              = 1100,
  service_ceiling   = 3850,
  climb_rate        = 3.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming O-435A (190 ch)',
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
  operators_count   = 6,
  variants          = E'- **S.11-1** : version de la force aérienne et de l''aéronavale néerlandaises, 48 exemplaires\n- **S.11-2** : version de l''armée de l''air israélienne, 41 exemplaires\n- **S.11-3 / Macchi M.416** : version italienne construite sous licence par Aermacchi et IMAM\n- **S.11-4 (T-21)** : version brésilienne, 99 exemplaires dont 95 construits par Fokker au Brésil\n- **S.12 (T-22)** : variante à train tricycle, un prototype et 49 appareils de série pour le Brésil',
  variants_en       = E'- **S.11-1**: version for the Dutch air force and naval air service, 48 built\n- **S.11-2**: version for the Israeli Air Force, 41 built\n- **S.11-3 / Macchi M.416**: Italian version built under licence by Aermacchi and IMAM\n- **S.11-4 (T-21)**: Brazilian version, 99 built including 95 by Fokker in Brazil\n- **S.12 (T-22)**: tricycle-undercarriage variant, one prototype and 49 production aircraft for Brazil',

  -- Strate 4 : qualitatif
  nickname          = 'Instructor',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fokker_S.11_Instructor',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fokker_S-11',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Schleiffert from Holland',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Fokker S.11 Instructor';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fokker S.11 Instructor';
