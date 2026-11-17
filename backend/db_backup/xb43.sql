-- Douglas XB-43 Jetmaster
--
-- Photo : Douglas YB-43 in flight 061219-F-1234S-006.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Douglas_YB-43_in_flight_061219-F-1234S-006.jpg

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
    'Douglas XB-43 Jetmaster',
    'Douglas XB-43 Jetmaster',
    'Douglas XB-43 Jetmaster',
    'Douglas XB-43 Jetmaster',
    'Premier bombardier à réaction américain à voler, né d''un bimoteur à hélices propulsives',
    'The first American jet bomber to fly, born from a pusher-propeller twin',
    '/assets/airplanes/xb43-jetmaster.jpg',
    E'## Genèse\nDès octobre 1943, l''Air Materiel Command de l''USAAF s''interroge sur les bombardiers à réaction. Douglas conçoit alors le **XB-42 Mixmaster**, un bimoteur dont les moteurs à pistons sont enfouis dans le fuselage et entraînent des hélices propulsives : son aile laminaire, libre de toute nacelle, semble faite pour accueillir des réacteurs. En mars 1944, l''USAAF modifie le contrat du XB-42 pour y ajouter deux prototypes à turboréacteurs, les XB-43. Douglas convainc l''armée qu''il est plus rapide et moins coûteux de transformer la cellule d''essais statiques du XB-42 que de dessiner un avion nouveau.\n\n## Conception\nLes deux Allison V-1710 cèdent la place à deux **General Electric J35**, premiers turboréacteurs américains à compresseur axial. Deux entrées d''air sont découpées de chaque côté du fuselage, en arrière du poste pressurisé, et l''espace libéré par les arbres d''hélice accueille deux longues tuyères. Sans hélice risquant de toucher la piste, la dérive ventrale de l''empennage cruciforme disparaît, compensée par une dérive dorsale agrandie. Douglas rêve de produire jusqu''à 200 B-43 par mois, en bombardier à nez vitré ou en avion d''attaque armé de 16 mitrailleuses et de 36 roquettes, et l''USAAF envisage d''en commander 50.\n\n## Essais\nLes retards de livraison des J35 étirent les travaux sur près de deux ans, puis l''explosion d''un réacteur au banc, qui blesse un technicien, impose sept mois de réparations. Le XB-43 décolle enfin de Muroc le 17 mai 1946, aux mains du pilote d''essai **Bob Brush** : c''est le premier vol d''un bombardier à réaction américain. Il souffre toutefois de problèmes de stabilité et, déjà, l''USAAF mise sur le **XB-45 Tornado**, conçu dès l''origine pour la réaction. Le second prototype, désigné YB-43 et surnommé **Versatile II**, vole le 15 mai 1947 ; son nez en plastique se fissurant sous l''effet des écarts de température, les mécaniciens lui en façonnent un en contreplaqué.\n\n## Place dans l''histoire\nSans suite en série, le Jetmaster rend de précieux services : il aide à définir les procédures de vol des bombardiers à réaction et sert de banc d''essais moteur, l''un de ses J35 étant remplacé par un J47. Versatile II, nourri des pièces du premier prototype endommagé en février 1951, totalise plus de 300 heures de vol avant son retrait en décembre 1953. Confié à la Smithsonian en 1954, il attend aujourd''hui sa restauration au musée de l''US Air Force, à Dayton, aux côtés du dernier XB-42.',
    E'## Genesis\nAs early as October 1943, the USAAF''s Air Materiel Command was considering jet bombers. Douglas was then designing the **XB-42 Mixmaster**, a twin whose piston engines were buried in the fuselage and drove pusher propellers: its laminar-flow wing, free of nacelles, seemed ideal for jet engines. In March 1944 the USAAF amended the XB-42 contract to add two turbojet-powered prototypes, the XB-43s. Douglas persuaded the Army that converting the XB-42 static test airframe would be quicker and cheaper than drawing a new aircraft.\n\n## Design\nThe two Allison V-1710s gave way to two **General Electric J35s**, the first American axial-flow turbojets. Two air intakes were cut into each side of the fuselage aft of the pressurised cockpit, and the space freed by the propeller shafts took two long jet pipes. With no propellers to strike the runway, the ventral fin of the cruciform tail was deleted and offset by an enlarged dorsal fin. Douglas dreamed of building up to 200 B-43s a month, either as a glazed-nose bomber or as an attack aircraft with 16 machine guns and 36 rockets, and the USAAF considered ordering 50.\n\n## Testing\nLate deliveries of the J35s stretched the work to almost two years, then an engine that burst during ground runs, injuring a technician, cost another seven months of repairs. The XB-43 finally took off from Muroc on 17 May 1946, flown by test pilot **Bob Brush**: it was the first flight of an American jet bomber. It suffered from stability problems, however, and the USAAF was already backing the **XB-45 Tornado**, designed for jet power from the outset. The second prototype, designated YB-43 and nicknamed **Versatile II**, flew on 15 May 1947; when its plastic nose cracked under temperature changes, mechanics fashioned one from plywood.\n\n## Place in history\nNever put into production, the Jetmaster still gave valuable service: it helped develop procedures for flying jet bombers and served as an engine testbed, one of its J35s being replaced by a J47. Versatile II, kept flying with parts from the first prototype after it was damaged in February 1951, logged more than 300 hours before retiring in December 1953. Handed to the Smithsonian in 1954, it now awaits restoration at the US Air Force museum in Dayton, alongside the last XB-42.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-03-01',
    '1946-05-17',
    NULL,
    829,
    4570,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas XB-43 Jetmaster'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas XB-43 Jetmaster'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Douglas XB-43 Jetmaster'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.6,
  wingspan          = 21.69,
  height            = 7.39,
  wing_area         = 52.3,
  empty_weight      = 9877,
  mtow              = 17932,
  service_ceiling   = 11700,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J35-GE-3',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 16.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XB-43** (44-61508) : premier prototype, tiré de la cellule d''essais statiques du XB-42, détruit comme cible\n- **YB-43** (44-61509) : second prototype « Versatile II », banc d''essais moteur avec un J47, conservé à Dayton\n- **A-43** : version d''attaque à nez plein armé de mitrailleuses, envisagée mais jamais construite\n- **XB-42 Mixmaster** : bimoteur à hélices propulsives dont le Jetmaster est directement dérivé',
  variants_en       = E'- **XB-43** (44-61508): first prototype, converted from the XB-42 static test airframe, later destroyed as a target\n- **YB-43** (44-61509): second prototype Versatile II, engine testbed with a J47, preserved at Dayton\n- **A-43**: attack version with a solid gun nose, considered but never built\n- **XB-42 Mixmaster**: pusher-propeller twin from which the Jetmaster was directly derived',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_XB-43_Jetmaster',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_XB-43_Jetmaster',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Douglas XB-43 Jetmaster';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Douglas XB-43 Jetmaster';
