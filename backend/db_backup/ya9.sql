-- Northrop YA-9A
--
-- Photo : Northrop A-9A prototype.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:Northrop_A-9A_prototype.jpg

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
    'Northrop YA-9',
    'Northrop YA-9',
    'Northrop YA-9A',
    'Northrop YA-9A',
    'Concurrent malheureux de l''A-10 au programme A-X, écarté bien qu''il ait rempli tout le cahier des charges',
    'The A-10''s unlucky rival in the A-X programme, passed over although it met every requirement',
    '/assets/airplanes/ya9.jpg',
    E'## Genèse\nAu Vietnam, les avions d''attaque au sol tombent en nombre sous les armes légères, les missiles sol-air et la DCA à basse altitude, et les jets rapides comme le **F-100**, le **F-105** ou le **F-4** se révèlent peu efficaces en appui rapproché : c''est encore le vieux **A-1 Skyraider** qui tient ce rôle. À la mi-1966, l''US Air Force crée le bureau **A-X** (Attack Experimental). L''appel d''offres de mai 1970 exige un avion conçu autour d''un canon de 30 mm, capable d''emporter 7 300 kg de charges, pour un coût unitaire de 1,4 million de dollars. Le 18 décembre 1970, Northrop et Fairchild Republic sont retenus pour construire les prototypes YA-9A et YA-10A.\n\n## Conception\nLe YA-9 est un monoplan à aile haute en alliage d''aluminium riveté. Ses deux turbofans **Lycoming YF102** de 32 kN, dérivés de la turbine de l''hélicoptère CH-47 Chinook pour limiter les coûts, sont logés en nacelles sous l''emplanture des ailes. Les ailerons fendus servent d''aérofreins : actionnés de façon dissymétrique avec la gouverne de direction, ils déplacent l''avion latéralement sans lacet ni inclinaison, ce qui facilite la visée. Le pilote est entouré d''une **baignoire blindée**, en aluminium sur les prototypes, prévue en titane en série ; réservoirs autoobturants et commandes doublées devaient réduire les pertes de 90 %. Faute de GAU-8 prêt à temps, les prototypes reçoivent un **M61 Vulcan** de 20 mm ; dix points d''emport acceptent bombes et missiles **AGM-65 Maverick**.\n\n## Essais\nLe YA-9 vole le 30 mai 1972, le second prototype le 23 août. Northrop vante une maniabilité « de chasseur » et une bonne plateforme de tir. La compétition en vol, confiée aux pilotes d''essai de l''Air Force, se déroule du 10 octobre au 9 décembre 1972. Le YA-9 remplit entièrement le cahier des charges, mais le YA-10 est déclaré vainqueur le 18 janvier 1973 : son réacteur TF34, déjà éprouvé, a pu peser face au F102 inédit, et Fairchild, sans autre contrat, n''aurait sans doute pas survécu à une défaite.\n\n## Place dans l''histoire\nLes deux YA-9 poursuivent leurs essais à la **NASA** avant d''être retirés. Leurs moteurs sur mesure connaissent une seconde vie sur une cellule de Buffalo, dans l''avion de recherche **QSRA** de la NASA et de Boeing, consacré aux avions de ligne silencieux à décollage court. L''un des prototypes est exposé au March Field Air Museum, l''autre attend sa restauration à Edwards. Le YA-9 reste l''autre réponse au besoin qui a donné naissance à l''**A-10 Thunderbolt II**.',
    E'## Genesis\nIn Vietnam, ground-attack aircraft were shot down in large numbers by small arms, surface-to-air missiles and low-level anti-aircraft fire, and fast jets such as the **F-100**, **F-105** and **F-4** proved largely ineffective at close air support: the role still fell to the old **A-1 Skyraider**. In mid-1966 the US Air Force set up the **A-X** (Attack Experimental) programme office. The May 1970 request for proposals called for an aircraft designed around a 30 mm cannon, able to carry 7,300 kg of stores, at a unit cost of 1.4 million dollars. On 18 December 1970 Northrop and Fairchild Republic were selected to build the YA-9A and YA-10A prototypes.\n\n## Design\nThe YA-9 was a shoulder-wing monoplane of riveted aluminium alloy. Its two 32 kN **Lycoming YF102** turbofans, derived from the CH-47 Chinook''s turboshaft to keep costs down, sat in nacelles under the wing roots. Split ailerons doubled as airbrakes: operated asymmetrically together with the rudder, they moved the aircraft sideways without yawing or banking, easing weapon aiming. The pilot sat in an **armoured bathtub**, aluminium on the prototypes and titanium in production; self-sealing tanks and redundant controls were meant to cut combat losses by 90%. As the GAU-8 was not ready, the prototypes received a 20 mm **M61 Vulcan**; ten hardpoints could carry bombs and **AGM-65 Maverick** missiles.\n\n## Testing\nThe YA-9 flew on 30 May 1972, the second prototype on 23 August. Northrop claimed ''fighter-like'' handling and a good weapons platform. The fly-off, flown by Air Force test pilots, ran from 10 October to 9 December 1972. The YA-9 fully met the requirements, but the YA-10 was declared the winner on 18 January 1973: its proven TF34 engine may have counted against the untried F102, and Fairchild, with no other work, was unlikely to survive a defeat.\n\n## Place in history\nBoth YA-9s went on testing with **NASA** before being retired. Their custom-built engines found a second life on a Buffalo airframe, in the NASA-Boeing **QSRA** research aircraft, devoted to quiet short-haul airliners. One prototype is displayed at the March Field Air Museum, the other awaits restoration at Edwards. The YA-9 remains the other answer to the requirement that produced the **A-10 Thunderbolt II**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1967-03-06',
    '1972-05-30',
    NULL,
    837,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop YA-9'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop YA-9'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'Northrop YA-9'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop YA-9'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Northrop YA-9'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.31,
  wingspan          = 17.68,
  height            = 5.16,
  wing_area         = 54,
  empty_weight      = NULL,
  mtow              = 18597,
  service_ceiling   = NULL,
  climb_rate        = 25.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming YF102-LD-100',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 32.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **YA-9A 71-1367** : premier prototype, premier vol le 30 mai 1972 ; en attente de restauration à Edwards\n- **YA-9A 71-1368** : second prototype, premier vol le 23 août 1972 ; exposé au March Field Air Museum\n- **A-9A de série** : version prévue avec canon GAU-8 de 30 mm et baignoire blindée en titane, jamais construite',
  variants_en       = E'- **YA-9A 71-1367**: first prototype, first flight on 30 May 1972; awaiting restoration at Edwards\n- **YA-9A 71-1368**: second prototype, first flight on 23 August 1972; displayed at the March Field Air Museum\n- **Production A-9A**: planned version with the 30 mm GAU-8 cannon and a titanium armoured bathtub, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_YA-9',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_YA-9',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Northrop YA-9';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Northrop YA-9';
