-- Kaman K-16B
--
-- Photo : Kaman K-16-B tilt wing aircraft (ARC-1962-A-28975).jpg
--   licence Public domain — NASA Ames Research Center / Emerson Shaw
--   https://commons.wikimedia.org/wiki/File:Kaman_K-16-B_tilt_wing_aircraft_(ARC-1962-A-28975).jpg

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
    'Kaman K-16B',
    'Kaman K-16B',
    'Kaman K-16B',
    'Kaman K-16B',
    'Un amphibie Goose doté d''une aile basculante pour l''US Navy, qui n''a jamais effectué de vol libre',
    'A Goose amphibian given a tilting wing for the US Navy, which never made a free flight',
    '/assets/airplanes/kaman-k16b.jpg',
    E'## Genèse\nÀ la fin des années 1950, le décollage et l''atterrissage verticaux suscitent un vif intérêt, et les armées commandent plusieurs types expérimentaux pour en développer la technique. L''**US Navy** passe ainsi contrat avec **Kaman Aircraft**, de Bloomfield, dans le Connecticut, pour un banc d''essai fondé sur le concept maison de « **rotorprop** » appliqué à l''aile basculante. Pour gagner du temps et réduire les coûts, l''appareil est bâti à partir d''un amphibie **Grumman JRF-5 Goose** et d''autres éléments existants.\n\n## Conception\nLe fuselage et l''empennage du Goose sont mariés à une aile basculante neuve, qui porte deux turbomoteurs **General Electric YT58-GE-2A** de 1 325 ch, entraînant chacun une hélice tripale Kaman de 4,5 m de diamètre. L''incidence de l''aile ne peut dépasser 50 degrés : le rotorprop devait fournir assez de poussée pour décoller verticalement malgré cet angle limité. Long de 11,68 m pour 10,36 m d''envergure, l''appareil pèse 2 948 kg à vide et doit accueillir deux hommes d''équipage. Ses performances, publiées par le Jane''s de 1959-1960, ne sont que des estimations : 320 km/h, 400 km de distance franchissable et 4 900 m de plafond.\n\n## Essais\nLivré fin 1959, le K-16B subit une longue campagne en soufflerie, notamment dans la grande soufflerie de 40 × 80 pieds du centre de recherche **Ames** de la NASA, ainsi que quelques sauts au bout de câbles de retenue, pour évaluer l''aérodynamique de la formule. Les premiers vols étaient attendus à l''automne 1960, mais ces essais préliminaires se prolongent jusqu''en 1962. Cette année-là, le programme est annulé : l''appareil n''a jamais effectué de vol libre.\n\n## Place dans l''histoire\nLe K-16B s''inscrit parmi les appareils expérimentaux qui ont exploré l''aile basculante à la même époque, comme le **Vertol VZ-2** et le **Hiller X-18**, formule que reprendront ensuite le **LTV XC-142** et le **Canadair CL-84**. Il illustre aussi une méthode économique : greffer une voilure entièrement nouvelle sur une cellule éprouvée. L''exemplaire unique est conservé au **New England Air Museum**, à Windsor Locks, dans le Connecticut, l''État même où Kaman l''avait construit.',
    E'## Genesis\nIn the late 1950s vertical take-off and landing attracted wide interest, and the services ordered several experimental types to develop the technology. The **US Navy** accordingly contracted **Kaman Aircraft** of Bloomfield, Connecticut, for a testbed based on the company''s ''**rotorprop**'' concept for tiltwing aircraft. To save time and cost, it was built from a **Grumman JRF-5 Goose** amphibian and other existing parts.\n\n## Design\nThe fuselage and tail of the Goose were mated to a new tilting wing carrying two 1,325 hp **General Electric YT58-GE-2A** turboshafts, each driving a three-bladed Kaman propeller 4.5 m in diameter. The wing''s angle of incidence was limited to 50 degrees: the rotorprop was expected to provide enough thrust for vertical take-off despite that low angle. At 11.68 m long with a 10.36 m span, the aircraft weighed 2,948 kg empty and was to carry a crew of two. Its performance, published in Jane''s 1959-1960, was only ever estimated: 320 km/h, a range of 400 km and a ceiling of 4,900 m.\n\n## Testing\nDelivered in late 1959, the K-16B underwent extensive wind tunnel testing, notably in the 40 by 80 foot tunnel of NASA''s **Ames** Research Center, along with some tethered hops, to evaluate the aerodynamics of the layout. Flight testing was expected to begin in the autumn of 1960, but these preliminary tests dragged on into 1962. That year the project was cancelled: the aircraft never made a free flight.\n\n## Place in history\nThe K-16B belongs among the experimental aircraft that explored the tilting wing in the same period, such as the **Vertol VZ-2** and the **Hiller X-18**, a layout later taken up by the **LTV XC-142** and the **Canadair CL-84**. It also illustrates an economical method: grafting an entirely new wing onto a proven airframe. The sole example is preserved at the **New England Air Museum** in Windsor Locks, Connecticut, the very state in which Kaman had built it.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    NULL,
    NULL,
    322,
    402,
    (SELECT id FROM manufacturer WHERE code = 'KAM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Kaman K-16B'), (SELECT id FROM tech WHERE name = 'Aile à incidence variable'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Kaman K-16B'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.68,
  wingspan          = 10.36,
  height            = 5.84,
  wing_area         = NULL,
  empty_weight      = 2948,
  mtow              = 3629,
  service_ceiling   = 4877,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric YT58-GE-2A (1 325 ch)',
  engine_count      = 2,
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
  variants          = E'- **Grumman JRF-5 Goose** : amphibie dont le K-16B reprend le fuselage et l''empennage\n- **K-16B** : exemplaire unique, aile basculante limitée à 50 degrés, livré fin 1959\n- **Rotorprop** : concept d''hélice de Kaman, tripale de 4,5 m, censé permettre le décollage vertical malgré l''inclinaison limitée de l''aile\n- **Exemplaire conservé** : exposé au New England Air Museum, à Windsor Locks (Connecticut)',
  variants_en       = E'- **Grumman JRF-5 Goose**: amphibian whose fuselage and tail the K-16B reused\n- **K-16B**: sole example, wing tilt limited to 50 degrees, delivered in late 1959\n- **Rotorprop**: Kaman''s propeller concept, three-bladed and 4.5 m across, meant to allow vertical take-off despite the limited wing tilt\n- **Surviving aircraft**: displayed at the New England Air Museum, Windsor Locks, Connecticut',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Kaman_K-16B',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Emerson Shaw, NASA Ames Research Center',
  image_licence     = 'Public domain'
WHERE name = 'Kaman K-16B';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Kaman K-16B';
