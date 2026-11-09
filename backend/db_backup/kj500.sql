-- Shaanxi KJ-500
--
-- Photo : KJ-500 at PLAAF Aviation Open Day 20250921.jpg
--   licence CC BY-SA 4.0 — 颐园居
--   https://commons.wikimedia.org/wiki/File:KJ-500_at_PLAAF_Aviation_Open_Day_20250921.jpg

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
    'Shaanxi KJ-500',
    'Shaanxi KJ-500',
    'Shaanxi KJ-500',
    'Shaanxi KJ-500',
    'Trois antennes AESA sous un radôme fixe : le guet aérien chinois produit en série',
    'Three AESA arrays under a fixed radome: China’s series-built early warning aircraft',
    '/assets/airplanes/kj500.jpg',
    E'## Genèse\nÀ la fin des années 2000, la Chine dispose de deux avions de guet aérien : le lourd **KJ-2000**, sur cellule d''Il-76, construit à quelques exemplaires, et le **KJ-200**, dérivé du **Shaanxi Y-8**, dont l''antenne en poutre couvre mal l''avant et l''arrière. L''aviation populaire veut un appareil moyen, produit en série, qui devienne le nœud de son réseau de combat. Shaanxi part de son nouveau transport, le **Y-9**, qui a volé en novembre 2010.\n\n## Conception\nLe radôme circulaire ne tourne pas : il est **fixe** et abrite trois antennes **AESA** disposées en triangle, qui couvrent les 360 degrés par balayage électronique — une version allégée de la technique du KJ-2000. Quatre turbopropulseurs, une cabine d''opérateurs, des liaisons de données et satellite : l''appareil coordonne chasseurs, navires et défense sol-air. Le KJ-500A, essayé à partir de 2018, ajoute une **perche de ravitaillement en vol**, un traitement des données plus puissant et de nouvelles antennes de liaison ; il est montré au public au salon de Zhuhai en 2022.\n\n## Carrière opérationnelle\nLes prototypes volent en 2013 ; l''appareil entre en service fin 2014 selon les observateurs occidentaux, et la production des modèles antérieurs cesse en 2018. Une quarantaine servent dans l''armée de l''air et une vingtaine de KJ-500H dans l''aéronavale. En mars 2022, le commandant des forces aériennes américaines du Pacifique le désigne comme l''élément qui rend efficaces les missiles air-air chinois à longue portée. En 2022, au salon de Changchun, il mène une formation de chasseurs furtifs **J-20**. Le Pakistan annonce son achat en 2025.\n\n## Place dans l''histoire\nUne soixantaine d''exemplaires en une décennie. La fiche du **Y-8** le range parmi les variantes nées de cette famille de cellules ; il en est la plus lourde de conséquences, celle qui permet aux chasseurs chinois de combattre au-delà de la portée de leur propre radar.',
    E'## Genesis\nAt the end of the 2000s China had two airborne early warning aircraft: the heavy **KJ-2000**, on an Il-76 airframe and built in only a handful, and the **KJ-200**, derived from the **Shaanxi Y-8**, whose beam antenna covered poorly to the front and rear. The People''s air force wanted a medium-sized aircraft, built in series, that would become the hub of its combat network. Shaanxi started from its new transport, the **Y-9**, which had flown in November 2010.\n\n## Design\nThe circular radome does not rotate: it is **fixed** and houses three **AESA** arrays arranged in a triangle, covering 360 degrees by electronic scanning — a lighter version of the KJ-2000''s technique. Four turboprops, an operators'' cabin, data and satellite links: the aircraft coordinates fighters, ships and ground-based air defence. The KJ-500A, tested from 2018, adds an **in-flight refuelling probe**, more powerful data processing and new link antennas; it was shown in public at the Zhuhai air show in 2022.\n\n## Operational career\nThe prototypes flew in 2013; the aircraft entered service in late 2014 according to Western observers, and production of the earlier types ended in 2018. Some forty serve with the air force and about twenty KJ-500Hs with the naval air arm. In March 2022 the commander of US Pacific Air Forces singled it out as the element that makes China''s long-range air-to-air missiles effective. In 2022, at the Changchun air show, it led a formation of **J-20** stealth fighters. Pakistan announced its purchase in 2025.\n\n## Place in history\nSome sixty built in a decade. The **Y-8** entry lists it among the variants born of that airframe family; it is the most consequential of them, the one that lets Chinese fighters fight beyond the range of their own radar.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    NULL,
    '2013-01-01',
    '2014-01-01',
    550.0,
    5700.0,
    (SELECT id FROM manufacturer WHERE code = 'SHX'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-500'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-500'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-500'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-500'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-500'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-500'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 77000,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Zhuzhou WJ-6C',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **KJ-500** : version de base de l''armée de l''air, une quarantaine d''exemplaires\n- **KJ-500H** : version de l''aéronavale, une vingtaine d''exemplaires\n- **KJ-500A** : perche de ravitaillement en vol, traitement et liaisons améliorés, en service vers 2020\n- **Radôme fixe** à trois antennes **AESA** : couverture sur 360° sans pièce tournante\n- Cellule du **Shaanxi Y-9**, elle-même issue du **Y-8**',
  variants_en       = E'- **KJ-500** : basic air force version, some forty aircraft\n- **KJ-500H** : naval air arm version, about twenty aircraft\n- **KJ-500A** : in-flight refuelling probe, improved processing and links, in service around 2020\n- **Fixed radome** with three **AESA** arrays: 360° coverage with no rotating part\n- Airframe of the **Shaanxi Y-9**, itself derived from the **Y-8**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/KJ-500',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Shaanxi_KJ-500',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '颐园居',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Shaanxi KJ-500';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Shaanxi KJ-500';
