-- Beechcraft U-21 Ute
--
-- Photo : Beechcraft King Air U-21 Ute (52464779014).jpg
--   licence CC BY 2.0 — Eric Friedebach
--   https://commons.wikimedia.org/wiki/File:Beechcraft_King_Air_U-21_Ute_(52464779014).jpg

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
    'Beechcraft U-21 Ute',
    'Beechcraft U-21 Ute',
    'Beechcraft U-21 Ute',
    'Beechcraft U-21 Ute',
    'Bimoteur utilitaire de l''US Army, prototype du King Air devenu oreille électronique au Vietnam',
    'US Army utility twin, forerunner of the King Air turned electronic ear over Vietnam',
    '/assets/airplanes/beechcraft-u21-ute.jpg',
    E'## Genèse\nEn 1963, Beechcraft monte deux turbopropulseurs Pratt & Whitney Canada PT6A de 500 ch sur un bimoteur à pistons **Queen Air** : ce Model 87 doit démontrer le futur **King Air**. L''US Army le prend sous les désignations successives L-23G, NU-8F puis YU-21 et, fidèle à sa tradition, le baptise du nom d''un peuple amérindien, les **Utes**. Le prototype vole le **15 mai 1963** et passe trois mois d''évaluation à Fort Rucker en 1964. En octobre 1966, l''Army commande la version de série, le **U-21A**.\n\n## Conception\nLe U-21A garde le fuselage non pressurisé du Queen Air, mais reçoit l''aile, l''empennage et le train du King Air, deux PT6A-20 de 550 ch, des hublots carrés et une large porte de fret. Sa cabine modulable transporte dix soldats, six passagers d''état-major, trois blessés couchés ou 1 360 kg de fret. Très vite, l''Army en fait aussi une plate-forme de **renseignement électromagnétique** : radiogoniométrie, interception et brouillage. Le RU-21D est le premier appareil équipé d''une centrale de navigation inertielle, et le système **Guardrail**, mis au point à partir de 1971, est servi à distance par des techniciens au sol plutôt que par des opérateurs à bord.\n\n## Carrière opérationnelle\nLes livraisons commencent le 16 mai 1967. Au **Vietnam**, au moins cinq EU-21A relaient les transmissions de la 1re brigade des transmissions ; un JU-21A d''écoute est abattu au-dessus du Nord-Vietnam le 16 février 1973 avec ses cinq hommes, seul U-21 perdu sous le feu ennemi pendant la guerre. Le U-21F, dérivé du King Air A100, devient en 1971 le premier avion pressurisé de l''Army. À partir de 1984, les RU-21 cèdent la place aux RC-12 Guardrail ; l''Army vend 124 U-21 à Dynamic Aviation en 1996, et le dernier, le JU-21H 70-15888, est retiré le 4 janvier 2000.\n\n## Place dans l''histoire\nLe U-21 a servi de banc d''essai à l''une des familles d''avions d''affaires les plus répandues, le King Air, dont dérive ensuite le **C-12 Huron** qui lui succède dans l''Army. Il a surtout fait entrer le renseignement électronique dans la petite aviation : en confiant l''écoute du champ de bataille à des bimoteurs légers, puis à des opérateurs restés au sol, il a ouvert la voie que poursuivent ses successeurs, les RC-12 Guardrail.',
    E'## Genesis\nIn 1963 Beechcraft fitted two 500 shp Pratt & Whitney Canada PT6A turboprops to a piston-engined **Queen Air** twin: this Model 87 was to prove the future **King Air**. The US Army took it on under the successive designations L-23G, NU-8F and then YU-21 and, true to its tradition, named it after a Native American people, the **Utes**. The prototype flew on **15 May 1963** and underwent a three-month evaluation at Fort Rucker in 1964. In October 1966 the Army ordered the production version, the **U-21A**.\n\n## Design\nThe U-21A kept the unpressurised fuselage of the Queen Air but received the wing, tail and undercarriage of the King Air, two 550 shp PT6A-20 engines, square windows and a large cargo door. Its adaptable cabin carried ten troops, six staff passengers, three stretcher patients or 1,360 kg of freight. The Army soon also turned it into a **signals intelligence** platform: direction finding, intercept and jamming. The RU-21D was the first aircraft fitted with an inertial navigation system, and the **Guardrail** system, developed from 1971, was operated remotely by technicians on the ground rather than by operators on board.\n\n## Operational career\nDeliveries began on 16 May 1967. In **Vietnam**, at least five EU-21As relayed communications for the 1st Signal Brigade; a JU-21A intelligence aircraft was shot down over North Vietnam on 16 February 1973 with its five-man crew, the only U-21 lost to enemy fire during the war. The U-21F, derived from the King Air A100, became the Army''s first pressurised aircraft in 1971. From 1984 the RU-21s gave way to RC-12 Guardrails; the Army sold 124 U-21s to Dynamic Aviation in 1996, and the last one, JU-21H 70-15888, was retired on 4 January 2000.\n\n## Place in history\nThe U-21 served as the test bed for one of the most widespread families of business aircraft, the King Air, from which came the **C-12 Huron** that succeeded it in the Army. Above all, it brought electronic intelligence into light aviation: by entrusting battlefield listening to light twins, and then to operators who stayed on the ground, it opened the path followed by its successors, the RC-12 Guardrails.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1963-01-01',
    '1963-05-15',
    '1967-05-16',
    426,
    2697,
    (SELECT id FROM manufacturer WHERE code = 'BEE'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft U-21 Ute'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Beechcraft U-21 Ute'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'Beechcraft U-21 Ute'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft U-21 Ute'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Beechcraft U-21 Ute'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Beechcraft U-21 Ute'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft U-21 Ute'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.82,
  wingspan          = 13.98,
  height            = 4.33,
  wing_area         = 25.98,
  empty_weight      = 2464,
  mtow              = 4377,
  service_ceiling   = 7970,
  climb_rate        = 10.97,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada T74-CP-700 (PT6A-20) (550 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1966,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **NU-8F / YU-21** : prototype dérivé du Queen Air, premier vol le 15 mai 1963, démonstrateur du King Air\n- **U-21A / U-21G** : version utilitaire non pressurisée de série (141 Model 65-A90-1 construits, toutes versions comprises)\n- **RU-21A à RU-21E** : radiogoniométrie, interception et brouillage (systèmes Cefirm Leader, Laffing Eagle, Left Foot)\n- **RU-21H** : 21 appareils convertis au système d''écoute Guardrail V, servi à distance depuis le sol\n- **U-21F** : cinq King Air A100 pressurisés de série, premier avion pressurisé de l''US Army en 1971',
  variants_en       = E'- **NU-8F / YU-21**: Queen Air-derived prototype, first flight on 15 May 1963, King Air proof of concept\n- **U-21A / U-21G**: unpressurised production utility version (141 Model 65-A90-1s built, all versions included)\n- **RU-21A to RU-21E**: direction finding, intercept and jamming (Cefirm Leader, Laffing Eagle, Left Foot systems)\n- **RU-21H**: 21 aircraft converted to the Guardrail V signals intelligence system, operated remotely from the ground\n- **U-21F**: five production pressurised King Air A100s, the US Army''s first pressurised aircraft in 1971',

  -- Strate 4 : qualitatif
  nickname          = 'Ute',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beechcraft_U-21_Ute',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beechcraft_U-21_Ute',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Eric Friedebach',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Beechcraft U-21 Ute';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beechcraft U-21 Ute';
