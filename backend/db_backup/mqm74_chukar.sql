-- Northrop MQM-74 / BQM-74 Chukar
--
-- Photo : US Navy 080626-N-3560R-001 A drone is launched from the amphibious dock landing ship USS Tortuga (LSD 46) for a scheduled missile exercise.jpg
--   licence Public domain — U.S. Navy photo by Cmdr. James Ridgway
--   https://commons.wikimedia.org/wiki/File:US_Navy_080626-N-3560R-001_A_drone_is_launched_from_the_amphibious_dock_landing_ship_USS_Tortuga_(LSD_46)_for_a_scheduled_missile_exercise.jpg

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
    'Northrop BQM-74 Chukar',
    'Northrop BQM-74 Chukar',
    'Northrop MQM-74 / BQM-74 Chukar',
    'Northrop MQM-74 / BQM-74 Chukar',
    'Drone-cible de l''US Navy depuis 1968, devenu leurre au-dessus de Bagdad en 1991',
    'US Navy target drone since 1968, turned decoy over Baghdad in 1991',
    '/assets/airplanes/bqm74-chukar.jpg',
    E'## Genèse\nAu début des années 1960, l''**US Navy** réclame un nouveau drone-cible pour entraîner ses équipages au tir. **Northrop** répond par un prototype à aile delta, le **NV-105**, qui vole en 1964. La formule ne donne pas satisfaction : une aile droite la remplace sur le **NV-105A**, qui vole en 1965 et entre en production en 1968 sous la désignation **MQM-74A**. Le nom retenu, Chukar, est celui d''une perdrix asiatique introduite en Amérique pour la chasse : un clin d''œil pour un engin dont la raison d''être est de se faire tirer dessus.\n\n## Conception\nLe Chukar est un fuseau effilé de moins de 4 m, à ailes droites médianes, avec un petit réacteur suspendu sous le fuselage et un empennage en V inversé. Il décolle d''un lanceur à longueur nulle, à terre ou sur un navire, grâce à deux fusées d''appoint ; les versions récentes peuvent aussi être larguées par un avion porteur. Télécommandé, il redescend sous parachute à la fin de l''exercice, au besoin en mer grâce à un kit de flottaison. Pour le récupérer, les missiles tirés contre lui portent une tête de télémesure au lieu de leur charge : elle mesure la distance de passage et dit si une vraie tête l''aurait détruit.\n\n## Carrière opérationnelle\nL''US Navy achète 1 800 Chukar I ; l''OTAN, pour son champ de tir de Crète, la Royal Navy et la marine italienne en prennent plusieurs centaines. Le **MQM-74C Chukar II**, un peu plus grand et plus rapide, est construit à au moins 1 400 exemplaires et exporté de l''Allemagne de l''Ouest au Japon ; l''Inde l''emploie sous le nom de Chakor de 1978 à 1998. Vient ensuite le **BQM-74C Chukar III**, à pilote automatique programmable, construit à plus de 1 600 exemplaires. Dans la nuit du 17 janvier 1991, pendant la **guerre du Golfe**, 37 BQM-74C munis de réflecteurs radar sont lancés depuis l''Arabie saoudite et tournent jusqu''à vingt minutes au-dessus de Bagdad en se faisant passer pour des avions : les radars irakiens qui les cherchent sont aussitôt frappés par des missiles **AGM-88 HARM**.\n\n## Place dans l''histoire\nConçu pour être abattu, le Chukar a fini par servir d''appât dans une vraie guerre : l''opération **Scathe Mean** a contribué à briser une défense aérienne irakienne qui ne s''en est jamais remise. Sa lignée n''a pas cessé d''évoluer, avec le **BQM-74E**, plus endurant, puis le **BQM-74F** à ailes en flèche, dévoilé en 2005 et capable d''imiter avions et missiles de croisière. Le 16 novembre 2013, un BQM-74E qui devait virer à plus d''un mille du croiseur **USS Chancellorsville** l''a percuté, blessant légèrement deux marins : la cible était, cette fois, trop réaliste.',
    E'## Genesis\nIn the early 1960s the **US Navy** called for a new target drone to train its crews in gunnery and missile firing. **Northrop** answered with a delta-winged prototype, the **NV-105**, which flew in 1964. The delta did not work out: a straight wing replaced it on the **NV-105A**, which flew in 1965 and went into production in 1968 as the **MQM-74A**. The name Chukar is that of an Asian partridge introduced to America and hunted for sport: a fitting choice for a machine whose purpose in life is to be shot at.\n\n## Design\nThe Chukar is a tapered cigar of less than 4 m, with straight mid-mounted wings, a small jet engine slung under the fuselage and an inverted-vee tail. It takes off from a zero-length launcher, ashore or aboard ship, with two booster rockets; later versions can also be air-launched from a carrier aircraft. Remotely controlled, it comes down by parachute at the end of the exercise, at sea if need be thanks to a flotation kit. To recover it, missiles fired at it carry a telemetry warhead instead of explosives: it measures the miss distance and shows whether a real warhead would have destroyed the target.\n\n## Operational career\nThe US Navy bought 1,800 Chukar Is; NATO, for its range on Crete, the Royal Navy and the Italian Navy took several hundred more. The **MQM-74C Chukar II**, slightly larger and faster, was built in at least 1,400 examples and exported from West Germany to Japan; India flew it as the Chakor from 1978 to 1998. Then came the **BQM-74C Chukar III**, with a programmable autopilot, of which more than 1,600 were built. On the night of 17 January 1991, during the **Gulf War**, 37 BQM-74Cs fitted with radar reflectors were launched from Saudi Arabia and circled Baghdad for up to twenty minutes posing as aircraft: the Iraqi radars that probed for them were promptly hit by **AGM-88 HARM** missiles.\n\n## Place in history\nBuilt to be shot down, the Chukar ended up as bait in a real war: Operation **Scathe Mean** helped break an Iraqi air defence that never recovered. The line kept evolving, with the longer-ranged **BQM-74E** and then the swept-wing **BQM-74F**, unveiled in 2005 and able to imitate aircraft and cruise missiles. On 16 November 2013 a BQM-74E that should have turned away more than a mile from the cruiser **USS Chancellorsville** flew straight into her, slightly injuring two sailors: this time the target was too realistic.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1965-01-01',
    '1968-01-01',
    972,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'En service',
    'In service'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop BQM-74 Chukar'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop BQM-74 Chukar'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 3.94,
  wingspan          = 1.76,
  height            = 0.71,
  wing_area         = NULL,
  empty_weight      = 123,
  mtow              = 249,
  service_ceiling   = 12000,
  climb_rate        = NULL,
  g_limit_pos       = 6,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Williams J400-WR-404',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 1.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1968,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **MQM-74A Chukar I** : version initiale à réacteur WR24-6, 1 800 exemplaires pour l''US Navy\n- **XBQM-108** : démonstrateur expérimental à décollage vertical sur la queue, abandonné en essais captifs\n- **MQM-74C Chukar II** : version agrandie de 950 km/h, au moins 1 400 exemplaires, exportée (Chakor en Inde)\n- **BQM-74C Chukar III** : fuselage cylindrique, pilote automatique programmable, lancement aérien, plus de 1 600 exemplaires\n- **BQM-74E** : réacteur J400-WR-404 de série, autonomie accrue d''un tiers\n- **BQM-74F** : ailes en flèche et Mach 0,93, dévoilé en 2005',
  variants_en       = E'- **MQM-74A Chukar I**: initial version with WR24-6 engine, 1,800 built for the US Navy\n- **XBQM-108**: experimental tail-sitting vertical take-off demonstrator, cancelled during tethered tests\n- **MQM-74C Chukar II**: enlarged 950 km/h version, at least 1,400 built, exported (Chakor in India)\n- **BQM-74C Chukar III**: cylindrical fuselage, programmable autopilot, air launch, more than 1,600 built\n- **BQM-74E**: J400-WR-404 engine as standard, a third more range and endurance\n- **BQM-74F**: swept wings and Mach 0.93, unveiled in 2005',

  -- Strate 4 : qualitatif
  nickname          = 'Chukar',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/BQM-74_Chukar',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_BQM-74_Chukar',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Cmdr. James Ridgway, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Northrop BQM-74 Chukar';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Northrop BQM-74 Chukar';
