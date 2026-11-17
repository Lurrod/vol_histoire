-- Iliouchine Il-80 (Il-86VKP)
--
-- Photo : Airborne command and control aircraft IL-86VKP (1).jpg
--   licence CC BY-SA 4.0 — Vitaly V. Kuzmin
--   https://commons.wikimedia.org/wiki/File:Airborne_command_and_control_aircraft_IL-86VKP_(1).jpg

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
    'Iliouchine Il-80',
    'Ilyushin Il-80',
    'Iliouchine Il-80 (Il-86VKP)',
    'Ilyushin Il-80 (Il-86VKP)',
    'Un Il-86 sans hublots, en livrée Aeroflot, pour commander la Russie pendant une guerre nucléaire',
    'A windowless Il-86 in Aeroflot livery, built to command Russia through a nuclear war',
    '/assets/airplanes/il80.jpg',
    E'## Genèse\nDans les années 1980, l''Union soviétique se dote elle aussi d''un centre de commandement volant destiné à survivre à une guerre nucléaire, dans un rôle comparable à celui de l''**E-4B** américain. Iliouchine part de l''avion de ligne **Il-86** et le transforme si profondément qu''il en fait un autre avion, l''**Il-80**, aussi désigné **Il-86VKP**. Le premier aurait volé à l''été 1985 depuis l''aéroport de Pridatcha, à Voronej ; le premier vol après modification a lieu le 5 mars 1987, et les livraisons commencent la même année.\n\n## Conception\nL''Il-80 n''a plus aucun hublot en dehors du poste de pilotage : il s''agit de protéger l''intérieur du souffle et de l''impulsion électromagnétique d''une explosion nucléaire. Des trois portes d''embarquement de l''avion de ligne, une seule subsiste, et un curieux déflecteur obture les vitres arrière du poste. Deux nacelles de 9,5 m de long, montées à l''intérieur des moteurs, abritent des génératrices électriques. Comme sur l''E-4B, un carénage dorsal loge les communications par satellite, et une **antenne filaire traînante** sortie de l''arrière du fuselage permet d''émettre en très basse fréquence, sans doute vers les sous-marins lanceurs d''engins.\n\n## Carrière opérationnelle\nLes quatre appareils convertis, immatriculés CCCP-86146 à 86149, rejoignent la 8e division d''aviation à missions spéciales sur la base de Tchkalovski, au nord-est de Moscou. Ils ne sont photographiés par des observateurs occidentaux qu''en 1992 ; l''OTAN leur donne le nom de code **Maxdome**. En 2011, trois restent en service sous des immatriculations civiles et dans la livrée d''Aeroflot, tandis que le premier, privé de ses moteurs, semble retiré. Rarement vus en vol, ils sont au cœur d''un fait divers en décembre 2020 : du matériel radio est volé à bord de l''un d''eux pendant une maintenance.\n\n## Place dans l''histoire\nL''Il-80 est la réponse soviétique, puis russe, à la doctrine américaine de continuité du gouvernement : un poste de commandement présidentiel qui ne dépend d''aucun bunker. Sous sa livrée de compagnie aérienne, rarement vu en vol, il est l''un des appareils les plus discrets de la flotte russe. Un successeur bâti sur l''**Il-96-400M** doit le remplacer.',
    E'## Genesis\nIn the 1980s the Soviet Union also acquired a flying command centre meant to survive a nuclear war, in a role comparable to that of the American **E-4B**. Ilyushin started from the **Il-86** airliner and modified it so deeply that it became another aircraft, the **Il-80**, also designated **Il-86VKP**. The first is believed to have flown in summer 1985 from Pridacha airport in Voronezh; the first post-modification flight took place on 5 March 1987, and deliveries began the same year.\n\n## Design\nThe Il-80 has no windows at all apart from the cockpit: the aim is to protect the interior from the blast and electromagnetic pulse of a nuclear explosion. Of the airliner''s three boarding doors only one remains, and an unusual baffle blocks the rear cockpit windows. Two 9.5 m pods, mounted inboard of the engines, house electrical generators. As on the E-4B, a dorsal fairing holds satellite communications, and a **trailing wire antenna** deployed from the rear fuselage allows very low frequency transmissions, probably to ballistic missile submarines.\n\n## Operational career\nThe four converted aircraft, registered CCCP-86146 to 86149, joined the 8th Special Purpose Aviation Division at Chkalovsky air base, north-east of Moscow. They were first photographed by Western observers only in 1992; NATO gave them the reporting name **Maxdome**. In 2011 three remained in service under civil registrations and in Aeroflot livery, while the first, stripped of its engines, appeared to be withdrawn. Rarely seen flying, they made the news in December 2020 when radio equipment was stolen from one of them during maintenance.\n\n## Place in history\nThe Il-80 is the Soviet, then Russian, answer to the American doctrine of continuity of government: a presidential command post that depends on no bunker. In its airline livery and rarely seen flying, it is one of the most discreet aircraft in the Russian fleet. A successor built on the **Il-96-400M** is due to replace it.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '1987-03-05',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-80'), (SELECT id FROM tech WHERE name = 'Antenne filaire traînante')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-80'), (SELECT id FROM tech WHERE name = 'Durcissement contre l''impulsion électromagnétique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-80'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-80'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = NULL,
  engine_count      = NULL,
  engine_type       = NULL,
  engine_type_en    = NULL,
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Il-80 (Il-86VKP)** : quatre Il-86 convertis, immatriculés CCCP-86146 à 86149, puis RA- sous immatriculation civile\n- **Cellule sans hublots** hors poste de pilotage, une seule porte d''embarquement au lieu de trois\n- **Nacelles de génératrices** de 9,5 m montées à l''intérieur des moteurs\n- **Carénage dorsal** de communications par satellite et antenne filaire traînante VLF',
  variants_en       = E'- **Il-80 (Il-86VKP)**: four converted Il-86s, registered CCCP-86146 to 86149, later RA- civil registrations\n- **Windowless airframe** apart from the cockpit, one boarding door instead of three\n- **Generator pods** 9.5 m long mounted inboard of the engines\n- **Dorsal fairing** for satellite communications and a VLF trailing wire antenna',

  -- Strate 4 : qualitatif
  nickname          = 'Maxdome',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-80',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-80',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Vitaly V. Kuzmin',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Iliouchine Il-80';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-80';
