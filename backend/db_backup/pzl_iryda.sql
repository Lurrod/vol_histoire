-- PZL I-22 Iryda
--
-- Photo : PZL I-22 Iryda M-93K - Muzeum Lotnictwa Kraków.jpg
--   licence CC BY-SA 3.0 — Jakub "flyz1" Maciejewski
--   https://commons.wikimedia.org/wiki/File:PZL_I-22_Iryda_M-93K_-_Muzeum_Lotnictwa_Krak%C3%B3w.jpg

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
    'PZL I-22 Iryda',
    'PZL I-22 Iryda',
    'PZL I-22 Iryda',
    'PZL I-22 Iryda',
    'Le biréacteur d''école polonais censé succéder à l''Iskra, englué dans vingt ans de retards et de querelles',
    'The Polish twin-jet trainer meant to succeed the Iskra, mired in twenty years of delays and disputes',
    '/assets/airplanes/pzl-iryda.jpg',
    E'## Genèse\nEn 1976, l''**Institut de l''aviation** de Varsovie lance l''étude d''un nouvel avion d''école à réaction pour remplacer le **TS-11 Iskra**, premier jet d''école conçu en Pologne. L''appareil doit être propulsé par le turboréacteur **PZL K-15**, lui aussi dessiné à l''Institut, et construit à Mielec. Le projet est achevé en 1978, approuvé en 1980, et la fabrication des prototypes commence deux ans plus tard. Baptisé **Iryda**, le premier vole le 3 mars 1985.\n\n## Conception\nL''Iryda est un biplace biréacteur à aile haute, à fuselage métallique semi-monocoque et train escamotable, dont la silhouette rappelle celle de l''**Alpha Jet**. Faute de K-15 prêts à temps, les premiers exemplaires reçoivent des PZL-5 plus anciens, jugés trop faibles. La version de série **M-93K**, enfin dotée des K-15 de 14,7 kN, double presque sa charge utile : un canon **GSh-23** et quatre points d''emport portant jusqu''à 2 000 kg de roquettes, de missiles R-60 ou de bombes. Après 1989, l''ouverture de la Pologne lui apporte un siège éjectable Martin-Baker et une avionique française Sagem.\n\n## Carrière opérationnelle\nL''armée de l''air polonaise reçoit ses premiers Iryda en 1992, puis les deux premiers M-93K de série en mai 1995. Le programme devient alors un feuilleton politique : abandon annoncé en décembre 1995 pour raisons de coût, relance par le Premier ministre en janvier 1996, puis interdiction de vol après un accident mortel le 24 janvier 1996, attribué à un problème de compensateur. Une nouvelle commande, en avril 1996, prévoit de moderniser onze appareils ; la version améliorée vole en 1997. Mais l''industriel et le ministère de la Défense se brouillent au point d''aller en justice, et la commande est annulée en 1998.\n\n## Place dans l''histoire\nAvec seulement 17 exemplaires, prototypes compris, l''Iryda illustre les difficultés de l''industrie aéronautique polonaise après les révolutions de 1989, prise entre budgets réduits et concurrence des avions occidentaux. PZL-Mielec le relance en 2002 sous le nom d''Iskra 2, avec une avionique Thales, sans trouver de client. Les derniers exemplaires sont aujourd''hui exposés dans des musées et des écoles en Pologne.',
    E'## Genesis\nIn 1976 the Warsaw **Institute of Aviation** began work on a new jet trainer to replace the **TS-11 Iskra**, the first jet trainer designed in Poland. The aircraft was to be powered by the **PZL K-15** turbojet, also designed at the Institute, and built at Mielec. The design was completed in 1978, approved in 1980, and prototype construction began two years later. Named **Iryda**, the first flew on 3 March 1985.\n\n## Design\nThe Iryda was a shoulder-wing twin-jet two-seater with an all-metal semi-monocoque fuselage and retractable undercarriage, its silhouette recalling that of the **Alpha Jet**. With the K-15 not ready in time, the first examples received older PZL-5 engines, judged underpowered. The production **M-93K**, at last fitted with 14.7 kN K-15s, almost doubled its payload: a **GSh-23** cannon and four hardpoints carrying up to 2,000 kg of rockets, R-60 missiles or bombs. After 1989, Poland''s opening brought it a Martin-Baker ejection seat and French Sagem avionics.\n\n## Operational career\nThe Polish Air Force received its first Irydas in 1992, then the first two production M-93Ks in May 1995. The programme then became a political saga: cancellation announced in December 1995 on cost grounds, revival by the Prime Minister in January 1996, then grounding after a fatal accident on 24 January 1996, blamed on a trim problem. A new order in April 1996 planned to upgrade eleven aircraft; the improved version flew in 1997. But the manufacturer and the Defence Ministry fell out to the point of going to court, and the order was cancelled in 1998.\n\n## Place in history\nWith only 17 built, prototypes included, the Iryda illustrates the difficulties of Poland''s aircraft industry after the revolutions of 1989, caught between shrinking budgets and competition from Western aircraft. PZL-Mielec relaunched it in 2002 as the Iskra 2, with Thales avionics, without finding a customer. The last examples are now displayed in museums and schools across Poland.',
    (SELECT id FROM countries WHERE code = 'POL'),
    '1976-01-01',
    '1985-03-03',
    '1992-12-22',
    940,
    1200,
    (SELECT id FROM manufacturer WHERE code = 'PZL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL I-22 Iryda'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'PZL I-22 Iryda'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'PZL I-22 Iryda'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'PZL I-22 Iryda'), (SELECT id FROM armement WHERE name = 'FAB-250'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL I-22 Iryda'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'PZL I-22 Iryda'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.22,
  wingspan          = 9.6,
  height            = 4.3,
  wing_area         = 19.92,
  empty_weight      = 4600,
  mtow              = 7500,
  service_ceiling   = 13700,
  climb_rate        = 40.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'PZL K-15',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 14.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 17,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **I-22** : prototypes et premiers exemplaires à réacteurs PZL-5 provisoires\n- **M-93K** : version de série à réacteurs PZL K-15, livrée à partir de 1995\n- **M-93V** : version à réacteurs Rolls-Royce Viper 545, premier vol le 24 avril 1994\n- **M-96** : version améliorée de 1997, volets Fowler, empennage modifié et avionique Sextant\n- **Iskra 2** : relance de 2002 avec avionique Thales et points d''emport sous les ailes',
  variants_en       = E'- **I-22**: prototypes and early examples with interim PZL-5 engines\n- **M-93K**: production version with PZL K-15 engines, delivered from 1995\n- **M-93V**: version with Rolls-Royce Viper 545 engines, first flight on 24 April 1994\n- **M-96**: improved 1997 version with Fowler flaps, modified tail and Sextant avionics\n- **Iskra 2**: 2002 relaunch with Thales avionics and underwing hardpoints',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/PZL_I-22_Iryda',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/PZL_I-22_Iryda',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jakub "flyz1" Maciejewski',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'PZL I-22 Iryda';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'PZL I-22 Iryda';
