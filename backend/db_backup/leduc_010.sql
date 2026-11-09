-- Leduc 0.10
--
-- Photo : First flight of the Languedoc n°6 with the Leduc 010 prototype.jpg
--   licence Public domain — auteur non indiqué
--   https://commons.wikimedia.org/wiki/File:First_flight_of_the_Languedoc_n%C2%B06_with_the_Leduc_010_prototype.jpg

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
    'Leduc 010',
    'Leduc 010',
    'Leduc 0.10',
    'Leduc 0.10',
    '21 avril 1949 : pour la première fois, un avion vole propulsé par un statoréacteur seul',
    '21 April 1949: for the first time, an aircraft flies on ramjet power alone',
    '/assets/airplanes/leduc-010.jpg',
    E'## Genèse\nLe statoréacteur est le plus simple des moteurs : un tube ouvert, sans pièce tournante, où l''air comprimé par la seule vitesse de l''avion est brûlé avec du carburant. Son principe est connu depuis René Lorin, avant la Première Guerre mondiale, mais personne n''a su en faire un propulseur. **René Leduc**, ingénieur venu de chez Breguet, s''y consacre dans les années 1930 et convainc le ministère de l''Air de lui commander un avion expérimental en 1937. La guerre interrompt les travaux, poursuivis à petits pas pendant l''Occupation ; l''appareil sort de l''usine de Toulouse en septembre 1946.\n\n## Conception\nL''avion **est** le moteur. Le fuselage est un gros cylindre creux ; le pilote est installé dans un cône central, comme une ogive placée dans l''entrée d''air, et l''air passe tout autour de lui avant d''être brûlé à l''arrière. Une aile droite et un empennage classique complètent l''ensemble. Un statoréacteur ne produit aucune poussée à l''arrêt : le 0.10 est donc hissé sur le dos d''un quadrimoteur **SNCASE Languedoc** et largué en altitude.\n\n## Carrière opérationnelle\nAucune. Après des vols captifs à partir de novembre 1946, le premier vol plané a lieu le 21 octobre 1947. Le **21 avril 1949**, au-dessus de Toulouse, **Jean Gonord** est largué vers 3 000 mètres et allume le statoréacteur : c''est le premier vol au monde d''un avion propulsé par un statoréacteur seul. Les essais suivants dépassent Mach 0,8 et montrent une vitesse ascensionnelle supérieure à celle des chasseurs de l''époque. Les deux exemplaires sont détruits en accident, le 27 novembre 1951 et le 25 juillet 1952 ; leurs pilotes, Jean Sarrail et Yvan Littolff, sont blessés.\n\n## Place dans l''histoire\nLeduc poursuit avec les **0.21** et **0.22**, ce dernier doté d''un turboréacteur pour décoller seul et destiné à franchir Mach 2. Les difficultés techniques et le coût conduisent l''État à arrêter le programme en février 1958, au moment où le **Mirage III** promet la même vitesse avec des moyens classiques. Le statoréacteur ne disparaît pas pour autant : le **Nord 1500 Griffon** l''associe à un turboréacteur, et les missiles en font leur moteur, jusqu''à l''**ASMP** français. Un 0.10 reconstitué à partir du 0.16 est conservé au musée de l''Air et de l''Espace du Bourget.',
    E'## Genesis\nThe ramjet is the simplest of engines: an open tube with no moving parts, in which air compressed by the aircraft’s speed alone is burned with fuel. Its principle had been known since René Lorin, before the First World War, but nobody had managed to turn it into a powerplant. **René Leduc**, an engineer from Breguet, devoted himself to it in the 1930s and persuaded the Air Ministry to order an experimental aircraft from him in 1937. The war interrupted the work, which continued slowly under the Occupation; the aircraft left the Toulouse factory in September 1946.\n\n## Design\nThe aircraft **is** the engine. The fuselage is a large hollow cylinder; the pilot sits in a central cone, like a bullet placed in the intake, and the air flows all around him before being burned at the rear. A straight wing and a conventional tail complete the design. A ramjet produces no thrust at rest: the 0.10 was therefore hoisted onto the back of a four-engined **SNCASE Languedoc** and released at altitude.\n\n## Operational career\nNone. After captive flights from November 1946, the first gliding flight took place on 21 October 1947. On **21 April 1949**, over Toulouse, **Jean Gonord** was released at about 3,000 metres and lit the ramjet: the first flight in the world of an aircraft powered by a ramjet alone. Later tests exceeded Mach 0.8 and showed a rate of climb better than that of the fighters of the day. Both aircraft were destroyed in accidents, on 27 November 1951 and 25 July 1952; their pilots, Jean Sarrail and Yvan Littolff, were injured.\n\n## Place in history\nLeduc went on with the **0.21** and **0.22**, the latter fitted with a turbojet to take off on its own and intended to pass Mach 2. Technical difficulties and cost led the state to end the programme in February 1958, just as the **Mirage III** promised the same speed by conventional means. The ramjet did not disappear for all that: the **Nord 1500 Griffon** combined it with a turbojet, and missiles made it their engine, down to the French **ASMP**. A 0.10 rebuilt from the 0.16 is preserved at the Musée de l’Air et de l’Espace at Le Bourget.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1937-01-01',
    '1949-04-21',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'LED'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Leduc 010'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Leduc 010'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.25,
  wingspan          = 10.52,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Statoréacteur Leduc',
  engine_count      = 1,
  engine_type       = 'Statoréacteur',
  engine_type_en    = 'Ramjet',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **0.10-01** : premier exemplaire, premier vol propulsé le 21 avril 1949, détruit le 25 juillet 1952\n- **0.10-02** : second exemplaire, détruit le 27 novembre 1951\n- **0.16** : variante dotée de deux turboréacteurs d''appoint en bout d''aile, ramenée au standard 0.10 et remise au musée du Bourget en 1954\n- **0.21 / 0.22** : successeurs plus grands ; le 0.22 associe statoréacteur et turboréacteur\n- Programme arrêté par l''État en **février 1958**',
  variants_en       = E'- **0.10-01** : first aircraft, first powered flight on 21 April 1949, destroyed on 25 July 1952\n- **0.10-02** : second aircraft, destroyed on 27 November 1951\n- **0.16** : variant with two auxiliary turbojets at the wingtips, returned to 0.10 standard and handed to the Le Bourget museum in 1954\n- **0.21 / 0.22** : larger successors; the 0.22 combined ramjet and turbojet\n- Programme ended by the state in **February 1958**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Leduc_(avion)',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Leduc_0.10',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Leduc 010';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Leduc 010';
