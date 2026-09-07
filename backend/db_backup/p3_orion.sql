-- Lockheed P-3 Orion
--
-- Photo : "World Watchers" Final Operational Flight of P-3 Orion (8815788).jpg
--   licence Public domain — U.S. Navy photo by Petty Officer 2nd Class Alec Kramer
--   https://commons.wikimedia.org/wiki/File%3A%22World_Watchers%22_Final_Operational_Flight_of_P-3_Orion_%288815788%29.jpg

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
    'P-3 Orion',
    'P-3 Orion',
    'Lockheed P-3 Orion',
    'Lockheed P-3 Orion',
    'Patrouilleur maritime occidental de référence, dérivé d’un avion de ligne',
    'The West’s standard maritime patrol aircraft, derived from an airliner',
    '/assets/airplanes/p3-orion.jpg',
    E'## Genèse\nEn 1957, l''US Navy veut remplacer ses patrouilleurs à pistons sans financer un programme complet. Lockheed propose de partir de son avion de ligne **L-188 Electra**, déjà en production : fuselage raccourci, soute à armement ventrale, perche magnétique en queue. Du contrat au premier vol, il s''écoule deux ans.\n\n## Conception\nQuatre turbopropulseurs T56 pour une endurance de plus de **douze heures**, avec possibilité d''éteindre deux moteurs en patrouille pour économiser le carburant. L''appareil emporte des bouées acoustiques, un détecteur d''anomalies magnétiques dans sa perche de queue, et jusqu''à neuf tonnes d''armement — torpilles, mines, missiles antinavires.\n\n## Carrière opérationnelle\nSept cent cinquante-sept exemplaires et dix-sept pays. Le P-3 traque les sous-marins soviétiques pendant toute la guerre froide, puis se reconvertit en plateforme de surveillance au-dessus de l''Irak et de l''Afghanistan — un patrouilleur maritime employé au-dessus du désert, faute de mieux pour observer longuement une zone.\n\n## Place dans l''histoire\nSoixante ans de service, encore actif dans une dizaine de marines. Son remplaçant, le **P-8 Poseidon**, reprend exactement la même méthode : partir d''un avion de ligne éprouvé plutôt que de concevoir une cellule militaire spécifique.',
    E'## Genesis\nIn 1957 the US Navy wanted to replace its piston patrol aircraft without funding a full programme. Lockheed offered to start from its **L-188 Electra** airliner, already in production: shortened fuselage, ventral weapons bay, magnetic boom in the tail. Two years passed from contract to first flight.\n\n## Design\nFour T56 turboprops for more than **twelve hours** of endurance, with the option of shutting down two engines on patrol to save fuel. The aircraft carries sonobuoys, a magnetic anomaly detector in its tail boom, and up to nine tonnes of weapons — torpedoes, mines, anti-ship missiles.\n\n## Operational career\nSeven hundred and fifty-seven built and seventeen operators. The P-3 hunted Soviet submarines throughout the Cold War, then converted into a surveillance platform over Iraq and Afghanistan — a maritime patrol aircraft used over the desert, for want of anything better able to watch an area for hours.\n\n## Place in history\nSixty years of service, still active with a dozen navies. Its replacement, the **P-8 Poseidon**, uses exactly the same method: start from a proven airliner rather than design a bespoke military airframe.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1957-01-01',
    '1959-11-25',
    '1962-08-13',
    750.0,
    8944.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM armement WHERE name = 'Mk 82'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 35.61,
  wingspan          = 30.38,
  height            = 11.85,
  wing_area         = 120.77,
  empty_weight      = 35017,
  mtow              = 64410,
  service_ceiling   = 8600,
  climb_rate        = 16,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3835,
  crew              = 11,

  -- Strate 2 : motorisation
  engine_name       = 'Allison T56-A-14',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1961,
  production_end    = 1990,
  units_built       = 757,
  unit_cost_usd     = 36000000,
  unit_cost_year    = 1990,
  operators_count   = 17,
  variants          = E'- **P-3A / B / C** : versions de patrouille maritime successives\n- **EP-3E Aries** : renseignement électronique ; un exemplaire contraint de se poser en **Chine** en 2001 après collision avec un J-8\n- **AP-3C** : version australienne modernisée\n- **P-8 Poseidon** : successeur, bâti sur un Boeing 737',
  variants_en       = E'- **P-3A / B / C** : successive maritime patrol versions\n- **EP-3E Aries** : signals intelligence; one was forced to land in **China** in 2001 after a collision with a J-8\n- **AP-3C** : upgraded Australian version\n- **P-8 Poseidon** : successor, built on a Boeing 737',

  -- Strate 4 : qualitatif
  nickname          = 'Orion',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_P-3_Orion',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_P-3_Orion',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy photo by Petty Officer 2nd Class Alec Kramer',
  image_licence     = 'Public domain'
WHERE name = 'P-3 Orion';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'P-3 Orion';
