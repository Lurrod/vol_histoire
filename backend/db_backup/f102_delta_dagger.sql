-- Convair F-102 Delta Dagger
--
-- Photo : 431st Fighter-Interceptor Squadron Convair F-102 Delta Dagger 55-0983 over Med.jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany
--   https://commons.wikimedia.org/wiki/File%3AConvair_F-102_Delta_Dagger_%286586494353%29.jpg

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
    'F-102 Delta Dagger',
    'F-102 Delta Dagger',
    'Convair F-102 Delta Dagger',
    'Convair F-102 Delta Dagger',
    'Premier intercepteur à aile delta et à armement tout-missile',
    'First delta-wing, all-missile armed interceptor',
    '/assets/airplanes/f102-delta-dagger.jpg',
    E'## Genèse\nConçu pour intercepter les bombardiers soviétiques au-dessus du pôle, le F-102 devait être le premier élément d''un système complet : l''avion, son radar, ses missiles et le réseau de conduite au sol **SAGE** ne formaient qu''un seul programme. C''est le premier chasseur américain à ne porter **aucun canon**.\n\n## Conception\nLe prototype est un échec : incapable de dépasser Mach 1 malgré son aile delta. Convair applique alors la **loi des aires** de Richard Whitcomb et pince la taille du fuselage — la fameuse silhouette en bouteille de Coca-Cola. L''appareil redessiné passe Mach 1 dès son premier vol. Ses missiles sont logés dans une soute ventrale, préservant l''aérodynamique.\n\n## Carrière opérationnelle\nUn millier d''exemplaires arment la défense aérienne du continent nord-américain pendant près de vingt ans. Déployé au **Vietnam** pour l''escorte de bombardiers et quelques missions d''appui, il n''y remporte aucune victoire aérienne. La Turquie et la Grèce en reçoivent en fin de carrière.\n\n## Place dans l''histoire\nLe F-102 est le premier avion pensé comme un **sous-ensemble d''un système d''armes** plutôt que comme une machine autonome — une approche qui deviendra la norme. Son échec initial reste le cas d''école le plus cité de l''application de la loi des aires.',
    E'## Genesis\nDesigned to intercept Soviet bombers over the pole, the F-102 was meant to be one element of a complete system: the aircraft, its radar, its missiles and the **SAGE** ground control network formed a single programme. It was the first American fighter to carry **no gun at all**.\n\n## Design\nThe prototype failed: it could not exceed Mach 1 despite its delta wing. Convair then applied Richard Whitcomb’s **area rule** and pinched the fuselage waist — the famous Coke-bottle shape. The redesigned aircraft went supersonic on its first flight. Its missiles sit in a ventral bay, preserving the aerodynamics.\n\n## Operational career\nA thousand aircraft manned North American air defence for nearly twenty years. Deployed to **Vietnam** for bomber escort and a few support missions, it scored no aerial victories. Turkey and Greece received them late in their career.\n\n## Place in history\nThe F-102 was the first aircraft conceived as a **subsystem of a weapons system** rather than a standalone machine — an approach that became the norm. Its initial failure remains the most-cited textbook case of the area rule.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1950-01-01',
    '1953-10-24',
    '1956-04-01',
    1304.0,
    2175.0,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), (SELECT id FROM armement WHERE name = 'AIM-4 Falcon')),
((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.83,
  wingspan          = 11.61,
  height            = 6.46,
  wing_area         = 61.5,
  empty_weight      = 8777,
  mtow              = 14300,
  service_ceiling   = 16300,
  climb_rate        = 66,
  g_limit_pos       = 7.33,
  g_limit_neg       = NULL,
  combat_radius     = 800,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J57-P-25',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 51.6,
  thrust_wet        = 76.6,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1958,
  units_built       = 1000,
  unit_cost_usd     = 1200000,
  unit_cost_year    = 1955,
  operators_count   = 3,
  variants          = E'- **YF-102** : prototype incapable de passer Mach 1, refondu selon la loi des aires\n- **F-102A** : version de série\n- **TF-102A** : biplace côte à côte de conversion\n- **QF-102 / PQM-102** : cellules converties en drones-cibles',
  variants_en       = E'- **YF-102** : prototype unable to exceed Mach 1, redesigned with area ruling\n- **F-102A** : production version\n- **TF-102A** : side-by-side two-seat conversion trainer\n- **QF-102 / PQM-102** : airframes converted into target drones',

  -- Strate 4 : qualitatif
  nickname          = 'Deuce',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_F-102_Delta_Dagger',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_F-102_Delta_Dagger',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'United States Air Force Photo',
  image_licence     = 'Public domain'
WHERE name = 'F-102 Delta Dagger';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-102 Delta Dagger';
