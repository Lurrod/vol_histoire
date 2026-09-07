-- Lockheed F-94 Starfire
--
-- Photo : F-94 North Dakota ANG in flight 1950s.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3AF-94_North_Dakota_ANG_in_flight_1950s.jpg

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
    'F-94 Starfire',
    'F-94 Starfire',
    'Lockheed F-94 Starfire',
    'Lockheed F-94 Starfire',
    'Premier intercepteur américain à postcombustion, né d’un avion-école',
    'First American afterburning interceptor, born from a training aircraft',
    '/assets/airplanes/f94-starfire.jpg',
    E'## Genèse\nEn 1948, l''US Air Force n''a aucun chasseur de nuit à réaction et les Soviétiques viennent de faire voler le MiG-15. Le programme F-89 traîne. Lockheed propose alors la solution la plus rapide possible : reprendre le biplace **T-33**, y loger un radar dans le nez et une postcombustion à l''arrière. Onze mois séparent la commande du premier vol.\n\n## Conception\nTrois générations partagent la même cellule : le **F-80** chasseur, le **T-33** école, le F-94 intercepteur. L''ajout d''un radar APG-33 et d''un opérateur allonge le nez et déplace le centrage ; la postcombustion, première sur un avion de série américain, compense la masse. La version C va plus loin : elle supprime les mitrailleuses et loge **vingt-quatre roquettes** dans un anneau autour du radar, tirées en salve unique.\n\n## Carrière opérationnelle\nIl tient l''alerte de nuit sur le continent américain, puis part en **Corée** en 1951. Le 30 janvier 1953, un F-94B abat un appareil nord-coréen : première victoire nocturne à réaction de l''US Air Force. La consigne interdisait toutefois de survoler le territoire ennemi, de peur qu''un radar APG-33 ne tombe entre les mains soviétiques.\n\n## Place dans l''histoire\nHuit cent cinquante-cinq exemplaires. Il illustre une pratique devenue rare : produire un intercepteur en dix-huit mois en dérivant un avion-école. Le **F-102 Delta Dagger**, conçu de zéro avec son système d''armes, mettra sept ans — et coûtera dix fois plus.',
    E'## Genesis\nIn 1948 the US Air Force had no jet night fighter and the Soviets had just flown the MiG-15. The F-89 programme was dragging. Lockheed proposed the fastest possible answer: take the two-seat **T-33**, fit a radar in the nose and an afterburner at the back. Eleven months separated the order from the first flight.\n\n## Design\nThree generations share one airframe: the **F-80** fighter, the **T-33** trainer, the F-94 interceptor. Adding an APG-33 radar and an operator lengthened the nose and moved the centre of gravity; the afterburner, a first on an American production aircraft, offset the weight. The C model went further: it deleted the guns and packed **twenty-four rockets** into a ring around the radar, fired in a single salvo.\n\n## Operational career\nIt stood night alert over the American continent, then went to **Korea** in 1951. On 30 January 1953 an F-94B shot down a North Korean aircraft: the US Air Force''s first jet night victory. Standing orders nevertheless forbade flying over enemy territory, for fear an APG-33 radar might fall into Soviet hands.\n\n## Place in history\nEight hundred and fifty-five built. It illustrates a practice that has become rare: fielding an interceptor in eighteen months by deriving it from a trainer. The **F-102 Delta Dagger**, designed from scratch around its weapons system, would take seven years — and cost ten times as much.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1948-03-01',
    '1949-04-16',
    '1950-05-01',
    1030.0,
    1300.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-94 Starfire'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F-94 Starfire'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'F-94 Starfire'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-94 Starfire'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'F-94 Starfire'), (SELECT id FROM armement WHERE name = 'FFAR Mighty Mouse'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-94 Starfire'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-94 Starfire'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-94 Starfire'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'F-94 Starfire'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.56,
  wingspan          = 11.43,
  height            = 4.55,
  wing_area         = 21.63,
  empty_weight      = 5764,
  mtow              = 11340,
  service_ceiling   = 15665,
  climb_rate        = 40.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J48-P-5',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 28.9,
  thrust_wet        = 38.3,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1954,
  units_built       = 855,
  unit_cost_usd     = 534000,
  unit_cost_year    = 1953,
  operators_count   = 1,
  variants          = E'- **F-94A / B** : versions initiales, quatre mitrailleuses de 12,7 mm dans le nez\n- **F-94C** : refonte complète, canon remplacé par **vingt-quatre roquettes** en anneau\n- Dérivé du **T-33**, lui-même dérivé du F-80 : trois générations d''une même cellule\n- Premier avion de série américain doté d''une **postcombustion**\n- Le 30 janvier 1953, un F-94B remporte la première victoire nocturne à réaction de l''USAF',
  variants_en       = E'- **F-94A / B** : initial versions with four 12.7 mm machine guns in the nose\n- **F-94C** : complete redesign, guns replaced by **twenty-four rockets** in a nose ring\n- Derived from the **T-33**, itself derived from the F-80: three generations of one airframe\n- First American production aircraft fitted with an **afterburner**\n- On 30 January 1953 an F-94B scored the USAF''s first jet night victory',

  -- Strate 4 : qualitatif
  nickname          = 'Starfire',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_F-94_Starfire',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_F-94_Starfire',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'F-94 Starfire';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-94 Starfire';
