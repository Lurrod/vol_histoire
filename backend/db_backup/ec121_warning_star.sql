-- Lockheed EC-121 Warning Star
--
-- Photo : Lockheed EC-121K Warning Star '141297' (11613726956).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Weston, Spalding, Lincs, UK
--   https://commons.wikimedia.org/wiki/File%3ALockheed_EC-121K_Warning_Star_%27141297%27_%2811613726956%29.jpg

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
    'EC-121 Warning Star',
    'EC-121 Warning Star',
    'Lockheed EC-121 Warning Star',
    'Lockheed EC-121 Warning Star',
    'Premier radar volant opérationnel, vingt ans avant l’AWACS',
    'The first operational flying radar, twenty years before AWACS',
    '/assets/airplanes/ec121-warning-star.jpg',
    E'## Genèse\nUn radar au sol ne voit pas au-delà de l''horizon : un bombardier volant bas passe dessous. La parade est évidente en théorie — mettre le radar en l''air — et impossible en pratique tant que l''électronique reste lourde. En 1949, les tubes ont assez maigri : Lockheed loge un radar de veille et son état-major dans la cellule du **Constellation**, l''avion de ligne le plus vaste dont il dispose.\n\n## Conception\nDeux radômes : une **soucoupe dorsale** de sept mètres pour la veille en altitude, un **radôme ventral** aplati de huit mètres pour la veille en distance. Vingt-six hommes à bord, dont dix-huit opérateurs devant des écrans cathodiques dans une cabine sans hublots. Le radar ne tourne pas électroniquement : il balaie mécaniquement, et l''interprétation reste entièrement humaine.\n\n## Carrière opérationnelle\nIl patrouille les approches atlantiques et pacifiques du continent américain pendant toute la guerre froide, en relais des navires-radars. Au **Vietnam**, il devient l''organe central du combat aérien : c''est un EC-121 qui détecte les MiG au décollage et guide les Phantom vers eux — il revendique vingt-cinq interceptions réussies. En 1969, un EC-121 est abattu par la Corée du Nord au-dessus de la mer du Japon : trente et un morts.\n\n## Place dans l''histoire\nDeux cent trente-deux exemplaires. Il invente une fonction — le guet aérien avancé — qui n''existait pas, et l''exerce seul pendant vingt ans avant que le **E-3 Sentry** ne la reprenne avec un radar rotatif à antenne unique et des calculateurs. La doctrine, elle, n''a pas changé : voir loin, bas, et diriger.',
    E'## Genesis\nGround radar cannot see beyond the horizon: a bomber flying low passes underneath. The remedy is obvious in theory — put the radar in the air — and impossible in practice while the electronics remain heavy. By 1949 the tubes had shrunk enough: Lockheed fitted a search radar and its staff into the airframe of the **Constellation**, the largest airliner it had.\n\n## Design\nTwo radomes: a seven-metre **dorsal saucer** for height finding, and a flattened eight-metre **ventral radome** for range search. Twenty-six men aboard, eighteen of them operators at cathode screens in a windowless cabin. The radar does not scan electronically: it sweeps mechanically, and interpretation remains entirely human.\n\n## Operational career\nIt patrolled the Atlantic and Pacific approaches to the American continent throughout the Cold War, relieving the radar picket ships. Over **Vietnam** it became the nerve centre of air combat: an EC-121 detected MiGs on take-off and guided Phantoms onto them — it claimed twenty-five successful interceptions. In 1969 an EC-121 was shot down by North Korea over the Sea of Japan: thirty-one dead.\n\n## Place in history\nTwo hundred and thirty-two built. It invented a function — airborne early warning — that did not exist, and performed it alone for twenty years before the **E-3 Sentry** took it over with a single rotating antenna and computers. The doctrine itself has not changed: see far, see low, and direct.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1949-01-01',
    '1949-06-09',
    '1954-10-01',
    517.0,
    7400.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 35.41,
  wingspan          = 38.45,
  height            = 8.23,
  wing_area         = 153.3,
  empty_weight      = 36560,
  mtow              = 65600,
  service_ceiling   = 6200,
  climb_rate        = 4.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2800,
  crew              = 26,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-3350-34 Turbo-Compound',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1958,
  units_built       = 232,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **RC-121D / EC-121D** : guet aérien standard, radômes dorsal et ventral\n- **EC-121K / M** : versions de la marine, renseignement électronique\n- **EC-121R Batcat** : relais des capteurs sismiques largués sur la piste Hô Chi Minh\n- **EC-121T** : dernière version, retirée en 1978\n- Dérivé du **Lockheed Constellation**, avion de ligne au fuselage courbe caractéristique',
  variants_en       = E'- **RC-121D / EC-121D** : standard early warning, dorsal and ventral radomes\n- **EC-121K / M** : Navy versions, signals intelligence\n- **EC-121R Batcat** : relay for seismic sensors dropped on the Ho Chi Minh trail\n- **EC-121T** : final version, retired in 1978\n- Derived from the **Lockheed Constellation**, the airliner with the distinctive curved fuselage',

  -- Strate 4 : qualitatif
  nickname          = 'Warning Star',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_EC-121_Warning_Star',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_EC-121_Warning_Star',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Weston, Spalding, Lincs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'EC-121 Warning Star';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'EC-121 Warning Star';
