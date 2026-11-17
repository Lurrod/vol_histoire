-- Soko J-20 Kraguj
--
-- Photo : J-20 Kraguj YU-JRV 30151 - Ečka - 11.jpg
--   licence CC BY-SA 4.0 — Srđan Popović
--   https://commons.wikimedia.org/wiki/File:J-20_Kraguj_YU-JRV_30151_-_Ečka_-_11.jpg

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
    'Soko J-20 Kraguj',
    'Soko J-20 Kraguj',
    'Soko J-20 Kraguj',
    'Soko J-20 Kraguj',
    'Avion d''appui léger yougoslave conçu pour continuer la guerre depuis des terrains de fortune, en « avion de partisans »',
    'Yugoslav light support aircraft designed to fight on from makeshift strips as a "partisan aircraft"',
    '/assets/airplanes/soko-j20-kraguj.jpg',
    E'## Genèse\nLes planificateurs militaires yougoslaves tirent de la Seconde Guerre mondiale une leçon simple : un agresseur commencera par neutraliser les aérodromes. Ils imaginent donc un avion capable de survivre à la destruction de l''aviation régulière, pour donner aux groupes de résistance et de guérilla une capacité limitée de reconnaissance et de frappe. Conçu par l''Institut technique militaire (VTI) et fabriqué par **SOKO**, le **J-20 Kraguj** (« l''épervier ») est surnommé « avion de partisans ». Il vole pour la première fois le 21 novembre 1962.\n\n## Conception\nLe Kraguj est un monoplace à aile basse légèrement effilée et à structure métallique semi-monocoque, aussi simple que possible. Son train fixe à roulette de queue, amorti par des blocs de caoutchouc, lui permet d''opérer depuis de courtes pistes sommaires, notamment en montagne, et il peut recevoir des skis. Un moteur à plat **Lycoming GSO-480** de 340 ch entraîne une hélice tripale métallique à pas variable ; deux éjecteurs spécialement dessinés renforcent son refroidissement. Le pilote dispose d''une verrière coulissante, d''un poste chauffé et ventilé et d''un pare-brise dégivré par air chaud.\n\n## Carrière opérationnelle\nL''armement fixe se limite à deux mitrailleuses Colt-Browning de 7,7 mm dans les ailes, avec 650 coups chacune. Sous les ailes, des adaptateurs permettent de passer des bombes à des paniers de douze roquettes de 57 mm, ou à des roquettes de 128 mm. Produit à 43 exemplaires de 1964 à 1977, le Kraguj sert à l''appui au sol mais aussi à l''entraînement, du vol à vue de jour et de nuit jusqu''à l''apprentissage de l''attaque au sol. Il quitte l''aviation yougoslave en 1989 ; on le retrouve ensuite dans les inventaires de l''armée de l''air croate et de celle de la Republika Srpska.\n\n## Place dans l''histoire\nLe Kraguj est la traduction aéronautique d''une doctrine nourrie par l''expérience des partisans : prévoir dès la conception que l''aviation devra survivre à sa propre défaite et continuer le combat depuis des prés ou des vallées. Loin de la course à la vitesse des chasseurs à réaction, il fait le pari inverse de la rusticité, de l''autonomie et des courtes distances de décollage. Des exemplaires préservés par des collectionneurs volent encore en meeting, aux couleurs yougoslaves.',
    E'## Genesis\nYugoslav military planners drew a simple lesson from the Second World War: an aggressor would begin by putting the airfields out of action. They therefore imagined an aircraft able to survive the destruction of the regular air force, to give resistance and guerrilla groups a limited reconnaissance and strike capability. Designed by the Military Technical Institute (VTI) and built by **SOKO**, the **J-20 Kraguj** ("sparrowhawk") was nicknamed the "partisan aircraft". It first flew on 21 November 1962.\n\n## Design\nThe Kraguj was a single-seater with a slightly tapered low wing and a semi-monocoque metal structure, kept as simple as possible. Its fixed tailwheel undercarriage, with rubber shock absorbers, allowed it to operate from short unprepared strips, especially in mountains, and it could be fitted with skis. A 340 hp **Lycoming GSO-480** flat engine drove a three-bladed metal variable-pitch propeller; two specially designed ejectors improved its cooling. The pilot had a sliding canopy, a heated and ventilated cockpit and a windscreen de-iced by hot air.\n\n## Operational career\nFixed armament was limited to two 7.7 mm Colt-Browning machine guns in the wings, with 650 rounds each. Under the wings, adapters allowed a switch from bombs to pods of twelve 57 mm rockets, or to 128 mm rockets. Built in 43 examples from 1964 to 1977, the Kraguj was used for ground support but also for training, from visual day and night flying to ground-attack instruction. It left the Yugoslav Air Force in 1989; it later appeared in the inventories of the Croatian Air Force and the Republika Srpska Air Force.\n\n## Place in history\nThe Kraguj is the aeronautical translation of a doctrine shaped by the partisan experience: planning from the outset that the air force would have to survive its own defeat and carry on fighting from meadows and valleys. Far from the race for speed of jet fighters, it made the opposite bet on ruggedness, autonomy and short take-off distances. Examples preserved by collectors still fly at air shows, in Yugoslav colours.',
    (SELECT id FROM countries WHERE code = 'YUG'),
    NULL,
    '1962-11-21',
    '1964-01-01',
    295,
    800,
    (SELECT id FROM manufacturer WHERE code = 'SOKO'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko J-20 Kraguj'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Soko J-20 Kraguj'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Soko J-20 Kraguj'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.93,
  wingspan          = 10.64,
  height            = 3.0,
  wing_area         = 17.0,
  empty_weight      = 1130,
  mtow              = 1624,
  service_ceiling   = NULL,
  climb_rate        = 8.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming GSO-480-B1A6 (340 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1964,
  production_end    = 1977,
  units_built       = 43,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **J-20 Kraguj** : monoplace d''appui au sol, de lutte anti-guérilla et de reconnaissance, 43 exemplaires\n- **Configuration bombes** : bombes de 100 kg sous voilure\n- **Configuration roquettes** : paniers de douze roquettes de 57 mm ou roquettes de 128 mm\n- **Version d''entraînement** : emploi pour le vol à vue de jour et de nuit et l''apprentissage de l''attaque au sol',
  variants_en       = E'- **J-20 Kraguj**: single-seat ground support, counter-insurgency and reconnaissance aircraft, 43 built\n- **Bomb configuration**: 100 kg bombs under the wings\n- **Rocket configuration**: pods of twelve 57 mm rockets or 128 mm rockets\n- **Training use**: visual day and night flying and ground-attack instruction',

  -- Strate 4 : qualitatif
  nickname          = 'Kraguj',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soko_J-20_Kraguj',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Soko_J-20_Kraguj',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Srđan Popović',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Soko J-20 Kraguj';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Soko J-20 Kraguj';
