-- Grumman F11F Tiger
--
-- Photo : Grumman F11F-1 Tiger in flight c1956.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3AGrumman_F11F-1_Tiger_in_flight_c1956.jpg

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
    'F11F Tiger',
    'F11F Tiger',
    'Grumman F11F Tiger',
    'Grumman F11F Tiger',
    'Le chasseur qui s’est abattu lui-même avec ses propres obus',
    'The fighter that shot itself down with its own gunfire',
    '/assets/airplanes/f11f-tiger.jpg',
    E'## Genèse\nGrumman poursuit sa lignée féline — Panther, Cougar, puis Tiger — en cherchant cette fois le supersonique. La contrainte reste la même depuis 1946 : tenir sur un pont d''envol. Le Tiger est le premier chasseur embarqué américain dessiné selon la **loi des aires**, cette règle aérodynamique qui veut qu''on resserre le fuselage là où l''aile est la plus large.\n\n## Conception\nD''où sa silhouette en bouteille de Coca-Cola, très marquée. L''aile est mince, en flèche à 35°, et se replie **vers le bas** en bout — solution rare, choisie pour gagner de la place sans mécanisme lourd. Le réacteur J65, un Sapphire britannique construit sous licence, est le point faible : il manque de poussée et limite l''appareil à Mach 1,1, quand le F8U Crusader concurrent atteint Mach 1,8.\n\n## Carrière opérationnelle\nSa carrière de chasseur est brève — quatre ans en escadre, éclipsé par le Crusader. Le **21 septembre 1956**, l''appareil de Tom Attridge tire une rafale de 20 mm en descente, puis rattrape ses propres obus qui, ralentis par l''air, retombaient sur sa trajectoire : trois impacts, moteur détruit, atterrissage forcé. C''est le premier cas documenté d''un avion s''abattant lui-même.\n\n## Place dans l''histoire\nDeux cents exemplaires. Sa vraie carrière est publique : les **Blue Angels** le volent douze ans, de 1957 à 1969, plus longtemps que n''importe quel autre appareil de la patrouille avant le Hornet. La version Super Tiger, à réacteur J79, atteignait Mach 2 mais n''a jamais trouvé preneur — le **F-8 Crusader** avait déjà pris la place.',
    E'## Genesis\nGrumman continued its feline line — Panther, Cougar, then Tiger — this time chasing supersonic speed. The constraint had not changed since 1946: it had to work on a flight deck. The Tiger is the first American carrier fighter drawn to the **area rule**, the aerodynamic principle that pinches the fuselage where the wing is widest.\n\n## Design\nHence its pronounced Coke-bottle shape. The wing is thin, swept 35°, and folds **downward** at the tips — a rare solution chosen to save space without heavy mechanism. The J65 engine, a licence-built British Sapphire, is the weak point: it lacks thrust and limits the aircraft to Mach 1.1, when the competing F8U Crusader reached Mach 1.8.\n\n## Operational career\nIts fighter career was brief — four years in squadrons, eclipsed by the Crusader. On **21 September 1956** Tom Attridge''s aircraft fired a 20 mm burst in a descent, then caught up with its own shells, which the air had slowed onto its flight path: three hits, engine destroyed, forced landing. It is the first documented case of an aircraft shooting itself down.\n\n## Place in history\nTwo hundred built. Its real career was public: the **Blue Angels** flew it for twelve years, from 1957 to 1969, longer than any other display aircraft before the Hornet. The J79-powered Super Tiger reached Mach 2 but never found a buyer — the **F-8 Crusader** had already taken the place.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1952-04-01',
    '1954-07-30',
    '1957-03-08',
    1207.0,
    2044.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F11F Tiger'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F11F Tiger'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'F11F Tiger'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F11F Tiger'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'F11F Tiger'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F11F Tiger'), (SELECT id FROM armement WHERE name = 'FFAR Mighty Mouse'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F11F Tiger'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F11F Tiger'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F11F Tiger'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.31,
  wingspan          = 9.64,
  height            = 4.03,
  wing_area         = 23.23,
  empty_weight      = 6091,
  mtow              = 10052,
  service_ceiling   = 12770,
  climb_rate        = 53.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Wright J65-W-18',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 33.4,
  thrust_wet        = 47.6,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1959,
  units_built       = 200,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **F11F-1** : version de série unique, redésignée **F-11A** en 1962\n- **F11F-1F Super Tiger** : réacteur J79, atteint Mach 2, deux exemplaires, sans client\n- **Blue Angels** : patrouille acrobatique de l''US Navy de 1957 à 1969, douze ans\n- Premier chasseur embarqué américain conçu selon la **loi des aires**\n- Le 21 septembre 1956, l''appareil d''essai de Tom Attridge rattrape sa propre rafale',
  variants_en       = E'- **F11F-1** : the sole production version, redesignated **F-11A** in 1962\n- **F11F-1F Super Tiger** : J79-powered, reached Mach 2, two built, no customer\n- **Blue Angels** : the US Navy display team''s mount from 1957 to 1969, twelve years\n- First American carrier fighter designed to the **area rule**\n- On 21 September 1956 Tom Attridge''s test aircraft caught up with its own burst',

  -- Strate 4 : qualitatif
  nickname          = 'Tiger',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_F-11_Tiger',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_F-11_Tiger',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'F11F Tiger';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F11F Tiger';
