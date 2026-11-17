-- Antonov An-30 (Clank)
--
-- Photo : Antonov AN-30 Clank 5D4 9075 (52256760389).jpg
--   licence CC BY 2.0 — Ronnie Macdonald from Chelmsford, United Kingdom
--   https://commons.wikimedia.org/wiki/File:Antonov_AN-30_Clank_5D4_9075_(52256760389).jpg

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
    'Antonov An-30',
    'Antonov An-30',
    'Antonov An-30 (Clank)',
    'Antonov An-30 (Clank)',
    'L''An-24 à nez vitré qui a cartographié l''Afghanistan et survolé l''Europe au titre du traité Ciel ouvert',
    'The glazed-nose An-24 that mapped Afghanistan and flew over Europe under the Open Skies Treaty',
    '/assets/airplanes/an30.jpg',
    E'## Genèse\nLa première version de cartographie aérienne de l''**An-24** n''est pas l''œuvre d''Antonov mais du bureau **Beriev**, qui transforme en 1966 un An-24A de série dans son atelier n° 49. Baptisé **An-24FK**, pour « photocartographique », le prototype vole le 21 août 1967. Les essais d''acceptation de l''État s''achèvent en 1970 et la certification civile en 1974. Rebaptisé An-30, l''avion entre en production en 1971 à l''usine Antonov de Kiev, qui en construit 123 jusqu''en 1980 en deux versions principales : l''An-30A civil et l''**An-30B** militaire.\n\n## Conception\nTout l''avant du fuselage est neuf. Le nez, largement vitré, abrite le navigateur, un viseur optique et un système de pilotage assisté par calculateur qui permet de répéter exactement les axes de prise de vue. Pour leur faire de la place, le poste de pilotage est surélevé de 41 cm, d''où la bosse caractéristique de l''appareil. En cabine, cinq fenêtres percées dans le plancher reçoivent trois caméras verticales de cartographie et deux caméras obliques inclinées de 28°, utilisables entre 2 000 et 7 000 m. Deux turbopropulseurs **Ivtchenko AI-24TVT** et un réacteur d''appoint **RU-19A-300** l''animent.\n\n## Carrière opérationnelle\nEn 1982, des An-30 cartographient l''intégralité de l''Afghanistan. Le 11 mars 1985, au retour d''une mission photographique au sud de la vallée du Panchir, l''un d''eux est touché par un missile **Strela** près de Kaboul ; deux des cinq membres d''équipage périssent. Des An-30 cubains servent en Angola en 1987. La Bulgarie, la Tchéquie, la Roumanie, la Russie et l''Ukraine l''emploient aussi pour les vols d''observation du **traité Ciel ouvert**. Dans le Donbass, un An-30 ukrainien est touché par des tirs séparatistes au-dessus de Sloviansk le 22 avril 2014, puis un An-30B est abattu près de la ville le 6 juin, vraisemblablement par un missile portable.\n\n## Place dans l''histoire\nDeuxième membre de la famille de l''An-24, avant l''**An-26** et l''**An-32**, l''An-30 a aussi tenté d''agir sur le temps : l''**An-30M** disperse de la carboglace dans les nuages pour provoquer la pluie ou dégager le ciel, comme lors du 850e anniversaire de Moscou en 1997. L''An-30R chargé de surveiller le panache de **Tchernobyl** en est resté radioactif et a été retiré aussitôt. Quatorze forces aériennes l''ont utilisé, et il vole encore, entre autres, en Russie, en Bulgarie, en Roumanie et en Ukraine.',
    E'## Genesis\nThe first aerial survey version of the **An-24** was not designed by Antonov but by the **Beriev** bureau, which converted a production An-24A at its No. 49 construction shop in 1966. Named **An-24FK**, for ''photo mapping'', the prototype flew on 21 August 1967. State acceptance trials were completed in 1970 and civil certification in 1974. Redesignated An-30, the aircraft entered production in 1971 at the Antonov factory in Kyiv, which built 123 by 1980 in two main versions: the civil An-30A and the military **An-30B**.\n\n## Design\nThe whole forward fuselage was new. The extensively glazed nose housed the navigator, an optical sight and computer flight path control, which made survey runs precisely repeatable. To make room, the flight deck was raised by 41 cm, giving the aircraft its characteristic hump. In the cabin, five camera windows in the floor took three vertical mapping cameras and two oblique cameras angled at 28 degrees, usable between 2,000 and 7,000 m. Two **Ivchenko AI-24TVT** turboprops and an **RU-19A-300** booster turbojet powered it.\n\n## Operational career\nIn 1982 An-30s mapped the whole of Afghanistan. On 11 March 1985, returning from a photographic sortie south of the Panjshir Valley, one was hit by a **Strela** missile near Kabul; two of the five crew were killed. Cuban An-30s saw active service in Angola in 1987. Bulgaria, the Czech Republic, Romania, Russia and Ukraine also used it for surveillance flights under the **Open Skies Treaty**. In the Donbas, a Ukrainian An-30 was hit by separatist small-arms fire over Sloviansk on 22 April 2014, and an An-30B was shot down near the town on 6 June, reportedly by a MANPADS.\n\n## Place in history\nThe second member of the An-24 family, ahead of the **An-26** and **An-32**, the An-30 also tried to control the weather: the **An-30M** sprayed dry ice into clouds to bring rain or clear the skies, as for Moscow''s 850th anniversary in 1997. The An-30R used to monitor the **Chernobyl** plume became permanently radioactive and was withdrawn at once. Fourteen air forces have flown it, and it remains in service in Russia, Bulgaria, Romania and Ukraine, among others.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1966-01-01',
    '1967-08-21',
    NULL,
    540,
    2630,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-30'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-30'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-30'), (SELECT id FROM wars WHERE name = 'Guerre soviéto-afghane')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-30'), (SELECT id FROM wars WHERE name = 'Guerre du Donbass'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 24.26,
  wingspan          = 29.2,
  height            = 8.32,
  wing_area         = 74.98,
  empty_weight      = 15590,
  mtow              = 23000,
  service_ceiling   = 8300,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 7,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-24TVT (2 803 ch) + Tumansky RU-19A-300 d''appoint',
  engine_count      = 3,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1971,
  production_end    = 1980,
  units_built       = 123,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 14,
  variants          = E'- **An-24FK** : prototype unique transformé par Beriev à partir d''un An-24 de série\n- **An-30A** : version civile de cartographie, dont sept exemplaires livrés à la Chine\n- **An-30B** : version de l''armée de l''air soviétique, 26 exemplaires, avionique différente et lance-leurres\n- **An-30D Sibiriak** : version à long rayon d''action pour la surveillance des glaces et des pêches\n- **An-30M** : version météorologique, dispersion de carboglace dans les nuages\n- **An-30R** : reconnaissance nucléaire, biologique et chimique à nacelles de prélèvement',
  variants_en       = E'- **An-24FK**: single prototype converted by Beriev from a production An-24\n- **An-30A**: civil survey version, seven of them delivered to China\n- **An-30B**: Soviet Air Force version, 26 built, different avionics and flare dispensers\n- **An-30D Sibiryak**: long-range version for ice and fisheries monitoring\n- **An-30M**: weather version, spraying dry ice into clouds\n- **An-30R**: nuclear, biological and chemical reconnaissance with sampling pods',

  -- Strate 4 : qualitatif
  nickname          = 'Clank',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-30',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-30',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ronnie Macdonald',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Antonov An-30';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-30';
