-- Vought XF8U-3 Crusader III
--
-- Photo : Vought F8U-3 Crusader III taxiing in 1958.jpeg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Vought_F8U-3_Crusader_III_taxiing_in_1958.jpeg

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
    'Vought XF8U-3 Crusader III',
    'Vought XF8U-3 Crusader III',
    'Vought XF8U-3 Crusader III',
    'Vought XF8U-3 Crusader III',
    'Crusader agrandi à Mach 2, plus agile que le Phantom II mais battu par lui pour la défense de la flotte',
    'An enlarged Mach 2 Crusader, more agile than the Phantom II but beaten by it for the fleet defence role',
    '/assets/airplanes/xf8u3-crusader-3.jpg',
    E'## Genèse\nParallèlement aux F8U-1 et F8U-2 Crusader, l''équipe de **Chance Vought** étudie un appareil plus grand et plus performant, le **V-401**. En décembre 1955, l''US Navy ouvre un concours pour un intercepteur de défense de la flotte capable de dépasser Mach 2 : le V-401 y devient le **XF8U-3**. Comme le F8U-2 était déjà surnommé « Crusader II », le nouvel avion reçoit officiellement le nom de **Crusader III**. Malgré la parenté de désignation et de silhouette, il ne partage que peu de pièces avec ses aînés.\n\n## Conception\nIl reprend du Crusader l''**aile à incidence variable**, mais il est plus grand et propulsé par un **Pratt & Whitney J75-P-5A** de 131 kN avec postcombustion. Conçu pour de brèves pointes à Mach 2,7, il se distingue par une entrée d''air « Ferri » en flèche inversée, qui ralentit l''air par trois ondes de choc, et par deux grandes dérives ventrales, rabattues à l''horizontale au décollage et à l''atterrissage. Vought prévoit même un moteur-fusée d''appoint Rocketdyne XLF-40 de 35,6 kN. L''avionique comprend un calculateur de tir AN/AWG-7 et une liaison de données AN/ASQ-19 ; le système doit suivre six cibles et en engager deux, avec des **AIM-7 Sparrow** et des **AIM-9 Sidewinder**.\n\n## Essais\nLe XF8U-3 vole le 2 juin 1958 et dépasse Mach 2 en palier le 14 août, à son 38e vol, bien avant son rival le **F4H-1 Phantom II**. Sa vitesse maximale démontrée est de Mach 2,39, loin des Mach 2,6 souvent cités. Face au Phantom, il se montre nettement plus maniable : son chef pilote d''essai, **John Konrad**, dira qu''il pouvait tourner en rond autour de son concurrent. Mais un pilote seul peine à mener l''interception et à guider les Sparrow, quand le Phantom embarque un officier radar ; sa charge utile bien supérieure et sa capacité air-sol emportent la décision.\n\n## Place dans l''histoire\nLe programme est annulé après cinq exemplaires, dont trois ont volé. Tous passent à la **NASA** pour des essais atmosphériques, l''avion pouvant monter au-dessus de 95 % de l''atmosphère terrestre. À Patuxent River, les pilotes de la NASA interceptent et battent régulièrement les Phantom de la marine en combat simulé, jusqu''à ce que les plaintes de l''US Navy mettent fin à ce harcèlement. Tous les Crusader III sont ensuite ferraillés ; le Phantom, lui, remplacera même le F-8 Crusader comme chasseur de supériorité aérienne de la marine au Vietnam.',
    E'## Genesis\nAlongside the F8U-1 and F8U-2 Crusader, the **Chance Vought** team was working on a larger, higher-performance aircraft, the **V-401**. In December 1955 the US Navy opened a competition for a Mach 2+ fleet defence interceptor, and the V-401 became the **XF8U-3**. Since the F8U-2 was already labelled ''Crusader II'', the new aircraft was officially named **Crusader III**. Despite the shared designation and outline, it had few parts in common with its forebears.\n\n## Design\nIt kept the Crusader''s **variable-incidence wing**, but was larger and powered by a **Pratt & Whitney J75-P-5A** giving 131 kN with afterburner. Designed for brief dashes to Mach 2.7, it stood out with a swept-forward ''Ferri'' intake, slowing the air through three shock waves, and two large ventral fins that folded to the horizontal for take-off and landing. Vought even provided for a 35.6 kN Rocketdyne XLF-40 booster rocket. Avionics included an AN/AWG-7 fire control computer and an AN/ASQ-19 datalink; the system was to track six targets and engage two, with **AIM-7 Sparrow** and **AIM-9 Sidewinder** missiles.\n\n## Testing\nThe XF8U-3 flew on 2 June 1958 and exceeded Mach 2 in level flight on 14 August, on its 38th flight, well before its rival the **F4H-1 Phantom II**. Its maximum demonstrated speed was Mach 2.39, well short of the Mach 2.6 often quoted. Against the Phantom it proved clearly more manoeuvrable: chief test pilot **John Konrad** later said it could fly circles around its competitor. But a lone pilot struggled to run the intercept and guide the Sparrows, whereas the Phantom carried a radar intercept officer; its much larger payload and air-to-ground capability won the day.\n\n## Place in history\nThe programme was cancelled with five aircraft built, three of which flew. All went to **NASA** for atmospheric testing, as the aircraft could climb above 95% of the Earth''s atmosphere. At Patuxent River, NASA pilots routinely intercepted and beat Navy Phantoms in mock dogfights, until Navy complaints put an end to the harassment. All the Crusader IIIs were later scrapped; the Phantom, for its part, would even replace the F-8 Crusader as the Navy''s air superiority fighter over Vietnam.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1955-12-01',
    '1958-06-02',
    NULL,
    2538,
    3290,
    (SELECT id FROM manufacturer WHERE code = 'VOU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Vought XF8U-3 Crusader III'), (SELECT id FROM tech WHERE name = 'Aile à incidence variable')),
((SELECT id FROM airplanes WHERE name = 'Vought XF8U-3 Crusader III'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Vought XF8U-3 Crusader III'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Vought XF8U-3 Crusader III'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Vought XF8U-3 Crusader III'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'Vought XF8U-3 Crusader III'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Vought XF8U-3 Crusader III'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Vought XF8U-3 Crusader III'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.88,
  wingspan          = 12.16,
  height            = 4.98,
  wing_area         = 41.8,
  empty_weight      = 9915,
  mtow              = 17590,
  service_ceiling   = 19800,
  climb_rate        = 165,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J75-P-5A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 73.4,
  thrust_wet        = 131.2,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **V-401** : désignation interne de l''étude chez Chance Vought\n- **XF8U-3 Crusader III** : cinq exemplaires construits, trois ont volé pendant les essais de l''US Navy\n- **Version à moteur-fusée** : provision pour un Rocketdyne XLF-40 d''appoint, pour viser Mach 2,9 selon certaines sources, jamais montée\n- **Crusader III de la NASA** : les cinq cellules, transférées à la NASA pour des essais atmosphériques à haute altitude',
  variants_en       = E'- **V-401**: Chance Vought''s internal study designation\n- **XF8U-3 Crusader III**: five built, three flown during the US Navy trials\n- **Rocket-boosted version**: provision for a Rocketdyne XLF-40 booster, aiming at Mach 2.9 according to some sources, never fitted\n- **NASA Crusader IIIs**: all five airframes, transferred to NASA for high-altitude atmospheric testing',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Vought_XF8U-3_Crusader_III',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Vought_XF8U-3_Crusader_III',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Vought XF8U-3 Crusader III';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Vought XF8U-3 Crusader III';
