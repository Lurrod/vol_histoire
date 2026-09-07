-- de Havilland Canada DHC-5 Buffalo
--
-- Photo : DHC-5 7Q-STB 151215 (Left).jpg
--   licence CC BY-SA 2.0 — Nik Deblauwe
--   https://commons.wikimedia.org/wiki/File%3ADHC-5_7Q-STB_151215_%28Left%29.jpg

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
    'DHC-5 Buffalo',
    'DHC-5 Buffalo',
    'de Havilland Canada DHC-5 Buffalo',
    'de Havilland Canada DHC-5 Buffalo',
    'Décolle en trois cents mètres avec huit tonnes à bord',
    'Takes off in three hundred metres with eight tonnes aboard',
    '/assets/airplanes/dhc5-buffalo.jpg',
    E'## Genèse\nLe **DHC-4 Caribou** a prouvé au Vietnam qu''un transport peut se poser sur trois cents mètres de terre battue, mais ses moteurs à pistons sont capricieux et sa charge limitée. L''US Army demande en 1962 une version à turbopropulseurs, plus puissante. De Havilland Canada répond par le Buffalo — puis l''US Army est dessaisie des avions à voilure fixe au profit de l''Air Force, et la commande s''évapore.\n\n## Conception\nVingt-neuf mètres d''envergure pour vingt-deux tonnes, une aile haute à volets généreux, un empennage en T haut placé et deux turbopropulseurs **CT64**. La combinaison permet de décoller en **deux cent quatre-vingt-dix mètres** à pleine charge et de se poser encore plus court, sur une piste que rien d''autre de cette taille ne peut utiliser.\n\n## Carrière opérationnelle\nCent vingt-six exemplaires, quinze pays. Il sert au **Vietnam** avec l''US Army, puis équipe les forces brésiliennes, égyptiennes, péruviennes et canadiennes. Le Canada l''utilise quarante ans pour le sauvetage en montagne. Les Nations unies en exploitent plusieurs pour l''aide humanitaire, là où les pistes sont mauvaises et les besoins urgents.\n\n## Place dans l''histoire\nCent vingt-six exemplaires. Le Buffalo ferme la lignée des transports ADAC canadiens ouverte par le **Caribou** — une spécialité que personne n''a reprise depuis, faute de marché : les armées préfèrent des **C-130** qui portent plus loin et acceptent des pistes un peu moins mauvaises.',
    E'## Genesis\nThe **DHC-4 Caribou** had proved over Vietnam that a transport can land on three hundred metres of dirt, but its piston engines were temperamental and its load limited. In 1962 the US Army asked for a more powerful turboprop version. De Havilland Canada answered with the Buffalo — then the US Army lost its fixed-wing aircraft to the Air Force, and the order evaporated.\n\n## Design\nTwenty-nine metres of span for twenty-two tonnes, a high wing with generous flaps, a high T-tail and two **CT64** turboprops. The combination allows take-off in **two hundred and ninety metres** at full load and an even shorter landing, on a strip nothing else of that size can use.\n\n## Operational career\nOne hundred and twenty-six built, fifteen countries. It served in **Vietnam** with the US Army, then equipped Brazilian, Egyptian, Peruvian and Canadian forces. Canada used it for forty years for mountain rescue. The United Nations operate several for humanitarian aid, where strips are bad and needs urgent.\n\n## Place in history\nOne hundred and twenty-six built. The Buffalo closes the line of Canadian STOL transports opened by the **Caribou** — a speciality nobody has taken up since, for want of a market: armies prefer **C-130s** that carry further and accept strips only slightly less bad.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1962-01-01',
    '1964-04-09',
    '1965-04-01',
    467.0,
    3200.0,
    (SELECT id FROM manufacturer WHERE code = 'DHC'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-5 Buffalo'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-5 Buffalo'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'DHC-5 Buffalo'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'DHC-5 Buffalo'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-5 Buffalo'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'DHC-5 Buffalo'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 24.08,
  wingspan          = 29.26,
  height            = 8.73,
  wing_area         = 87.8,
  empty_weight      = 11412,
  mtow              = 22316,
  service_ceiling   = 9450,
  climb_rate        = 11.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1100,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CT64-820-4',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1964,
  production_end    = 1986,
  units_built       = 126,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 15,
  variants          = E'- **DHC-5A / D** : versions de série successives, la D à moteurs plus puissants\n- **CC-115** : désignation des Forces canadiennes, sauvetage en montagne et en mer\n- **C-8A** : quatre exemplaires cédés à la **NASA** pour des essais d''aile soufflée\n- Dérivé du **DHC-4 Caribou**, dont il reprend la cellule avec des turbopropulseurs\n- Décollage en **290 m** à pleine charge : performance ADAC inégalée dans sa catégorie',
  variants_en       = E'- **DHC-5A / D** : successive production versions, the D with more powerful engines\n- **CC-115** : Canadian Forces designation, mountain and sea rescue\n- **C-8A** : four aircraft passed to **NASA** for blown-wing research\n- Derived from the **DHC-4 Caribou**, reusing its airframe with turboprops\n- Take-off in **290 m** at full load: unmatched STOL performance in its class',

  -- Strate 4 : qualitatif
  nickname          = 'Buffalo',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Canada_DHC-5_Buffalo',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Canada_DHC-5_Buffalo',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Nik Deblauwe',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'DHC-5 Buffalo';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'DHC-5 Buffalo';
