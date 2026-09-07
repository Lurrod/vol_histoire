-- Baykar Bayraktar TB2
--
-- Photo : Bayraktar TB2 Runway.jpg
--   licence CC BY-SA 4.0 — Bayhaluk
--   https://commons.wikimedia.org/wiki/File%3ABayraktar_TB2_Runway.jpg

-- Entrée de référentiel propre à cette fiche.
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'MAM-L', NULL, 'Munition guidée laser de 22 kg conçue pour les drones tactiques légers', 'Laser-guided 22 kg munition designed for light tactical drones'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'MAM-L');

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
    'Bayraktar TB2',
    'Bayraktar TB2',
    'Baykar Bayraktar TB2',
    'Baykar Bayraktar TB2',
    'Drone armé turc à bas coût, qui a redéfini la guerre aérienne des années 2020',
    'Low-cost Turkish armed drone that redefined air warfare in the 2020s',
    '/assets/airplanes/bayraktar-tb2.jpg',
    E'## Genèse\nRefusée à l''achat de drones armés américains et israéliens, la Turquie développe les siens. Baykar, entreprise familiale sans passé aéronautique majeur, livre en 2014 un appareil de **700 kilos** — un septième du MQ-9 Reaper — pour un vingtième de son prix.\n\n## Conception\nCellule en composites, moteur à pistons Rotax de série, empennage en V inversé, quatre points d''emport pour des munitions **MAM-L** de 22 kg développées par Roketsan. Rien n''est technologiquement remarquable pris isolément ; l''ensemble atteint 27 heures d''endurance et une précision suffisante pour détruire un blindé, à un coût qui autorise d''en perdre.\n\n## Carrière opérationnelle\n**Syrie** en 2020, où il détruit une grande quantité de matériel syrien en quelques jours ; **Libye** la même année ; **Haut-Karabagh** à l''automne 2020, où sa contribution à la victoire azerbaïdjanaise marque durablement les états-majors ; **Ukraine** en 2022, où il devient un symbole de la résistance avant que les défenses russes ne le neutralisent.\n\n## Place dans l''histoire\nLe TB2 a démontré qu''une puissance moyenne peut se doter d''une capacité de frappe aérienne sans aviation de combat, et l''exporter à trente pays. Sa vulnérabilité face à une défense sol-air organisée, apparue dès l''été 2022, a tout autant marqué la doctrine que ses succès initiaux.',
    E'## Genesis\nRefused the purchase of American and Israeli armed drones, Turkey developed its own. Baykar, a family firm with no major aviation history, delivered in 2014 a **700-kilogram** aircraft — a seventh of the MQ-9 Reaper — for a twentieth of its price.\n\n## Design\nA composite airframe, an off-the-shelf Rotax piston engine, an inverted V-tail, and four hardpoints for 22 kg **MAM-L** munitions developed by Roketsan. Nothing is technologically remarkable taken alone; together it achieves 27 hours of endurance and accuracy enough to destroy an armoured vehicle, at a cost that makes losing one acceptable.\n\n## Operational career\n**Syria** in 2020, where it destroyed a large amount of Syrian equipment within days; **Libya** the same year; **Nagorno-Karabakh** in autumn 2020, where its contribution to the Azerbaijani victory left a lasting mark on general staffs; **Ukraine** in 2022, where it became a symbol of resistance before Russian defences neutralised it.\n\n## Place in history\nThe TB2 proved that a middle power can acquire an air strike capability without a combat air force, and export it to thirty countries. Its vulnerability to organised surface-to-air defences, apparent from the summer of 2022, has shaped doctrine as much as its early successes.',
    (SELECT id FROM countries WHERE code = 'TUR'),
    '2007-01-01',
    '2014-08-01',
    '2014-11-01',
    220.0,
    4000.0,
    (SELECT id FROM manufacturer WHERE code = 'BAY'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), (SELECT id FROM armement WHERE name = 'MAM-L'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 6.5,
  wingspan          = 12.0,
  height            = 2.2,
  wing_area         = NULL,
  empty_weight      = 420,
  mtow              = 700,
  service_ceiling   = 8200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 300,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rotax 912 iS',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons, quatre cylindres',
  engine_type_en    = 'Four-cylinder piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2014,
  production_end    = NULL,
  units_built       = 500,
  unit_cost_usd     = 5000000,
  unit_cost_year    = 2021,
  operators_count   = 30,
  variants          = E'- **TB2** : version de base, 27 heures d''endurance, quatre munitions MAM-L\n- **TB2S** : liaison satellite, affranchie de la portée radio\n- **Bayraktar TB3** : version navalisée à ailes repliables pour porte-drones\n- **Bayraktar Akıncı** : plateforme lourde, charge utile 1 500 kg\n\n*Aucun équipage embarqué : l''appareil est piloté depuis une station au sol.*',
  variants_en       = E'- **TB2** : baseline version, 27 hours endurance, four MAM-L munitions\n- **TB2S** : satellite link, freed from radio range limits\n- **Bayraktar TB3** : navalised version with folding wings for drone carriers\n- **Bayraktar Akıncı** : heavy platform with a 1,500 kg payload\n\n*No onboard crew: the aircraft is flown from a ground station.*',

  -- Strate 4 : qualitatif
  nickname          = 'TB2',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bayraktar_TB2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Baykar_Bayraktar_TB2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bayhaluk',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Bayraktar TB2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bayraktar TB2';
