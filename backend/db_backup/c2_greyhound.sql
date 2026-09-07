-- Grumman C-2A Greyhound
--
-- Photo : Grumman C-2A Greyhound of VR-24 in flight over the Mediterranean Sea on 1 July 1988 (6440873).jpg
--   licence Public domain — LCdr. John R. Leenhouts, U.S. Navy
--   https://commons.wikimedia.org/wiki/File%3AGrumman_C-2A_Greyhound_of_VR-24_in_flight_over_the_Mediterranean_Sea_on_1_July_1988_%286440873%29.jpg

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
    'C-2 Greyhound',
    'C-2 Greyhound',
    'Grumman C-2A Greyhound',
    'Grumman C-2A Greyhound',
    'Le cordon ombilical du porte-avions pendant cinquante-huit ans',
    'The carrier’s umbilical cord for fifty-eight years',
    '/assets/airplanes/c2-greyhound.jpg',
    E'## Genèse\nUn porte-avions embarque cinq mille hommes et emporte des pièces détachées pour quelques semaines. Au-delà, il dépend d''un cordon logistique. Dans les années 1960, ce cordon est assuré par de vieux **C-1 Trader** à pistons, trop lents et trop petits. La Navy veut mieux — et veut surtout que l''appareil existe vite.\n\n## Conception\nGrumman applique la méthode la plus économique : reprendre le **E-2 Hawkeye**, déjà embarqué, et n''en changer que le fuselage. Aile repliable, empennage à quatre dérives, moteurs T56 : tout est commun. Le fuselage neuf est large, à plancher renforcé et rampe arrière, et peut emporter **quatre tonnes et demie**, vingt-six passagers ou un réacteur F110 complet.\n\n## Carrière opérationnelle\nCinquante-huit exemplaires. De 1966 à 2024, le Greyhound apporte aux porte-avions américains les pièces, le courrier, les équipages et les blessés. Il assure des évacuations sanitaires depuis le Vietnam, ravitaille les groupes engagés en Irak et en Afghanistan, et est le premier appareil à apponter sur chaque nouveau porte-avions.\n\n## Place dans l''histoire\nCinquante-huit exemplaires pour **cinquante-huit ans de service** — l''un des plus longs de l''aéronavale américaine. Son remplaçant, le **CMV-22B Osprey**, va plus loin et se pose sur n''importe quel navire, mais emporte moins et ne peut pas avaler un réacteur entier : la Navy expédie désormais les moteurs par la mer.',
    E'## Genesis\nA carrier holds five thousand men and carries spares for a few weeks. Beyond that it depends on a logistic umbilical. In the 1960s that cord was held by old piston-engined **C-1 Traders**, too slow and too small. The Navy wanted better — and above all wanted the aircraft soon.\n\n## Design\nGrumman applied the most economical method: take the **E-2 Hawkeye**, already carrier-qualified, and change only the fuselage. Folding wing, four-fin tail, T56 engines: all shared. The new fuselage is wide, with a strengthened floor and rear ramp, and can carry **four and a half tonnes**, twenty-six passengers or a complete F110 engine.\n\n## Operational career\nFifty-eight built. From 1966 to 2024 the Greyhound brought American carriers their parts, mail, aircrew and casualties. It flew medical evacuations from Vietnam, resupplied groups committed over Iraq and Afghanistan, and was the first aircraft to land aboard every new carrier.\n\n## Place in history\nFifty-eight built for **fifty-eight years of service** — among the longest in American naval aviation. Its replacement, the **CMV-22B Osprey**, goes further and lands on any ship, but carries less and cannot swallow a whole engine: the Navy now ships engines by sea.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1962-01-01',
    '1964-11-18',
    '1966-12-01',
    574.0,
    2891.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'C-2 Greyhound'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'C-2 Greyhound'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'C-2 Greyhound'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'C-2 Greyhound'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'C-2 Greyhound'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.32,
  wingspan          = 24.56,
  height            = 4.85,
  wing_area         = 65.03,
  empty_weight      = 15310,
  mtow              = 24655,
  service_ceiling   = 10210,
  climb_rate        = 13.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1300,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Allison T56-A-425',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1965,
  production_end    = 1989,
  units_built       = 58,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **C-2A** : version d''origine, dix-neuf exemplaires livrés de 1966 à 1968\n- **C-2A(R)** : seconde série de trente-neuf appareils, produite de 1985 à 1989\n- Dérivé du **E-2 Hawkeye**, dont il reprend l''aile, l''empennage et les moteurs\n- Mission **COD** : *Carrier Onboard Delivery*, ravitaillement du groupe aéronaval\n- Retiré en **2024**, remplacé par le **CMV-22B Osprey** à rotors basculants',
  variants_en       = E'- **C-2A** : original version, nineteen delivered between 1966 and 1968\n- **C-2A(R)** : second batch of thirty-nine aircraft, built from 1985 to 1989\n- Derived from the **E-2 Hawkeye**, reusing its wing, tail and engines\n- **COD** mission: *Carrier Onboard Delivery*, resupply of the carrier group\n- Retired in **2024**, replaced by the tiltrotor **CMV-22B Osprey**',

  -- Strate 4 : qualitatif
  nickname          = 'Greyhound',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_C-2_Greyhound',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_C-2_Greyhound',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'LCdr. John R. Leenhouts, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'C-2 Greyhound';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'C-2 Greyhound';
