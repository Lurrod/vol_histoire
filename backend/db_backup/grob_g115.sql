-- Grob G 115E Tutor
--
-- Photo : Grob G 115E EA.JPG
--   licence CC BY-SA 3.0 — James Humphreys - SalopianJames
--   https://commons.wikimedia.org/wiki/File:Grob_G_115E_EA.JPG

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
    'Grob G 115',
    'Grob G 115',
    'Grob G 115E Tutor',
    'Grob G 115E Tutor',
    'Biplace d''école en composite, le Tutor qui fait voler les cadets et les étudiants de la RAF depuis 1999',
    'Composite two-seat trainer, the Tutor that has flown RAF cadets and university students since 1999',
    '/assets/airplanes/grob-g115-tutor.jpg',
    E'## Genèse\nLe **Grob G 115** est un biplace d''aviation générale construit en Allemagne par **Grob Aircraft** et destiné avant tout à l''école de pilotage ; il vole pour la première fois en novembre 1985. Les premiers G 115 et G 115A, à dérive droite, vont surtout aux aéroclubs allemands et britanniques. Sa carrière militaire commence avec le retrait du **Scottish Aviation Bulldog** des escadrons universitaires (UAS) et des vols de découverte des cadets (AEF) de la **Royal Air Force**. Le ministère de la Défense retient alors une formule nouvelle : des avions possédés et exploités par l''industrie privée, sous contrat avec l''État. Son choix se porte sur le **G 115E**, désigné **Tutor T1**, mis en service en 1999.\n\n## Conception\nLa cellule est en matériaux composites carbone ; le fuselage et chaque longeron d''aile sont d''une seule pièce. Le train tricycle fixe en acier à ressort porte des carénages de roues, et le nez court abrite un quatre-cylindres à plat **Lycoming AEIO-360** de 180 ch entraînant une hélice tripale à pas variable. Sous une large verrière, les deux sièges côte à côte sont fixes : la position du pilote se règle avec des coussins et le palonnier. Limité à +6 g et −3 g, le Tutor permet la voltige de base ; son circuit d''huile inversé a été redessiné pour mieux lubrifier le moteur en voltige.\n\n## Carrière opérationnelle\nLes Tutor de la RAF appartiennent à **Babcock International**, dans le cadre d''un financement privé, et portent des immatriculations civiles britanniques avec une livrée blanche à bandes bleues et des cocardes militaires. Ils assurent la formation élémentaire des pilotes de la RAF, de la Royal Navy et de l''Army Air Corps à Cranwell et Barkston Heath, jusqu''à l''arrivée en 2018 du **Grob G120TP Prefect** ; la Royal Navy garde cinq Tutor pour la sélection de ses élèves pilotes à Yeovilton. Les vols de découverte des cadets l''adoptent au tournant du siècle, le dernier en 2001. Le 11 février 2009, deux Tutor partis de St Athan entrent en collision : un pilote et une cadette meurent dans chacun des deux avions.\n\n## Place dans l''histoire\nAvec 89 appareils, la RAF est le premier utilisateur militaire du G 115, devant l''**armée de l''air égyptienne** et ses 74 exemplaires. La **Finlande** en a acheté 28 sur les stocks britanniques, et les Émirats arabes unis, le Kenya et le Bangladesh en ont aussi mis en ligne. Promis au remplacement par le Prefect, plus avancé, le Tutor assure encore en 2020 une partie de la formation élémentaire de la RAF.',
    E'## Genesis\nThe **Grob G 115** is a general aviation two-seater built in Germany by **Grob Aircraft** and intended above all for flight training; it first flew in November 1985. The early G 115 and G 115A, with an upright fin, went mainly to German and British flying clubs. Its military career began with the retirement of the **Scottish Aviation Bulldog** from the University Air Squadrons (UAS) and Air Experience Flights (AEF) of the **Royal Air Force**. The Ministry of Defence then adopted a new approach: aircraft owned and operated by private industry under contract to the state. Its choice fell on the **G 115E**, designated **Tutor T1**, which entered service in 1999.\n\n## Design\nThe airframe is built of carbon composite materials; the fuselage and each wing spar are single pieces. The fixed sprung-steel tricycle undercarriage has spatted wheels, and the short nose houses a 180 hp **Lycoming AEIO-360** flat-four driving a three-bladed variable-pitch propeller. Under a broad canopy the two side-by-side seats are fixed: pilot position is adjusted with cushions and the rudder bar. Limited to +6 g and −3 g, the Tutor is capable of basic aerobatics; its inverted oil system was redesigned to improve lubrication during aerobatics.\n\n## Operational career\nThe RAF''s Tutors are owned and maintained by **Babcock International** under a Private Finance Initiative scheme, and carry British civil registrations, an overall white scheme with blue flashes and military roundels. They provided Elementary Flying Training for the RAF, Royal Navy and Army Air Corps at Cranwell and Barkston Heath until the **Grob G120TP Prefect** arrived in 2018; the Royal Navy keeps five Tutors for pilot grading at Yeovilton. The cadets'' Air Experience Flights adopted it at the turn of the century, the last in 2001. On 11 February 2009 two Tutors from St Athan collided in mid-air: an RAF pilot and a cadet died in each aircraft.\n\n## Place in history\nWith 89 aircraft, the RAF is the largest military user of the G 115, ahead of the **Egyptian Air Force** with 74. **Finland** bought 28 from UK stocks, and the United Arab Emirates, Kenya and Bangladesh have also fielded it. From 2009, Enhanced Avionics Tutors received a Garmin GPS and digital instruments. Due to be replaced by the more advanced Prefect, the Tutor was still handling part of the RAF''s elementary flying training in 2020.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    NULL,
    '1985-11-01',
    '1999-01-01',
    250,
    1150,
    (SELECT id FROM manufacturer WHERE code = 'GROB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Grob G 115'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Grob G 115'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Grob G 115'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.79,
  wingspan          = 10.0,
  height            = 2.82,
  wing_area         = 12.21,
  empty_weight      = 670,
  mtow              = 990,
  service_ceiling   = 6095,
  climb_rate        = 5.3,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming AEIO-360-B1F/B (180 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1985,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **G 115 / G 115A** : premières versions à dérive droite, vendues surtout aux aéroclubs allemands et britanniques\n- **G 115D2 Heron** : version achetée d''abord par la Royal Navy, puis reprise par Tayside Aviation\n- **G 115E Tutor T1** : version à hélice tripale à pas variable de la RAF, de la Royal Navy et de l''Army Air Corps, en service depuis 1999\n- **Tutor EA** : Tutor à avionique améliorée à partir de 2009, avec GPS Garmin GNS 430W, HSI et instruments moteur numériques',
  variants_en       = E'- **G 115 / G 115A**: early versions with an upright fin, sold mainly to German and British flying clubs\n- **G 115D2 Heron**: version first bought by the Royal Navy, later taken over by Tayside Aviation\n- **G 115E Tutor T1**: version with a three-bladed variable-pitch propeller for the RAF, Royal Navy and Army Air Corps, in service since 1999\n- **Tutor EA**: Enhanced Avionics Tutor from 2009, with Garmin GNS 430W GPS, digital HSI and digital engine instruments',

  -- Strate 4 : qualitatif
  nickname          = 'Tutor',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grob_G_115',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grob_G_115',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'James Humphreys',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Grob G 115';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Grob G 115';
