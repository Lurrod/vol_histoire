-- Convair C-131 Samaritan
--
-- Photo : C-131F Samaritan VR-30 in flight.JPEG
--   licence Public domain — PH2 J.L. Berry, USN
--   https://commons.wikimedia.org/wiki/File:C-131F_Samaritan_VR-30_in_flight.JPEG

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
    'Convair C-131 Samaritan',
    'Convair C-131 Samaritan',
    'Convair C-131 Samaritan',
    'Convair C-131 Samaritan',
    'Le Convair-Liner en uniforme : évacuation sanitaire, école de navigateurs et banc d''essais volant',
    'The Convair-Liner in uniform: medevac, navigator school and flying testbed',
    '/assets/airplanes/c131-samaritan.jpg',
    E'## Genèse\nTout commence par une demande d''**American Airlines**, qui veut un avion de ligne pressurisé pour remplacer le DC-3. **Convair** dessine un bimoteur de 40 places, d''où son nom de CV-240 ; il vole le 16 mars 1947 et entre en service l''année suivante. L''US Air Force y voit un outil polyvalent. Elle en tire d''abord un avion-école, le **T-29**, livré à partir de 1950 pour former les navigateurs, puis, à partir de 1954, un transport baptisé **Samaritan**, nom qui dit sa vocation première : l''évacuation sanitaire.\n\n## Conception\nLe C-131 conserve le fuselage pressurisé de l''avion de ligne et ses deux moteurs en étoile : des **Pratt & Whitney R-2800 Double Wasp** de 2 500 ch. Il évolue avec les modèles civils : le C-131A dérive du CV-240 et emporte 39 passagers sur des sièges tournés vers l''arrière, ou 20 civières ; le C-131B, hybride des CV-240 et 340, offre 48 places ; le C-131D reprend le CV-340. La version école T-29 accueille dans sa cabine jusqu''à 14 élèves navigateurs. La Navy et les Marines reçoivent à partir de 1952 36 R4Y-1 de 44 places, devenus C-131F en 1962.\n\n## Carrière opérationnelle\nLe Samaritan assure transports sanitaires, liaisons d''état-major et logistique, tandis que des variantes spécialisées se multiplient : C-131E d''entraînement à la contre-mesure électronique pour le Strategic Air Command, appareils de poursuite de missiles, de cartographie ou de vérification des aides radio. En 1959, un C-131 est le premier avion utilisé en vol parabolique pour habituer à l''apesanteur les astronautes du **programme Mercury**. En 1963, le projet **Tailchaser** fait d''un C-131B le premier banc d''essais d''avion d''appui à tir latéral, armé d''une mitrailleuse rotative SUU-11A.\n\n## Place dans l''histoire\nL''Air Force s''en sépare à la fin des années 1970 au profit du **C-9 Nightingale**, les T-29 étant relayés par le T-43 dès 1974 ; les garde-côtes le gardent jusqu''en 1983, la Garde nationale et la Navy jusqu''en 1990. Il est l''un des derniers avions à moteurs en étoile du service américain. Le NC-131H, doté d''un second poste de pilotage dans un nez allongé, a servi de simulateur volant avant de rejoindre le musée de l''Air Force à Dayton. Avec 512 exemplaires, T-29 compris, il a formé des générations de navigateurs.',
    E'## Genesis\nIt all began with a request from **American Airlines**, which wanted a pressurised airliner to replace the DC-3. **Convair** designed a 40-seat twin, hence the name CV-240; it flew on 16 March 1947 and entered service the following year. The US Air Force saw it as a versatile tool. It first derived a trainer, the **T-29**, delivered from 1950 to train navigators, then, from 1954, a transport named **Samaritan**, a name that reflected its primary calling: medical evacuation.\n\n## Design\nThe C-131 kept the airliner''s pressurised fuselage and its two radial engines, 2,500 hp **Pratt & Whitney R-2800 Double Wasps**. It evolved with the civil models: the C-131A, derived from the CV-240, carried 39 passengers on rearward-facing seats, or 20 stretchers; the C-131B, a CV-240/340 hybrid, offered 48 seats; the C-131D was based on the CV-340. The T-29 trainer version seated up to 14 student navigators. From 1952 the Navy and Marines received 36 44-seat R4Y-1s, which became C-131Fs in 1962.\n\n## Operational career\nThe Samaritan flew medical evacuation, staff transport and logistics, while specialised variants multiplied: the C-131E electronic countermeasures trainer for Strategic Air Command, and aircraft for missile tracking, photo-mapping or radio aids checking. In 1959 a C-131 was the first aircraft used for parabolic flights to accustom **Project Mercury** astronauts to weightlessness. In 1963, project **Tailchaser** made a C-131B the first side-firing gunship testbed, armed with an SUU-11A rotary machine gun.\n\n## Place in history\nThe Air Force retired it in the late 1970s in favour of the **C-9 Nightingale**, its T-29s having been replaced by the T-43 from 1974; the Coast Guard kept it until 1983, the Air National Guard and the Navy until 1990. It was one of the last radial-engined aircraft in US service. The NC-131H, given a second cockpit in a lengthened nose, served as a flying simulator before joining the Air Force museum at Dayton. With 512 built, T-29s included, it trained generations of navigators.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1949-09-22',
    '1950-01-01',
    472,
    725,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair C-131 Samaritan'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair C-131 Samaritan'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Convair C-131 Samaritan'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 24.14,
  wingspan          = 32.11,
  height            = 8.59,
  wing_area         = 85.5,
  empty_weight      = 13294,
  mtow              = 21363,
  service_ceiling   = 7470,
  climb_rate        = 7.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-99 Double Wasp (2 500 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1956,
  units_built       = 512,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **T-29A / B / C / D** : avions-écoles de navigateurs, de radios et de bombardiers, 363 exemplaires au total\n- **C-131A** : transport sanitaire dérivé du CV-240, 26 exemplaires, dont 22 passés aux garde-côtes (HC-131A)\n- **C-131B et C-131D** : transports de 48 et 44 places, 36 et 33 exemplaires\n- **C-131E** : entraînement à la contre-mesure électronique pour le Strategic Air Command, 15 exemplaires\n- **R4Y-1 / C-131F** : version de la Navy et des Marines, 36 exemplaires\n- **NC-131H TIFS** : simulateur volant à second poste de pilotage dans un nez allongé',
  variants_en       = E'- **T-29A / B / C / D**: navigator, radio operator and bombardier trainers, 363 built in all\n- **C-131A**: medevac transport derived from the CV-240, 26 built, 22 of them passed to the Coast Guard (HC-131A)\n- **C-131B and C-131D**: 48- and 44-seat transports, 36 and 33 built\n- **C-131E**: electronic countermeasures trainer for Strategic Air Command, 15 built\n- **R4Y-1 / C-131F**: Navy and Marine Corps version, 36 built\n- **NC-131H TIFS**: flying simulator with a second cockpit in a lengthened nose',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_C-131_Samaritan',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_C-131_Samaritan',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'PH2 J.L. Berry, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Convair C-131 Samaritan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Convair C-131 Samaritan';
