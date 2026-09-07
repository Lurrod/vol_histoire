-- Boeing F/A-18E/F Super Hornet
--
-- Photo : F A-18E Super Hornet aircraft.jpg
--   licence Public domain — Petty Officer 1st Class David Mercil, U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3AF_A-18E_Super_Hornet_aircraft.jpg

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
    'F/A-18E Super Hornet',
    'F/A-18E Super Hornet',
    'Boeing F/A-18E/F Super Hornet',
    'Boeing F/A-18E/F Super Hornet',
    'Pilier actuel de l’aviation embarquée américaine',
    'Current backbone of US carrier aviation',
    '/assets/airplanes/fa18e-super-hornet.jpg',
    E'## Genèse\nAprès l''annulation du programme furtif **A-12 Avenger II** en 1991, l''US Navy se retrouve sans remplaçant pour ses F-14 et A-6 vieillissants. La solution est pragmatique : agrandir le Hornet plutôt que repartir d''une feuille blanche. Le Super Hornet partage la silhouette de son aîné mais il est **25 % plus grand** et ne conserve presque aucune pièce commune.\n\n## Conception\nAile agrandie, entrées d''air redessinées en trapèze pour masquer les aubes de compresseur, deux points d''emport supplémentaires, 33 % de carburant interne en plus. La signature radar est réduite d''un ordre de grandeur par rapport au Hornet sans viser la furtivité du F-35. Le Block III ajoute un cockpit à écran unique et une capacité de réseau tactique étendue.\n\n## Carrière opérationnelle\nPremière frappe en **2002** au-dessus de l''Irak. Devenu la monture standard des groupes aéronavals américains, il assure aussi la fonction de ravitailleur embarqué depuis le retrait du S-3 Viking. Sa déclinaison **EA-18G Growler** a remplacé l''EA-6B Prowler dans la guerre électronique de toute la flotte.\n\n## Place dans l''histoire\nIl illustre un choix stratégique assumé : préférer un appareil éprouvé et abordable, produit en grand nombre, à un programme de rupture au coût incertain. L''Australie et le Koweït l''ont adopté ; la marine américaine le fera voler aux côtés du F-35C jusque dans les années 2040.',
    E'## Genesis\nAfter the classified **A-12 Avenger II** stealth programme was cancelled in 1991, the US Navy was left without a replacement for its ageing F-14s and A-6s. The answer was pragmatic: enlarge the Hornet rather than start from a blank sheet. The Super Hornet shares its predecessor’s silhouette but is **25% larger** and retains almost no common parts.\n\n## Design\nEnlarged wing, trapezoidal intakes redesigned to mask the compressor faces, two extra weapon stations, 33% more internal fuel. Radar signature is an order of magnitude below the Hornet’s without aiming for F-35 stealth. Block III adds a single large-area display cockpit and extended tactical networking.\n\n## Operational career\nFirst strike in **2002** over Iraq. Now the standard mount of US carrier air wings, it also serves as the fleet’s organic tanker since the S-3 Viking retired. Its **EA-18G Growler** derivative replaced the EA-6B Prowler for electronic warfare across the whole fleet.\n\n## Place in history\nIt embodies a deliberate strategic choice: a proven, affordable aircraft built in numbers rather than a revolutionary programme of uncertain cost. Australia and Kuwait adopted it; the US Navy will fly it alongside the F-35C into the 2040s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1987-01-01',
    '1995-11-29',
    '1999-01-01',
    1915.0,
    3330.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM armement WHERE name = 'AGM-154 JSOW')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM armement WHERE name = 'AGM-158 JASSM')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 18.31,
  wingspan          = 13.62,
  height            = 4.88,
  wing_area         = 46.5,
  empty_weight      = 14552,
  mtow              = 29937,
  service_ceiling   = 15000,
  climb_rate        = 228,
  g_limit_pos       = 7.6,
  g_limit_neg       = -3.0,
  combat_radius     = 722,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F414-GE-400',
  engine_count      = 2,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 62.3,
  thrust_wet        = 97.9,

  -- Strate 3 : production & service
  production_start  = 1995,
  production_end    = NULL,
  units_built       = 640,
  unit_cost_usd     = 70500000,
  unit_cost_year    = 2021,
  operators_count   = 3,
  variants          = E'- **F/A-18E** : monoplace\n- **F/A-18F** : biplace\n- **EA-18G Growler** : version de guerre électronique, brouillage et destruction radar\n- **Block III** : cockpit à écran unique, réseau tactique et réservoirs conformes',
  variants_en       = E'- **F/A-18E** : single-seat\n- **F/A-18F** : two-seat\n- **EA-18G Growler** : electronic warfare version, jamming and radar suppression\n- **Block III** : single large-area display cockpit, tactical networking and conformal tanks',

  -- Strate 4 : qualitatif
  nickname          = 'Rhino',

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_F/A-18E/F_Super_Hornet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_F/A-18E/F_Super_Hornet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Petty Officer 1st Class David Mercil, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'F/A-18E Super Hornet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'F/A-18E Super Hornet';
