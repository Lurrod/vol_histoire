-- Nanchang CJ-6 (Chujiao-6)
--
-- Photo : CJ-6 at Changchun Air Show 20250921.jpg
--   licence CC BY-SA 4.0 — 颐园居
--   https://commons.wikimedia.org/wiki/File%3ACJ-6_at_Changchun_Air_Show_20250921.jpg

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
    'Nanchang CJ-6',
    'Nanchang CJ-6',
    'Nanchang CJ-6 (Chujiao-6)',
    'Nanchang CJ-6 (Chujiao-6)',
    'Trois mille exemplaires : le premier avion vraiment chinois',
    'Three thousand built: the first genuinely Chinese aircraft',
    '/assets/airplanes/cj6.jpg',
    E'## Genèse\nÀ la fin des années 1950, la Chine forme ses pilotes sur des **Yak-18** soviétiques à roulette de queue, mal adaptés à des élèves qui passeront ensuite sur des MiG à train tricycle. Nanchang entreprend d''y remédier — et la rupture avec Moscou en 1960 transforme l''amélioration en nécessité : il n''y aura plus de livraisons.\n\n## Conception\nLe CJ-6 garde du Yak-18 la silhouette générale et rien d''autre : aile, fuselage et train sont redessinés, le train devient tricycle rentrant, et le moteur en étoile **Huosai-6** est chinois. L''appareil est volontairement rustique — structure métallique simple, entretien minimal — pour pouvoir être produit et réparé partout dans un pays qui manque de tout.\n\n## Carrière opérationnelle\nEnviron **trois mille exemplaires**, une production ouverte depuis 1960. Il forme tous les pilotes militaires chinois pendant soixante ans et il est livré à douze pays — Corée du Nord, Cambodge, Bangladesh, Zambie, Tanzanie. Plusieurs centaines sont aujourd''hui vendus à des propriétaires civils en Amérique du Nord.\n\n## Place dans l''histoire\nTrois mille exemplaires, soixante-six ans de production. Le CJ-6 est **le premier avion entièrement conçu et produit en Chine**, à une époque où le pays copiait encore tout le reste. Il est aussi, en nombre, le plus produit de tout ce catalogue.',
    E'## Genesis\nIn the late 1950s China trained its pilots on Soviet **Yak-18s** with tailwheels, ill-suited to students who would move on to tricycle-gear MiGs. Nanchang set about fixing that — and the 1960 split with Moscow turned an improvement into a necessity: there would be no more deliveries.\n\n## Design\nThe CJ-6 keeps the Yak-18''s general outline and nothing else: wing, fuselage and undercarriage are redrawn, the gear becomes retractable tricycle, and the **Huosai-6** radial engine is Chinese. The aircraft is deliberately rustic — simple metal structure, minimal maintenance — so it can be built and repaired anywhere in a country short of everything.\n\n## Operational career\nSome **three thousand built**, with production open since 1960. It trained every Chinese military pilot for sixty years and was delivered to twelve countries — North Korea, Cambodia, Bangladesh, Zambia, Tanzania. Several hundred are today sold to civil owners in North America.\n\n## Place in history\nThree thousand built over sixty-six years of production. The CJ-6 is **the first aircraft designed and built entirely in China**, at a time when the country still copied everything else. It is also, by number, the most produced aircraft in this whole catalogue.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '1958-01-01',
    '1958-08-27',
    '1962-01-01',
    297.0,
    690.0,
    (SELECT id FROM manufacturer WHERE code = 'NAMC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Nanchang CJ-6'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Nanchang CJ-6'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Nanchang CJ-6'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.46,
  wingspan          = 10.22,
  height            = 3.25,
  wing_area         = 17.05,
  empty_weight      = 1095,
  mtow              = 1400,
  service_ceiling   = 6250,
  climb_rate        = 5.7,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = 300,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Zhuzhou Huosai-6A',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1960,
  production_end    = NULL,
  units_built       = 3000,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 12,
  variants          = E'- **CJ-6** : version d''origine, moteur de 260 ch\n- **CJ-6A** : version portée à 285 ch, la plus produite et la plus exportée\n- **CJ-6B** : version armée, deux points d''emport, exportée en petit nombre\n- *Chujiao* signifie « **instruction élémentaire** » en chinois\n- Souvent confondu avec le **Yak-18** dont il dérive : la cellule est pourtant nouvelle',
  variants_en       = E'- **CJ-6** : original version, 260 hp engine\n- **CJ-6A** : uprated to 285 hp, the most produced and most exported\n- **CJ-6B** : armed version with two hardpoints, exported in small numbers\n- *Chujiao* means ''**elementary training**'' in Chinese\n- Often mistaken for the **Yak-18** it derives from: the airframe is in fact new',

  -- Strate 4 : qualitatif
  nickname          = 'Chujiao-6',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Nanchang_CJ-6',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Nanchang_CJ-6',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '颐园居',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Nanchang CJ-6';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Nanchang CJ-6';
