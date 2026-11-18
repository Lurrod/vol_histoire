-- Boeing EC-135 Looking Glass
--
-- Photo : An air-to-air left side view of a 4th Airborne Command and Control Squadron EC-135 Stratolifter aircraft - DPLA - ce1c3bad5935b916e52f881739b9a635.jpg
--   licence Public domain — Department of Defense. American Forces Information Service. Defense Visual Information Center. 1994
--   https://commons.wikimedia.org/wiki/File:An_air-to-air_left_side_view_of_a_4th_Airborne_Command_and_Control_Squadron_EC-135_Stratolifter_aircraft_-_DPLA_-_ce1c3bad5935b916e52f881739b9a635.jpg

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
    'Boeing EC-135',
    'Boeing EC-135',
    'Boeing EC-135 Looking Glass',
    'Boeing EC-135 Looking Glass',
    'Poste de commandement volant du Strategic Air Command, resté en l''air jour et nuit pendant vingt-neuf ans',
    'Strategic Air Command''s flying command post, kept airborne day and night for twenty-nine years',
    '/assets/airplanes/boeing-ec135.jpg',
    E'## Genèse\nLa stratégie nucléaire américaine repose sur une exigence : pouvoir commander bombardiers et missiles même si les centres de commandement au sol ont été détruits. Le 3 février 1961, le **Strategic Air Command** lance l''opération **Looking Glass** avec cinq **EC-135A**, des ravitailleurs KC-135A convertis, basés à Offutt dans le Nebraska. Des EC-135C dédiés, d''anciens KC-135B, les relaient à partir de 1964. Le nom de la mission dit son principe : l''avion est le reflet, dans le ciel, du poste de commandement au sol.\n\n## Conception\nL''EC-135 n''est pas un avion mais une famille de cellules du **C-135 Stratolifter** remplies d''électronique, chaque lettre correspondant à une mission. Les EC-135A, C et G reçoivent l''**Airborne Launch Control System**, qui permet à des officiers embarqués de tirer les missiles **Minuteman** si leurs postes de tir sont détruits. Les EC-135L servent de relais radio, tandis que les huit EC-135N transformés pour le programme **Apollo** portent dans un nez bulbeux, le « Droop Snoot », une antenne parabolique orientable de 2,1 m destinée au suivi et à la télémesure.\n\n## Carrière opérationnelle\nPendant plus de 29 ans, un Looking Glass reste en l''air jour et nuit, cumulant plus de 281 000 heures de vol sans accident, jusqu''à la fin de l''alerte en vol permanente le 24 juillet 1990. D''autres EC-135 servent les grands commandements : **Silk Purse** en Europe, **Blue Eagle** dans le Pacifique, **Scope Light** dans l''Atlantique et **Nightwatch**, prêt à évacuer le président hors de Washington. Un EC-135L assure des relais radio pendant l''invasion du Panama puis la guerre du Golfe. Le 13 juin 1971, un EC-135N disparaît au sud d''Hawaï après avoir observé un essai nucléaire français, avec 24 personnes à bord.\n\n## Place dans l''histoire\nL''EC-135 a incarné pendant toute la **guerre froide** la permanence du commandement nucléaire américain. Ses successeurs reprennent ses missions une à une : le **Boeing E-4** remplace les EC-135J de Nightwatch dès 1974, puis l''**E-6 Mercury** de la Navy prend la relève de Looking Glass le 1er octobre 1998. Les derniers EC-135 quittent le service en 2000 ; le dernier ancien Looking Glass, converti en WC-135C, vole jusqu''en novembre 2020.',
    E'## Genesis\nAmerican nuclear strategy rested on one requirement: being able to command bombers and missiles even if the command centres on the ground had been destroyed. On 3 February 1961 **Strategic Air Command** launched **Operation Looking Glass** with five **EC-135As**, converted KC-135A tankers based at Offutt, Nebraska. Dedicated EC-135Cs, former KC-135Bs, took over from 1964. The mission''s name states its principle: the aircraft mirrors, in the sky, the command post on the ground.\n\n## Design\nThe EC-135 is not one aircraft but a family of **C-135 Stratolifter** airframes filled with electronics, each suffix letter matching a mission. The EC-135A, C and G received the **Airborne Launch Control System**, which let airborne officers fire **Minuteman** missiles if their launch centres were destroyed. The EC-135L served as radio relays, while the eight EC-135Ns converted for the **Apollo** programme carried a 2.1 m steerable dish for tracking and telemetry in a bulbous nose, the "Droop Snoot".\n\n## Operational career\nFor more than 29 years a Looking Glass aircraft stayed airborne day and night, logging more than 281,000 accident-free flying hours, until continuous airborne alert ended on 24 July 1990. Other EC-135s served the major commands: **Silk Purse** in Europe, **Blue Eagle** in the Pacific, **Scope Light** in the Atlantic and **Nightwatch**, ready to fly the president out of Washington. An EC-135L flew radio relay missions during the invasion of Panama and then the Gulf War. On 13 June 1971 an EC-135N vanished south of Hawaii after monitoring a French nuclear test, with 24 people aboard.\n\n## Place in history\nThroughout the **Cold War** the EC-135 embodied the permanence of American nuclear command. Its successors took over its missions one by one: the **Boeing E-4** replaced the Nightwatch EC-135Js in 1974, then the Navy''s **E-6 Mercury** took over Looking Glass on 1 October 1998. The last EC-135s left service in 2000; the last former Looking Glass airframe, converted into a WC-135C, flew until November 2020.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    NULL,
    '1961-02-03',
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing EC-135'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Boeing EC-135'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing EC-135'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Boeing EC-135'), (SELECT id FROM wars WHERE name = 'Invasion du Panama')),
((SELECT id FROM airplanes WHERE name = 'Boeing EC-135'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

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
  engine_count      = 4,
  engine_type       = NULL,
  engine_type_en    = NULL,
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **EC-135A** : KC-135A convertis, premiers Looking Glass de 1961 puis centres de lancement aéroportés des Minuteman\n- **EC-135C** : KC-135B redésignés le 1er janvier 1965, poste de commandement Looking Glass du SAC jusqu''en 1998\n- **EC-135H / J / P** : postes de commandement des théâtres (Silk Purse, Blue Eagle, Scope Light) et Nightwatch présidentiel\n- **EC-135L** : relais radio « Cover All » entre le poste de commandement et les centres de lancement\n- **EC-135N / E (ARIA)** : nez « Droop Snoot » abritant une antenne parabolique orientable, suivi des missions Apollo puis des essais de missiles\n- **EC-135Y** : NKC-135 reconfigurés pour le commandant de l''US Central Command de 1989 à 2003',
  variants_en       = E'- **EC-135A**: converted KC-135As, first Looking Glass aircraft in 1961, later airborne launch control centres for the Minuteman\n- **EC-135C**: KC-135Bs redesignated on 1 January 1965, SAC''s Looking Glass command post until 1998\n- **EC-135H / J / P**: theatre command posts (Silk Purse, Blue Eagle, Scope Light) and the presidential Nightwatch\n- **EC-135L**: "Cover All" radio relay between the command post and the launch centres\n- **EC-135N / E (ARIA)**: "Droop Snoot" nose housing a steerable dish, tracking for the Apollo missions and later for missile tests\n- **EC-135Y**: NKC-135s reconfigured for the commander of US Central Command from 1989 to 2003',

  -- Strate 4 : qualitatif
  nickname          = 'Looking Glass',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_EC-135',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_EC-135',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'TSgt Michael J. Haggerty, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Boeing EC-135';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing EC-135';
