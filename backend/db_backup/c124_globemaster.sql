-- Douglas C-124 Globemaster II
--
-- Photo : C-124C landing at Travis AFB 1984.JPEG
--   licence Public domain — SSgt Bob Simons, USAF
--   https://commons.wikimedia.org/wiki/File:C-124C_landing_at_Travis_AFB_1984.JPEG

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
    'Douglas C-124 Globemaster II',
    'Douglas C-124 Globemaster II',
    'Douglas C-124 Globemaster II',
    'Douglas C-124 Globemaster II',
    'Le géant à nez ouvrant qui embarquait chars et bulldozers entiers, né des leçons de Berlin',
    'The clamshell-nosed giant that swallowed whole tanks and bulldozers, born of the lessons of Berlin',
    '/assets/airplanes/c124-globemaster-2.jpg',
    E'## Genèse\nLe pont aérien de Berlin a montré ce qu''un transport lourd pouvait changer. De 1947 à 1949, Douglas développe le C-124 à partir d''un prototype tiré du **C-74 Globemaster**, un quadrimoteur conçu pendant la Seconde Guerre mondiale, en y intégrant les leçons de Berlin. Le Globemaster II vole le 27 novembre 1949 et les livraisons du **C-124A** commencent en mai 1950. Jusqu''en 1955, 448 appareils sortent de l''usine de Long Beach, en Californie.\n\n## Conception\nLe C-124 se reconnaît à son nez : deux grandes portes à coquille et une rampe hydraulique s''ouvrent sous le poste de pilotage, complétées par un monte-charge sous le fuselage arrière. Sa soute de 23 m, équipée de deux palans de 3,6 t, accueille chars, canons, camions ou bulldozers : c''est le seul avion de son temps capable de transporter un équipement lourd entièrement assemblé. Sur deux ponts, il emporte 200 soldats équipés ou 127 blessés couchés. Quatre **Pratt & Whitney R-4360 Wasp Major** à 28 cylindres, de 3 800 ch chacun, le propulsent. Le **C-124C** ajoute un radar météo APS-42 logé dans un « dé à coudre » sur le nez et des réchauffeurs en bout d''aile pour le dégivrage.\n\n## Carrière opérationnelle\nLe C-124 sert pendant la **guerre de Corée**, ravitaille l''opération Deep Freeze en Antarctique et transporte de 1959 à 1961 des missiles Thor vers l''Angleterre. Le Strategic Air Command en aligne 50 de 1950 à 1962 pour déplacer ses armes nucléaires entre bases. En 1954, il achemine des parachutistes français destinés à renforcer la garnison de **Diên Biên Phu**, puis sert largement pendant la **guerre du Vietnam** pour transporter du matériel depuis les États-Unis. Ses équipages le surnomment « Old Shaky ». Le 18 juin 1953, l''écrasement d''un C-124 à Tachikawa, au Japon, tue 129 personnes : c''est alors la pire catastrophe de l''histoire de l''aviation.\n\n## Place dans l''histoire\nPrincipal transport lourd du Military Air Transport Service jusqu''à l''arrivée du **C-141 Starlifter**, le C-124 passe à la réserve et à la Garde nationale, dont la dernière unité, en Géorgie, le retire en septembre 1974. Jusqu''à la mise en service du C-5 Galaxy, lui et son cadet le **C-133 Cargomaster** sont les seuls avions américains capables d''emporter de très grosses charges. Huit exemplaires sont aujourd''hui conservés dans des musées, sept aux États-Unis et un en Corée du Sud.',
    E'## Genesis\nThe Berlin Airlift had shown what a heavy transport could change. From 1947 to 1949 Douglas developed the C-124 from a prototype derived from the **C-74 Globemaster**, a four-engined design of the Second World War, incorporating the lessons of Berlin. The Globemaster II flew on 27 November 1949 and deliveries of the **C-124A** began in May 1950. By 1955, 448 aircraft had left the Long Beach plant in California.\n\n## Design\nThe C-124 is recognisable by its nose: two large clamshell doors and a hydraulic ramp opened beneath the flight deck, supplemented by a cargo elevator under the rear fuselage. Its 23 m hold, fitted with two 3.6-tonne overhead hoists, took tanks, guns, trucks or bulldozers: it was the only aircraft of its time able to carry fully assembled heavy equipment. On two decks it carried 200 equipped troops or 127 stretcher cases. Four 28-cylinder **Pratt & Whitney R-4360 Wasp Major** engines of 3,800 hp each powered it. The **C-124C** added an APS-42 weather radar in a thimble on the nose and wingtip combustion heaters for de-icing.\n\n## Operational career\nThe C-124 served in the **Korean War**, supplied Operation Deep Freeze in Antarctica and carried Thor missiles across the Atlantic to England from 1959 to 1961. Strategic Air Command flew 50 of them from 1950 to 1962 to move its nuclear weapons between bases. In 1954 it carried French paratroopers to reinforce the garrison of **Dien Bien Phu**, and it was used extensively in the **Vietnam War** to haul materiel from the United States. Its crews nicknamed it "Old Shaky". On 18 June 1953 a C-124 crash at Tachikawa, Japan, killed 129 people: at the time the worst accident in aviation history.\n\n## Place in history\nThe Military Air Transport Service''s primary heavy lifter until the arrival of the **C-141 Starlifter**, the C-124 passed to the Reserve and the Air National Guard, whose last unit, in Georgia, retired it in September 1974. Until the C-5 Galaxy entered service, it and its younger sibling the **C-133 Cargomaster** were the only American aircraft able to carry very large loads. Eight survive in museums today, seven in the United States and one in South Korea.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1947-01-01',
    '1949-11-27',
    '1950-05-01',
    489,
    10980,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-124 Globemaster II'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-124 Globemaster II'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-124 Globemaster II'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Douglas C-124 Globemaster II'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'Douglas C-124 Globemaster II'), (SELECT id FROM wars WHERE name = 'Guerre d''Indochine')),
