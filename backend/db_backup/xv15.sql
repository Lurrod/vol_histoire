-- Bell XV-15
--
-- Photo : Bell-NASA XV-15 (cropped).jpg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File:Bell-NASA_XV-15_(cropped).jpg

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
    'Bell XV-15',
    'Bell XV-15',
    'Bell XV-15',
    'Bell XV-15',
    'Le démonstrateur qui a fait du rotor basculant un programme militaire',
    'The demonstrator that turned the tiltrotor into a military programme',
    '/assets/airplanes/xv15.jpg',
    E'## Genèse\nLe rotor basculant est une idée des années 1930, et le **Bell XV-3** avait montré en 1955 qu''un tel appareil pouvait voler — mais ses arbres de transmission, qui portaient la puissance du fuselage jusqu''aux bouts d''aile, étaient lourds et très sollicités. En 1971, le centre **Ames** de la NASA relance le sujet. Bell et Boeing Vertol reçoivent en octobre 1972 des contrats d''étude ; la NASA retient le **Bell 301** le 31 juillet 1973.\n\n## Conception\nL''innovation tient dans les nacelles : moteur et rotor y sont **réunis et basculent ensemble**, de la verticale à l''horizontale. La puissance ne parcourt plus l''aile ; un arbre de secours la traverse seulement pour qu''un moteur puisse entraîner les deux rotors en cas de panne. Deux turbomoteurs **Lycoming LTC1K-4K** de 1 550 ch, deux rotors à trois pales de 7,6 m de diamètre, deux pilotes sur sièges éjectables, et jusqu''à neuf passagers si l''on installe des sièges.\n\n## Carrière opérationnelle\nLe premier exemplaire vole le 3 mai 1977, passe dans la grande soufflerie d''Ames puis est essayé à Dryden. En 1981, au **Salon du Bourget**, il salue la foule d''une révérence en vol stationnaire ; le *New York Times* en fait la vedette du salon. Sénateurs et responsables de la Marine sont invités à le piloter. En 1983, Bell et Boeing en proposent une version agrandie au programme interarmées JVX : ce sera le **V-22 Osprey**. Le premier XV-15 est accidenté en 1992 sans victime ; le second vole jusqu''en 2003, au profit du V-22 et du convertible civil **AW609**.\n\n## Place dans l''histoire\nDeux exemplaires. Le XV-15 a fait passer le rotor basculant du stade de la curiosité à celui du programme militaire. Il détient toujours des records de sa catégorie FAI, dont la vitesse — 456 km/h — et le temps de montée à 3 000 et 6 000 m. Le V-22 et l''AW609 ont repris sa formule des moteurs logés dans les nacelles basculantes. Le second exemplaire est exposé au Smithsonian, au centre Udvar-Hazy.',
    E'## Genesis\nThe tiltrotor is an idea from the 1930s, and the **Bell XV-3** had shown in 1955 that such an aircraft could fly — but its drive shafts, which carried power from the fuselage out to the wingtips, were heavy and heavily loaded. In 1971 NASA''s **Ames** centre revived the subject. Bell and Boeing Vertol received study contracts in October 1972; NASA chose the **Bell 301** on 31 July 1973.\n\n## Design\nThe innovation lies in the nacelles: engine and rotor are **combined and tilt together**, from vertical to horizontal. Power no longer travels along the wing; an emergency shaft runs through it only so that one engine can drive both rotors after a failure. Two 1,550 hp **Lycoming LTC1K-4K** turboshafts, two three-bladed rotors 7.6 m in diameter, two pilots on ejection seats, and up to nine passengers if seats are fitted.\n\n## Operational career\nThe first aircraft flew on 3 May 1977, went through the large Ames wind tunnel and was then tested at Dryden. In 1981, at the **Paris Air Show**, it greeted the crowd with a bow in the hover; the *New York Times* called it the hit of the show. Senators and Navy officials were invited to fly it. In 1983 Bell and Boeing offered an enlarged version to the joint-service JVX programme: it would become the **V-22 Osprey**. The first XV-15 crashed in 1992 without loss of life; the second flew until 2003, supporting the V-22 and the civil **AW609** tiltrotor.\n\n## Place in history\nTwo built. The XV-15 moved the tiltrotor from curiosity to military programme. It still holds records in its FAI class, including speed — 456 km/h — and time to climb to 3,000 and 6,000 m. The V-22 and the AW609 adopted its formula of engines housed in the tilting nacelles. The second aircraft is displayed by the Smithsonian at the Udvar-Hazy Center.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1973-07-31',
    '1977-05-03',
    NULL,
    615.0,
    824.0,
    (SELECT id FROM manufacturer WHERE code = 'BEL'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell XV-15'), (SELECT id FROM tech WHERE name = 'Rotors basculants'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell XV-15'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.83,
  wingspan          = NULL,
  height            = 3.86,
  wing_area         = 15.7,
  empty_weight      = 4341,
  mtow              = 6804,
  service_ceiling   = 8839,
  climb_rate        = 16.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming LTC1K-4K',
  engine_count      = 2,
  engine_type       = 'Turbomoteur à rotors basculants',
  engine_type_en    = 'Tiltrotor turboshaft',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **N702NA** : premier exemplaire, premier vol le 3 mai 1977, accidenté en 1992\n- **N703NA** : second exemplaire, en vol jusqu''en 2003, exposé au centre Udvar-Hazy\n- **Bell 301** : désignation du constructeur\n- Records FAI de **vitesse (456 km/h)** et de temps de montée à 3 000 et 6 000 m\n- A donné le **V-22 Osprey** militaire et le convertible civil **AW609**',
  variants_en       = E'- **N702NA** : first aircraft, first flight on 3 May 1977, crashed in 1992\n- **N703NA** : second aircraft, flown until 2003, displayed at the Udvar-Hazy Center\n- **Bell 301** : manufacturer''s designation\n- FAI records for **speed (456 km/h)** and time to climb to 3,000 and 6,000 m\n- Led to the military **V-22 Osprey** and the civil **AW609** tiltrotor',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bell_XV-15',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'Bell XV-15';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bell XV-15';
