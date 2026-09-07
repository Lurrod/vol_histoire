-- Lockheed YF-22
--
-- Photo : An air-to-air overhead view of the YF-22 advanced tactical fighter aircraft during a test flight DF-ST-92-09938.jpg
--   licence Public domain — auteur non renseigné
--   https://commons.wikimedia.org/wiki/File%3AAn_air-to-air_overhead_view_of_the_YF-22_advanced_tactical_fighter_aircraft_during_a_test_flight_DF-ST-92-09938.jpg

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
    'YF-22',
    'YF-22',
    'Lockheed YF-22',
    'Lockheed YF-22',
    'Le prototype qui a gagné le plus gros contrat de chasse de l’histoire',
    'The prototype that won the biggest fighter contract in history',
    '/assets/airplanes/yf22.jpg',
    E'## Genèse\nLe programme **Advanced Tactical Fighter** est lancé en 1981 pour répondre à une menace qui n''existera jamais : le chasseur soviétique de cinquième génération. L''Air Force veut de la furtivité, de la supercroisière et un radar hors de portée. En 1986, deux équipes sont retenues pour construire des prototypes volants — Lockheed avec le YF-22, Northrop avec le **YF-23**.\n\n## Conception\nLockheed applique au chasseur les leçons du **F-117**, mais en surfaces courbes et non plus en facettes : la puissance de calcul de 1986 permet enfin de modéliser une géométrie continue. Deux **YF119** à tuyères orientables assurent la supercroisière et la manœuvre. Les missiles sont logés dans des **soutes internes**, sans lesquelles toute la furtivité serait perdue.\n\n## Carrière opérationnelle\nAucune. Deux prototypes, quatre-vingt-onze vols en huit mois. Le YF-22 est moins furtif et moins rapide que son rival mais plus manœuvrant, et Lockheed convainc mieux sur le calendrier et le coût. Le **23 avril 1991**, l''Air Force le choisit — le plus gros contrat de chasse jamais signé.\n\n## Place dans l''histoire\nDeux exemplaires. Le F-22 de série qui en découle sera si profondément redessiné qu''il n''en partage presque aucune pièce. Et des 648 appareils commandés, la fin de la guerre froide n''en laissera construire que **187**. Le YF-22 aura donc gagné une compétition dont le prix a fondu de soixante-dix pour cent.',
    E'## Genesis\nThe **Advanced Tactical Fighter** programme was launched in 1981 to counter a threat that would never exist: the Soviet fifth-generation fighter. The Air Force wanted stealth, supercruise and a radar beyond reach. In 1986 two teams were selected to build flying prototypes — Lockheed with the YF-22, Northrop with the **YF-23**.\n\n## Design\nLockheed applied the lessons of the **F-117** to a fighter, but in curved surfaces rather than facets: the computing power of 1986 finally allowed a continuous geometry to be modelled. Two **YF119s** with vectoring nozzles provide supercruise and manoeuvre. The missiles sit in **internal bays**, without which all the stealth would be lost.\n\n## Operational career\nNone. Two prototypes, ninety-one flights in eight months. The YF-22 was less stealthy and slower than its rival but more manoeuvrable, and Lockheed argued schedule and cost better. On **23 April 1991** the Air Force chose it — the largest fighter contract ever signed.\n\n## Place in history\nTwo built. The production F-22 that followed was so thoroughly redrawn that it shares almost no part with it. And of the 648 aircraft ordered, the end of the Cold War would allow only **187** to be built. The YF-22 thus won a competition whose prize shrank by seventy per cent.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1986-10-01',
    '1990-09-29',
    NULL,
    2335.0,
    2960.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'YF-22'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'YF-22'), (SELECT id FROM tech WHERE name = 'Moteurs à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'YF-22'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'YF-22'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'YF-22'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'YF-22'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'YF-22'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.56,
  wingspan          = 13.11,
  height            = 5.39,
  wing_area         = 77.1,
  empty_weight      = 14970,
  mtow              = 28120,
  service_ceiling   = 15240,
  climb_rate        = NULL,
  g_limit_pos       = 7.0,
  g_limit_neg       = NULL,
  combat_radius     = 1200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney YF119-PW-100',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion et poussée vectorielle',
  engine_type_en    = 'Afterburning turbofan with thrust vectoring',
  thrust_dry        = 104.0,
  thrust_wet        = 155.7,

  -- Strate 3 : production & service
  production_start  = 1988,
  production_end    = 1990,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **YF-22 n°1 (YF119) et n°2 (YF120)** : deux prototypes, deux motorisations concurrentes\n- Opposé au **YF-23 Black Widow II** de Northrop dans la compétition **ATF**\n- Tire un **AIM-9** et un **AIM-120** depuis ses soutes internes pendant les essais\n- Choisi le **23 avril 1991** : contrat de 86 milliards de dollars pour 648 appareils\n- Le F-22 de série sera profondément redessiné : voilure, dérives et cockpit modifiés',
  variants_en       = E'- **YF-22 No. 1 (YF119) and No. 2 (YF120)** : two prototypes, two competing engines\n- Faced Northrop''s **YF-23 Black Widow II** in the **ATF** competition\n- Fired an **AIM-9** and an **AIM-120** from its internal bays during testing\n- Selected on **23 April 1991**: an $86 billion contract for 648 aircraft\n- The production F-22 was heavily redrawn: wing, fins and cockpit all changed',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_YF-22',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_YF-22',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'YF-22';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'YF-22';
