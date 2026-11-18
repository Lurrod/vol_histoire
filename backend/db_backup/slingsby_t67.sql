-- Slingsby T67 Firefly
--
-- Photo : Slingsby.firefly.t67m.fairford2006.arp.jpg
--   licence Public domain — Adrian Pingstone
--   https://commons.wikimedia.org/wiki/File:Slingsby.firefly.t67m.fairford2006.arp.jpg

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
    'Slingsby T67 Firefly',
    'Slingsby T67 Firefly',
    'Slingsby T67 Firefly',
    'Slingsby T67 Firefly',
    'Biplace de voltige en composites né du Fournier RF-6, école de la RAF et, sous le nom de T-3A, de l''US Air Force',
    'Composite aerobatic two-seater born of the Fournier RF-6, trainer for the RAF and, as the T-3A, the US Air Force',
    '/assets/airplanes/slingsby-t67-firefly.jpg',
    E'## Genèse\nL''histoire commence en France avec le **Fournier RF-6**, dessiné par **René Fournier** et envolé le 12 mars 1974 : un biplace tout en bois, à l''aile de grand allongement héritée de ses motoplaneurs. Faute de rentabilité, sa petite usine de Nitray, près de Tours, ferme après une quarantaine d''exemplaires. En 1981, Fournier cède les droits du RF-6B au britannique **Slingsby Aviation**, installé à Kirkbymoorside, dans le Yorkshire, qui le rebaptise **T67**. Les premiers T67A sont presque identiques aux avions français, mais la structure en bois cède vite la place aux matériaux composites.\n\n## Conception\nSlingsby fait évoluer la cellule en montant des moteurs de plus en plus puissants. Le **T67M**, envolé le 5 décembre 1982 et destiné au marché militaire, est le premier à recevoir une hélice à pas variable et des circuits d''essence et d''huile pour le vol dos. Le **T67M260**, certifié en 1993, porte un six-cylindres Lycoming de 260 ch ; ses deux pilotes sont assis côte à côte, mais il se pilote seul depuis la place de droite, pour habituer l''élève à la manette des gaz à gauche des avions militaires. L''avion monte à 7 m/s et dépasse 280 km/h, mais il sort mal de vrille, défaut lié à au moins 36 accidents mortels.\n\n## Carrière opérationnelle\nLe plus gros client est l''**US Air Force** : choisi en 1992 pour remplacer le **Cessna T-41** dans la sélection des futurs pilotes, voltige comprise, le **T-3A Firefly** est livré à 113 exemplaires de 1993 à 1995, au Texas et à l''Air Force Academy du Colorado. En juillet 1997, après des arrêts moteur et trois accidents graves qui tuent trois élèves officiers et trois instructeurs, toute la flotte est clouée au sol, puis ferraillée en 2006. Au Royaume-Uni, 22 T67M260 forment de 1995 à 2010 les élèves de l''armée de terre, de la Royal Navy et de la **RAF**, plus de 100 000 heures de vol, avant de céder la place au Grob Tutor. Le Canada, Hong Kong, la Jordanie et Bahreïn l''emploient aussi.\n\n## Place dans l''histoire\nPlus de 250 Firefly ont été construits, surtout des T67M260 et des T-3A. L''avion illustre le modèle britannique de l''école militaire confiée à un industriel, dont la société possède et exploite les appareils pour les armées. Au Canada, où il sert sous le nom de **CT-111** à partir de 1992, il est remplacé en 2006 par le **Grob G 120**. Son passage américain reste une affaire controversée : les essais menés à Edwards n''ont trouvé aucun défaut du circuit carburant, et l''altitude de l''Académie comme l''inexpérience en voltige des instructeurs ont pesé.',
    E'## Genesis\nThe story begins in France with the **Fournier RF-6**, designed by **René Fournier** and first flown on 12 March 1974: an all-wooden two-seater whose high aspect-ratio wing echoed his motorgliders. Unable to make it pay, his small factory at Nitray, near Tours, closed after around forty aircraft. In 1981 Fournier sold the rights to the RF-6B to the British firm **Slingsby Aviation**, based at Kirkbymoorside in Yorkshire, which renamed it the **T67**. The first T67As were almost identical to the French aircraft, but the wooden structure soon gave way to composite materials.\n\n## Design\nSlingsby developed the airframe with progressively more powerful engines. The **T67M**, first flown on 5 December 1982 and aimed at the military market, was the first to receive a constant-speed propeller and fuel and oil systems for inverted flight. The **T67M260**, certified in 1993, carried a 260 hp Lycoming six-cylinder; its two pilots sat side by side, but it was flown solo from the right-hand seat, to accustom students to the left-hand throttle of military aircraft. The aircraft climbed at 7 m/s and exceeded 280 km/h, but it recovered poorly from spins, a weakness linked to at least 36 fatal accidents.\n\n## Operational career\nThe largest customer was the **US Air Force**: selected in 1992 to replace the **Cessna T-41** in screening future pilots, aerobatics included, the **T-3A Firefly** was delivered in 113 examples from 1993 to 1995, to Texas and to the Air Force Academy in Colorado. In July 1997, after engine stoppages and three serious accidents that killed three cadets and three instructors, the whole fleet was grounded, then scrapped in 2006. In the United Kingdom, 22 T67M260s trained Army, Royal Navy and **RAF** students from 1995 to 2010, flying more than 100,000 hours, before giving way to the Grob Tutor. Canada, Hong Kong, Jordan and Bahrain also used it.\n\n## Place in history\nMore than 250 Fireflies were built, mainly T67M260s and T-3As. The aircraft illustrates the British model of military training handed to industry, with a company owning and operating the aircraft for the armed forces. In Canada, where it served as the **CT-111** from 1992, it was replaced in 2006 by the **Grob G 120**. Its American episode remains controversial: tests at Edwards found no fault in the fuel system, and both the Academy''s altitude and the instructors'' limited aerobatic experience played a part.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1981-01-01',
    '1982-12-05',
    '1992-01-01',
    281,
    753,
    (SELECT id FROM manufacturer WHERE code = 'SLI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Slingsby T67 Firefly'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Slingsby T67 Firefly'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Slingsby T67 Firefly'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.55,
  wingspan          = 10.69,
  height            = 2.36,
  wing_area         = 12.6,
  empty_weight      = 794,
  mtow              = 1157,
  service_ceiling   = 5790,
  climb_rate        = 7.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Textron Lycoming AEIO-540-D (260 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1981,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 8,
  variants          = E'- **T67A / T67B** : premières versions civiles, en bois puis en composites, moteur de 118 ch\n- **T67M / T67M MkII** : première version militaire (1982), hélice à pas variable et circuits pour le vol dos, 160 ch\n- **T67M200** : moteur de 200 ch et hélice tripale\n- **T67M260** : six-cylindres de 260 ch, école de base britannique de 1995 à 2010\n- **T-3A Firefly** : T67M260 climatisé de l''US Air Force, 114 exemplaires\n- **CT-111** : désignation canadienne du T67C, de 1992 à 2006',
  variants_en       = E'- **T67A / T67B**: first civil versions, in wood then composites, 118 hp engine\n- **T67M / T67M MkII**: first military version (1982), constant-speed propeller and inverted-flight systems, 160 hp\n- **T67M200**: 200 hp engine and three-blade propeller\n- **T67M260**: 260 hp six-cylinder, British basic trainer from 1995 to 2010\n- **T-3A Firefly**: air-conditioned T67M260 for the US Air Force, 114 built\n- **CT-111**: Canadian designation of the T67C, from 1992 to 2006',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fournier_RF-6',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Slingsby_T67_Firefly',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Adrian Pingstone',
  image_licence     = 'Public domain'
WHERE name = 'Slingsby T67 Firefly';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Slingsby T67 Firefly';
