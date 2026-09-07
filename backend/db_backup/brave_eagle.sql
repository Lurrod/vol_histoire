-- AIDC T-5 Yong Ying (Brave Eagle)
--
-- Photo : ROCAF T-5(1108)勇鷹高教機.jpg
--   licence CC0 — 廢柴老闆
--   https://commons.wikimedia.org/wiki/File%3AROCAF_T-5%281108%29%E5%8B%87%E9%B7%B9%E9%AB%98%E6%95%99%E6%A9%9F.jpg

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
    'AIDC T-5 Brave Eagle',
    'AIDC T-5 Brave Eagle',
    'AIDC T-5 Yong Ying (Brave Eagle)',
    'AIDC T-5 Yong Ying (Brave Eagle)',
    'Taïwan réapprend à construire ses avions, faute de pouvoir en acheter',
    'Taiwan relearns how to build its aircraft, being unable to buy them',
    '/assets/airplanes/brave-eagle.jpg',
    E'## Genèse\nTaïwan ne peut pas acheter librement des avions militaires : chaque vente est un incident diplomatique, et les fournisseurs se comptent sur les doigts d''une main. En 2017, ses **AT-3** ont trente-cinq ans et ses F-5 d''entraînement davantage. Faute de pouvoir commander, l''île décide de construire — et se donne trois ans.\n\n## Conception\nLe délai n''est tenable qu''en partant de l''existant. AIDC reprend **quatre-vingts pour cent** de la cellule de son chasseur **F-CK-1 Ching-kuo** : même voilure, même architecture bimoteur, mêmes F124. Le fuselage est allongé pour la seconde place, les points d''emport et le radar sont supprimés, le carburant augmenté. C''est un Ching-kuo désarmé et rallongé.\n\n## Carrière opérationnelle\nSoixante-six exemplaires commandés, les premiers livrés fin 2021. Ils forment les pilotes taïwanais destinés aux F-16V, aux Mirage 2000 et aux Ching-kuo — les trois flottes de l''île, chacune d''origine différente, ce qui rend l''école commune d''autant plus nécessaire.\n\n## Place dans l''histoire\nSoixante-six exemplaires. Le Brave Eagle est un cas rare d''appareil conçu **par contrainte politique** plutôt que par ambition industrielle : Taïwan ne construit pas parce qu''elle le veut, mais parce qu''on lui refuse d''acheter. Le **F-CK-1** dont il dérive était né du même refus, trente-cinq ans plus tôt.',
    E'## Genesis\nTaiwan cannot buy military aircraft freely: every sale is a diplomatic incident and its suppliers can be counted on one hand. By 2017 its **AT-3s** were thirty-five years old and its training F-5s older still. Unable to order, the island decided to build — and gave itself three years.\n\n## Design\nThat schedule is only tenable by starting from what exists. AIDC reused **eighty per cent** of the airframe of its **F-CK-1 Ching-kuo** fighter: the same wing, the same twin-engine architecture, the same F124s. The fuselage is stretched for the second seat, the hardpoints and radar deleted, the fuel increased. It is a disarmed, lengthened Ching-kuo.\n\n## Operational career\nSixty-six ordered, the first delivered in late 2021. They train Taiwanese pilots destined for F-16Vs, Mirage 2000s and Ching-kuos — the island''s three fleets, each of different origin, which makes a common school all the more necessary.\n\n## Place in history\nSixty-six built. The Brave Eagle is a rare case of an aircraft designed **out of political constraint** rather than industrial ambition: Taiwan builds not because it wants to but because it is refused the chance to buy. The **F-CK-1** it derives from was born of the same refusal, thirty-five years earlier.',
    (SELECT id FROM countries WHERE code = 'TWN'),
    '2017-02-01',
    '2020-06-10',
    '2021-11-29',
    1000.0,
    2400.0,
    (SELECT id FROM manufacturer WHERE code = 'AIDC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AIDC T-5 Brave Eagle'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'AIDC T-5 Brave Eagle'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AIDC T-5 Brave Eagle'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.3,
  wingspan          = 9.5,
  height            = 4.7,
  wing_area         = 24.3,
  empty_weight      = 5000,
  mtow              = 9000,
  service_ceiling   = 14600,
  climb_rate        = NULL,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.0,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Honeywell/ITEC F124-GA-100',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 27.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2019,
  production_end    = NULL,
  units_built       = 66,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **T-5 Brave Eagle** : version d''entraînement avancé, soixante-six commandés\n- Dérivé du chasseur **F-CK-1 Ching-kuo**, dont il reprend 80 % de la cellule\n- *Yong Ying* (勇鷹) signifie « **aigle courageux** » en chinois\n- Remplace à la fois les **AT-3** et les **F-5** d''entraînement taïwanais\n- Premier vol trois ans après le lancement du programme : rare pour un avion neuf',
  variants_en       = E'- **T-5 Brave Eagle** : advanced training version, sixty-six ordered\n- Derived from the **F-CK-1 Ching-kuo** fighter, reusing 80% of its airframe\n- *Yong Ying* (勇鷹) means ''**brave eagle**'' in Chinese\n- Replaces both the **AT-3** and the training **F-5s** in Taiwanese service\n- First flight three years after programme launch: rare for a new aircraft',

  -- Strate 4 : qualitatif
  nickname          = 'Yong Ying',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/AIDC_T-5_Brave_Eagle',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AIDC_T-5_Brave_Eagle',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '廢柴老闆',
  image_licence     = 'CC0'
WHERE name = 'AIDC T-5 Brave Eagle';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AIDC T-5 Brave Eagle';
