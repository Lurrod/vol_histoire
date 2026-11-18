-- Republic XF-84H Thunderscreech
--
-- Photo : Republic XF-84H in flight.jpg
--   licence Public domain — U.S. Air Force photo
--   https://commons.wikimedia.org/wiki/File:Republic_XF-84H_in_flight.jpg

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
    'Republic XF-84H Thunderscreech',
    'Republic XF-84H Thunderscreech',
    'Republic XF-84H Thunderscreech',
    'Republic XF-84H Thunderscreech',
    'Turbopropulseur et hélice supersonique sur une cellule de F-84F : sans doute l''avion le plus bruyant jamais construit',
    'A turboprop and a supersonic propeller on an F-84F airframe: almost certainly the loudest aircraft ever built',
    '/assets/airplanes/xf84h-thunderscreech.jpg',
    E'## Genèse\nLe projet naît d''un besoin de l''**US Navy** : un chasseur embarqué capable de décoller sans catapulte. Le **Wright Air Development Center** de l''US Air Force en devient pourtant le principal soutien, sous le nom de Republic Project 3347. D''abord désigné XF-106, un numéro repris plus tard par le Convair F-106, l''appareil devient **XF-84H** pour marquer sa parenté avec le F-84. Quand la marine annule sa commande, les prototypes deviennent de purs avions de recherche, construits pour le laboratoire des hélices de l''Air Force à Wright-Patterson afin d''étudier l''hélice supersonique aux vitesses des avions à réaction.\n\n## Conception\nRepublic part d''une cellule de **F-84F Thunderstreak** et loge un turbopropulseur **Allison XT40-A-1** de 5 850 ch derrière le cockpit ; un arbre de 5,5 m entraîne l''hélice du nez. Cette hélice **Aeroproducts** de 3,7 m, à trois pales d''acier à bouts carrés, tourne à vitesse constante : la poussée se règle par le pas, et l''extrémité des pales file à environ Mach 1,18. Contre le couple, une dérive dorsale fixe est ajoutée, l''entrée d''air gauche est avancée de 30 cm sur la droite et les volets agissent de façon différentielle ; l''empennage passe en T pour échapper au souffle de l''hélice. Le XF-84H est le premier avion doté d''une **éolienne de secours** escamotable, qui sort d''elle-même en cas de panne moteur.\n\n## Essais\nLe premier vol a lieu à Edwards le 22 juillet 1955. L''accélération est remarquable, mais les vibrations de l''hélice, les pannes du mécanisme de pas et les trente minutes de chauffe du moteur rendent l''avion inutilisable au combat. En douze vols, il ne cumule que 6 h 40 de vol : **Hank Beaird** en effectue onze, dont dix finissent en atterrissage forcé, et **Lin Hendrix** refuse d''y remonter après un seul. Au sol, on l''entend à 40 km ; l''onde de choc des pales peut renverser un homme, rend les mécaniciens malades et oblige la tour d''Edwards à communiquer par signaux lumineux. L''Air Force annule le programme en septembre 1956 sans qu''aucun de ses pilotes l''ait piloté.\n\n## Place dans l''histoire\nSurnommé **Thunderscreech**, le XF-84H est presque certainement l''avion le plus bruyant jamais construit. Le Guinness l''a présenté comme l''avion à hélice le plus rapide, avec 1 003 km/h en essais, un chiffre contesté ; le musée de l''US Air Force retient 840 km/h, ce qui en fait tout de même le monomoteur à hélice le plus rapide jusqu''en 1989. Le premier exemplaire passe des années sur un mât devant l''aéroport de Bakersfield, hélice entraînée par un moteur électrique, avant d''être restauré et exposé à Dayton.',
    E'## Genesis\nThe project grew out of a **US Navy** requirement for a carrier fighter able to take off without a catapult. Yet the US Air Force''s **Wright Air Development Center** became its main sponsor, as Republic Project 3347. First designated XF-106, a number later reused for the Convair F-106, the aircraft became the **XF-84H** to mark its kinship with the F-84. When the Navy cancelled its order, the prototypes became pure research aircraft, built for the Air Force''s Propeller Laboratory at Wright-Patterson to study supersonic propellers at jet speeds.\n\n## Design\nRepublic started from an **F-84F Thunderstreak** airframe and installed a 5,850 hp **Allison XT40-A-1** turboprop behind the cockpit; a 5.5 m shaft drove the nose propeller. This 3.7 m **Aeroproducts** propeller, with three square-tipped steel blades, turned at constant speed: thrust was set through blade pitch, and the tips travelled at about Mach 1.18. To fight the torque, a fixed dorsal fin was added, the left intake sat 30 cm ahead of the right and the flaps worked differentially; the tail became a T-tail to stay clear of the propeller wash. The XF-84H was also the first aircraft fitted with a retractable **ram air turbine**, which swung out automatically if the engine failed.\n\n## Testing\nThe first flight took place at Edwards on 22 July 1955. Acceleration was remarkable, but propeller vibration, failures of the pitch gearing and the engine''s thirty-minute warm-up made the aircraft useless for combat. In twelve flights it logged only 6 hours 40 minutes: **Hank Beaird** flew eleven, ten of which ended in forced landings, and **Lin Hendrix** refused to fly it again after one. On the ground it could be heard 40 km away; the blades'' shock wave could knock a man down, left ground crews sick and forced the Edwards tower to talk to the crew by light signals. The Air Force cancelled the programme in September 1956 without any of its own pilots having flown it.\n\n## Place in history\nNicknamed **Thunderscreech**, the XF-84H is almost certainly the loudest aircraft ever built. Guinness listed it as the fastest propeller-driven aircraft, at 1,003 km/h in tests, a disputed figure; the National Museum of the US Air Force gives 840 km/h, which still made it the fastest single-engined propeller aircraft until 1989. The first example spent years on a pole outside Bakersfield airport, its propeller turned by an electric motor, before being restored and put on display at Dayton.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1955-07-22',
    NULL,
    840,
    3200,
    (SELECT id FROM manufacturer WHERE code = 'REP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Republic XF-84H Thunderscreech'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Republic XF-84H Thunderscreech'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Republic XF-84H Thunderscreech'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.67,
  wingspan          = 10.18,
  height            = 4.67,
  wing_area         = 30.75,
  empty_weight      = 8116,
  mtow              = 12268,
  service_ceiling   = 12192,
  climb_rate        = 25.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison XT40-A-1 (5 850 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Project 3347 / XF-106** : désignation initiale du projet, abandonnée au profit de XF-84H ; le numéro F-106 passe ensuite au Convair Delta Dart\n- **XF-84H 51-17059 (FS-059)** : premier prototype, longtemps exposé sur un mât à Bakersfield, restauré et présenté au musée de l''US Air Force\n- **XF-84H 51-17060 (FS-060)** : second prototype, quatre vols seulement, probablement ferraillé à l''annulation ; son moteur T40 aurait servi au programme d''essais du Douglas A2D Skyshark',
  variants_en       = E'- **Project 3347 / XF-106**: original project designation, dropped in favour of XF-84H; the F-106 number later went to the Convair Delta Dart\n- **XF-84H 51-17059 (FS-059)**: first prototype, long displayed on a pole at Bakersfield, restored and shown at the National Museum of the US Air Force\n- **XF-84H 51-17060 (FS-060)**: second prototype, only four flights, presumed scrapped on cancellation; its T40 engine reportedly supported the Douglas A2D Skyshark test programme',

  -- Strate 4 : qualitatif
  nickname          = 'Thunderscreech',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Republic_XF-84H',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Republic_XF-84H_Thunderscreech',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Republic XF-84H Thunderscreech';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Republic XF-84H Thunderscreech';
