-- Lockheed P-2 Neptune
--
-- Photo : P2V-5 VP-1 in flight over Japan 1952.JPG
--   licence Public domain — USN
--   https://commons.wikimedia.org/wiki/File%3AP2V-5_VP-1_in_flight_over_Japan_1952.JPG

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
    'P-2 Neptune',
    'P-2 Neptune',
    'Lockheed P-2 Neptune',
    'Lockheed P-2 Neptune',
    'Patrouilleur maritime qui décolla un jour d’un porte-avions avec une bombe atomique',
    'Maritime patroller that once left a carrier deck carrying an atomic bomb',
    '/assets/airplanes/p2-neptune.jpg',
    E'## Genèse\nLockheed dessine le Neptune en 1941, de sa propre initiative et sans commande, autour d''une idée simple : un avion de patrouille doit avant tout **rester en l''air longtemps**. Tout le reste — vitesse, plafond, armement — vient après. La marine américaine ne s''y intéresse qu''en 1944, la guerre du Pacifique ayant démontré ce que coûte l''absence de surveillance maritime.\n\n## Conception\nAile droite de grand allongement montée haut, deux moteurs Turbo-Compound qui récupèrent l''énergie des gaz d''échappement par des turbines, poste de navigateur vitré dans le nez. La cellule est conçue pour vingt heures de vol. Sa capacité d''emport dépasse largement le besoin d''un patrouilleur — c''est ce qui permettra les versions les plus étranges.\n\n## Carrière opérationnelle\nEn 1946, un Neptune relie l''Australie à l''Ohio **sans escale**, 18 082 kilomètres, record du monde de distance tenu dix ans. En 1948, un P2V-3C décolle du porte-avions *Coral Sea* avec une bombe atomique factice, propulsé par des fusées : la marine démontrait qu''elle pouvait, elle aussi, frapper à l''arme nucléaire. Il patrouille ensuite l''Atlantique et le Pacifique pendant trente ans, et chasse de nuit sur la piste Hô Chi Minh.\n\n## Place dans l''histoire\nMille cent quatre-vingt-un exemplaires, neuf marines. Il a fixé la silhouette du patrouilleur maritime — long fuselage, grande aile, queue en aiguille pour le détecteur magnétique — que reprendra son successeur direct, le **P-3 Orion**, avec quatre turbopropulseurs à la place de ses deux moteurs à pistons.',
    E'## Genesis\nLockheed drew the Neptune in 1941 on its own initiative, with no order, around a simple idea: a patrol aircraft must above all **stay up a long time**. Everything else — speed, ceiling, armament — comes after. The US Navy only took an interest in 1944, the Pacific war having shown what the absence of maritime surveillance costs.\n\n## Design\nA high-aspect-ratio straight wing mounted high, two Turbo-Compound engines recovering exhaust energy through turbines, and a glazed navigator''s station in the nose. The airframe is built for twenty hours aloft. Its load capacity far exceeds a patroller''s needs — which is what made the strangest versions possible.\n\n## Operational career\nIn 1946 a Neptune flew from Australia to Ohio **non-stop**, 18,082 kilometres, a world distance record held for ten years. In 1948 a P2V-3C left the carrier *Coral Sea* carrying a dummy atomic bomb, boosted by rockets: the Navy was demonstrating that it too could strike with nuclear weapons. It then patrolled the Atlantic and Pacific for thirty years, and hunted by night over the Ho Chi Minh trail.\n\n## Place in history\nOne thousand one hundred and eighty-one built, nine navies. It fixed the silhouette of the maritime patroller — long fuselage, large wing, needle tail for the magnetic detector — which its direct successor the **P-3 Orion** took up, with four turboprops in place of its two piston engines.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1941-01-01',
    '1945-05-17',
    '1947-03-01',
    649.0,
    5930.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM armement WHERE name = 'Mk 46')),
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 27.94,
  wingspan          = 31.65,
  height            = 8.94,
  wing_area         = 92.9,
  empty_weight      = 22650,
  mtow              = 36240,
  service_ceiling   = 6800,
  climb_rate        = 5.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2200,
  crew              = 9,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-3350-32W Turbo-Compound',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1962,
  units_built       = 1181,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 9,
  variants          = E'- **P2V-3C** : version nucléaire embarquée, décollage par fusées depuis un porte-avions\n- **P2V-7 / SP-2H** : version définitive, **deux réacteurs J34 ajoutés** sous voilure\n- **AP-2H** : version d''attaque nocturne du Vietnam, armée de canons et de capteurs\n- **Kawasaki P-2J** : version japonaise à turbopropulseurs, 82 exemplaires\n- Le *Truculent Turtle* franchit **18 082 km sans escale** en 1946, record tenu dix ans',
  variants_en       = E'- **P2V-3C** : carrier-borne nuclear version, rocket-assisted take-off from a deck\n- **P2V-7 / SP-2H** : definitive version, with **two J34 jets added** under the wings\n- **AP-2H** : Vietnam night attack version, armed with cannon and sensors\n- **Kawasaki P-2J** : Japanese turboprop version, 82 built\n- The *Truculent Turtle* flew **18,082 km non-stop** in 1946, a record held for ten years',

  -- Strate 4 : qualitatif
  nickname          = 'Neptune',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_P-2_Neptune',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_P-2_Neptune',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USN',
  image_licence     = 'Public domain'
WHERE name = 'P-2 Neptune';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'P-2 Neptune';
