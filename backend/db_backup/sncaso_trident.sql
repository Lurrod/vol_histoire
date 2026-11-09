-- SNCASO SO.9000 Trident
--
-- Photo : Sud-Ouest SO.9000 Trident I ‘Y’ -F-ZWRY- (53410559117).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Sud-Ouest_SO.9000_Trident_I_%E2%80%98Y%E2%80%99_-F-ZWRY-_(53410559117).jpg

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
    'SNCASO Trident',
    'SNCASO Trident',
    'SNCASO SO.9000 Trident',
    'SNCASO SO.9000 Trident',
    'Deux réacteurs en bout d’aile, une fusée dans le fuselage : 24 217 mètres en 1958',
    'Two jets at the wingtips, a rocket in the fuselage: 24,217 metres in 1958',
    '/assets/airplanes/sncaso-trident.jpg',
    E'## Genèse\nÀ la fin des années 1940, la menace est le bombardier soviétique à haute altitude, et le problème celui du temps : un intercepteur à réaction met de longues minutes à rejoindre son plafond. En octobre 1948, la **SNCASO** (Société nationale de constructions aéronautiques du Sud-Ouest) étudie une réponse radicale : confier la montée à un moteur-fusée, qui ne dépend pas de l''air ambiant, et garder de petits turboréacteurs pour le retour. La maquette est approuvée en 1950, deux prototypes commandés en avril 1951.\n\n## Conception\nUne aile droite très mince et de faible envergure, à l''extrémité de laquelle sont fixés deux petits turboréacteurs — d''où le nom de Trident, avec la fusée au centre. Le moteur-fusée **SEPR** à plusieurs chambres, logé dans l''arrière du fuselage, brûle des ergols liquides et ne fonctionne que quelques minutes. Le **Trident II** reçoit des réacteurs plus puissants, puis des **Turbomeca Gabizo**, et une fusée **SEPR 631** de 29 kN.\n\n## Carrière opérationnelle\nAucune. Le premier prototype vole le **2 mars 1953**, sur ses seuls réacteurs ; le second s''écrase dès son premier vol, le 1er septembre 1953, et son pilote, Jacques Guignard, est grièvement blessé. Les vols avec fusée commencent en 1954. Le Trident II vole le 19 juillet 1955, et six appareils de présérie sont commandés en 1956, dont trois seront livrés. Le **2 mai 1958**, **Roger Carpentier** porte le record du monde d''altitude à **24 217 mètres** ; l''appareil grimpe à 15 000 mètres en 2 min 15 s et dépasse 2 000 km/h. Mais les ergols sont dangereux, plusieurs appareils sont perdus, et l''armée de l''air préfère le **Mirage III**. Le programme est arrêté en 1958 pour raisons budgétaires.\n\n## Place dans l''histoire\nHuit appareils construits. Le Trident appartient à la courte lignée des intercepteurs européens à propulsion mixte, fusée et réacteurs, des années 1950, avec le SNCASE Durandal et le **Saunders-Roe SR.53** britannique, qui connaît le même sort. Tous sont condamnés par l''arrivée d''intercepteurs à postcombustion assez puissants et par le missile sol-air. Un exemplaire est conservé au musée de l''Air et de l''Espace du Bourget.',
    E'## Genesis\nAt the end of the 1940s the threat was the high-altitude Soviet bomber, and the problem was time: a jet interceptor took long minutes to reach its ceiling. In October 1948 **SNCASO** (Société nationale de constructions aéronautiques du Sud-Ouest) studied a radical answer: leave the climb to a rocket engine, which does not depend on the surrounding air, and keep small turbojets for the return. The mock-up was approved in 1950 and two prototypes were ordered in April 1951.\n\n## Design\nA very thin, short-span straight wing, with a small turbojet fixed at each tip — hence the name Trident, with the rocket in the middle. The multi-chamber **SEPR** rocket engine, housed in the rear fuselage, burned liquid propellants and ran for only a few minutes. The **Trident II** received more powerful jets, later **Turbomeca Gabizos**, and a 29 kN **SEPR 631** rocket.\n\n## Operational career\nNone. The first prototype flew on **2 March 1953** on its jets alone; the second crashed on its first flight, on 1 September 1953, and its pilot, Jacques Guignard, was seriously injured. Rocket flights began in 1954. The Trident II flew on 19 July 1955, and six pre-production aircraft were ordered in 1956, of which three would be delivered. On **2 May 1958** **Roger Carpentier** raised the world altitude record to **24,217 metres**; the aircraft climbed to 15,000 metres in 2 min 15 s and exceeded 2,000 km/h. But the propellants were dangerous, several aircraft were lost, and the Air Force preferred the **Mirage III**. The programme was stopped in 1958 for budgetary reasons.\n\n## Place in history\nEight aircraft built. The Trident belongs to the short line of European mixed rocket-and-jet interceptors of the 1950s, alongside the SNCASE Durandal and Britain’s **Saunders-Roe SR.53**, which met the same fate. All were doomed by the arrival of afterburning interceptors powerful enough for the job, and by the surface-to-air missile. One example is preserved at the Musée de l’Air et de l’Espace at Le Bourget.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1948-10-01',
    '1953-03-02',
    NULL,
    2060.0,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'SUD'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'SNCASO Trident'), (SELECT id FROM tech WHERE name = 'Moteur-fusée')),
((SELECT id FROM airplanes WHERE name = 'SNCASO Trident'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'SNCASO Trident'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'SNCASO Trident'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.7,
  wingspan          = 6.98,
  height            = NULL,
  wing_area         = 14.5,
  empty_weight      = 5150,
  mtow              = 5900,
  service_ceiling   = 24000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = '2 × Turbomeca Gabizo + SEPR 631',
  engine_count      = 3,
  engine_type       = 'Fusée et turboréacteur',
  engine_type_en    = 'Rocket and turbojet',
  thrust_dry        = 10.8,
  thrust_wet        = 29.3,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 8,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **SO.9000 Trident I** : deux prototypes, turboréacteurs Marboré en bout d''aile et fusée SEPR 481 ; le second perdu le 1er septembre 1953\n- **SO.9050 Trident II** : prototypes à réacteurs Dassault MD.30 Viper et fusée SEPR 631, premier vol le 19 juillet 1955\n- **Présérie Trident II** : six commandés en 1956, trois livrés, réacteurs Turbomeca Gabizo\n- **24 217 m** : record du monde d''altitude de Roger Carpentier, 2 mai 1958\n- Armement prévu : un missile air-air Matra, jamais mis en œuvre en unité',
  variants_en       = E'- **SO.9000 Trident I** : two prototypes, Marboré turbojets at the wingtips and SEPR 481 rocket; the second lost on 1 September 1953\n- **SO.9050 Trident II** : prototypes with Dassault MD.30 Viper jets and SEPR 631 rocket, first flight on 19 July 1955\n- **Trident II pre-production** : six ordered in 1956, three delivered, Turbomeca Gabizo jets\n- **24,217 m** : Roger Carpentier’s world altitude record, 2 May 1958\n- Planned armament: a Matra air-to-air missile, never used in service',

  -- Strate 4 : qualitatif
  nickname          = 'Trident',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/SO.9000_Trident',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/SNCASO_Trident',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'SNCASO Trident';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'SNCASO Trident';
