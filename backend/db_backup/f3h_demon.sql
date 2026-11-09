-- McDonnell F3H Demon
--
-- Photo : F3H Demon.png
--   licence Public domain — Joe Sewell
--   https://commons.wikimedia.org/wiki/File:F3H_Demon.png

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
    'F3H Demon',
    'F3H Demon',
    'McDonnell F3H Demon',
    'McDonnell F3H Demon',
    'Condamné par le réacteur J40, sauvé par l’Allison J71 : le père direct du F-4 Phantom II',
    'Crippled by the J40 engine, saved by the Allison J71: the direct father of the F-4 Phantom II',
    '/assets/airplanes/f3h-demon.jpg',
    E'## Genèse\nEn 1949, l''US Navy constate que ses chasseurs embarqués à aile droite ne tiendront pas face aux chasseurs à aile en flèche qui apparaissent en URSS. Elle demande à **McDonnell** un intercepteur capable de rivaliser avec les meilleurs avions terrestres depuis un porte-avions. L''appareil est dessiné autour d''un seul moteur, le **Westinghouse J40**, que la Marine a retenu pour plusieurs programmes et dont elle attend une poussée inédite. Le prototype vole le **7 août 1951**.\n\n## Conception\nUne aile à forte flèche, un fuselage massif qui abrite le réacteur, une large réserve de carburant et, à partir du F3H-2, un radar de tir. En cours de développement, la Marine demande une version de chasse tout-temps plus lourde, alors que le J40 ne tient pas ses promesses : il manque de poussée et de fiabilité. Le remède est un autre moteur, l''**Allison J71**, de 43 kN à sec et 66 kN avec postcombustion, qui impose de modifier la cellule. L''armement associe quatre canons Colt Mk 12 de 20 mm et des missiles **AIM-7 Sparrow** et **AIM-9 Sidewinder**.\n\n## Carrière opérationnelle\nLe fiasco du J40 est complet : sur trente-cinq F3H-1N motorisés par lui, six sont perdus en accident, et la série est interdite de vol. Le Congrès enquête en 1955 et la plupart de ces cellules ne serviront plus qu''à l''instruction au sol. Le **F3H-2** à réacteur J71 entre en service le **7 mars 1956**. Il devient l''un des premiers chasseurs de l''aéronavale armés de missiles air-air, et assure la défense des groupes aéronavals américains en Méditerranée et dans le Pacifique. Redésigné **F-3** en 1962, il est retiré en 1964.\n\n## Place dans l''histoire\nCinq cent dix-neuf exemplaires, et un programme qui reste un cas d''école des dangers d''un moteur choisi avant d''être mis au point. Mais l''essentiel est ailleurs : c''est en étudiant un **Super Demon** plus grand et biréacteur que McDonnell aboutit au **F-4 Phantom II**, qui prend sa place sur les porte-avions et devient l''avion de combat occidental le plus produit de son temps. Le Demon est aussi le successeur direct du **F2H Banshee** dans la lignée maison.',
    E'## Genesis\nIn 1949 the US Navy realised that its straight-wing carrier fighters would not hold against the swept-wing fighters appearing in the USSR. It asked **McDonnell** for an interceptor able to rival the best land-based aircraft from a carrier deck. The aircraft was drawn around a single engine, the **Westinghouse J40**, which the Navy had chosen for several programmes and from which it expected unprecedented thrust. The prototype flew on **7 August 1951**.\n\n## Design\nA sharply swept wing, a bulky fuselage housing the engine, a large fuel capacity and, from the F3H-2, a fire-control radar. During development the Navy asked for a heavier all-weather fighter version, while the J40 failed to deliver: it lacked both thrust and reliability. The cure was another engine, the **Allison J71**, of 43 kN dry and 66 kN with afterburner, which meant modifying the airframe. Armament combined four 20 mm Colt Mk 12 cannon with **AIM-7 Sparrow** and **AIM-9 Sidewinder** missiles.\n\n## Operational career\nThe J40 fiasco was complete: of thirty-five J40-powered F3H-1Ns, six were lost in accidents and the type was grounded. Congress investigated in 1955, and most of those airframes ended their days as ground instructional trainers. The J71-powered **F3H-2** entered service on **7 March 1956**. It became one of the first naval fighters armed with air-to-air missiles, and defended American carrier groups in the Mediterranean and the Pacific. Redesignated **F-3** in 1962, it was retired in 1964.\n\n## Place in history\nFive hundred and nineteen built, and a programme that remains a textbook case of the dangers of an engine chosen before it is proven. But what matters most lies elsewhere: it was by studying a larger, twin-engined **Super Demon** that McDonnell arrived at the **F-4 Phantom II**, which took its place on the carriers and became the most-produced Western combat aircraft of its time. The Demon is also the direct successor of the **F2H Banshee** in the company line.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1949-01-01',
    '1951-08-07',
    '1956-03-07',
    1152.0,
    2200.0,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F3H Demon'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F3H Demon'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F3H Demon'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F3H Demon'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'F3H Demon'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'F3H Demon'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F3H Demon'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F3H Demon'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'F3H Demon'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F3H Demon'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.98,
  wingspan          = 10.77,
  height            = 4.45,
  wing_area         = 48.2,
  empty_weight      = 9586,
  mtow              = 15377,
  service_ceiling   = 10680,
  climb_rate        = 65,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J71-A-2E',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 43.1,
  thrust_wet        = 65.6,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 519,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **F3H-1N** : version initiale à réacteur Westinghouse J40, interdite de vol après une série d''accidents\n- **F3H-2N** : chasseur tout-temps à réacteur Allison J71, missiles Sidewinder (F-3C en 1962)\n- **F3H-2M** : version armée de Sparrow I à guidage sur faisceau (MF-3B en 1962)\n- **F3H-2** : version définitive polyvalente, Sparrow III et capacité d''attaque (F-3B en 1962)\n- **Super Demon** : étude agrandie et biréacteur, devenue le **F-4 Phantom II**',
  variants_en       = E'- **F3H-1N** : initial version with the Westinghouse J40, grounded after a string of accidents\n- **F3H-2N** : all-weather fighter with the Allison J71, Sidewinder missiles (F-3C in 1962)\n- **F3H-2M** : version armed with beam-riding Sparrow I (MF-3B in 1962)\n- **F3H-2** : definitive multi-role version, Sparrow III and strike capability (F-3B in 1962)\n- **Super Demon** : enlarged twin-engined study that became the **F-4 Phantom II**',

  -- Strate 4 : qualitatif
  nickname          = 'Demon',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_F3H_Demon',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_F3H_Demon',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Joe Sewell',
  image_licence     = 'Public domain'
WHERE name = 'F3H Demon';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F3H Demon';
