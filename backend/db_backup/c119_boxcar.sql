-- Fairchild C-119 Flying Boxcar
--
-- Photo : C-119 Flying Boxcar in flight.jpg
--   licence Public domain — United States Air Force
--   https://commons.wikimedia.org/wiki/File%3AC-119_Flying_Boxcar_in_flight.jpg

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
    'C-119 Flying Boxcar',
    'C-119 Flying Boxcar',
    'Fairchild C-119 Flying Boxcar',
    'Fairchild C-119 Flying Boxcar',
    'Le wagon volant : première soute conçue autour du largage',
    'The flying boxcar: the first hold designed around the air drop',
    '/assets/airplanes/c119-boxcar.jpg',
    E'## Genèse\nLes transports de la Seconde Guerre mondiale étaient des avions de ligne militarisés : on y chargeait par une porte latérale, en portant les caisses. Fairchild propose l''inverse — dessiner d''abord la **soute**, puis l''avion autour. Le C-82 Packet ouvre la voie en 1944 mais manque de puissance ; le C-119, plus gros moteurs et poste de pilotage abaissé dans le nez, en est la correction.\n\n## Conception\nUne caisse rectangulaire posée entre **deux poutres de queue**, laissant l''arrière entièrement dégagé : on ouvre en vol et on largue sans rien démonter. Le plancher est à hauteur de camion, la section constante sur toute la longueur. C''est cette géométrie — poutres, soute droite, ouverture arrière — qui deviendra la grammaire de tout transport tactique, du Noratlas au C-130.\n\n## Carrière opérationnelle\nEn **Corée**, il largue des ponts flottants entiers, section par section, pour permettre le repli de la 1re division de Marines. En **Indochine**, des C-119 prêtés à la France et pilotés par des équipages civils américains ravitaillent Diên Biên Phu sous le feu. Au **Vietnam**, ses versions canonnières Shadow et Stinger inventent le tir en cercle qui fera la réputation de l''AC-130.\n\n## Place dans l''histoire\nMille cent quatre-vingt-trois exemplaires dans douze forces aériennes. En août 1960, un C-119 récupère en vol la capsule du satellite Discoverer 14 : **première capture aérienne d''un objet revenu de l''espace**. Son successeur, le **C-130 Hercules**, reprend sa géométrie en la portant à l''échelle du turbopropulseur.',
    E'## Genesis\nSecond World War transports were militarised airliners: freight went in through a side door, carried by hand. Fairchild proposed the reverse — design the **hold** first, then the aircraft around it. The C-82 Packet opened the way in 1944 but lacked power; the C-119, with larger engines and a cockpit lowered into the nose, was the correction.\n\n## Design\nA rectangular box set between **two tail booms**, leaving the rear entirely clear: you open it in flight and drop without dismantling anything. The floor is at truck-bed height and the section constant along its length. It is this geometry — booms, straight hold, rear opening — that became the grammar of every tactical transport, from the Noratlas to the C-130.\n\n## Operational career\nOver **Korea** it dropped entire floating bridges, section by section, to let the 1st Marine Division withdraw. In **Indochina**, C-119s lent to France and flown by American civilian crews resupplied Dien Bien Phu under fire. Over **Vietnam**, its Shadow and Stinger gunship versions invented the pylon turn that would make the AC-130''s reputation.\n\n## Place in history\nOne thousand one hundred and eighty-three built across twelve air forces. In August 1960 a C-119 caught the capsule of the Discoverer 14 satellite in mid-air: the **first aerial recovery of an object returned from space**. Its successor, the **C-130 Hercules**, took up its geometry and scaled it to the turboprop.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1947-01-01',
    '1947-11-17',
    '1949-12-01',
    450.0,
    3670.0,
    (SELECT id FROM manufacturer WHERE code = 'FRC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 26.37,
  wingspan          = 33.3,
  height            = 8.08,
  wing_area         = 134.4,
  empty_weight      = 18000,
  mtow              = 33900,
  service_ceiling   = 7300,
  climb_rate        = 5.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1600,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-3350-89W Cyclone',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1955,
  units_built       = 1183,
  unit_cost_usd     = 589000,
  unit_cost_year    = 1953,
  operators_count   = 12,
  variants          = E'- **C-119B / C / F / G** : versions de transport tactique successives\n- **AC-119G Shadow / AC-119K Stinger** : canonnières du Vietnam, ancêtres de l''AC-130\n- **C-119J** : rampe arrière modifiée, a récupéré en vol la **première capsule spatiale**\n- Des C-119 français ont ravitaillé **Diên Biên Phu** en 1954, pilotés par des équipages civils\n- Dérivé du C-82 Packet, dont il corrige le manque de puissance',
  variants_en       = E'- **C-119B / C / F / G** : successive tactical transport versions\n- **AC-119G Shadow / AC-119K Stinger** : Vietnam gunships, ancestors of the AC-130\n- **C-119J** : modified rear ramp; made the **first mid-air space capsule recovery**\n- French C-119s resupplied **Dien Bien Phu** in 1954, flown by civilian crews\n- Derived from the C-82 Packet, whose lack of power it corrected',

  -- Strate 4 : qualitatif
  nickname          = 'Flying Boxcar',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fairchild_C-119_Flying_Boxcar',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fairchild_C-119_Flying_Boxcar',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'United States Air Force',
  image_licence     = 'Public domain'
WHERE name = 'C-119 Flying Boxcar';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'C-119 Flying Boxcar';
