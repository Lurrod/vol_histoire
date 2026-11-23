-- North American AJ (A-2) Savage
--
-- Photo : AJ-2P VAP-61 in flight near Guam.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:AJ-2P_VAP-61_in_flight_near_Guam.jpg

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
    'North American AJ Savage',
    'North American AJ Savage',
    'North American AJ (A-2) Savage',
    'North American AJ (A-2) Savage',
    'Deux moteurs à pistons et un réacteur pour emporter la bombe atomique depuis un porte-avions',
    'Two piston engines and a jet to carry the atomic bomb from an aircraft carrier',
    '/assets/airplanes/aj-savage.jpg',
    E'## Genèse\nLe 13 août 1945, l''US Navy lance un concours pour un bombardier embarqué capable d''emporter une bombe de 4,5 t, remporté par **North American Aviation**. La même année, elle décide qu''il devra pouvoir délivrer l''arme atomique, en l''occurrence la bombe Mark 4. Trois prototypes XAJ-1 sont commandés le 24 juin 1946. En attendant, la Marine improvise : des **P-2 Neptune** décollent de porte-avions à l''aide de fusées d''appoint avec une copie de la bombe Little Boy, mais ne peuvent pas apponter et doivent amerrir ou rejoindre une base amie après leur mission.\n\n## Conception\nPour emporter 5,4 t de bombes, le Savage devient l''avion le plus lourd jamais conçu pour opérer depuis un porte-avions. Ce monoplan à aile haute et train tricycle associe deux moteurs en étoile **Pratt & Whitney R-2800** à un turboréacteur **Allison J33** logé dans l''arrière du fuselage. Le réacteur ne sert qu''au décollage et pour la pointe de vitesse près de l''objectif ; son entrée d''air dorsale reste fermée le reste du temps, et il brûle la même essence que les moteurs à pistons. Les ailes et la dérive se replient pour le rangement à bord. En dehors de sa charge offensive, l''avion n''emporte aucun armement.\n\n## Carrière opérationnelle\nLe premier XAJ-1 vole le 3 juillet 1948 ; le VC-5 reçoit ses premiers Savage en septembre 1949. Encombrant, peu fiable, l''avion n''est guère apprécié à bord, ses ailes devant être repliées une à une à la pompe hydraulique. Les escadrons déployés à Port-Lyautey, au Maroc, s''entraînent à frapper le bloc soviétique depuis la Méditerranée orientale, en traversant à basse altitude la Bulgarie et la Roumanie. En juillet 1953, deux AJ-1 sont détachés sur la base coréenne de K-3 comme moyen de dissuasion nucléaire pendant la **guerre de Corée**, tandis que les AJ-2P photographient la Chine et la Corée du Nord depuis les Philippines. Convertis en ravitailleurs, des Savage ravitaillent le Crusader de **John Glenn** lors du record transcontinental de juillet 1957.\n\n## Place dans l''histoire\nConstruit à 143 exemplaires, prototypes compris, le Savage est remplacé à partir de 1957 par le **A-3 Skywarrior**, à réaction, dans les escadrons d''attaque lourde, et quitte le service en 1960. Il a donné à l''US Navy sa première capacité de frappe nucléaire embarquée, au moment où elle craignait de voir l''US Air Force monopoliser la bombe. Sa carrière se prolonge ensuite à la NASA, qui en fait un simulateur d''apesanteur, puis comme bombardier d''eau et enfin, jusqu''en 1984, comme banc d''essais du réacteur Lycoming YF102.',
    E'## Genesis\nOn 13 August 1945 the US Navy launched a competition for a carrier-based bomber able to carry a 4.5-tonne bomb, which **North American Aviation** won. The same year it decided that the aircraft must be able to deliver the atomic bomb, specifically the Mark 4. Three XAJ-1 prototypes were ordered on 24 June 1946. In the meantime the Navy improvised: **P-2 Neptunes** took off from carriers with rocket assistance carrying a copy of the Little Boy bomb, but could not land back on board and had to ditch or reach a friendly base after their mission.\n\n## Design\nTo carry 5.4 tonnes of bombs, the Savage became the heaviest aircraft yet designed to operate from a carrier. This high-wing monoplane with tricycle undercarriage combined two **Pratt & Whitney R-2800** radial engines with an **Allison J33** turbojet in the rear fuselage. The jet was used only for take-off and for a burst of speed near the target; its dorsal intake stayed closed the rest of the time, and it burned the same avgas as the piston engines. The wings and fin folded for stowage on board. Apart from its offensive load, the aircraft carried no armament.\n\n## Operational career\nThe first XAJ-1 flew on 3 July 1948, and VC-5 received its first Savages in September 1949. Bulky and unreliable, the aircraft was not popular on board, as its wings had to be folded one at a time with a portable hydraulic pump. Squadrons deployed to Port Lyautey in Morocco trained to strike the Soviet bloc from the eastern Mediterranean, flying low across Bulgaria and Romania. In July 1953 two AJ-1s were detached to the Korean base K-3 as a nuclear deterrent during the **Korean War**, while AJ-2Ps photographed China and North Korea from the Philippines. Converted to tankers, Savages refuelled **John Glenn**''s Crusader during his transcontinental record in July 1957.\n\n## Place in history\nBuilt in 143 examples including prototypes, the Savage was replaced from 1957 by the jet-powered **A-3 Skywarrior** in the heavy attack squadrons, and left service in 1960. It gave the US Navy its first carrier-based nuclear strike capability, at a time when the service feared the Air Force would monopolise the bomb. Its career then continued with NASA, which used it as a weightlessness simulator, then as a water bomber and finally, until 1984, as a testbed for the Lycoming YF102 engine.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-08-13',
    '1948-07-03',
    '1949-09-01',
    758,
    2786,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'North American AJ Savage'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'North American AJ Savage'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'North American AJ Savage'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'North American AJ Savage'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'North American AJ Savage'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'North American AJ Savage'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'North American AJ Savage'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.22,
  wingspan          = 21.76,
  height            = 6.25,
  wing_area         = 77.6,
  empty_weight      = 12500,
  mtow              = 23112,
  service_ceiling   = 12400,
  climb_rate        = 15,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = '2 Pratt & Whitney R-2800-44W Double Wasp (2 400 ch) + 1 Allison J33-A-10 (20 kN)',
  engine_count      = 3,
  engine_type       = 'Moteurs en étoile et turboréacteur',
  engine_type_en    = 'Radial engines and turbojet',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = NULL,
  units_built       = 143,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XAJ-1** : trois prototypes, dont deux perdus pendant les essais\n- **AJ-1 (A-2A)** : première version de série, moteurs R-2800-44W, 55 exemplaires\n- **AJ-2P** : reconnaissance photographique, nez à menton pour caméra oblique, dérive rehaussée, 30 exemplaires\n- **AJ-2 (A-2B)** : bombardier reprenant les modifications de l''AJ-2P, moteurs R-2800-48, 55 exemplaires\n- **Ravitailleurs** : tuyau et panier sortant de la soute, en service à partir de fin 1954',
  variants_en       = E'- **XAJ-1**: three prototypes, two of them lost during testing\n- **AJ-1 (A-2A)**: first production version, R-2800-44W engines, 55 built\n- **AJ-2P**: photo-reconnaissance version with a chin for an oblique camera and a taller fin, 30 built\n- **AJ-2 (A-2B)**: bomber incorporating the AJ-2P changes, R-2800-48 engines, 55 built\n- **Tankers**: hose and drogue extended from the bomb bay, in service from late 1954',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_A-2_Savage',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_AJ_Savage',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'North American AJ Savage';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'North American AJ Savage';
