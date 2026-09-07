-- Antonov An-22 Antei (Cock)
--
-- Photo : Antonov An-22A Antei aircraft.jpg
--   licence CC BY-SA 3.0 — Navigator-avia
--   https://commons.wikimedia.org/wiki/File%3AAntonov_An-22A_Antei_aircraft.jpg

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
    'Antonov An-22 Antei',
    'Antonov An-22 Antei',
    'Antonov An-22 Antei (Cock)',
    'Antonov An-22 Antei (Cock)',
    'Le plus gros avion à hélices jamais construit, toujours en vol',
    'The largest propeller aircraft ever built, and still flying',
    '/assets/airplanes/an22-antei.jpg',
    E'## Genèse\nL''URSS doit déplacer ses chars et ses missiles balistiques sur un territoire où la route et le rail s''arrêtent souvent. Antonov, à Kiev, reçoit en 1960 la commande d''un appareil capable de porter **cinquante tonnes** — le double de tout ce qui existe alors. Sa présentation au Salon du Bourget en 1965 stupéfie les observateurs occidentaux, qui n''imaginaient pas l''URSS capable d''un tel saut.\n\n## Conception\nQuatre **NK-12**, les turbopropulseurs les plus puissants jamais construits, déjà employés sur le Tu-95. Chacun entraîne deux hélices contrarotatives de six mètres vingt : le bruit est tel qu''il reste audible à des dizaines de kilomètres, et le souffle interdit toute présence au sol près des moteurs. Double dérive pour tenir dans les hangars, quatorze roues à basse pression pour les terrains meubles, et une soute pressurisée assez vaste pour deux chars d''assaut.\n\n## Carrière opérationnelle\nIl achemine les blindés soviétiques en Égypte, en Angola, en Éthiopie et surtout en **Afghanistan**, où il porte l''essentiel du matériel lourd pendant dix ans. Il transporte aussi l''aide humanitaire après les grands séismes, dont celui d''Arménie en 1988. En version PZ, il convoie sur son dos des sections de fuselage trop grandes pour tenir dedans.\n\n## Place dans l''histoire\nSoixante-huit exemplaires, et un record que rien n''a jamais menacé : c''est le **plus gros avion à hélices de l''histoire**. Il a prouvé que le bureau de Kiev pouvait tenir tête aux Américains sur le très lourd, ce qu''Antonov confirmera avec l''**An-124** puis l''An-225. Un seul appareil reste aujourd''hui en état de vol.',
    E'## Genesis\nThe USSR had to move its tanks and ballistic missiles across a territory where road and rail often stop. In 1960 Antonov, in Kyiv, was ordered to build an aircraft able to carry **fifty tonnes** — twice anything then in existence. Its appearance at the 1965 Paris Air Show astonished Western observers, who had not imagined the USSR capable of such a leap.\n\n## Design\nFour **NK-12s**, the most powerful turboprops ever built, already used on the Tu-95. Each drives two contra-rotating propellers six metres twenty across: the noise is such that it carries for tens of kilometres, and the slipstream bars anyone from the ground near the engines. Twin fins to fit hangars, fourteen low-pressure wheels for soft fields, and a pressurised hold large enough for two battle tanks.\n\n## Operational career\nIt carried Soviet armour to Egypt, Angola, Ethiopia and above all **Afghanistan**, where it moved the bulk of the heavy equipment for ten years. It also carried humanitarian aid after major earthquakes, including Armenia in 1988. In PZ form it ferried fuselage sections too large to fit inside, carried on its back.\n\n## Place in history\nSixty-eight built, and a record nothing has ever threatened: it is the **largest propeller aircraft in history**. It proved that the Kyiv bureau could match the Americans in the very heavy class, which Antonov would confirm with the **An-124** and then the An-225. A single aircraft remains airworthy today.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1960-01-01',
    '1965-02-27',
    '1969-01-01',
    740.0,
    5000.0,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 57.9,
  wingspan          = 64.4,
  height            = 12.53,
  wing_area         = 345.0,
  empty_weight      = 114000,
  mtow              = 250000,
  service_ceiling   = 7500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4200,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Kuznetsov NK-12MA',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1966,
  production_end    = 1976,
  units_built       = 68,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **An-22** : version de série, transport lourd et largage de blindés\n- **An-22PZ** : version de convoyage, portant des tronçons d''avion **sur le dos**\n- **Hélices contrarotatives de 6,2 m** : les plus grandes jamais montées sur un avion\n- A détenu quarante et un records du monde de charge et d''altitude\n- Un seul exemplaire reste en état de vol, exploité par la Russie',
  variants_en       = E'- **An-22** : production version, heavy transport and armour dropping\n- **An-22PZ** : ferry version, carrying aircraft sections **on its back**\n- **6.2 m contra-rotating propellers** : the largest ever fitted to an aircraft\n- Held forty-one world records for load and altitude\n- A single airworthy aircraft remains, operated by Russia',

  -- Strate 4 : qualitatif
  nickname          = 'Cock',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-22',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-22',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Navigator-avia',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Antonov An-22 Antei';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-22 Antei';
