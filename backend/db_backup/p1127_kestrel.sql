-- Hawker P.1127 / Kestrel FGA.1
--
-- Photo : Hawker Siddeley P.1127 in flight at NASA Langley 1968.jpeg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File%3AHawker_Siddeley_P.1127_in_flight_at_NASA_Langley_1968.jpeg

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
    'Hawker P.1127 Kestrel',
    'Hawker P.1127 Kestrel',
    'Hawker P.1127 / Kestrel FGA.1',
    'Hawker P.1127 / Kestrel FGA.1',
    'Le prototype qui a rendu le décollage vertical possible',
    'The prototype that made vertical take-off possible',
    '/assets/airplanes/p1127-kestrel.jpg',
    E'## Genèse\nL''idée vient d''un moteur, pas d''un avion. En 1957, l''ingénieur français **Michel Wibault** propose de dévier la poussée d''un turboréacteur par des tuyères orientables ; Bristol reprend le principe et conçoit le **Pegasus**, à quatre tuyères tournant ensemble. Hawker bâtit une cellule autour. Le gouvernement britannique refusant de financer, ce sont les **États-Unis**, via le programme d''aide mutuelle de l''OTAN, qui paient les trois quarts du développement du moteur.\n\n## Conception\nTout est subordonné à l''équilibre : le Pegasus est placé au centre exact de gravité, les quatre tuyères réparties deux par deux de chaque côté. En vol stationnaire, les gouvernes classiques ne servent à rien — l''appareil est tenu par des **jets d''air comprimé** prélevés sur le compresseur et soufflés au nez, à la queue et en bout d''aile. Le train est disposé en bicycle, avec des balancines sous la voilure.\n\n## Carrière opérationnelle\nAucune au combat, mais une évaluation décisive. Le premier vol stationnaire libre a lieu le **19 novembre 1960**, la première transition complète en septembre 1961. Un escadron d''évaluation **tripartite** — britannique, américain et allemand — vole sur neuf Kestrel en 1965. Six partent ensuite aux États-Unis, où ils convaincront le Corps des Marines, futur plus gros utilisateur de l''appareil de série.\n\n## Place dans l''histoire\nQuinze exemplaires, et la seule formule de décollage vertical à réaction qui ait jamais réussi. Tous les autres — le Yak-38 soviétique excepté, et de loin — sont restés à l''état de prototypes. Le **Harrier** en sortira directement, servira quarante ans, se battra aux Malouines, et sa descendance technique se lit encore dans la soufflante du F-35B.',
    E'## Genesis\nThe idea came from an engine, not an aircraft. In 1957 the French engineer **Michel Wibault** proposed deflecting a jet engine''s thrust through swivelling nozzles; Bristol took up the principle and designed the **Pegasus**, with four nozzles turning together. Hawker built an airframe around it. With the British government refusing to fund it, it was the **United States**, through NATO''s mutual aid programme, that paid three quarters of the engine''s development.\n\n## Design\nEverything is subordinated to balance: the Pegasus sits at the exact centre of gravity, the four nozzles arranged two per side. In the hover conventional controls are useless — the aircraft is held by **compressed air jets** bled from the compressor and blown at the nose, tail and wingtips. The undercarriage is a bicycle arrangement with outriggers under the wing.\n\n## Operational career\nNone in combat, but a decisive evaluation. The first free hover took place on **19 November 1960**, the first full transition in September 1961. A **tripartite** evaluation squadron — British, American and German — flew nine Kestrels in 1965. Six then went to the United States, where they would convince the Marine Corps, the future largest operator of the production aircraft.\n\n## Place in history\nFifteen aircraft, and the only jet vertical take-off formula that ever succeeded. All the others — the Soviet Yak-38 excepted, and distantly at that — stayed prototypes. The **Harrier** came directly from it, served forty years, fought in the Falklands, and its technical descent can still be read in the F-35B''s lift fan.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1957-01-01',
    '1960-10-21',
    NULL,
    1176.0,
    1500.0,
    (SELECT id FROM manufacturer WHERE code = 'HS'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.9,
  wingspan          = 6.98,
  height            = 3.28,
  wing_area         = 17.0,
  empty_weight      = 4763,
  mtow              = 7530,
  service_ceiling   = 16000,
  climb_rate        = 60.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 370,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Siddeley Pegasus 5',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à poussée vectorielle',
  engine_type_en    = 'Vectored-thrust turbofan',
  thrust_dry        = 68.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1959,
  production_end    = 1964,
  units_built       = 15,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **P.1127** : six prototypes, premier vol stationnaire en octobre 1960\n- **Kestrel FGA.1** : neuf exemplaires d''évaluation pour un escadron tripartite\n- **XV-6A** : six Kestrel cédés aux **États-Unis**, évalués par l''armée, la Navy et la NASA\n- **Hawker Siddeley Harrier** : version opérationnelle, en service à partir de 1969\n- Le premier appontage vertical a lieu sur le HMS Ark Royal en **février 1963**',
  variants_en       = E'- **P.1127** : six prototypes, first hover in October 1960\n- **Kestrel FGA.1** : nine evaluation aircraft for a tripartite squadron\n- **XV-6A** : six Kestrels handed to the **United States**, evaluated by the Army, Navy and NASA\n- **Hawker Siddeley Harrier** : the operational version, in service from 1969\n- The first vertical deck landing took place on HMS Ark Royal in **February 1963**',

  -- Strate 4 : qualitatif
  nickname          = 'Kestrel',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hawker_P.1127',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hawker_Siddeley_P.1127',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'Hawker P.1127 Kestrel';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Hawker P.1127 Kestrel';
