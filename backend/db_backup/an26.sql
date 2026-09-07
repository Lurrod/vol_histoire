-- Antonov An-26 (Curl)
--
-- Photo : Antonov An-26, Ukraine - Air Force AN1412045.jpg
--   licence CC BY-SA 3.0 — Oleg V. Belyakov - AirTeamImages
--   https://commons.wikimedia.org/wiki/File%3AAntonov_An-26%2C_Ukraine_-_Air_Force_AN1412045.jpg

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
    'Antonov An-26',
    'Antonov An-26',
    'Antonov An-26 (Curl)',
    'Antonov An-26 (Curl)',
    'Quatorze cents exemplaires : le transport tactique du bloc de l’Est',
    'Fourteen hundred built: the Eastern bloc’s tactical transport',
    '/assets/airplanes/an26.jpg',
    E'## Genèse\nL''**An-24** est un excellent avion de ligne régional, produit à plus de mille exemplaires, mais sa porte latérale interdit tout usage militaire sérieux : on ne charge pas une jeep par une porte de cabine. En 1966, Antonov entreprend d''en faire un transport tactique, ce qui suppose de redessiner entièrement l''arrière du fuselage.\n\n## Conception\nLa solution est ingénieuse : la rampe arrière ne s''abaisse pas, elle **coulisse sous le fuselage**. Un camion peut ainsi reculer jusqu''au seuil et décharger de plain-pied, et la même rampe sert au largage en vol. Les moteurs AI-24 sont renforcés et un petit **réacteur d''appoint** est logé dans la nacelle droite pour le décollage à chaud et en altitude.\n\n## Carrière opérationnelle\n**Mille quatre cent trois exemplaires**, une cinquantaine de pays — le transport tactique le plus produit du bloc de l''Est. Il vole en Afghanistan, en Angola, en Éthiopie, au Vietnam, en Syrie et aujourd''hui en Ukraine, où plusieurs ont été abattus depuis 2014. Sa réputation de fiabilité en conditions dégradées est intacte après cinquante ans.\n\n## Place dans l''histoire\nMille quatre cent trois exemplaires. L''An-26 est au bloc de l''Est ce que le **C-130 Hercules** est à l''Occident, à l''échelle près : plus petit, plus simple, produit en plus grand nombre. Il ferme dans ce catalogue la lignée Antonov, dont il est le cinquième et dernier appareil.',
    E'## Genesis\nThe **An-24** is an excellent regional airliner, built in more than a thousand examples, but its side door rules out any serious military use: you cannot load a jeep through a cabin door. In 1966 Antonov set about turning it into a tactical transport, which meant redrawing the entire rear fuselage.\n\n## Design\nThe solution is ingenious: the rear ramp does not lower, it **slides under the fuselage**. A lorry can therefore back up to the sill and unload on the level, and the same ramp serves for airdrops. The AI-24 engines are uprated and a small **booster jet** is housed in the right nacelle for hot and high take-offs.\n\n## Operational career\n**One thousand four hundred and three built**, some fifty countries — the most produced tactical transport of the Eastern bloc. It has flown in Afghanistan, Angola, Ethiopia, Vietnam, Syria and today in Ukraine, where several have been shot down since 2014. Its reputation for reliability in poor conditions is intact after fifty years.\n\n## Place in history\nOne thousand four hundred and three built. The An-26 is to the Eastern bloc what the **C-130 Hercules** is to the West, allowing for scale: smaller, simpler, built in greater numbers. In this catalogue it closes the Antonov line, of which it is the fifth and last aircraft.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1966-01-01',
    '1969-05-21',
    '1970-01-01',
    540.0,
    2550.0,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-26'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-26'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-26'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-26'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-26'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-26'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.8,
  wingspan          = 29.2,
  height            = 8.58,
  wing_area         = 74.98,
  empty_weight      = 15020,
  mtow              = 24000,
  service_ceiling   = 7500,
  climb_rate        = 6.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 900,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-24VT',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1969,
  production_end    = 1986,
  units_built       = 1403,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 50,
  variants          = E'- **An-26** : version de transport de base, la plus produite\n- **An-26B** : version de fret palettisé, à équipements de manutention\n- **An-26RT / An-26M** : versions de relais radio et d''évacuation sanitaire\n- **Rampe arrière coulissante** sous le fuselage : chargement de plain-pied depuis un camion\n- Dérivé de l''**An-24** civil ; a donné l''**An-30** et l''**An-32**',
  variants_en       = E'- **An-26** : basic transport version, the most produced\n- **An-26B** : palletised freight version with handling equipment\n- **An-26RT / An-26M** : radio relay and medical evacuation versions\n- **Sliding rear ramp** under the fuselage: level loading straight from a lorry\n- Derived from the civil **An-24**; gave rise to the **An-30** and **An-32**',

  -- Strate 4 : qualitatif
  nickname          = 'Curl',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-26',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-26',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Oleg V. Belyakov - AirTeamImages',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Antonov An-26';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-26';
