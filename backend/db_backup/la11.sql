-- Lavotchkine La-11
--
-- Photo : LA-11-Lavochikin.jpg
--   licence CC BY-SA 4.0 — Museum Pusat TNI AU Dirgantara Mandala, Yogyakarta, Indonesia
--   https://commons.wikimedia.org/wiki/File:LA-11-Lavochikin.jpg

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
    'La-11',
    'La-11',
    'Lavotchkine La-11',
    'Lavochkin La-11',
    'Dernier chasseur à hélice de Lavotchkine, escorteur à long rayon d''action devenu intercepteur en Corée',
    'Lavochkin''s last piston fighter, a long-range escort that ended up as an interceptor over Korea',
    '/assets/airplanes/lavochkin-la11.jpg',
    E'## Genèse\nLe La-11 naît des essais officiels du **La-130**, prototype du **La-9** : la commission recommande d''en tirer un **chasseur d''escorte à long rayon d''action**. Le bureau d''études **Lavotchkine** construit le **La-134**, parfois appelé La-9M, aux réservoirs de carburant et d''huile agrandis, dont le premier vol a lieu en mai 1947. Un second prototype, le La-134D, emporte encore 275 litres de plus dans l''aile et en réservoirs extérieurs. Mis en production sous le nom de **La-11** dès 1947, il reçoit de l''OTAN le nom de code *Fang*.\n\n## Conception\nC''est pour l''essentiel un La-9 dont on a retiré l''un des quatre canons **NS-23** de 23 mm pour gagner du carburant. Le moteur en étoile **Chvetsov ASh-82FN** de 1 850 ch entraîne une hélice tripale. Les longues missions imposent des pneus plus gros, un siège rembourré avec accoudoirs, un urinoir et un équipement complet de radionavigation. À pleine charge, les performances de combat s''en ressentent, et l''avion se révèle peu à l''aise au-dessus de 7 000 m : face à un **B-29** à son altitude de croisière, il ne dispose que de 20 km/h d''avance et met 26 minutes à l''y rejoindre.\n\n## Carrière opérationnelle\nPrévu pour escorter, le La-11 sert surtout d''intercepteur. Le 8 avril 1950, quatre pilotes soviétiques abattent au-dessus de la Baltique un **PB4Y-2 Privateer** de l''US Navy et ses dix hommes d''équipage ; un P2V Neptune tombe la même année près de Vladivostok. En 1950, un régiment de La-11 défend Shanghai contre les bombardements nationalistes. En **Corée**, il patrouille dès juillet 1950 et chasse surtout l''**A-26 Invader** de nuit ; le 30 novembre 1951, seize La-11 chinois escortant des Tu-2 vers l''île de Taehwa-do sont attaqués par plus de trente F-86, et trois sont abattus. Le 23 juillet 1954, deux La-11 chinois abattent au large de Hainan un DC-4 de Cathay Pacific, tuant dix personnes.\n\n## Place dans l''histoire\nProduit à 1 182 exemplaires jusqu''en 1951, le La-11 est le dernier chasseur à hélice de Lavotchkine, dont les modèles suivants sont à réaction. Son altitude de combat trop basse et l''arrivée du réacteur le font vite remplacer dans les unités soviétiques par le **MiG-15**. Il poursuit sa carrière en Chine, qui en reçoit 163 et retire les 18 derniers en 1966, en Corée du Nord et en Indonésie, qui en obtient 24 de la Chine en 1958-1959. Il marque la fin d''une époque : celle où l''on concevait encore des chasseurs à pistons pour escorter les bombardiers.',
    E'## Genesis\nThe La-11 grew out of the official trials of the **La-130**, prototype of the **La-9**: the commission recommended developing it into a **long-range escort fighter**. The **Lavochkin** design bureau built the **La-134**, sometimes called the La-9M, with enlarged fuel and oil tanks; it first flew in May 1947. A second prototype, the La-134D, carried a further 275 litres in the wings and in external tanks. Put into production as the **La-11** in 1947, it received the NATO reporting name *Fang*.\n\n## Design\nIt was essentially a La-9 with one of its four 23 mm **NS-23** cannon removed to make room for fuel. The 1,850 hp **Shvetsov ASh-82FN** radial engine drove a three-bladed propeller. Long missions called for larger tyres, a padded seat with armrests, a urinal and a full radio navigation suite. Fully fuelled, its combat performance suffered, and it proved poorly suited to fighting above 7,000 m: against a **B-29** at cruising altitude it had a margin of only 20 km/h and needed 26 minutes to get there.\n\n## Operational career\nDesigned as an escort, the La-11 served mostly as an interceptor. On 8 April 1950 four Soviet pilots shot down a US Navy **PB4Y-2 Privateer** over the Baltic, killing its ten crew; a P2V Neptune was downed near Vladivostok later that year. In 1950 a La-11 regiment defended Shanghai against Nationalist bombing raids. Over **Korea** it flew patrols from July 1950 and mainly hunted the **A-26 Invader** night bomber; on 30 November 1951 sixteen Chinese La-11s escorting Tu-2s to Taehwa-do island were attacked by more than thirty F-86s, and three were shot down. On 23 July 1954 two Chinese La-11s shot down a Cathay Pacific DC-4 off Hainan, killing ten people.\n\n## Place in history\nWith 1,182 built up to 1951, the La-11 was Lavochkin''s last piston-engined fighter; its successors were jets. Its low combat ceiling and the arrival of the jet engine saw it quickly replaced in Soviet units by the **MiG-15**. It carried on in China, which received 163 and retired the last 18 in 1966, in North Korea and in Indonesia, which obtained 24 from China in 1958-1959. It marks the end of an era: the last time piston fighters were designed to escort bombers.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '1947-05-01',
    '1950-04-01',
    674,
    2235,
    (SELECT id FROM manufacturer WHERE code = 'LAV'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'La-11'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'La-11'), (SELECT id FROM armement WHERE name = 'NS-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'La-11'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'La-11'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'La-11'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'La-11'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'La-11'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.62,
  wingspan          = 9.8,
  height            = 3.47,
  wing_area         = 17.6,
  empty_weight      = 2770,
  mtow              = 3996,
  service_ceiling   = 10250,
  climb_rate        = 12.63,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Chvetsov ASh-82FN (1 850 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 1951,
  units_built       = 1182,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **La-130** : prototype du La-9, dont les essais recommandent une version d''escorte\n- **La-134 (La-9M)** : premier prototype, réservoirs agrandis et trois canons, vol en mai 1947\n- **La-134D** : second prototype, 275 litres de carburant supplémentaires et radionavigation complète\n- **La-11 (La-140)** : version de série, produite de 1947 à 1951',
  variants_en       = E'- **La-130**: La-9 prototype whose trials recommended an escort version\n- **La-134 (La-9M)**: first prototype, enlarged tanks and three cannon, flew in May 1947\n- **La-134D**: second prototype, 275 litres of extra fuel and a full radio navigation suite\n- **La-11 (La-140)**: production version, built from 1947 to 1951',

  -- Strate 4 : qualitatif
  nickname          = 'Fang',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lavotchkine_La-11',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lavochkin_La-11',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Museum Pusat TNI AU Dirgantara Mandala',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'La-11';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'La-11';
