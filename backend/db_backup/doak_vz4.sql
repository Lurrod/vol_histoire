-- Doak VZ-4DA (Model 16)
--
-- Photo : Doak VZ-4 Fort Eustis VA 22.04.04R.jpg
--   licence CC BY 3.0 — RuthAS
--   https://commons.wikimedia.org/wiki/File:Doak_VZ-4_Fort_Eustis_VA_22.04.04R.jpg

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
    'Doak VZ-4',
    'Doak VZ-4',
    'Doak VZ-4DA (Model 16)',
    'Doak VZ-4DA (Model 16)',
    'Premier avion à décoller à la verticale grâce à deux hélices carénées basculantes en bout d''aile',
    'The first aircraft to take off vertically on two tilting ducted fans at its wingtips',
    '/assets/airplanes/doak-vz4.jpg',
    E'## Genèse\nIngénieur autodidacte et vice-président de **Douglas**, **Edmund R. Doak Jr.** fonde en 1940 à Torrance la **Doak Aircraft Company**, qui emploie 4 000 personnes pendant la guerre comme sous-traitant de toute l''industrie. En 1950, il propose à l''**US Army** un avion à décollage vertical capable de stationner et même de reculer comme un hélicoptère, sans son bruit ni ses vibrations, tout en volant vite et en portant des armes sous les ailes comme un chasseur. L''Army, qui craint qu''une attaque soviétique sur les bases aériennes ne cloue au sol les avions classiques, est séduite : le 10 avril 1956, elle commande un prototype de recherche, le **Model 16**.\n\n## Conception\nUne turbine **Lycoming YT53** de 840 ch, logée dans le fuselage et remplacée plus tard par une **T53-L-1** de 1 000 ch, entraîne par un renvoi en T et des arbres en aluminium deux **hélices carénées** en fibre de verre de 1,22 m, placées en bout d''aile. Axe vertical au décollage, où elles tournent à 4 800 tr/min, elles pivotent ensuite pour le vol de croisière : c''est le premier essai réussi de ce principe de propulsion. Pilote et observateur sont assis en tandem. Pour gagner du poids, la structure en tubes d''acier soudés est d''abord laissée nue, avant de recevoir un nez en fibre de verre et un arrière en aluminium ; le train vient d''un **Cessna 182**, les sièges d''un **P-51 Mustang** et les vérins des carénages d''un **T-33**.\n\n## Essais\nLe Model 16 effectue son premier vol stationnaire le 25 février 1958 à Torrance, et sa première transition du vertical à l''horizontale, aller et retour, le 5 mai. Réussi dans l''ensemble, il décolle et atterrit court moins bien qu''espéré, et tend à cabrer pendant la transition. Transféré à Edwards en octobre 1958, il y atteint 370 km/h et 3 700 m en 50 heures d''essais. L''Army l''accepte en septembre 1959 sous le nom de **VZ-4DA** et le confie au centre de **Langley** de la NASA ; quand Doak licencie 90 % de son personnel fin 1960, **Douglas** reprend le projet et ses brevets.\n\n## Place dans l''histoire\nEn 1963, l''Army juge que l''hélicoptère suffira à ses besoins de décollage vertical et réoriente ses crédits vers lui : les essais du VZ-4DA s''arrêtent, comme ceux des autres appareils non conventionnels. La NASA poursuit pourtant ses vols jusqu''en 1972. Exposé dès 1973 au musée des transports de l''Army à Fort Eustis, l''appareil a rejoint en 2024 le musée de l''aviation de l''US Army ; d''autres souvenirs de Doak sont conservés au Western Museum of Flight de Torrance.',
    E'## Genesis\nA self-taught engineer and vice-president of **Douglas**, **Edmund R. Doak Jr.** founded the **Doak Aircraft Company** in Torrance in 1940; it grew to 4,000 employees during the war as a subcontractor to the whole industry. In 1950 he proposed to the **US Army** a vertical take-off aircraft able to hover and even fly backwards like a helicopter, without its noise and vibration, while cruising fast and carrying wing-mounted weapons like a fighter. Fearing that a Soviet attack on airbases would ground conventional aircraft, the Army liked the idea: on 10 April 1956 it ordered a single research prototype, the **Model 16**.\n\n## Design\nAn 840 shp **Lycoming YT53** turbine in the fuselage, later replaced by a 1,000 shp **T53-L-1**, drove through a T-box and aluminium shafts two 1.22 m fibreglass **ducted fans** at the wingtips. Set with their axis vertical for take-off, where they turned at 4,800 rpm, they then rotated for cruising flight: the first successful test of this propulsion concept. Pilot and observer sat in tandem. To save weight the welded steel-tube structure was first left uncovered, before receiving a fibreglass nose and aluminium rear fuselage; the landing gear came from a **Cessna 182**, the seats from a **P-51 Mustang** and the duct actuators from a **T-33**.\n\n## Testing\nThe Model 16 first hovered on 25 February 1958 at Torrance, and made its first transition from vertical to horizontal flight and back on 5 May. Generally successful, it showed disappointing short take-off and landing performance and a tendency to nose up during transition. Moved to Edwards in October 1958, it reached 370 km/h and 3,700 m there in 50 hours of testing. The Army accepted it in September 1959 as the **VZ-4DA** and passed it to NASA''s **Langley** centre; when Doak laid off 90 per cent of his staff in late 1960, **Douglas** took over the project and its patents.\n\n## Place in history\nIn 1963 the Army decided the helicopter would meet its vertical take-off needs and shifted its funding to it: trials of the VZ-4DA stopped, like those of other unconventional aircraft. NASA nevertheless kept flying it until 1972. Displayed from 1973 at the Army Transportation Museum at Fort Eustis, the aircraft moved in 2024 to the US Army Aviation Museum; other Doak artefacts are kept at the Western Museum of Flight in Torrance.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1956-04-10',
    '1958-02-25',
    NULL,
    370,
    400,
    (SELECT id FROM manufacturer WHERE code = 'DOA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Doak VZ-4'), (SELECT id FROM tech WHERE name = 'Soufflante carénée'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Doak VZ-4'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.75,
  wingspan          = 7.77,
  height            = 3.05,
  wing_area         = NULL,
  empty_weight      = 1043,
  mtow              = 1451,
  service_ceiling   = 3700,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Avco Lycoming YT53 (840 ch), puis T53-L-1 (1 000 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Model 16** : désignation du constructeur, prototype unique commandé le 10 avril 1956\n- **Motorisation initiale** : turbine Lycoming YT53 de 840 ch\n- **Motorisation définitive** : turbine Lycoming T53-L-1 de 1 000 ch\n- **VZ-4DA** : désignation militaire après l''acceptation par l''US Army en septembre 1959\n- **Reprise par Douglas** : à partir de fin 1960, poursuite des travaux avec quatre ingénieurs de Doak',
  variants_en       = E'- **Model 16**: manufacturer''s designation, single prototype ordered on 10 April 1956\n- **Initial powerplant**: 840 shp Lycoming YT53 turbine\n- **Final powerplant**: 1,000 shp Lycoming T53-L-1 turbine\n- **VZ-4DA**: military designation after US Army acceptance in September 1959\n- **Douglas takeover**: from late 1960, work continued with four former Doak engineers',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Doak_VZ-4',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'RuthAS',
  image_licence     = 'CC BY 3.0'
WHERE name = 'Doak VZ-4';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Doak VZ-4';
