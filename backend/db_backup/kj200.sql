-- Shaanxi KJ-200 (GX-5)
--
-- Photo : KJ-200H 9371 20160131.jpg
--   licence CC BY 4.0 — 日本防衛省・統合幕僚監部
--   https://commons.wikimedia.org/wiki/File:KJ-200H_9371_20160131.jpg

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
    'Shaanxi KJ-200',
    'Shaanxi KJ-200',
    'Shaanxi KJ-200 (GX-5)',
    'Shaanxi KJ-200 (GX-5)',
    'Le guet aérien que la Chine a dû inventer seule, une poutre radar sur le dos d''un Y-8',
    'The early warning aircraft China had to build alone, a radar beam on the back of a Y-8',
    '/assets/airplanes/kj200.jpg',
    E'## Genèse\nÀ la fin des années 1990, l''armée de l''air chinoise mesure qu''elle ne dispose d''aucun moyen de guet aérien digne de ce nom. Elle compte sur le radar israélien **EL/W-2090 Phalcon**, mais les États-Unis bloquent la vente. Le développement d''un appareil national commence en 2002 chez **Shaanxi**, sous la direction de l''ingénieur en chef **Ouyang Shaoxiu**. La base retenue est le cargo **Shaanxi Y-8**, version chinoise de l''An-12, dont 80 % de la cellule sont modifiés.\n\n## Conception\nLe capteur principal est un radar à antenne active **JY-06**, logé dans un long carénage plat posé sur le dos du fuselage, la « poutre d''équilibre » qui a donné son surnom à l''avion. Cette disposition rappelle celle du radar suédois **Erieye**, qui équipe notamment l''Embraer R-99 brésilien. D''autres carénages garnissent le nez, l''empennage et les extrémités de voilure, et l''appareil vole sur quatre turbopropulseurs à hélices à six pales. Le reste de l''avion garde l''architecture du cargo : un monoplan à aile haute, entièrement métallique.\n\n## Carrière opérationnelle\nLe premier vol a lieu en janvier 2005. L''année suivante, le 4 juin 2006, le deuxième prototype s''écrase dans le xian de Guangde à cause d''un givrage des ailes, tuant les quarante personnes à bord, pour l''essentiel des ingénieurs et des techniciens : l''accident manque de faire dérailler le programme. Le KJ-200 entre pourtant en service en 2007 et se montre au public lors du défilé de la fête nationale de 2009. En février 2017, un KJ-200 et un **P-3 Orion** américain se croisent à moins de 300 m au-dessus de la mer de Chine méridionale.\n\n## Place dans l''histoire\nLe KJ-200 est l''avion de la contrainte : privée du Phalcon, la Chine a dû apprendre seule à intégrer un radar de guet sur un avion, avant que le **KJ-500**, plus performant et bâti sur le Y-9, ne prenne le relais. Une dizaine d''exemplaires servent dans l''armée de l''air et l''aéronavale chinoises, et le type continue d''évoluer : le KJ-200A au nez redessiné apparaît en 2016, une version dotée d''une perche de ravitaillement est observée, et le KJ-200B, équipé de communications par satellite, entre en service en 2023.',
    E'## Genesis\nIn the late 1990s the Chinese air force realised that it had no real airborne early warning capability. It counted on the Israeli **EL/W-2090 Phalcon** radar, but the United States blocked the sale. Development of a domestic aircraft began in 2002 at **Shaanxi**, under chief designer **Ouyang Shaoxiu**. The chosen basis was the **Shaanxi Y-8** freighter, the Chinese version of the An-12, 80% of whose airframe was modified.\n\n## Design\nThe main sensor is a **JY-06** active electronically scanned array radar, housed in a long flat fairing on the back of the fuselage, the "balance beam" that gave the aircraft its nickname. The layout recalls the Swedish **Erieye** radar, used among others by Brazil''s Embraer R-99. Other fairings adorn the nose, the tail and the wingtips, and the aircraft flies on four turboprops with six-blade propellers. The rest of the aircraft keeps the freighter''s architecture: an all-metal high-wing monoplane.\n\n## Operational career\nThe first flight took place in January 2005. The following year, on 4 June 2006, the second prototype crashed in Guangde county because of wing icing, killing all forty people aboard, mostly engineers and technicians: the accident almost derailed the programme. The KJ-200 nevertheless entered service in 2007 and made its public debut at the 2009 National Day parade. In February 2017 a KJ-200 and an American **P-3 Orion** passed within 300 m of each other over the South China Sea.\n\n## Place in history\nThe KJ-200 is the aircraft of necessity: denied the Phalcon, China had to learn on its own how to integrate an early warning radar into an aircraft, before the more capable **KJ-500**, built on the Y-9, took over. Around ten examples serve with the Chinese air force and naval aviation, and the type keeps evolving: the KJ-200A with a reshaped nose appeared in 2016, a version with a refuelling probe has been observed, and the KJ-200B, fitted with satellite communications, entered service in 2023.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2002-01-01',
    '2005-01-01',
    '2007-01-01',
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'SHX'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-200'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-200'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-200'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-200'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

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
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = NULL,
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 11,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **KJ-200** : version de base sur cellule de Y-8, radar JY-06 en « poutre » dorsale\n- **KJ-200A** : nez redessiné et électronique nouvelle, observé pour la première fois en décembre 2016\n- **« KJ-200AG »** : désignation officieuse d''un KJ-200A doté d''une perche de ravitaillement en vol\n- **KJ-200H** : version modifiée pour l''aéronavale chinoise\n- **KJ-200B** : communications par satellite et électronique nouvelle, en service depuis 2023',
  variants_en       = E'- **KJ-200**: basic version on the Y-8 airframe, JY-06 radar in a dorsal "beam"\n- **KJ-200A**: reshaped nose and new electronics, first observed in December 2016\n- **"KJ-200AG"**: unofficial designation of a KJ-200A fitted with an in-flight refuelling probe\n- **KJ-200H**: modified version for Chinese naval aviation\n- **KJ-200B**: satellite communications and new electronics, in service since 2023',

  -- Strate 4 : qualitatif
  nickname          = 'Moth',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Shaanxi_KJ-200',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Shaanxi_KJ-200',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Joint Staff Office, Japan Ministry of Defense',
  image_licence     = 'CC BY 4.0'
WHERE name = 'Shaanxi KJ-200';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Shaanxi KJ-200';
