-- Fairey Firefly
--
-- Photo : Fairey Firefly AS Mk. 6.jpg
--   licence CC BY-SA 2.0 — Ken Mist from Brampton, Canada
--   https://commons.wikimedia.org/wiki/File%3AFairey_Firefly_AS_Mk._6.jpg

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
    'Fairey Firefly',
    'Fairey Firefly',
    'Fairey Firefly',
    'Fairey Firefly',
    'Chasseur embarqué biplace dont la deuxième guerre fut la Corée',
    'Two-seat carrier fighter whose second war was Korea',
    '/assets/airplanes/fairey-firefly.jpg',
    E'## Genèse\nLa Fleet Air Arm britannique a une conviction que personne ne partage : au-dessus de la mer, un chasseur doit emporter **un navigateur**. Sans repère au sol, retrouver son porte-avions après un combat relève de l''exploit, et le pilote seul y échoue souvent. Fairey conçoit donc en 1939 un chasseur biplace, plus lourd et plus lent que ses contemporains terrestres, mais capable de rentrer.\n\n## Conception\nMoteur Griffon de deux mille chevaux, aile repliable, et une particularité rare : des **volets Youngman** rétractables qui se déploient non seulement à l''atterrissage mais aussi en virage de combat, augmentant la portance sans traînée excessive. L''observateur occupe un poste séparé, derrière l''aile, avec sa propre verrière.\n\n## Carrière opérationnelle\nIl attaque le cuirassé *Tirpitz* en Norvège, détruit les raffineries de Sumatra, puis survit à la guerre — ce qui est rare pour un appareil de 1941. Sa seconde carrière est coréenne : depuis les porte-avions britanniques et australiens, les Firefly effectuent des milliers de sorties d''attaque au sol contre les lignes nord-coréennes, à une époque où les MiG-15 volent deux fois plus vite qu''eux.\n\n## Place dans l''histoire\nMille sept cent deux exemplaires et quatorze ans de production. Il incarne une idée britannique restée minoritaire — l''équipage à deux pour l''aéronavale — que la **Sea Vixen** puis le Phantom reprendront à l''ère du radar, quand l''opérateur ne servira plus à naviguer mais à voir. Son successeur direct chez Fairey est le **Gannet**, qui pousse la logique jusqu''à trois hommes.',
    E'## Genesis\nBritain''s Fleet Air Arm held a conviction nobody else shared: over the sea, a fighter should carry **a navigator**. With no landmarks, finding your carrier again after a fight is a feat, and the solo pilot often failed at it. In 1939 Fairey therefore designed a two-seat fighter, heavier and slower than its land-based contemporaries, but able to get home.\n\n## Design\nA two-thousand-horsepower Griffon engine, folding wings, and one rare feature: retractable **Youngman flaps** that deploy not only for landing but in combat turns, raising lift without excessive drag. The observer sits in a separate station behind the wing, under his own canopy.\n\n## Operational career\nIt attacked the battleship *Tirpitz* in Norway, destroyed the Sumatra refineries, then survived the war — rare for a 1941 design. Its second career was Korean: from British and Australian carriers, Fireflies flew thousands of ground attack sorties against North Korean lines, at a time when MiG-15s flew twice as fast as they did.\n\n## Place in history\nOne thousand seven hundred and two built over fourteen years of production. It embodies a British idea that stayed in the minority — the two-man naval crew — which the **Sea Vixen** and then the Phantom would take up in the radar age, when the operator would no longer navigate but see. Its direct Fairey successor is the **Gannet**, which pushes the logic to three men.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1939-01-01',
    '1941-12-22',
    '1943-10-01',
    618.0,
    2090.0,
    (SELECT id FROM manufacturer WHERE code = 'FAI'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.56,
  wingspan          = 13.56,
  height            = 4.37,
  wing_area         = 30.5,
  empty_weight      = 4388,
  mtow              = 7000,
  service_ceiling   = 8500,
  climb_rate        = 8.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Griffon 74',
  engine_count      = 1,
  engine_type       = 'Moteur en V',
  engine_type_en    = 'V engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1942,
  production_end    = 1956,
  units_built       = 1702,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **Firefly Mk I** : chasseur-reconnaissance biplace initial\n- **Firefly FR.4 / AS.6** : versions d''après-guerre, lutte anti-sous-marine\n- **Firefly AS.7** : dernière version, cellule redessinée\n- **Firefly U.9** : convertie en **drone cible** téléguidé pour les essais de missiles\n- Exploité par les marines **australienne**, **canadienne**, **néerlandaise** et indienne',
  variants_en       = E'- **Firefly Mk I** : initial two-seat fighter-reconnaissance version\n- **Firefly FR.4 / AS.6** : post-war versions for anti-submarine work\n- **Firefly AS.7** : final version, with a redesigned airframe\n- **Firefly U.9** : converted into a radio-controlled **target drone** for missile trials\n- Flown by the **Australian**, **Canadian**, **Dutch** and Indian navies',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fairey_Firefly',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fairey_Firefly',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ken Mist from Brampton, Canada',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Fairey Firefly';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fairey Firefly';
