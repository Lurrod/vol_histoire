-- Avro Canada VZ-9-AV Avrocar
--
-- Photo : Avrocar 3.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:Avrocar_3.jpg

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
    'Avro Canada VZ-9 Avrocar',
    'Avro Canada VZ-9 Avrocar',
    'Avro Canada VZ-9-AV Avrocar',
    'Avro Canada VZ-9-AV Avrocar',
    'La soucoupe volante d''Avro Canada, démonstrateur à décollage vertical qui n''a jamais quitté l''effet de sol',
    'Avro Canada''s flying saucer, a vertical take-off demonstrator that never left ground effect',
    '/assets/airplanes/avro-canada-vz9-avrocar.jpg',
    E'## Genèse\nL''Avrocar est l''aboutissement des recherches menées chez **Avro Canada** par **John « Jack » Frost**, venu en 1947 de l''industrie britannique, à la tête d''un « Special Projects Group ». Après une aile en forme de pique, le **Project Y**, financé en 1952 par le Canada, Frost s''intéresse à l''**effet Coandă** et retient le disque : c''est le **Project Y-2**. Financé dès 1955 par l''US Air Force, il devient le **Weapons System 606A**, chasseur supersonique à décollage vertical. En 1958, pour obtenir des données de vol sans attendre le moteur, Frost propose un démonstrateur plus petit, l''Avrocar, qui séduit aussi l''**US Army**, en quête d''une « jeep volante » : un contrat de 2 millions de dollars finance deux exemplaires, désignés VZ-9-AV.\n\n## Conception\nL''Avrocar est un disque de 5,5 m de diamètre et de 1,07 m d''épaisseur. Sa structure repose sur un grand triangle équilatéral, au centre duquel tourne un « turborotor » de 124 aubes entraîné par trois turboréacteurs **Continental J69-T-9** de 2,9 kN. L''essentiel du flux part vers le bas, le reste alimente un anneau de commande périphérique qui oriente l''écoulement ; un unique manche latéral agit par de l''air sous pression, sans liaison mécanique. Deux pilotes occupent des postes séparés. On en attendait 417 km/h et 3 000 m de plafond.\n\n## Essais\nSorti en mai 1959, le premier exemplaire passe au banc puis à la soufflerie du centre **Ames** de la NASA : sa portance hors de l''effet de sol se révèle inférieure à son poids à vide. Le second tente un vol captif le 29 septembre 1959 et entre aussitôt dans une oscillation de roulis et de tangage que l''équipe baptise « hubcapping ». Modifié, il effectue le 12 novembre 1959 son premier vol entièrement libre. Une nouvelle commande améliore le stationnaire mais rend l''engin instable au-delà de 56 km/h ; lors de l''évaluation du 9 juin 1961, il atteint 37 km/h et franchit un fossé de 1,8 m. Pour **Fred Drinkwater**, de la NASA, le piloter revenait à tenir en équilibre sur un ballon de plage.\n\n## Place dans l''histoire\nLes fonds sont épuisés dès mars 1961 et les militaires américains abandonnent l''Avrocar et le WS-606A la même année. Jugé sur ses performances, c''est un échec : brûlant, assourdissant, incapable de s''élever sans danger à plus de quelques pieds du sol. Il n''était pourtant qu''à une jupe de caoutchouc d''être l''un des premiers aéroglisseurs, et sa soufflante carénée a inspiré d''autres engins, dont ceux de **Paul Moller**, passé par Avro. Les deux exemplaires survivent, au musée national de l''US Air Force à Dayton et au musée du transport de l''US Army à Fort Eustis.',
    E'## Genesis\nThe Avrocar was the end result of research led at **Avro Canada** by **John ''Jack'' Frost**, who had joined in 1947 from the British industry, at the head of a ''Special Projects Group''. After a spade-shaped wing, **Project Y**, funded by Canada in 1952, Frost turned to the **Coandă effect** and settled on a disc: **Project Y-2**. Funded by the US Air Force from 1955, it became **Weapons System 606A**, a supersonic vertical take-off fighter. In 1958, to gather flight data while the engine was developed, Frost proposed a smaller demonstrator, the Avrocar, which also appealed to the **US Army**, then looking for a ''flying jeep'': a $2 million contract paid for two examples, designated VZ-9-AV.\n\n## Design\nThe Avrocar was a disc 5.5 m across and 1.07 m thick. Its structure was built around a large equilateral triangle, at the centre of which spun a 124-blade ''turborotor'' driven by three 2.9 kN **Continental J69-T-9** turbojets. Most of the flow went straight down, the rest feeding a control ring around the rim that directed the airflow; a single side-mounted stick worked through high-pressure air, with no mechanical linkages. Two pilots sat in separate cockpits. It was expected to reach 417 km/h and a 3,000 m ceiling.\n\n## Testing\nRolled out in May 1959, the first example went to a static rig, then to the wind tunnel at NASA''s **Ames** centre: its lift out of ground effect proved lower than its empty weight. The second made a tethered hover attempt on 29 September 1959 and at once fell into a rolling and pitching oscillation the team called ''hubcapping''. Once modified, it made its first completely free flight on 12 November 1959. A new control system improved the hover but made the craft unstable above 56 km/h; during the evaluation of 9 June 1961 it reached 37 km/h and crossed a 1.8 m ditch. NASA pilot **Fred Drinkwater** likened flying it to balancing on a beach ball.\n\n## Place in history\nFunding ran out in March 1961 and the US military abandoned the Avrocar and WS-606A that same year. Judged on its performance it was a failure: scorching, deafening and unable to rise safely more than a few feet off the ground. Yet it was a rubber skirt short of being one of the world''s first hovercraft, and its ducted fan inspired other craft, including those of **Paul Moller**, an Avro alumnus. Both examples survive, at the National Museum of the US Air Force in Dayton and the US Army Transportation Museum at Fort Eustis.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1958-01-01',
    '1959-11-12',
    NULL,
    56,
    127,
    (SELECT id FROM manufacturer WHERE code = 'AVC'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Canada VZ-9 Avrocar'), (SELECT id FROM tech WHERE name = 'Soufflante carénée'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Canada VZ-9 Avrocar'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 5.5,
  wingspan          = 5.5,
  height            = 1.07,
  wing_area         = 23.6,
  empty_weight      = 1361,
  mtow              = 2522,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Continental J69-T-9',
  engine_count      = 3,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 2.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1958,
  production_end    = 1959,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Project Y / Y-2** : études d''Avro Canada, aile en forme de pique puis disque à effet Coandă\n- **WS-606A / Project 1794** : chasseur supersonique à décollage vertical en forme de disque, financé par l''US Air Force, jamais construit\n- **VZ-9-AV 58-7055** : premier Avrocar, essais au banc et en soufflerie à Ames ; exposé au musée de l''US Air Force à Dayton\n- **VZ-9-AV 59-4975** : second Avrocar, auteur des vols libres ; en restauration au musée du transport de l''US Army\n- **Versions proposées** : dérive ou ailettes, deux turboréacteurs General Electric J85 et turborotor agrandi, jamais réalisées',
  variants_en       = E'- **Project Y / Y-2**: Avro Canada studies, a spade-shaped wing and then a Coandă-effect disc\n- **WS-606A / Project 1794**: disc-shaped supersonic vertical take-off fighter funded by the US Air Force, never built\n- **VZ-9-AV 58-7055**: first Avrocar, rig and Ames wind tunnel testing; displayed at the US Air Force museum in Dayton\n- **VZ-9-AV 59-4975**: second Avrocar, which made the free flights; under restoration at the US Army Transportation Museum\n- **Proposed versions**: tail fin or winglets, two General Electric J85 turbojets and a larger turborotor, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Avro_Canada_VZ-9_Avrocar',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Avro_Canada_VZ-9_Avrocar',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Avro Canada VZ-9 Avrocar';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Avro Canada VZ-9 Avrocar';
