-- Northrop Grumman RQ-4 Global Hawk
--
-- Photo : RQ-4 Global Hawk at Paris Air Show 2009.jpg
--   licence CC BY-SA 3.0 — Tangopaso
--   https://commons.wikimedia.org/wiki/File%3ARQ-4_Global_Hawk_at_Paris_Air_Show_2009.jpg

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
    'RQ-4 Global Hawk',
    'RQ-4 Global Hawk',
    'Northrop Grumman RQ-4 Global Hawk',
    'Northrop Grumman RQ-4 Global Hawk',
    'Trente-quatre heures de vol à dix-huit mille mètres, sans personne à bord',
    'Thirty-four hours at eighteen thousand metres, with nobody aboard',
    '/assets/airplanes/rq4-global-hawk.jpg',
    E'## Genèse\nLe **U-2** vole depuis 1955 et fait toujours le même métier : monter à vingt mille mètres et regarder. Mais il exige un pilote en scaphandre, et sa mission ne dure que dix heures. En 1994, l''US Air Force demande un successeur sans équipage capable de tenir **plus de trente heures** — assez pour traverser un océan, observer et revenir.\n\n## Conception\nUne aile de **quarante mètres**, plus grande que celle d''un Boeing 737, greffée sur un fuselage court dont le nez bulbeux abrite l''antenne satellite. Le réacteur est monté sur le dos. À dix-huit mille mètres, l''appareil est hors de portée de la plupart des défenses et couvre **cent mille kilomètres carrés par jour** avec son radar à antenne active et ses capteurs optiques.\n\n## Carrière opérationnelle\nQuarante-deux exemplaires seulement, pour cent trente millions de dollars pièce. Engagé en Afghanistan, en Irak, en Libye, au-dessus de Fukushima après le tsunami de 2011, et en surveillance permanente de la mer Noire depuis 2022. Le **20 juin 2019**, l''Iran en abat un au-dessus d''Ormuz : la destruction d''un appareil sans pilote de cent trente millions de dollars pose une question inédite de riposte.\n\n## Place dans l''histoire\nQuarante-deux exemplaires. Le Global Hawk devait remplacer le U-2 ; il coûte si cher que l''US Air Force a plusieurs fois envisagé l''inverse. Il reste le seul drone à avoir traversé le Pacifique sans escale, et le plus grand aéronef sans équipage jamais mis en service.',
    E'## Genesis\nThe **U-2** has flown since 1955 doing the same job: climb to twenty thousand metres and look. But it needs a pilot in a pressure suit, and its mission lasts only ten hours. In 1994 the US Air Force asked for an unmanned successor able to stay up **more than thirty hours** — enough to cross an ocean, observe and return.\n\n## Design\nA **forty-metre** wing, greater than a Boeing 737''s, grafted onto a short fuselage whose bulbous nose houses the satellite antenna. The engine sits on the spine. At eighteen thousand metres the aircraft is beyond most defences and covers **a hundred thousand square kilometres a day** with its active array radar and optical sensors.\n\n## Operational career\nOnly forty-two built, at a hundred and thirty million dollars each. Used over Afghanistan, Iraq and Libya, above Fukushima after the 2011 tsunami, and in permanent surveillance of the Black Sea since 2022. On **20 June 2019** Iran shot one down over Hormuz: destroying a hundred-and-thirty-million-dollar unmanned aircraft raised an unprecedented question about retaliation.\n\n## Place in history\nForty-two built. The Global Hawk was meant to replace the U-2; it costs so much that the US Air Force has several times considered the reverse. It remains the only drone to have crossed the Pacific non-stop, and the largest unmanned aircraft ever fielded.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1994-01-01',
    '1998-02-28',
    '2001-11-01',
    629.0,
    22780.0,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-4 Global Hawk'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'RQ-4 Global Hawk'), (SELECT id FROM tech WHERE name = 'Radar AESA'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-4 Global Hawk'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.5,
  wingspan          = 39.9,
  height            = 4.7,
  wing_area         = 50.2,
  empty_weight      = 6781,
  mtow              = 14628,
  service_ceiling   = 18300,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 5556,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce F137-RR-100',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 34.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1998,
  production_end    = NULL,
  units_built       = 42,
  unit_cost_usd     = 131400000,
  unit_cost_year    = 2013,
  operators_count   = 4,
  variants          = E'- **RQ-4A / RQ-4B** : versions successives, la B à envergure et charge accrues\n- **MQ-4C Triton** : version de patrouille maritime de l''US Navy\n- **NATO AGS** : cinq exemplaires exploités en commun par l''**OTAN** depuis l''Italie\n- Envergure de **39,9 m**, supérieure à celle d''un **Boeing 737**\n- Un RQ-4 est **abattu par l''Iran** le 20 juin 2019 au-dessus du détroit d''Ormuz',
  variants_en       = E'- **RQ-4A / RQ-4B** : successive versions, the B with greater span and payload\n- **MQ-4C Triton** : US Navy maritime patrol version\n- **NATO AGS** : five aircraft operated jointly by **NATO** from Italy\n- A span of **39.9 m**, greater than a **Boeing 737**\n- One RQ-4 was **shot down by Iran** on 20 June 2019 over the Strait of Hormuz',

  -- Strate 4 : qualitatif
  nickname          = 'Global Hawk',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_Grumman_RQ-4_Global_Hawk',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_Grumman_RQ-4_Global_Hawk',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Tangopaso',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'RQ-4 Global Hawk';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'RQ-4 Global Hawk';
