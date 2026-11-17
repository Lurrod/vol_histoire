-- FMA I.Ae. 27 Pulqui I
--
-- Photo : Pulqui27.jpg
--   licence CC BY-SA 3.0 — Aeroprints.com
--   https://commons.wikimedia.org/wiki/File:Pulqui27.jpg

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
    'IAe 27 Pulqui I',
    'IAe 27 Pulqui I',
    'FMA I.Ae. 27 Pulqui I',
    'FMA I.Ae. 27 Pulqui I',
    'Premier avion à réaction conçu et construit en Amérique latine, prototype unique de 1947',
    'First jet aircraft designed and built in Latin America, a single 1947 prototype',
    '/assets/airplanes/pulqui-1.jpg',
    E'## Genèse\nAu lendemain de la Seconde Guerre mondiale, l''Argentine veut entrer d''emblée dans l''ère du réacteur. En 1946, l''**Instituto Aerotécnico** lance l''étude d''un chasseur à réaction national. L''équipe est dirigée par l''ingénieur français **Émile Dewoitine**, entouré des ingénieurs **Juan Ignacio San Martín**, Enrique Cardeilhac, Cesare Pallavicino et Norberto L. Morchio. Le projet prend le nom d''**I.Ae. 27 Pulqui**, le premier d''une courte lignée de chasseurs argentins.\n\n## Conception\nLe Pulqui I est un monoplan à aile droite, au fuselage semi-monocoque de section elliptique. Son réacteur unique, un **Rolls-Royce Derwent 5** britannique de 16 kN, est alimenté par une entrée d''air dans le nez, dont les conduits contournent le poste de pilotage. Ce choix réduit le volume disponible dans le fuselage : le carburant doit être logé dans les ailes, ce qui ampute nettement l''autonomie. Quatre canons de 20 mm et des bombes ou roquettes sous les ailes sont prévus pour la version opérationnelle, mais jamais installés sur le prototype. L''aile, d''abord à bouts arrondis, est ensuite raccourcie et dotée de saumons carrés.\n\n## Essais\nLe prototype vole pour la première fois le 9 août 1947, aux mains du lieutenant **Osvaldo Weiss**. Sa carrière se limite aux essais et à l''évaluation de cet unique exemplaire. Ses performances sont jugées insuffisantes, et les études d''un appareil bien plus ambitieux, l''**IAe 33 Pulqui II** à aile en flèche, sont déjà avancées : le Pulqui I n''a pas de suite. Restauré, il est aujourd''hui exposé au musée national d''Aéronautique de l''armée de l''air argentine, à Morón, près de Buenos Aires.\n\n## Place dans l''histoire\nMalgré son échec, le Pulqui I occupe une place à part : c''est le premier avion à réaction conçu et construit en Argentine et dans toute l''Amérique latine. Il fait de l''Argentine le cinquième pays au monde à mettre au point par ses propres moyens un avion de combat à réaction, deux ans seulement après la fin de la guerre. Dépassé par son aile droite avant même d''avoir volé, il a surtout servi de banc d''apprentissage à l''équipe qui allait concevoir le Pulqui II.',
    E'## Genesis\nIn the aftermath of the Second World War, Argentina wanted to enter the jet age straight away. In 1946 the **Instituto Aerotécnico** began studying a domestic jet fighter. The team was led by the French engineer **Émile Dewoitine**, alongside the engineers **Juan Ignacio San Martín**, Enrique Cardeilhac, Cesare Pallavicino and Norberto L. Morchio. The project was named the **I.Ae. 27 Pulqui**, the first of a short line of Argentine fighters.\n\n## Design\nThe Pulqui I was a straight-wing monoplane with a semi-monocoque fuselage of elliptical cross-section. Its single engine, a British 16 kN **Rolls-Royce Derwent 5**, was fed by a nose intake whose ducts ran around the cockpit. That choice reduced the internal fuselage volume: fuel had to be carried in the wings, which cut range significantly. Four 20 mm cannon and underwing bombs or rockets were planned for an operational version, but never fitted to the prototype. The wing, initially with rounded tips, was later shortened and given squared tips.\n\n## Testing\nThe prototype first flew on 9 August 1947, flown by Lieutenant **Osvaldo Weiss**. Its career was limited to testing and evaluation of this single example. Its performance was judged unsatisfactory, and studies for a far more ambitious design, the swept-wing **IAe 33 Pulqui II**, were already well advanced: the Pulqui I had no sequel. Restored, it is now displayed at the Argentine Air Force''s National Aeronautics Museum at Morón, near Buenos Aires.\n\n## Place in history\nDespite its failure, the Pulqui I holds a special place: it was the first jet aircraft designed and built in Argentina and in all of Latin America. It made Argentina the fifth country in the world to develop a jet combat aircraft by its own means, only two years after the end of the war. Outdated by its straight wing before it even flew, it served above all as a learning platform for the team that would design the Pulqui II.',
    (SELECT id FROM countries WHERE code = 'ARG'),
    '1946-01-01',
    '1947-08-09',
    NULL,
    720,
    900,
    (SELECT id FROM manufacturer WHERE code = 'FMA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAe 27 Pulqui I'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.69,
  wingspan          = 11.25,
  height            = 3.39,
  wing_area         = 19.7,
  empty_weight      = 2358,
  mtow              = 3600,
  service_ceiling   = 15500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Derwent 5',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 16,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **I.Ae. 27 Pulqui I (version initiale)** : aile de 11,25 m d''envergure à bouts arrondis\n- **I.Ae. 27 Pulqui I (version finale)** : aile raccourcie à 10,50 m, saumons carrés\n- **Version armée** : projet à quatre canons de 20 mm, bombes ou roquettes sous les ailes, jamais réalisé',
  variants_en       = E'- **I.Ae. 27 Pulqui I (initial version)**: 11.25 m span wing with rounded tips\n- **I.Ae. 27 Pulqui I (final version)**: wing shortened to 10.50 m, squared tips\n- **Armed version**: project with four 20 mm cannon and underwing bombs or rockets, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/I.Ae._27_Pulqui_I',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/FMA_I.Ae._27_Pulqui_I',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Aeroprints.com',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'IAe 27 Pulqui I';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAe 27 Pulqui I';
