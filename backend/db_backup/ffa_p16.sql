-- FFA P-16
--
-- Photo : Erster Prototyp P-16 J-3001 in Altenrhein Com C05-160-001-006.jpg
--   licence CC BY-SA 4.0 — Comet Photo AG
--   https://commons.wikimedia.org/wiki/File%3AErster_Prototyp_P-16_J-3001_in_Altenrhein_Com_C05-160-001-006.jpg

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
    'FFA P-16',
    'FFA P-16',
    'FFA P-16',
    'FFA P-16',
    'Chasseur suisse d’attaque alpine, coulé par deux amerrissages dans un lac',
    'Swiss alpine attack fighter, sunk by two ditchings in a lake',
    '/assets/airplanes/ffa-p16.jpg',
    E'## Genèse\nLa Suisse a un problème de terrain autant que de neutralité : ses aérodromes sont courts, coincés entre des montagnes, et un appareil de combat doit y opérer par mauvais temps. Aucun chasseur étranger n''est conçu pour cela. En 1948, la Confédération lance donc son propre programme, confié à la Flug- und Fahrzeugwerke d''Altenrhein, sur les rives du lac de Constance.\n\n## Conception\nAile droite épaisse à réservoirs de bout d''aile, choisie pour la portance et la manœuvrabilité à basse vitesse — exactement l''inverse de la mode de l''époque, qui allait à la flèche. Le P-16 doit voler bas dans les vallées, virer serré, et se poser court. Son réacteur Sapphire britannique et ses trente-huit roquettes en font, sur le papier, un excellent appareil d''attaque alpine.\n\n## Carrière opérationnelle\nAucune. Le 31 août 1955, le premier prototype amerrit dans le **lac de Constance** après une panne hydraulique ; le pilote s''éjecte. La Confédération commande néanmoins cent appareils. Le 25 mars 1958, un second exemplaire **tombe dans le même lac**. Le lendemain, le Conseil fédéral annule la commande. Le programme est mort en vingt-quatre heures.\n\n## Place dans l''histoire\nCinq exemplaires. La Suisse achètera des **Hawker Hunter** puis des **Mirage III**, et ne concevra plus jamais d''avion de combat. L''histoire a pourtant une suite inattendue : l''aile du P-16, jugée excellente, est rachetée par l''Américain Bill Lear — elle devient celle du **Learjet 23**, premier avion d''affaires à réaction produit en série.',
    E'## Genesis\nSwitzerland had a problem of terrain as much as of neutrality: its airfields are short, hemmed in by mountains, and a combat aircraft must work from them in bad weather. No foreign fighter was designed for that. In 1948 the Confederation therefore launched its own programme, entrusted to the Flug- und Fahrzeugwerke at Altenrhein, on the shore of Lake Constance.\n\n## Design\nA thick straight wing with tip tanks, chosen for lift and low-speed handling — exactly against the fashion of the day, which was going to sweep. The P-16 had to fly low in valleys, turn tightly and land short. Its British Sapphire engine and thirty-eight rockets made it, on paper, an excellent Alpine attack aircraft.\n\n## Operational career\nNone. On 31 August 1955 the first prototype ditched in **Lake Constance** after a hydraulic failure; the pilot ejected. The Confederation nevertheless ordered a hundred aircraft. On 25 March 1958 a second example **fell into the same lake**. The following day the Federal Council cancelled the order. The programme died in twenty-four hours.\n\n## Place in history\nFive built. Switzerland would buy **Hawker Hunters** and then **Mirage IIIs**, and never design a combat aircraft again. The story has an unexpected sequel, however: the P-16''s wing, judged excellent, was bought by the American Bill Lear — it became that of the **Learjet 23**, the first series-produced business jet.',
    (SELECT id FROM countries WHERE code = 'CHE'),
    '1948-01-01',
    '1955-04-28',
    NULL,
    1120.0,
    1000.0,
    (SELECT id FROM manufacturer WHERE code = 'FFA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'FFA P-16'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'FFA P-16'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'FFA P-16'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'FFA P-16'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'FFA P-16'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'FFA P-16'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.26,
  wingspan          = 11.15,
  height            = 4.2,
  wing_area         = 30.0,
  empty_weight      = 7000,
  mtow              = 11880,
  service_ceiling   = 14000,
  climb_rate        = 63.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 350,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Armstrong Siddeley Sapphire ASSa.7',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 49.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1960,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **P-16.04 / .05** : prototypes successifs, cinq exemplaires au total\n- Deux appareils amerrissent dans le **lac de Constance**, en 1955 puis en 1958\n- Commande de cent exemplaires **annulée le lendemain** du second accident\n- Aile droite à réservoirs de bout d''aile, conçue pour la manœuvre en vallée alpine\n- Son aile sera rachetée par **Bill Lear** et deviendra celle du **Learjet 23**',
  variants_en       = E'- **P-16.04 / .05** : successive prototypes, five aircraft in all\n- Two aircraft ditched in **Lake Constance**, in 1955 and again in 1958\n- An order for a hundred was **cancelled the day after** the second accident\n- Straight wing with tip tanks, designed for manoeuvring in Alpine valleys\n- Its wing was bought by **Bill Lear** and became that of the **Learjet 23**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/FFA_P-16',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/FFA_P-16',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Comet Photo AG',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'FFA P-16';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'FFA P-16';
