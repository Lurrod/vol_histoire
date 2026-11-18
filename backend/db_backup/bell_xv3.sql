-- Bell XV-3
--
-- Photo : ARC-1960-AC-26438.jpg
--   licence Public domain — NASA Ames Research Center
--   https://commons.wikimedia.org/wiki/File:ARC-1960-AC-26438.jpg

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
    'Bell XV-3',
    'Bell XV-3',
    'Bell XV-3',
    'Bell XV-3',
    'Premier convertible à rotors basculants en bout d''aile, ancêtre direct du XV-15 et du V-22 Osprey',
    'The first convertiplane with tilting wingtip rotors, direct ancestor of the XV-15 and the V-22 Osprey',
    '/assets/airplanes/bell-xv3.jpg',
    E'## Genèse\nEn 1951, l''**US Army** et l''**US Air Force** lancent le **Convertible Aircraft Program** : elles cherchent un appareil qui décolle et se pose comme un hélicoptère, puis vole aussi vite qu''un avion. En octobre 1953, **Bell Helicopter** obtient un contrat pour deux exemplaires d''essai, d''abord désignés XH-33, comme des hélicoptères, puis XV-3 dans la série des convertibles. Les ingénieurs **Bob Lichten** et **Kenneth Wernicke** en arrêtent la formule : un rotor basculant à chaque bout d''aile. Le premier exemplaire vole le 11 août 1955 aux mains de **Floyd Carlson**, chef pilote d''essai de Bell.\n\n## Conception\nLe XV-3 garde un fuselage d''hélicoptère, avec un moteur en étoile **Pratt & Whitney R-985 Wasp Junior** de 450 ch installé dans la cellule. Des arbres de transmission portent sa puissance jusqu''aux deux rotors de 7,62 m placés en bout d''aile, qui pivotent de 90 degrés : verticaux pour le vol stationnaire, ils basculent vers l''avant pour servir d''hélices. Le premier exemplaire a des rotors tripales, le second des rotors bipales. Les essais en soufflerie imposent ensuite un rotor de diamètre réduit, une aile renforcée et des commandes de rotor plus rigides.\n\n## Essais\nL''instabilité dynamique des rotors domine le programme. Le 25 octobre 1956, le premier XV-3 s''écrase : son pilote, **Dick Stansbury**, grièvement blessé, a perdu connaissance sous des vibrations extrêmes, mâts inclinés de 17 degrés vers l''avant. Le second, passé par la soufflerie d''Ames de la NACA, vole dès le 21 janvier 1958. Le 18 décembre 1958, **Bill Quinlan** réussit la première conversion complète et stable en mode avion ; le 6 janvier 1959, le capitaine **Robert Ferry** est le premier pilote militaire à l''imiter. Évalué à Edwards de mai à juillet 1959, puis par la NASA jusqu''en juillet 1962, l''appareil totalise 250 vols, 125 heures et 110 conversions. Le 20 mai 1966, une rupture en bout d''aile lors d''un dernier essai en soufflerie le met hors d''usage.\n\n## Place dans l''histoire\nLimité dans ses performances, le XV-3 a pourtant démontré le rotor basculant, formule applicable malgré ses défauts selon le rapport d''évaluation militaire cosigné par Ferry. En avril 1966, l''aérodynamicien de Bell **Earl Hall** tire de ses données l''explication du « pylon whirl », l''instabilité qui avait miné tout le programme. Cette expérience est au cœur du **Bell XV-15**, qui ouvre à son tour la voie au **V-22 Osprey**. Retrouvé en 1984 par l''équipe du XV-15, restauré par Bell avec d''anciens ingénieurs du programme, il est exposé depuis 2007 au musée national de l''US Air Force, à Dayton.',
    E'## Genesis\nIn 1951 the **US Army** and the **US Air Force** launched the **Convertible Aircraft Program**: they wanted an aircraft that would take off and land like a helicopter, then fly as fast as an aeroplane. In October 1953 **Bell Helicopter** won a contract for two test aircraft, first designated XH-33, as helicopters, then XV-3 in the convertiplane series. Engineers **Bob Lichten** and **Kenneth Wernicke** settled the layout: a tilting rotor at each wingtip. The first aircraft flew on 11 August 1955 with Bell chief test pilot **Floyd Carlson** at the controls.\n\n## Design\nThe XV-3 kept a helicopter-like fuselage, with a 450 hp **Pratt & Whitney R-985 Wasp Junior** radial engine inside the airframe. Driveshafts carried its power out to two 7.62 m rotors at the wingtips, which tilted through 90 degrees: vertical for the hover, they swung forward to pull the aircraft like propellers. The first aircraft had three-bladed rotors, the second two-bladed ones. Wind tunnel testing then led to a smaller rotor diameter, a strengthened wing and stiffer rotor controls.\n\n## Testing\nDynamic rotor instability dominated the programme. On 25 October 1956 the first XV-3 crashed: its pilot, **Dick Stansbury**, seriously injured, had blacked out under extreme vibration with the masts tilted 17 degrees forward. The second aircraft, after tests in the wind tunnel of the NACA''s Ames laboratory, flew from 21 January 1958. On 18 December 1958 **Bill Quinlan** made the first dynamically stable full conversion to aeroplane mode; on 6 January 1959 Captain **Robert Ferry** became the first military pilot to do so. Evaluated at Edwards from May to July 1959, then by NASA until July 1962, the aircraft logged 250 flights, 125 hours and 110 conversions. On 20 May 1966 a wingtip failure during a final wind tunnel test put it out of action.\n\n## Place in history\nLimited in performance, the XV-3 nonetheless proved the tiltrotor: despite its deficiencies, concluded the military evaluation report co-written by Ferry, the concept was practical. In April 1966 Bell aerodynamicist **Earl Hall** used its data to explain pylon whirl, the instability that had dogged the whole programme. That experience was central to the **Bell XV-15**, which in turn paved the way for the **V-22 Osprey**. Found in 1984 by the XV-15 team and restored by Bell with former programme engineers, it has been on display since 2007 at the National Museum of the US Air Force in Dayton.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1953-10-01',
    '1955-08-11',
    NULL,
    296,
    410,
    (SELECT id FROM manufacturer WHERE code = 'BEL'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell XV-3'), (SELECT id FROM tech WHERE name = 'Rotors basculants')),
((SELECT id FROM airplanes WHERE name = 'Bell XV-3'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell XV-3'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.25,
  wingspan          = 9.55,
  height            = 4.04,
  wing_area         = 10.8,
  empty_weight      = 865,
  mtow              = 1006,
  service_ceiling   = 4572,
  climb_rate        = 6.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-985-AN-1 Wasp Junior (450 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Bell 200** : désignation du constructeur\n- **XH-33** : désignation militaire d''origine, qui classait l''appareil parmi les hélicoptères\n- **XV-3 54-147** : premier exemplaire, rotors tripales, détruit le 25 octobre 1956\n- **XV-3 54-148** : second exemplaire, rotors bipales, auteur des 110 conversions ; exposé à Dayton\n- **XV-3A** : désignation prise en 1962, quand le préfixe V est réservé aux appareils à décollage vertical',
  variants_en       = E'- **Bell 200**: manufacturer''s designation\n- **XH-33**: original military designation, which classed the aircraft as a helicopter\n- **XV-3 54-147**: first aircraft, three-bladed rotors, destroyed on 25 October 1956\n- **XV-3 54-148**: second aircraft, two-bladed rotors, which made the 110 conversions; displayed at Dayton\n- **XV-3A**: designation adopted in 1962, when the V prefix was reserved for vertical take-off aircraft',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bell_XV-3',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bell_XV-3',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA Ames Research Center',
  image_licence     = 'Public domain'
WHERE name = 'Bell XV-3';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bell XV-3';
