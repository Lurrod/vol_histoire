-- UTVA 75
--
-- Photo : Utva 75 RV i PVO VS sletanje4.jpg
--   licence CC BY-SA 4.0 — Srđan Popović
--   https://commons.wikimedia.org/wiki/File:Utva_75_RV_i_PVO_VS_sletanje4.jpg

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
    'UTVA 75',
    'UTVA 75',
    'UTVA 75',
    'UTVA 75',
    'L''école yougoslave aux portes papillon, restée en service dans la plupart des armées de l''air de l''ex-Yougoslavie',
    'The Yugoslav trainer with gull-wing doors, still serving in most air forces of the former Yugoslavia',
    '/assets/airplanes/utva-75.jpg',
    E'## Genèse\nAu début des années 1970, l''armée de l''air yougoslave cherche un successeur à l''**UTVA Aero 3**, son avion d''instruction de base. Le constructeur **UTVA** étudie pour elle un biplace simple et robuste, le **UTVA 75**, qui effectue son premier vol en 1976. De 1978 à 1985, 136 exemplaires sont produits pour l''armée de l''air yougoslave.\n\n## Conception\nLe UTVA 75 est un monoplan à aile basse, de construction entièrement métallique semi-monocoque, à train tricycle fixe capable d''opérer depuis des pistes en dur comme depuis des terrains sommaires. Il se reconnaît à ses portières papillon, qui s''ouvrent vers le haut pour donner accès au poste à deux places côte à côte, et à une rangée de prises d''air au centre du cadre avant de la verrière. Un Lycoming IO-360 de 180 ch lui donne 215 km/h et 800 km de distance franchissable, portés à 2 000 km avec des réservoirs largables. Ses deux points d''emport de 150 kg chacun peuvent recevoir des paniers de roquettes de 57 mm, des roquettes de 128 mm, des bombes de 50 ou 120 kg ou des nacelles de mitrailleuses de 7,62 mm.\n\n## Carrière opérationnelle\nSimple et indulgent, l''avion sert d''abord à l''instruction élémentaire, mais il assure aussi la reconnaissance aérienne, le transport léger, la liaison et même des travaux agricoles. Une partie de la flotte est confiée dès l''époque yougoslave à des aéroclubs. Après l''éclatement de la Yougoslavie, les appareils sont répartis entre les États qui en sont issus : Serbie, Croatie, Slovénie, Monténégro, Macédoine du Nord et Bosnie-Herzégovine, où la flotte de la Republika Srpska rejoint en 2006 l''armée de l''air nationale. La Slovénie remet finalement tous les siens à des aéroclubs, tandis que la force aérienne serbe en forme encore ses élèves pilotes.\n\n## Place dans l''histoire\nLe UTVA 75 a survécu à la fin de la fédération : on le retrouve dans presque toutes les armées de l''air de ses anciennes républiques, où il reste un avion d''école apprécié. Plusieurs variantes en sont tirées, de l''épandeur agricole monoplace au quadriplace de 1986. À l''étranger, il équipe la force aérienne soudanaise, où le complexe aéronautique SAFAT en a dérivé le **SAFAT 03**, et le Somaliland en achète quatre pour des usages civils et militaires.',
    E'## Genesis\nIn the early 1970s the Yugoslav Air Force was looking for a successor to the **UTVA Aero 3**, its basic trainer. The manufacturer **UTVA** designed a simple and sturdy two-seater for it, the **UTVA 75**, which made its first flight in 1976. From 1978 to 1985, 136 aircraft were produced for the Yugoslav Air Force.\n\n## Design\nThe UTVA 75 is a low-wing monoplane of all-metal semi-monocoque construction, with a fixed tricycle undercarriage able to operate from paved runways and rough strips alike. It is recognisable by its gull-wing doors, which open upwards to give access to the two-seat side-by-side cockpit, and by a row of air scoops in the central front frame of the canopy. A 180 hp Lycoming IO-360 gave it 215 km/h and a range of 800 km, extended to 2,000 km with drop tanks. Its two 150 kg hardpoints could take 57 mm rocket launchers, 128 mm rockets, 50 or 120 kg bombs or 7.62 mm gun pods.\n\n## Operational career\nSimple and forgiving, the aircraft served first for elementary training, but it also flew aerial reconnaissance, light transport, liaison and even agricultural work. Part of the fleet was handed to aero clubs as early as the Yugoslav period. After the break-up of Yugoslavia, the aircraft were shared among its successor states: Serbia, Croatia, Slovenia, Montenegro, North Macedonia and Bosnia and Herzegovina, where the Republika Srpska fleet joined the national air force in 2006. Slovenia eventually handed all of its aircraft to aero clubs, while the Serbian Air Force still trains its student pilots on the type.\n\n## Place in history\nThe UTVA 75 outlived the federation: it is found in almost every air force of its former republics, where it remains a well-liked trainer. Several variants were derived from it, from a single-seat agricultural sprayer to the four-seater of 1986. Abroad it serves with the Sudanese Air Force, where the SAFAT aviation complex derived the **SAFAT 03** from it, and Somaliland bought four for civil and military use.',
    (SELECT id FROM countries WHERE code = 'YUG'),
    NULL,
    '1976-01-01',
    NULL,
    215,
    800,
    (SELECT id FROM manufacturer WHERE code = 'UTVA'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'UTVA 75'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'UTVA 75'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'UTVA 75'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'UTVA 75'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.11,
  wingspan          = 9.73,
  height            = 3.15,
  wing_area         = 14.63,
  empty_weight      = 685,
  mtow              = 960,
  service_ceiling   = 4000,
  climb_rate        = 4.5,
  g_limit_pos       = 4.4,
  g_limit_neg       = -2.2,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming IO-360-B1F (180 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1978,
  production_end    = 1985,
  units_built       = 136,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 9,
  variants          = E'- **UTVA 75A11** : version agricole monoplace reprenant l''essentiel de la cellule\n- **UTVA 75A21** : biplace à doubles commandes, équipé pour le vol sans visibilité\n- **UTVA 75A41** : quadriplace à avionique améliorée, premier vol en 1986\n- **SAFAT 03** : dérivé soudanais au fuselage et à la dérive modifiés',
  variants_en       = E'- **UTVA 75A11**: single-seat agricultural version using most of the airframe\n- **UTVA 75A21**: two-seater with dual controls, equipped for blind instrument flying\n- **UTVA 75A41**: four-seater with improved avionics, first flown in 1986\n- **SAFAT 03**: Sudanese derivative with a modified fuselage and fin',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lola_Utva_75',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/UTVA_75',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Srđan Popović',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'UTVA 75';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'UTVA 75';
