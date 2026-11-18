-- AeroVironment RQ-14 Dragon Eye
--
-- Photo : US Navy 041108-M-5882G-071 U.S. Marines assigned to Alpha Company, 1st Battalion, 7th Marines, prepare to launch a Dradoneye Small Unit Remote Scouting System, outside the village of Al Qaim, Iraq.jpg
--   licence Public domain — U.S. Marine Corps photo by Lance Cpl. Christopher G. Graham
--   https://commons.wikimedia.org/wiki/File:US_Navy_041108-M-5882G-071_U.S._Marines_assigned_to_Alpha_Company,_1st_Battalion,_7th_Marines,_prepare_to_launch_a_Dradoneye_Small_Unit_Remote_Scouting_System,_outside_the_village_of_Al_Qaim,_Iraq.jpg

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
    'AeroVironment RQ-14 Dragon Eye',
    'AeroVironment RQ-14 Dragon Eye',
    'AeroVironment RQ-14 Dragon Eye',
    'AeroVironment RQ-14 Dragon Eye',
    'Mini-drone de 2 kg qui tient dans un sac à dos, conçu pour l''escouade des Marines et engagé en Irak',
    'A 2 kg mini-drone that fits in a backpack, built for the Marine squad and used in Iraq',
    '/assets/airplanes/rq14-dragon-eye.jpg',
    E'## Genèse\nLe Dragon Eye est né dans les laboratoires de recherche de la marine américaine : le **Naval Research Laboratory** et le **Marine Corps Warfighting Laboratory** le conçoivent pour l''**US Marine Corps**. Leur objectif est de donner la reconnaissance, la surveillance et l''acquisition d''objectifs non plus à l''état-major, mais à la compagnie, à la section et même au groupe de combat, sur une dizaine de kilomètres autour d''eux. Le drone vole pour la première fois en juin 2001 et entre en service en 2002. Le contrat de production est attribué en 2003 à **AeroVironment**.\n\n## Conception\nC''est un petit avion sans queue, à aile rectangulaire, tiré par deux hélices qu''entraînent de petits moteurs électriques silencieux. Avec 1,14 m d''envergure et environ 2,3 kg, il tient dans un sac à dos et se lance à la main ou à l''aide d''un simple sandow du commerce. Pour résister aux chocs, il se démonte à l''impact au lieu de se briser : les éléments se raccrochent ensuite ou se remplacent. Un système de navigation par points de passage, fondé sur le GPS et une centrale inertielle, le guide. L''opérateur suit le vol dans des lunettes vidéo reliées à un ordinateur portable, et l''ensemble de contrôle ne pèse que 5,4 kg.\n\n## Carrière opérationnelle\nLe Dragon Eye sert surtout à éclairer les zones urbaines, où il se révèle particulièrement utile lors des assauts. Mis en œuvre par un Marine entraîné, il permet de repérer l''ennemi sans que celui-ci soupçonne sa présence. Il est engagé en **Irak** dès 2003, après l''invasion, et y reste employé dans les années suivantes. Plus de 1 000 exemplaires sont construits avant que les Marines n''utilisent le reste du contrat pour passer au **RQ-11 Raven B** du même constructeur.\n\n## Place dans l''histoire\nLe Dragon Eye a donné aux Marines un drone taillé pour le plus petit échelon de l''infanterie. Son autonomie de 45 à 60 minutes, sa portée de transmission de 10 km et son vol à une centaine de mètres du sol suffisaient à voir derrière le prochain pâté de maisons. Avec lui, AeroVironment a posé les bases de sa gamme de mini-drones lancés à la main, du Raven au **Puma**.',
    E'## Genesis\nThe Dragon Eye was born in the US naval research laboratories: the **Naval Research Laboratory** and the **Marine Corps Warfighting Laboratory** developed it for the **US Marine Corps**. Their aim was to bring reconnaissance, surveillance and target acquisition down from headquarters to the company, the platoon and even the squad, over about ten kilometres around them. The drone first flew in June 2001 and entered service in 2002. The production contract went to **AeroVironment** in 2003.\n\n## Design\nIt is a small tailless aircraft with a rectangular wing, pulled by two propellers driven by small, quiet electric motors. With a 1.14 m span and a weight of about 2.3 kg, it fits into a backpack and is launched by hand or with an ordinary store-bought bungee cord. To survive knocks, it breaks apart on impact instead of shattering: the parts can be reattached or replaced. A GPS and inertial waypoint navigation system guides it. The operator follows the flight through video goggles connected to a laptop computer, and the whole control system weighs only 5.4 kg.\n\n## Operational career\nThe Dragon Eye was used mainly for scouting urban areas, where it proved especially useful in assaults. In the hands of a trained Marine, it could spot the enemy without alerting him to its presence. It went to **Iraq** in 2003, after the invasion, and remained in use there in the years that followed. More than 1,000 were built before the Marines switched the rest of the contract to the same maker''s **RQ-11 Raven B**.\n\n## Place in history\nThe Dragon Eye gave the Marines a drone tailored to the smallest echelon of the infantry. Its endurance of 45 to 60 minutes, its 10 km transmission range and its flight at around a hundred metres above the ground were enough to see behind the next block of houses. With it AeroVironment laid the foundations of its range of hand-launched mini-drones, from the Raven to the **Puma**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '2001-06-01',
    '2002-01-01',
    NULL,
    5,
    (SELECT id FROM manufacturer WHERE code = 'AV'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-14 Dragon Eye'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-14 Dragon Eye'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-14 Dragon Eye'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-14 Dragon Eye'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 0.91,
  wingspan          = 1.14,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 2.7,
  service_ceiling   = 152,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Deux moteurs électriques',
  engine_count      = 2,
  engine_type       = 'Moteur électrique',
  engine_type_en    = 'Electric motor',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2003,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **RQ-14 Dragon Eye** : version de série du Marine Corps, production confiée à AeroVironment en 2003\n- **Aile rectangulaire sans queue**, deux hélices entraînées par des moteurs électriques\n- **Cellule démontable** : les éléments se séparent à l''impact et se remontent ou se remplacent\n- **Station sol de 5,4 kg** : ordinateur portable et lunettes vidéo\n- **Plus de 1 000 exemplaires** avant le passage au RQ-11 Raven B',
  variants_en       = E'- **RQ-14 Dragon Eye**: Marine Corps production version, built by AeroVironment from 2003\n- **Tailless rectangular wing**, two propellers driven by electric motors\n- **Break-apart airframe**: parts separate on impact and can be reattached or replaced\n- **5.4 kg ground station**: laptop computer and video goggles\n- **More than 1,000 built** before the switch to the RQ-11 Raven B',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/RQ-14_Dragon_Eye',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AeroVironment_RQ-14_Dragon_Eye',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Lance Cpl. Christopher G. Graham, U.S. Marine Corps',
  image_licence     = 'Public domain'
WHERE name = 'AeroVironment RQ-14 Dragon Eye';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AeroVironment RQ-14 Dragon Eye';
