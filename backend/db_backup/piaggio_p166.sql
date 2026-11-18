-- Piaggio P.166 Portofino
--
-- Photo : P.166 DL3 Italian Coast Guard.JPG
--   licence CC BY-SA 2.5 — SCDBob
--   https://commons.wikimedia.org/wiki/File:P.166_DL3_Italian_Coast_Guard.JPG

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
    'Piaggio P.166',
    'Piaggio P.166',
    'Piaggio P.166 Portofino',
    'Piaggio P.166 Portofino',
    'Bimoteur à hélices propulsives né d''un amphibie, qui a patrouillé les côtes italiennes et sud-africaines',
    'A twin-pusher utility aircraft born from an amphibian, which patrolled the coasts of Italy and South Africa',
    '/assets/airplanes/piaggio-p166.jpg',
    E'## Genèse\nLa première production d''après-guerre de **Piaggio**, à Gênes, est un petit amphibie, le **P.136 Royal Gull**, à aile haute et moteurs à hélices propulsives, pour garder une garde au sol suffisante et une cabine plus confortable. Piaggio s''en sert de base pour un avion terrestre dont l''étude commence en 1955 : le **P.166**, qui garde l''aile et les moteurs du P.136 mais reçoit un fuselage et un empennage neufs. Le prototype décolle de Villanova d''Albenga le 26 novembre 1957. Plusieurs exemplaires partent comme avions d''affaires, de desserte régionale ou d''aérotaxi, jusqu''en Australie.\n\n## Conception\nLe P.166 conserve la formule de son ancêtre : une aile haute, deux moteurs en nacelles qui entraînent des hélices propulsives, une cabine de six à huit passagers derrière deux pilotes, facile à charger. Le **P.166B Portofino** de 1962, plus puissant, allonge le nez ; le **P.166C** de 1964 emporte douze passagers. Le **P.166D**, qui vole le 3 juillet 1976, passe aux turbopropulseurs **Lycoming LTP101** : dans sa version DL3, il atteint 400 km/h, monte à 8 500 m et franchit plus de 2 000 km avec ses réservoirs d''aile et de bout d''aile. Huit appareils de la Guardia di Finanza reçoivent plus tard des **Pratt & Whitney PT6A-121**.\n\n## Carrière opérationnelle\nL''**Aeronautica Militare** reçoit 49 **P.166M** de 1960 à 1968, puis des versions de photographie aérienne. En Afrique du Sud, le **P.166S Albatross**, au nez allongé et aux grands réservoirs de bout d''aile, assure la patrouille côtière et le sauvetage au sein du 27 Squadron : vingt sont construits. La Somalie achète en 1980 deux avions de transport et deux de patrouille maritime. Dans les années 1980 et 1990, la version **DL3/SEM**, pour la surveillance maritime et écologique, équipe les garde-côtes italiens, qui la retirent en juillet 2017, et la **Guardia di Finanza**, qui prévoyait de la garder jusqu''en 2020.\n\n## Place dans l''histoire\nAvec environ 154 exemplaires, le P.166 n''a jamais été un grand succès commercial, mais il a prouvé la polyvalence d''une formule née sur l''eau : transport, ambulance, école, photographie, patrouille. Pour l''Italie, il a été pendant près de trente ans l''œil des garde-côtes et de la police financière sur ses côtes. Les Albatross sud-africains, revendus à des particuliers, ont continué de voler après leur retrait : le 14 août 2011, deux d''entre eux, volant en formation, percutent une falaise dans le brouillard près de Tzaneen, tuant leurs treize occupants.',
    E'## Genesis\n**Piaggio**''s first post-war product, in Genoa, was a small amphibian, the **P.136 Royal Gull**, with a high wing and pusher engines, for adequate ground clearance and a more comfortable cabin. Piaggio used it as the basis for a landplane whose design began in 1955: the **P.166**, which kept the wing and engines of the P.136 but received a new fuselage and tail. The prototype took off from Villanova d''Albenga on 26 November 1957. Several went to customers as executive transports, feeder liners or air taxis, as far away as Australia.\n\n## Design\nThe P.166 kept its ancestor''s formula: a high wing, two engines in nacelles driving pusher propellers, and a cabin for six to eight passengers behind two pilots, easy to load. The more powerful **P.166B Portofino** of 1962 had a longer nose; the **P.166C** of 1964 carried twelve passengers. The **P.166D**, which flew on 3 July 1976, switched to **Lycoming LTP101** turboprops: in its DL3 version it reached 400 km/h, climbed to 8,500 m and covered more than 2,000 km on its wing and tip tanks. Eight Guardia di Finanza aircraft were later re-engined with **Pratt & Whitney PT6A-121**s.\n\n## Operational career\nThe **Aeronautica Militare** received 49 **P.166M**s between 1960 and 1968, followed by aerial photography versions. In South Africa the **P.166S Albatross**, with a longer nose and large tip tanks, flew coastal patrol and search and rescue with 27 Squadron: twenty were built. Somalia bought two transports and two maritime patrol aircraft in 1980. In the 1980s and 1990s the **DL3/SEM** maritime and environmental surveillance version equipped the Italian Coast Guard, which retired it in July 2017, and the **Guardia di Finanza**, which planned to keep it until 2020.\n\n## Place in history\nWith about 154 built, the P.166 was never a great commercial success, but it proved the versatility of a formula born on the water: transport, ambulance, trainer, photography and patrol. For Italy it was for nearly thirty years the eye of the coast guard and the financial police over its coasts. The South African Albatrosses, sold to private owners, kept flying after their retirement: on 14 August 2011 two of them, flying in formation, hit a cliff in dense mist near Tzaneen, killing all thirteen aboard.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1955-01-01',
    '1957-11-26',
    '1960-01-01',
    400,
    2084,
    (SELECT id FROM manufacturer WHERE code = 'PIA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Piaggio P.166'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Piaggio P.166'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.88,
  wingspan          = 14.69,
  height            = 5,
  wing_area         = 26.56,
  empty_weight      = 2650,
  mtow              = 4300,
  service_ceiling   = 8535,
  climb_rate        = 11,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming LTP101-700 (600 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 154,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **P.166AL1** : première version de série à moteurs à pistons Lycoming GSO-480 de 340 ch, 29 construits ; le **P.166M** militaire en dérive, 49 pour l''Aeronautica Militare\n- **P.166B Portofino** : moteurs de 380 ch et nez allongé, premier vol le 27 mars 1962\n- **P.166S Albatross** : patrouille côtière et sauvetage pour la South African Air Force, nez long et grands réservoirs de bout d''aile, 20 construits\n- **P.166DL3** : turbopropulseurs Lycoming LTP101, déclinée en photographie aérienne (APH), patrouille maritime (MAR) et surveillance maritime et écologique (SEM)\n- **P.166DP1** : huit DL3 de la Guardia di Finanza remotorisés en Pratt & Whitney PT6A-121',
  variants_en       = E'- **P.166AL1**: first production version with 340 hp Lycoming GSO-480 piston engines, 29 built; the military **P.166M** was derived from it, 49 for the Aeronautica Militare\n- **P.166B Portofino**: 380 hp engines and a longer nose, first flight on 27 March 1962\n- **P.166S Albatross**: coastal patrol and search and rescue for the South African Air Force, long nose and large tip tanks, 20 built\n- **P.166DL3**: Lycoming LTP101 turboprops, built in aerial photography (APH), maritime patrol (MAR) and maritime and environmental surveillance (SEM) versions\n- **P.166DP1**: eight Guardia di Finanza DL3s re-engined with Pratt & Whitney PT6A-121s',

  -- Strate 4 : qualitatif
  nickname          = 'Albatross',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Piaggio_P166',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Piaggio_P.166',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'SCDBob',
  image_licence     = 'CC BY-SA 2.5'
WHERE name = 'Piaggio P.166';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Piaggio P.166';
