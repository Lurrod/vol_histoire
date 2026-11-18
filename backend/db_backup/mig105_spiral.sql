-- Mikoyan-Gourevitch MiG-105 « Spiral »
--
-- Photo : Mikoyan-Gurevich MiG-105 EPOS (8911845093).jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany
--   https://commons.wikimedia.org/wiki/File:Mikoyan-Gurevich_MiG-105_EPOS_(8911845093).jpg

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
    'MiG-105',
    'MiG-105',
    'Mikoyan-Gourevitch MiG-105 « Spiral »',
    'Mikoyan-Gurevich MiG-105 Spiral',
    'Maquette volante pilotée de l''avion spatial soviétique Spiral, un corps portant qui atterrissait sur patins',
    'A piloted flying analogue of the Soviet Spiral spaceplane, a lifting body that landed on skids',
    '/assets/airplanes/mig105-spiral.jpg',
    E'## Genèse\nEn 1965, le bureau **Mikoyan** lance, sous la direction de **Gleb Lozino-Lozinsky**, le programme **Spiral**, un projet d''avion spatial orbital soviétique, aussi connu sous le nom d''**EPOS** (avion orbital habité expérimental). Le projet, arrêté en 1969, est relancé en 1974 en réponse à la navette spatiale américaine. Le système prévu était ambitieux : l''avion spatial et un étage-fusée à ergols liquides devaient être lancés à haute altitude depuis le dos d''un avion porteur hypersonique de **Tupolev**, qui ne fut jamais construit. Le **MiG-105** en est l''analogue piloté, chargé d''étudier le comportement à basse vitesse et l''atterrissage.\n\n## Conception\nLe MiG-105 est un corps portant au nez large et aplati, qui lui vaut le surnom de **« Lapot »**, la chaussure d''écorce tressée. Ses ailes à dièdre variable devaient rester relevées à 60° pendant le lancement et la rentrée, puis être abaissées à l''horizontale une fois revenu en subsonique. Un turboréacteur **RD-36-35K**, alimenté par une entrée d''air sous la dérive protégée par une trappe, permet un atterrissage propulsé et une remise des gaz. L''avion se pose sur des patins sortis de trappes situées sur les flancs, au-dessus et en avant des ailes : une disposition destinée à préserver la protection thermique, qui a valu au moins un atterrissage dur.\n\n## Essais\nLe MiG-105 effectue son premier vol libre en 1976, en décollant par ses propres moyens d''une ancienne piste près de Moscou. Piloté par **Aviard Fastovets**, il rejoint le centre d''essais de Joukovski au terme d''un vol de 35 km, à 560 m d''altitude au plus. Huit vols d''essais au total ont lieu, de loin en loin, jusqu''en 1978, à des vitesses subsoniques. L''avion spatial ne sera jamais lancé : le programme est annulé lorsque l''Union soviétique choisit de développer la navette **Bourane**.\n\n## Place dans l''histoire\nSpiral a laissé une descendance : les maquettes inhabitées **BOR**, lancées pour essayer en vraie rentrée sa protection thermique « en écailles », ont servi à la mise au point de Bourane. Le MiG-105, seule réalisation visible du programme, est aujourd''hui exposé au musée central des forces aériennes de Monino, près de Moscou.',
    E'## Genesis\nIn 1965 the **Mikoyan** bureau launched, under **Gleb Lozino-Lozinsky**, the **Spiral** programme, a Soviet orbital spaceplane project also known as **EPOS** (Experimental Passenger Orbital Aircraft). Halted in 1969, the project was restarted in 1974 in response to the American Space Shuttle. The planned system was ambitious: the spaceplane and a liquid-fuelled booster stage were to be launched at high altitude from the back of a hypersonic **Tupolev** mothership, which was never built. The **MiG-105** was its piloted analogue, built to explore low-speed handling and landing.\n\n## Design\nThe MiG-105 was a lifting body with a broad, flattened nose that earned it the nickname **''Lapot''**, the Russian bast shoe. Its variable-dihedral wings were to stay folded up at 60 degrees during launch and re-entry, then be lowered to the horizontal once back at subsonic speed. An **RD-36-35K** turbojet, fed by an intake beneath the fin protected by a door, allowed a powered landing and a go-around. The aircraft landed on skids extended from doors on the fuselage sides, above and ahead of the wings: a layout meant to protect the heat shield, which led to at least one hard landing.\n\n## Testing\nThe MiG-105 made its first free flight in 1976, taking off under its own power from an old airstrip near Moscow. Flown by **Aviard Fastovets**, it reached the Zhukovsky test centre after a 35 km flight, never higher than 560 m. Eight test flights in all followed sporadically until 1978, at subsonic speeds. The spaceplane itself was never launched: the programme was cancelled when the Soviet Union chose to develop the **Buran** shuttle instead.\n\n## Place in history\nSpiral left descendants: the uncrewed **BOR** sub-scale vehicles, launched to try its ''scale-plate'' heat shield in a real re-entry, were used in the development of Buran. The MiG-105, the only visible result of the programme, is now on display at the Central Air Force Museum at Monino, near Moscow.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1965-01-01',
    '1976-01-01',
    NULL,
    800,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-105'), (SELECT id FROM tech WHERE name = 'Corps portant'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-105'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.6,
  wingspan          = 6.7,
  height            = NULL,
  wing_area         = 24,
  empty_weight      = 3500,
  mtow              = 4220,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'RD-36-35K',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 19.61,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Spiral (EPOS)** : avion spatial orbital prévu, lancé depuis un porteur hypersonique Tupolev avec un étage-fusée, jamais construit\n- **MiG-105-11** : analogue subsonique piloté, huit vols de 1976 à 1978, exposé à Monino\n- **BOR** : maquettes inhabitées à échelle réduite, lancées pour essayer la protection thermique en rentrée',
  variants_en       = E'- **Spiral (EPOS)**: planned orbital spaceplane, to be launched from a hypersonic Tupolev mothership with a rocket stage, never built\n- **MiG-105-11**: piloted subsonic analogue, eight flights from 1976 to 1978, displayed at Monino\n- **BOR**: uncrewed sub-scale vehicles launched to test the heat shield during re-entry',

  -- Strate 4 : qualitatif
  nickname          = 'Lapot',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_MiG-105',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mikoyan-Gurevich_MiG-105',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clemens Vasters',
  image_licence     = 'CC BY 2.0'
WHERE name = 'MiG-105';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MiG-105';
