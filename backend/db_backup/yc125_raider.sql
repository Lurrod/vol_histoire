-- Northrop N-32 / YC-125 Raider
--
-- Photo : Northrop YC-125B Raider USAF.jpg
--   licence Public domain — auteur non indiqué
--   https://commons.wikimedia.org/wiki/File:Northrop_YC-125B_Raider_USAF.jpg

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
    'Northrop YC-125 Raider',
    'Northrop YC-125 Raider',
    'Northrop N-32 / YC-125 Raider',
    'Northrop N-32 / YC-125 Raider',
    'Un trimoteur à décollage court pour l''US Air Force, trop peu puissant pour durer',
    'A short take-off trimotor for the US Air Force, too underpowered to last',
    '/assets/airplanes/northrop-yc125-raider.jpg',
    E'## Genèse\nLe Raider descend du premier avion civil de **Northrop** d''après-guerre, le trimoteur **N-23 Pioneer**, conçu pour remplacer les vieux Ford Trimotor de la compagnie centraméricaine TACA. Le Pioneer vole le 21 décembre 1946 et décroche une commande de quarante avions, mais TACA perd ses droits de desserte des États-Unis et l''annule ; malgré des tournées de démonstration, aucun autre client ne se présente, et le prototype est perdu en février 1948 lorsqu''une nouvelle dérive se détache en vol. La même année, l''US Air Force s''intéresse à la formule et commande vingt-trois appareils.\n\n## Conception\nLe N-32 Raider reprend la formule du Pioneer : un trimoteur à décollage et atterrissage courts, mû par trois moteurs en étoile **Wright R-1820-99 Cyclone** de 1 200 ch. Il emporte jusqu''à 36 soldats ou 4,5 tonnes de fret, et une porte cargo complétée par une trappe sous le nez permettait, sur le Pioneer, d''engouffrer des tubes ou des poutres de 11 m. Avec des fusées d''appoint JATO, il décolle en moins de 150 m. Treize exemplaires sont livrés en transport de troupes, sous la désignation YC-125A, et dix en version de sauvetage arctique YC-125B, avec vingt civières et un train à skis possible.\n\n## Carrière opérationnelle\nLe premier Raider vole le 1er août 1949 et les livraisons commencent en 1950. La carrière tourne court : trop peu puissants, les appareils sont vite envoyés à la base de Sheppard, au Texas, où ils ne servent plus que de supports d''instruction au sol. Retirés en 1955 et déclarés excédentaires, ils sont pour la plupart rachetés par Frank Ambrose, qui les revend à des transporteurs de brousse d''Amérique centrale et du Sud, là même où le Pioneer devait faire carrière.\n\n## Place dans l''histoire\nLe Raider illustre une impasse de l''immédiat après-guerre : un trimoteur rustique pensé pour les terrains sommaires, qui arrive alors que les surplus militaires bon marché encombrent le marché civil et qui manque de puissance pour le service militaire. **Canadair** envisage un temps de le produire sous licence, puis d''en étudier une version à deux turbopropulseurs **Allison T56**, sans suite. Deux exemplaires subsistent : un YC-125B au musée national de l''US Air Force, à Dayton, et un YC-125A au Pima Air and Space Museum de Tucson.',
    E'## Genesis\nThe Raider descends from **Northrop**''s first post-war civil design, the **N-23 Pioneer** trimotor, intended to replace the ageing Ford Trimotors of the Central American airline TACA. The Pioneer flew on 21 December 1946 and won an order for forty aircraft, but TACA lost its rights to fly to the United States and cancelled; despite sales tours no other customer came forward, and the prototype was lost in February 1948 when a new tail fin came off in flight. That same year the US Air Force took an interest in the layout and ordered twenty-three aircraft.\n\n## Design\nThe N-32 Raider kept the Pioneer''s formula: a short take-off and landing trimotor, powered by three 1,200 hp **Wright R-1820-99 Cyclone** radial engines. It carried up to 36 troops or 4.5 tonnes of cargo, and on the Pioneer a cargo door together with a chin hatch had allowed 11 m lengths of pipe or timber to be loaded. With JATO rockets it could take off in less than 150 m. Thirteen were delivered as troop transports, designated YC-125A, and ten as YC-125B Arctic rescue aircraft, with twenty stretchers and provision for skis.\n\n## Operational career\nThe first Raider flew on 1 August 1949 and deliveries began in 1950. Its career was short: underpowered, the aircraft were soon sent to Sheppard Air Force Base, Texas, where they were relegated to ground instructional airframes. Retired in 1955 and declared surplus, most were bought by Frank Ambrose and sold on to bush operators in Central and South America, the very region where the Pioneer was meant to have made its career.\n\n## Place in history\nThe Raider illustrates a dead end of the immediate post-war years: a rugged trimotor designed for rough strips, arriving when cheap military surplus crowded the civil market, and lacking the power for military service. **Canadair** considered building it under licence, then studied a version with two **Allison T56** turboprops, without result. Two survive: a YC-125B at the National Museum of the United States Air Force in Dayton, and a YC-125A at the Pima Air and Space Museum in Tucson.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1948-01-01',
    '1949-08-01',
    '1950-01-01',
    333,
    2987,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop YC-125 Raider'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop YC-125 Raider'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.45,
  wingspan          = 26.37,
  height            = 7.04,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 19006,
  service_ceiling   = 3700,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-1820-99 Cyclone (1 200 ch)',
  engine_count      = 3,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1950,
  units_built       = 23,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **N-23 Pioneer** : prototype civil, premier vol le 21 décembre 1946, perdu en février 1948\n- **N-32 Raider** : désignation constructeur de la version militaire\n- **YC-125A** : transport de troupes, trente places assises, 13 exemplaires\n- **YC-125B** : sauvetage arctique, vingt civières et train à skis possible, 10 exemplaires (48-618 à 48-627)\n- **CL-3 / CL-12 et N-74** : projets de production sous licence par Canadair, le second à deux turbopropulseurs Allison T56, abandonnés',
  variants_en       = E'- **N-23 Pioneer**: civil prototype, first flight on 21 December 1946, lost in February 1948\n- **N-32 Raider**: company designation of the military version\n- **YC-125A**: troop transport seating thirty, 13 built\n- **YC-125B**: Arctic rescue version, twenty stretchers and provision for skis, 10 built (48-618 to 48-627)\n- **CL-3 / CL-12 and N-74**: Canadair licence-production projects, the latter with two Allison T56 turboprops, abandoned',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_YC-125_Raider',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_YC-125_Raider',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Northrop YC-125 Raider';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Northrop YC-125 Raider';
