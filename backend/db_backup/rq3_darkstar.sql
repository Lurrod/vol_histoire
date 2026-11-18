-- Lockheed Martin / Boeing RQ-3A DarkStar
--
-- Photo : DarkStar Tier III 2.jpg
--   licence Public domain — Carla Thomas
--   https://commons.wikimedia.org/wiki/File:DarkStar_Tier_III_2.jpg

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
    'Lockheed Martin RQ-3 DarkStar',
    'Lockheed Martin RQ-3 DarkStar',
    'Lockheed Martin / Boeing RQ-3A DarkStar',
    'Lockheed Martin / Boeing RQ-3A DarkStar',
    'Drone de reconnaissance furtif et entièrement autonome, conçu pour entrer là où le Global Hawk ne peut aller',
    'Fully autonomous stealthy reconnaissance drone, designed to go where the Global Hawk cannot',
    '/assets/airplanes/rq3-darkstar.jpg',
    E'## Genèse\nAppelé **Tier III-** (« Tier three minus ») pendant son développement, le DarkStar est conçu par **Lockheed Martin** et **Boeing** comme un drone d''endurance à haute altitude. Sa raison d''être tient en une différence : là où le **RQ-4 Global Hawk** ne peut opérer qu''une fois la maîtrise du ciel acquise, le DarkStar doit, grâce à la furtivité, travailler à l''intérieur d''un espace aérien fortement défendu. Sa désignation le résume : R pour reconnaissance, Q pour système sans pilote, 3 pour le troisième d''une série d''appareils de reconnaissance sans pilote conçus comme tels.\n\n## Conception\nLong de 4,6 m seulement pour 21,3 m d''envergure, le DarkStar est entièrement autonome : il peut décoller, rejoindre son objectif, faire fonctionner ses capteurs, transmettre ses informations, revenir et se poser sans intervention humaine. Les opérateurs peuvent toutefois modifier son plan de vol et l''orientation de ses capteurs par radio ou par relais satellite. Il emporte soit un capteur optique, soit un radar, et peut envoyer des données numériques vers un satellite en plein vol. Son unique réacteur n''est pas identifié avec certitude ; une source cite un turboréacteur double flux Williams-Rolls-Royce FJ44-1A.\n\n## Essais\nLe premier prototype vole le 29 mars 1996, mais s''écrase peu après le décollage lors de son deuxième vol, le 22 avril 1996. Une version modifiée et plus stable, le RQ-3A, prend l''air le 29 juin 1998 et effectue cinq vols ; deux autres RQ-3A sont construits sans jamais voler. Le 28 janvier 1999, le département de la Défense arrête le programme, juste avant le sixième et dernier vol prévu de la phase de navigabilité : le drone n''est pas jugé assez stable aérodynamiquement et ne tient ni ses objectifs de coût ni ceux de performances.\n\n## Place dans l''histoire\nLe DarkStar laisse ainsi le Global Hawk, non furtif, seul sur le créneau de la haute altitude. Un article d''Aviation Week de juillet 2003 affirme qu''un dérivé aurait servi pendant l''invasion de l''Irak au printemps 2003, sans qu''aucune confirmation indépendante ne vienne l''étayer. Trois exemplaires subsistent : le second RQ-3A, suspendu au musée national de l''US Air Force à Dayton, le troisième au Museum of Flight de Seattle et le quatrième, en réserve, au National Air and Space Museum.',
    E'## Genesis\nKnown as **Tier III-** (Tier three minus) during development, the DarkStar was designed by **Lockheed Martin** and **Boeing** as a high-altitude endurance drone. Its reason for being came down to one difference: where the **RQ-4 Global Hawk** can only operate once air supremacy has been won, the DarkStar was to use stealth to work inside heavily defended airspace. Its designation sums it up: R for reconnaissance, Q for unmanned system, 3 for the third in a series of purpose-built unmanned reconnaissance aircraft.\n\n## Design\nOnly 4.6 m long for a 21.3 m wingspan, the DarkStar was fully autonomous: it could take off, fly to its target, operate its sensors, transmit information, return and land without human intervention. Operators could nonetheless change its flight plan and sensor orientation through radio or satellite relay. It carried either an optical sensor or a radar, and could send digital data to a satellite while still in flight. Its single jet engine has never been identified with certainty; one source cites a Williams-Rolls-Royce FJ44-1A turbofan.\n\n## Testing\nThe first prototype flew on 29 March 1996, but crashed shortly after take-off on its second flight, on 22 April 1996. A modified, more stable version, the RQ-3A, flew on 29 June 1998 and made five flights; two more RQ-3As were built but never flew. On 28 January 1999 the Department of Defense terminated the programme, just before the sixth and final flight planned for the airworthiness phase: the drone was judged not aerodynamically stable enough and was not meeting its cost and performance objectives.\n\n## Place in history\nThe DarkStar thus left the non-stealthy Global Hawk alone in the high-altitude niche. A July 2003 Aviation Week article claimed that a derivative had been used during the invasion of Iraq in spring 2003, with no independent confirmation. Three aircraft survive: the second RQ-3A, hanging in the National Museum of the United States Air Force in Dayton, the third at the Museum of Flight in Seattle and the fourth, in storage, at the National Air and Space Museum.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1996-03-29',
    NULL,
    NULL,
    925,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin RQ-3 DarkStar'), (SELECT id FROM tech WHERE name = 'Conception furtive'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin RQ-3 DarkStar'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 4.6,
  wingspan          = 21.3,
  height            = 1.1,
  wing_area         = NULL,
  empty_weight      = 1980,
  mtow              = 3860,
  service_ceiling   = 13500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Williams-Rolls-Royce FJ44-1A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 8.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Tier III- n° 1** : premier vol le 29 mars 1996, détruit au décollage de son deuxième vol le 22 avril 1996\n- **RQ-3A** : version modifiée plus stable, premier vol le 29 juin 1998, cinq vols\n- **Deux RQ-3A supplémentaires**, construits sans jamais voler\n- **Exemplaires conservés** : A/V 2 à Dayton, A/V 3 au Museum of Flight de Seattle, A/V 4 en réserve au National Air and Space Museum',
  variants_en       = E'- **Tier III- No. 1**: first flight on 29 March 1996, destroyed on take-off on its second flight, 22 April 1996\n- **RQ-3A**: modified, more stable version, first flight on 29 June 1998, five flights\n- **Two further RQ-3As**, built but never flown\n- **Surviving aircraft**: A/V 2 in Dayton, A/V 3 at the Museum of Flight in Seattle, A/V 4 in storage at the National Air and Space Museum',

  -- Strate 4 : qualitatif
  nickname          = 'Tier III-',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_Martin_RQ-3_DarkStar',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Carla Thomas, NASA',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed Martin RQ-3 DarkStar';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'Lockheed Martin RQ-3 DarkStar';
