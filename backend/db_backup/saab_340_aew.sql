-- Saab 340 AEW&C (S 100 Argus)
--
-- Photo : Saab 340 Argus VBY.jpg
--   licence CC BY-SA 4.0 — Bene Riobó
--   https://commons.wikimedia.org/wiki/File:Saab_340_Argus_VBY.jpg

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
    'Saab 340 AEW&C',
    'Saab 340 AEW&C',
    'Saab 340 AEW&C (S 100 Argus)',
    'Saab 340 AEW&C (S 100 Argus)',
    'Une « planche » radar sur un avion régional : l’alerte avancée à la portée des pays moyens',
    'A radar “plank” on a regional airliner: early warning within reach of mid-sized air forces',
    '/assets/airplanes/saab-340-aew.jpg',
    E'## Genèse\nDans les années 1980, la Suède cherche une alerte avancée aéroportée à la mesure de son budget : pas d''AWACS lourd sur quadriréacteur, mais un radar porté par un petit avion économique, capable d''opérer depuis des pistes courtes. **Ericsson** développe pour cela l''**Erieye**, et l''armée de l''air retient comme porteur le **Saab 340**, un biturbopropulseur régional d''une trentaine de places.\n\n## Conception\nL''Erieye (PS-890) est une antenne active montée en « planche » sur le dos du fuselage. Elle ne tourne pas : ses deux faces balayent électroniquement chaque côté de l''avion, en laissant des secteurs aveugles réduits vers l''avant et l''arrière. À 6 100 m d''altitude, elle détecte avions, navires et missiles jusqu''à 300 à 400 km. Le reste de la cellule est celui du Saab 340B, avec deux turbopropulseurs **General Electric CT7-9B** de 1 390 kW et un équipage de six personnes.\n\n## Carrière opérationnelle\nLe premier Saab 340 équipé de l''Erieye vole en 1994 ; l''appareil entre en service en 1997 dans l''armée de l''air suédoise sous la désignation **S 100B Argus**, puis est modernisé en S 100D. Il est exporté en Thaïlande avec les Gripen, deux appareils sont acquis par la Pologne, et la Suède annonce en mai 2024 le don de deux exemplaires à l''**Ukraine**. Partout, il sert à étendre la couverture radar au-delà de l''horizon des stations au sol et à guider la chasse.\n\n## Place dans l''histoire\nLe Saab 340 AEW&C a démontré qu''une alerte avancée efficace n''exigeait pas un quadriréacteur. L''Erieye est ensuite monté sur le Saab 2000, sur l''**Embraer E-99** brésilien, puis, sous une forme bien plus puissante, sur le **Saab GlobalEye**, que la Suède commande en juin 2022 pour le remplacer. Il a ouvert aux forces aériennes moyennes un outil jusque-là réservé aux grandes puissances.',
    E'## Genesis\nIn the 1980s Sweden looked for an airborne early warning capability matching its budget: no heavy four-jet AWACS, but a radar carried by a small, economical aircraft able to operate from short runways. **Ericsson** developed the **Erieye** for the purpose, and the air force chose the **Saab 340**, a thirty-odd-seat regional twin turboprop, to carry it.\n\n## Design\nThe Erieye (PS-890) is an active array mounted as a "plank" on top of the fuselage. It does not rotate: its two faces scan each side of the aircraft electronically, leaving small blind sectors fore and aft. At 6,100 m it detects aircraft, ships and missiles out to 300 to 400 km. The rest of the airframe is that of the Saab 340B, with two **General Electric CT7-9B** turboprops of 1,390 kW and a crew of six.\n\n## Operational career\nThe first Erieye-equipped Saab 340 flew in 1994; the type entered Swedish Air Force service in 1997 as the **S 100B Argus**, later upgraded to S 100D. It was exported to Thailand alongside the Gripen, two aircraft were acquired by Poland, and in May 2024 Sweden announced the donation of two to **Ukraine**. Everywhere it extends radar coverage beyond the horizon of ground stations and directs fighters.\n\n## Place in history\nThe Saab 340 AEW&C proved that effective early warning did not require a four-engined jet. The Erieye was later fitted to the Saab 2000, to Brazil''s **Embraer E-99** and, in a far more powerful form, to the **Saab GlobalEye**, which Sweden ordered in June 2022 to replace it. It opened to mid-sized air forces a tool previously reserved for the great powers.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    NULL,
    '1994-01-01',
    '1997-01-01',
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 340 AEW&C'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Saab 340 AEW&C'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Saab 340 AEW&C'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 340 AEW&C'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Saab 340 AEW&C'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.57,
  wingspan          = 21.44,
  height            = 6.97,
  wing_area         = 41.81,
  empty_weight      = 10300,
  mtow              = 13155,
  service_ceiling   = 7620,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CT7-9B',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1994,
  production_end    = 1999,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **S 100B Argus** : désignation suédoise de la version d''origine, radar Erieye PS-890\n- **S 100D Argus (ASC 890)** : version suédoise modernisée, systèmes de mission revus\n- **Saab 2000 Erieye** : même radar sur le biturbopropulseur Saab 2000, exporté au Pakistan\n- Radar cousin sur l''**Embraer E-99** brésilien\n- Remplacé en Suède par le **Saab GlobalEye**, commandé en juin 2022',
  variants_en       = E'- **S 100B Argus** : Swedish designation of the original version, Erieye PS-890 radar\n- **S 100D Argus (ASC 890)** : upgraded Swedish version with revised mission systems\n- **Saab 2000 Erieye** : same radar on the Saab 2000 twin turboprop, exported to Pakistan\n- Related radar on Brazil''s **Embraer E-99**\n- Replaced in Sweden by the **Saab GlobalEye**, ordered in June 2022',

  -- Strate 4 : qualitatif
  nickname          = 'Argus',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Saab_340_AEW%26C',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saab_340_AEW%26C',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bene Riobó',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Saab 340 AEW&C';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saab 340 AEW&C';
