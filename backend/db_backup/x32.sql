-- Boeing X-32A / X-32B
--
-- Photo : USAF X32B 250.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3AUSAF_X32B_250.jpg

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
    'Boeing X-32',
    'Boeing X-32',
    'Boeing X-32A / X-32B',
    'Boeing X-32A / X-32B',
    'Le finaliste du JSF, perdu pour une bouche d’entrée d’air',
    'The JSF finalist, lost over an air intake',
    '/assets/airplanes/x32.jpg',
    E'## Genèse\nLe **Joint Strike Fighter** cherche l''impossible : un seul appareil pour l''Air Force, la Navy et les Marines, donc à la fois classique, embarqué et à décollage court. Le mot d''ordre est le coût. Boeing, qui n''a jamais conçu de chasseur furtif seul, en fait son argument central : une cellule aussi simple que possible.\n\n## Conception\nD''où une **aile delta d''un seul tenant** en composite, sans dièdre ni assemblage complexe, et une **entrée d''air ventrale unique** placée sous le nez. Pour la version ADAV, Boeing reprend la solution du Harrier — dévier directement les gaz vers le bas — plutôt que la soufflante entraînée de son concurrent. C''est plus simple, mais moins performant, et cela impose une bouche d''air béante qui donne à l''appareil sa silhouette si commentée.\n\n## Carrière opérationnelle\nAucune. Deux démonstrateurs, environ deux cents vols en 2000 et 2001. Le X-32B parvient à décoller court et à se poser à la verticale, mais il doit être **modifié entre les deux campagnes** — il ne peut pas démontrer le vol supersonique et le vol stationnaire dans la même configuration. Le X-35 de Lockheed, lui, y parvient en une seule sortie.\n\n## Place dans l''histoire\nDeux exemplaires. Le **26 octobre 2001**, le Pentagone choisit le X-35, qui devient le **F-35 Lightning II** et le programme d''armement le plus cher de l''histoire. Boeing, écarté du chasseur de cinquième génération, se rabattra sur le **Super Hornet** et attendra vingt ans le F-47 pour revenir dans la course.',
    E'## Genesis\nThe **Joint Strike Fighter** sought the impossible: one aircraft for the Air Force, the Navy and the Marines, at once conventional, carrier-capable and short take-off. The watchword was cost. Boeing, which had never designed a stealth fighter on its own, made that its central argument: an airframe as simple as possible.\n\n## Design\nHence a **one-piece composite delta wing**, with no dihedral or complex joints, and a **single ventral intake** under the nose. For the STOVL version Boeing took the Harrier''s route — deflect the gas straight down — rather than its rival''s shaft-driven lift fan. Simpler, but less capable, and it forced the gaping intake that gave the aircraft its much-discussed look.\n\n## Operational career\nNone. Two demonstrators, some two hundred flights in 2000 and 2001. The X-32B managed short take-offs and vertical landings, but had to be **modified between the two campaigns** — it could not demonstrate supersonic flight and hovering in the same configuration. Lockheed''s X-35 did both in a single sortie.\n\n## Place in history\nTwo built. On **26 October 2001** the Pentagon chose the X-35, which became the **F-35 Lightning II** and the most expensive weapons programme in history. Boeing, shut out of the fifth generation, fell back on the **Super Hornet** and waited twenty years for the F-47 to return to the race.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1996-11-01',
    '2000-09-18',
    NULL,
    1930.0,
    1500.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing X-32'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Boeing X-32'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Boeing X-32'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing X-32'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Boeing X-32'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Boeing X-32'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.72,
  wingspan          = 10.97,
  height            = 4.0,
  wing_area         = 55.7,
  empty_weight      = 10900,
  mtow              = 17200,
  service_ceiling   = 15240,
  climb_rate        = NULL,
  g_limit_pos       = 7.0,
  g_limit_neg       = NULL,
  combat_radius     = 1000,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney YF119-PW-614',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion et poussée vectorielle',
  engine_type_en    = 'Afterburning turbofan with thrust vectoring',
  thrust_dry        = 125.0,
  thrust_wet        = 191.0,

  -- Strate 3 : production & service
  production_start  = 1997,
  production_end    = 2000,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **X-32A** : démonstrateur conventionnel et embarqué, premier vol en septembre 2000\n- **X-32B** : démonstrateur ADAV, à poussée orientée directe comme le Harrier\n- Aile **delta d''un seul tenant** en composite, pensée pour la simplicité de fabrication\n- Opposé au **X-35** de Lockheed Martin, qui remporte le contrat le 26 octobre 2001\n- Aucun des deux exemplaires n''a jamais volé dans la configuration finale proposée',
  variants_en       = E'- **X-32A** : conventional and carrier demonstrator, first flew September 2000\n- **X-32B** : STOVL demonstrator, using direct-lift thrust like the Harrier\n- **One-piece delta** composite wing, conceived for manufacturing simplicity\n- Faced Lockheed Martin''s **X-35**, which won the contract on 26 October 2001\n- Neither aircraft ever flew in the final proposed configuration',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_X-32',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_X-32',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'Boeing X-32';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'Boeing X-32';
