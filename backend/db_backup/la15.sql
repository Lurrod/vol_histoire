-- Lavochkine La-15 (Fantail)
--
-- Photo : Lavochkin La-15 ‘212 white’ (39048469422).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3ALavochkin_La-15_%E2%80%98212_white%E2%80%99_%2839048469422%29.jpg

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
    'La-15',
    'La-15',
    'Lavochkine La-15 (Fantail)',
    'Lavochkin La-15 (Fantail)',
    'Le rival malheureux du MiG-15, écarté pour une question d’usine',
    'The MiG-15’s unlucky rival, dropped over a question of factories',
    '/assets/airplanes/la15.jpg',
    E'## Genèse\nL''URSS de 1947 met trois bureaux en concurrence sur le même moteur britannique et la même mission : un chasseur à aile en flèche. Mikoyan présente le MiG-15, Yakovlev le Yak-23, Lavochkine le La-15. Les essais donnent un résultat inconfortable : le La-15 **manœuvre mieux** que le MiG-15 et monte aussi vite, mais il est plus complexe à construire.\n\n## Conception\nLà où le MiG place son aile au milieu du fuselage, Lavochkine la monte **en position haute** et ajoute un empennage en T. L''aile, très mince, offre une meilleure finesse mais impose une structure délicate et un train d''atterrissage étroit, logé dans le fuselage. C''est précisément ce raffinement qui le condamne : il exige des ouvriers qualifiés que l''industrie soviétique n''a pas en nombre.\n\n## Carrière opérationnelle\nDeux cent trente-cinq exemplaires équipent quelques régiments de défense aérienne à partir de 1949. La décision tombe en 1953 : produire et entretenir deux chasseurs de même classe est un luxe. Le MiG-15, plus simple, produit à plus de dix-huit mille exemplaires, l''emporte pour des raisons de série, pas de performances. Les La-15 sont retirés en bloc.\n\n## Place dans l''histoire\nDeux cent trente-cinq exemplaires contre plus de dix-huit mille MiG-15 : l''écart ne mesure pas une différence de qualité mais une décision industrielle. Lavochkine, écarté de la chasse, se reconvertira dans les **missiles sol-air** — c''est son bureau qui concevra le S-75 qui abattra le U-2 de Gary Powers.',
    E'## Genesis\nThe USSR of 1947 set three bureaux against each other on the same British engine and the same mission: a swept-wing fighter. Mikoyan offered the MiG-15, Yakovlev the Yak-23, Lavochkin the La-15. Testing produced an uncomfortable result: the La-15 **manoeuvred better** than the MiG-15 and climbed as fast, but was harder to build.\n\n## Design\nWhere the MiG puts its wing mid-fuselage, Lavochkin mounted it **high** and added a T-tail. The very thin wing offers better efficiency but demands a delicate structure and a narrow undercarriage stowed in the fuselage. It is precisely that refinement that condemned it: it required skilled workers Soviet industry did not have in numbers.\n\n## Operational career\nTwo hundred and thirty-five aircraft equipped a few air defence regiments from 1949. The decision came in 1953: building and maintaining two fighters of the same class was a luxury. The simpler MiG-15, built in more than eighteen thousand examples, won for reasons of production, not performance. The La-15s were withdrawn together.\n\n## Place in history\nTwo hundred and thirty-five built against more than eighteen thousand MiG-15s: the gap measures not a difference in quality but an industrial decision. Lavochkin, pushed out of fighters, turned to **surface-to-air missiles** — it was his bureau that designed the S-75 that would shoot down Gary Powers''s U-2.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1947-01-01',
    '1948-01-08',
    '1949-01-01',
    1026.0,
    1170.0,
    (SELECT id FROM manufacturer WHERE code = 'LAV'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'La-15'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'La-15'), (SELECT id FROM armement WHERE name = 'NR-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'La-15'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'La-15'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'La-15'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.56,
  wingspan          = 8.83,
  height            = 3.8,
  wing_area         = 16.16,
  empty_weight      = 2575,
  mtow              = 3850,
  service_ceiling   = 13500,
  climb_rate        = 41.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 350,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Klimov RD-500',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 15.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1950,
  units_built       = 235,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **La-15** : version de série unique, aile haute et empennage en T\n- **La-174TK** : prototype à aile mince, base du programme\n- **La-200** : dérivé biplace tout-temps, resté prototype\n- Retiré dès 1953 : maintenir **deux chasseurs** au lieu d''un coûtait trop cher\n- Dernier chasseur de série du bureau Lavochkine, qui passera ensuite aux missiles',
  variants_en       = E'- **La-15** : the sole production version, high wing and T-tail\n- **La-174TK** : thin-wing prototype, the basis of the programme\n- **La-200** : two-seat all-weather derivative, never left prototype stage\n- Withdrawn as early as 1953: keeping **two fighters** instead of one cost too much\n- The last production fighter from the Lavochkin bureau, which then moved to missiles',

  -- Strate 4 : qualitatif
  nickname          = 'Fantail',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lavotchkine_La-15',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lavochkin_La-15',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'La-15';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'La-15';
