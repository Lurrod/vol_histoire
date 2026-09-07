-- Myasishchev M-55 Geofizika (Mystic-B)
--
-- Photo : Myasishchev M-55 Geophysica, Myasichchev Design Bureau AN1275839.jpg
--   licence CC BY-SA 3.0 — Oleg V. Belyakov - AirTeamImages
--   https://commons.wikimedia.org/wiki/File%3AMyasishchev_M-55_Geophysica%2C_Myasichchev_Design_Bureau_AN1275839.jpg

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
    'Myasishchev M-55',
    'Myasishchev M-55',
    'Myasishchev M-55 Geofizika (Mystic-B)',
    'Myasishchev M-55 Geophysica (Mystic-B)',
    'Le U-2 soviétique, reconverti dans l’étude de la couche d’ozone',
    'The Soviet U-2, converted to studying the ozone layer',
    '/assets/airplanes/m55-geofizika.jpg',
    E'## Genèse\nDans les années 1970, l''OTAN lâche des **ballons de reconnaissance** qui dérivent au-dessus de l''URSS à vingt mille mètres, hors de portée des chasseurs. Le bureau **Myasishchev**, écarté des bombardiers depuis vingt ans, reçoit une mission singulière : construire un avion capable de monter jusque-là et de les abattre au canon.\n\n## Conception\nTrente-sept mètres d''envergure pour vingt-quatre tonnes — c''est un planeur motorisé, cousin conceptuel du **U-2**. La version M-55 adopte deux réacteurs et une **double poutre de queue**, solution rare qui dégage l''arrière du fuselage pour les capteurs. À vingt et un mille mètres, l''appareil vole au-dessus de quatre-vingt-quinze pour cent de l''atmosphère.\n\n## Carrière opérationnelle\nCinq exemplaires. Les ballons ont cessé avant que l''appareil ne soit prêt, et la mission d''interception disparaît. En 1996, le M-55 trouve une seconde vie inattendue : l''**Agence spatiale européenne** et plusieurs instituts l''affrètent pour étudier la couche d''ozone, depuis la Suède, les Seychelles, le Brésil et le Népal.\n\n## Place dans l''histoire\nCinq exemplaires, seize records du monde, et une reconversion complète. Le M-55 est le seul appareil de ce catalogue conçu pour détruire des ballons, et le seul dont la carrière utile se soit déroulée **au service de la science européenne** — un ancien intercepteur soviétique loué par Bruxelles pour mesurer le trou d''ozone.',
    E'## Genesis\nIn the 1970s NATO released **reconnaissance balloons** that drifted over the USSR at twenty thousand metres, beyond the reach of fighters. The **Myasishchev** bureau, shut out of bombers for twenty years, received a singular task: build an aircraft able to climb that high and shoot them down with a gun.\n\n## Design\nThirty-seven metres of span for twenty-four tonnes — it is a powered glider, a conceptual cousin of the **U-2**. The M-55 version adopted two engines and a **twin tail boom**, a rare solution that frees the rear fuselage for sensors. At twenty-one thousand metres the aircraft flies above ninety-five per cent of the atmosphere.\n\n## Operational career\nFive built. The balloons stopped before the aircraft was ready, and the interception mission vanished. In 1996 the M-55 found an unexpected second life: the **European Space Agency** and several institutes chartered it to study the ozone layer, from Sweden, the Seychelles, Brazil and Nepal.\n\n## Place in history\nFive built, sixteen world records, and a complete conversion. The M-55 is the only aircraft in this catalogue designed to destroy balloons, and the only one whose useful career unfolded **in the service of European science** — a former Soviet interceptor chartered by Brussels to measure the ozone hole.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1978-01-01',
    '1988-08-16',
    '1994-01-01',
    743.0,
    4970.0,
    (SELECT id FROM manufacturer WHERE code = 'MYA'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-55'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-55'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-55'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-55'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 22.87,
  wingspan          = 37.46,
  height            = 4.83,
  wing_area         = 131.6,
  empty_weight      = 14000,
  mtow              = 24500,
  service_ceiling   = 21550,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1300,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Aviadvigatel PS-30V12',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 49.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1987,
  production_end    = 1994,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **M-17 Stratosfera (Mystic-A)** : version d''origine monoréacteur, trois exemplaires\n- **M-55 Geofizika (Mystic-B)** : version biréacteur à deux poutres de queue\n- Conçu à l''origine pour **abattre les ballons** de reconnaissance occidentaux\n- Détient **seize records du monde** d''altitude et de charge en 1990\n- Reconverti dans la **recherche atmosphérique** européenne à partir de 1996',
  variants_en       = E'- **M-17 Stratosfera (Mystic-A)** : original single-engined version, three built\n- **M-55 Geophysica (Mystic-B)** : twin-engined, twin-boom version\n- Originally designed to **shoot down** Western reconnaissance balloons\n- Holds **sixteen world records** for altitude and payload set in 1990\n- Converted to European **atmospheric research** from 1996',

  -- Strate 4 : qualitatif
  nickname          = 'Geofizika',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Myasishchev_M-55',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Myasishchev_M-55',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Oleg V. Belyakov - AirTeamImages',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Myasishchev M-55';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Myasishchev M-55';
