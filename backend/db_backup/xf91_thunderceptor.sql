-- Republic XF-91 Thunderceptor
--
-- Photo : XF91-21republic.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:XF91-21republic.jpg

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
    'Republic XF-91 Thunderceptor',
    'Republic XF-91 Thunderceptor',
    'Republic XF-91 Thunderceptor',
    'Republic XF-91 Thunderceptor',
    'Intercepteur à réacteur et fusée, à l''aile élargie en bout, premier chasseur américain supersonique en palier',
    'Jet and rocket interceptor with a wing widening at the tips, the first US fighter supersonic in level flight',
    '/assets/airplanes/xf91-thunderceptor.jpg',
    E'## Genèse\nPendant le développement du **F-84 Thunderjet**, l''équipe de **Republic** dirigée par **Alexander Kartveli** étudie l''ajout de moteurs-fusées sur un chasseur. Elle s''inspire des appareils allemands de la guerre, l''avion-fusée **Me 163** et les intercepteurs **Me 262C Heimatschützer** à fusée d''appoint. L''idée : voler sur un réacteur la plupart du temps, et allumer une grappe de quatre petites chambres de combustion pour la montée et l''interception. Le projet, d''abord désigné XP-91, est l''une des deux versions à aile en flèche dérivées du F-84, avec le futur **F-84F Thunderstreak**.\n\n## Conception\nLe trait le plus original du Thunderceptor est son **aile à effilement inversé** : sa corde augmente de l''emplanture vers l''extrémité, à l''inverse des ailes en flèche habituelles. Il s''agit de combattre le cabré brutal qui frappe les premiers avions à aile en flèche quand le bout d''aile décroche avant le reste : ici, toute l''aile décroche progressivement, comme une aile droite. Les extrémités plus épaisses logent le train principal à roues en tandem, et l''incidence de toute l''aile peut varier pour le décollage et l''atterrissage. La propulsion associe un **General Electric J47** à postcombustion et un moteur-fusée **Reaction Motors XLR11** de 26,7 kN.\n\n## Essais\nLe premier prototype vole le 9 mai 1949, et en décembre 1951 il devient le premier chasseur américain à dépasser Mach 1 en vol en palier. Le second, qui reçoit un radôme complet et une entrée d''air sous le nez, subit à l''été 1951 une panne moteur au décollage d''Edwards : le pilote de Republic **Carl Bellinger** s''échappe juste avant que la queue ne fonde. Reconstruit avec un empennage papillon, il vole ensuite dans cette configuration. Les deux prototypes accomplissent 192 vols d''essai en cinq ans.\n\n## Place dans l''histoire\nLe Thunderceptor est dépassé avant même d''être prêt : ses vols ne durent qu''environ 25 minutes, bien trop peu pour défendre un territoire comme les États-Unis, et il n''a ni le radar ni la conduite de tir du vol de nuit et tous temps. L''US Air Force préfère attendre les intercepteurs du programme de 1954, et l''ère de l''intercepteur de jour spécialisé se termine. Le premier prototype est exposé au musée de l''US Air Force à Dayton ; le second, après avoir servi à l''entraînement des pompiers d''Edwards, est démoli.',
    E'## Genesis\nWhile developing the **F-84 Thunderjet**, the **Republic** team led by **Alexander Kartveli** studied fitting rockets to a fighter. It drew on German wartime aircraft, the **Me 163** rocket plane and the rocket-boosted **Me 262C Heimatschützer** interceptors. The idea was to fly on a turbojet most of the time and light a cluster of four small rocket chambers for the climb and the interception. The project, first designated XP-91, was one of two swept-wing derivatives of the F-84, alongside the later **F-84F Thunderstreak**.\n\n## Design\nThe Thunderceptor''s most original feature was its **inverse tapered wing**: its chord grew from root to tip, the opposite of conventional swept wings. The aim was to cure the violent pitch-up that struck early swept-wing aircraft when the wingtips stalled before the rest of the wing: here the whole wing stalled smoothly, like a straight wing. The deeper tips housed the main gear with tandem wheels, and the incidence of the whole wing could be varied for take-off and landing. Power came from an afterburning **General Electric J47** and a 26.7 kN **Reaction Motors XLR11** rocket engine.\n\n## Testing\nThe first prototype flew on 9 May 1949, and in December 1951 it became the first American fighter to exceed Mach 1 in level flight. The second, which received a full radome and a chin intake, suffered an engine failure on take-off from Edwards in the summer of 1951: Republic pilot **Carl Bellinger** escaped just as the tail melted off. Rebuilt with a butterfly tail, it went on flying in that configuration. The two prototypes completed 192 test flights over five years.\n\n## Place in history\nThe Thunderceptor was overtaken before it was ready: its flights lasted only about 25 minutes, far too little to defend a territory the size of the United States, and it lacked the radar and fire control needed for night and all-weather work. The US Air Force chose to wait for the interceptors of the 1954 programme, and the era of the dedicated day interceptor came to an end. The first prototype is displayed at the US Air Force museum in Dayton; the second, after serving for crash-crew training at Edwards, was scrapped.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1949-05-09',
    NULL,
    1584,
    1885,
    (SELECT id FROM manufacturer WHERE code = 'REP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Republic XF-91 Thunderceptor'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Republic XF-91 Thunderceptor'), (SELECT id FROM tech WHERE name = 'Aile à incidence variable')),
((SELECT id FROM airplanes WHERE name = 'Republic XF-91 Thunderceptor'), (SELECT id FROM tech WHERE name = 'Moteur-fusée')),
((SELECT id FROM airplanes WHERE name = 'Republic XF-91 Thunderceptor'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Republic XF-91 Thunderceptor'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Republic XF-91 Thunderceptor'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.18,
  wingspan          = 9.52,
  height            = 5.52,
  wing_area         = 29.7,
  empty_weight      = 7191,
  mtow              = 12935,
  service_ceiling   = 15240,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J47-GE-7 + Reaction Motors XLR11-RM-9 (26,7 kN)',
  engine_count      = 2,
  engine_type       = 'Fusée et turboréacteur',
  engine_type_en    = 'Rocket and turbojet',
  thrust_dry        = 23.1,
  thrust_wet        = 30.7,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **46-680** : premier prototype, premier vol le 9 mai 1949, supersonique en palier en décembre 1951, exposé à Dayton\n- **46-681** : second prototype à radôme et entrée d''air sous le nez, queue détruite par un incendie en 1951\n- **Empennage papillon** : en V, monté sur le 46-681 après son incendie et essayé en vol\n- **F-91 de série** : armement prévu de quatre canons de 20 mm, de roquettes ou de missiles Falcon, jamais construit',
  variants_en       = E'- **46-680**: first prototype, first flight on 9 May 1949, supersonic in level flight in December 1951, displayed at Dayton\n- **46-681**: second prototype with a radome and chin intake, tail destroyed by fire in 1951\n- **Butterfly tail**: V-tail fitted to 46-681 after its fire and flight-tested\n- **Production F-91**: planned armament of four 20 mm cannon, rockets or Falcon missiles, never built',

  -- Strate 4 : qualitatif
  nickname          = 'Thunderceptor',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Republic_XF-91_Thunderceptor',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Republic_XF-91_Thunderceptor',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Republic XF-91 Thunderceptor';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Republic XF-91 Thunderceptor';
