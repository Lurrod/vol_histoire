-- Rolls-Royce Thrust Measuring Rig
--
-- Photo : Rolls-Royce Flying Bedstead (1954) Science Museum London 2026-03-30.jpg
--   licence CC BY 4.0 — Andrew Bone
--   https://commons.wikimedia.org/wiki/File:Rolls-Royce_Flying_Bedstead_(1954)_Science_Museum_London_2026-03-30.jpg

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
    'Rolls-Royce Thrust Measuring Rig',
    'Rolls-Royce Thrust Measuring Rig',
    'Rolls-Royce Thrust Measuring Rig',
    'Rolls-Royce Thrust Measuring Rig',
    'Deux réacteurs Nene dans un cadre d''acier : le premier engin au monde à voler porté par ses seuls jets',
    'Two Nene jets in a steel frame: the first jet-lift aircraft to fly anywhere in the world',
    '/assets/airplanes/rr-flying-bedstead.jpg',
    E'## Genèse\nLe père du projet est le **Dr Alan Arnold Griffith**, spécialiste des turbines à gaz au **Royal Aircraft Establishment** (RAE) dans les années 1920, entré chez **Rolls-Royce** en 1939. Dans les années 1940, il imagine d''utiliser la poussée des réacteurs pour soulever directement un avion et propose de construire une machine de recherche pour l''étudier. Rolls-Royce, désireux d''exploiter sa nouvelle gamme de réacteurs, la fait construire à **Hucknall**, dans le Nottinghamshire, tandis que le RAE en fournit le stabilisateur automatique. Deux exemplaires de ce **Thrust Measuring Rig** sont construits.\n\n## Conception\nL''engin n''a ni aile ni empennage : deux turboréacteurs **Rolls-Royce Nene** sont montés dos à dos à l''horizontale dans un cadre tubulaire en acier posé sur quatre pieds à roulettes, le pilote assis sur une plate-forme au sommet. Les jets sont renvoyés vers le bas, au centre de gravité, par une tuyère centrale pour l''un et deux tuyères latérales pour l''autre, afin qu''une panne de moteur ne fasse pas basculer la machine. Quatre bras soufflent de l''air comprimé pour le contrôle en roulis, tangage et lacet ; tangage et roulis sont commandés électriquement, sans secours mécanique. Avec un rapport poussée/poids de 1,08, l''autonomie ne dépasse pas six minutes, et cette allure de sommier lui vaut le surnom de **Flying Bedstead**.\n\n## Essais\nLe premier exemplaire, **XJ314**, vole le 19 août 1953 à Hucknall, retenu par un portique qui limite ses déplacements et sa vitesse de descente. Le 3 août 1954, le chef pilote d''essai **Ronald Thomas Shepherd** réussit le premier vol libre. Fin 1954, l''engin passe au RAE, à Farnborough puis à Bedford en juin 1956, où l''on étudie le besoin d''une stabilisation artificielle. Les pilotes peinent surtout à tenir leur hauteur, car les réacteurs répondent à la manette avec une à deux secondes de retard. Le 28 novembre 1957, le second exemplaire, **XK426**, est détruit en essai et le **Wing Commander H. G. F. Larsen**, qui le pilotait pour la première fois, est tué.\n\n## Place dans l''histoire\nLe TMR est le premier aéronef à sustentation par réaction à avoir volé, où que ce soit dans le monde. Le rapport du ministère de l''Aviation en tire deux leçons : un avion à décollage vertical doit être stabilisé artificiellement en vol stationnaire, et ses moteurs doivent répondre plus vite. Rolls-Royce lance ensuite le réacteur de sustentation **RB.108**, dont cinq exemplaires équipent le **Short SC.1**, premier véritable avion britannique à décollage vertical. Le XJ314 est aujourd''hui exposé au **Science Museum** de Londres.',
    E'## Genesis\nThe father of the project was **Dr Alan Arnold Griffith**, who had worked on gas turbine design at the **Royal Aircraft Establishment** (RAE) in the 1920s and joined **Rolls-Royce** in 1939. During the 1940s he conceived of using jet thrust to lift an aircraft directly, and suggested building a research machine to study it. Keen to exploit its new range of jet engines, Rolls-Royce had it built at **Hucknall** in Nottinghamshire, while the RAE supplied its automatic stabiliser. Two examples of this **Thrust Measuring Rig** were built.\n\n## Design\nThe machine had neither wings nor tail: two **Rolls-Royce Nene** turbojets were mounted back-to-back horizontally inside a tubular steel frame standing on four castored legs, with the pilot seated on a platform on top. The jets were turned downwards at the centre of gravity, one through a central nozzle and the other through two side nozzles, so that an engine failure would not tip the rig over. Four outrigger arms released compressed air for control in roll, pitch and yaw; pitch and roll were electrically signalled, with no mechanical reversion. With a thrust-to-weight ratio of just 1.08, endurance did not exceed six minutes, and its bed-frame look earned it the nickname **Flying Bedstead**.\n\n## Testing\nThe first example, **XJ314**, flew on 19 August 1953 at Hucknall, held within a gantry that limited its movements and its rate of descent. On 3 August 1954 Rolls-Royce chief test pilot **Ronald Thomas Shepherd** made the first free flight. In late 1954 the rig moved to the RAE, first at Farnborough and from June 1956 at Bedford, which studied whether artificial stabilisation was needed, sometimes flying with none at all. Pilots struggled above all with height control, as the engines answered the throttle with a lag of one to two seconds. On 28 November 1957 the second example, **XK426**, was destroyed in a test flight, killing **Wing Commander H. G. F. Larsen**, who was flying it for the first time.\n\n## Place in history\nThe TMR was the first jet-lift aircraft to fly anywhere in the world. The Ministry of Aviation report drew two lessons from it: a vertical take-off aircraft must have artificial stabilisation in the hover, and its engines must respond faster. Rolls-Royce went on to develop the **RB.108** lift jet, five of which powered the **Short SC.1**, the first true British vertical take-off aircraft. XJ314 is now on display at the **Science Museum** in London.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    NULL,
    '1953-08-19',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'RR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Rolls-Royce Thrust Measuring Rig'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Rolls-Royce Thrust Measuring Rig'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.53,
  wingspan          = NULL,
  height            = 3.86,
  wing_area         = NULL,
  empty_weight      = 2722,
  mtow              = 3402,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Nene',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 18.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **XJ314** : premier exemplaire, vols captifs sous portique à partir du 19 août 1953, premier vol libre le 3 août 1954 ; exposé au Science Museum de Londres\n- **XK426** : second exemplaire, détruit en essai le 28 novembre 1957\n- **Configuration de Hucknall** : essais de Rolls-Royce en 1953-1954, composants de commande électrique doublés\n- **Configuration du RAE** : essais en vol libre à Farnborough puis Bedford, commandes électriques en triplex partiel et stabilisateur automatique plus ou moins sollicité',
  variants_en       = E'- **XJ314**: first example, tethered flights within a gantry from 19 August 1953, first free flight on 3 August 1954; displayed at the Science Museum, London\n- **XK426**: second example, destroyed in a test flight on 28 November 1957\n- **Hucknall configuration**: Rolls-Royce trials in 1953-1954, with duplicated electrical control components\n- **RAE configuration**: free-flight trials at Farnborough then Bedford, with partial-triplex electrical controls and varying levels of automatic stabilisation',

  -- Strate 4 : qualitatif
  nickname          = 'Flying Bedstead',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Rolls-Royce_Thrust_Measuring_Rig',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Rolls-Royce_Thrust_Measuring_Rig',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Andrew Bone',
  image_licence     = 'CC BY 4.0'
WHERE name = 'Rolls-Royce Thrust Measuring Rig';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Rolls-Royce Thrust Measuring Rig';
