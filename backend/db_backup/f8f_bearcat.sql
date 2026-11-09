-- Grumman F8F Bearcat
--
-- Photo : Grumman F8F-2P Bearcat ‘121714 - B-201’ (G-RUMM) (22066402333).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Grumman_F8F-2P_Bearcat_%E2%80%98121714_-_B-201%E2%80%99_(G-RUMM)_(22066402333).jpg

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
    'F8F Bearcat',
    'F8F Bearcat',
    'Grumman F8F Bearcat',
    'Grumman F8F Bearcat',
    'Conçu pour le Pacifique, arrivé trop tard : sa guerre sera l’Indochine',
    'Designed for the Pacific, arrived too late: its war would be Indochina',
    '/assets/airplanes/f8f-bearcat.jpg',
    E'## Genèse\nEn 1943, l''US Navy veut un chasseur capable de décoller des petits porte-avions d''escorte et de grimper plus vite que tout ce que le Japon peut lui opposer. **Grumman** prend le problème à l''envers de ses habitudes : au lieu d''un avion plus gros autour d''un moteur plus puissant, il dessine la plus petite cellule possible autour du **Pratt & Whitney R-2800** qui équipe déjà le Hellcat. Deux prototypes sont commandés le 27 novembre 1943 ; le premier vole le **21 août 1944**.\n\n## Conception\nHuit mètres soixante de long, trois tonnes et demie à vide, 2 100 ch : le rapport puissance-masse est exceptionnel. La verrière en goutte d''eau dégage la vue vers l''arrière, et l''armement se réduit à quatre mitrailleuses de 12,7 mm sur le F8F-1, quatre canons de 20 mm sur le F8F-1B, avec roquettes et bombes sous les ailes. En 1946, un Bearcat monte à 3 048 mètres en 94 secondes depuis l''arrêt, une performance que bien des avions à réaction de l''époque ne pouvaient égaler.\n\n## Carrière opérationnelle\nLa première flottille, la VF-19, est déclarée opérationnelle le **21 mai 1945**, mais la guerre s''achève avant tout engagement. Le Bearcat devient alors le chasseur standard de l''aéronavale américaine de l''immédiat après-guerre, jusqu''à ce que les jets le remplacent ; trop court en autonomie, il ne sert pas en Corée. Sa vraie guerre est l''**Indochine** : à partir de 1951, la France en reçoit environ deux cents au titre de l''aide américaine. Les groupes de chasse de l''armée de l''air les engagent en appui au sol — bombes, roquettes, napalm — jusqu''aux combats de **Diên Biên Phu** en 1954. Après le départ des Français, les survivants passent à l''armée de l''air sud-vietnamienne, tandis que la **Thaïlande** en aligne également.\n\n## Place dans l''histoire\nMille deux cent soixante-cinq exemplaires de 1944 à 1949. Le Bearcat est l''aboutissement du chasseur embarqué à pistons américain, au moment exact où le réacteur le rend inutile ; dans l''US Navy, ses flottilles passent au **F9F Panther**. Il survit dans les courses aériennes : en 1989, le Bearcat modifié *Rare Bear* porte le record du monde de vitesse des avions à moteur à pistons à 850 km/h. Son équivalent britannique, le **Hawker Sea Fury**, a suivi la même trajectoire.',
    E'## Genesis\nIn 1943 the US Navy wanted a fighter able to take off from small escort carriers and climb faster than anything Japan could put against it. **Grumman** reversed its usual approach: instead of a bigger aircraft around a more powerful engine, it drew the smallest possible airframe around the **Pratt & Whitney R-2800** that already powered the Hellcat. Two prototypes were ordered on 27 November 1943; the first flew on **21 August 1944**.\n\n## Design\nEight metres sixty long, three and a half tonnes empty, 2,100 hp: an exceptional power-to-weight ratio. The bubble canopy cleared the view to the rear, and armament was reduced to four 12.7 mm machine guns on the F8F-1, four 20 mm cannon on the F8F-1B, with rockets and bombs under the wings. In 1946 a Bearcat climbed to 3,048 metres in 94 seconds from a standing start, a performance many jets of the day could not match.\n\n## Operational career\nThe first squadron, VF-19, was declared operational on **21 May 1945**, but the war ended before any action. The Bearcat then became the standard US Navy fighter of the immediate post-war years, until jets replaced it; short on range, it did not serve in Korea. Its real war was **Indochina**: from 1951 France received some two hundred under American aid. The Air Force fighter groups used them for ground support — bombs, rockets, napalm — up to the battle of **Dien Bien Phu** in 1954. After the French left, the survivors went to the South Vietnamese air force, while **Thailand** also flew the type.\n\n## Place in history\nOne thousand two hundred and sixty-five built from 1944 to 1949. The Bearcat is the culmination of the American piston carrier fighter, at the very moment the jet made it useless; in the US Navy its squadrons moved on to the **F9F Panther**. It lives on in air racing: in 1989 the modified Bearcat *Rare Bear* set the world speed record for piston-engined aircraft at 850 km/h. Its British counterpart, the **Hawker Sea Fury**, followed the same path.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1943-11-27',
    '1944-08-21',
    '1945-05-21',
    732.0,
    1778.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.61,
  wingspan          = 10.92,
  height            = 4.22,
  wing_area         = 22.7,
  empty_weight      = 3470,
  mtow              = 6105,
  service_ceiling   = 12400,
  climb_rate        = 22.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-34W Double Wasp',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons en étoile, 18 cylindres',
  engine_type_en    = '18-cylinder radial piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1944,
  production_end    = 1949,
  units_built       = 1265,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **F8F-1** : version initiale, quatre mitrailleuses de 12,7 mm\n- **F8F-1B** : quatre canons de 20 mm, livrée en nombre à la France pour l''Indochine\n- **F8F-1N / F8F-2N** : chasseurs de nuit à radar en nacelle\n- **F8F-2 / F8F-2P** : dérive agrandie, version de reconnaissance photographique\n- ***Rare Bear*** : Bearcat de course, record du monde de vitesse des avions à pistons en 1989',
  variants_en       = E'- **F8F-1** : initial version, four 12.7 mm machine guns\n- **F8F-1B** : four 20 mm cannon, supplied in numbers to France for Indochina\n- **F8F-1N / F8F-2N** : night fighters with podded radar\n- **F8F-2 / F8F-2P** : enlarged fin, photo-reconnaissance version\n- ***Rare Bear*** : racing Bearcat, piston-engined world speed record in 1989',

  -- Strate 4 : qualitatif
  nickname          = 'Bearcat',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_F8F_Bearcat',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_F8F_Bearcat',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'F8F Bearcat';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F8F Bearcat';
