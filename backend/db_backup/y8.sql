-- Shaanxi Y-8 (Yunshuji-8)
--
-- Photo : Shaanxi Y-8.jpg
--   licence CC BY-SA 4.0 — Alert5
--   https://commons.wikimedia.org/wiki/File%3AShaanxi_Y-8.jpg

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
    'Shaanxi Y-8',
    'Shaanxi Y-8',
    'Shaanxi Y-8 (Yunshuji-8)',
    'Shaanxi Y-8 (Yunshuji-8)',
    'Copie chinoise de l’An-12, devenue une famille de trente variantes',
    'Chinese copy of the An-12, grown into a family of thirty variants',
    '/assets/airplanes/y8.jpg',
    E'## Genèse\nLa rupture sino-soviétique de 1960 laisse la Chine avec quelques **An-12** livrés, aucun contrat de licence et aucune pièce de rechange. Le pays fait ce qu''il fera souvent ensuite : il démonte les appareils qu''il possède et les reproduit. Le premier Y-8 vole en 1974, quatorze ans après l''arrêt de la coopération.\n\n## Conception\nExtérieurement, c''est un An-12 : quatre turbopropulseurs, aile haute, rampe arrière, tourelle de queue sur les premières versions. La rétro-ingénierie a exigé de recréer les alliages, les profils et les moteurs. Le résultat est plus lourd et moins fin que l''original, mais il est **chinois** — et c''était l''objet.\n\n## Carrière opérationnelle\nEnviron deux cents exemplaires, huit pays. Sa vraie valeur n''est pas le transport mais la **cellule disponible** : la Chine en a tiré plus de trente variantes spécialisées — guet aérien KJ-200 et KJ-500, patrouille maritime KQ-200, guerre électronique, relais de communication, mesure de renseignement. Ce sont ces versions qui patrouillent le détroit de Taïwan.\n\n## Place dans l''histoire\nDeux cents exemplaires et une descendance, le **Y-9**, toujours en production. Le Y-8 illustre une méthode : copier une cellule éprouvée pour disposer d''une base sur laquelle greffer ce qu''on développe vraiment — les capteurs. C''est exactement ce que la Chine a fait ensuite avec le **J-11** issu du Su-27.',
    E'## Genesis\nThe Sino-Soviet split of 1960 left China with a few delivered **An-12s**, no licence agreement and no spare parts. The country did what it would often do afterwards: it took apart the aircraft it had and reproduced them. The first Y-8 flew in 1974, fourteen years after cooperation ended.\n\n## Design\nOutwardly it is an An-12: four turboprops, high wing, rear ramp, tail turret on the early versions. Reverse engineering meant recreating the alloys, the aerofoils and the engines. The result is heavier and less refined than the original, but it is **Chinese** — and that was the point.\n\n## Operational career\nSome two hundred built, eight countries. Its real value is not transport but the **available airframe**: China has drawn more than thirty specialised variants from it — KJ-200 and KJ-500 early warning, KQ-200 maritime patrol, electronic warfare, communications relay, intelligence gathering. It is these versions that patrol the Taiwan Strait.\n\n## Place in history\nTwo hundred built and a descendant, the **Y-9**, still in production. The Y-8 illustrates a method: copy a proven airframe to obtain a base on which to graft what you are really developing — the sensors. It is exactly what China did next with the **J-11** derived from the Su-27.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '1968-01-01',
    '1974-12-25',
    '1980-01-01',
    662.0,
    5615.0,
    (SELECT id FROM manufacturer WHERE code = 'SHX'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shaanxi Y-8'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shaanxi Y-8'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Shaanxi Y-8'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Shaanxi Y-8'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 34.02,
  wingspan          = 38.0,
  height            = 11.16,
  wing_area         = 121.86,
  empty_weight      = 35500,
  mtow              = 61000,
  service_ceiling   = 10400,
  climb_rate        = 5.9,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1800,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Zhuzhou WJ-6',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1974,
  production_end    = NULL,
  units_built       = 200,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 8,
  variants          = E'- **Y-8** : transport tactique de base, copie sans licence de l''**Antonov An-12**\n- **Y-8Q / KQ-200** : patrouille maritime à perche magnétométrique de queue\n- **KJ-200 / KJ-500** : guet aérien à antenne en poutre puis à radôme circulaire\n- **Y-9** : version très modernisée, moteurs et avionique neufs, depuis 2012\n- Plus de **trente variantes** spécialisées : le fourgon de l''armée de l''air chinoise',
  variants_en       = E'- **Y-8** : basic tactical transport, an unlicensed copy of the **Antonov An-12**\n- **Y-8Q / KQ-200** : maritime patrol with a tail magnetic anomaly boom\n- **KJ-200 / KJ-500** : airborne early warning, first with a beam array then a rotodome\n- **Y-9** : heavily modernised version with new engines and avionics, since 2012\n- More than **thirty** specialised variants: the Chinese air force''s workhorse',

  -- Strate 4 : qualitatif
  nickname          = 'Yunshuji-8',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Shaanxi_Y-8',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Shaanxi_Y-8',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alert5',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Shaanxi Y-8';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Shaanxi Y-8';
