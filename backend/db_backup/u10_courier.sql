-- Helio U-10 Super Courier
--
-- Photo : U-10B 5th SOS over Vietnam 1969.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:U-10B_5th_SOS_over_Vietnam_1969.jpg

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
    'Helio U-10 Courier',
    'Helio U-10 Courier',
    'Helio U-10 Super Courier',
    'Helio U-10 Super Courier',
    'Un avion de brousse qui décolle en quelques longueurs, outil discret des commandos et d''Air America au Vietnam',
    'A bush plane that took off in a few lengths, a discreet tool of commandos and Air America in Vietnam',
    '/assets/airplanes/u10-courier.jpg',
    E'## Genèse\nLe professeur **Otto C. Koppen**, qui avait dessiné pour Ford le petit avion populaire Flivver, conçoit le Courier autour d''une idée : voler très lentement sans danger. Son démonstrateur, le **Helioplane n° 1**, est tiré d''un Piper PA-17 Vagabond profondément transformé — fuselage allongé, aile raccourcie, becs sur toute l''envergure, train plus haut — et vole le 8 avril 1949 depuis l''aéroport de Boston. La **Helio Aircraft Company** en tire le Courier, certifié en juillet 1954 et fabriqué à Pittsburg, au Kansas.\n\n## Conception\nLe Courier est un monoplan à aile haute cantilever, à structure centrale en tubes d''acier soudés et revêtement d''aluminium. Quatre becs de bord d''attaque de type Handley Page sortent d''eux-mêmes entre 89 et 97 km/h, et des volets à fente occupent 74 % du bord de fuite ; des déporteurs sur l''aile prennent le relais des ailerons, réduits, aux très basses vitesses. L''avion reste contrôlable à 43 km/h et résiste au décrochage comme à la vrille. Sur le Super Courier, un **Lycoming GO-480** à réducteur de 295 ch entraîne une grande hélice tripale : en démonstration, l''avion décollait en travers d''une piste de 30 à 60 m de large. Le train principal, placé très en avant, autorise un freinage énergique sur terrain non préparé.\n\n## Carrière opérationnelle\nLe **Super Courier** entre à l''**US Air Force** à partir de 1958 sous le nom de L-28, devenu **U-10**. Un peu plus de 120 exemplaires militaires sont livrés : U-10A, U-10B à grande autonomie et porte de parachutage, U-10D plus lourd. L''Air Force et l''Army, ses forces spéciales comprises, l''emploient pour la liaison, le fret léger et le largage de ravitaillement, la guerre psychologique, le contrôle aérien avancé, la reconnaissance et l''insertion d''équipes par terre et par mer. Pendant la **guerre du Vietnam**, il vole aussi sous la même désignation pour **Air America**. La Thaïlande, l''Italie, la Turquie, le Pérou et le Guyana l''ont également utilisé.\n\n## Place dans l''histoire\nEnviron 500 Courier sortent des chaînes de 1954 à 1974, et l''avion reste prisé des pilotes de brousse du Canada et de l''Alaska comme des missionnaires qui desservent des pistes de jungle. Il a donné le **Helio AU-24 Stallion** à turbopropulseur, et ses droits ont été repris en 2019 par Helio Alaska, qui a refait l''outillage. Parmi les avions de liaison à décollage court, aux côtés du **DHC-2 Beaver** ou du **Pilatus PC-6 Porter**, il se distingue par sa maîtrise du vol lent.',
    E'## Genesis\nProfessor **Otto C. Koppen**, who had designed the Flivver light aircraft for Ford, built the Courier around one idea: flying very slowly in complete safety. His demonstrator, **Helioplane No. 1**, was converted from a heavily modified Piper PA-17 Vagabond — lengthened fuselage, shortened wing, full-span slats, taller undercarriage — and flew on 8 April 1949 from Boston''s airport. The **Helio Aircraft Company** developed it into the Courier, certified in July 1954 and built at Pittsburg, Kansas.\n\n## Design\nThe Courier is a cantilever high-wing monoplane with a welded steel-tube centre section and aluminium skin. Four Handley Page leading-edge slats deploy automatically between 89 and 97 km/h, and slotted flaps take up 74% of the trailing edge; spoilers on the wing take over from the small ailerons at very low speed. The aircraft stays controllable at 43 km/h and resists both stalling and spinning. On the Super Courier a geared 295 hp **Lycoming GO-480** drives a large three-blade propeller: at air shows it took off across runways 30 to 60 m wide. The main gear sits far forward, allowing hard braking on unprepared ground.\n\n## Operational career\nThe **Super Courier** entered **US Air Force** service from 1958 as the L-28, later **U-10**. Just over 120 military examples were delivered: the U-10A, the long-range U-10B with paratroop doors, and the heavier U-10D. The Air Force and the Army, including its Special Forces, used it for liaison, light cargo and supply drops, psychological warfare, forward air control, reconnaissance and the insertion of teams by land and sea. During the **Vietnam War** it also flew under the same designation for **Air America**. Thailand, Italy, Turkey, Peru and Guyana also operated it.\n\n## Place in history\nAround 500 Couriers left the lines between 1954 and 1974, and the type remains popular with bush pilots in Canada and Alaska and with missionaries serving jungle airstrips. It led to the turboprop **Helio AU-24 Stallion**, and its rights were taken over in 2019 by Helio Alaska, which made new tooling. Among short take-off liaison aircraft, alongside the **DHC-2 Beaver** and the **Pilatus PC-6 Porter**, it stands out for its mastery of slow flight.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1949-04-08',
    '1958-01-01',
    274,
    1760,
    (SELECT id FROM manufacturer WHERE code = 'HLO'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Helio U-10 Courier'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Helio U-10 Courier'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'Helio U-10 Courier'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Helio U-10 Courier'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.35,
  wingspan          = 11.89,
  height            = 2.69,
  wing_area         = NULL,
  empty_weight      = 943,
  mtow              = 1542,
  service_ceiling   = 6200,
  climb_rate        = 6.1,
  g_limit_pos       = 3.8,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming GO-480-G1D6 (295 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1974,
  units_built       = 121,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 7,
  variants          = E'- **Helioplane n° 1** : démonstrateur tiré d''un Piper PA-17 Vagabond, premier vol le 8 avril 1949\n- **L-28A / U-10A** : premiers Super Courier militaires (H-395), 28 exemplaires au total\n- **U-10B** : version à grande autonomie avec porte de parachutage, 57 exemplaires\n- **U-10D** : version à masse au décollage accrue (H-295), 36 exemplaires\n- **AU-24 Stallion** : développement à turbopropulseur (H-550)',
  variants_en       = E'- **Helioplane No. 1**: demonstrator converted from a Piper PA-17 Vagabond, first flown on 8 April 1949\n- **L-28A / U-10A**: first military Super Couriers (H-395), 28 built in all\n- **U-10B**: long-range version with paratroop doors, 57 built\n- **U-10D**: higher gross weight version (H-295), 36 built\n- **AU-24 Stallion**: turboprop development (H-550)',

  -- Strate 4 : qualitatif
  nickname          = 'Super Courier',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Helio_Courier',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Helio U-10 Courier';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Helio U-10 Courier';
