-- Douglas F5D Skylancer
--
-- Photo : F5D in flight 1971.jpg
--   licence Public domain — NASA Photo
--   https://commons.wikimedia.org/wiki/File:F5D_in_flight_1971.jpg

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
    'F5D Skylancer',
    'F5D Skylancer',
    'Douglas F5D Skylancer',
    'Douglas F5D Skylancer',
    'Successeur supersonique du Skyray refusé par la marine, devenu banc d''essai de la NASA pour le X-20',
    'The Skyray''s supersonic successor, turned down by the Navy and turned into a NASA testbed for the X-20',
    '/assets/airplanes/f5d-skylancer.jpg',
    E'## Genèse\nLe Skylancer naît comme **F4D-2N**, version tous-temps du **F4D Skyray**, pensée pour exploiter la poussée supplémentaire du **Pratt & Whitney J57** finalement monté sur le Skyray à la place du Westinghouse J40. Les modifications s''accumulent au point que l''avion n''est plus une simple variante : il reçoit une désignation propre, F5D Skylancer. Neuf cellules d''essai sont commandées, avec une commande de série de 51 avions à suivre. Le premier F5D-1 vole le 21 avril 1956 et passe le mur du son dès ce vol inaugural.\n\n## Conception\nPresque toutes les pièces de la cellule sont modifiées, mais la forme générale et le dessin de l''aile du Skyray demeurent ; l''aile devient seulement bien plus mince et son revêtement est renforcé, ce qui corrige un défaut du F4D. Le fuselage, allongé de 2,4 m, suit la **loi des aires** pour réduire la traînée transsonique. Les quatre canons de 20 mm de l''emplanture sont conservés, mais l''armement principal doit être fait de missiles, quatre **AIM-9 Sidewinder** ou deux **AIM-7 Sparrow**, et de roquettes de 51 mm. Une version Mach 2 à réacteur General Electric J79 et entrées d''air variables est proposée, puis écartée.\n\n## Essais\nL''avion se révèle facile à piloter et performant, mais la marine annule sa commande après quatre exemplaires. Raison officielle : il ressemble trop au **Vought F8U Crusader** déjà commandé. Certains historiens y voient aussi la politique, Douglas construisant déjà une très grande part des avions de la marine : lui confier le F5D l''aurait rapproché du monopole. Le pilote d''essai du programme, **Alan Shepard**, conclut dans son rapport que la marine n''en a pas besoin. Les quatre avions poursuivent néanmoins divers programmes d''essais militaires.\n\n## Place dans l''histoire\nDeux Skylancer passent à la **NASA** au début des années 1960. Le NASA 212 sert de banc d''essai au programme américain de transport supersonique avec une aile ogivale, la forme qu''adoptera Concorde, et de simulateur de champ de vision pour l''avion spatial **X-20 Dyna-Soar**. Le NASA 802, proche du X-20 par sa forme et son pilotage, simule ses procédures d''interruption de mission ; **Neil Armstrong** le pilote dans ce programme. Le dernier vole jusqu''en 1970 : sans jamais rejoindre une flottille, le Skylancer aura préparé l''avion spatial et le vol supersonique civil.',
    E'## Genesis\nThe Skylancer began as the **F4D-2N**, an all-weather version of the **F4D Skyray** meant to exploit the extra thrust of the **Pratt & Whitney J57** eventually fitted to the Skyray instead of the Westinghouse J40. The changes piled up until the aircraft was no longer a mere variant: it received its own designation, F5D Skylancer. Nine test airframes were ordered, with a 51-aircraft production order to follow. The first F5D-1 flew on 21 April 1956 and went supersonic on that maiden flight.\n\n## Design\nAlmost every part of the airframe was modified, but the Skyray''s basic form and wing shape remained; the wing simply became much thinner and its skinning was reinforced, curing a weakness of the F4D. The fuselage, 2.4 m longer, was **area-ruled** to reduce transonic drag. The four 20 mm cannon in the wing roots were retained, but primary armament was to be missiles, four **AIM-9 Sidewinders** or two **AIM-7 Sparrows**, plus 51 mm rockets. A Mach 2 version with a General Electric J79 and variable inlets was proposed, then rejected.\n\n## Testing\nThe aircraft proved easy to fly and performed well, but the Navy cancelled its order after four had been built. The stated reason was that it was too similar to the **Vought F8U Crusader**, already on order. Some historians believe politics played as big a part, since Douglas already built a very large share of the Navy''s aircraft: the F5D contract would have brought it closer to a monopoly. The project test pilot, **Alan Shepard**, concluded in his report that the Navy did not need it. The four aircraft nevertheless went on flying in various military test programmes.\n\n## Place in history\nTwo Skylancers were transferred to **NASA** in the early 1960s. NASA 212 served as a testbed for the American supersonic transport programme with an ogival wing, the planform later used on Concorde, and as a vision-field simulator for the **X-20 Dyna-Soar** spaceplane. NASA 802, close to the X-20 in shape and handling, simulated its abort procedures; **Neil Armstrong** flew it in that programme. The last one flew until 1970: without ever joining a squadron, the Skylancer helped prepare both the spaceplane and civil supersonic flight.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1956-04-21',
    NULL,
    1270,
    2146,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F5D Skylancer'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'F5D Skylancer'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F5D Skylancer'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F5D Skylancer'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F5D Skylancer'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F5D Skylancer'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F5D Skylancer'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.4,
  wingspan          = 10.21,
  height            = 4.52,
  wing_area         = 51.7,
  empty_weight      = 7912,
  mtow              = 14154,
  service_ceiling   = 17500,
  climb_rate        = 105.8,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J57-P-8',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 45.4,
  thrust_wet        = 71.2,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **F4D-2N** : désignation initiale du projet, version tous-temps du Skyray\n- **F5D-1** : quatre exemplaires construits sur neuf cellules d''essai commandées, tous à réacteur J57-P-8\n- **F5D-1 de série** : 51 avions prévus à réacteur J57-P-14, annulés\n- **Version Mach 2** : projet à réacteur General Electric J79 et entrées d''air variables, rejeté\n- **NASA 212 et NASA 802** : deux F5D-1 de la NASA, banc d''essai d''aile ogivale et simulateurs du X-20 Dyna-Soar',
  variants_en       = E'- **F4D-2N**: original project designation, an all-weather version of the Skyray\n- **F5D-1**: four built out of nine test airframes ordered, all with the J57-P-8\n- **Production F5D-1**: 51 aircraft planned with the J57-P-14, cancelled\n- **Mach 2 version**: proposal with a General Electric J79 and variable inlets, rejected\n- **NASA 212 and NASA 802**: two NASA F5D-1s, ogival-wing testbed and X-20 Dyna-Soar simulators',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_F5D_Skylancer',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_F5D_Skylancer',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'F5D Skylancer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F5D Skylancer';
