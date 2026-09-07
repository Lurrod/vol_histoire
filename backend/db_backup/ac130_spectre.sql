-- Lockheed AC-130 Spectre / Ghostrider
--
-- Photo : AC-130 (5872).jpg
--   licence Public domain — MSgt Christopher Boitz
--   https://commons.wikimedia.org/wiki/File%3AAC-130_%285872%29.jpg

-- Entrée de référentiel propre à cette fiche.
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Canon M102 105 mm', NULL, 'Obusier de 105 mm tirant en dérive depuis le flanc gauche de l''appareil', 'Side-firing 105 mm howitzer mounted on the left side of the aircraft'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Canon M102 105 mm');

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
    'AC-130 Spectre',
    'AC-130 Spectre',
    'Lockheed AC-130 Spectre / Ghostrider',
    'Lockheed AC-130 Spectre / Ghostrider',
    'Transport transformé en batterie d’artillerie volante',
    'Transport aircraft turned into a flying artillery battery',
    '/assets/airplanes/ac130-spectre.jpg',
    E'## Genèse\nL''idée naît au Vietnam d''une observation simple : un avion qui tourne en cercle autour d''un point, en inclinant l''aile, maintient ses armes pointées sur ce point aussi longtemps qu''il le veut. Testée sur un vieux DC-3, la formule est reprise sur la cellule bien plus capable du **C-130 Hercules**.\n\n## Conception\nToutes les armes tirent **par le flanc gauche**, perpendiculairement à l''axe de vol. Le pilote décrit une orbite inclinée à 30° autour de la cible ; un calculateur de tir corrige en continu la dérive, le vent et le mouvement. Le vaisseau amiral de la famille, l''AC-130U, emporte un obusier de **105 mm** — une pièce d''artillerie de campagne, tirée depuis un avion.\n\n## Carrière opérationnelle\nRedoutable de nuit contre des adversaires sans défense antiaérienne, il est extrêmement vulnérable dès qu''il en existe une : lent, gros, et contraint de tourner en rond. Six appareils sont perdus au Vietnam, un lors de la guerre du Golfe. Il sert depuis en Afghanistan, en Irak, en Libye et en Syrie, presque exclusivement de nuit.\n\n## Place dans l''histoire\nAucun autre pays n''a jamais aligné d''équivalent opérationnel. Le concept — un appui-feu à très longue endurance, sans précision limitée par la vitesse — n''a de sens que dans un ciel entièrement maîtrisé, condition que seuls les États-Unis ont réunie durablement depuis 1991.',
    E'## Genesis\nThe idea came from a simple Vietnam observation: an aircraft circling a point in a bank keeps its weapons trained on that point for as long as it likes. Tested on an old DC-3, the formula moved to the far more capable **C-130 Hercules** airframe.\n\n## Design\nEvery weapon fires **out of the left side**, perpendicular to the flight path. The pilot flies a 30° banked orbit around the target while a fire control computer continuously corrects for drift, wind and motion. The family’s flagship, the AC-130U, carries a **105 mm** howitzer — a field artillery piece, fired from an aircraft.\n\n## Operational career\nDevastating at night against opponents with no air defences, it is extremely vulnerable as soon as any exist: slow, large, and obliged to circle. Six aircraft were lost over Vietnam and one in the Gulf War. It has since served in Afghanistan, Iraq, Libya and Syria, almost exclusively at night.\n\n## Place in history\nNo other country has ever fielded an operational equivalent. The concept — very long-endurance fire support whose accuracy is not limited by speed — only makes sense in fully controlled airspace, a condition only the United States has sustained since 1991.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1967-01-01',
    '1967-09-01',
    '1968-02-01',
    480.0,
    4070.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM tech WHERE name = 'Pod désignateur laser')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM armement WHERE name = 'GAU-12 Equalizer')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM armement WHERE name = 'Canon M102 105 mm')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM armement WHERE name = 'AGM-114 Hellfire')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 29.79,
  wingspan          = 40.41,
  height            = 11.66,
  wing_area         = 162.1,
  empty_weight      = 34400,
  mtow              = 69750,
  service_ceiling   = 9100,
  climb_rate        = 9,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1800,
  crew              = 13,

  -- Strate 2 : motorisation
  engine_name       = 'Allison T56-A-15',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1967,
  production_end    = NULL,
  units_built       = 130,
  unit_cost_usd     = 165000000,
  unit_cost_year    = 2019,
  operators_count   = 1,
  variants          = E'- **AC-130A Spectre** : première version, mitrailleuses et canons de 20 mm\n- **AC-130H / U Spooky** : obusier de 105 mm, canon de 40 mm, conduite de tir numérique\n- **AC-130J Ghostrider** : version actuelle, munitions guidées et missiles Hellfire\n- **AC-130W Stinger II** : version à armement exclusivement guidé',
  variants_en       = E'- **AC-130A Spectre** : first version, machine guns and 20 mm cannon\n- **AC-130H / U Spooky** : 105 mm howitzer, 40 mm gun, digital fire control\n- **AC-130J Ghostrider** : current version with guided munitions and Hellfire missiles\n- **AC-130W Stinger II** : version with guided weapons only',

  -- Strate 4 : qualitatif
  nickname          = 'Spooky',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_AC-130',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_AC-130',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'MSgt Christopher Boitz',
  image_licence     = 'Public domain'
WHERE name = 'AC-130 Spectre';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AC-130 Spectre';
