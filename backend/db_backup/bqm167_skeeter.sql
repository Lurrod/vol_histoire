-- Composite Engineering / Kratos BQM-167A Skeeter
--
-- Photo : BGM167A drone sits on a launcher 01.jpg
--   licence Public domain — Master Sgt. Mark Fortin
--   https://commons.wikimedia.org/wiki/File:BGM167A_drone_sits_on_a_launcher_01.jpg

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
    'Kratos BQM-167 Skeeter',
    'Kratos BQM-167 Skeeter',
    'Composite Engineering / Kratos BQM-167A Skeeter',
    'Composite Engineering / Kratos BQM-167A Skeeter',
    'Cible en fibre de carbone de l''US Air Force, capable de virer à 9 g et de revenir sous parachute',
    'US Air Force carbon-fibre target able to pull 9 g turns and come back under a parachute',
    '/assets/airplanes/bqm167-skeeter.jpg',
    E'## Genèse\nAu tournant des années 2000, l''**US Air Force** cherche une nouvelle cible sous-échelle pour succéder au **MQM-107 Streaker**. **Composite Engineering Inc.**, une entreprise depuis rachetée par **Kratos Defense & Security Solutions**, fait voler deux prototypes en 2001. En juillet 2002, son **BQM-167A** est retenu comme cible sous-échelle de nouvelle génération de l''armée de l''air. Six exemplaires servent à la démonstration des performances en vol : le premier vole le 8 décembre 2004, et treize lancements sont effectués jusqu''en mars 2006.\n\n## Conception\nLe Skeeter est construit en fibre de carbone et en matériaux à base de résine époxy. Long de 6,1 m et pesant 930 kg au décollage, il est propulsé par un turboréacteur **Microturbo TRI 60-5+** de 4,4 kN qui le pousse à 600 nœuds au niveau de la mer et l''emmène jusqu''à 15 000 m. Il encaisse des virages à 9 g, de quoi imiter un avion de combat qui manœuvre. Lancé depuis un rail grâce à une fusée d''appoint, il redescend sous parachute, sur terre ou en mer. Il emporte au besoin des cibles remorquées radar ou infrarouges, des nacelles sous les ailes, des lance-leurres et des systèmes de mesure de la distance de passage des missiles.\n\n## Carrière opérationnelle\nLes essais préopérationnels s''étalent d''août 2006 à juin 2007, et le premier tir réel d''un missile air-air contre un BQM-167 a lieu le 7 février 2007. La capacité opérationnelle initiale est atteinte en 2008, pour un coût de 570 000 dollars par cible. Le **82nd Aerial Targets Squadron** le met en œuvre depuis la base de Tyndall, en Floride : après chaque vol, l''engin est inspecté, remis en état et réemployé. L''US Air Force en compte 37 en inventaire ; l''armée de l''air de Singapour et l''agence suédoise du matériel de défense l''utilisent aussi. Le 19 mars 2021, un Skeeter s''est échoué sur une plage de Boynton Beach, en Floride, après une évaluation de systèmes d''armes.\n\n## Place dans l''histoire\nLe Skeeter a aussi servi de base à une idée qui le dépasse. En 2015, Kratos en tire sur ses fonds propres l''**UTAP-22**, un drone de combat à bas coût qui vole 94 minutes en formation autonome avec un **AV-8B Harrier**, commandé à travers une liaison de données tactique. Baptisé **Mako** en 2017, il porte un point d''emport d''arme sous chaque aile et coûte de 2 à 3 millions de dollars : la cible devenait l''ailier d''un avion piloté.',
    E'## Genesis\nAround the turn of the century the **US Air Force** was looking for a new subscale target to succeed the **MQM-107 Streaker**. **Composite Engineering Inc.**, a company since acquired by **Kratos Defense & Security Solutions**, flew two prototypes in 2001. In July 2002 its **BQM-167A** was selected as the Air Force''s next-generation subscale aerial target. Six were built for the flight performance demonstration: the first flew on 8 December 2004, and thirteen launches were made up to March 2006.\n\n## Design\nThe Skeeter is built of carbon fibre and epoxy-based materials. At 6.1 m long and 930 kg at take-off, it is powered by a 4.4 kN **Microturbo TRI 60-5+** turbojet that drives it to 600 knots at sea level and takes it up to 15,000 m. It can pull 9 g turns, enough to imitate a manoeuvring combat aircraft. Launched from a rail with a rocket booster, it comes down by parachute on land or at sea. It can carry radar or infrared tow targets, wing pods, chaff and flare dispensers and miss-distance scoring systems.\n\n## Operational career\nPre-operational testing ran from August 2006 to June 2007, and the first live air-to-air missile shot against a BQM-167 took place on 7 February 2007. Initial operational capability was reached in 2008, at a cost of $570,000 per target. The **82nd Aerial Targets Squadron** operates it from Tyndall Air Force Base, Florida: after each flight the drone is assessed, refurbished and put back into service. The US Air Force has had 37 in inventory; the Republic of Singapore Air Force and the Swedish Defence Materiel Administration use it too. On 19 March 2021 a Skeeter washed ashore at Boynton Beach, Florida, after a weapon systems evaluation.\n\n## Place in history\nThe Skeeter also served as the basis for an idea bigger than itself. In 2015 Kratos used its own funds to turn it into the **UTAP-22**, a low-cost combat drone that flew for 94 minutes in autonomous formation with an **AV-8B Harrier**, controlled through a tactical data link. Named **Mako** in 2017, it has a weapon hardpoint under each wing and costs between $2 and $3 million: the target had become the wingman of a manned aircraft.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '2001-01-01',
    '2008-01-01',
    1111,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'KRA'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Kratos BQM-167 Skeeter'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Kratos BQM-167 Skeeter'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 6.1,
  wingspan          = 3.2,
  height            = 1.2,
  wing_area         = NULL,
  empty_weight      = 313,
  mtow              = 930,
  service_ceiling   = 15000,
  climb_rate        = NULL,
  g_limit_pos       = 9,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Microturbo TRI 60-5+',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 4.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = 570000,
  unit_cost_year    = 2008,
  operators_count   = 3,
  variants          = E'- **Prototypes** : deux exemplaires construits et essayés en vol en 2001\n- **BQM-167A** : cible sous-échelle de l''US Air Force, retenue en juillet 2002, en service en 2008\n- **BQM-167i** : version d''exportation pour des armées de l''air étrangères (Singapour, Suède)\n- **UTAP-22 Mako** : drone de combat à bas coût dérivé (2015), Mach 0,91, 2 600 km de portée, deux points d''emport',
  variants_en       = E'- **Prototypes**: two built and flight tested in 2001\n- **BQM-167A**: US Air Force subscale target, selected in July 2002, in service in 2008\n- **BQM-167i**: export version for foreign air forces (Singapore, Sweden)\n- **UTAP-22 Mako**: derived low-cost combat drone (2015), Mach 0.91, 2,600 km range, two hardpoints',

  -- Strate 4 : qualitatif
  nickname          = 'Skeeter',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Composite_Engineering_BQM-167_Skeeter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Master Sgt. Mark Fortin, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Kratos BQM-167 Skeeter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Kratos BQM-167 Skeeter';
