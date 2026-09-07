-- Boeing EA-18G Growler
--
-- Photo : VAQ-129 EA-18G After Takeoff - Aviation Nation 2019.jpg
--   licence CC BY-SA 4.0 — Noah Wulf
--   https://commons.wikimedia.org/wiki/File%3AVAQ-129_EA-18G_After_Takeoff_-_Aviation_Nation_2019.jpg

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
    'EA-18G Growler',
    'EA-18G Growler',
    'Boeing EA-18G Growler',
    'Boeing EA-18G Growler',
    'Le seul avion de guerre électronique dédié encore produit dans le monde',
    'The only dedicated electronic warfare aircraft still in production',
    '/assets/airplanes/ea18g-growler.jpg',
    E'## Genèse\nL''**EA-6B Prowler**, seul brouilleur embarqué américain, date de 1971 et arrive en fin de vie de cellule au début des années 2000. Le remplacer par un appareil neuf coûterait des décennies. Boeing propose une greffe : prendre un **F/A-18F Super Hornet** biplace de série et y installer l''ensemble du système de guerre électronique.\n\n## Conception\nLe canon est retiré du nez pour loger un récepteur ; les extrémités d''aile reçoivent des antennes de détection ; trois nacelles **ALQ-99** pendent sous la voilure. Neuf éléments seulement diffèrent d''un Super Hornet standard, ce qui divise par dix le coût de développement et permet aux mécaniciens du bord d''entretenir les deux types indifféremment.\n\n## Carrière opérationnelle\nCent soixante exemplaires. Engagé en **Libye** en 2011, contre l''État islamique en Irak et en Syrie, et déployé en permanence en Europe depuis 2022. L''**Australie** en achète douze, seule vente à l''étranger : Washington considère la guerre électronique comme une technologie trop sensible pour être largement exportée.\n\n## Place dans l''histoire\nCent soixante exemplaires. Le Growler est aujourd''hui **le seul avion de guerre électronique dédié produit dans le monde occidental** — les autres forces aériennes brouillent avec des nacelles montées sur des chasseurs ordinaires. Il hérite d''une lignée que ce catalogue suit depuis l''**EA-6B Prowler**.',
    E'## Genesis\nThe **EA-6B Prowler**, the only American carrier-based jammer, dated from 1971 and was reaching the end of its airframe life in the early 2000s. Replacing it with a new design would take decades. Boeing proposed a graft: take a production two-seat **F/A-18F Super Hornet** and install the whole electronic warfare suite in it.\n\n## Design\nThe gun is removed from the nose to house a receiver; the wingtips carry detection antennas; three **ALQ-99** pods hang under the wing. Only nine components differ from a standard Super Hornet, which divides development cost by ten and lets shipboard mechanics maintain both types interchangeably.\n\n## Operational career\nOne hundred and sixty built. Used over **Libya** in 2011, against Islamic State in Iraq and Syria, and permanently deployed in Europe since 2022. **Australia** bought twelve, the only foreign sale: Washington considers electronic warfare too sensitive a technology to export widely.\n\n## Place in history\nOne hundred and sixty built. The Growler is today **the only dedicated electronic warfare aircraft in production in the Western world** — other air forces jam with pods on ordinary fighters. It inherits a line this catalogue has followed since the **EA-6B Prowler**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2001-01-01',
    '2006-08-15',
    '2009-09-01',
    1900.0,
    3330.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Guerre électronique'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'EA-18G Growler'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'EA-18G Growler'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'EA-18G Growler'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'EA-18G Growler'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'EA-18G Growler'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'EA-18G Growler'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'EA-18G Growler'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 18.31,
  wingspan          = 13.62,
  height            = 4.88,
  wing_area         = 46.45,
  empty_weight      = 15011,
  mtow              = 29964,
  service_ceiling   = 15000,
  climb_rate        = 228.0,
  g_limit_pos       = 7.6,
  g_limit_neg       = -3.0,
  combat_radius     = 1080,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F414-GE-400',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 62.3,
  thrust_wet        = 97.9,

  -- Strate 3 : production & service
  production_start  = 2007,
  production_end    = 2024,
  units_built       = 160,
  unit_cost_usd     = 68000000,
  unit_cost_year    = 2020,
  operators_count   = 2,
  variants          = E'- **EA-18G** : version unique, dérivée du **F/A-18F Super Hornet** biplace\n- Nacelles de brouillage **ALQ-99**, héritées de l''**EA-6B Prowler** qu''il remplace\n- **NGJ** : nouvelle nacelle à antennes actives, en remplacement depuis 2022\n- Seul appareil de sa catégorie exporté : douze livrés à l''**Australie**\n- Conserve un **canon** et des Sidewinder : contrairement au Prowler, il peut se défendre',
  variants_en       = E'- **EA-18G** : the only version, derived from the two-seat **F/A-18F Super Hornet**\n- **ALQ-99** jamming pods, inherited from the **EA-6B Prowler** it replaces\n- **NGJ** : new active-array pod, replacing them since 2022\n- The only aircraft of its kind exported: twelve delivered to **Australia**\n- Keeps a **gun** and Sidewinders: unlike the Prowler, it can defend itself',

  -- Strate 4 : qualitatif
  nickname          = 'Growler',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_EA-18G_Growler',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_EA-18G_Growler',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Noah Wulf',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'EA-18G Growler';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'EA-18G Growler';
