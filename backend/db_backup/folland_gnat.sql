-- Folland Gnat
--
-- Photo : Folland Gnat T1 (28521605458).jpg
--   licence CC BY 2.0 — Michael Gaylard from Horsham, UK
--   https://commons.wikimedia.org/wiki/File%3AFolland_Gnat_T1_%2828521605458%29.jpg

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
    'Folland Gnat',
    'Folland Gnat',
    'Folland Gnat',
    'Folland Gnat',
    'Chasseur miniature britannique, « tueur de Sabre » en Inde',
    'British miniature fighter, the “Sabre Slayer” in India',
    '/assets/airplanes/folland-gnat.jpg',
    E'## Genèse\n**W. E. W. Petter**, qui avait conçu le Canberra, quitte English Electric convaincu que les avions de combat deviennent trop lourds et trop chers. Chez Folland, il dessine l''inverse : un chasseur de **deux tonnes à vide**, moitié moins qu''un Hunter, assez simple pour être entretenu sur un terrain sommaire.\n\n## Conception\nNeuf mètres de long, 6,75 mètres d''envergure — plus petit qu''un avion de tourisme moderne. Le réacteur Orpheus, léger et peu gourmand, lui donne des performances comparables à celles de chasseurs deux fois plus lourds. La RAF refuse le concept, jugeant l''appareil trop limité en emport et en avionique ; elle en achètera pourtant la version biplace.\n\n## Carrière opérationnelle\nC''est l''**Inde** qui en fait un avion de combat. Lors des guerres de 1965 et 1971, les Gnat indiens affrontent les F-86 Sabre pakistanais et en abattent plusieurs : leur petite taille les rend difficiles à voir et à suivre en combat tournant. La presse indienne les baptise *Sabre Slayers*.\n\n## Place dans l''histoire\nEn Grande-Bretagne il reste surtout la première monture des **Red Arrows**, qu''il équipe pendant quatorze ans. Son héritage opérationnel est indien : le **HAL Ajeet**, version améliorée produite sous licence, prolonge la formule jusqu''en 1991.',
    E'## Genesis\n**W. E. W. Petter**, who had designed the Canberra, left English Electric convinced that combat aircraft were becoming too heavy and too expensive. At Folland he drew the opposite: a fighter weighing **two tonnes empty**, half a Hunter, simple enough to be maintained from a rough strip.\n\n## Design\nNine metres long, 6.75 metres of span — smaller than a modern light aircraft. The light, frugal Orpheus engine gave it performance comparable to fighters twice its weight. The RAF rejected the concept, judging the aircraft too limited in payload and avionics; it nonetheless bought the two-seat version.\n\n## Operational career\nIt was **India** that made it a combat aircraft. In the wars of 1965 and 1971 Indian Gnats faced Pakistani F-86 Sabres and shot several down: their small size made them hard to see and hard to follow in a turning fight. The Indian press named them *Sabre Slayers*.\n\n## Place in history\nIn Britain it is remembered chiefly as the first mount of the **Red Arrows**, which flew it for fourteen years. Its operational legacy is Indian: the **HAL Ajeet**, an improved licence-built version, carried the formula through to 1991.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1951-01-01',
    '1955-07-18',
    '1959-03-01',
    1120.0,
    1900.0,
    (SELECT id FROM manufacturer WHERE code = 'FOL'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Orpheus'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.68,
  wingspan          = 6.75,
  height            = 2.69,
  wing_area         = 16.3,
  empty_weight      = 2175,
  mtow              = 4030,
  service_ceiling   = 15000,
  climb_rate        = 100,
  g_limit_pos       = 8.0,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Siddeley Orpheus 701',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 20.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1965,
  units_built       = 449,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **Gnat F.1** : chasseur monoplace, refusé par la RAF, exporté\n- **Gnat T.1** : biplace d''entraînement, seule version retenue par la RAF\n- **HAL Ajeet** : version indienne améliorée, produite sous licence\n- Première monture des **Red Arrows**, de 1965 à 1979',
  variants_en       = E'- **Gnat F.1** : single-seat fighter, rejected by the RAF and exported\n- **Gnat T.1** : two-seat trainer, the only version the RAF adopted\n- **HAL Ajeet** : improved Indian version, licence-built\n- First mount of the **Red Arrows**, from 1965 to 1979',

  -- Strate 4 : qualitatif
  nickname          = 'Sabre Slayer',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Folland_Gnat',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Folland_Gnat',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Michael Gaylard from Horsham, UK',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Folland Gnat';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Folland Gnat';
