-- Northrop Grumman EA-6B Prowler
--
-- Photo : Prowler Final Flight division flight (cropped).jpg
--   licence Public domain — Cpl. Neysa Huertas Quinones
--   https://commons.wikimedia.org/wiki/File%3AProwler_Final_Flight_division_flight_%28cropped%29.jpg

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
    'EA-6B Prowler',
    'EA-6B Prowler',
    'Northrop Grumman EA-6B Prowler',
    'Northrop Grumman EA-6B Prowler',
    'Avion de guerre électronique embarqué, brouilleur de toute une flotte',
    'Carrier-borne electronic warfare aircraft, jammer for an entire fleet',
    '/assets/airplanes/ea6b-prowler.jpg',
    E'## Genèse\nLe Vietnam a montré qu''aucune formation de bombardiers ne survit longtemps face à des radars de conduite de tir intacts. Grumman allonge la cellule de l''A-6 Intruder de 1,40 mètre pour y loger **quatre membres d''équipage** : un pilote et trois officiers de contre-mesures électroniques.\n\n## Conception\nLe cœur du système est le **ALQ-99**, un ensemble de nacelles brouilleuses alimentées par des éoliennes en veine d''air et pilotées depuis l''appareil. Le Prowler ne se défend pas : il aveugle. Sa présence conditionne l''entrée du reste du dispositif dans un espace aérien défendu, ce qui en fait l''un des rares appareils dont l''indisponibilité peut annuler une opération entière.\n\n## Carrière opérationnelle\nDe **1972** au-dessus du Vietnam à **2019** en Irak et en Syrie, le Prowler participe à toutes les campagnes américaines. Après le retrait de l''US Air Force de la guerre électronique dédiée en 1998, il devient l''**unique** brouilleur tactique des forces armées américaines, prêté d''un service à l''autre.\n\n## Place dans l''histoire\nQuarante-huit ans de service pour un appareil dont on ne parle jamais et sans lequel rien ne décolle. Le Prowler a fait de la guerre électronique une spécialité à part entière, avec ses équipages, sa doctrine et ses appareils — un héritage repris par l''EA-18G Growler.',
    E'## Genesis\nVietnam showed that no bomber formation survives long against intact fire-control radars. Grumman stretched the A-6 Intruder airframe by 1.4 metres to house **four crew**: a pilot and three electronic countermeasures officers.\n\n## Design\nAt the heart of the system is the **ALQ-99**, a set of jamming pods powered by ram-air turbines and controlled from the aircraft. The Prowler does not defend itself: it blinds. Its presence conditions everyone else’s entry into defended airspace, making it one of the rare aircraft whose unavailability can cancel an entire operation.\n\n## Operational career\nFrom **1972** over Vietnam to **2019** over Iraq and Syria, the Prowler took part in every American campaign. After the US Air Force withdrew from dedicated electronic warfare in 1998, it became the **only** tactical jammer in the US armed forces, lent from one service to another.\n\n## Place in history\nForty-eight years of service for an aircraft nobody talks about and without which nothing takes off. The Prowler made electronic warfare a discipline in its own right, with its own crews, doctrine and aircraft — a legacy carried on by the EA-18G Growler.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1966-01-01',
    '1968-05-25',
    '1971-07-01',
    1048.0,
    3254.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Guerre électronique'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM wars WHERE name = 'Guerre du Liban')),
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.7,
  wingspan          = 16.15,
  height            = 4.95,
  wing_area         = 49.1,
  empty_weight      = 14588,
  mtow              = 27900,
  service_ceiling   = 11580,
  climb_rate        = 65,
  g_limit_pos       = 5.5,
  g_limit_neg       = -2.0,
  combat_radius     = 1840,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J52-P-408',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 49.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1966,
  production_end    = 1991,
  units_built       = 170,
  unit_cost_usd     = 52000000,
  unit_cost_year    = 1997,
  operators_count   = 1,
  variants          = E'- **EA-6A** : premier dérivé de guerre électronique de l''A-6, biplace\n- **EA-6B ICAP II / III** : évolutions successives des brouilleurs et récepteurs\n- **EA-18G Growler** : successeur, bâti sur la cellule du Super Hornet',
  variants_en       = E'- **EA-6A** : first electronic warfare derivative of the A-6, two-seat\n- **EA-6B ICAP II / III** : successive jammer and receiver upgrades\n- **EA-18G Growler** : successor, built on the Super Hornet airframe',

  -- Strate 4 : qualitatif
  nickname          = 'Prowler',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_EA-6_Prowler',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_Grumman_EA-6B_Prowler',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Cpl. Neysa Huertas Quinones',
  image_licence     = 'Public domain'
WHERE name = 'EA-6B Prowler';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'EA-6B Prowler';
