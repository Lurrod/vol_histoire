-- Grumman A-6 Intruder
--
-- Photo : Grumman KA-6D Intruder of VA-34 in flight, in 1988.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3AGrumman_KA-6D_Intruder_of_VA-34_in_flight%2C_in_1988.jpg

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
    'A-6 Intruder',
    'A-6 Intruder',
    'Grumman A-6 Intruder',
    'Grumman A-6 Intruder',
    'Bombardier embarqué tout-temps, de nuit et à très basse altitude',
    'All-weather carrier bomber, by night and at very low level',
    '/assets/airplanes/a6-intruder.jpg',
    E'## Genèse\nLa guerre de Corée a montré une lacune : la marine américaine ne sait pas frapper de nuit ni par mauvais temps. Grumman répond avec un appareil pensé autour de son électronique, pas de ses performances — l''A-6 est lent, laid, et emporte plus de bombes qu''un B-17.\n\n## Conception\nLe pilote et le **bombardier-navigateur** sont assis côte à côte, décalés en hauteur, autour d''un écran radar commun : la mission se conduit à deux. Le système DIANE couple radar de recherche, radar de suivi de terrain et centrale inertielle pour amener l''avion sur sa cible à 60 mètres du sol, dans la nuit noire, sans référence extérieure.\n\n## Carrière opérationnelle\nAu **Vietnam**, l''A-6 est souvent le seul appareil en vol pendant la mousson. Il frappe Hanoï et Haïphong par tous les temps, au prix de pertes élevées en défense antiaérienne dense. Suivent le **Liban** en 1983, la Libye en 1986, et la **guerre du Golfe**, où il assure une large part des frappes de nuit de l''aéronavale.\n\n## Place dans l''histoire\nRetiré en 1997 sans remplaçant direct — ses missions se sont réparties entre le F/A-18E Super Hornet et les armements guidés à distance de sécurité. Sa descendance, l''**EA-6B Prowler**, servira encore vingt ans dans la guerre électronique.',
    E'## Genesis\nThe Korean War exposed a gap: the US Navy could not strike at night or in bad weather. Grumman answered with an aircraft designed around its electronics rather than its performance — the A-6 is slow, ugly, and carries more bombs than a B-17.\n\n## Design\nThe pilot and the **bombardier-navigator** sit side by side, offset in height, around a shared radar display: the mission is flown by two. The DIANE system combined search radar, terrain-following radar and an inertial platform to bring the aircraft over its target at 60 metres in pitch darkness, with no outside reference.\n\n## Operational career\nOver **Vietnam**, the A-6 was often the only aircraft flying during the monsoon. It struck Hanoi and Haiphong in all weather, at the cost of heavy losses in dense air defences. Then came **Lebanon** in 1983, Libya in 1986, and the **Gulf War**, where it flew a large share of naval aviation’s night strikes.\n\n## Place in history\nRetired in 1997 with no direct replacement — its missions were split between the F/A-18E Super Hornet and stand-off guided weapons. Its descendant, the **EA-6B Prowler**, would serve another twenty years in electronic warfare.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1957-01-01',
    '1960-04-19',
    '1963-02-01',
    1043.0,
    5222.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM tech WHERE name = 'Radar de suivi de terrain')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM armement WHERE name = 'Mk 84')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM wars WHERE name = 'Guerre du Liban')),
((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.64,
  wingspan          = 16.15,
  height            = 4.93,
  wing_area         = 49.1,
  empty_weight      = 12093,
  mtow              = 27397,
  service_ceiling   = 12900,
  climb_rate        = 40,
  g_limit_pos       = 6.5,
  g_limit_neg       = -3.0,
  combat_radius     = 1627,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J52-P-8B',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 41.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1960,
  production_end    = 1992,
  units_built       = 693,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **A-6A** : version initiale du Vietnam\n- **A-6E** : radar unique et calculateur numérique, version définitive\n- **A-6E TRAM** : tourelle électro-optique sous le nez, guidage laser\n- **KA-6D** : ravitailleur embarqué\n- **EA-6B Prowler** : dérivé de guerre électronique à quatre places',
  variants_en       = E'- **A-6A** : initial Vietnam version\n- **A-6E** : single radar and digital computer, definitive version\n- **A-6E TRAM** : chin-mounted electro-optical turret, laser designation\n- **KA-6D** : carrier-borne tanker\n- **EA-6B Prowler** : four-seat electronic warfare derivative',

  -- Strate 4 : qualitatif
  nickname          = 'Double Ugly',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_A-6_Intruder',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_A-6_Intruder',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'A-6 Intruder';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'A-6 Intruder';
