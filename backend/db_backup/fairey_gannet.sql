-- Fairey Gannet
--
-- Photo : Fairey Gannet (6014173936).jpg
--   licence CC BY 2.0 — thinboyfatter
--   https://commons.wikimedia.org/wiki/File%3AFairey_Gannet_%286014173936%29.jpg

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
    'Fairey Gannet',
    'Fairey Gannet',
    'Fairey Gannet',
    'Fairey Gannet',
    'Chasseur de sous-marins embarqué à double turbine et hélices contrarotatives',
    'Carrier-borne submarine hunter with a twin turbine and contra-rotating propellers',
    '/assets/airplanes/gannet.jpg',
    E'## Genèse\nLa Royal Navy sort de la guerre avec une leçon coûteuse : chercher un sous-marin et l''attaquer sont deux missions qu''on ne peut plus confier à deux avions différents, faute de place sur les ponts. Il faut un appareil unique, capable de détecter **et** de frapper, et de tenir en l''air assez longtemps pour que la recherche ait un sens. Fairey s''y attelle dès octobre 1945.\n\n## Conception\nLa solution tient dans un moteur singulier : le **Double Mamba**, deux turbines accolées entraînant chacune une hélice contrarotative. En patrouille, on **coupe une des deux turbines** et l''hélice correspondante se met en drapeau — l''appareil vole sur une moitié de moteur, doublant son endurance. Trois hommes en trois postes séparés, une soute à armement interne, une voilure qui se replie en deux points pour tenir dans un ascenseur : tout est dicté par le porte-avions.\n\n## Carrière opérationnelle\nIl équipe la Fleet Air Arm pendant vingt-cinq ans, ainsi que les marines australienne, allemande et indonésienne. Sa dernière incarnation est la plus durable : la version de **guet aérien AEW.3**, reconnaissable à son énorme radôme ventral, reste l''unique radar volant de la Royal Navy jusqu''à son retrait en 1978 — trois ans avant les Malouines, où son absence se fera cruellement sentir.\n\n## Place dans l''histoire\nTrois cent quarante-huit exemplaires. Le retrait de la version AEW en 1978, décidé avec les grands porte-avions britanniques, laisse la flotte sans détection lointaine ; en 1982, faute de guet aérien, la Royal Navy perdra plusieurs bâtiments face aux attaques argentines à basse altitude. Peu d''avions auront démontré leur utilité aussi clairement par leur absence.',
    E'## Genesis\nThe Royal Navy came out of the war with an expensive lesson: searching for a submarine and attacking it are two missions that could no longer be given to two different aircraft, for want of deck space. What was needed was a single machine able to detect **and** strike, and to stay up long enough for the search to mean anything. Fairey set to work in October 1945.\n\n## Design\nThe solution lay in a singular engine: the **Double Mamba**, two turbines side by side each driving one contra-rotating propeller. On patrol **one of the two turbines is shut down** and its propeller feathered — the aircraft flies on half an engine, doubling its endurance. Three men in three separate stations, an internal weapons bay, and a wing that folds at two points to fit a lift: everything is dictated by the carrier.\n\n## Operational career\nIt equipped the Fleet Air Arm for twenty-five years, along with the Australian, German and Indonesian navies. Its final incarnation was the longest-lived: the **AEW.3 early warning** version, recognisable by its huge belly radome, remained the Royal Navy''s only airborne radar until its withdrawal in 1978 — three years before the Falklands, where its absence would be felt bitterly.\n\n## Place in history\nThree hundred and forty-eight built. The withdrawal of the AEW version in 1978, decided along with Britain''s large carriers, left the fleet without long-range detection; in 1982, lacking airborne early warning, the Royal Navy would lose several ships to low-level Argentine attacks. Few aircraft have demonstrated their usefulness so clearly by being absent.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1945-10-01',
    '1949-09-19',
    '1954-01-17',
    500.0,
    1090.0,
    (SELECT id FROM manufacturer WHERE code = 'FAI'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairey Gannet'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Fairey Gannet'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Fairey Gannet'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairey Gannet'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairey Gannet'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Fairey Gannet'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Fairey Gannet'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairey Gannet'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.11,
  wingspan          = 16.56,
  height            = 4.19,
  wing_area         = 44.85,
  empty_weight      = 6835,
  mtow              = 9800,
  service_ceiling   = 7620,
  climb_rate        = 10.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 480,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Armstrong Siddeley Double Mamba ASMD.1',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1961,
  units_built       = 348,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **Gannet AS.1 / AS.4** : lutte anti-sous-marine, versions principales\n- **Gannet AEW.3** : guet aérien embarqué, radar en radôme ventral, en service jusqu''en 1978\n- **Gannet COD.4** : liaison et transport de fret vers le porte-avions\n- **Gannet T.2** : version d''entraînement à double commande\n- Exporté vers l''**Australie**, l''**Allemagne** et l''**Indonésie**',
  variants_en       = E'- **Gannet AS.1 / AS.4** : anti-submarine warfare, the main versions\n- **Gannet AEW.3** : carrier airborne early warning, radar in a belly radome, in service until 1978\n- **Gannet COD.4** : carrier onboard delivery and liaison\n- **Gannet T.2** : dual-control training version\n- Exported to **Australia**, **Germany** and **Indonesia**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fairey_Gannet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fairey_Gannet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'thinboyfatter',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Fairey Gannet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fairey Gannet';
