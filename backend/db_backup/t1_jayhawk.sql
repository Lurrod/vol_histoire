-- Raytheon T-1A Jayhawk
--
-- Photo : A T-1A Jayhawk takes off during the 99th Flying Training Squadron’s final T-1A flight from Randolph Air Force Base, Texas. July 15, 2024.jpg
--   licence Public domain — Sean Worrell
--   https://commons.wikimedia.org/wiki/File:A_T-1A_Jayhawk_takes_off_during_the_99th_Flying_Training_Squadron%E2%80%99s_final_T-1A_flight_from_Randolph_Air_Force_Base,_Texas._July_15,_2024.jpg

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
    'Raytheon T-1 Jayhawk',
    'Raytheon T-1 Jayhawk',
    'Raytheon T-1A Jayhawk',
    'Raytheon T-1A Jayhawk',
    'Biréacteur d''affaires Beechjet devenu l''école des futurs pilotes de transport et de ravitailleurs de l''US Air Force',
    'Beechjet business twinjet turned school for the US Air Force''s future airlift and tanker pilots',
    '/assets/airplanes/t1-jayhawk.jpg',
    E'## Genèse\nÀ la fin des années 1980, l''US Air Force veut former les pilotes destinés aux avions de transport et aux ravitailleurs sur un biréacteur proche des appareils qu''ils piloteront ensuite. Elle retient une version militaire du **Beechjet 400A**, l''avion d''affaires de Beechcraft, alors propriété de **Raytheon**. Le T-1A vole le 5 juillet 1991 et le premier exemplaire est livré à Reese, au Texas, le 17 janvier 1992 ; la formation des élèves commence en 1993. Au total, 180 T-1A sont livrés entre 1992 et 1997.\n\n## Conception\nLe T-1A conserve l''aile en flèche et les deux turbosoufflantes Pratt & Whitney Canada **JT15D-5B** de 13 kN du Beechjet, qui le poussent à Mach 0,78. Son cockpit accueille un instructeur et deux élèves. Il diffère de l''avion civil par une structure renforcée pour encaisser un grand nombre d''atterrissages par heure de vol, une meilleure résistance aux impacts d''oiseaux et un réservoir de fuselage supplémentaire, qui porte son autonomie à 5 400 km. Le Japon en commande une variante, le **T-400**, qui partage le même certificat de type.\n\n## Carrière opérationnelle\nLe Jayhawk assure la phase avancée de la formation des pilotes de l''USAF sélectionnés pour le transport aérien stratégique et tactique et pour le ravitaillement, dans les escadrons de Randolph, Columbus, Laughlin et Vance. Il forme aussi les officiers systèmes de combat au vol à haute et basse altitude, et remplace ou complète le **T-39 Sabreliner** pour les navigateurs de la Navy et du Marine Corps jusqu''à la séparation des filières en 2010. Au Japon, les 13 T-400 servent à Miho pour les équipages de transport. Début 2024, 178 T-1A figurent encore à l''inventaire.\n\n## Place dans l''histoire\nLe T-1 incarne la spécialisation de la formation des pilotes militaires : plutôt que de tous passer par un jet d''entraînement supersonique, les futurs pilotes de transport apprennent sur un avion d''affaires qui annonce le cockpit d''un C-17 ou d''un KC-135. Sa désignation reprend celle du T-1 SeaStar, retiré depuis longtemps. En 2024, l''USAF décide d''en retirer jusqu''à 52 malgré l''opposition du Congrès et en propose quatre à l''Uruguay ; il n''en reste que 43 en ligne au 30 septembre 2025.',
    E'## Genesis\nIn the late 1980s the US Air Force wanted to train pilots bound for airlifters and tankers on a twinjet close to the aircraft they would fly next. It chose a military version of the **Beechjet 400A**, the business jet built by Beechcraft, then owned by **Raytheon**. The T-1A flew on 5 July 1991 and the first example was delivered to Reese, Texas, on 17 January 1992; student training began in 1993. In all, 180 T-1As were delivered between 1992 and 1997.\n\n## Design\nThe T-1A keeps the Beechjet''s swept wing and two 13 kN Pratt & Whitney Canada **JT15D-5B** turbofans, good for Mach 0.78. Its cockpit seats an instructor and two students. It differs from the civil aircraft in a structure strengthened for a large number of landings per flight hour, greater bird-strike resistance and an extra fuselage fuel tank, which brings its range to 5,400 km. Japan ordered a variant, the **T-400**, which shares the same type certificate.\n\n## Operational career\nThe Jayhawk flew the advanced phase of training for USAF pilots selected for strategic and tactical airlift and for tankers, in squadrons at Randolph, Columbus, Laughlin and Vance. It also trained combat systems officers in high- and low-level flying, and replaced or supplemented the **T-39 Sabreliner** for Navy and Marine Corps flight officers until the training pipelines split in 2010. In Japan the 13 T-400s served at Miho for transport crews. In early 2024, 178 T-1As were still on the inventory.\n\n## Place in history\nThe T-1 embodies the specialisation of military pilot training: rather than all going through a supersonic jet trainer, future transport pilots learn on a business jet that prefigures the cockpit of a C-17 or a KC-135. Its designation reuses that of the long-retired T-1 SeaStar. In 2024 the USAF decided to retire up to 52 of them despite opposition in Congress and offered four to Uruguay; only 43 remained in line on 30 September 2025.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1991-07-05',
    '1992-01-17',
    867,
    5400,
    (SELECT id FROM manufacturer WHERE code = 'BEE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Raytheon T-1 Jayhawk'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Raytheon T-1 Jayhawk'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Raytheon T-1 Jayhawk'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.76,
  wingspan          = 13.26,
  height            = 4.24,
  wing_area         = 22.43,
  empty_weight      = 4740,
  mtow              = 7303,
  service_ceiling   = 12500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada JT15D-5B',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 12.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1992,
  production_end    = 1997,
  units_built       = 180,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Beechjet / Hawker 400A** : avion d''affaires civil dont le T-1A est la version militaire\n- **T-1A** : école de l''USAF à deux JT15D-5B, structure renforcée et réservoir de fuselage supplémentaire, 180 construits\n- **T-400 (400T)** : version de la force aérienne d''autodéfense japonaise à JT15D-5F, projet TX, 13 construits',
  variants_en       = E'- **Beechjet / Hawker 400A**: civil business jet of which the T-1A is the military version\n- **T-1A**: USAF trainer with two JT15D-5Bs, strengthened structure and extra fuselage tank, 180 built\n- **T-400 (400T)**: Japan Air Self-Defense Force version with JT15D-5F engines, TX project, 13 built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Raytheon_T-1_Jayhawk',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Raytheon_T-1_Jayhawk',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Sean Worrell, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Raytheon T-1 Jayhawk';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Raytheon T-1 Jayhawk';
