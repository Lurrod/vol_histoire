-- Boeing–Saab T-7A Red Hawk
--
-- Photo : A T-7A Red Hawk takes off from Joint Base San Antonio-Randolph, Texas, May 15, 2026.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:A_T-7A_Red_Hawk_takes_off_from_Joint_Base_San_Antonio-Randolph,_Texas,_May_15,_2026.jpg

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
    'Boeing T-7 Red Hawk',
    'Boeing T-7 Red Hawk',
    'Boeing–Saab T-7A Red Hawk',
    'Boeing–Saab T-7A Red Hawk',
    'Le successeur du T-38, conçu avec Saab pour former aux chasseurs de cinquième génération',
    'The T-38’s successor, designed with Saab to train pilots for fifth-generation fighters',
    '/assets/airplanes/t7a-red-hawk.jpg',
    E'## Genèse\nLe **T-38 Talon** forme les pilotes de chasse américains depuis 1961. L''US Air Force commence à définir son remplaçant dès 2003, mais les arbitrages budgétaires repoussent sans cesse le programme **T-X**. Boeing s''associe au suédois **Saab** et choisit une méthode peu courante : construire sur fonds propres deux prototypes avant même l''ouverture de l''appel d''offres. Le premier vole le 20 décembre 2016.\n\n## Conception\nUn seul réacteur **General Electric F404** à postcombustion, celui du F/A-18 Hornet, qui fournit à lui seul trois fois la poussée totale des deux moteurs du Talon. Double dérive, places en tandem étagées, voilure dessinée pour les fortes incidences et les facteurs de charge élevés : l''appareil doit préparer à piloter des chasseurs de cinquième génération. Saab fabrique la section arrière du fuselage. Le programme se veut la vitrine de la **conception numérique** : trente-six mois du dessin au premier vol, trente minutes pour raccorder l''arrière à la voilure.\n\n## Carrière opérationnelle\nEn septembre 2018, Boeing remporte le T-X — 351 avions et 46 simulateurs pour 9,2 milliards de dollars — face au **M-346** de Leonardo et au **T-50** coréen. Le nom de Red Hawk, donné en 2019, rend hommage aux aviateurs noirs de **Tuskegee**, qui peignaient en rouge la queue de leurs chasseurs. Saab ouvre en 2019 une usine à West Lafayette, dans l''Indiana, pour la section arrière. Logiciels, systèmes de sécurité, essais : les retards s''accumulent. Un premier T-7 rejoint l''escadre d''entraînement de Randolph, au Texas, en décembre 2025 ; la capacité opérationnelle initiale est attendue en 2027.\n\n## Place dans l''histoire\nL''appareil n''est pas encore en service et doit déjà durer un demi-siècle. Sa tâche est d''autant plus pressante que, comme le rappelle la fiche du **T-38**, chaque année de retard oblige à prolonger des cellules conçues à la fin des années 1950. Boeing le propose aussi à l''exportation et en version armée d''entraînement tactique.',
    E'## Genesis\nThe **T-38 Talon** has trained American fighter pilots since 1961. The US Air Force began defining its replacement as early as 2003, but budget decisions kept pushing the **T-X** programme back. Boeing teamed up with Sweden''s **Saab** and chose an unusual method: build two prototypes with its own money before the competition had even opened. The first flew on 20 December 2016.\n\n## Design\nA single afterburning **General Electric F404**, the engine of the F/A-18 Hornet, which on its own delivers three times the combined thrust of the Talon''s two engines. Twin fins, stepped tandem seats, a wing drawn for high angles of attack and high load factors: the aircraft has to prepare pilots for fifth-generation fighters. Saab builds the aft fuselage section. The programme set out to showcase **digital engineering**: thirty-six months from drawing board to first flight, thirty minutes to join the aft section to the wing.\n\n## Operational career\nIn September 2018 Boeing won T-X — 351 aircraft and 46 simulators for 9.2 billion dollars — against Leonardo''s **M-346** and the Korean **T-50**. The name Red Hawk, given in 2019, honours the Black airmen of **Tuskegee**, who painted the tails of their fighters red. In 2019 Saab opened a plant at West Lafayette, Indiana, for the aft section. Software, safety systems, testing: the delays piled up. A first T-7 joined the training wing at Randolph, Texas, in December 2025; initial operational capability is expected in 2027.\n\n## Place in history\nThe aircraft is not yet in service and must already last half a century. The task is all the more pressing because, as the **T-38** entry recalls, every year of delay means extending airframes designed in the late 1950s once again. Boeing is also offering it for export and as an armed tactical trainer.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2013-12-01',
    '2016-12-20',
    NULL,
    NULL,
    1835.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing T-7 Red Hawk'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric F404')),
((SELECT id FROM airplanes WHERE name = 'Boeing T-7 Red Hawk'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Boeing T-7 Red Hawk'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing T-7 Red Hawk'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.3,
  wingspan          = 9.32,
  height            = 4.11,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = 15240,
  climb_rate        = NULL,
  g_limit_pos       = 8.0,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F404-GE-103',
  engine_count      = 1,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2021,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **BTX-1** : deux prototypes construits sur fonds propres, premier vol le 20 décembre 2016\n- **T-7A Red Hawk** : version de série de l''US Air Force, 351 avions commandés en 2018\n- **T-7B / T-7 UJTS** : versions proposées à l''US Navy ; Boeing s''est retiré de la seconde compétition en 2026\n- **F/T-7X / F-7** : versions armées d''entraînement tactique et de combat léger, à l''étude\n- Section arrière du fuselage fabriquée par **Saab**, d''abord en Suède puis dans l''Indiana',
  variants_en       = E'- **BTX-1** : two prototypes built with company money, first flight on 20 December 2016\n- **T-7A Red Hawk** : US Air Force production version, 351 aircraft ordered in 2018\n- **T-7B / T-7 UJTS** : versions offered to the US Navy; Boeing withdrew from the second competition in 2026\n- **F/T-7X / F-7** : armed tactical-trainer and light-combat versions under study\n- Aft fuselage built by **Saab**, first in Sweden and then in Indiana',

  -- Strate 4 : qualitatif
  nickname          = 'Red Hawk',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_T-7_Red_Hawk',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing–Saab_T-7_Red_Hawk',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Boeing T-7 Red Hawk';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing T-7 Red Hawk';
