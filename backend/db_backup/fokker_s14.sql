-- Fokker S.14 Machtrainer
--
-- Photo : Fokker S-14 Machtrainer (c-n 6289, PH-XIV) 2007-06-21 Andre Gerwing Collection ID 008471.jpg
--   licence CC BY-SA 4.0 — André Gerwing
--   https://commons.wikimedia.org/wiki/File%3AFokker_S-14_Machtrainer_%28c-n_6289%2C_PH-XIV%29_2007-06-21_Andre_Gerwing_Collection_ID_008471.jpg

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
    'Fokker S.14 Machtrainer',
    'Fokker S.14 Machtrainer',
    'Fokker S.14 Machtrainer',
    'Fokker S.14 Machtrainer',
    'Premier avion-école à réaction conçu en Europe',
    'The first jet trainer designed in Europe',
    '/assets/airplanes/fokker-s14.jpg',
    E'## Genèse\nLes Pays-Bas sortent de l''occupation avec une industrie aéronautique à reconstruire et une aviation militaire à rééquiper. Fokker, qui était avant guerre l''un des grands noms européens, veut revenir par une porte que personne n''a encore franchie : l''**avion-école à réaction**. En 1947, aucun n''existe — on forme les pilotes de jet sur des appareils à hélices.\n\n## Conception\nLe choix pédagogique commande tout le dessin. Fokker place les deux sièges **côte à côte** et non en tandem, pour que l''instructeur voie ce que fait l''élève de ses mains. Il en résulte un fuselage large, une verrière en bulbe et un réacteur Derwent relégué derrière le cockpit, alimenté par des entrées d''air d''emplanture. L''appareil est lent — 730 km/h — mais docile, ce qui est exactement l''objectif.\n\n## Carrière opérationnelle\nVingt et un exemplaires, tous néerlandais, en service de 1955 à 1967. Ils forment l''ensemble des pilotes de chasse du pays pendant douze ans, le temps que la Koninklijke Luchtmacht passe du Meteor au **F-104 Starfighter**. Fokker cherche à l''exporter, notamment au Brésil : aucun contrat ne se conclut.\n\n## Place dans l''histoire\nVingt et un exemplaires. Le S.14 vole quatre ans avant le **Jet Provost** britannique et six ans avant le **T-37** américain — mais un marché national de vingt appareils ne finance pas une gamme. Fokker abandonnera ensuite les appareils militaires conçus en propre pour se concentrer sur l''aviation régionale.',
    E'## Genesis\nThe Netherlands came out of occupation with an aircraft industry to rebuild and an air force to re-equip. Fokker, one of the great European names before the war, wanted to return through a door nobody had yet opened: the **jet trainer**. In 1947 none existed — jet pilots were trained on propeller aircraft.\n\n## Design\nThe teaching choice governs the whole layout. Fokker put the two seats **side by side** rather than in tandem, so the instructor could see what the pupil''s hands were doing. The result is a wide fuselage, a bulbous canopy and a Derwent engine pushed behind the cockpit, fed by wing-root intakes. The aircraft is slow — 730 km/h — but docile, which is exactly the point.\n\n## Operational career\nTwenty-one aircraft, all Dutch, in service from 1955 to 1967. They trained every fighter pilot in the country for twelve years, while the Koninklijke Luchtmacht moved from the Meteor to the **F-104 Starfighter**. Fokker tried to export it, notably to Brazil: no contract was signed.\n\n## Place in history\nTwenty-one built. The S.14 flew four years before the British **Jet Provost** and six before the American **T-37** — but a home market of twenty aircraft does not fund a product line. Fokker would afterwards give up designing its own military aircraft and concentrate on regional airliners.',
    (SELECT id FROM countries WHERE code = 'NLD'),
    '1947-01-01',
    '1951-05-19',
    '1955-01-01',
    730.0,
    970.0,
    (SELECT id FROM manufacturer WHERE code = 'FOK'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fokker S.14 Machtrainer'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fokker S.14 Machtrainer'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Fokker S.14 Machtrainer'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.3,
  wingspan          = 12.0,
  height            = 4.6,
  wing_area         = 30.0,
  empty_weight      = 3820,
  mtow              = 5300,
  service_ceiling   = 12000,
  climb_rate        = 13.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Derwent 8',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 15.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1958,
  units_built       = 21,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **S.14** : vingt exemplaires de série plus le prototype, tous néerlandais\n- Places **côte à côte**, pour que l''instructeur voie les mains de l''élève\n- Réacteur logé **derrière le cockpit**, entrées d''air à l''emplanture\n- Premier avion-école à réaction **conçu** en Europe, avant le Jet Provost\n- Retiré en 1967 : les Pays-Bas passent au **Lockheed T-33** américain',
  variants_en       = E'- **S.14** : twenty production aircraft plus the prototype, all Dutch\n- **Side-by-side** seating, so the instructor can see the pupil''s hands\n- Engine mounted **behind the cockpit**, intakes at the wing root\n- The first jet trainer **designed** in Europe, ahead of the Jet Provost\n- Withdrawn in 1967: the Netherlands moved to the American **Lockheed T-33**',

  -- Strate 4 : qualitatif
  nickname          = 'Machtrainer',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fokker_S.14_Machtrainer',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fokker_S.14_Machtrainer',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'André Gerwing',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Fokker S.14 Machtrainer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fokker S.14 Machtrainer';