((SELECT id FROM airplanes WHERE name = 'Douglas C-124 Globemaster II'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 39.75,
  wingspan          = 53.07,
  height            = 14.72,
  wing_area         = 232.8,
  empty_weight      = 45888,
  mtow              = 88224,
  service_ceiling   = 6600,
  climb_rate        = 3.9,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 7,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-4360-63A Wasp Major (3 800 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1955,
  units_built       = 448,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **YC-124** : prototype reconstruit à partir d''un C-74 avec un nouveau fuselage, remotorisé ensuite en YC-124A\n- **C-124A** : première version de série, 204 exemplaires, presque tous dotés après coup du radar de nez et des réchauffeurs\n- **YC-124B** : version à turbopropulseurs YT34, proposée comme ravitailleur et employée pour des essais\n- **C-124C** : moteurs R-4360-63A de 3 800 ch, radar APS-42, réchauffeurs en bout d''aile et carburant accru, 243 exemplaires\n- **JC-124C** : un C-124C banc d''essai du turbopropulseur Pratt & Whitney XT57, monté dans le nez',
  variants_en       = E'- **YC-124**: prototype rebuilt from a C-74 with a new fuselage, later re-engined as the YC-124A\n- **C-124A**: first production version, 204 built, most later fitted with the nose radar and heaters\n- **YC-124B**: YT34 turboprop version, proposed as a tanker and used for trials\n- **C-124C**: 3,800 hp R-4360-63A engines, APS-42 radar, wingtip heaters and more fuel, 243 built\n- **JC-124C**: one C-124C used as a testbed for the Pratt & Whitney XT57 turboprop, mounted in the nose',

  -- Strate 4 : qualitatif
  nickname          = 'Old Shaky',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_C-124_Globemaster_II',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_C-124_Globemaster_II',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'SSgt Bob Simons, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Douglas C-124 Globemaster II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Douglas C-124 Globemaster II';
