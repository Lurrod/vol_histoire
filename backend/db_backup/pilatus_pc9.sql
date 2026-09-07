-- Pilatus PC-9
--
-- Photo : PC-9, ILA 2024, Schoenefeld (ILA43883).jpg
--   licence CC BY-SA 4.0 — Matti Blume
--   https://commons.wikimedia.org/wiki/File%3APC-9%2C_ILA_2024%2C_Schoenefeld_%28ILA43883%29.jpg

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
    'Pilatus PC-9',
    'Pilatus PC-9',
    'Pilatus PC-9',
    'Pilatus PC-9',
    'Entraîneur suisse à turbopropulseur, école de vingt forces aériennes',
    'Swiss turboprop trainer, school of twenty air forces',
    '/assets/airplanes/pilatus-pc9.jpg',
    E'## Genèse\nDans les années 1980, former un pilote de chasse coûte de plus en plus cher : l''heure de vol d''un entraîneur à réaction dépasse celle d''un avion de ligne. Pilatus fait le pari inverse — un **turbopropulseur** assez performant pour couvrir les phases élémentaire et de base, à un dixième du coût horaire d''un jet.\n\n## Conception\nUn PT6A de 950 chevaux dans une cellule de 1,7 tonne à vide : le rapport puissance/masse permet une montée de 1 200 mètres par minute et un domaine de vol à **7 g**, comparable à celui d''un jet d''entraînement. Le cockpit en tandem est surélevé à l''arrière et l''instrumentation reproduit celle d''un chasseur, pour éviter toute rupture d''apprentissage au passage sur réaction.\n\n## Carrière opérationnelle\nVingt forces aériennes, de l''Australie à l''Arabie saoudite en passant par l''Irlande, la Croatie et la Slovénie. Sa version armée sert en contre-insurrection ; l''Australie l''a utilisée comme appareil de contrôle aérien avancé. La patrouille croate **Krila Oluje** vole sur PC-9M.\n\n## Place dans l''histoire\nLe PC-9 a rendu le turbopropulseur à nouveau crédible dans la formation militaire avancée, contre trente ans de tout-réacteur. Son dérivé américain, le **T-6 Texan II**, forme aujourd''hui les pilotes de l''US Air Force et de l''US Navy — un entraîneur conçu par un pays neutre sans aviation de combat.',
    E'## Genesis\nBy the 1980s training a fighter pilot was becoming ever more expensive: an hour in a jet trainer cost more than an hour in an airliner. Pilatus made the opposite bet — a **turboprop** capable enough to cover elementary and basic phases at a tenth of a jet’s hourly cost.\n\n## Design\nA 950 hp PT6A in an airframe weighing 1.7 tonnes empty: the power-to-weight ratio allows a climb of 1,200 metres per minute and a **7 g** envelope comparable to a jet trainer’s. The tandem cockpit is raised at the rear and the instruments reproduce a fighter’s, to avoid any break in learning on transition to jets.\n\n## Operational career\nTwenty air forces, from Australia to Saudi Arabia by way of Ireland, Croatia and Slovenia. Its armed version serves in counter-insurgency; Australia used it as a forward air control aircraft. The Croatian display team **Krila Oluje** flies the PC-9M.\n\n## Place in history\nThe PC-9 made the turboprop credible again in advanced military training, against thirty years of all-jet doctrine. Its American derivative, the **T-6 Texan II**, now trains US Air Force and US Navy pilots — a trainer designed by a neutral country with no combat aviation.',
    (SELECT id FROM countries WHERE code = 'CHE'),
    '1982-01-01',
    '1984-05-07',
    '1987-01-01',
    593.0,
    1642.0,
    (SELECT id FROM manufacturer WHERE code = 'PIL'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'), (SELECT id FROM armement WHERE name = 'Hydra 70'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.18,
  wingspan          = 10.19,
  height            = 3.26,
  wing_area         = 16.29,
  empty_weight      = 1685,
  mtow              = 3200,
  service_ceiling   = 11580,
  climb_rate        = 20,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.5,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-62',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1985,
  production_end    = NULL,
  units_built       = 270,
  unit_cost_usd     = 5000000,
  unit_cost_year    = 2000,
  operators_count   = 20,
  variants          = E'- **PC-9** : version d''entraînement de base\n- **PC-9M** : cellule et avionique modernisées, version actuelle\n- **Beechcraft T-6 Texan II** : dérivé américain, produit sous licence à plus de 900 exemplaires\n- **PC-21** : successeur direct, encore plus proche du comportement d''un jet',
  variants_en       = E'- **PC-9** : baseline training version\n- **PC-9M** : upgraded airframe and avionics, the current version\n- **Beechcraft T-6 Texan II** : American derivative, licence-built in more than 900 examples\n- **PC-21** : direct successor, closer still to jet handling',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Pilatus_PC-9',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Pilatus_PC-9',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Matti Blume',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Pilatus PC-9';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Pilatus PC-9';
