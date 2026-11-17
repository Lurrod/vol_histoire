-- SIAI-Marchetti S.211
--
-- Photo : PAF S-211 No. 004 in Flight.jpg
--   licence CC BY 2.0 — Philippine Fly Boy
--   https://commons.wikimedia.org/wiki/File:PAF_S-211_No._004_in_Flight.jpg

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
    'SIAI-Marchetti S.211',
    'SIAI-Marchetti S.211',
    'SIAI-Marchetti S.211',
    'SIAI-Marchetti S.211',
    'Petit biplace d''école à réaction en composites, école de Singapour et avion d''attaque des Philippines',
    'Small composite jet trainer, school of Singapore''s pilots and light attack aircraft of the Philippines',
    '/assets/airplanes/s211.jpg',
    E'## Genèse\nEn 1976, **SIAI-Marchetti** lance sur fonds propres l''étude d''un avion d''école de base à réaction. La firme vise sa clientèle existante, les nombreuses forces aériennes qui utilisent déjà son **SF.260** à moteur à pistons et pourraient y ajouter un petit jet économique. Le projet est dévoilé au Salon du Bourget en 1977 et suscite assez d''intérêt pour justifier la construction de prototypes. Le premier vole le 10 avril 1981 ; Singapour passe la première commande, dix appareils, en 1983.\n\n## Conception\nLe S.211 est un biplace compact à aile haute, entièrement voltigeable, à train tricycle escamotable. Élève et instructeur sont assis en tandem, la place arrière surélevée pour mieux voir vers l''avant, avec des postes entièrement doublés. La cellule fait largement appel aux **matériaux composites**, Kevlar, Nomex et fibre de carbone, assemblés par collage. Un seul turbofan **Pratt & Whitney Canada JT15D** de 11 kN suffit à l''emmener à plus de 650 km/h et à 12 200 m. Quatre points d''emport sous les ailes lui donnent une capacité secondaire d''appui rapproché, avec bombes, paniers de roquettes ou équipements de reconnaissance photographique.\n\n## Carrière opérationnelle\nLa force aérienne de Singapour en reçoit 32, en grande partie assemblés sur place, et les fait voler en Australie, à la base de Pearce, jusqu''à leur remplacement par le **Pilatus PC-21** à partir de 2008. Les Philippines en reçoivent 24 à partir de 1989 : rebaptisés **AS-211 Warriors**, ils servent à la fois d''écoles et d''avions d''attaque. Après le retrait des derniers **F-5** en 2005, ils héritent même de la défense aérienne et reçoivent le viseur et les radios des F-5, ainsi qu''une nacelle ventrale de mitrailleuse de 12,7 mm conçue aux Philippines. Haïti, enfin, en prend quatre en 1985 avant de les revendre.\n\n## Place dans l''histoire\nConstruit à une soixantaine d''exemplaires, le S.211 n''a pas connu le succès commercial espéré : sa version S.211A, associée à **Grumman** puis Northrop Grumman, échoue face au **T-6 Texan II** dans le programme américain JPATS. Il a pourtant formé pendant plus de vingt ans les pilotes de Singapour, et quelques exemplaires volent encore aux Philippines en 2025. Repris par **Aermacchi** en 1997, il a donné naissance au M-345, entré en service en Italie en 2020.',
    E'## Genesis\nIn 1976 **SIAI-Marchetti** began, as a private venture, the design of a jet basic trainer. The firm targeted its existing customers, the many air forces already flying its piston-engined **SF.260** that might add a small, economical jet. The project was unveiled at the Paris Air Show in 1977 and drew enough interest to justify building prototypes. The first flew on 10 April 1981; Singapore placed the first order, for ten aircraft, in 1983.\n\n## Design\nThe S.211 was a compact, fully aerobatic shoulder-wing two-seater with a retractable tricycle undercarriage. Student and instructor sat in tandem, the rear seat raised for a better forward view, with fully duplicated cockpits. The airframe made wide use of **composite materials**, Kevlar, Nomex and carbon fibre, joined by structural bonding. A single 11 kN **Pratt & Whitney Canada JT15D** turbofan was enough to take it beyond 650 km/h and up to 12,200 m. Four underwing hardpoints gave it a secondary close air support capability, with bombs, rocket pods or photographic reconnaissance equipment.\n\n## Operational career\nThe Republic of Singapore Air Force received 32, largely assembled locally, and flew them in Australia at Pearce until their replacement by the **Pilatus PC-21** from 2008. The Philippines received 24 from 1989: renamed **AS-211 Warriors**, they served as both trainers and attack aircraft. After the last **F-5**s were retired in 2005, they even took over air defence and received the F-5s'' gunsight and radios, along with a ventral 12.7 mm machine gun pod designed in the Philippines. Haiti, finally, took four in 1985 before selling them.\n\n## Place in history\nBuilt to around sixty aircraft, the S.211 did not achieve the commercial success hoped for: its S.211A version, teamed with **Grumman** and later Northrop Grumman, lost to the **T-6 Texan II** in the American JPATS programme. Yet it trained Singapore''s pilots for more than twenty years, and a few were still flying in the Philippines in 2025. Taken over by **Aermacchi** in 1997, it gave rise to the M-345, which entered service in Italy in 2020.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1976-01-01',
    '1981-04-10',
    '1984-01-01',
    667,
    1668,
    (SELECT id FROM manufacturer WHERE code = 'SIAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'SIAI-Marchetti S.211'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'SIAI-Marchetti S.211'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'SIAI-Marchetti S.211'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'SIAI-Marchetti S.211'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'SIAI-Marchetti S.211'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.31,
  wingspan          = 8.43,
  height            = 3.8,
  wing_area         = 12.6,
  empty_weight      = 1850,
  mtow              = 3150,
  service_ceiling   = 12200,
  climb_rate        = 21,
  g_limit_pos       = 6,
  g_limit_neg       = -3,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada JT15D-4C',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 11.12,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1981,
  production_end    = 1994,
  units_built       = 60,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **S.211** : version de série, une soixantaine d''exemplaires pour Singapour, les Philippines et Haïti\n- **AS-211 Warrior** : désignation philippine ; à partir de 2005, viseur et radios repris des F-5 et nacelle ventrale de mitrailleuse de 12,7 mm\n- **S.211A** : version plus puissante proposée avec Grumman au programme américain JPATS, deux prototypes\n- **M-311 / M-345** : dérivé modernisé annoncé par Aermacchi en 2004, devenu le M-345 entré en service en 2020',
  variants_en       = E'- **S.211**: production version, around sixty built for Singapore, the Philippines and Haiti\n- **AS-211 Warrior**: Philippine designation; from 2005, gunsight and radios taken from F-5s and a ventral 12.7 mm machine gun pod\n- **S.211A**: more powerful version offered with Grumman for the American JPATS programme, two prototypes\n- **M-311 / M-345**: modernised derivative announced by Aermacchi in 2004, which became the M-345 that entered service in 2020',

  -- Strate 4 : qualitatif
  nickname          = 'Warrior',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/SIAI_Marchetti_S.211',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/SIAI-Marchetti_S.211',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Philippine Fly Boy',
  image_licence     = 'CC BY 2.0'
WHERE name = 'SIAI-Marchetti S.211';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'SIAI-Marchetti S.211';
