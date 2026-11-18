-- de Havilland Canada DHC-6 Twin Otter (UV-18 / CC-138)
--
-- Photo : Thunder and Lightning over Arizona Open House 2016 160312-F-ZT877-0359.jpg
--   licence Public domain — Senior Airman Chris Massey
--   https://commons.wikimedia.org/wiki/File:Thunder_and_Lightning_over_Arizona_Open_House_2016_160312-F-ZT877-0359.jpg

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
    'DHC-6 Twin Otter',
    'DHC-6 Twin Otter',
    'de Havilland Canada DHC-6 Twin Otter (UV-18 / CC-138)',
    'de Havilland Canada DHC-6 Twin Otter (UV-18 / CC-138)',
    'Le bimoteur à décollage court des parachutistes de l''US Air Force Academy, du sauvetage canadien et des forces spéciales',
    'The STOL twin of US Air Force Academy parachutists, Canadian rescue crews and special forces',
    '/assets/airplanes/dhc6-twin-otter.jpg',
    E'## Genèse\nAu début des années 1960, la turbine **Pratt & Whitney Canada PT6A** de 550 ch rend envisageable un bimoteur léger à décollage court. **de Havilland Canada** a déjà fait voler en 1963 un DHC-3 Otter de recherche dont le moteur à pistons avait été remplacé par deux PT6. Le développement du **DHC-6 Twin Otter**, successeur bimoteur de l''Otter, commence en 1964, et le premier exemplaire vole le 20 mai 1965.\n\n## Conception\nLe Twin Otter conserve les qualités de décollage court de son aîné grâce à des volets à double fente et à des ailerons qui s''abaissent avec eux. Il repose sur un train tricycle fixe, livrable d''usine avec roues, skis ou flotteurs, et emporte une vingtaine de passagers. La **série 300**, lancée en 1969 avec des PT6A-27 de 620 ch, devient de loin la plus répandue. La fiabilité de la turbine et la sécurité du bimoteur en font un remplaçant immédiat de l''Otter à pistons.\n\n## Carrière opérationnelle\nLes forces armées canadiennes l''emploient en recherche et sauvetage sous le nom de **CC-138**. Aux États-Unis, la Garde nationale de l''Alaska reçoit six **UV-18A**, et l''US Air Force Academy aligne trois **UV-18B** au 98th Flying Training Squadron : son équipe de parachutisme, les Wings of Blue, s''en sert toute l''année, l''appareil pouvant emporter 22 parachutistes à plus de 5 200 m. L''aviation argentine en déploie un en permanence à la base antarctique Marambio depuis les années 1970, l''aviation chilienne en exploite depuis 1980, et le président paraguayen **Alfredo Stroessner** en fait son avion présidentiel. En France, l''armée de l''Air en met en œuvre cinq, dont trois au profit de la DGSE et deux pour le Commandement des opérations spéciales ; l''un d''eux s''écrase dans le Sinaï en 2007 au service de la Force multinationale et observateurs, faisant neuf morts.\n\n## Place dans l''histoire\nDe Havilland Canada en construit 844 jusqu''en 1988. **Viking Air** relance la production en 2008 avec la **série 400** ; en 2017, près d''un tiers de ces nouveaux appareils volent sous les couleurs d''une armée, comme les trois **UV-18C** de l''US Army livrés en 2013. En Alaska, ce sont des **C-23 Sherpa** qui remplacent les UV-18A. Le millième Twin Otter est livré en mars 2026.',
    E'## Genesis\nIn the early 1960s the 550 hp **Pratt & Whitney Canada PT6A** turbine made a light short take-off twin feasible. **de Havilland Canada** had already flown, in 1963, a research DHC-3 Otter whose piston engine had been replaced by two PT6s. Development of the **DHC-6 Twin Otter**, the Otter''s twin-engined successor, began in 1964, and the first aircraft flew on 20 May 1965.\n\n## Design\nThe Twin Otter kept its predecessor''s short take-off qualities thanks to double-slotted flaps and ailerons that droop with them. It sits on fixed tricycle landing gear, available from the factory with wheels, skis or floats, and carries around twenty passengers. The **Series 300**, launched in 1969 with 620 hp PT6A-27s, became by far the most widespread. The reliability of turbine power and the safety of two engines made it an immediate replacement for the piston Otter.\n\n## Operational career\nThe Canadian Armed Forces used it for search and rescue as the **CC-138**. In the United States, the Alaska National Guard received six **UV-18A**s, and the US Air Force Academy flies three **UV-18B**s with the 98th Flying Training Squadron: its parachute team, the Wings of Blue, uses them year-round, the aircraft being able to lift 22 parachutists above 5,200 m. The Argentine Air Force has kept one at its Marambio Antarctic base since the 1970s, the Chilean Air Force has flown the type since 1980, and Paraguayan president **Alfredo Stroessner** used one as his presidential aircraft. In France, the Air Force operates five, three for the DGSE intelligence service and two for Special Operations Command; one crashed in the Sinai in 2007 while serving the Multinational Force and Observers, killing nine.\n\n## Place in history\nDe Havilland Canada built 844 up to 1988. **Viking Air** restarted production in 2008 with the **Series 400**; by 2017 nearly a third of these new aircraft flew in military colours, such as the US Army''s three **UV-18C**s delivered in 2013. In Alaska, **C-23 Sherpas** replaced the UV-18As. The thousandth Twin Otter was delivered in March 2026.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1964-01-01',
    '1965-05-20',
    '1966-01-01',
    337,
    1296,
    (SELECT id FROM manufacturer WHERE code = 'DHC'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-6 Twin Otter'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'DHC-6 Twin Otter'), (SELECT id FROM tech WHERE name = 'Hypersustentation ADAC'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-6 Twin Otter'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'DHC-6 Twin Otter'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.77,
  wingspan          = 19.81,
  height            = 5.94,
  wing_area         = 39,
  empty_weight      = 3363,
  mtow              = 5670,
  service_ceiling   = 7620,
  climb_rate        = 8.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-27 (620 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1965,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Séries 100 et 200** : premières versions à PT6A-20 de 550 ch ; nez allongé à partir de la série 200 (1968)\n- **Série 300** : PT6A-27 de 620 ch, version la plus produite à partir de 1969\n- **CC-138** : transport et recherche et sauvetage des forces armées canadiennes, dérivé de la série 300\n- **UV-18A / UV-18B** : six appareils pour la Garde nationale de l''Alaska ; trois avions de largage de parachutistes pour l''US Air Force Academy\n- **Série 400 / UV-18C** : production relancée par Viking Air en 2008 ; trois UV-18C livrés à l''US Army en 2013',
  variants_en       = E'- **Series 100 and 200**: first versions with 550 hp PT6A-20s; longer nose from the Series 200 (1968)\n- **Series 300**: 620 hp PT6A-27, the most-produced version from 1969\n- **CC-138**: Canadian Armed Forces transport and search and rescue aircraft, based on the Series 300\n- **UV-18A / UV-18B**: six aircraft for the Alaska National Guard; three parachute-dropping aircraft for the US Air Force Academy\n- **Series 400 / UV-18C**: production restarted by Viking Air in 2008; three UV-18Cs delivered to the US Army in 2013',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Canada_DHC-6_Twin_Otter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Canada_DHC-6_Twin_Otter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Senior Airman Chris Massey, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'DHC-6 Twin Otter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'DHC-6 Twin Otter';
