-- Lockheed YF-12A
--
-- Photo : YF-12 in flight 0.jpg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File:YF-12_in_flight_0.jpg

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
    'Lockheed YF-12',
    'Lockheed YF-12',
    'Lockheed YF-12A',
    'Lockheed YF-12A',
    'L''A-12 devenu intercepteur Mach 3 à radar et missiles, jamais commandé en série, puis laboratoire volant de la NASA',
    'The A-12 reborn as a Mach 3 missile interceptor, never put into production, then a NASA flying laboratory',
    '/assets/airplanes/yf12.jpg',
    E'## Genèse\nÀ la fin des années 1950, l''US Air Force cherche un successeur au **F-106 Delta Dart** et retient l''intercepteur Mach 3 **North American XF-108 Rapier**, annulé en septembre 1959. Au même moment, les **Skunk Works** de **Lockheed** construisent dans le secret l''avion de reconnaissance **A-12** pour la CIA. **Kelly Johnson** propose d''en tirer un intercepteur, l''AF-12, et l''US Air Force en commande trois en 1960 : ils prennent les places sept à neuf de la chaîne de l''A-12 et deviennent les YF-12A.\n\n## Conception\nLe nez de l''A-12 est modifié, ses bords d''attaque de fuselage raccourcis, pour loger l''énorme radar de conduite de tir **Hughes AN/ASG-18** prévu pour le XF-108, flanqué de deux détecteurs infrarouges. Un second poste accueille l''opérateur du système d''armes, et des dérives ventrales rétablissent la stabilité. Trois des quatre baies de l''A-12 reçoivent chacune un missile **AIM-47 Falcon**. Deux réacteurs **Pratt & Whitney J58** de 140 kN avec postcombustion le poussent au-delà de Mach 3.\n\n## Essais\nLe YF-12A vole le 7 août 1963 ; son existence est révélée par le président **Lyndon Johnson** le 24 février 1964, en partie pour couvrir l''A-12 encore secret. Le 1er mai 1965, il établit des records de vitesse, 3 331 km/h, et d''altitude, 24 462 m. Six tirs d''AIM-47 sur sept réussissent, le dernier depuis Mach 3,2 et 23 000 m sur un drone volant à 150 m du sol. Une commande de 93 F-12B suit en mai 1965, mais **Robert McNamara** en bloque le financement, guerre du Vietnam oblige, et le programme est clos en janvier 1968. La NASA reprend ensuite les avions : ses recherches sur les entrées d''air et le contrôle conjoint de la cellule et des moteurs augmentent de 7 % l''autonomie du **SR-71**.\n\n## Place dans l''histoire\nPlus grand, plus lourd et plus rapide intercepteur piloté du monde, le YF-12 n''a jamais servi en unité. Son héritage est ailleurs : l''AIM-47 grandit pour devenir l''**AIM-54 Phoenix** du F-14, et le radar AN/ASG-18 évolue en **AN/AWG-9**. Sur les trois exemplaires, l''un est détruit par un incendie en 1966 et sa moitié arrière sert à bâtir l''unique **SR-71C**, un autre est perdu en vol en 1971, le dernier est exposé à Dayton depuis novembre 1979.',
    E'## Genesis\nIn the late 1950s the US Air Force sought a successor to the **F-106 Delta Dart** and selected the Mach 3 **North American XF-108 Rapier** interceptor, cancelled in September 1959. At the same time **Lockheed**''s **Skunk Works** was secretly building the **A-12** reconnaissance aircraft for the CIA. **Kelly Johnson** proposed an interceptor version, the AF-12, and the US Air Force ordered three in 1960: they took the seventh to ninth slots on the A-12 line and became the YF-12As.\n\n## Design\nThe A-12''s nose was modified and its chines cut back to house the huge **Hughes AN/ASG-18** fire-control radar developed for the XF-108, flanked by two infrared sensors. A second cockpit took the weapon system operator, and ventral fins restored stability. Three of the A-12''s four equipment bays each carried an **AIM-47 Falcon** missile. Two 140 kN afterburning **Pratt & Whitney J58** engines drove it beyond Mach 3.\n\n## Testing\nThe YF-12A flew on 7 August 1963; its existence was revealed by President **Lyndon Johnson** on 24 February 1964, partly to cover the still-secret A-12. On 1 May 1965 it set speed and altitude records of 3,331 km/h and 24,462 m. Six of seven AIM-47 firings succeeded, the last from Mach 3.2 and 23,000 m against a drone flying 150 m above the ground. An order for 93 F-12Bs followed in May 1965, but **Robert McNamara** withheld the funding because of the cost of the Vietnam War, and the programme was ended in January 1968. NASA then took over the aircraft: its research on inlets and on integrated airframe and engine control increased the **SR-71**''s range by 7 per cent.\n\n## Place in history\nThe largest, heaviest and fastest crewed interceptor in the world, the YF-12 never served with a unit. Its legacy lies elsewhere: the AIM-47 grew into the **AIM-54 Phoenix** of the F-14, and the AN/ASG-18 radar evolved into the **AN/AWG-9**. Of the three aircraft, one was destroyed by fire in 1966 and its rear half was used to build the only **SR-71C**, another was lost in flight in 1971, and the last has been on display at Dayton since November 1979.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1960-01-01',
    '1963-08-07',
    NULL,
    3661,
    4800,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed YF-12'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Lockheed YF-12'), (SELECT id FROM tech WHERE name = 'Matériaux résistants à la chaleur')),
((SELECT id FROM airplanes WHERE name = 'Lockheed YF-12'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Lockheed YF-12'), (SELECT id FROM tech WHERE name = 'Conception aérodynamique pour haute altitude'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed YF-12'), (SELECT id FROM armement WHERE name = 'AIM-47 Falcon'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed YF-12'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Lockheed YF-12'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.97,
  wingspan          = 16.95,
  height            = 5.64,
  wing_area         = 167,
  empty_weight      = 27604,
  mtow              = 63504,
  service_ceiling   = 27400,
  climb_rate        = 60,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2222,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J58 (JTD11D-20A)',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 91.2,
  thrust_wet        = 140.1,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **YF-12A** : trois exemplaires de présérie (60-6934, 60-6935 et 60-6936) prélevés sur la chaîne de l''A-12\n- **F-12B** : version de série, rayon d''action porté à 2 500 km et radar amélioré ; 93 commandés en 1965, annulés en 1968\n- **YF-12C** : désignation fictive donnée au deuxième SR-71A (61-7951), prêté à la NASA de 1971 à 1978 pour garder le secret du SR-71\n- **SR-71C** : biplace d''instruction bâti avec la moitié arrière du 60-6934, endommagé sans remède en 1966',
  variants_en       = E'- **YF-12A**: three pre-production aircraft (60-6934, 60-6935 and 60-6936) taken from the A-12 line\n- **F-12B**: production version, combat radius raised to 2,500 km and improved radar; 93 ordered in 1965, cancelled in 1968\n- **YF-12C**: fictitious designation given to the second SR-71A (61-7951), loaned to NASA from 1971 to 1978 to keep the SR-71 secret\n- **SR-71C**: training two-seater built with the rear half of 60-6934, damaged beyond repair in 1966',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_YF-12',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_YF-12',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed YF-12';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'Lockheed YF-12';
