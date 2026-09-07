-- EWR VJ 101C
--
-- Photo : EWR VJ101.JPG
--   licence Public domain — Jmcc150 at English Wikipedia
--   https://commons.wikimedia.org/wiki/File%3AEWR_VJ101.JPG

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
    'EWR VJ 101',
    'EWR VJ 101',
    'EWR VJ 101C',
    'EWR VJ 101C',
    'Premier ADAV supersonique, aux réacteurs basculant en bout d’aile',
    'First supersonic VTOL, with engines tilting at the wingtips',
    '/assets/airplanes/vj101.jpg',
    E'## Genèse\nL''Allemagne fédérale veut remplacer ses **F-104 Starfighter** par un intercepteur qui n''aura pas besoin de piste. Trois firmes — Bölkow, Heinkel et Messerschmitt — se regroupent en 1959 dans un consortium, l''**Entwicklungsring Süd**, pour y parvenir. L''objectif est ambitieux au point d''être irréaliste : Mach 2 et décollage vertical dans la même cellule.\n\n## Conception\nLa solution retenue est spectaculaire. Deux nacelles contenant chacune **deux réacteurs** sont montées en bout d''aile et **pivotent de quatre-vingt-dix degrés** : verticales pour le décollage, horizontales pour le vol. Deux moteurs supplémentaires, fixes et verticaux, sont logés derrière le cockpit pour équilibrer l''appareil. Six moteurs, donc, et un pilotage en stationnaire d''une difficulté redoutable — la moindre dissymétrie de poussée fait basculer la machine.\n\n## Carrière opérationnelle\nAucune. Le X-1 franchit **Mach 1,04** le 29 juillet 1964, faisant du VJ 101 le premier ADAV supersonique de l''histoire. Six semaines plus tard il est détruit au décollage : deux gyroscopes du système de stabilisation avaient été **branchés à l''envers**, et l''appareil s''est retourné. Le pilote s''éjecte à temps.\n\n## Place dans l''histoire\nDeux exemplaires. L''Allemagne abandonne en 1968, après avoir dépensé sur trois programmes ADAV parallèles — VJ 101, **VAK 191B** et **Do 31** — de quoi financer une flotte complète. Aucun n''a abouti. Bonn achètera finalement des **Tornado**, qui décollent d''une piste comme tout le monde.',
    E'## Genesis\nWest Germany wanted to replace its **F-104 Starfighters** with an interceptor that would need no runway. Three firms — Bölkow, Heinkel and Messerschmitt — combined in 1959 into a consortium, **Entwicklungsring Süd**, to achieve it. The goal was ambitious to the point of being unrealistic: Mach 2 and vertical take-off in the same airframe.\n\n## Design\nThe chosen solution is spectacular. Two nacelles, each holding **two engines**, are mounted at the wingtips and **pivot through ninety degrees**: vertical for take-off, horizontal for flight. Two further engines, fixed and vertical, sit behind the cockpit to balance the aircraft. Six engines, then, and a hover that is formidably difficult to fly — the slightest thrust asymmetry rolls the machine over.\n\n## Operational career\nNone. X-1 passed **Mach 1.04** on 29 July 1964, making the VJ 101 the first supersonic VTOL in history. Six weeks later it was destroyed on take-off: two gyroscopes of the stabilisation system had been **connected in reverse**, and the aircraft flipped. The pilot ejected in time.\n\n## Place in history\nTwo built. Germany gave up in 1968, having spent on three parallel VTOL programmes — VJ 101, **VAK 191B** and **Do 31** — enough to fund a complete fleet. None came to anything. Bonn eventually bought **Tornados**, which take off from a runway like everybody else.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1959-01-01',
    '1963-04-10',
    NULL,
    1320.0,
    1000.0,
    (SELECT id FROM manufacturer WHERE code = 'EWR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'EWR VJ 101'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'EWR VJ 101'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'EWR VJ 101'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'EWR VJ 101'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'EWR VJ 101'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'EWR VJ 101'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.7,
  wingspan          = 6.61,
  height            = 4.1,
  wing_area         = 18.6,
  empty_weight      = 6000,
  mtow              = 8000,
  service_ceiling   = 15000,
  climb_rate        = 100.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 300,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce RB.145',
  engine_count      = 6,
  engine_type       = 'Turboréacteur basculant et de sustentation',
  engine_type_en    = 'Tilting and lift turbojet',
  thrust_dry        = 12.2,
  thrust_wet        = 16.0,

  -- Strate 3 : production & service
  production_start  = 1961,
  production_end    = 1964,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **VJ 101C X-1** : premier prototype, détruit en 1964 sur une erreur de câblage\n- **VJ 101C X-2** : second exemplaire, à postcombustion, seul survivant\n- **Six réacteurs** : quatre basculants en bout d''aile, deux verticaux dans le fuselage\n- Franchit **Mach 1,04 le 29 juillet 1964** : premier ADAV supersonique de l''histoire\n- Devait aboutir au **VJ 101D**, chasseur de série qui n''a jamais été lancé',
  variants_en       = E'- **VJ 101C X-1** : first prototype, destroyed in 1964 by a wiring error\n- **VJ 101C X-2** : second aircraft, with afterburners, the only survivor\n- **Six engines**: four tilting at the wingtips, two vertical in the fuselage\n- Passed **Mach 1.04 on 29 July 1964**: the first supersonic VTOL in history\n- Was to lead to the **VJ 101D** production fighter, which was never launched',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/EWR_VJ_101',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/EWR_VJ_101',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jmcc150 at English Wikipedia',
  image_licence     = 'Public domain'
WHERE name = 'EWR VJ 101';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'EWR VJ 101';
