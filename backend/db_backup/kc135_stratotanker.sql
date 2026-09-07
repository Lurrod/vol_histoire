-- Boeing KC-135 Stratotanker
--
-- Photo : KC-135 Stratotanker 3 (27199272525).jpg
--   licence CC BY 2.0 — Ronnie Macdonald from Chelmsford and Largs, United Kingdom
--   https://commons.wikimedia.org/wiki/File%3AKC-135_Stratotanker_3_%2827199272525%29.jpg

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
    'KC-135 Stratotanker',
    'KC-135 Stratotanker',
    'Boeing KC-135 Stratotanker',
    'Boeing KC-135 Stratotanker',
    'Le ravitailleur qui donne son allonge mondiale à l’aviation américaine',
    'The tanker that gives American air power its global reach',
    '/assets/airplanes/kc135-stratotanker.jpg',
    E'## Genèse\nLe Strategic Air Command a des bombardiers à réaction, et des ravitailleurs à hélices trop lents pour les suivre. Boeing prend un risque financier considérable : la firme finance **sur ses fonds propres** un démonstrateur, le 367-80, en pariant qu''il servira à la fois de ravitailleur militaire et d''avion de ligne. Le pari fonde simultanément le KC-135 et le Boeing 707.\n\n## Conception\nAile en flèche à 35°, quatre réacteurs en nacelles pendulaires, et surtout la **perche rigide** inventée par Boeing : un opérateur allongé à l''arrière la pilote comme une aile, l''emboîte dans le réceptacle de l''avion ravitaillé et transfère jusqu''à trois tonnes par minute. Le KC-135 est plus étroit que le 707 civil, sa cabine n''étant pas destinée aux passagers mais aux réservoirs.\n\n## Carrière opérationnelle\nIl rend possible tout ce que l''aviation américaine fait loin de ses bases. Au Vietnam, les Stratotanker effectuent **presque deux cent mille ravitaillements**. En 1991, ils permettent au pont aérien vers le Golfe de fonctionner sans escale. Ils ont sauvé des centaines d''appareils endommagés en leur donnant le carburant du retour — plusieurs équipages ont ravitaillé en dessous des minima, en descendant vers un avion incapable de monter.\n\n## Place dans l''histoire\nHuit cent trois exemplaires, en service depuis **1957** : plus de soixante-sept ans, un record que seul le B-52 approche. La remotorisation de 1984 lui a donné une seconde vie complète. Son remplacement par le KC-46 traîne depuis quinze ans ; les derniers KC-135 voleront vraisemblablement au-delà de 2050, soit près d''un siècle de service pour un type.',
    E'## Genesis\nStrategic Air Command had jet bombers, and propeller-driven tankers too slow to keep up with them. Boeing took a considerable financial risk: the firm funded a demonstrator, the 367-80, **from its own money**, betting it would serve both as a military tanker and as an airliner. The gamble founded the KC-135 and the Boeing 707 at the same time.\n\n## Design\nA 35° swept wing, four engines on pylons, and above all the **flying boom** invented by Boeing: an operator lying at the rear flies it like a wing, seats it in the receiving aircraft''s receptacle and transfers up to three tonnes a minute. The KC-135 is narrower than the civil 707, its cabin being meant for tanks rather than passengers.\n\n## Operational career\nIt makes possible everything American air power does far from its bases. Over Vietnam, Stratotankers flew **almost two hundred thousand refuellings**. In 1991 they let the air bridge to the Gulf run without stopping. They have saved hundreds of damaged aircraft by giving them the fuel to get home — several crews have refuelled below minima, descending towards an aircraft unable to climb.\n\n## Place in history\nEight hundred and three built, in service since **1957**: more than sixty-seven years, a record only the B-52 approaches. The 1984 re-engining gave it a complete second life. Its replacement by the KC-46 has dragged on for fifteen years; the last KC-135s will probably fly beyond 2050, close to a century of service for one type.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1954-01-01',
    '1956-08-31',
    '1957-06-28',
    933.0,
    2419.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 41.53,
  wingspan          = 39.88,
  height            = 12.7,
  wing_area         = 226.0,
  empty_weight      = 44663,
  mtow              = 146285,
  service_ceiling   = 15200,
  climb_rate        = 15.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2419,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'CFM International F108-CF-100',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 97.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1965,
  units_built       = 803,
  unit_cost_usd     = 39600000,
  unit_cost_year    = 1998,
  operators_count   = 5,
  variants          = E'- **KC-135A** : version initiale à réacteurs J57, fumée noire caractéristique\n- **KC-135R** : remotorisée CFM56 en 1984, gain de 50 % de carburant transférable\n- **RC-135** : famille de renseignement électronique, dont le Rivet Joint\n- **EC-135 Looking Glass** : poste de commandement aéroporté, en alerte permanente 1961-1990\n- **KC-46 Pegasus** : successeur en cours de livraison, bâti sur un Boeing 767',
  variants_en       = E'- **KC-135A** : initial version with J57 engines and characteristic black smoke\n- **KC-135R** : re-engined with CFM56 in 1984, transferring 50 % more fuel\n- **RC-135** : signals intelligence family, including Rivet Joint\n- **EC-135 Looking Glass** : airborne command post, continuously airborne 1961-1990\n- **KC-46 Pegasus** : successor now being delivered, built on a Boeing 767',

  -- Strate 4 : qualitatif
  nickname          = 'Stratotanker',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_KC-135_Stratotanker',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_KC-135_Stratotanker',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ronnie Macdonald from Chelmsford and Largs, United Kingdom',
  image_licence     = 'CC BY 2.0'
WHERE name = 'KC-135 Stratotanker';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'KC-135 Stratotanker';
