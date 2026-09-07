-- Tupolev Tu-4 (Bull)
--
-- Photo : Tupolev Tu-4 ’01 red’ (38606467515).jpg
--   licence CC BY-SA 2.0 — calflier001
--   https://commons.wikimedia.org/wiki/File%3ATupolev_Tu-4_DATANSHAN_CHINA_AVIATION_MUSEUM_OCT_2012_%288272495620%29.jpg

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
    'Tupolev Tu-4',
    'Tupolev Tu-4',
    'Tupolev Tu-4 (Bull)',
    'Tupolev Tu-4 (Bull)',
    'Copie soviétique du B-29, fondatrice de l’aviation stratégique de l’URSS',
    'Soviet copy of the B-29, founder of the USSR’s strategic air arm',
    '/assets/airplanes/tu4.jpg',
    E'## Genèse\nEn 1944, trois B-29 américains endommagés au-dessus du Japon se posent en **Sibérie**. L''URSS, neutre dans le Pacifique, les interne — et refuse de les rendre. Staline ordonne alors à Tupolev non pas de s''en inspirer, mais de les **copier à l''identique**, boulon par boulon, en deux ans. C''est l''un des plus vastes exercices de rétro-ingénierie jamais entrepris.\n\n## Conception\nTrois cellules sont démontées : l''une pièce par pièce, la deuxième conservée intacte comme référence, la troisième réservée aux vols de comparaison. Chaque élément est relevé, redessiné aux normes métriques et confié à une usine. Le travail bute sur mille détails — l''aluminium soviétique n''existe pas aux épaisseurs américaines, ce qui oblige à recalculer toute la structure. Tupolev obtient malgré tout une machine plus lourde de seulement trois cent quarante kilos que l''original.\n\n## Carrière opérationnelle\nDévoilé par surprise au défilé de Toushino en 1947, il annonce au monde que l''URSS dispose désormais d''un bombardier capable d''atteindre l''Amérique — en aller simple. Il emporte la première **bombe atomique soviétique** en 1951. La Chine en reçoit vingt-cinq, qui serviront de plateformes de guet aérien et de porteurs de drones jusque dans les années 1980.\n\n## Place dans l''histoire\nHuit cent quarante-sept exemplaires. Son importance dépasse de loin ses qualités : en le copiant, l''industrie soviétique a acquis d''un coup l''aluminium haute résistance, la pressurisation, le radar de bombardement et les tourelles asservies. Toute la lignée qui mène au **Tu-16** puis au Tu-95 part de là.',
    E'## Genesis\nIn 1944 three American B-29s damaged over Japan landed in **Siberia**. The USSR, neutral in the Pacific, interned them — and refused to give them back. Stalin then ordered Tupolev not to draw inspiration from them but to **copy them exactly**, bolt for bolt, in two years. It was one of the largest reverse-engineering exercises ever undertaken.\n\n## Design\nThree airframes were taken apart: one piece by piece, the second kept intact as a reference, the third reserved for comparison flights. Every item was measured, redrawn to metric standards and assigned to a factory. The work ran into a thousand details — Soviet aluminium did not exist in American gauges, which forced a recalculation of the entire structure. Tupolev nevertheless produced a machine only three hundred and forty kilos heavier than the original.\n\n## Operational career\nRevealed by surprise at the 1947 Tushino flypast, it told the world that the USSR now had a bomber able to reach America — one way. It carried the first **Soviet atomic bomb** in 1951. China received twenty-five, which served as airborne early warning platforms and drone carriers into the 1980s.\n\n## Place in history\nEight hundred and forty-seven built. Its importance far exceeds its qualities: in copying it, Soviet industry acquired at a stroke high-strength aluminium, pressurisation, bombing radar and powered turrets. The whole line leading to the **Tu-16** and then the Tu-95 starts here.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1945-06-22',
    '1947-05-19',
    '1949-01-01',
    558.0,
    5100.0,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'), (SELECT id FROM armement WHERE name = 'NR-23')),
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'), (SELECT id FROM armement WHERE name = 'FAB-1000')),
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'), (SELECT id FROM armement WHERE name = 'FAB-3000'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.18,
  wingspan          = 43.05,
  height            = 8.46,
  wing_area         = 161.7,
  empty_weight      = 35270,
  mtow              = 66000,
  service_ceiling   = 11200,
  climb_rate        = 4.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2500,
  crew              = 11,

  -- Strate 2 : motorisation
  engine_name       = 'Shvetsov ASh-73TK',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1952,
  units_built       = 847,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Tu-4** : bombardier stratégique, version de base\n- **Tu-4A** : version porteuse d''arme nucléaire, opérationnelle en 1951\n- **Tu-4T** : version de transport de troupes et de parachutage\n- **Tu-70 / Tu-75** : dérivés civils et de transport bâtis sur la même voilure\n- La **Chine** en a reçu vingt-cinq ; certains volaient encore comme bancs d''essai en 1988',
  variants_en       = E'- **Tu-4** : strategic bomber, the baseline version\n- **Tu-4A** : nuclear-capable version, operational in 1951\n- **Tu-4T** : troop transport and paratroop version\n- **Tu-70 / Tu-75** : civil and transport derivatives built on the same wing\n- **China** received twenty-five; some were still flying as testbeds in 1988',

  -- Strate 4 : qualitatif
  nickname          = 'Bull',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tupolev_Tu-4',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tupolev_Tu-4',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Tupolev Tu-4';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tupolev Tu-4';
