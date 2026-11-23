-- North American T-2 Buckeye
--
-- Photo : T-2C Buckeye of VT-26 in flight over Gulf of Mexico 1989.JPEG
--   licence Public domain — PH1 (AC) Scott Allen, USN
--   https://commons.wikimedia.org/wiki/File:T-2C_Buckeye_of_VT-26_in_flight_over_Gulf_of_Mexico_1989.JPEG

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
    'T-2 Buckeye',
    'T-2 Buckeye',
    'North American T-2 Buckeye',
    'North American T-2 Buckeye',
    'L''avion d''école sur lequel l''aéronavale américaine a appris le réacteur et l''appontage pendant près d''un demi-siècle',
    'The trainer on which US naval aviators learned jets and carrier landings for nearly half a century',
    '/assets/airplanes/t2-buckeye.jpg',
    E'## Genèse\nAu début de 1956, l''**US Navy** cherche un avion d''école de base à réaction pour remplacer ses **T-28 Trojan** à moteur à pistons. Elle veut que ses élèves pilotes et officiers navigants découvrent le jet sur un appareil fait pour eux. **North American Aviation** répond avec un projet maison, le NA-241, qui remporte la compétition au milieu de l''année. Désigné **T2J-1**, puis T-2A en 1962, l''avion est baptisé **Buckeye**, l''arbre emblème de l''Ohio, État où il est construit, à l''usine de Columbus.\n\n## Conception\nPour réduire le coût du développement, North American puise dans ses propres modèles : l''aile droite, non repliable, reprend la structure du chasseur **FJ-1 Fury**, et les commandes de vol viennent du T-28C. Élève et instructeur sont assis en tandem sur des sièges éjectables Martin-Baker, la place arrière surélevée pour voir par-dessus l''élève, dans une cabine pressurisée et climatisée. Réservoirs fixes en bout d''aile, crosse d''appontage, lancement par catapulte : c''est un avion de porte-avions en réduction. Sa faible vitesse de décrochage le rend si indulgent qu''il sert à enseigner la sortie de vrille. Le premier exemplaire vole le 31 janvier 1958 ; au réacteur unique Westinghouse J34 du T-2A succèdent deux Pratt & Whitney J60 sur le **T-2B**, puis deux General Electric J85 sur le **T-2C**.\n\n## Carrière opérationnelle\nLe Buckeye entre en service en 1959 au groupe d''entraînement VT-7 de Meridian, dans le Mississippi, et remplace le T2V SeaStar. De la fin des années 1950 à 2004, pratiquement tous les pilotes à réaction et officiers navigants de l''aéronavale américaine passent par lui, jusqu''à leurs premiers appontages. La Grèce (40 T-2E) et le Venezuela (12 T-2D) l''achètent aussi. Après la guerre froide, l''arrivée du **T-45 Goshawk** réduit son rôle : il quitte la filière des pilotes d''attaque en 2004, puis celle des officiers navigants en 2008, après 49 ans de service.\n\n## Place dans l''histoire\nConstruit à 609 exemplaires jusqu''en décembre 1974, le T-2 a formé l''essentiel des équipages embarqués américains de la guerre froide. Il illustre une méthode : assembler un avion d''école à partir de pièces éprouvées plutôt que de partir d''une feuille blanche. L''armée de l''air grecque l''utilise toujours, et quelques exemplaires devenus civils, encore aux couleurs de la Navy, se montrent dans les meetings américains.',
    E'## Genesis\nIn early 1956 the **US Navy** sought a jet basic trainer to replace its piston-engined **T-28 Trojan**. It wanted its student pilots and flight officers to discover the jet on an aircraft built for them. **North American Aviation** answered with an in-house design, the NA-241, which won the competition in mid-year. Designated **T2J-1**, then T-2A in 1962, the aircraft was named **Buckeye**, after the state tree of Ohio, where it was built at the Columbus plant.\n\n## Design\nTo cut development costs, North American drew on its own designs: the unswept, non-folding wing used the structure of the **FJ-1 Fury** fighter, and the flight controls came from the T-28C. Student and instructor sat in tandem on Martin-Baker ejection seats, the rear seat raised so the instructor could see over the student, in a pressurised and air-conditioned cockpit. Fixed wingtip tanks, an arrester hook and catapult launching made it a carrier aircraft in miniature. Its low stall speed made it so forgiving that it was used to teach spin recovery. The first aircraft flew on 31 January 1958; the single Westinghouse J34 of the T-2A gave way to two Pratt & Whitney J60s on the **T-2B**, then two General Electric J85s on the **T-2C**.\n\n## Operational career\nThe Buckeye entered service in 1959 with training group VT-7 at Meridian, Mississippi, replacing the T2V SeaStar. From the late 1950s until 2004, virtually every US naval jet pilot and flight officer passed through it, up to their first carrier landings. Greece (40 T-2Es) and Venezuela (12 T-2Ds) also bought it. After the Cold War, the arrival of the **T-45 Goshawk** reduced its role: it left the strike pilot pipeline in 2004, then the flight officer pipeline in 2008, after 49 years of service.\n\n## Place in history\nBuilt to 609 aircraft until December 1974, the T-2 trained most of America''s Cold War carrier aircrew. It illustrates a method: assembling a trainer from proven parts rather than starting from a blank sheet. The Hellenic Air Force still uses it, and a few examples now in civilian hands, still in Navy markings, appear at American airshows.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1956-01-01',
    '1958-01-31',
    '1959-11-01',
    840,
    1683,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'T-2 Buckeye'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'T-2 Buckeye'), (SELECT id FROM tech WHERE name = 'Système de décollage et d''atterrissage sur porte-avions'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'T-2 Buckeye'), (SELECT id FROM armement WHERE name = 'FFAR Mighty Mouse'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'T-2 Buckeye'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.67,
  wingspan          = 11.62,
  height            = 4.51,
  wing_area         = 23.7,
  empty_weight      = 3681,
  mtow              = 5978,
  service_ceiling   = 12300,
  climb_rate        = 31,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J85-GE-4',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 13.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1958,
  production_end    = 1974,
  units_built       = 609,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **T-2A (T2J-1)** : première série, un seul réacteur Westinghouse J34, 217 exemplaires\n- **T-2B** : deux réacteurs Pratt & Whitney J60-P-6, 97 exemplaires\n- **T-2C** : version définitive de l''US Navy, deux General Electric J85-GE-4, 231 exemplaires\n- **T-2D et T-2E** : versions d''exportation pour le Venezuela (12) et la Grèce (40)\n- **DT-2B et DT-2C** : quelques appareils convertis en directeurs de drones',
  variants_en       = E'- **T-2A (T2J-1)**: first production model, single Westinghouse J34 engine, 217 built\n- **T-2B**: two Pratt & Whitney J60-P-6 engines, 97 built\n- **T-2C**: definitive US Navy version, two General Electric J85-GE-4 engines, 231 built\n- **T-2D and T-2E**: export versions for Venezuela (12) and Greece (40)\n- **DT-2B and DT-2C**: a few aircraft converted to drone directors',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_T-2_Buckeye',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_T-2_Buckeye',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'PH1 (AC) Scott Allen, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'T-2 Buckeye';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'T-2 Buckeye';
