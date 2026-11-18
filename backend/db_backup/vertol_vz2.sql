-- Vertol VZ-2 (Model 76)
--
-- Photo : Vertol VZ-2 (Vertol 76) in flight 1960 (aft view).jpeg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File:Vertol_VZ-2_(Vertol_76)_in_flight_1960_(aft_view).jpeg

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
    'Vertol VZ-2',
    'Vertol VZ-2',
    'Vertol VZ-2 (Model 76)',
    'Vertol VZ-2 (Model 76)',
    'Banc d''essai volant à aile basculante, qui fit pivoter toute sa voilure pour passer du stationnaire à la croisière',
    'A flying tilt-wing test rig that swung its whole wing to pass from hover to cruise',
    '/assets/airplanes/vertol-vz2.jpg',
    E'## Genèse\nAu milieu des années 1950, l''avion à décollage vertical se cherche, et plusieurs formules sont mises à l''essai en vraie grandeur. **Vertol**, qui deviendra **Boeing Vertol**, construit en 1957 le **Model 76**, désigné VZ-2, pour en étudier une : l''**aile basculante**. Au lieu de faire pivoter seulement des rotors ou des moteurs, l''appareil fait tourner sa voilure entière, hélices comprises, de la verticale à l''horizontale. Les essais au sol commencent en avril 1957, et le 13 août le VZ-2 décolle pour la première fois, en vol stationnaire seulement.\n\n## Conception\nLe VZ-2 est un banc d''essai volant plus qu''un avion achevé : son fuselage est une structure en tubes, d''abord laissée sans revêtement, et le pilote prend place sous une verrière en bulle d''hélicoptère, avec une place pour un passager ou un observateur. Une turbine **Avco Lycoming YT53** de 700 ch entraîne les deux hélices de 2,90 m portées par l''aile. Aux basses vitesses, où les gouvernes ordinaires perdent leur efficacité, l''empennage en T reçoit de petites soufflantes carénées qui servent de propulseurs de contrôle.\n\n## Essais\nIl faut près d''un an de mise au point avant que le VZ-2, le 23 juillet 1958, réussisse sa première transition complète du vol vertical au vol horizontal. Les essais se prolongent ensuite jusqu''en 1965 pour le compte de la **NASA**, son principal utilisateur. Au terme du programme, l''appareil totalise quelque 450 vols, dont 34 transitions complètes. Ses caractéristiques donnent une vitesse maximale de 340 km/h, un plafond de 4 200 m et une distance franchissable de 210 km.\n\n## Place dans l''histoire\nLe VZ-2 se range parmi les avions à aile basculante de son époque, avec le **Hiller X-18**, le **Kaman K-16B**, le **LTV XC-142** et le **Canadair CL-84** : tous répondent au problème de la transition en orientant l''aile entière plutôt que les seuls propulseurs. Son programme a couru sur huit ans, des premiers essais au sol en 1957 aux derniers vols en 1965, et sa première transition complète n''est venue qu''au bout de onze mois de vols en stationnaire. Exemplaire unique, il est conservé par le **National Air and Space Museum**, en réserve au centre de conservation et de restauration Paul E. Garber.',
    E'## Genesis\nIn the mid-1950s the vertical take-off aircraft was still searching for its form, and several layouts were being tried at full scale. **Vertol**, later **Boeing Vertol**, built the **Model 76**, designated VZ-2, in 1957 to investigate one of them: the **tilt wing**. Instead of pivoting only rotors or engines, the aircraft rotated its entire wing, propellers included, from vertical to horizontal. Ground tests began in April 1957, and on 13 August the VZ-2 took off for the first time, in hover mode only.\n\n## Design\nThe VZ-2 was a flying test rig rather than a finished aircraft: its fuselage was a tubular framework, originally left uncovered, and the pilot sat under a helicopter-style bubble canopy, with room for a passenger or observer. A 700 hp **Avco Lycoming YT53** turboshaft drove the two 2.90 m propellers on the wing. At low speeds, where ordinary control surfaces lose their effectiveness, the T-tail carried small ducted fans acting as control thrusters.\n\n## Testing\nIt took almost a year of development before the VZ-2, on 23 July 1958, made its first full transition from vertical to horizontal flight. Testing then continued until 1965 on behalf of **NASA**, its primary user. By the end of the programme the aircraft had made some 450 flights, including 34 full transitions. Its figures give a maximum speed of 340 km/h, a ceiling of 4,200 m and a range of 210 km.\n\n## Place in history\nThe VZ-2 ranks among the tilt-wing aircraft of its era, with the **Hiller X-18**, the **Kaman K-16B**, the **LTV XC-142** and the **Canadair CL-84**: all of them answered the transition problem by turning the whole wing rather than the propulsors alone. Its programme ran for eight years, from the first ground tests in 1957 to the last flights in 1965, and its first full transition came only after eleven months of hovering flights. The sole example is preserved by the **National Air and Space Museum**, in storage at the Paul E. Garber Preservation, Restoration and Storage Facility.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1957-08-13',
    NULL,
    340,
    210,
    (SELECT id FROM manufacturer WHERE code = 'VER'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Vertol VZ-2'), (SELECT id FROM tech WHERE name = 'Aile à incidence variable'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Vertol VZ-2'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.05,
  wingspan          = 7.59,
  height            = 4.57,
  wing_area         = NULL,
  empty_weight      = 1678,
  mtow              = NULL,
  service_ceiling   = 4200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Avco Lycoming YT53-L-1 (700 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur à voilure basculante',
  engine_type_en    = 'Tilt-wing turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Model 76** : désignation du constructeur\n- **VZ-2** : désignation militaire de l''exemplaire unique\n- **Boeing Vertol VZ-2** : appellation prise après l''intégration de Vertol à Boeing\n- **Configuration d''origine** : fuselage tubulaire sans revêtement, verrière en bulle, place pour un observateur\n- **Propulseurs de queue** : petites soufflantes carénées dans l''empennage en T pour le contrôle à basse vitesse',
  variants_en       = E'- **Model 76**: manufacturer''s designation\n- **VZ-2**: military designation of the sole example\n- **Boeing Vertol VZ-2**: name adopted after Vertol became part of Boeing\n- **Original configuration**: uncovered tubular fuselage, bubble canopy, seat for an observer\n- **Tail thrusters**: small ducted fans in the T-tail for low-speed control',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Vertol_VZ-2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Vertol_VZ-2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'Vertol VZ-2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Vertol VZ-2';
