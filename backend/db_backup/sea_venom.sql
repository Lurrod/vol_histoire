-- de Havilland DH.112 Sea Venom
--
-- Photo : De Havilland Sea Venom - Muzeum Lotnictwa Kraków.jpg
--   licence CC BY-SA 3.0 — Jakub "flyz1" Maciejewski
--   https://commons.wikimedia.org/wiki/File:De_Havilland_Sea_Venom_-_Muzeum_Lotnictwa_Krak%C3%B3w.jpg

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
    'de Havilland Sea Venom',
    'de Havilland Sea Venom',
    'de Havilland DH.112 Sea Venom',
    'de Havilland DH.112 Sea Venom',
    'Chasseur tous-temps embarqué de la Royal Navy à Suez, construit en France sous le nom d''Aquilon',
    'The Royal Navy''s carrier-borne all-weather fighter at Suez, built in France as the Aquilon',
    '/assets/airplanes/sea-venom.jpg',
    E'## Genèse\nComme le Sea Vampire avant lui, le Sea Venom répond à une demande de la **Royal Navy** : une version embarquée du **de Havilland Venom**, ici de son biplace de chasse de nuit NF.2, pour disposer d''un intercepteur tous-temps. Le premier prototype vole le 19 avril 1951 et commence ses essais sur porte-avions la même année. La France s''y intéresse aussitôt : après avoir écarté plusieurs projets nationaux, l''**Aéronautique navale** obtient dès l''été 1951 une licence confiée à la **SNCASE**, qui produit l''appareil sous le nom d''**Aquilon**, avec des réacteurs construits par Fiat en Italie.\n\n## Conception\nLa navalisation du Venom passe par des ailes repliables, une crosse d''appontage escamotée dans une lèvre caractéristique au-dessus de la tuyère, un train renforcé à grand débattement et une verrière permettant l''évacuation sous l''eau. Pilote et opérateur radar sont assis côte à côte. Le FAW.20 vole avec le turboréacteur **de Havilland Ghost** 103 ; le FAW.21 reçoit le Ghost 104, une verrière dégagée et un radar américain ; le FAW.22, le Ghost 105 de 23,6 kN, et certains emportent le missile air-air **Firestreak**. Sept FAW.21 deviennent en 1958 des avions de **contre-mesures électroniques**, sans canons.\n\n## Carrière opérationnelle\nEn service à partir de 1954, le Sea Venom connaît le feu en 1956 pendant la **crise de Suez** : les flottilles embarquées sur les porte-avions HMS Albion et HMS Eagle bombardent de nombreux objectifs égyptiens lors de l''opération Musketeer. En France, les Aquilon des flottilles 11F et 16F participent de 1957 à 1961 aux opérations de contre-insurrection de la **guerre d''Algérie**. En Australie, 39 FAW.53 remplacent le Hawker Sea Fury à partir de 1956 et opèrent depuis le porte-avions HMAS Melbourne.\n\n## Place dans l''histoire\nLe **Sea Vixen**, bipoutre lui aussi, le remplace en première ligne à partir de 1959, mais des unités de seconde ligne de la Fleet Air Arm l''emploient jusqu''en 1970. Les Aquilon effectuent leur dernier vol officiel le 30 juin 1966, et l''Australie le relève par le Skyhawk A-4G en 1967. Successeur de la Sea Hornet à pistons, le Sea Venom a servi trois marines pendant près de quinze ans, de Suez à l''Algérie, et fait le lien entre les chasseurs de nuit à hélice et les intercepteurs embarqués armés de missiles.',
    E'## Genesis\nLike the Sea Vampire before it, the Sea Venom answered a **Royal Navy** requirement: a carrier version of the **de Havilland Venom**, in this case of its NF.2 two-seat night fighter, to provide an all-weather interceptor. The first prototype flew on 19 April 1951 and began carrier trials the same year. France showed immediate interest: having set aside several domestic designs, the French **Aéronavale** secured a licence from the summer of 1951, entrusted to **SNCASE**, which built the aircraft as the **Aquilon**, with engines made by Fiat in Italy.\n\n## Design\nNavalising the Venom meant folding wings, a tailhook retracting into a characteristic lip above the jetpipe, strengthened long-stroke undercarriage and a canopy allowing escape underwater. Pilot and radar operator sat side by side. The FAW.20 flew with the **de Havilland Ghost** 103 turbojet; the FAW.21 received the Ghost 104, a clear-view canopy and American radar; the FAW.22 had the 23.6 kN Ghost 105, and some carried the **Firestreak** air-to-air missile. Seven FAW.21s became **electronic countermeasures** aircraft in 1958, with their cannon removed.\n\n## Operational career\nIn service from 1954, the Sea Venom saw combat in 1956 during the **Suez Crisis**: squadrons embarked on the carriers HMS Albion and HMS Eagle bombed a variety of Egyptian targets during Operation Musketeer. In France, the Aquilons of Flottilles 11F and 16F took part in counter-insurgency operations in the **Algerian War** from 1957 to 1961. In Australia, 39 FAW.53s replaced the Hawker Sea Fury from 1956 and flew from the carrier HMAS Melbourne.\n\n## Place in history\nThe **Sea Vixen**, also twin-boomed, replaced it in front-line service from 1959, but second-line Fleet Air Arm units flew it until 1970. The Aquilon made its last official flight on 30 June 1966, and Australia replaced it with the A-4G Skyhawk in 1967. Successor to the piston-engined Sea Hornet, the Sea Venom served three navies for nearly fifteen years, from Suez to Algeria, bridging the gap between propeller-driven night fighters and missile-armed carrier interceptors.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    NULL,
    '1951-04-19',
    '1954-03-01',
    927,
    1135,
    (SELECT id FROM manufacturer WHERE code = 'DH'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM armement WHERE name = 'Firestreak')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM armement WHERE name = '1000 lb GP'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM wars WHERE name = 'Crise de Suez')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Sea Venom'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.15,
  wingspan          = 13.08,
  height            = 2.6,
  wing_area         = 26.0,
  empty_weight      = NULL,
  mtow              = 7167,
  service_ceiling   = 12000,
  climb_rate        = 29.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'de Havilland Ghost 105',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 23.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 399,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Sea Venom NF.20** : trois prototypes dérivés du Venom NF.2\n- **Sea Venom FAW.20** : première série à Ghost 103 et radar AI Mk 10, 50 exemplaires\n- **Sea Venom FAW.21** : Ghost 104, verrière dégagée, radar américain et train à grand débattement, 167 exemplaires, dont des conversions de contre-mesures électroniques (ECM.21)\n- **Sea Venom FAW.22** : Ghost 105 de 23,6 kN, meilleures performances en altitude, missiles Firestreak sur certains avions, 39 exemplaires\n- **Sea Venom FAW.53** : version australienne du FAW.21, 39 exemplaires\n- **SNCASE Aquilon** : 101 avions construits sous licence en France, déclinés en biplaces 20 et 202, monoplace 203 à radar AN/APQ-94 et missiles, et biplace d''entraînement 204',
  variants_en       = E'- **Sea Venom NF.20**: three prototypes derived from the Venom NF.2\n- **Sea Venom FAW.20**: first production batch with Ghost 103 and AI Mk 10 radar, 50 built\n- **Sea Venom FAW.21**: Ghost 104, clear-view canopy, American radar and long-stroke undercarriage, 167 built, including electronic countermeasures conversions (ECM.21)\n- **Sea Venom FAW.22**: 23.6 kN Ghost 105, better high-altitude performance, Firestreak missiles on some aircraft, 39 built\n- **Sea Venom FAW.53**: Australian version of the FAW.21, 39 built\n- **SNCASE Aquilon**: 101 aircraft licence-built in France, as the two-seat 20 and 202, the single-seat 203 with AN/APQ-94 radar and missiles, and the 204 two-seat trainer',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Sea_Venom',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Sea_Venom',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jakub "flyz1" Maciejewski',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'de Havilland Sea Venom';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'de Havilland Sea Venom';
