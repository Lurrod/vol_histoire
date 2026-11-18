-- AeroVironment RQ-20 Puma AE
--
-- Photo : RQ20A-130304-M-DE426-001 crop.jpg
--   licence Public domain — Sgt. Bobby Yarbrough
--   https://commons.wikimedia.org/wiki/File:RQ20A-130304-M-DE426-001_crop.jpg

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
    'AeroVironment RQ-20 Puma',
    'AeroVironment RQ-20 Puma',
    'AeroVironment RQ-20 Puma AE',
    'AeroVironment RQ-20 Puma AE',
    'Drone électrique lancé à la main, adopté par plus de vingt-cinq pays, de l''US Army à l''Ukraine',
    'Hand-launched electric drone adopted by more than twenty-five countries, from the US Army to Ukraine',
    '/assets/airplanes/rq20-puma.jpg',
    E'## Genèse\nLe Puma est un petit drone américain conçu par **AeroVironment** pour la surveillance et le renseignement : alimenté par batterie, il se lance à la main et filme le terrain avec une caméra électro-optique et infrarouge. Il vole en 2007 et, dès 2008, le commandement des opérations spéciales américain, le **SOCOM**, le sélectionne. En mars 2012, l''US Army commande la version **Puma AE** (All Environment) et la désigne **RQ-20A** ; les Marines et l''US Air Force passent une commande similaire le mois suivant. L''armée de terre finit par en aligner 325 systèmes, un par compagnie d''infanterie.\n\n## Conception\nChaque système militaire réunit trois appareils et deux stations sol. Le Puma AE mesure 1,4 m de long pour 2,8 m d''envergure et pèse moins de 6 kg : un soldat le lance à bout de bras. Mû par un moteur électrique, il vole à plus de 70 km/h, tient l''air environ deux heures et transmet en direct à sa station la vidéo de ses capteurs, dotés d''un zoom optique ×50. Il est conçu pour opérer de −29 à 49 °C, par des vents de 25 nœuds et sous une pluie de 25 mm par heure. Les versions suivantes allongent son endurance jusqu''à 5,5 heures et sa portée jusqu''à 60 km grâce à une antenne de poursuite.\n\n## Carrière opérationnelle\nLe 26 juillet 2013, le Puma devient l''un des premiers drones autorisés par la **FAA** à voler dans l''espace aérien américain à des fins commerciales ; le 8 juin 2014, il effectue pour BP, à Prudhoe Bay en Alaska, le premier vol commercial autorisé d''un drone au-dessus des terres. En 2016, l''US Navy le déploie sur un destroyer avec un système de récupération autonome, et l''emploie sur ses patrouilleurs du golfe Persique. Le 1er avril 2022, les États-Unis incluent des Puma dans une aide militaire de 300 millions de dollars à l''**Ukraine** envahie par la Russie ; au 19 septembre 2023, les forces russes en avaient abattu au moins dix.\n\n## Place dans l''histoire\nPlus de vingt-cinq pays, de l''Albanie à la Nouvelle-Zélande, ont adopté le Puma, souvent pour leurs forces spéciales ou leurs marines : le Royaume-Uni en dote des équipes de la 700 Naval Air Squadron au profit des Royal Marines, le Canada ses patrouilleurs de la classe Kingston, la Turquie le produit sous licence. Avec lui, la reconnaissance aérienne n''est plus l''affaire de l''état-major : chaque compagnie d''infanterie américaine dispose de son propre œil volant, lancé à la main.',
    E'## Genesis\nThe Puma is a small American drone designed by **AeroVironment** for surveillance and intelligence gathering: battery powered, it is launched by hand and watches the ground with an electro-optical and infrared camera. It flew in 2007 and, in 2008, US Special Operations Command, **SOCOM**, selected it. In March 2012 the US Army ordered the **Puma AE** (All Environment) version and designated it **RQ-20A**; the Marine Corps and the US Air Force placed a similar order the following month. The Army eventually fielded 325 systems, one per infantry company.\n\n## Design\nEach military system comprises three air vehicles and two ground stations. The Puma AE is 1.4 m long with a 2.8 m span and weighs under 6 kg: a soldier launches it at arm''s length. Driven by an electric motor, it flies at over 70 km/h, stays aloft for about two hours and live-streams video to its ground station from sensors that include a fifty-times optical zoom. It is designed to operate from −29 to 49 °C, in winds of 25 knots and in rain of 25 mm an hour. Later versions stretched its endurance to 5.5 hours and its range to 60 km with a tracking antenna.\n\n## Operational career\nOn 26 July 2013 the Puma became one of the first drones certified by the **FAA** to fly in US airspace for commercial purposes; on 8 June 2014 it flew for BP at Prudhoe Bay, Alaska, the first authorised commercial unmanned flight over land. In 2016 the US Navy deployed it aboard a destroyer with an autonomous recovery system, and used it on patrol craft in the Persian Gulf. On 1 April 2022 the United States included Pumas in a $300 million military aid package to **Ukraine**, invaded by Russia; by 19 September 2023 Russian forces had shot down at least ten of them.\n\n## Place in history\nMore than twenty-five countries, from Albania to New Zealand, have adopted the Puma, often for their special forces or navies: Britain gave it to 700 Naval Air Squadron teams supporting the Royal Marines, Canada to its Kingston-class patrol vessels, and Turkey builds it under licence. With it, aerial reconnaissance is no longer a matter for headquarters: every American infantry company has its own hand-launched flying eye.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '2007-01-01',
    '2008-01-01',
    83,
    15,
    (SELECT id FROM manufacturer WHERE code = 'AV'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-20 Puma'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-20 Puma'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-20 Puma'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 1.4,
  wingspan          = 2.8,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 5.9,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Moteur électrique sur batterie',
  engine_count      = 1,
  engine_type       = 'Moteur électrique',
  engine_type_en    = 'Electric motor',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 26,
  variants          = E'- **RQ-20A Puma AE** : désignation militaire de la version All Environment (2012)\n- **Enhanced Puma** : propulsion et batteries améliorées, 3,5 heures d''endurance (2014)\n- **RQ-20B Puma AE II** : Block 2, cellule allégée, navigation inertielle de précision, boule Mantis i45\n- **LRTA Puma** : antenne de poursuite à longue portée, 60 km (2018)\n- **Puma LE** : endurance portée à 5,5 heures (2019)\n- **Puma 3 AE** : version maritime capable de se poser sur l''eau ou au sol (2021)',
  variants_en       = E'- **RQ-20A Puma AE**: military designation of the All Environment version (2012)\n- **Enhanced Puma**: improved propulsion and batteries, 3.5 hours'' endurance (2014)\n- **RQ-20B Puma AE II**: Block 2, lighter airframe, precision inertial navigation, Mantis i45 gimbal\n- **LRTA Puma**: long-range tracking antenna, 60 km (2018)\n- **Puma LE**: endurance extended to 5.5 hours (2019)\n- **Puma 3 AE**: maritime version able to land on water or ground (2021)',

  -- Strate 4 : qualitatif
  nickname          = 'Puma',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AeroVironment_RQ-20_Puma',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Sgt. Bobby Yarbrough, U.S. Marine Corps',
  image_licence     = 'Public domain'
WHERE name = 'AeroVironment RQ-20 Puma';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AeroVironment RQ-20 Puma';
