-- Fokker F27 Maritime / Maritime Enforcer
--
-- Photo : 47af - Royal Netherlands Air Force Fokker F27 Friendship 200MAR; M-2@SXM;02.02.1999 (8296609763).jpg
--   licence CC BY-SA 2.0 — Aero Icarus from Zürich, Switzerland
--   https://commons.wikimedia.org/wiki/File%3A47af_-_Royal_Netherlands_Air_Force_Fokker_F27_Friendship_200MAR%3B_M-2%40SXM%3B02.02.1999_%288296609763%29.jpg

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
    'Fokker F27 Maritime',
    'Fokker F27 Maritime',
    'Fokker F27 Maritime / Maritime Enforcer',
    'Fokker F27 Maritime / Maritime Enforcer',
    'L’avion de ligne néerlandais devenu patrouilleur de six marines',
    'The Dutch airliner turned patrol aircraft for six navies',
    '/assets/airplanes/f27-maritime.jpg',
    E'## Genèse\nLe **F27 Friendship** est le plus grand succès commercial de l''aéronautique néerlandaise : près de huit cents exemplaires vendus dans le monde entier depuis 1958. Fokker cherche à en tirer des versions spécialisées, et le marché le plus évident est la **patrouille maritime** — une mission qui demande exactement ce que fait un avion de ligne à turbopropulseurs : voler longtemps, bas et lentement.\n\n## Conception\nLa cellule est conservée ; on lui ajoute un **radar de recherche** sous le fuselage, des bulles d''observation latérales, des postes d''opérateurs et des réservoirs supplémentaires qui portent l''autonomie à douze heures. La version **Enforcer** ajoute quatre points d''emport pour torpilles Mk 46 et missiles antinavires, ce qui en fait un véritable appareil de combat.\n\n## Carrière opérationnelle\nUne vingtaine d''exemplaires, six marines : Pays-Bas, Espagne, Pérou, Philippines, Angola et Nigeria. La **Koninklijke Luchtmacht** les emploie notamment aux Antilles néerlandaises pour la surveillance des Caraïbes, mission de garde-côtes autant que militaire.\n\n## Place dans l''histoire\nVingt exemplaires militaires sur près de huit cents F27 construits. Fokker a fait faillite en 1996, incapable de rivaliser avec Embraer et Bombardier. Le F27 Maritime reste, avec le **S.14 Machtrainer**, l''un des deux seuls appareils néerlandais de ce catalogue.',
    E'## Genesis\nThe **F27 Friendship** is the greatest commercial success of Dutch aviation: nearly eight hundred sold worldwide since 1958. Fokker sought specialised versions, and the most obvious market was **maritime patrol** — a mission that demands exactly what a turboprop airliner does: fly for a long time, low and slowly.\n\n## Design\nThe airframe is kept; to it are added a **search radar** under the fuselage, side observation bubbles, operator stations and extra tanks that raise endurance to twelve hours. The **Enforcer** version adds four hardpoints for Mk 46 torpedoes and anti-ship missiles, making it a genuine combat aircraft.\n\n## Operational career\nSome twenty built, six navies: the Netherlands, Spain, Peru, the Philippines, Angola and Nigeria. The **Koninklijke Luchtmacht** used them notably in the Netherlands Antilles for Caribbean surveillance, a coastguard mission as much as a military one.\n\n## Place in history\nTwenty military aircraft out of nearly eight hundred F27s built. Fokker went bankrupt in 1996, unable to compete with Embraer and Bombardier. The F27 Maritime remains, with the **S.14 Machtrainer**, one of only two Dutch aircraft in this catalogue.',
    (SELECT id FROM countries WHERE code = 'NLD'),
    '1973-01-01',
    '1976-03-25',
    '1981-01-01',
    480.0,
    5000.0,
    (SELECT id FROM manufacturer WHERE code = 'FOK'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fokker F27 Maritime'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Fokker F27 Maritime'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Fokker F27 Maritime'), (SELECT id FROM armement WHERE name = 'Mk 46'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fokker F27 Maritime'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Fokker F27 Maritime'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Fokker F27 Maritime'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.56,
  wingspan          = 29.0,
  height            = 8.5,
  wing_area         = 70.0,
  empty_weight      = 12520,
  mtow              = 20410,
  service_ceiling   = 8990,
  climb_rate        = 7.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1800,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Dart Mk 552',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1976,
  production_end    = 1990,
  units_built       = 20,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **F27 Maritime** : version de surveillance non armée, radar ventral et bulles d''observation\n- **F27 Maritime Enforcer** : version armée de torpilles et de missiles antinavires\n- **F27 Troopship** : version de transport militaire, la plus produite des versions armées\n- Dérivé du **F27 Friendship**, avion de ligne produit à près de huit cents exemplaires\n- Autonomie de **douze heures** : le double d''un avion de ligne à charge égale',
  variants_en       = E'- **F27 Maritime** : unarmed surveillance version, belly radar and observation bubbles\n- **F27 Maritime Enforcer** : version armed with torpedoes and anti-ship missiles\n- **F27 Troopship** : military transport version, the most produced of the military ones\n- Derived from the **F27 Friendship** airliner, built in nearly eight hundred examples\n- **Twelve hours** endurance: twice an airliner''s at equal load',

  -- Strate 4 : qualitatif
  nickname          = 'Maritime',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fokker_F27_Friendship',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fokker_F27_Friendship',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Aero Icarus from Zürich, Switzerland',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Fokker F27 Maritime';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fokker F27 Maritime';
