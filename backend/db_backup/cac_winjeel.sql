-- CAC CA-25 Winjeel
--
-- Photo : Winjeel VH-OPJ.jpg
--   licence CC BY-SA 4.0 — Mickydee2066
--   https://commons.wikimedia.org/wiki/File:Winjeel_VH-OPJ.jpg

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
    'CAC Winjeel',
    'CAC Winjeel',
    'CAC CA-25 Winjeel',
    'CAC CA-25 Winjeel',
    'Avion-école australien à moteur en étoile, quarante ans de service dans la RAAF jusqu''au guidage aérien avancé',
    'Australian radial-engined trainer, forty years of RAAF service ending in forward air control',
    '/assets/airplanes/cac-winjeel.jpg',
    E'## Genèse\nEn 1948, la Royal Australian Air Force publie la spécification technique **AC.77** : il lui faut un avion-école capable de remplacer à la fois le **de Havilland Tiger Moth** et le **CAC Wirraway**. La **Commonwealth Aircraft Corporation**, installée à Fishermans Bend, dans l''État de Victoria, conçoit pour y répondre un appareil national. Son nom, **Winjeel**, vient d''un mot aborigène du Victoria signifiant « jeune aigle », une autre graphie de Bunjil. Les deux prototypes **CA-22** volent en février 1951.\n\n## Conception\nLe Winjeel est un monoplan à aile basse, propulsé par un moteur en étoile **Pratt & Whitney R-985 Wasp Junior** de 445 ch, avec deux membres d''équipage et la possibilité d''installer un troisième siège. Les essais révèlent un défaut inattendu pour un avion d''école : il est si stable qu''il est presque impossible de le mettre en vrille. Or l''apprentissage de la vrille fait partie de la formation des pilotes, et l''empennage doit être redessiné. La version de série, le **CA-25**, est commandée à 62 exemplaires, immatriculés A85-401 à A85-462.\n\n## Carrière opérationnelle\nLe premier CA-25 vole le 23 février 1955 et les livraisons commencent en septembre, à la 1re école de pilotage de base d''Uranquinty, en Nouvelle-Galles du Sud ; le dernier est livré en août 1957. Le Winjeel forme ensuite des générations de pilotes à Point Cook. En 1968, la RAAF tente une formation entièrement sur réacteur avec l''**Aermacchi MB-326** ; l''échec de ce concept prolonge le Winjeel jusqu''en 1975, quand arrive le CT/4A Airtrainer néo-zélandais. Il entame alors une seconde carrière de **contrôle aérien avancé** : armé de bombes fumigènes, il marque les cibles pour l''aviation d''attaque. En 1994, les quatre derniers, au No. 76 Squadron de Williamtown, cèdent la place au **Pilatus PC-9**.\n\n## Place dans l''histoire\nConçu et construit en Australie, le Winjeel est resté près de quarante ans dans la RAAF, de 1955 à 1994. Avion de formation de base de 1955 à 1975, il a survécu à la tentative de tout confier au réacteur, puis s''est réinventé en avion d''observation. Il reste très présent : une vingtaine d''exemplaires volent encore entre des mains privées, et la RAAF en conserve un pour ses présentations historiques.',
    E'## Genesis\nIn 1948 the Royal Australian Air Force issued technical requirement **AC.77**: it needed a trainer able to replace both the **de Havilland Tiger Moth** and the **CAC Wirraway**. The **Commonwealth Aircraft Corporation**, based at Fishermans Bend in Victoria, designed a domestic aircraft to meet it. Its name, **Winjeel**, comes from a Victorian Aboriginal word meaning "young eagle", an alternative spelling of Bunjil. The two **CA-22** prototypes flew in February 1951.\n\n## Design\nThe Winjeel was a low-wing monoplane powered by a 445 hp **Pratt & Whitney R-985 Wasp Junior** radial engine, with a crew of two and provision for a third seat. Testing revealed an unexpected flaw for a trainer: it was so stable that it was almost impossible to spin. Since spin training was a required part of pilot instruction, the tail had to be redesigned. The production version, the **CA-25**, was ordered in 62 examples, serialled A85-401 to A85-462.\n\n## Operational career\nThe first CA-25 flew on 23 February 1955 and deliveries began in September, to No. 1 Basic Flying Training School at Uranquinty, New South Wales; the last was delivered in August 1957. The Winjeel went on to train generations of pilots at Point Cook. In 1968 the RAAF tried all-through jet training with the **Aermacchi MB-326**; the failure of that concept kept the Winjeel in service until 1975, when the New Zealand-built CT/4A Airtrainer arrived. It then began a second career in **forward air control**: armed with smoke bombs, it marked targets for strike aircraft. In 1994 the last four, with No. 76 Squadron at Williamtown, gave way to the **Pilatus PC-9**.\n\n## Place in history\nDesigned and built in Australia, the Winjeel stayed with the RAAF for nearly forty years, from 1955 to 1994. The basic trainer from 1955 to 1975, it outlived the attempt to entrust everything to the jet, then reinvented itself as an observation aircraft. It remains a familiar sight: around twenty examples still fly in private hands, and the RAAF keeps one for heritage displays.',
    (SELECT id FROM countries WHERE code = 'AUS'),
    '1948-01-01',
    '1955-02-23',
    '1955-09-01',
    299,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'CWA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'CAC Winjeel'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'CAC Winjeel'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'CAC Winjeel'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.55,
  wingspan          = 11.77,
  height            = 2.77,
  wing_area         = 23.1,
  empty_weight      = 1492,
  mtow              = 1935,
  service_ceiling   = 5500,
  climb_rate        = 7.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-985-AN-2 Wasp Junior (445 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1957,
  units_built       = 64,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **CA-22** : prototypes, deux exemplaires ayant volé en février 1951 ; empennage redessiné après des essais de vrille\n- **CA-25** : version de série d''entraînement de base pour la RAAF, 62 exemplaires (A85-401 à A85-462)\n- **Winjeel de contrôle aérien avancé** : Winjeel reconvertis après 1975 pour le marquage d''objectifs à la bombe fumigène, jusqu''en 1994',
  variants_en       = E'- **CA-22**: prototypes, two built, first flown in February 1951; tail redesigned after spinning trials\n- **CA-25**: production basic trainer for the RAAF, 62 built (A85-401 to A85-462)\n- **Forward air control Winjeel**: Winjeels converted after 1975 for target marking with smoke bombs, until 1994',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/CAC_CA-25_Winjeel',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/CAC_Winjeel',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mickydee2066',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'CAC Winjeel';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'CAC Winjeel';
