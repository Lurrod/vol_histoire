-- Northrop F-15A Reporter (RF-61C)
--
-- Photo : NorthropF15tanker (4418610921).jpg
--   licence CC BY-SA 2.0 — Bill Larkins
--   https://commons.wikimedia.org/wiki/File:NorthropF15tanker_(4418610921).jpg

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
    'Northrop F-15 Reporter',
    'Northrop F-15 Reporter',
    'Northrop F-15A Reporter (RF-61C)',
    'Northrop F-15A Reporter (RF-61C)',
    'Black Widow désarmé et doté d''un nez à caméras, dernier avion photo à pistons de l''USAF et cartographe de la Corée',
    'A disarmed Black Widow with a camera nose, the USAF''s last piston photo aircraft and the mapmaker of Korea',
    '/assets/airplanes/f15-reporter.jpg',
    E'## Genèse\nÀ la fin de la Seconde Guerre mondiale, l''armée de l''air américaine attend un avion de reconnaissance photographique à long rayon d''action, mais le **Hughes XF-11** de **Howard Hughes** accumule les difficultés. **Northrop** propose une voie plus simple : dériver son chasseur de nuit **P-61 Black Widow**. Le premier **XP-61E**, dernière version de chasse du P-61, n''a pas six mois de vol quand il retourne à l''atelier : on lui retire ses armes et on lui greffe un nez capable d''abriter des caméras. Rebaptisé XF-15, il vole le 3 juillet 1945 aux mains du pilote d''essai **L. A. « Slim » Parrett**.\n\n## Conception\nLe Reporter reprend les ailes, les moteurs et l''empennage du P-61C, mais avec une nacelle centrale nouvelle et plus fine, où pilote et opérateur photo sont assis en tandem sous une verrière continue. Six caméras occupent le long nez. Deux moteurs en étoile **Pratt & Whitney R-2800** turbocompressés de 2 100 ch lui donnent 708 km/h vers 10 000 m. Les essais montrent des performances comparables à celles du XF-11, obtenues avec des moteurs moins puissants et des pièces existantes : le Reporter met fin au projet de Hughes. Dès juin 1945, avant même le premier vol, 175 exemplaires sont commandés.\n\n## Carrière opérationnelle\nLe premier F-15A de série est accepté en septembre 1946, mais le contrat est brutalement annulé en 1947, l''avion à hélices étant déjà dépassé : 36 seulement sont construits, tous à partir de cellules commandées comme P-61C. Neuf restent aux États-Unis ; les autres rejoignent à partir de mars 1947 le 8th Photographic Reconnaissance Squadron au **Japon**. Redésignés RF-61C en 1948, ils photographient la péninsule coréenne : leurs clichés fournissent l''essentiel des cartes aériennes de la **Corée du Nord** utilisées au début de la guerre de Corée, jusqu''à l''arrivée des F7F-3P des Marines à la fin de 1950. Les avions passent ensuite au 82d Tactical Reconnaissance Squadron, dissous le 1er avril 1949.\n\n## Place dans l''histoire\nDernier avion de reconnaissance photographique à moteurs à pistons conçu pour l''US Air Force, le Reporter connaît une carrière brève mais une longue seconde vie. Le premier exemplaire de série sert au laboratoire Ames de la **NACA** jusqu''en 1953, larguant à haute altitude des maquettes d''ailes en flèche. Vendu, il fait de la photographie aérienne au Mexique, puis devient bombardier d''eau en Californie sous l''immatriculation N9768Z, avec une citerne de 6 056 litres. Il s''écrase au décollage le 6 septembre 1968 près de Hollister : c''était le dernier appareil de toute la lignée P-61 encore en état de vol.',
    E'## Genesis\nAt the end of the Second World War the US Army Air Forces needed a long-range photographic reconnaissance aircraft, but **Howard Hughes**''s **XF-11** was mired in difficulties. **Northrop** offered a simpler route: derive one from its **P-61 Black Widow** night fighter. With less than six months'' flying time, the first **XP-61E**, the last fighter version of the P-61, went back to the shop, where its guns were removed and a new nose able to hold cameras was fitted. Redesignated XF-15, it flew on 3 July 1945 with Northrop test pilot **L. A. "Slim" Parrett** at the controls.\n\n## Design\nThe Reporter used the wings, engines and tail of the P-61C but an entirely new, more streamlined central nacelle, with pilot and camera operator seated in tandem under a continuous canopy. Six cameras filled the long nose. Two turbosupercharged **Pratt & Whitney R-2800** radials of 2,100 hp gave it 708 km/h at around 10,000 m. Testing showed performance similar to the XF-11''s, achieved with less powerful engines and existing parts: the Reporter ended Hughes''s project. In June 1945, even before the first flight, 175 were ordered.\n\n## Operational career\nThe first production F-15A was accepted in September 1946, but the contract was abruptly cancelled in 1947 as piston aircraft were being overshadowed by jets: only 36 were built, all from airframes ordered as P-61Cs. Nine stayed in the United States; the rest joined the 8th Photographic Reconnaissance Squadron in **Japan** from March 1947. Redesignated RF-61C in 1948, they photographed the Korean Peninsula, and their pictures provided most of the aerial maps of **North Korea** used at the start of the Korean War, until Marine F7F-3Ps arrived in late 1950. The aircraft later passed to the 82d Tactical Reconnaissance Squadron, inactivated on 1 April 1949.\n\n## Place in history\nThe last piston-engined photo-reconnaissance aircraft designed for the US Air Force, the Reporter had a short career but a long afterlife. The first production aircraft served with **NACA**''s Ames laboratory until 1953, dropping scale models of swept-wing designs from high altitude. Sold off, it flew aerial survey work in Mexico, then became a fire bomber in California as N9768Z, with a 6,056-litre tank. It crashed on take-off near Hollister on 6 September 1968: it was the last airworthy member of the entire P-61 line.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-06-01',
    '1945-07-03',
    '1947-03-01',
    708,
    6400,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop F-15 Reporter'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Northrop F-15 Reporter'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop F-15 Reporter'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Northrop F-15 Reporter'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop F-15 Reporter'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.31,
  wingspan          = 20.12,
  height            = 2.79,
  wing_area         = 61.7,
  empty_weight      = NULL,
  mtow              = 14580,
  service_ceiling   = 10670,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-73 Double Wasp (2 100 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1946,
  production_end    = 1947,
  units_built       = 36,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XF-15** : premier prototype, converti du premier XP-61E, premier vol le 3 juillet 1945\n- **XF-15A** : second prototype, converti d''un P-61C, moteurs R-2800-C turbocompressés, premier vol le 17 octobre 1945\n- **F-15A Reporter** : version de série, 36 exemplaires, six caméras dans le nez\n- **F-15A-5-NO** : derniers exemplaires, installation de caméras interne revue\n- **RF-61C** : désignation de l''US Air Force à partir de 1948',
  variants_en       = E'- **XF-15**: first prototype, converted from the first XP-61E, first flown on 3 July 1945\n- **XF-15A**: second prototype, converted from a P-61C, turbosupercharged R-2800-C engines, first flown on 17 October 1945\n- **F-15A Reporter**: production version, 36 built, six cameras in the nose\n- **F-15A-5-NO**: final aircraft, revised internal camera installation\n- **RF-61C**: US Air Force designation from 1948',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_F-15_Reporter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_F-15_Reporter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bill Larkins',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Northrop F-15 Reporter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Northrop F-15 Reporter';
