-- Gulfstream C-37A (Gulfstream V)
--
-- Photo : CMC Camp Lejeune Visit 150429-M-UY788-012.jpg
--   licence Public domain — Lance Cpl. Chloe Nelson
--   https://commons.wikimedia.org/wiki/File:CMC_Camp_Lejeune_Visit_150429-M-UY788-012.jpg

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
    'Gulfstream C-37A',
    'Gulfstream C-37A',
    'Gulfstream C-37A (Gulfstream V)',
    'Gulfstream C-37A (Gulfstream V)',
    'Gulfstream V à très long rayon d''action qui transporte chefs militaires et hauts responsables américains',
    'Ultra-long-range Gulfstream V that carries American military chiefs and senior officials',
    '/assets/airplanes/gulfstream-c37a.jpg',
    E'## Genèse\nAu début des années 1990, **Gulfstream Aerospace** répond au **Bombardier Global Express** en dérivant du Gulfstream IV son premier avion d''affaires à très long rayon d''action, le **Gulfstream V**. Le prototype vole le 28 novembre 1995, l''avion est certifié le 11 avril 1997 et entre en service en juin. Avant même sa certification, en août 1996, l''US Air Force choisit de remplacer ses vieux **VC-137**, dérivés du Boeing 707, par une flotte panachée de C-32A, de C-37A, version militaire du Gulfstream V, puis de C-40.\n\n## Conception\nPar rapport au Gulfstream IV, l''envergure passe de 22,7 à 28,5 m, le fuselage s''allonge et une nouvelle voilure semi-supercritique emporte 5,4 t de carburant de plus. Deux turbosoufflantes **Rolls-Royce BR710** à régulation numérique FADEC portent le plafond de 13 700 à 15 500 m, et l''autonomie atteint 12 000 km. Le C-37A reçoit une gestion de vol par satellite, un radar météo, un collimateur tête haute et un système de vision améliorée pour voler par mauvais temps, ainsi que des transmissions civiles et militaires. Dans l''US Army, il vole avec deux pilotes, un mécanicien navigant, un opérateur radio et un agent de bord.\n\n## Carrière opérationnelle\nDésigné C-37A, le Gulfstream V effectue des missions pour le gouvernement et les responsables du département de la Défense. Le 89th Airlift Wing en aligne quatre à Andrews, près de Washington ; d''autres escadrons en mettent en œuvre à MacDill, Hickam et Ramstein, et l''US Army en garde deux pour ses transports prioritaires. La Navy, le Marine Corps et les garde-côtes en utilisent aussi ; ces derniers y transportent leur commandant et le secrétaire à la Sécurité intérieure. Avec cinq hommes d''équipage et douze passagers, il franchit encore plus de 10 000 km.\n\n## Place dans l''histoire\nLe C-37A est le premier d''une lignée : en 2003, le Gulfstream V cède la place au **G550**, qui devient le **C-37B** dans les forces américaines. Cette cellule sert aussi de base à des avions de mission, comme l''avion de guet G550 CAEW ou le brouilleur **EA-37B Compass Call**, né sous la désignation EC-37B, version de guerre électronique du C-37B. Entre transport de personnalités et missions de renseignement, le jet d''affaires américain s''est fait une place durable dans l''aviation militaire.',
    E'## Genesis\nIn the early 1990s **Gulfstream Aerospace** answered the **Bombardier Global Express** by deriving from the Gulfstream IV its first ultra-long-range business jet, the **Gulfstream V**. The prototype flew on 28 November 1995, the aircraft was certified on 11 April 1997 and entered service in June. Even before its certification, in August 1996 the US Air Force chose to replace its ageing Boeing 707-based **VC-137s** with a mixed fleet of C-32As, C-37As, the military version of the Gulfstream V, and later C-40s.\n\n## Design\nCompared with the Gulfstream IV, the span grew from 22.7 to 28.5 m, the fuselage was stretched and a new semi-supercritical wing holds 5.4 t more fuel. Two **Rolls-Royce BR710** turbofans with FADEC raised the ceiling from 13,700 to 15,500 m, and range reached 12,000 km. The C-37A received a satellite flight management system, weather radar, a head-up display and an enhanced vision system for flying in bad weather, as well as civil and military communications. In the US Army it flies with two pilots, a flight engineer, a radio operator and a flight attendant.\n\n## Operational career\nDesignated C-37A, the Gulfstream V flies missions for the government and Defense Department officials. The 89th Airlift Wing flies four from Andrews, near Washington; other squadrons operate it from MacDill, Hickam and Ramstein, and the US Army keeps two for its priority air transport. The Navy, the Marine Corps and the Coast Guard also use it; the latter carries its commandant and the Secretary of Homeland Security. With five crew and twelve passengers it still covers more than 10,000 km.\n\n## Place in history\nThe C-37A was the first of a line: in 2003 the Gulfstream V gave way to the **G550**, which became the **C-37B** in the US forces. That airframe also serves as the basis for mission aircraft, such as the G550 CAEW early warning aircraft or the **EA-37B Compass Call** jammer, born under the designation EC-37B as an electronic warfare version of the C-37B. Between VIP transport and intelligence missions, the American business jet has carved out a lasting place in military aviation.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1995-11-28',
    '1997-06-01',
    940,
    12000,
    (SELECT id FROM manufacturer WHERE code = 'GUL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Gulfstream C-37A'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Gulfstream C-37A'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Gulfstream C-37A'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 29.38,
  wingspan          = 28.48,
  height            = 8.18,
  wing_area         = 105.6,
  empty_weight      = 20956,
  mtow              = 41050,
  service_ceiling   = 15545,
  climb_rate        = 21.28,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce BR710A1-10',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 65.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1995,
  production_end    = 2002,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **Gulfstream V** : avion d''affaires de base, premier vol le 28 novembre 1995, 193 exemplaires produits jusqu''en 2002\n- **C-37A** : désignation militaire américaine du Gulfstream V, en service dans l''Air Force, l''Army, la Navy, le Marine Corps et les garde-côtes\n- **C-37B** : désignation militaire du Gulfstream G550, successeur du Gulfstream V à partir de 2003\n- **SEMA** : Gulfstream V très modifié pour les missions électroniques spéciales, livré au ministère israélien de la Défense en juin 2005\n- **HIAPER** : Gulfstream V de recherche atmosphérique du NCAR, livré le 11 mars 2005, avec instruments sous les ailes',
  variants_en       = E'- **Gulfstream V**: baseline business jet, first flight on 28 November 1995, 193 built until 2002\n- **C-37A**: US military designation of the Gulfstream V, in service with the Air Force, Army, Navy, Marine Corps and Coast Guard\n- **C-37B**: military designation of the Gulfstream G550, successor to the Gulfstream V from 2003\n- **SEMA**: highly modified Gulfstream V for special electronic missions, delivered to the Israeli Ministry of Defense in June 2005\n- **HIAPER**: NCAR atmospheric research Gulfstream V, delivered on 11 March 2005, with underwing instruments',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Gulfstream_V',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Gulfstream_V',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Lance Cpl. Chloe Nelson, U.S. Marine Corps',
  image_licence     = 'Public domain'
WHERE name = 'Gulfstream C-37A';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Gulfstream C-37A';
