-- Rhein-Flugzeugbau Fantrainer
--
-- Photo : RFB Fanjet 600 (c-n 005, D-EIWZ) 2025-09-10 Andre Gerwing Collection ID 025071.jpg
--   licence CC BY-SA 4.0 — André Gerwing
--   https://commons.wikimedia.org/wiki/File:RFB_Fanjet_600_(c-n_005,_D-EIWZ)_2025-09-10_Andre_Gerwing_Collection_ID_025071.jpg

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
    'RFB Fantrainer',
    'RFB Fantrainer',
    'Rhein-Flugzeugbau Fantrainer',
    'Rhein-Flugzeugbau Fantrainer',
    'L''avion-école allemand à soufflante carénée, qui offrait les sensations d''un jet pour le prix d''une hélice',
    'The German ducted-fan trainer that offered the feel of a jet for the cost of a propeller aircraft',
    '/assets/airplanes/rfb-fantrainer.jpg',
    E'## Genèse\nDans les années 1960, la société allemande **Rhein-Flugzeugbau** s''intéresse à la propulsion par soufflante carénée intégrée au fuselage et en essaie le principe sur deux planeurs modifiés, en 1969 et 1971. En 1970, elle lance l''étude d''un biplace d''entraînement militaire qui offrirait le comportement d''un avion à réaction pour un coût modeste. En mars 1975, le ministère ouest-allemand de la Défense lui commande deux prototypes, à évaluer pour remplacer les **Piaggio P.149** de la Luftwaffe. Le premier vole le 27 octobre 1977, propulsé par deux moteurs rotatifs Wankel.\n\n## Conception\nLe Fantrainer loge au milieu du fuselage, derrière la cabine, une soufflante carénée à cinq pales entraînée par une turbine **Allison 250**. Le pilote dispose d''une seule manette de puissance, comme sur un réacteur, et l''avion consomme en moyenne dix fois moins de carburant que l''**Alpha Jet**. La cabine en plastique moulé, fixée sur une poutre-caisson métallique, peut imiter celle de l''avion d''armes du client. L''aile en flèche inversée de 6°, reprise de l''avion expérimental LFU 205, dégage la vue de l''instructeur assis à l''arrière ; ailerons et aérofreins mêlent fibres de carbone et de verre.\n\n## Carrière opérationnelle\nLe Wankel se montre capricieux, et le second prototype, motorisé par l''Allison, s''écrase le 7 septembre 1978. Évalué face au **Beechcraft T-34C** et au **Pilatus PC-7**, le Fantrainer est jugé le plus adapté et le moins cher des trois, mais la Luftwaffe estime ses P.149 encore suffisants et ne commande rien. En août 1982, la Thaïlande achète 47 appareils, 31 Fantrainer 400 et 16 Fantrainer 600 : les quatre premiers sont construits en Allemagne, les autres assemblés sur place. Au 402e escadron, ils préparent les futurs pilotes de **F-5**.\n\n## Place dans l''histoire\nConstruit à 50 exemplaires, le Fantrainer est resté une curiosité commerciale, mais sa formule a eu une suite : avec Rockwell, RFB en tire au début des années 1990 le **Ranger 2000** à turboréacteur, battu par le **T-6 Texan II** dans la compétition américaine JPATS. Depuis 2010, la société **FanJet Aviation** détient la documentation, l''outillage et les droits du type, et cherche à relancer le Fantrainer 600 sous le nom de Fanjet 600, avec une cabine modernisée.',
    E'## Genesis\nIn the 1960s the German company **Rhein-Flugzeugbau** took an interest in ducted fans built into the fuselage, testing the principle on two modified gliders in 1969 and 1971. In 1970 it began work on a two-seat military trainer offering jet-like handling at modest cost. In March 1975 the West German Defence Ministry ordered two prototypes, to be evaluated as replacements for the Luftwaffe''s **Piaggio P.149s**. The first flew on 27 October 1977, powered by two Wankel rotary engines.\n\n## Design\nThe Fantrainer housed a five-bladed ducted fan in the middle of the fuselage, behind the cockpit, driven by an **Allison 250** turboshaft. The pilot had a single power lever, as on a jet, and the aircraft burned on average a tenth of the fuel of an **Alpha Jet**. The moulded plastic cockpit, fixed to a metal box keel, could be shaped to imitate that of the customer''s combat aircraft. The 6° forward-swept wing, taken from the experimental LFU 205, kept the wing root out of the rear instructor''s view; ailerons and air brakes mixed carbon and glass fibre.\n\n## Operational career\nThe Wankel engines proved troublesome, and the second prototype, powered by the Allison, crashed on 7 September 1978. Evaluated against the **Beechcraft T-34C** and the **Pilatus PC-7**, the Fantrainer was judged the most suitable and the cheapest of the three, but the Luftwaffe considered its P.149s still adequate and ordered none. In August 1982 Thailand bought 47 aircraft, 31 Fantrainer 400s and 16 Fantrainer 600s: the first four were built in Germany, the rest assembled locally. With 402 Squadron they prepared future **F-5** pilots.\n\n## Place in history\nWith 50 built, the Fantrainer remained a commercial curiosity, but its formula had a sequel: with Rockwell, RFB derived the jet-powered **Ranger 2000** from it in the early 1990s, beaten by the **T-6 Texan II** in the American JPATS competition. Since 2010 **FanJet Aviation** has held the type''s documentation, tooling and rights, and is seeking to relaunch the Fantrainer 600 as the Fanjet 600 with a modernised cockpit.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1970-01-01',
    '1977-10-27',
    '1982-01-01',
    417,
    1037,
    (SELECT id FROM manufacturer WHERE code = 'RFB'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'RFB Fantrainer'), (SELECT id FROM tech WHERE name = 'Soufflante carénée')),
