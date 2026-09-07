-- Tupolev Tu-128 Fiddler
--
-- Photo : Tu-128.jpg
--   licence CC BY-SA 3.0 — Mike1979 Russia
--   https://commons.wikimedia.org/wiki/File%3ATu-128.jpg

-- Entrée de référentiel propre à cette fiche.
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-4', NULL, 'Missile air-air lourd, versions à guidage radar semi-actif et infrarouge, portée 25 km', 'Heavy air-to-air missile in semi-active radar and infrared versions, 25 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-4');

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
    'Tu-128',
    'Tu-128',
    'Tupolev Tu-128 Fiddler',
    'Tupolev Tu-128 Fiddler',
    'Le plus gros et le plus lourd intercepteur jamais mis en service',
    'The largest and heaviest interceptor ever to enter service',
    '/assets/airplanes/tu128-fiddler.jpg',
    E'## Genèse\nL''URSS a un problème de géographie : entre l''Oural et le Pacifique, la frontière nord s''étend sur des milliers de kilomètres sans radars ni terrains. Aucun intercepteur classique ne peut y patrouiller. Tupolev propose de partir non pas d''un chasseur, mais d''un **bombardier supersonique** abandonné, le Tu-98.\n\n## Conception\nTrente mètres de long, quarante-quatre tonnes au décollage : le Tu-128 pèse plus qu''un bombardier moyen. Il ne manœuvre pas, ne monte pas vite, et n''en a pas besoin. Sa mission est de tenir l''air pendant des heures loin de toute base, de détecter avec son énorme radar Smertch un bombardier ou un missile de croisière, et de tirer quatre missiles **R-4** de très loin.\n\n## Carrière opérationnelle\nDéployé de 1964 à 1990 sur les bases arctiques et sibériennes les plus isolées, il n''a jamais tiré en situation réelle. Sa véritable adversaire fut la météo : il opérait depuis des terrains où la température descend sous les −50 °C.\n\n## Place dans l''histoire\nAucun autre pays n''a jamais mis en service un intercepteur de cette taille. Le Tu-128 illustre une logique purement soviétique : à un problème de distance, répondre par la masse. Le **MiG-31**, plus petit mais bien plus rapide et doté d''un radar à balayage électronique, lui succède en 1981.',
    E'## Genesis\nThe USSR had a geography problem: between the Urals and the Pacific its northern frontier stretched thousands of kilometres without radars or airfields. No conventional interceptor could patrol it. Tupolev proposed starting not from a fighter but from an abandoned **supersonic bomber**, the Tu-98.\n\n## Design\nThirty metres long, forty-four tonnes at take-off: the Tu-128 weighed more than a medium bomber. It did not manoeuvre, did not climb fast, and did not need to. Its mission was to stay airborne for hours far from any base, detect a bomber or cruise missile with its huge Smerch radar, and fire four **R-4** missiles from very long range.\n\n## Operational career\nDeployed from 1964 to 1990 on the most isolated Arctic and Siberian bases, it never fired in anger. Its real adversary was the weather: it operated from fields where temperatures fall below −50 °C.\n\n## Place in history\nNo other country ever fielded an interceptor of this size. The Tu-128 illustrates a purely Soviet logic: answer a problem of distance with mass. The **MiG-31**, smaller but far faster and fitted with an electronically scanned radar, succeeded it in 1981.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1955-01-01',
    '1961-03-18',
    '1964-06-01',
    1910.0,
    2565.0,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-128'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Tu-128'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'Tu-128'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-128'), (SELECT id FROM armement WHERE name = 'R-4'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-128'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Tu-128'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-128'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.06,
  wingspan          = 17.53,
  height            = 7.15,
  wing_area         = 96.94,
  empty_weight      = 24500,
  mtow              = 43700,
  service_ceiling   = 15600,
  climb_rate        = 40,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1170,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lyulka AL-7F-2',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 72.6,
  thrust_wet        = 100.0,

  -- Strate 3 : production & service
  production_start  = 1961,
  production_end    = 1970,
  units_built       = 198,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Tu-128S-4** : système complet associant l''avion, le radar Smertch et les missiles R-4\n- **Tu-128M** : radar et missiles modernisés, portée de détection accrue\n- **Tu-128UT** : version d''entraînement à cockpit supplémentaire dans le nez',
  variants_en       = E'- **Tu-128S-4** : complete system pairing the aircraft, the Smerch radar and R-4 missiles\n- **Tu-128M** : upgraded radar and missiles with greater detection range\n- **Tu-128UT** : training version with an extra cockpit in the nose',

  -- Strate 4 : qualitatif
  nickname          = 'Fiddler',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tupolev_Tu-128',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tupolev_Tu-128',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mike1979 Russia',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Tu-128';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tu-128';
