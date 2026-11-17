-- Yakovlev Yak-52
--
-- Photo : Black Sea Air Show 2025 (9238794).jpg
--   licence Public domain — Sgt. Justin Lacy, U.S. Army
--   https://commons.wikimedia.org/wiki/File:Black_Sea_Air_Show_2025_(9238794).jpg

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
    'Yak-52',
    'Yak-52',
    'Yakovlev Yak-52',
    'Yakovlev Yak-52',
    'Biplace de voltige et d''école du DOSAAF, construit en Roumanie, devenu chasseur de drones en Ukraine',
    'DOSAAF aerobatic two-seat trainer, built in Romania, turned drone hunter in Ukraine',
    '/assets/airplanes/yak52.jpg',
    E'## Genèse\nDans les années 1970, le **DOSAAF**, l''organisation paramilitaire qui forme en URSS les pilotes sportifs comme les futurs pilotes militaires, a besoin d''un nouvel avion d''école voltigeur. **Iakovlev** part de son monoplace de compétition, le **Yak-50**, et en tire un biplace en tandem : le **Yak-52**, qui vole en 1976 et entre en service en 1979. Dans le cadre du COMECON, la production est confiée à la Roumanie, où **Aerostar** le construit sous le nom d''Iak-52 de 1977 à 1998.\n\n## Conception\nConçu comme une école militaire, le Yak-52 reprend la disposition des premiers chasseurs d''après-guerre : postes en tandem, train tricycle, fuselage mixte en monocoque et tubes d''acier, dimensions proches de celles du biplace d''école à réaction **Yak-17 UTI**. Son moteur en étoile **Vedeneïev M-14P** de 360 ch permet deux minutes de vol dos. Démarrage, train, volets et freins sont actionnés par un circuit pneumatique alimenté par compresseur, robuste et peu exigeant en entretien. Le train escamotable reste en partie apparent, ce qui protège l''avion lors d''un atterrissage train rentré. Limité à +7 et -5 g, il exécute toutes les figures du catalogue de voltige.\n\n## Carrière opérationnelle\nLe Yak-52 forme des générations de pilotes du DOSAAF et des forces aériennes soviétiques, puis de nombreux pays issus de l''URSS, de la Roumanie au Vietnam. Une version armée, le Yak-52B, peut emporter deux paniers de roquettes **S-5**. Depuis 2024, l''aviation légère de l''armée ukrainienne l''emploie contre les drones russes pendant l''**invasion de l''Ukraine** : verrière ouverte, le pilote tourne autour de la cible tandis qu''un tireur armé d''un fusil l''abat depuis la place arrière. Un même appareil aurait ainsi abattu jusqu''à huit drones, et la Russie l''emploie à son tour contre les drones ukrainiens.\n\n## Place dans l''histoire\nHéritier du **Yak-18**, le Yak-52 a prolongé la tradition des écoles de voltige soviétiques jusqu''aux années 1990. Après la guerre froide, il est devenu un avion de voltige prisé des pilotes civils, au point d''avoir son propre championnat du monde monotype de la FAI. Son emploi improvisé en Ukraine montre qu''un avion d''école lent et agile peut retrouver une utilité militaire face aux drones.',
    E'## Genesis\nIn the 1970s **DOSAAF**, the paramilitary organisation that trained both sport pilots and future military pilots in the USSR, needed a new aerobatic trainer. **Yakovlev** started from its single-seat competition aircraft, the **Yak-50**, and derived a tandem two-seater: the **Yak-52**, which flew in 1976 and entered service in 1979. Under COMECON arrangements, production went to Romania, where **Aerostar** built it as the Iak-52 from 1977 to 1998.\n\n## Design\nDesigned as a military trainer, the Yak-52 reproduced the layout of early post-war fighters: tandem cockpits, tricycle undercarriage, mixed monocoque and steel-tube fuselage, and dimensions close to those of the **Yak-17 UTI** jet trainer. Its 360 hp **Vedeneyev M-14P** radial allowed two minutes of inverted flight. Engine start, undercarriage, flaps and brakes were pneumatically operated from a compressor-fed system, rugged and undemanding to maintain. The retractable undercarriage remained partly exposed, protecting the aircraft in a wheels-up landing. Stressed to +7 and -5 g, it could perform every figure in the aerobatic catalogue.\n\n## Operational career\nThe Yak-52 trained generations of DOSAAF and Soviet Air Force pilots, then those of many countries from Romania to Vietnam. An armed version, the Yak-52B, could carry two pods of **S-5** rockets. Since 2024 Ukrainian Army Aviation has used it against Russian drones during the **Russian invasion of Ukraine**: canopy open, the pilot circles the target while a gunner with a rifle shoots it down from the rear seat. A single aircraft is reported to have downed up to eight drones, and Russia in turn uses it against Ukrainian drones.\n\n## Place in history\nHeir to the **Yak-18**, the Yak-52 carried the tradition of Soviet aerobatic trainers into the 1990s. After the Cold War it became a favourite aerobatic aircraft of civilian pilots, to the point of having its own FAI one-design world championship. Its improvised use in Ukraine shows that a slow, agile trainer can regain military value against drones.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '1976-01-01',
    '1979-01-01',
    285,
    550,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-52'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-52'), (SELECT id FROM armement WHERE name = 'S-5'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-52'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Yak-52'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-52'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.745,
  wingspan          = 9.3,
  height            = 2.7,
  wing_area         = 15.0,
  empty_weight      = 1015,
  mtow              = 1305,
  service_ceiling   = 4000,
  climb_rate        = 5,
  g_limit_pos       = 7,
  g_limit_neg       = -5,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Vedeneïev M-14P (360 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1978,
  production_end    = 1998,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 14,
  variants          = E'- **Yak-52 (Iak-52)** : biplace d''école à moteur M-14P de 360 ch, construit par Aerostar en Roumanie\n- **Yak-52B** : version d''attaque légère à deux paniers de roquettes S-5\n- **Yak-52M** : version modernisée de 2003-2004, moteur M-14Kh et hélice tripale\n- **Iak-52W et Iak-52TW** : versions occidentalisées d''Aerostar, la seconde à train classique et réservoirs agrandis\n- **UTL-450** : variante à turbopropulseur AI-450S présentée par Motor Sich en 2016',
  variants_en       = E'- **Yak-52 (Iak-52)**: two-seat trainer with 360 hp M-14P engine, built by Aerostar in Romania\n- **Yak-52B**: light attack version with two S-5 rocket pods\n- **Yak-52M**: modernised 2003-2004 version, M-14Kh engine and three-blade propeller\n- **Iak-52W and Iak-52TW**: westernised Aerostar versions, the latter with tailwheel undercarriage and larger tanks\n- **UTL-450**: AI-450S turboprop variant presented by Motor Sich in 2016',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-52',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-52',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Sgt. Justin Lacy, U.S. Army',
  image_licence     = 'Public domain'
WHERE name = 'Yak-52';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-52';
