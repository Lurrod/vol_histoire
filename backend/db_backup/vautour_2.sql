-- Sud Aviation SO.4050 Vautour II
--
-- Photo : 640 Sud-Est 4050 Vautour IIB French Air Force (3251521518).jpg
--   licence CC BY 2.0 — Jerry Gunner from Lincoln, UK
--   https://commons.wikimedia.org/wiki/File%3A640_Sud-Est_4050_Vautour_IIB_French_Air_Force_%283251521518%29.jpg

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
    'Vautour II',
    'Vautour II',
    'Sud Aviation SO.4050 Vautour II',
    'Sud Aviation SO.4050 Vautour II',
    'Bombardier et chasseur français, pilier de l’aviation israélienne de 1967',
    'French bomber and fighter, mainstay of Israeli aviation in 1967',
    '/assets/airplanes/vautour-2.jpg',
    E'## Genèse\nLe Vautour répond à un programme français de 1951 qui demandait, chose rare, **un même appareil pour trois missions** : chasse de nuit, attaque au sol et bombardement. Trois versions distinctes sortiront de la même cellule — un pari industriel que peu de constructeurs ont tenté.\n\n## Conception\nAile en flèche montée en position médiane, deux Atar en nacelles sous voilure, train principal en tandem dans le fuselage avec des balancines en bout d''aile — une architecture empruntée aux bombardiers américains de l''époque. La soute interne accepte une charge substantielle, complétée par des points d''emport externes.\n\n## Carrière opérationnelle\nEn France, sa carrière est brève : le Mirage IV le supplante dans la frappe nucléaire. C''est **Israël** qui en tire le meilleur. Le 5 juin 1967, les Vautour israéliens frappent les terrains égyptiens les plus éloignés, hors de portée des Mirage III, lors de l''opération Focus. Ils volent encore en 1973.\n\n## Place dans l''histoire\nSeulement 149 exemplaires et deux utilisateurs, mais un rôle décisif dans le conflit le plus étudié de l''histoire aérienne moderne. Le Vautour illustre le moment où l''industrie française savait déjà concevoir, mais pas encore vendre.',
    E'## Genesis\nThe Vautour answered a 1951 French requirement that unusually asked for **one aircraft covering three missions**: night fighter, ground attack and bombing. Three distinct versions came out of the same airframe — an industrial gamble few manufacturers attempted.\n\n## Design\nA mid-mounted swept wing, two Atars in underwing nacelles, tandem main gear in the fuselage with outrigger wheels at the wingtips — an architecture borrowed from contemporary American bombers. The internal bay took a substantial load, supplemented by external hardpoints.\n\n## Operational career\nIn France its career was short: the Mirage IV displaced it in the nuclear strike role. It was **Israel** that got the most from it. On 5 June 1967 Israeli Vautours struck the most distant Egyptian airfields, beyond the reach of the Mirage IIIs, during Operation Focus. They were still flying in 1973.\n\n## Place in history\nOnly 149 built and two operators, but a decisive part in the most studied conflict in modern air history. The Vautour illustrates the moment when French industry already knew how to design, but not yet how to sell.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1951-01-01',
    '1952-10-16',
    '1958-01-01',
    1105.0,
    5400.0,
    (SELECT id FROM manufacturer WHERE code = 'SUD'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM armement WHERE name = 'Matra R530')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'Vautour II'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.57,
  wingspan          = 15.09,
  height            = 4.5,
  wing_area         = 45.0,
  empty_weight      = 10000,
  mtow              = 21000,
  service_ceiling   = 15000,
  climb_rate        = 60,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1000,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA Atar 101E-3',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 34.3,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1961,
  units_built       = 149,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Vautour IIA** : version d''attaque monoplace\n- **Vautour IIB** : bombardier biplace, nez vitré\n- **Vautour IIN** : chasseur de nuit biplace à radar\n- Israël exploitera les trois versions simultanément',
  variants_en       = E'- **Vautour IIA** : single-seat attack version\n- **Vautour IIB** : two-seat bomber with glazed nose\n- **Vautour IIN** : two-seat radar-equipped night fighter\n- Israel operated all three versions simultaneously',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/SNCASO_Vautour',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Sud_Aviation_Vautour',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jerry Gunner from Lincoln, UK',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Vautour II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Vautour II';
