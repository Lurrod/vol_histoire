-- Mikoyan-Gourevitch Ye-152
--
-- Photo : Ye-166.jpg
--   licence CC BY-SA 3.0 — Mike1979 Russia
--   https://commons.wikimedia.org/wiki/File:Ye-166.jpg

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
    'Ye-152',
    'Ye-152',
    'Mikoyan-Gourevitch Ye-152',
    'Mikoyan-Gurevich Ye-152',
    'Intercepteur lourd expérimental à Mach 2,85, recordman du monde sous le faux nom de Ye-166',
    'A Mach 2.85 experimental heavy interceptor that set world records under the false name Ye-166',
    '/assets/airplanes/ye152.jpg',
    E'## Genèse\nAu milieu des années 1950, la défense aérienne soviétique, la **PVO**, réclame un intercepteur lourd capable d''interceptions automatiques. Le système **Uragan-5**, lancé en 1955, doit guider depuis le sol un chasseur vers des bombardiers supersoniques volant entre 10 000 et 25 000 m à 1 600-2 000 km/h, jusqu''à 120 km de sa base. Après les I-3, I-7 et I-75, le bureau **Mikoyan-Gourevitch** développe pour cela la famille **Ye-150**, d''énormes chasseurs pour l''époque : le Ye-150 pèse 12 345 kg et mesure 18,14 m, contre 4 819 kg et 15,76 m pour le MiG-21F. Il doit emporter des missiles K-6, K-7, K-8 ou K-9, des roquettes ou une paire de canons orientables.\n\n## Conception\nLe **Ye-152** reprend la formule du Ye-150, une aile delta et un unique gros réacteur **Tumansky R-15**, ici dans sa version améliorée **R-15-300** de 99,6 kN avec postcombustion. Il conserve l''entrée d''air allongée étudiée pour le Ye-151 à canons, qui s''était révélée meilleure en soufflerie. Ses ailes delta tronquées, de plus grande surface, portent en bout d''aile des rampes pour les gros missiles **K-80** ou **K-9**. Deux exemplaires sont construits, le Ye-152-1 et le Ye-152-2.\n\n## Essais\nLe Ye-152 vole pour la première fois le 21 avril 1961. Le R-15-300 reste peu fiable, si bien que les essais en vol, les essais du système d''armes et les vols de record restent limités ; le premier prototype bat néanmoins des records du monde en 1961 et 1962, homologués par la FAI sous la fausse désignation de **Ye-166**. Le second devient le **Ye-152M**, avec une tuyère convergente-divergente axisymétrique et des plans canard bientôt retirés. La faiblesse du moteur et l''abandon du système K-9 / Uragan-5B mettent fin au programme, l''Uragan-5 étant annulé en 1962.\n\n## Place dans l''histoire\nAvec 3 030 km/h, soit Mach 2,85, et un plafond de 22 680 m, le Ye-152 a montré ce que pouvait atteindre un intercepteur soviétique au tournant des années 1960. Son cousin biréacteur, le **Ye-152A**, servit ensuite de laboratoire volant pour les équipements du futur **MiG-25**. Le Ye-152M est exposé à Monino sous le nom trompeur de Ye-166, avec trois étoiles rouges rappelant les records de son frère.',
    E'## Genesis\nIn the mid-1950s the Soviet air defence force, the **PVO**, wanted a heavy interceptor capable of automatic interceptions. The **Uragan-5** system, launched in 1955, was to guide a fighter from the ground towards supersonic bombers flying at 10,000 to 25,000 m and 1,600 to 2,000 km/h, up to 120 km from its base. After the I-3, I-7 and I-75, the **Mikoyan-Gurevich** bureau developed the **Ye-150** family for the task, huge fighters for the time: the Ye-150 weighed 12,345 kg and was 18.14 m long, against 4,819 kg and 15.76 m for the MiG-21F. It was to carry K-6, K-7, K-8 or K-9 missiles, rockets or a pair of aimable cannon.\n\n## Design\nThe **Ye-152** kept the Ye-150''s layout, a delta wing and a single large **Tumansky R-15**, here in its improved **R-15-300** version giving 99.6 kN with afterburner. It retained the lengthened intake studied for the cannon-armed Ye-151, which had proved better in the wind tunnel. Its cropped delta wings, of greater area, carried wingtip launchers for the large **K-80** or **K-9** missiles. Two were built, the Ye-152-1 and Ye-152-2.\n\n## Testing\nThe Ye-152 first flew on 21 April 1961. The R-15-300 remained unreliable, so development flying, weapons system testing and record flights were limited; even so, the first prototype set world records in 1961 and 1962, registered with the FAI under the false designation **Ye-166**. The second became the **Ye-152M**, with an axisymmetric convergent-divergent nozzle and canards that were soon removed. The poor engine and the cancellation of the K-9 / Uragan-5B system ended the programme, Uragan-5 itself being cancelled in 1962.\n\n## Place in history\nWith 3,030 km/h, or Mach 2.85, and a ceiling of 22,680 m, the Ye-152 showed what a Soviet interceptor could reach at the turn of the 1960s. Its twin-engined cousin, the **Ye-152A**, later served as a flying laboratory for the equipment of the future **MiG-25**. The Ye-152M is displayed at Monino under the misleading name Ye-166, with three red stars recalling its sister ship''s records.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1955-01-01',
    '1961-04-21',
    NULL,
    3030,
    1470,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Ye-152'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Ye-152'), (SELECT id FROM tech WHERE name = 'Moteurs Tumansky R-15')),
((SELECT id FROM airplanes WHERE name = 'Ye-152'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Ye-152'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.66,
  wingspan          = 8.79,
  height            = NULL,
  wing_area         = 40.02,
  empty_weight      = 10900,
  mtow              = 14350,
  service_ceiling   = 22680,
  climb_rate        = 62.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Tumansky R-15-300',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 66.7,
  thrust_wet        = 99.6,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Ye-150** : premier de la famille, armé de missiles, premier vol le 8 juillet 1960, 42 vols d''essais constructeur\n- **Ye-151** : version à deux canons orientables en tourelle, étudiée en soufflerie, jamais construite\n- **Ye-152-1** : premier prototype, records du monde de 1961 et 1962 homologués sous le nom de Ye-166\n- **Ye-152M** : Ye-152-2 modifié, tuyère convergente-divergente et plans canard vite retirés, exposé à Monino\n- **Ye-152A** : biréacteur à deux Tumansky R-11, premier vol le 10 juillet 1959, baptisé « Flipper » par l''OTAN',
  variants_en       = E'- **Ye-150**: first of the family, missile-armed, first flight on 8 July 1960, 42 manufacturer''s test flights\n- **Ye-151**: version with two aimable cannon in a turret, wind tunnel tested, never built\n- **Ye-152-1**: first prototype, 1961 and 1962 world records registered as the Ye-166\n- **Ye-152M**: modified Ye-152-2, convergent-divergent nozzle and short-lived canards, displayed at Monino\n- **Ye-152A**: twin-engined version with two Tumansky R-11s, first flight on 10 July 1959, NATO name ''Flipper''',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_Ye-150',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mikoyan-Gurevich_Ye-150_family',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mike1979 Russia',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Ye-152';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Ye-152';
