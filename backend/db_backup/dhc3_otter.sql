-- de Havilland Canada DHC-3 Otter (U-1A / CSR-123)
--
-- Photo : U-1B Otter of Naval Test Pilot School at NAS Patuxent River 1983.JPEG
--   licence Public domain — Don S. Montgomery, USN
--   https://commons.wikimedia.org/wiki/File:U-1B_Otter_of_Naval_Test_Pilot_School_at_NAS_Patuxent_River_1983.JPEG

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
    'DHC-3 Otter',
    'DHC-3 Otter',
    'de Havilland Canada DHC-3 Otter (U-1A / CSR-123)',
    'de Havilland Canada DHC-3 Otter (U-1A / CSR-123)',
    'Le « camion d''une tonne » de la brousse, dont l''US Army fut le premier client avec 184 U-1A',
    'The bush''s one-ton truck, whose largest customer was the US Army with 184 U-1As',
    '/assets/airplanes/dhc3-otter.jpg',
    E'## Genèse\nEn janvier 1951, **de Havilland Canada** lance l''étude d''une version agrandie et plus puissante de son **DHC-2 Beaver**, capable des mêmes missions mais avec une charge double. Surnommé « King Beaver » pendant sa conception, l''appareil doit être le « camion d''une tonne » quand le Beaver est celui d''une demi-tonne. Le **DHC-3 Otter** vole le 12 décembre 1951, reçoit sa certification canadienne en novembre 1952 et entre en production aussitôt après.\n\n## Conception\nL''Otter reprend la formule du Beaver — monomoteur à aile haute contreventée, train classique — avec un fuselage plus long, une aile de plus grande envergure et un empennage cruciforme. Son moteur en étoile **Pratt & Whitney R-1340 Wasp** de 600 ch, réducté pour faire tourner l''hélice plus lentement, emporte dix à onze passagers, ou six civières et quatre sièges. Il peut recevoir des roues, des skis ou des flotteurs amphibies. En 1956, deux Otter militaires se disloquent en vol : un volet rentré brutalement sur un empennage encore compensé a provoqué un piqué fatal, et l''on ajoute un filtre hydraulique et une liaison entre volets et plan horizontal.\n\n## Carrière opérationnelle\nL''**US Army** devient le plus gros utilisateur de l''appareil, avec 184 **U-1A** livrés, et l''US Navy reçoit des **UC-1**, rebaptisés U-1B en 1962 ; l''un d''eux, devenu NU-1B, sert à l''école des pilotes d''essai de Patuxent River et reste le plus ancien appareil en service dans la Navy. Au Canada, les **CSR-123** volent en recherche et sauvetage et en transport léger jusqu''en 1980, larguant aussi du ravitaillement aux troupes en manœuvre. Début 1957, le porte-avions **HMCS Magnificent** emmène quatre Otter à Port-Saïd pour la Force d''urgence des Nations unies : ils décollent seuls du pont, navire au mouillage, seule occasion où des avions de l''aviation canadienne ont opéré depuis un navire canadien. Une vingtaine d''autres armées de l''air l''adoptent, de l''Australie au Ghana.\n\n## Place dans l''histoire\nCrédité d''une traversée du pôle Sud en 1957, l''Otter sert aussi de banc d''essai : l''Otter 3682 de l''aviation canadienne, transformé en « Batwing Otter », étudie le décollage court, puis vole en mai 1963 avec deux turbines PT6 sur l''aile, préfigurant le **DHC-6 Twin Otter**. Construit à 466 exemplaires, militaires et civils confondus, il reste en service dans la brousse, souvent converti à la turbine.',
    E'## Genesis\nIn January 1951 **de Havilland Canada** began work on a larger, more powerful version of its **DHC-2 Beaver**, able to fly the same missions with twice the load. Nicknamed the ''King Beaver'' during design, it was to be the ''one-ton truck'' to the Beaver''s half-ton. The **DHC-3 Otter** flew on 12 December 1951, received Canadian certification in November 1952 and entered production shortly afterwards.\n\n## Design\nThe Otter kept the Beaver''s formula — a strut-braced high-wing single with tailwheel landing gear — with a longer fuselage, a greater-span wing and a cruciform tail. Its 600 hp **Pratt & Whitney R-1340 Wasp** radial, geared to turn the propeller more slowly, carried ten or eleven passengers, or six stretchers and four seats. It could be fitted with wheels, skis or amphibious floats. In 1956 two military Otters broke up in flight: flaps retracting abruptly with the tailplane still fully trimmed caused a fatal nose drop, and a hydraulic filter and a flap-to-tailplane interconnection were added.\n\n## Operational career\nThe **US Army** became the largest operator, with 184 **U-1A**s delivered, and the US Navy received **UC-1**s, redesignated U-1B in 1962; one of them, as an NU-1B, served with the Naval Test Pilot School at Patuxent River and remained the oldest aircraft in Navy service. In Canada, **CSR-123**s flew search and rescue and light transport until 1980, also dropping supplies to troops on manoeuvres. In early 1957 the carrier **HMCS Magnificent** carried four Otters to Port Said for the United Nations Emergency Force: they flew off unassisted with the ship at anchor, the only time RCAF fixed-wing aircraft operated from a Canadian warship. Some twenty other air arms adopted it, from Australia to Ghana.\n\n## Place in history\nAn Otter crossed the South Pole in 1957, and the type also served as a testbed: RCAF Otter 3682, turned into the ''Batwing Otter'', explored short take-off, then flew in May 1963 with two PT6 turbines on the wing, foreshadowing the **DHC-6 Twin Otter**. Built in 466 examples, military and civil combined, it remains in service in the bush, often converted to turbine power.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1951-01-01',
    '1951-12-12',
    '1953-01-01',
    260,
    1540,
    (SELECT id FROM manufacturer WHERE code = 'DHC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-3 Otter'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-3 Otter'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'DHC-3 Otter'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.75,
  wingspan          = 17.68,
  height            = 3.84,
  wing_area         = 34.8,
  empty_weight      = 1863,
  mtow              = 3629,
  service_ceiling   = 5700,
  climb_rate        = 3.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-1340-S1H1-G Wasp (600 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1967,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 22,
  variants          = E'- **YU-1** : six appareils d''évaluation pour l''US Army\n- **U-1A** : transport utilitaire de l''US Army, 184 livrés\n- **UC-1 / U-1B** : version de l''US Navy, rebaptisée en 1962 ; un NU-1B à l''école des pilotes d''essai de Patuxent River\n- **CC-123 / CSR-123** : transport et recherche et sauvetage de l''aviation canadienne\n- **Batwing Otter** : Otter 3682 de l''aviation canadienne, banc d''essai du décollage court puis bimoteur PT6 en 1963',
  variants_en       = E'- **YU-1**: six evaluation aircraft for the US Army\n- **U-1A**: US Army utility transport, 184 delivered\n- **UC-1 / U-1B**: US Navy version, redesignated in 1962; one NU-1B with the Naval Test Pilot School at Patuxent River\n- **CC-123 / CSR-123**: RCAF transport and search and rescue version\n- **Batwing Otter**: RCAF Otter 3682, STOL testbed and later twin-PT6 configuration in 1963',

  -- Strate 4 : qualitatif
  nickname          = 'King Beaver',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Canada_DHC-3_Otter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Canada_DHC-3_Otter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Don S. Montgomery, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'DHC-3 Otter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'DHC-3 Otter';
