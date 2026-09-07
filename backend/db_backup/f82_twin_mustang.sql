-- North American F-82 Twin Mustang
--
-- Photo : 68th FAWS North American P-82G Twin Mustang 46-401 -2.jpg
--   licence Public domain — auteur non renseigné
--   

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
    'F-82 Twin Mustang',
    'F-82 Twin Mustang',
    'North American F-82 Twin Mustang',
    'North American F-82 Twin Mustang',
    'Deux Mustang soudés, auteur de la première victoire de la guerre de Corée',
    'Two Mustangs joined together, scorer of the Korean War’s first victory',
    '/assets/airplanes/f82-twin-mustang.jpg',
    E'## Genèse\nEn 1943, les bombardiers américains traversent le Pacifique sur des distances qu''aucun chasseur d''escorte ne peut suivre — et un pilote seul ne tient pas huit heures aux commandes. North American propose une réponse littérale : **prendre deux P-51 Mustang et les relier** par une aile centrale et un empennage commun. Deux pilotes, qui se relaient ; deux moteurs, pour la sécurité.\n\n## Conception\nCe n''est pas un assemblage de pièces existantes — les deux fuselages sont allongés et redessinés — mais la parenté saute aux yeux. Chaque cockpit peut piloter seul ; en version chasse de nuit, le poste droit devient celui de l''opérateur radar, et une **nacelle radar** est suspendue sous l''aile centrale. Les moteurs Allison, choisis pour des raisons de licence, se révéleront moins bons que les Merlin du Mustang d''origine.\n\n## Carrière opérationnelle\nIl arrive après la guerre pour laquelle il avait été conçu. Le **27 juin 1950**, deux jours après l''invasion du Sud, le lieutenant William Hudson abat un Yak-11 au-dessus de Séoul : **première victoire aérienne de la guerre de Corée**, remportée par un chasseur à hélices. Le F-82 assure ensuite l''escorte et l''attaque de nuit jusqu''à l''arrivée des F-94.\n\n## Place dans l''histoire\nDeux cent soixante-douze exemplaires. Il est **le dernier chasseur à hélices commandé en série par l''US Air Force** — et le seul chasseur bifuselage jamais produit. En 1947, l''exemplaire *Betty Jo* relie Hawaï à New York sans escale, huit mille cent vingt-neuf kilomètres, record qui tient encore pour un chasseur à hélices.',
    E'## Genesis\nIn 1943 American bombers were crossing the Pacific over distances no escort fighter could follow — and one pilot cannot hold the controls for eight hours. North American''s answer was literal: **take two P-51 Mustangs and join them** with a centre wing and a common tail. Two pilots, taking turns; two engines, for safety.\n\n## Design\nIt is not an assembly of existing parts — both fuselages were lengthened and redrawn — but the parentage is unmistakable. Either cockpit can fly the aircraft; in night fighter form the right seat becomes the radar operator''s, and a **radar pod** hangs under the centre wing. The Allison engines, chosen for licensing reasons, would prove inferior to the original Mustang''s Merlins.\n\n## Operational career\nIt arrived after the war it had been designed for. On **27 June 1950**, two days after the invasion of the South, Lieutenant William Hudson shot down a Yak-11 over Seoul: the **first air victory of the Korean War**, won by a propeller fighter. The F-82 then flew escort and night attack until the F-94s arrived.\n\n## Place in history\nTwo hundred and seventy-two built. It is **the last propeller fighter ordered into production by the US Air Force** — and the only twin-fuselage fighter ever built. In 1947 the aircraft *Betty Jo* flew Hawaii to New York non-stop, eight thousand one hundred and twenty-nine kilometres, a record that still stands for a propeller fighter.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1943-10-01',
    '1945-06-15',
    '1946-03-01',
    742.0,
    3605.0,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-82 Twin Mustang'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F-82 Twin Mustang'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-82 Twin Mustang'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'F-82 Twin Mustang'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'F-82 Twin Mustang'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-82 Twin Mustang'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-82 Twin Mustang'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'F-82 Twin Mustang'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-82 Twin Mustang'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'F-82 Twin Mustang'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.93,
  wingspan          = 15.62,
  height            = 4.22,
  wing_area         = 37.9,
  empty_weight      = 6890,
  mtow              = 11632,
  service_ceiling   = 11855,
  climb_rate        = 19.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1300,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Allison V-1710-143/145',
  engine_count      = 2,
  engine_type       = 'Moteur en V',
  engine_type_en    = 'V engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1949,
  units_built       = 272,
  unit_cost_usd     = 215154,
  unit_cost_year    = 1948,
  operators_count   = 1,
  variants          = E'- **P-82B** : version d''escorte à très long rayon d''action, deux pilotes\n- **F-82F / G** : chasseurs de nuit, **radar en nacelle centrale** sous l''aile\n- **F-82H** : version arctique, exploitée en Alaska\n- *Betty Jo* relie **Hawaï à New York sans escale** en 1947 : 8 129 km, record\n- Dernier chasseur à hélices commandé en série par l''US Air Force',
  variants_en       = E'- **P-82B** : very long range escort version, with two pilots\n- **F-82F / G** : night fighters, with a **radar pod on the wing centreline**\n- **F-82H** : Arctic version, flown in Alaska\n- *Betty Jo* flew **Hawaii to New York non-stop** in 1947: 8,129 km, a record\n- The last propeller fighter ordered into production by the US Air Force',

  -- Strate 4 : qualitatif
  nickname          = 'Twin Mustang',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_F-82_Twin_Mustang',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_F-82_Twin_Mustang',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'F-82 Twin Mustang';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-82 Twin Mustang';
