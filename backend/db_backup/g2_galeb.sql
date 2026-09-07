-- Soko G-2 Galeb
--
-- Photo : Soko G2 Galeb (VH-YUE) at the 2013 Australian International Airshow.jpg
--   licence CC BY-SA 3.0 au — Bidgee
--   https://commons.wikimedia.org/wiki/File%3ASoko_G2_Galeb_%28VH-YUE%29_at_the_2013_Australian_International_Airshow.jpg

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
    'Soko G-2 Galeb',
    'Soko G-2 Galeb',
    'Soko G-2 Galeb',
    'Soko G-2 Galeb',
    'Le premier avion à réaction yougoslave, et le dernier à voler dans sa guerre',
    'Yugoslavia’s first jet aircraft, and the last to fly in its war',
    '/assets/airplanes/g2-galeb.jpg',
    E'## Genèse\nLa Yougoslavie de Tito refuse d''appartenir à l''un ou l''autre bloc, ce qui a une conséquence concrète : elle ne peut compter ni sur les livraisons soviétiques ni sur l''aide américaine. Elle doit donc fabriquer. En 1957, le bureau d''études de Mostar lance le premier avion à réaction yougoslave — un avion-école, la marche la plus accessible.\n\n## Conception\nLe Galeb est délibérément conventionnel : aile droite à réservoirs de bout, deux places en tandem, un réacteur **Viper** britannique acheté sous licence — la neutralité permet d''acheter à l''Ouest. L''aile est contrainte à huit g, bien au-delà de ce qu''exige la formation, et l''appareil reçoit d''emblée deux mitrailleuses et des points d''emport. C''est un école qui sait se battre.\n\n## Carrière opérationnelle\nDeux cent quarante-huit exemplaires, exportés vers la Libye et la Zambie. Quand la Yougoslavie se défait en 1991, ses Galeb se retrouvent des deux côtés du front et sont engagés en appui — souvent les seuls appareils disponibles. Plusieurs sont abattus par des missiles portables ; d''autres servent encore dans les forces successeurs jusqu''aux années 2000.\n\n## Place dans l''histoire\nDeux cent quarante-huit exemplaires. Le Galeb a donné à la Yougoslavie ce qu''aucun achat n''aurait pu lui donner : la capacité de concevoir, produire et entretenir un avion à réaction. Sa lignée continue avec le **J-22 Orao** et le **G-4 Super Galeb**, tous deux déjà au catalogue.',
    E'## Genesis\nTito''s Yugoslavia refused to belong to either bloc, which had a concrete consequence: it could count on neither Soviet deliveries nor American aid. So it had to manufacture. In 1957 the Mostar design office launched the first Yugoslav jet aircraft — a trainer, the most accessible step.\n\n## Design\nThe Galeb is deliberately conventional: a straight wing with tip tanks, two seats in tandem, a British **Viper** engine bought under licence — neutrality allows buying in the West. The wing is stressed to eight g, well beyond what training demands, and the aircraft carries two machine guns and hardpoints from the start. It is a trainer that can fight.\n\n## Operational career\nTwo hundred and forty-eight built, exported to Libya and Zambia. When Yugoslavia broke apart in 1991, its Galebs ended up on both sides of the front and flew ground attack — often the only aircraft available. Several were shot down by shoulder-launched missiles; others served in successor forces into the 2000s.\n\n## Place in history\nTwo hundred and forty-eight built. The Galeb gave Yugoslavia what no purchase could: the ability to design, build and maintain a jet aircraft. Its line continues with the **J-22 Orao** and the **G-4 Super Galeb**, both already in this catalogue.',
    (SELECT id FROM countries WHERE code = 'YUG'),
    '1957-01-01',
    '1961-05-03',
    '1965-01-01',
    812.0,
    1240.0,
    (SELECT id FROM manufacturer WHERE code = 'SOKO'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko G-2 Galeb'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko G-2 Galeb'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'Soko G-2 Galeb'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'Soko G-2 Galeb'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko G-2 Galeb'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Soko G-2 Galeb'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko G-2 Galeb'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.34,
  wingspan          = 11.62,
  height            = 3.28,
  wing_area         = 19.43,
  empty_weight      = 2620,
  mtow              = 4300,
  service_ceiling   = 12000,
  climb_rate        = 22.5,
  g_limit_pos       = 8.0,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Viper Mk 22-6',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 11.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1983,
  units_built       = 248,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **G-2A** : version d''entraînement de série, deux places en tandem\n- **G-2AE** : version export, livrée à la **Libye** et à la **Zambie**\n- **J-21 Jastreb** : dérivé monoplace d''attaque, à structure renforcée\n- *Galeb* signifie « **mouette** » en serbo-croate\n- Engagé dans les **guerres de Yougoslavie** de 1991 à 1995, de tous les côtés',
  variants_en       = E'- **G-2A** : production training version, two seats in tandem\n- **G-2AE** : export version, delivered to **Libya** and **Zambia**\n- **J-21 Jastreb** : single-seat attack derivative, with a strengthened structure\n- *Galeb* means ''**seagull**'' in Serbo-Croat\n- Used in the **Yugoslav Wars** from 1991 to 1995, on every side',

  -- Strate 4 : qualitatif
  nickname          = 'Galeb',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soko_G-2_Galeb',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Soko_G-2_Galeb',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bidgee',
  image_licence     = 'CC BY-SA 3.0 au'
WHERE name = 'Soko G-2 Galeb';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Soko G-2 Galeb';
