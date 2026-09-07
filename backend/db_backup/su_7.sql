-- Soukhoï Su-7
--
-- Photo : Sukhoi Su-7BKL ’07 red’ (36655523710).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3ASukhoi_Su-7BKL_%E2%80%9907_red%E2%80%99_%2836655523710%29.jpg

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
    'Su-7',
    'Su-7',
    'Soukhoï Su-7',
    'Sukhoi Su-7',
    'Chasseur-bombardier soviétique, robuste et assoiffé',
    'Soviet fighter-bomber, rugged and thirsty',
    '/assets/airplanes/su7.jpg',
    E'## Genèse\nConçu au départ comme intercepteur de jour pour concurrencer le MiG-21, le Su-7 échoue dans ce rôle : trop lourd, trop peu manœuvrant. Soukhoï le réoriente vers l''attaque au sol, où sa robustesse et sa vitesse à basse altitude font merveille.\n\n## Conception\nAile à 62° de flèche et fuselage massif autour d''un unique AL-7F. La cellule encaisse des dommages considérables. Le défaut est structurel : la consommation est telle qu''avec un armement significatif, le rayon d''action tombe sous **500 km**, et le décollage exige une piste très longue — d''où la version à patins et fusées d''appoint.\n\n## Carrière opérationnelle\nExporté vers neuf pays du bloc de l''Est et du monde arabe. L''Égypte et la Syrie l''engagent en **1967** et **1973** ; l''Inde l''utilise intensivement en **1971** contre le Pakistan, où il encaisse remarquablement les tirs sol-air tout en subissant de lourdes pertes.\n\n## Place dans l''histoire\nLe Su-7 est le point de départ d''une lignée qui court jusqu''au Su-25 : sa conversion en **Su-17** à aile à géométrie variable, en 1966, corrige d''un coup ses deux défauts — distance de décollage et rayon d''action — et fonde la famille d''attaque de Soukhoï.',
    E'## Genesis\nOriginally designed as a day interceptor to compete with the MiG-21, the Su-7 failed in that role: too heavy, not agile enough. Sukhoi redirected it to ground attack, where its toughness and low-level speed came into their own.\n\n## Design\nA 62° swept wing and a massive fuselage around a single AL-7F. The airframe absorbed considerable damage. The flaw was structural: fuel consumption was such that with a meaningful load the radius fell below **500 km**, and take-off demanded a very long runway — hence the version with skids and rocket assistance.\n\n## Operational career\nExported to nine Eastern Bloc and Arab countries. Egypt and Syria committed it in **1967** and **1973**; India used it intensively in **1971** against Pakistan, where it absorbed ground fire remarkably well while suffering heavy losses.\n\n## Place in history\nThe Su-7 is the starting point of a line running to the Su-25: its 1966 conversion into the variable-geometry **Su-17** fixed both its weaknesses at once — take-off distance and radius — and founded Sukhoi’s attack family.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1953-01-01',
    '1955-09-07',
    '1959-01-01',
    2150.0,
    1650.0,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM armement WHERE name = 'NR-30')),
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM armement WHERE name = 'FAB-500'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971')),
((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.8,
  wingspan          = 8.93,
  height            = 4.99,
  wing_area         = 34.0,
  empty_weight      = 8620,
  mtow              = 13500,
  service_ceiling   = 17600,
  climb_rate        = 160,
  g_limit_pos       = 7.0,
  g_limit_neg       = NULL,
  combat_radius     = 480,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Lyulka AL-7F-1',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 66.6,
  thrust_wet        = 94.1,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1972,
  units_built       = 1847,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 9,
  variants          = E'- **Su-7B** : version d''attaque au sol de série\n- **Su-7BKL** : train renforcé et patins pour terrains sommaires\n- **Su-7U** : biplace d''entraînement\n- **Su-17 / Su-20 / Su-22** : dérivés à géométrie variable',
  variants_en       = E'- **Su-7B** : production ground-attack version\n- **Su-7BKL** : strengthened gear with skids for rough strips\n- **Su-7U** : two-seat trainer\n- **Su-17 / Su-20 / Su-22** : variable-geometry derivatives',

  -- Strate 4 : qualitatif
  nickname          = 'Fitter',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soukho%C3%AF_Su-7',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Sukhoi_Su-7',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Su-7';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Su-7';
