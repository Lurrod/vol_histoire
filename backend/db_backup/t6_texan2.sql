-- Beechcraft T-6 Texan II
--
-- Photo : T-6A Texan II four-ship formation photo - Vance AFB.jpg
--   licence Public domain — United States Air Force
--   https://commons.wikimedia.org/wiki/File%3AT-6A_Texan_II_four-ship_formation_photo_-_Vance_AFB.jpg

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
    'T-6 Texan II',
    'T-6 Texan II',
    'Beechcraft T-6 Texan II',
    'Beechcraft T-6 Texan II',
    'Un Pilatus suisse américanisé, devenu l’école commune de l’US Air Force et de l’US Navy',
    'An Americanised Swiss Pilatus, now the common school of the Air Force and the Navy',
    '/assets/airplanes/t6-texan2.jpg',
    E'## Genèse\nAu début des années 1990, l''US Air Force forme sur **T-37** et l''US Navy sur **T-34**, deux appareils différents, deux chaînes logistiques, deux écoles. Le programme **JPATS** vise à n''en faire qu''une. Il exige un appareil existant et éprouvé : le **Pilatus PC-9** suisse l''emporte, à condition d''être construit aux États-Unis.\n\n## Conception\nBeechcraft ne se contente pas d''assembler : la cellule est renforcée, pressurisée, dotée de sièges éjectables zéro-zéro, d''un moteur plus puissant et d''une avionique neuve. Il ne reste finalement que **vingt pour cent** de pièces communes avec le PC-9. Le résultat vole à cinq cent quatre-vingts kilomètres-heure et encaisse sept g.\n\n## Carrière opérationnelle\nEnviron neuf cents exemplaires, treize forces aériennes. Depuis 2001, **tous** les pilotes militaires américains — Air Force, Navy, Marines, garde-côtes — commencent sur T-6. Les versions export équipent le Canada, le Royaume-Uni, l''Irak, le Mexique, le Maroc, la Nouvelle-Zélande.\n\n## Place dans l''histoire\nNeuf cents exemplaires. Le T-6 conclut le mouvement engagé par le **PC-7** vingt ans plus tôt : le turbopropulseur a définitivement remplacé le réacteur dans la formation de base, y compris chez l''armée de l''air la plus riche du monde. Le **T-37** et le **T-34** de ce catalogue lui ont tous deux cédé la place.',
    E'## Genesis\nIn the early 1990s the US Air Force trained on the **T-37** and the US Navy on the **T-34**: two different aircraft, two supply chains, two schools. The **JPATS** programme aimed to make it one. It required an existing, proven aircraft: the Swiss **Pilatus PC-9** won, on condition it be built in the United States.\n\n## Design\nBeechcraft did not merely assemble: the airframe is strengthened, pressurised, given zero-zero ejection seats, a more powerful engine and new avionics. In the end only **twenty per cent** of parts are common with the PC-9. The result flies at five hundred and eighty kilometres an hour and takes seven g.\n\n## Operational career\nSome nine hundred built, thirteen air forces. Since 2001 **every** American military pilot — Air Force, Navy, Marines, Coast Guard — starts on the T-6. Export versions serve Canada, Britain, Iraq, Mexico, Morocco and New Zealand.\n\n## Place in history\nNine hundred built. The T-6 completes the movement the **PC-7** began twenty years earlier: the turboprop has definitively replaced the jet in basic training, including in the richest air force in the world. The **T-37** and the **T-34** in this catalogue both gave way to it.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1990-01-01',
    '1998-07-15',
    '2001-05-01',
    585.0,
    1667.0,
    (SELECT id FROM manufacturer WHERE code = 'BEE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'T-6 Texan II'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'T-6 Texan II'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.16,
  wingspan          = 10.19,
  height            = 3.23,
  wing_area         = 16.3,
  empty_weight      = 2168,
  mtow              = 2903,
  service_ceiling   = 9448,
  climb_rate        = 19.3,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.5,
  combat_radius     = 700,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-68',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1998,
  production_end    = NULL,
  units_built       = 900,
  unit_cost_usd     = 4300000,
  unit_cost_year    = 2016,
  operators_count   = 13,
  variants          = E'- **T-6A** : version de base, commune à l''**US Air Force** et à l''**US Navy**\n- **T-6B** : version navale à cockpit tout-écran et symbologie tête haute\n- **T-6C** : version export à points d''emport, vendue à treize pays\n- **AT-6 Wolverine** : version d''attaque légère armée, commandée par la Thaïlande\n- Dérivé du **Pilatus PC-9** suisse, profondément remanié par Beechcraft',
  variants_en       = E'- **T-6A** : basic version, shared by the **US Air Force** and the **US Navy**\n- **T-6B** : naval version with a glass cockpit and head-up symbology\n- **T-6C** : export version with hardpoints, sold to thirteen countries\n- **AT-6 Wolverine** : armed light attack version, ordered by Thailand\n- Derived from the Swiss **Pilatus PC-9**, heavily reworked by Beechcraft',

  -- Strate 4 : qualitatif
  nickname          = 'Texan II',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beechcraft_T-6_Texan_II',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beechcraft_T-6_Texan_II',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'United States Air Force',
  image_licence     = 'Public domain'
WHERE name = 'T-6 Texan II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'T-6 Texan II';
