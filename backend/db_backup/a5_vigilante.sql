-- North American A-5 Vigilante
--
-- Photo : A-5 Vigilante ECN-231.jpg
--   licence Public domain — NASA Dryden Flight Research Center
--   https://commons.wikimedia.org/wiki/File%3AA-5_Vigilante_ECN-231.jpg

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
    'A-5 Vigilante',
    'A-5 Vigilante',
    'North American A-5 Vigilante',
    'North American A-5 Vigilante',
    'Le plus grand et le plus rapide avion jamais embarqué sur porte-avions',
    'The largest and fastest aircraft ever to operate from a carrier',
    '/assets/airplanes/a5-vigilante.jpg',
    E'## Genèse\nÀ la fin des années 1950, l''US Navy veut sa part de la dissuasion nucléaire : un bombardier supersonique capable de décoller d''un porte-avions et de frapper l''URSS. Le Vigilante est la réponse — vingt-trois mètres de long, vingt-huit tonnes au décollage, Mach 2. Aucun appareil embarqué n''a jamais été aussi grand.\n\n## Conception\nL''appareil accumule les innovations : commandes de vol **entièrement électriques** — une première sur un avion de série —, entrées d''air à géométrie variable, centrale inertielle couplée à un calculateur numérique. Sa soute est **linéaire** : l''arme nucléaire, placée dans un tunnel entre les réacteurs, devait être éjectée vers l''arrière avec deux réservoirs vides. Le système n''a jamais fonctionné de façon fiable.\n\n## Carrière opérationnelle\nLa dissuasion navale passe aux sous-marins Polaris avant même que le Vigilante soit mûr. Reconverti en **RA-5C** de reconnaissance, il vole au Vietnam les missions les plus dangereuses de l''aéronavale : passages photographiques à basse altitude, seul et en ligne droite, juste après les frappes. Dix-huit appareils y sont perdus.\n\n## Place dans l''histoire\nCent soixante-sept exemplaires pour une carrière courte et coûteuse. Le Vigilante illustre une limite atteinte : un appareil embarqué peut être conçu pour Mach 2 et vingt-huit tonnes, mais son entretien et son taux de disponibilité sur un pont de porte-avions deviennent alors le vrai facteur limitant.',
    E'## Genesis\nIn the late 1950s the US Navy wanted its share of nuclear deterrence: a supersonic bomber able to launch from a carrier and strike the USSR. The Vigilante was the answer — twenty-three metres long, twenty-eight tonnes at take-off, Mach 2. No carrier aircraft has ever been larger.\n\n## Design\nThe design piled on innovations: **fully fly-by-wire** controls — a first on a production aircraft — variable-geometry intakes, an inertial platform coupled to a digital computer. Its bomb bay was **linear**: the nuclear weapon, in a tunnel between the engines, was to be ejected rearwards along with two empty tanks. The system never worked reliably.\n\n## Operational career\nNaval deterrence passed to Polaris submarines before the Vigilante was even mature. Converted into the **RA-5C** reconnaissance aircraft, it flew naval aviation’s most dangerous missions over Vietnam: low-level photographic runs, alone and straight, immediately after the strikes. Eighteen were lost there.\n\n## Place in history\nOne hundred and sixty-seven built for a short and costly career. The Vigilante illustrates a limit reached: a carrier aircraft can be designed for Mach 2 and twenty-eight tonnes, but its maintenance and availability on a flight deck then become the real constraint.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1954-01-01',
    '1958-08-31',
    '1961-06-01',
    2124.0,
    4800.0,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM armement WHERE name = 'B28')),
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM armement WHERE name = 'B43'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.11,
  wingspan          = 16.16,
  height            = 5.92,
  wing_area         = 70.05,
  empty_weight      = 17240,
  mtow              = 28615,
  service_ceiling   = 15900,
  climb_rate        = 40,
  g_limit_pos       = 6.5,
  g_limit_neg       = NULL,
  combat_radius     = 1800,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J79-GE-10',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 48.5,
  thrust_wet        = 79.6,

  -- Strate 3 : production & service
  production_start  = 1958,
  production_end    = 1970,
  units_built       = 167,
  unit_cost_usd     = 10000000,
  unit_cost_year    = 1965,
  operators_count   = 1,
  variants          = E'- **A-5A / A3J-1** : bombardier nucléaire embarqué, version initiale\n- **A-5B** : capacité carburant accrue, dos bossu caractéristique\n- **RA-5C** : version de reconnaissance, la plus produite et la seule engagée au Vietnam\n- Système de largage **linéaire** : l''arme sortait par l''arrière du fuselage, jamais fiable en pratique',
  variants_en       = E'- **A-5A / A3J-1** : carrier nuclear bomber, initial version\n- **A-5B** : increased fuel, with the characteristic humped spine\n- **RA-5C** : reconnaissance version, the most produced and the only one used over Vietnam\n- **Linear** bomb bay: the weapon exited through the rear of the fuselage, never reliable in practice',

  -- Strate 4 : qualitatif
  nickname          = 'Vigilante',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_A-5_Vigilante',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_A-5_Vigilante',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA Dryden Flight Research Center',
  image_licence     = 'Public domain'
WHERE name = 'A-5 Vigilante';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'A-5 Vigilante';
