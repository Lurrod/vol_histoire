-- KAI KT-1 Woongbi
--
-- Photo : Demonstration Flight of ROKAF New Light Trainer KT-1 'Woongbi'.jpg
--   licence CC BY-SA 2.0 — Doo Ho Kim
--   https://commons.wikimedia.org/wiki/File%3ADemonstration_Flight_of_ROKAF_New_Light_Trainer_KT-1_%27Woongbi%27.jpg

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
    'KAI KT-1 Woongbi',
    'KAI KT-1 Woongbi',
    'KAI KT-1 Woongbi',
    'KAI KT-1 Woongbi',
    'Premier appareil entièrement conçu en Corée du Sud',
    'The first aircraft designed entirely in South Korea',
    '/assets/airplanes/kt1-woongbi.jpg',
    E'## Genèse\nEn 1988, la Corée du Sud assemble sous licence des F-16 et des hélicoptères, mais n''a jamais rien **conçu**. L''Agence pour le développement de la défense lance alors un programme volontairement modeste : un avion-école à turbopropulseur, dont l''enjeu n''est pas l''appareil lui-même mais l''apprentissage de la conception.\n\n## Conception\nDeux places en tandem, un PT6 de neuf cent cinquante chevaux, une verrière haute et une aile contrainte à sept g. Rien d''original : la formule est celle du **Pilatus PC-9** et de l''**Embraer Tucano**, délibérément. L''objectif est de faire un appareil sûr, exportable, et surtout de traverser en entier le cycle conception-essais-certification pour la première fois.\n\n## Carrière opérationnelle\nEnviron cent quatre-vingts exemplaires. Il forme les pilotes coréens depuis 2000, et il est exporté vers l''**Indonésie**, la **Turquie**, le **Pérou** et le **Sénégal**. Sa version armée KA-1 sert de contrôleur aérien avancé le long de la zone démilitarisée.\n\n## Place dans l''histoire\nCent quatre-vingts exemplaires. Le KT-1 est **le premier avion entièrement conçu en Corée du Sud**, et la première marche d''une progression méthodique : école à hélice, puis école supersonique (**T-50**), puis chasseur léger (**FA-50**), puis chasseur de génération 4,5 (**KF-21**). Trente-cinq ans pour parcourir ce que d''autres n''ont jamais commencé.',
    E'## Genesis\nIn 1988 South Korea assembled F-16s and helicopters under licence but had never **designed** anything. The Agency for Defense Development then launched a deliberately modest programme: a turboprop trainer whose point was not the aircraft itself but learning how to design.\n\n## Design\nTwo seats in tandem, a nine-hundred-and-fifty-horsepower PT6, a high canopy and a wing stressed to seven g. Nothing original: the formula is the **Pilatus PC-9**''s and the **Embraer Tucano**''s, deliberately. The aim is a safe, exportable aircraft, and above all to go through the whole design-test-certification cycle for the first time.\n\n## Operational career\nSome one hundred and eighty built. It has trained Korean pilots since 2000 and has been exported to **Indonesia**, **Turkey**, **Peru** and **Senegal**. Its armed KA-1 version serves as a forward air controller along the demilitarised zone.\n\n## Place in history\nOne hundred and eighty built. The KT-1 is **the first aircraft designed entirely in South Korea**, and the first step of a methodical progression: propeller trainer, then supersonic trainer (**T-50**), then light fighter (**FA-50**), then generation 4.5 fighter (**KF-21**). Thirty-five years to travel a road others never started.',
    (SELECT id FROM countries WHERE code = 'ROK'),
    '1988-01-01',
    '1991-12-12',
    '2000-08-01',
    574.0,
    1333.0,
    (SELECT id FROM manufacturer WHERE code = 'KAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI KT-1 Woongbi'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI KT-1 Woongbi'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI KT-1 Woongbi'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'KAI KT-1 Woongbi'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'KAI KT-1 Woongbi'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.26,
  wingspan          = 10.6,
  height            = 3.68,
  wing_area         = 16.01,
  empty_weight      = 1910,
  mtow              = 3311,
  service_ceiling   = 11580,
  climb_rate        = 17.8,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.5,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-62',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1998,
  production_end    = NULL,
  units_built       = 180,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **KT-1** : version d''entraînement de base, la plus répandue\n- **KA-1** : version armée de contrôle aérien avancé et d''appui léger\n- **KT-1B / KT-1T / KT-1P** : versions export **Indonésie**, **Turquie**, **Pérou**\n- *Woongbi* signifie « **vol du grand oiseau** » en coréen\n- Monture de la patrouille acrobatique **Black Eagles** de 2002 à 2009',
  variants_en       = E'- **KT-1** : basic training version, the most widespread\n- **KA-1** : armed forward air control and light attack version\n- **KT-1B / KT-1T / KT-1P** : export versions for **Indonesia**, **Turkey**, **Peru**\n- *Woongbi* means ''**flight of the great bird**'' in Korean\n- Mount of the **Black Eagles** display team from 2002 to 2009',

  -- Strate 4 : qualitatif
  nickname          = 'Woongbi',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/KAI_KT-1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/KAI_KT-1_Woongbi',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Doo Ho Kim',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'KAI KT-1 Woongbi';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'KAI KT-1 Woongbi';
