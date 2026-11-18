-- Aerotec A-122 Uirapuru (T-23)
--
-- Photo : Aerotec A-122 FAB-174, Santa Cruz, Bolivia Nov92 (50701559778).jpg
--   licence CC BY 4.0 — Peter Garwood
--   https://commons.wikimedia.org/wiki/File:Aerotec_A-122_FAB-174,_Santa_Cruz,_Bolivia_Nov92_(50701559778).jpg

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
    'Aerotec T-23 Uirapuru',
    'Aerotec T-23 Uirapuru',
    'Aerotec A-122 Uirapuru (T-23)',
    'Aerotec A-122 Uirapuru (T-23)',
    'Le petit biplace côte à côte qui a formé les élèves de l''Académie de l''air brésilienne, de Bolivie et du Paraguay',
    'The small side-by-side two-seater that trained cadets of the Brazilian Air Force Academy, Bolivia and Paraguay',
    '/assets/airplanes/aerotec-t23-uirapuru.jpg',
    E'## Genèse\nAu milieu des années 1960, l''**Académie de l''air brésilienne** forme encore ses élèves sur des **Fokker S.11** et **S.12** devenus vétustes, désignés T-21 et T-22. Le constructeur brésilien **Aerotec** propose pour les remplacer un petit avion d''entraînement élémentaire, l''**A-122 Uirapuru**. Le prototype vole le 2 juin 1965 avec un moteur Lycoming de 108 ch. En octobre 1967, la force aérienne brésilienne commande 30 appareils, désignés **T-23**, puis deux nouvelles tranches de 40 et de 30 avions.\n\n## Conception\nL''Uirapuru est un monoplan à aile basse cantilever et train tricycle fixe, où l''élève et l''instructeur sont assis côte à côte. La version militaire reçoit un Lycoming O-320 de 160 ch, qui entraîne une hélice bipale à pas fixe. Long de 6,60 m pour 8,50 m d''envergure, l''avion ne pèse que 840 kg au décollage, atteint 225 km/h et tient l''air quatre heures, pour 800 km de distance franchissable. Après plusieurs accidents mortels à l''entraînement à la vrille, le témoignage d''un instructeur, qui décrit jusqu''au bout les réactions de son avion à ses commandes, révèle un manque d''efficacité des gouvernes : tous les Uirapuru reçoivent alors une quille ventrale sous l''arrière du fuselage.\n\n## Carrière opérationnelle\nLes livraisons à la force aérienne brésilienne commencent en 1969, et les T-23 servent à l''Académie de l''air à partir de 1970. À l''étranger, la **force aérienne bolivienne** commande des A-122 en 1974 et les fait voler jusqu''en 1997 à son école d''El Trompillo. Le Paraguay en achète huit en 1975 pour remplacer ses Fokker T-21, puis en reçoit six autres du Brésil en 1986. Une trentaine d''appareils sont aussi vendus sur le marché civil brésilien.\n\n## Place dans l''histoire\nAu total, 155 Uirapuru sont construits, prototypes compris, jusqu''à l''arrêt de la production en 1977. Conçu et produit au Brésil, l''avion a fourni pendant des années la première étape de la formation des pilotes militaires de trois pays d''Amérique du Sud. En 1980, l''intérêt de l''armée de l''air pour une version améliorée donne l''**Uirapuru II**, devenu A-132 Tangará, plus gros et plus puissant ; mais la force aérienne brésilienne décide entre-temps de ne plus utiliser que des biplaces en tandem pour l''instruction initiale et abandonne le programme. En 2009, un seul T-23 était encore en état de vol.',
    E'## Genesis\nIn the mid-1960s the **Brazilian Air Force Academy** was still training its cadets on obsolete **Fokker S.11s** and **S.12s**, designated T-21 and T-22. The Brazilian manufacturer **Aerotec** offered a small primary trainer to replace them, the **A-122 Uirapuru**. The prototype flew on 2 June 1965 with a 108 hp Lycoming engine. In October 1967 the Brazilian Air Force ordered 30 aircraft, designated **T-23**, followed by two further batches of 40 and 30.\n\n## Design\nThe Uirapuru is a cantilever low-wing monoplane with a fixed tricycle undercarriage, the student and instructor sitting side by side. The military version received a 160 hp Lycoming O-320 driving a fixed-pitch two-blade propeller. At 6.60 m long with an 8.50 m span, the aircraft weighed only 840 kg at take-off, reached 225 km/h and could stay aloft for four hours, with a range of 800 km. After several fatal accidents during spin training, the account of an instructor, who described his aircraft''s responses to his control inputs right to the end, revealed a lack of control effectiveness: all Uirapurus then received a ventral fin under the rear fuselage.\n\n## Operational career\nDeliveries to the Brazilian Air Force began in 1969, and the T-23s served at the Air Force Academy from 1970. Abroad, the **Bolivian Air Force** ordered A-122s in 1974 and flew them until 1997 at its El Trompillo school. Paraguay bought eight in 1975 to replace its Fokker T-21s, then received six more from Brazil in 1986. Some thirty aircraft were also sold on the Brazilian civil market.\n\n## Place in history\nIn all, 155 Uirapurus were built, prototypes included, before production ended in 1977. Designed and built in Brazil, the aircraft provided for years the first stage of military pilot training in three South American countries. In 1980 the air force''s interest in an improved version led to the **Uirapuru II**, later the A-132 Tangará, larger and more powerful; but the Brazilian Air Force had meanwhile decided to use only tandem two-seaters for initial training, and it dropped the programme. By 2009 only one T-23 was still airworthy.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    NULL,
    '1965-06-02',
    '1970-01-01',
    225,
    800,
    (SELECT id FROM manufacturer WHERE code = 'AET'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aerotec T-23 Uirapuru'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aerotec T-23 Uirapuru'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 6.6,
  wingspan          = 8.5,
  height            = 2.7,
  wing_area         = 13.5,
  empty_weight      = 540,
  mtow              = 840,
  service_ceiling   = 4500,
  climb_rate        = 4.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming O-320-B2B (160 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1968,
  production_end    = 1977,
  units_built       = 155,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **A-122A (T-23)** : version militaire de la force aérienne brésilienne, exportée en Bolivie et au Paraguay\n- **A-122B** : version civile\n- **A-122C (T-23C)** : version à verrière redessinée, vendue surtout sur le marché civil brésilien\n- **A-132 Tangará (Uirapuru II)** : version agrandie à verrière améliorée et dérive plus haute, prototype en 1981, abandonnée par le Brésil',
  variants_en       = E'- **A-122A (T-23)**: military version for the Brazilian Air Force, exported to Bolivia and Paraguay\n- **A-122B**: civil version\n- **A-122C (T-23C)**: version with a redesigned canopy, sold mainly on the Brazilian civil market\n- **A-132 Tangará (Uirapuru II)**: enlarged version with an improved canopy and taller fin, prototype in 1981, dropped by Brazil',

  -- Strate 4 : qualitatif
  nickname          = 'Uirapuru',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aerotec_Uirapuru',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aerotec_A-122_Uirapuru',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Peter Garwood',
  image_licence     = 'CC BY 4.0'
WHERE name = 'Aerotec T-23 Uirapuru';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aerotec T-23 Uirapuru';
