-- Grumman S-2 Tracker
--
-- Photo : Grumman S-2D Tracker of VX-1 flies over the Florida Keys (USA), 24 February 1967 (K-36120).jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Grumman_S-2D_Tracker_of_VX-1_flies_over_the_Florida_Keys_(USA),_24_February_1967_(K-36120).jpg

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
    'S-2 Tracker',
    'S-2 Tracker',
    'Grumman S-2 Tracker',
    'Grumman S-2 Tracker',
    'Le chasseur de sous-marins embarqué qui réunit en un seul avion la détection et l’attaque',
    'The carrier sub-hunter that combined detection and attack in a single aircraft',
    '/assets/airplanes/s2-tracker.jpg',
    E'## Genèse\nAu début des années 1950, la lutte anti-sous-marine embarquée de l''US Navy repose sur des paires d''**AF Guardian** : l''un détecte, l''autre attaque. Grumman propose de réunir les deux rôles dans un seul avion, ce qui libère de la place sur le pont. Prototypes et premiers avions de série sont commandés ensemble le 30 juin 1950 ; le premier vol a lieu le 4 décembre 1952, l''entrée en service en février 1954.\n\n## Conception\nUne aile haute repliable, deux moteurs en étoile **Wright R-1820** de 1 525 ch, quatre hommes d''équipage. Le Tracker rassemble toute la panoplie anti-sous-marine de son temps : radar escamotable sous le ventre, détecteur d''anomalies magnétiques au bout d''une perche, bouées acoustiques logées à l''arrière des nacelles, projecteur sous l''aile et « renifleur » des gaz d''échappement des sous-marins au schnorchel. La soute emporte deux torpilles légères ou une grenade anti-sous-marine nucléaire. Les équipages le surnomment *Stoof*, d''après sa désignation S2F.\n\n## Carrière opérationnelle\nGrumman en construit 1 185 et **de Havilland Canada** 99 sous licence, les CS2F embarqués sur le porte-avions *Bonaventure*. Quinze pays l''utilisent, de l''Australie au Japon et aux Pays-Bas. L''Aéronavale française, elle, ne l''a jamais eu : elle lui a préféré le **Breguet Alizé**. L''Argentine l''engage pendant la **guerre des Malouines** : le 1er mai 1982, depuis le *Veinticinco de Mayo*, ses Tracker repèrent la flotte britannique. Remotorisés en turbopropulseurs par IAI, les derniers Tracker argentins sont retirés fin 2025.\n\n## Place dans l''histoire\nMille deux cent quatre-vingt-quatre exemplaires et plus de soixante-dix ans de service. Comme l''indique la fiche du **S-3 Viking**, ce sont les sous-marins nucléaires, trop rapides pour lui, qui ont imposé son remplacement dans l''US Navy en 1976. Il a donné le **C-1 Trader** de transport embarqué et l''**E-1 Tracer** de guet aérien, et vole encore comme bombardier d''eau en Californie.',
    E'## Genesis\nIn the early 1950s the US Navy''s carrier anti-submarine force relied on pairs of **AF Guardians**: one detected, the other attacked. Grumman proposed combining both roles in a single aircraft, freeing up deck space. Prototypes and the first production aircraft were ordered together on 30 June 1950; the first flight took place on 4 December 1952 and service entry in February 1954.\n\n## Design\nA folding high wing, two 1,525 hp **Wright R-1820** radial engines, a crew of four. The Tracker gathered the whole anti-submarine toolkit of its day: a retractable radar under the belly, a magnetic anomaly detector on the end of a boom, sonobuoys housed in the back of the nacelles, a searchlight under the wing and a "sniffer" for the exhaust of snorkelling submarines. The bay carried two lightweight torpedoes or one nuclear depth charge. Crews nicknamed it *Stoof*, after its S2F designation.\n\n## Operational career\nGrumman built 1,185 and **de Havilland Canada** 99 under licence, the CS2Fs that flew from the carrier *Bonaventure*. Fifteen countries used it, from Australia to Japan and the Netherlands. The French Aéronavale never had it: it preferred the **Breguet Alizé**. Argentina used it in the **Falklands War**: on 1 May 1982, flying from the *Veinticinco de Mayo*, its Trackers located the British fleet. Re-engined with turboprops by IAI, the last Argentine Trackers were retired at the end of 2025.\n\n## Place in history\nOne thousand two hundred and eighty-four built and more than seventy years of service. As the **S-3 Viking** entry notes, it was nuclear submarines, too fast for it, that forced its replacement in the US Navy in 1976. It gave rise to the **C-1 Trader** carrier transport and the **E-1 Tracer** early warning aircraft, and still flies as a water bomber in California.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1950-06-30',
    '1952-12-04',
    '1954-02-01',
    450.0,
    2172.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'S-2 Tracker'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'S-2 Tracker'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'S-2 Tracker'), (SELECT id FROM tech WHERE name = 'Système de décollage et d''atterrissage sur porte-avions'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'S-2 Tracker'), (SELECT id FROM armement WHERE name = 'Mk 46'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'S-2 Tracker'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'S-2 Tracker'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'S-2 Tracker'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'S-2 Tracker'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.26,
  wingspan          = 22.12,
  height            = 5.33,
  wing_area         = 45.06,
  empty_weight      = 8308,
  mtow              = 11860,
  service_ceiling   = 6706,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-1820-82WA Cyclone',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1952,
  production_end    = NULL,
  units_built       = 1284,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 15,
  variants          = E'- **S2F-1 / S-2A** : version initiale de l''US Navy\n- **S-2E / S-2G** : versions agrandies à équipements acoustiques modernisés\n- **CS2F / CP-121** : production canadienne de **de Havilland Canada**, 99 exemplaires\n- **S-2T Turbo Tracker** : remotorisation en turbopropulseurs pour Taïwan et l''Argentine\n- Dérivés : **C-1 Trader** (transport embarqué), **E-1 Tracer** (guet aérien), **Firecat** (bombardier d''eau)',
  variants_en       = E'- **S2F-1 / S-2A** : initial US Navy version\n- **S-2E / S-2G** : enlarged versions with upgraded acoustic equipment\n- **CS2F / CP-121** : Canadian production by **de Havilland Canada**, 99 aircraft\n- **S-2T Turbo Tracker** : turboprop re-engining for Taiwan and Argentina\n- Derivatives: **C-1 Trader** (carrier transport), **E-1 Tracer** (early warning), **Firecat** (water bomber)',

  -- Strate 4 : qualitatif
  nickname          = 'Stoof',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_S-2_Tracker',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_S-2_Tracker',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'S-2 Tracker';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'S-2 Tracker';
