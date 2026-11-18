-- North American FJ-2/-3 Fury
--
-- Photo : FJ-3M VF-111 in flight 1958.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:FJ-3M_VF-111_in_flight_1958.jpg

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
    'FJ-2/-3 Fury',
    'FJ-2/-3 Fury',
    'North American FJ-2/-3 Fury',
    'North American FJ-2/-3 Fury',
    'Le Sabre passé à la Marine : ailes repliables, canons de 20 mm et crosse d''appontage',
    'The Sabre goes to sea: folding wings, 20 mm cannon and an arrester hook',
    '/assets/airplanes/fj3-fury.jpg',
    E'## Genèse\nEn 1951, la guerre de Corée révèle que les chasseurs à aile droite de l''US Navy sont surclassés par le **MiG-15** à aile en flèche, alors que ses propres chasseurs à aile en flèche, **F9F Cougar**, **F7U Cutlass**, **F3H Demon** ou **F4D Skyray**, ne sont pas prêts. En mesure d''attente, le Bureau of Aeronautics commande une version navale directe du **F-86E Sabre** de l''US Air Force, le **FJ-2**. Le pari est risqué, le Sabre n''ayant jamais été pensé pour un porte-avions, mais les pilotes de la Navy ont remarqué qu''il se pose plus lentement que le F9F Panther. L''urgence est telle que 300 appareils, ramenés ensuite à 200, sont commandés avant même le premier vol.\n\n## Conception\nLe premier prototype, le XFJ-2B, vole le 27 décembre 1951 : c''est un F-86E dont les six mitrailleuses sont remplacées par quatre canons **Colt Mk 12** de 20 mm. Les FJ-2 de série reçoivent une crosse d''appontage, une jambe de train avant allongée pour cabrer l''avion au catapultage, une voie élargie, des ailes repliables et un empennage monobloc. Ces ajouts alourdissent l''avion d''environ 500 kg sans en faire un véritable avion embarqué : sa maniabilité à basse vitesse reste médiocre. Le **FJ-3**, commandé en mars 1952, adopte le **Wright J65**, version sous licence du Sapphire britannique, 28 % plus puissant que le J47.\n\n## Carrière opérationnelle\nRetardé par les besoins de F-86 en Corée, le FJ-2 n''arrive qu''en janvier 1954, au VMF-122 de l''US Marine Corps : la Navy, qui lui préfère le Cougar, laisse ses 200 exemplaires aux Marines, et il quitte la première ligne dès 1956. Le FJ-3 rejoint la flotte en mai 1955 et convainc davantage, malgré les pannes de graissage et les ruptures d''aubes de son réacteur. En 1956, un FJ-3 est le premier chasseur à apponter sur le super-porte-avions **USS Forrestal**, et la Navy équipe tous ses FJ-3 d''une perche de ravitaillement. 194 sont convertis en **FJ-3M** armés du missile **AIM-9 Sidewinder**, d''autres pilotent des missiles Regulus ou des drones-cibles.\n\n## Place dans l''histoire\nAvec 741 exemplaires, le Fury à aile en flèche a donné à l''aéronavale américaine le chasseur moderne qui lui manquait pendant la mise au point de ses propres modèles. Le FJ-2 a aussi servi à évaluer la première catapulte à vapeur d''un porte-avions américain. Il annonce surtout le **FJ-4**, refonte complète de la cellule, et rappelle qu''adapter un chasseur terrestre au pont d''envol n''est jamais une simple affaire de crosse. Il quitte le service en septembre 1962.',
    E'## Genesis\nIn 1951 the Korean War showed that the US Navy''s straight-wing fighters were outclassed by the swept-wing **MiG-15**, while its own swept-wing designs, the **F9F Cougar**, **F7U Cutlass**, **F3H Demon** and **F4D Skyray**, were not ready. As a stopgap, the Bureau of Aeronautics ordered a direct naval development of the Air Force''s **F-86E Sabre**, the **FJ-2**. It was a gamble, since the Sabre had never been designed for carriers, but Navy pilots had noticed that it landed more slowly than the F9F Panther. The urgency was such that 300 aircraft, later cut to 200, were ordered before the first flight.\n\n## Design\nThe first prototype, the XFJ-2B, flew on 27 December 1951: an F-86E whose six machine guns had been replaced by four 20 mm **Colt Mk 12** cannon. Production FJ-2s received an arrester hook, a longer nose leg to raise the nose for catapult launches, a wider track, folding wings and an all-moving tailplane. These additions added some 500 kg without making it a true carrier aircraft: its low-speed handling remained poor. The **FJ-3**, ordered in March 1952, adopted the **Wright J65**, a licence-built British Sapphire with 28 per cent more thrust than the J47.\n\n## Operational career\nDelayed by the demand for F-86s in Korea, the FJ-2 only reached VMF-122 of the US Marine Corps in January 1954: the Navy, preferring the Cougar, left all 200 to the Marines, and the type left front-line service as early as 1956. The FJ-3 joined the fleet in May 1955 and proved more convincing, despite lubrication failures and broken turbine blades in its engine. In 1956 an FJ-3 became the first fighter to land aboard the supercarrier **USS Forrestal**, and the Navy fitted all its FJ-3s with a refuelling probe. 194 were converted into **FJ-3M**s armed with the **AIM-9 Sidewinder** missile; others controlled Regulus missiles or target drones.\n\n## Place in history\nWith 741 built, the swept-wing Fury gave American naval aviation the modern fighter it lacked while its own designs matured. The FJ-2 was also used to evaluate the first steam catapult on a US carrier. Above all it led to the **FJ-4**, a complete redesign of the airframe, and showed that adapting a land-based fighter to the flight deck is never just a matter of adding a hook. It left service in September 1962.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1951-01-01',
    '1951-12-27',
    '1954-01-01',
    1086,
    1380,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'FJ-2/-3 Fury'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'FJ-2/-3 Fury'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'FJ-2/-3 Fury'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'FJ-2/-3 Fury'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'FJ-2/-3 Fury'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'FJ-2/-3 Fury'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'FJ-2/-3 Fury'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'FJ-2/-3 Fury'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.46,
  wingspan          = 11.32,
  height            = 4.14,
  wing_area         = 26.8,
  empty_weight      = 5353,
  mtow              = 8523,
  service_ceiling   = 14300,
  climb_rate        = 36.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J47-GE-2',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 26.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1952,
  production_end    = NULL,
  units_built       = 741,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XFJ-2 / XFJ-2B** : trois prototypes, dont un armé de quatre canons de 20 mm\n- **FJ-2** : version à réacteur J47-GE-2 et ailes repliables, 200 exemplaires livrés aux Marines\n- **FJ-3** : réacteur Wright J65, aile « 6-3 » à partir de 1955, 538 exemplaires\n- **FJ-3M** : 194 FJ-3 modifiés pour tirer l''AIM-9 Sidewinder\n- **FJ-3D / FJ-3D2** : conversions de guidage pour missiles Regulus et drones-cibles',
  variants_en       = E'- **XFJ-2 / XFJ-2B**: three prototypes, one armed with four 20 mm cannon\n- **FJ-2**: J47-GE-2 version with folding wings, 200 delivered to the Marines\n- **FJ-3**: Wright J65 engine, "6-3" wing from 1955, 538 built\n- **FJ-3M**: 194 FJ-3s modified to fire the AIM-9 Sidewinder\n- **FJ-3D / FJ-3D2**: control conversions for Regulus missiles and target drones',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_FJ-2/-3_Fury',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_FJ-2/-3_Fury',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'FJ-2/-3 Fury';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'FJ-2/-3 Fury';
