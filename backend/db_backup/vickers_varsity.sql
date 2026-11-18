-- Vickers Type 668 Varsity
--
-- Photo : Vickers Varsity T.1 ‘WF369 F’ (50317056702).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Vickers_Varsity_T.1_%E2%80%98WF369_F%E2%80%99_(50317056702).jpg

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
    'Vickers Varsity',
    'Vickers Varsity',
    'Vickers Type 668 Varsity',
    'Vickers Type 668 Varsity',
    'La salle de classe volante où la RAF a formé pilotes, navigateurs et bombardiers des V-bombers',
    'The flying classroom where the RAF trained pilots, navigators and bomb aimers for the V-bombers',
    '/assets/airplanes/vickers-varsity.jpg',
    E'## Genèse\nÀ la fin des années 1940, la RAF forme encore ses équipages multimoteurs sur le **Wellington T10**, un bombardier de guerre reconverti, et sur les versions école du **Valetta**. L''Air Ministry publie la spécification T.13/48 pour un bimoteur d''entraînement dédié, et **Vickers** répond en partant de la famille Viking-Valetta. Le prototype Type 668, VX828, décolle de Wisley le 17 juillet 1949, piloté par **Mutt Summers** et **Jock Bryce**. Une version de ligne, le VC.3, est un temps envisagée, puis abandonnée face au succès du Viscount.\n\n## Conception\nLe Varsity n''est pas un simple Valetta modifié. Son aile a une plus grande envergure, son fuselage est allongé et il troque la roulette de queue de son aîné contre un train tricycle. Sous le fuselage, une nacelle ventrale permet à l''élève bombardier de viser allongé, et une soute emporte 24 bombes d''exercice fumigènes et éclairantes de 25 livres. Deux moteurs en étoile **Bristol Hercules 264** de 1 950 ch lui donnent 463 km/h et plus de 4 200 km d''autonomie, de quoi enchaîner de longues navigations d''entraînement à près de 8 700 m de plafond.\n\n## Carrière opérationnelle\nLes premiers avions de série rejoignent en 1951 la No. 201 Advanced Flying School de Swinderby, qui y forme les pilotes au vol multimoteur. Dès 1952, le Varsity équipe deux écoles de navigateurs ainsi que l''école de bombardement du Bomber Command, chargée de former les équipages des **V-bombers** de la dissuasion nucléaire britannique. La Jordanie en reçoit, et la Suède exploite un exemplaire de janvier 1953 à 1973, sous le nom de **Tp 82**, surtout pour des missions de renseignement électronique. Des écoles de pilotes d''essai et le Royal Aircraft Establishment l''utilisent aussi.\n\n## Place dans l''histoire\nLa RAF retire le Varsity en mai 1976 : le **Jetstream T1** reprend la formation des pilotes et le **Dominie T1** celle des navigateurs. Le dernier exemplaire en vol, WL679, sert encore au Royal Aircraft Establishment avant de rejoindre le musée de Cosford en 1992. Construit à 163 exemplaires, il a formé pendant un quart de siècle pilotes, navigateurs et bombardiers de la RAF. Plusieurs sont conservés, dont un à Berlin pour l''Allied Museum et le Tp 82 suédois à Linköping.',
    E'## Genesis\nAt the end of the 1940s the RAF was still training its multi-engine crews on the **Wellington T10**, a converted wartime bomber, and on training versions of the **Valetta**. The Air Ministry issued Specification T.13/48 for a dedicated twin-engined trainer, and **Vickers** answered by building on the Viking-Valetta family. The prototype Type 668, VX828, took off from Wisley on 17 July 1949, flown by **Mutt Summers** and **Jock Bryce**. An airliner version, the VC.3, was considered for a time, then abandoned in the face of the Viscount''s success.\n\n## Design\nThe Varsity was no mere modified Valetta. Its wing had a greater span, its fuselage was lengthened and it swapped its predecessor''s tailwheel for a tricycle undercarriage. Beneath the fuselage, a ventral pannier let the trainee bomb aimer sight lying prone, and a bomb bay carried 24 25 lb smoke and flash practice bombs. Two 1,950 hp **Bristol Hercules 264** radials gave it 463 km/h and over 4,200 km of range, enough for long training navigation sorties, with a ceiling of nearly 8,700 m.\n\n## Operational career\nThe first production aircraft joined No. 201 Advanced Flying School at Swinderby in 1951, where pilots learned multi-engine flying. From 1952 the Varsity equipped two Air Navigation Schools and the Bomber Command Bombing School, tasked with training the crews of the **V-bombers** of Britain''s nuclear deterrent. Jordan received some, and Sweden operated one example from January 1953 to 1973, as the **Tp 82**, mainly for electronic intelligence missions. Test pilot schools and the Royal Aircraft Establishment also flew it.\n\n## Place in history\nThe RAF retired the Varsity in May 1976: the **Jetstream T1** took over pilot training and the **Dominie T1** navigator training. The last flying example, WL679, was still serving the Royal Aircraft Establishment before joining the Cosford museum in 1992. Built to 163 examples, it trained RAF pilots, navigators and bomb aimers for a quarter of a century. Several survive, including one in Berlin for the Allied Museum and the Swedish Tp 82 at Linköping.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1948-01-01',
    '1949-07-17',
    '1951-01-01',
    463,
    4262,
    (SELECT id FROM manufacturer WHERE code = 'VIC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers Varsity'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers Varsity'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Vickers Varsity'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers Varsity'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.57,
  wingspan          = 29.13,
  height            = 7.29,
  wing_area         = 90.5,
  empty_weight      = 12265,
  mtow              = NULL,
  service_ceiling   = 8700,
  climb_rate        = 7.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Hercules 264 (1 950 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 163,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Type 668 (prototype)** : VX828, premier vol le 17 juillet 1949 à Wisley\n- **Varsity T.1** : version de série pour la RAF, formation des pilotes multimoteurs, des navigateurs et des bombardiers\n- **Tp 82** : exemplaire unique de l''armée de l''air suédoise, employé de 1953 à 1973 pour le renseignement électronique\n- **VC.3** : version civile envisagée puis abandonnée au profit du Viscount',
  variants_en       = E'- **Type 668 (prototype)**: VX828, first flight on 17 July 1949 at Wisley\n- **Varsity T.1**: RAF production version, training multi-engine pilots, navigators and bomb aimers\n- **Tp 82**: single Swedish Air Force example, used from 1953 to 1973 for electronic intelligence\n- **VC.3**: civil version considered then dropped in favour of the Viscount',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Vickers_Varsity',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Vickers_Varsity',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Vickers Varsity';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Vickers Varsity';
