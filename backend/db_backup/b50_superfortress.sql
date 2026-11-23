-- Boeing B-50 Superfortress
--
-- Photo : Boeing B-50D-95-BO 050421-F-1234P-006.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Boeing_B-50D-95-BO_050421-F-1234P-006.jpg

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
    'B-50 Superfortress',
    'B-50 Superfortress',
    'Boeing B-50 Superfortress',
    'Boeing B-50 Superfortress',
    'Le B-29 remotorisé et rebaptisé pour survivre aux coupes budgétaires, porteur de la bombe jusqu''en 1955',
    'The re-engined, renamed B-29 that survived the budget cuts and carried the bomb until 1955',
    '/assets/airplanes/b50-superfortress.jpg',
    E'## Genèse\nDès 1944, Boeing cherche à débarrasser le **B-29** de ses Wright R-3350 peu fiables au profit du **Pratt & Whitney R-4360 Wasp Major**, un moteur en étoile à 28 cylindres. Un B-29 d''essai, le XB-44, vole ainsi en mai 1945, et 200 B-29D sont commandés en juillet. La capitulation japonaise fait tomber la commande à 60 en décembre 1945, et l''avion devient le B-50. Selon **Peter M. Bowers**, ce changement de nom fut une ruse pour obtenir des crédits : sous l''appellation B-29D, l''appareil n''aurait semblé qu''une version d''un bombardier dont on annulait les commandes par milliers.\n\n## Conception\nL''aile, taillée dans un nouvel alliage 75-S, est à la fois plus solide et plus légère ; le train renforcé autorise des masses bien supérieures à celles du B-29. Une dérive agrandie, repliable pour entrer dans les hangars, compense le surcroît de puissance, et une roulette de nez orientable facilite le roulage. L''armement défensif compte 13 mitrailleuses de 12,7 mm réparties en cinq tourelles, pour 9 t de bombes en soute. Le premier B-50A vole le 25 juin 1947, sans prototype. Pour atteindre l''URSS, la flotte est équipée pour le ravitaillement en vol, d''abord par tuyau, puis par perche rigide sur le B-50D. Ses nacelles redessinées lui valent le surnom d''« Andy Gump », un personnage de bande dessinée sans menton.\n\n## Carrière opérationnelle\nLivrés à partir de juin 1948 au 43rd Bombardment Wing, les B-50 ont pour mission de larguer la bombe atomique. Du 26 février au 2 mars 1949, le B-50A **Lucky Lady II** boucle le premier tour du monde sans escale : 94 heures et 37 743 km, avec quatre ravitaillements en vol. Les RB-50 espionnent la périphérie soviétique jusqu''à ce que le MiG-15 rende ces vols trop dangereux, et les RB-50E photographient la Corée du Nord pendant la **guerre de Corée**. Remplacé par le **B-47 Stratojet**, le dernier bombardier quitte le Strategic Air Command en 1955, mais les ravitailleurs KB-50 servent encore au-dessus de l''Indochine au début de la **guerre du Vietnam**.\n\n## Place dans l''histoire\nConstruit à 370 exemplaires de 1947 à 1953, le B-50 fut le dernier bombardier à moteurs à pistons livré par Boeing à l''US Air Force. Bombardier intérimaire en attendant les jets, il resta près de vingt ans en service sous d''autres formes : ravitailleur, avion de reconnaissance, chasseur d''ouragans WB-50 qui surveilla la météo de Cuba pendant la crise des missiles. Les derniers furent retirés en mars 1965, après la découverte de fatigue et de corrosion dans l''épave d''un KB-50J.',
    E'## Genesis\nAs early as 1944, Boeing sought to rid the **B-29** of its unreliable Wright R-3350s in favour of the **Pratt & Whitney R-4360 Wasp Major**, a 28-cylinder radial engine. A trials B-29, the XB-44, flew in May 1945, and 200 B-29Ds were ordered in July. The Japanese surrender cut the order to 60 in December 1945, and the aircraft became the B-50. According to **Peter M. Bowers**, the new designation was a ruse to win funding: as the B-29D it would have looked like a mere version of a bomber whose orders were being cancelled by the thousand.\n\n## Design\nThe wing, made of a new 75-S alloy, was both stronger and lighter; the strengthened undercarriage allowed far higher weights than the B-29. An enlarged fin, which folded to fit inside hangars, coped with the extra power, and a steerable nosewheel eased taxiing. Defensive armament comprised thirteen 12.7 mm machine guns in five turrets, with 9 tonnes of bombs in the bays. The first B-50A flew on 25 June 1947, without a prototype. To reach the USSR, the fleet was equipped for in-flight refuelling, first with a looped hose and then with a flying boom on the B-50D. Its redesigned nacelles earned it the nickname **Andy Gump**, after a chinless comic-strip character.\n\n## Operational career\nDelivered from June 1948 to the 43rd Bombardment Wing, the B-50s were tasked with dropping the atomic bomb. Between 26 February and 2 March 1949, the B-50A **Lucky Lady II** made the first non-stop flight around the world: 94 hours and 37,743 km, with four in-flight refuellings. RB-50s probed the Soviet periphery until the MiG-15 made such flights too dangerous, and RB-50Es photographed North Korea during the **Korean War**. Replaced by the **B-47 Stratojet**, the last bomber left Strategic Air Command in 1955, but KB-50 tankers were still flying over Indochina in the early years of the **Vietnam War**.\n\n## Place in history\nBuilt in 370 examples between 1947 and 1953, the B-50 was the last piston-engined bomber Boeing delivered to the US Air Force. An interim bomber pending the jets, it stayed in service for nearly twenty years in other guises: tanker, reconnaissance aircraft, and WB-50 hurricane hunter that monitored the weather over Cuba during the missile crisis. The last were retired in March 1965, after fatigue and corrosion were found in the wreckage of a KB-50J.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-01-01',
    '1947-06-25',
    '1948-06-01',
    634,
    12470,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-50 Superfortress'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'B-50 Superfortress'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'B-50 Superfortress'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-50 Superfortress'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-50 Superfortress'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'B-50 Superfortress'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'B-50 Superfortress'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'B-50 Superfortress'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'B-50 Superfortress'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'B-50 Superfortress'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.18,
  wingspan          = 43.05,
  height            = 9.96,
  wing_area         = 160,
  empty_weight      = 38426,
  mtow              = 78471,
  service_ceiling   = 11200,
  climb_rate        = 11,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 10,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-4360-35 Wasp Major (3 500 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 1953,
  units_built       = 370,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **B-50A** : première version de série, ravitaillement en vol par tuyau, 79 exemplaires\n- **B-50D** : version définitive, réceptacle pour perche rigide, réservoirs sous les ailes, nez d''une seule pièce, 222 exemplaires\n- **RB-50E / F / G** : reconnaissance photographique, cartographie SHORAN et renseignement électronique\n- **KB-50J** : ravitailleur à trois points, deux réacteurs J47 ajoutés sous les ailes, 112 conversions\n- **WB-50D** : reconnaissance météorologique et prélèvements atmosphériques, en remplacement des WB-29',
  variants_en       = E'- **B-50A**: first production version, looped-hose in-flight refuelling, 79 built\n- **B-50D**: definitive version, flying-boom receptacle, underwing tanks, one-piece nose, 222 built\n- **RB-50E / F / G**: photographic reconnaissance, SHORAN mapping and electronic intelligence\n- **KB-50J**: three-point tanker with two J47 jets added under the wings, 112 conversions\n- **WB-50D**: weather reconnaissance and atmospheric sampling, replacing the WB-29',

  -- Strate 4 : qualitatif
  nickname          = 'Andy Gump',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_B-50_Superfortress',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_B-50_Superfortress',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'B-50 Superfortress';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'B-50 Superfortress';
