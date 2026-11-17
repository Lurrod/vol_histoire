-- Calidus B-250
--
-- Photo : Calidus B-250 at Dubai Air Show 2019 1.jpg
--   licence CC BY-SA 4.0 — Mztourist
--   https://commons.wikimedia.org/wiki/File:Calidus_B-250_at_Dubai_Air_Show_2019_1.jpg

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
    'Calidus B-250',
    'Calidus B-250',
    'Calidus B-250',
    'Calidus B-250',
    'Avion d''attaque légère émirien à turbopropulseur et cellule en fibre de carbone, conçu au Brésil',
    'Emirati turboprop light attack aircraft with a carbon-fibre airframe, designed in Brazil',
    '/assets/airplanes/calidus-b250.jpg',
    E'## Genèse\nPour disposer d''un avion de combat léger fabriqué aux Émirats arabes unis, la société émirienne **Calidus** ne part pas de rien : elle s''associe au bureau d''études brésilien **Novaer**. L''avion est dessiné et mis au point au Brésil, la production en série devant revenir aux Émirats. Le projet est confié à **Joseph Kovács**, l''ingénieur qui avait conçu l''**Embraer Tucano**. Il en résulte le **B-250**, un biplace d''attaque légère et de lutte anti-guérilla, dont le premier vol a lieu en juillet 2017.\n\n## Conception\nLe B-250 reprend la formule classique des avions d''attaque à turbopropulseur : monoplan à aile basse cantilever, train tricycle escamotable, deux sièges éjectables **Martin-Baker** en tandem sous une verrière fermée, et un **Pratt & Whitney Canada PT6A-68** de 1 600 ch entraînant une hélice tractive. Son originalité tient à sa structure, entièrement réalisée en **fibre de carbone**, qui le rend nettement plus léger que ses concurrents. L''avionique Pro Line Fusion II vient de l''américain Rockwell Collins. Sept points d''emport acceptent 1 800 kg d''armement et une tourelle optronique ; avec quatre bombes guidées laser, deux missiles air-air et un réservoir, le rayon d''action atteint 560 km, et l''endurance peut aller jusqu''à douze heures.\n\n## Carrière opérationnelle\nDeux exemplaires sont construits début 2018. Au salon de Dubaï de 2019, l''armée de l''air des Émirats arabes unis commande 24 appareils. En 2024, selon la lettre *Intelligence Online*, Calidus et l''Indonésie travaillent à transformer le B-250 en drone de combat ; le projet aurait été évoqué en mai 2024 à Abou Dabi par **Prabowo Subianto** et **Mohammed ben Zayed**. Le drone emploierait de l''avionique, des capteurs et des armes des deux pays, dont les missiles Al Tariq et Thunder du groupe émirien EDGE, avec une partie de la production à Jakarta.\n\n## Place dans l''histoire\nLe B-250 illustre une nouvelle manière de bâtir une industrie aéronautique nationale : acheter des compétences de conception à l''étranger pour produire chez soi. Il vient concurrencer, sur le créneau de l''appui aérien léger, des références comme l''**Embraer Super Tucano**, descendant du Tucano dessiné par le même ingénieur. Sa cellule composite et son éventuelle version sans pilote en font un témoin de l''évolution de ce type d''avion vers des formules plus légères et plus polyvalentes.',
    E'## Genesis\nTo obtain a light combat aircraft built in the United Arab Emirates, the Emirati company **Calidus** did not start from scratch: it partnered with the Brazilian design house **Novaer**. The aircraft was designed and developed in Brazil, with series production to be carried out in the Emirates. The project was led by **Joseph Kovács**, the engineer who had designed the **Embraer Tucano**. The result was the **B-250**, a two-seat light attack and counter-insurgency aircraft, which first flew in July 2017.\n\n## Design\nThe B-250 follows the classic formula of turboprop attack aircraft: a cantilever low-wing monoplane with retractable tricycle undercarriage, two **Martin-Baker** ejection seats in tandem under an enclosed canopy, and a 1,600 shp **Pratt & Whitney Canada PT6A-68** driving a tractor propeller. Its originality lies in its structure, built entirely of **carbon fibre**, which makes it much lighter than its competitors. The Pro Line Fusion II avionics come from America''s Rockwell Collins. Seven hardpoints take 1,800 kg of weapons and an electro-optical turret; with four laser-guided bombs, two air-to-air missiles and a fuel tank, the combat radius reaches 560 km, and endurance can extend to twelve hours.\n\n## Operational career\nTwo aircraft had been built by early 2018. At the 2019 Dubai Airshow the United Arab Emirates Air Force ordered 24. In 2024, according to the newsletter *Intelligence Online*, Calidus and Indonesia were working to turn the B-250 into a combat drone; the project was reportedly discussed in May 2024 in Abu Dhabi by **Prabowo Subianto** and **Mohammed bin Zayed**. The drone would use avionics, sensors and weapons from both countries, including the Al Tariq and Thunder missiles of the Emirati EDGE group, with part of the production in Jakarta.\n\n## Place in history\nThe B-250 illustrates a new way of building a national aviation industry: buying design expertise abroad in order to produce at home. On the light air support market it competes with references such as the **Embraer Super Tucano**, a descendant of the Tucano drawn by the same engineer. Its composite airframe and possible unmanned version make it a witness to the evolution of this type of aircraft towards lighter and more versatile formulas.',
    (SELECT id FROM countries WHERE code = 'ARE'),
    NULL,
    '2017-07-01',
    NULL,
    557,
    2400,
    (SELECT id FROM manufacturer WHERE code = 'CAL'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Calidus B-250'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Calidus B-250'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Calidus B-250'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.98,
  wingspan          = 12.09,
  height            = 3.79,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = 9100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 560,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-68 (1 600 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Prototypes B-250** : deux exemplaires construits au début de 2018, premier vol en juillet 2017\n- **B-250 de série** : version d''attaque légère et d''entraînement commandée à 24 exemplaires par l''armée de l''air émirienne en 2019\n- **Version drone** : projet de transformation en drone de combat étudié avec l''Indonésie à partir de 2024',
  variants_en       = E'- **B-250 prototypes**: two built by early 2018, first flight in July 2017\n- **Production B-250**: light attack and training version, 24 ordered by the UAE Air Force in 2019\n- **Drone version**: project to convert it into a combat drone, studied with Indonesia from 2024',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Calidus_B-250',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mztourist',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Calidus B-250';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Calidus B-250';
