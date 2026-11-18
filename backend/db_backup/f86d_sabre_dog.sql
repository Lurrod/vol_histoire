-- North American F-86D Sabre
--
-- Photo : North American F-86D-1s USAF in flight.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:North_American_F-86D-1s_USAF_in_flight.jpg

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
    'F-86D Sabre',
    'F-86D Sabre',
    'North American F-86D Sabre',
    'North American F-86D Sabre',
    'Intercepteur tous temps tiré du Sabre, monoplace à radar armé de roquettes et double recordman du monde de vitesse',
    'Radar-equipped, rocket-armed all-weather Sabre that twice set the world speed record',
    '/assets/airplanes/f86d-sabre-dog.jpg',
    E'## Genèse\nLe **F-86 Sabre** a été conçu comme chasseur de jour. Pour disposer d''un intercepteur tous temps, l''US Air Force fait développer par **North American Aviation**, à partir de mars 1949, une version profondément remaniée, premier avion conçu autour de la nouvelle roquette non guidée **FFAR Mighty Mouse** de 70 mm. D''abord désigné YF-95, le prototype non armé vole le 22 décembre 1949 aux mains du pilote d''essai **George Welch**. C''est le premier chasseur de nuit de l''US Air Force à n''avoir qu''un seul membre d''équipage et un seul moteur. Rebaptisé YF-86D avant la production, il ne partage pourtant qu''un quart de ses pièces avec le Sabre d''origine.\n\n## Conception\nLe fuselage est élargi et allongé, la verrière s''ouvre en coquille, les empennages grandissent et un radôme logé au-dessus de l''entrée d''air abrite le radar tous temps **AN/APG-36**. Le réacteur **General Electric J47** reçoit une postcombustion ; les derniers lots passent au J47-GE-33, plus puissant. Les mitrailleuses disparaissent au profit d''un plateau rétractable sous le fuselage qui déploie 24 roquettes Mk 4, jugées alors plus efficaces contre un bombardier que le tir au canon. Il est vite surnommé officieusement *Sabre Dog*.\n\n## Carrière opérationnelle\nLe 18 novembre 1952, le capitaine **J. Slade Nash** établit un record du monde de vitesse à 1 124,1 km/h au-dessus de la Salton Sea, à 38 m du sol ; le 16 juillet 1953, le lieutenant-colonel **William F. Barns** le porte à 1 151,8 km/h sur le même parcours. 2 504 F-86D sont construits, dont 981 sont ensuite modernisés au standard **F-86L**. Pour l''OTAN, le **F-86K** remplace les roquettes par quatre canons de 20 mm : 120 sortent des usines North American et 221 sont assemblés par **Fiat**. Après l''USAF et l''Air National Guard, qui le garde jusqu''en 1965, le Sabre Dog sert dans une quinzaine de forces aériennes, du Japon à la France ; la Yougoslavie en reçoit 130 et les utilise jusqu''en 1974, dont 32 convertis en avions de reconnaissance.\n\n## Place dans l''histoire\nLe F-86D illustre la défense aérienne des débuts de la **guerre froide** : un monoplace guidé par son radar, armé de roquettes destinées aux bombardiers. Il devient le premier chasseur tous temps de plusieurs aviations alliées, comme la Grèce, et le F-86K équipe les escadres françaises, italiennes, néerlandaises, norvégiennes et ouest-allemandes. Au total, 2 847 exemplaires des versions D, K et L sont construits, ce qui fait du Sabre Dog l''une des branches les plus fournies de la famille Sabre.',
    E'## Genesis\nThe **F-86 Sabre** had been designed as a day fighter. To obtain an all-weather interceptor, the US Air Force had **North American Aviation** develop a thoroughly reworked version from March 1949, the first aircraft designed around the new unguided 70 mm **FFAR Mighty Mouse** rocket. Initially designated YF-95, the unarmed prototype flew on 22 December 1949 with test pilot **George Welch** at the controls. It was the first US Air Force night fighter design with only a single crewman and a single engine. Redesignated YF-86D before production, it nonetheless shared only a quarter of its parts with the original Sabre.\n\n## Design\nThe fuselage was widened and lengthened, the canopy became a clamshell, the tail surfaces grew and a radome above the intake housed the **AN/APG-36** all-weather radar. The **General Electric J47** engine gained an afterburner; later batches switched to the more powerful J47-GE-33. The guns gave way to a retractable under-fuselage tray carrying 24 Mk 4 rockets, then considered more effective against a bomber than cannon fire. It soon became widely known, informally, as the *Sabre Dog*.\n\n## Operational career\nOn 18 November 1952 Captain **J. Slade Nash** set a world speed record of 1,124.1 km/h over the Salton Sea, just 38 m above the ground; on 16 July 1953 Lieutenant Colonel **William F. Barns** raised it to 1,151.8 km/h over the same course in another F-86D. A total of 2,504 F-86Ds were built, 981 of which were later upgraded to **F-86L** standard. For NATO, the **F-86K** replaced the rockets with four 20 mm cannon: 120 came from North American and 221 were assembled by **Fiat**. Besides the USAF and the Air National Guard, which kept it until 1965, the Sabre Dog served with some fifteen air forces from Japan to France; Yugoslavia received 130 and flew them until 1974, converting 32 into reconnaissance aircraft.\n\n## Place in history\nThe F-86D embodies early **Cold War** air defence: a radar-guided single-seater armed with rockets meant for bombers. It became the first all-weather fighter of several allied air forces, Greece among them, while the F-86K equipped French, Italian, Dutch, Norwegian and West German units. In all, 2,847 aircraft of the D, K and L versions were built, making the Sabre Dog one of the largest branches of the Sabre family.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1949-03-01',
    '1949-12-22',
    '1951-01-01',
    1151,
    531,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-86D Sabre'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-86D Sabre'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'F-86D Sabre'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-86D Sabre'), (SELECT id FROM armement WHERE name = 'FFAR Mighty Mouse'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-86D Sabre'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-86D Sabre'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-86D Sabre'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.27,
  wingspan          = 11.31,
  height            = 4.57,
  wing_area         = NULL,
  empty_weight      = 6132,
  mtow              = 9060,
  service_ceiling   = 15163,
  climb_rate        = 61.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J47-GE-17B',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 24.1,
  thrust_wet        = 33.4,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2847,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 16,
  variants          = E'- **YF-95A / YF-86D** : deux prototypes, premier vol le 22 décembre 1949\n- **F-86D** : version de série à 24 roquettes FFAR, 2 504 exemplaires (dont 406 commandés comme F-86G)\n- **F-86K** : version OTAN à quatre canons M24A1 de 20 mm et radar APG-37, 120 construits par North American et 221 assemblés par Fiat\n- **F-86L** : 981 F-86D modernisés (électronique, bords d''attaque et saumons allongés, moteur plus puissant)\n- **IF-86D** : 32 F-86D yougoslaves convertis en reconnaissance, trois caméras Kodak K-24 à la place des roquettes',
  variants_en       = E'- **YF-95A / YF-86D**: two prototypes, first flown on 22 December 1949\n- **F-86D**: production version with 24 FFAR rockets, 2,504 built (406 of them ordered as F-86Gs)\n- **F-86K**: NATO version with four 20 mm M24A1 cannon and APG-37 radar, 120 built by North American and 221 assembled by Fiat\n- **F-86L**: 981 F-86Ds upgraded (new electronics, extended leading edges and wingtips, uprated engine)\n- **IF-86D**: 32 Yugoslav F-86Ds converted for reconnaissance, with three Kodak K-24 cameras in place of the rockets',

  -- Strate 4 : qualitatif
  nickname          = 'Sabre Dog',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_F-86D_Sabre',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_F-86D_Sabre',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'F-86D Sabre';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-86D Sabre';
