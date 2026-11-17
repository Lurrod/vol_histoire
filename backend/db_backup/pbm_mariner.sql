-- Martin PBM Mariner
--
-- Photo : Martin PBM-3 Mariner of VP-74 in flight, in 1942 (fsa.8b08013).jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Martin_PBM-3_Mariner_of_VP-74_in_flight,_in_1942_(fsa.8b08013).jpg

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
    'Martin PBM Mariner',
    'Martin PBM Mariner',
    'Martin PBM Mariner',
    'Martin PBM Mariner',
    'Hydravion de patrouille à aile en mouette, chasseur d''U-Boote puis patrouilleur de la guerre de Corée',
    'Gull-winged patrol flying boat, a U-boat hunter in the Second World War and a patrol aircraft over Korea',
    '/assets/airplanes/pbm-mariner.jpg',
    E'## Genèse\nEn 1936, la **Glenn L. Martin Company** propose à la marine un hydravion quadrimoteur, le Model 160 ; le Bureau of Aeronautics préférant les bimoteurs, le bureau d''études en tire aussitôt le Model 162. Martin le promet 20 % plus rapide que le **PBY Catalina**, avec deux fois son rayon d''action et sa charge : Consolidated conteste et menace de poursuites. Pour trancher, Martin fait voler en décembre 1937 une maquette pilotée à l''échelle 3/8, le Tadpole Clipper, qui confirme ses calculs. La marine commande un prototype le 30 juin 1937 puis, sans attendre son vol, 21 PBM-1 de série dès le 28 décembre.\n\n## Conception\nLe prototype XPBM-1 vole le 18 février 1939. Une coque profonde et une aile en mouette tiennent les deux moteurs en étoile **Wright R-2600** loin des embruns, sans les haubans d''une aile parasol. Bombes, grenades ou torpilles sont logées dans des soutes creusées dans les nacelles, ce qui préserve la vitesse en charge ; l''empennage horizontal relevé donne aux deux dérives leur inclinaison caractéristique. Des tourelles de nez, dorsale et de queue et des sabords latéraux portent des mitrailleuses de 12,7 mm, et le radar AN/APS-15 devient un équipement courant.\n\n## Carrière opérationnelle\nEntré en service le 1er septembre 1940 à la patrouille VP-55, le Mariner mène d''abord les patrouilles de neutralité dans l''Atlantique. Après Pearl Harbor, il chasse les U-Boote : il coule l''U-158 le 30 juin 1942 et participe à la destruction de dix sous-marins allemands. Dans le Pacifique, de Saipan à Okinawa et Iwo Jima, il attaque de nuit convois et installations japonaises et repêche les équipages abattus, notamment ceux des B-29. Après la guerre, il assure de longues missions de patrouille pendant la **guerre de Corée**, et les garde-côtes en font l''épine dorsale de leur recherche et sauvetage à long rayon d''action.\n\n## Place dans l''histoire\nConstruit à 1 366 exemplaires, le Mariner cède la place au milieu des années 1950 à son successeur direct, le **P5M Marlin**, et au Grumman HU-16 Albatross ; la dernière patrouille de la marine équipée, la VP-50, s''en sépare en juillet 1956. Des avions d''occasion servent encore en Nouvelle-Guinée néerlandaise jusqu''en 1959 et en Uruguay jusqu''en 1964. Son nom reste aussi lié au mystère du **vol 19** : le 5 décembre 1945, un PBM-5 parti à la recherche des Avenger disparus s''évanouit à son tour, probablement détruit par une explosion en vol. Un seul exemplaire complet subsiste, au musée de Pima, à Tucson.',
    E'## Genesis\nIn 1936 the **Glenn L. Martin Company** offered the Navy a four-engined flying boat, the Model 160; as the Bureau of Aeronautics preferred twin-engined designs, the team promptly derived the Model 162 from it. Martin claimed it would be 20 percent faster than the **PBY Catalina**, with twice its range and payload: Consolidated disputed the claims and threatened legal action. To settle the matter, in December 1937 Martin flew a piloted three-eighths scale model, the Tadpole Clipper, which validated its projections. The Navy ordered a prototype on 30 June 1937 and then, without waiting for it to fly, 21 production PBM-1s on 28 December.\n\n## Design\nThe XPBM-1 prototype flew on 18 February 1939. A deep hull and a gull wing kept the two **Wright R-2600** radial engines clear of the spray without the bracing of a parasol wing. Bombs, depth charges or torpedoes were carried in bays built into the engine nacelles, preserving speed when loaded; the upswept tailplane gave the twin fins their distinctive inward tilt. Nose, dorsal and tail turrets plus beam positions carried 12.7 mm machine guns, and the AN/APS-15 radar became common equipment.\n\n## Operational career\nEntering service on 1 September 1940 with Patrol Squadron VP-55, the Mariner first flew Neutrality Patrols over the Atlantic. After Pearl Harbor it hunted U-boats: it sank U-158 on 30 June 1942 and shared in the destruction of ten German submarines. In the Pacific, from Saipan to Okinawa and Iwo Jima, it raided Japanese convoys and shore installations at night and rescued downed aircrews, including those of B-29s. After the war it flew long patrol missions during the **Korean War**, and the Coast Guard made it the backbone of its long-range search and rescue effort.\n\n## Place in history\nBuilt in 1,366 examples, the Mariner gave way in the mid-1950s to its direct successor, the **P5M Marlin**, and to the Grumman HU-16 Albatross; the Navy''s last PBM squadron, VP-50, retired them in July 1956. Second-hand aircraft served on in Netherlands New Guinea until 1959 and in Uruguay until 1964. Its name also remains tied to the mystery of **Flight 19**: on 5 December 1945 a PBM-5 sent to search for the missing Avengers vanished in turn, probably destroyed by a mid-air explosion. A single complete example survives, at the Pima Air & Space Museum in Tucson.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1937-06-30',
    '1939-02-18',
    '1940-09-01',
    330,
    4800,
    (SELECT id FROM manufacturer WHERE code = 'MAR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin PBM Mariner'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Martin PBM Mariner'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin PBM Mariner'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin PBM Mariner'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Martin PBM Mariner'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Martin PBM Mariner'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin PBM Mariner'), (SELECT id FROM wars WHERE name = 'Guerre de Corée'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 24.33,
  wingspan          = 35.97,
  height            = 8.38,
  wing_area         = 131,
  empty_weight      = 15048,
  mtow              = 25401,
  service_ceiling   = 6040,
  climb_rate        = 4.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 7,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-2600-6 (1 600 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1940,
  production_end    = 1949,
  units_built       = 1366,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 8,
  variants          = E'- **XPBM-1** : prototype à moteurs Wright R-2600-6, premier vol le 18 février 1939\n- **PBM-1** : première série, flotteurs d''aile escamotables, 21 exemplaires\n- **PBM-3C et PBM-3D** : versions de patrouille à radar AN/APS-15 et armement renforcé, 274 et 259 exemplaires\n- **PBM-3S et PBM-3R** : version anti-sous-marine allégée et version de transport désarmée\n- **PBM-5** : moteurs Pratt & Whitney R-2800 de 2 100 ch, 628 exemplaires, puis variantes anti-sous-marines PBM-5S et PBM-5S2\n- **PBM-5A** : amphibie à train tricycle escamotable, 36 exemplaires et quatre conversions',
  variants_en       = E'- **XPBM-1**: prototype with Wright R-2600-6 engines, first flight 18 February 1939\n- **PBM-1**: first production version, retractable wing floats, 21 built\n- **PBM-3C and PBM-3D**: patrol versions with AN/APS-15 radar and heavier armament, 274 and 259 built\n- **PBM-3S and PBM-3R**: lightened anti-submarine version and unarmed transport version\n- **PBM-5**: 2,100 hp Pratt & Whitney R-2800 engines, 628 built, followed by the PBM-5S and PBM-5S2 anti-submarine variants\n- **PBM-5A**: amphibian with retractable tricycle undercarriage, 36 built plus four conversions',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Martin_PBM_Mariner',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Martin_PBM_Mariner',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Martin PBM Mariner';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Martin PBM Mariner';
