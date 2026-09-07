-- LTV A-7 Corsair II
--
-- Photo : A-7E Corsair II of VA-146 in flight on 16 November 1974 (NNAM.1996.253.7100.039).jpg
--   licence Public domain — Robert L. Lawson, U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3AA-7E_Corsair_II_of_VA-146_in_flight_on_16_November_1974_%28NNAM.1996.253.7100.039%29.jpg

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
    'A-7 Corsair II',
    'A-7 Corsair II',
    'LTV A-7 Corsair II',
    'LTV A-7 Corsair II',
    'Avion d’attaque subsonique à la précision de frappe inédite',
    'Subsonic attack aircraft with unprecedented bombing accuracy',
    '/assets/airplanes/a7-corsair-2.jpg',
    E'## Genèse\nEn 1963, l''US Navy veut remplacer l''A-4 Skyhawk par un appareil emportant deux fois plus de bombes deux fois plus loin. Vought propose une version raccourcie et subsonique de son **F-8 Crusader** : en renonçant délibérément au vol supersonique, le projet gagne en carburant, en emport et en simplicité. Du dessin au premier vol, il s''écoule moins de deux ans.\n\n## Conception\nLa rupture est dans l''avionique. L''A-7D/E embarque une centrale inertielle couplée à un radar Doppler et un **viseur tête haute** — le premier d''un avion de série américain. Le calculateur résout le problème balistique en continu : les équipages atteignent en piqué une précision que les appareils précédents n''obtenaient qu''en bombardement guidé.\n\n## Carrière opérationnelle\nVietnam d''abord, puis les opérations sur le **Liban** en 1983 et la **guerre du Golfe**, où les A-7E tirent les premiers missiles antiradar de la campagne avant d''être retirés dans la foulée. La Grèce l''utilisera jusqu''en 2014, quarante-sept ans après sa mise en service.\n\n## Place dans l''histoire\nLe SLUF — *Short Little Ugly Fellow*, comme le surnomment ses équipages — est le premier avion d''attaque occidental dont la précision tient à son calculateur plutôt qu''à l''œil du pilote. C''est le chaînon entre le Skyhawk et le F/A-18, et le prédécesseur direct du A-10 dans l''appui de l''US Air Force.',
    E'## Genesis\nIn 1963 the US Navy wanted an A-4 Skyhawk replacement carrying twice the bombs twice as far. Vought offered a shortened, subsonic version of its **F-8 Crusader**: by deliberately giving up supersonic flight, the design gained fuel, payload and simplicity. Less than two years passed from drawing to first flight.\n\n## Design\nThe breakthrough was in the avionics. The A-7D/E carried an inertial platform coupled to a Doppler radar and a **head-up display** — the first on an American production aircraft. Its computer solved the ballistic problem continuously: crews achieved dive-bombing accuracy that earlier aircraft only reached with guided weapons.\n\n## Operational career\nVietnam first, then operations over **Lebanon** in 1983 and the **Gulf War**, where A-7Es fired the campaign’s first anti-radiation missiles before being retired immediately afterwards. Greece flew it until 2014, forty-seven years after it entered service.\n\n## Place in history\nThe SLUF — *Short Little Ugly Fellow*, as its crews called it — was the first Western attack aircraft whose accuracy came from its computer rather than the pilot’s eye. It is the link between the Skyhawk and the F/A-18, and the direct predecessor of the A-10 in USAF close air support.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1963-01-01',
    '1965-09-27',
    '1967-02-01',
    1123.0,
    4600.0,
    (SELECT id FROM manufacturer WHERE code = 'LTV'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM armement WHERE name = 'AGM-45 Shrike')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM armement WHERE name = 'GBU-10 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM armement WHERE name = 'Zuni 127 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM wars WHERE name = 'Guerre du Liban')),
((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.06,
  wingspan          = 11.81,
  height            = 4.9,
  wing_area         = 34.8,
  empty_weight      = 8986,
  mtow              = 19050,
  service_ceiling   = 12800,
  climb_rate        = 76,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.0,
  combat_radius     = 1127,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison TF41-A-2',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 66.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1965,
  production_end    = 1984,
  units_built       = 1569,
  unit_cost_usd     = 2860000,
  unit_cost_year    = 1970,
  operators_count   = 4,
  variants          = E'- **A-7A/B/C** : premières versions de l''US Navy\n- **A-7D** : version US Air Force, canon M61 et moteur TF41\n- **A-7E** : version navale définitive, viseur tête haute\n- **A-7P / TA-7C** : versions portugaise et biplace d''entraînement',
  variants_en       = E'- **A-7A/B/C** : early US Navy versions\n- **A-7D** : US Air Force version with M61 gun and TF41 engine\n- **A-7E** : definitive naval version with head-up display\n- **A-7P / TA-7C** : Portuguese and two-seat training versions',

  -- Strate 4 : qualitatif
  nickname          = 'SLUF',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/LTV_A-7_Corsair_II',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/LTV_A-7_Corsair_II',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Robert L. Lawson, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'A-7 Corsair II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'A-7 Corsair II';