((SELECT id FROM airplanes WHERE name = 'RFB Fantrainer'), (SELECT id FROM tech WHERE name = 'Aile en flèche inversée')),
((SELECT id FROM airplanes WHERE name = 'RFB Fantrainer'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'RFB Fantrainer'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.2,
  wingspan          = 9.74,
  height            = 3.16,
  wing_area         = 14.0,
  empty_weight      = 1160,
  mtow              = 2300,
  service_ceiling   = 7620,
  climb_rate        = 15.0,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Allison 250-C30 (650 ch), entraînant une soufflante carénée',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1982,
  production_end    = NULL,
  units_built       = 50,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **AWI-2** : premier prototype, deux moteurs Wankel de 150 ch, remotorisé en 1978 avec une turbine Allison\n- **ATI-2** : second prototype à turbine Allison 250-C20B, détruit le 7 septembre 1978\n- **Fantrainer 400** : fuselage allongé et turbine Allison 250-C20B de 545 ch ; B.F.18 dans l''armée de l''air thaïlandaise\n- **Fantrainer 600** : version améliorée à turbine Allison 250-C30 de 650 ch ; B.F.18A en Thaïlande\n- **Ranger 2000** : dérivé à turboréacteur Pratt & Whitney Canada JT15D développé avec Rockwell pour la compétition JPATS',
  variants_en       = E'- **AWI-2**: first prototype, two 150 hp Wankel engines, re-engined with an Allison turboshaft in 1978\n- **ATI-2**: second prototype with an Allison 250-C20B turboshaft, destroyed on 7 September 1978\n- **Fantrainer 400**: stretched fuselage and 545 hp Allison 250-C20B; B.F.18 in the Royal Thai Air Force\n- **Fantrainer 600**: improved version with a 650 hp Allison 250-C30; B.F.18A in Thailand\n- **Ranger 2000**: jet derivative with a Pratt & Whitney Canada JT15D, developed with Rockwell for the JPATS competition',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/RFB_Fantrainer',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/RFB_Fantrainer',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'André Gerwing',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'RFB Fantrainer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'RFB Fantrainer';
