-- Northrop X-4 Bantam
--
-- Photo : Northrop X-4 060912-F-1234S-005.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:Northrop_X-4_060912-F-1234S-005.jpg

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
    'Northrop X-4 Bantam',
    'Northrop X-4 Bantam',
    'Northrop X-4 Bantam',
    'Northrop X-4 Bantam',
    'Biréacteur miniature sans empennage horizontal, qui prouva que cette formule ne convenait pas au transsonique',
    'A miniature twinjet without a horizontal tail, which proved the layout unfit for transonic flight',
    '/assets/airplanes/northrop-x4.jpg',
    E'## Genèse\nDans les années 1940, des aérodynamiciens pensent que supprimer l''empennage horizontal éviterait l''interaction entre les ondes de choc de l''aile et celles de la queue, jugée responsable de l''instabilité à l''approche de Mach 1. Deux appareils ont déjà essayé la formule : le **Messerschmitt Me 163** allemand et le **de Havilland DH.108** britannique. Le 11 juin 1946, les United States Army Air Forces commandent deux X-4 à **Northrop**, retenu pour son expérience des ailes volantes **N-9M**, **XB-35** et **YB-49**.\n\n## Conception\nLe X-4 est minuscule : juste assez grand pour loger deux réacteurs **Westinghouse J30**, un pilote, l''instrumentation et 45 minutes de carburant. Une personne debout au sol voit sans peine dans le cockpit, et presque tout l''entretien se fait sans échelle ni marchepied. Faute de plan horizontal, des **élevons** au bord de fuite de l''aile en flèche assurent à la fois le tangage et le roulis, tandis que des volets d''intrados servent aussi d''aérofreins.\n\n## Essais\nLe premier exemplaire vole le 15 décembre 1948 à Muroc, piloté par **Charles Tucker**, mais il se révèle si peu fiable que le responsable du NACA, **Walter C. Williams**, le qualifie de « citron » ; cloué au sol après dix vols, il sert de réserve de pièces. Le second, bien plus sûr, est confié au NACA, dont les pilotes, parmi lesquels **Scott Crossfield**, constatent dès Mach 0,88 un marsouinage croissant, un piqué spontané et des oscillations sur les trois axes, annonce du couplage inertiel. Des baguettes de balsa épaississant le bord de fuite repoussent le problème jusqu''à Mach 0,92 environ. Des essais d''atterrissage à très faible finesse préparent aussi les futurs avions-fusées, jusqu''au 81e et dernier vol NACA, le 29 septembre 1953.\n\n## Place dans l''histoire\nLe X-4 a surtout prouvé un résultat négatif : avec les commandes de vol de l''époque, une aile en flèche sans empennage horizontal ne convient pas au vol proche de Mach 1. Les concepteurs ont ainsi évité une impasse et se sont tournés vers le delta. Il faudra les commandes de vol électriques pour que la formule revienne, sous d''autres formes, sur le **X-36**, **Have Blue** et le **F-117**. Les deux exemplaires sont conservés, à Edwards et au musée de l''US Air Force.',
    E'## Genesis\nIn the 1940s some aerodynamicists believed that removing the horizontal tail would avoid the interaction between the shock waves of the wing and those of the tail, thought to cause instability near Mach 1. Two aircraft had already tried the layout: the German **Messerschmitt Me 163** and the British **de Havilland DH.108**. On 11 June 1946 the United States Army Air Forces ordered two X-4s from **Northrop**, chosen for its experience with the **N-9M**, **XB-35** and **YB-49** flying wings.\n\n## Design\nThe X-4 was tiny: just large enough to hold two **Westinghouse J30** turbojets, a pilot, instrumentation and 45 minutes of fuel. A person standing on the ground could easily look into the cockpit, and nearly all maintenance could be done without a ladder or footstool. With no tailplane, **elevons** on the trailing edge of the swept wing handled both pitch and roll, while split flaps doubled as speed brakes.\n\n## Testing\nThe first aircraft flew on 15 December 1948 at Muroc, piloted by **Charles Tucker**, but proved so unreliable that the NACA''s **Walter C. Williams** called it a lemon; grounded after ten flights, it became a source of spare parts. The second, far more dependable, was handed to the NACA, whose pilots, among them **Scott Crossfield**, found that from Mach 0.88 it entered a growing pitch oscillation, a nose-down tuck and a hunting motion about all three axes, a precursor of inertia coupling. Balsa strips thickening the trailing edge pushed the problem back to about Mach 0.92. Very low lift-to-drag landing tests also prepared for future rocket aircraft, until the 81st and final NACA flight on 29 September 1953.\n\n## Place in history\nThe X-4 mainly proved a negative: with the flight controls of the day, a swept wing without a horizontal tail was unsuited to flight near Mach 1. Designers thus avoided a dead end and turned to the delta. Fly-by-wire controls were needed before the layout returned, in other shapes, on the **X-36**, **Have Blue** and the **F-117**. Both aircraft survive, at Edwards and at the US Air Force museum.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1946-06-11',
    '1948-12-15',
    NULL,
    1006,
    680,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop X-4 Bantam'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop X-4 Bantam'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.09,
  wingspan          = 8.18,
  height            = 4.52,
  wing_area         = 18.6,
  empty_weight      = 2498,
  mtow              = 3547,
  service_ceiling   = 12900,
  climb_rate        = 39,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse J30-WE-7 / WE-9',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 7.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **46-676** : premier exemplaire, premier vol le 15 décembre 1948, retiré après dix vols et utilisé comme réserve de pièces\n- **46-677** : second exemplaire, 20 vols constructeur puis 81 vols pour le NACA jusqu''au 29 septembre 1953\n- **Bord de fuite épaissi** : baguettes de balsa sur les volets et les élevons, essayées en 1951 et 1952 pour retarder l''instabilité\n- **Volets-aérofreins** en coquille, capables de ramener la finesse sous 3 pour simuler l''atterrissage d''un avion-fusée',
  variants_en       = E'- **46-676**: first aircraft, first flight on 15 December 1948, retired after ten flights and used for spare parts\n- **46-677**: second aircraft, 20 contractor flights then 81 NACA flights until 29 September 1953\n- **Thickened trailing edge**: balsa strips on the flaps and elevons, tried in 1951 and 1952 to delay instability\n- **Clamshell flap-speed brakes**, able to cut the lift-to-drag ratio below 3 to simulate a rocket aircraft landing',

  -- Strate 4 : qualitatif
  nickname          = 'Bantam',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_X-4_Bantam',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_X-4_Bantam',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Northrop X-4 Bantam';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Northrop X-4 Bantam';
