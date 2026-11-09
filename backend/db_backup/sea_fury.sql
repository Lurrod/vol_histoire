-- Hawker Sea Fury
--
-- Photo : Hawker Sea Fury T20 VX280 VL-120 (G-RNHF) (7297364024).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File:Hawker_Sea_Fury_T20_VX280_VL-120_(G-RNHF)_(7297364024).jpg

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
    'Hawker Sea Fury',
    'Hawker Sea Fury',
    'Hawker Sea Fury',
    'Hawker Sea Fury',
    'Dernier chasseur à hélice de la Royal Navy, et l’un des rares à avoir abattu un MiG-15',
    'The Royal Navy’s last piston fighter, and one of the few ever to down a MiG-15',
    '/assets/airplanes/hawker-sea-fury.jpg',
    E'## Genèse\nEn 1942, **Hawker** propose une version allégée et plus compacte de son Tempest : le Fury. La Royal Air Force et la Fleet Air Arm s''y intéressent ; la fin de la guerre conduit la RAF à renoncer, mais la Marine, pour qui l''avion à réaction embarqué reste à inventer, maintient sa commande. Le prototype du **Sea Fury** vole le **21 février 1945**. Il n''arrive en unité qu''en 1947 : sa carrière entière appartient à l''après-guerre.\n\n## Conception\nUn moteur en étoile **Bristol Centaurus** à dix-huit cylindres et chemises louvoyantes, de 2 480 ch, une hélice à cinq pales, des ailes repliables et quatre canons Hispano de 20 mm. La version principale, le **FB.11**, ajoute bombes et roquettes sous la voilure. À 740 km/h, il compte parmi les avions de série à moteur à pistons les plus rapides jamais construits, et sa robustesse en fait un excellent appareil d''attaque.\n\n## Carrière opérationnelle\nEn **Corée**, les Sea Fury des porte-avions britanniques HMS Theseus, Glory et Ocean, et australien **HMAS Sydney**, assurent attaque au sol, interdiction et patrouille de 1950 à 1953. En août 1952, le lieutenant **Peter Carmichael**, du 802 Squadron embarqué sur l''**HMS Ocean**, se voit crédité d''un **MiG-15** : l''une des très rares victoires d''un avion à hélice sur un chasseur à réaction. L''appareil est exporté vers une dizaine de forces aériennes, dont les Pays-Bas, le Canada, l''Australie, le Pakistan, l''Irak, l''Égypte et la Birmanie. Ironie de l''histoire, ce sont les Sea Fury achetés par Batista que l''aviation de **Fidel Castro** engage en avril 1961 contre le débarquement de la **baie des Cochons** ; avec les T-33 et B-26 cubains, ils contribuent à couler deux navires de la force d''invasion.\n\n## Place dans l''histoire\nEnviron huit cent soixante exemplaires de 1945 à 1955. Le Sea Fury est le dernier chasseur à hélice de la Fleet Air Arm, qui le remplace en première ligne par le **Hawker Sea Hawk** à réaction. Au Canada, il cède la place au **F2H Banshee**. Son rival direct d''outre-Atlantique, le **F8F Bearcat**, poursuit la même idée : un chasseur à pistons aussi léger et puissant que possible, au moment précis où le réacteur rend la formule caduque.',
    E'## Genesis\nIn 1942 **Hawker** proposed a lighter, more compact version of its Tempest: the Fury. Both the Royal Air Force and the Fleet Air Arm were interested; the end of the war led the RAF to drop it, but the Navy, for which the carrier jet had yet to be invented, kept its order. The **Sea Fury** prototype flew on **21 February 1945**. It reached squadrons only in 1947: its whole career belongs to the post-war era.\n\n## Design\nAn eighteen-cylinder sleeve-valve **Bristol Centaurus** radial of 2,480 hp, a five-bladed propeller, folding wings and four 20 mm Hispano cannon. The main version, the **FB.11**, added underwing bombs and rockets. At 740 km/h it ranks among the fastest production piston-engined aircraft ever built, and its toughness made it an excellent attack aircraft.\n\n## Operational career\nOver **Korea**, Sea Furies from the British carriers HMS Theseus, Glory and Ocean, and Australia’s **HMAS Sydney**, flew ground attack, interdiction and patrol from 1950 to 1953. In August 1952 Lieutenant **Peter Carmichael** of 802 Squadron, aboard **HMS Ocean**, was credited with a **MiG-15**: one of the very rare victories of a propeller aircraft over a jet fighter. The type was exported to some ten air arms, including the Netherlands, Canada, Australia, Pakistan, Iraq, Egypt and Burma. In an irony of history, it was the Sea Furies bought by Batista that **Fidel Castro**’s air force threw against the **Bay of Pigs** landing in April 1961; together with Cuban T-33s and B-26s they helped sink two ships of the invasion force.\n\n## Place in history\nSome eight hundred and sixty built from 1945 to 1955. The Sea Fury is the Fleet Air Arm’s last propeller fighter, replaced in front-line service by the jet **Hawker Sea Hawk**. In Canada it gave way to the **F2H Banshee**. Its direct rival across the Atlantic, the **F8F Bearcat**, pursued the same idea: a piston fighter as light and powerful as possible, at the very moment the jet made the formula obsolete.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1942-09-01',
    '1945-02-21',
    '1947-08-01',
    740.0,
    1127.0,
    (SELECT id FROM manufacturer WHERE code = 'HAW'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury'), (SELECT id FROM armement WHERE name = '1000 lb GP'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury'), (SELECT id FROM wars WHERE name = 'Guerre de Corée'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.57,
  wingspan          = 11.7,
  height            = 4.84,
  wing_area         = 26.01,
  empty_weight      = 4191,
  mtow              = 6645,
  service_ceiling   = 10900,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Centaurus XVIIC',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons en étoile, 18 cylindres',
  engine_type_en    = '18-cylinder radial piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1955,
  units_built       = 864,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Sea Fury F.10** : première série de chasseurs embarqués\n- **Sea Fury FB.11** : chasseur-bombardier, version principale, engagée en Corée\n- **Sea Fury T.20** : biplace d''entraînement\n- **FB.50 / FB.51** : versions de la Marine néerlandaise, en partie assemblées par Fokker\n- **Fury** terrestre : exportée notamment vers l''Irak et le Pakistan',
  variants_en       = E'- **Sea Fury F.10** : first batch of carrier fighters\n- **Sea Fury FB.11** : fighter-bomber, the main version, flown over Korea\n- **Sea Fury T.20** : two-seat trainer\n- **FB.50 / FB.51** : Royal Netherlands Navy versions, partly assembled by Fokker\n- Land-based **Fury** : exported notably to Iraq and Pakistan',

  -- Strate 4 : qualitatif
  nickname          = 'Sea Fury',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hawker_Sea_Fury',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hawker_Sea_Fury',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Hawker Sea Fury';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Hawker Sea Fury';
