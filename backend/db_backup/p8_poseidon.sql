-- Boeing P-8 Poseidon
--
-- Photo : 20190206 P-8 Poseidon Kadena AB-12.jpg
--   licence CC0 — Balon Greyjoy
--   https://commons.wikimedia.org/wiki/File%3A20190206_P-8_Poseidon_Kadena_AB-12.jpg

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
    'P-8 Poseidon',
    'P-8 Poseidon',
    'Boeing P-8 Poseidon',
    'Boeing P-8 Poseidon',
    'Chasseur de sous-marins bâti sur un Boeing 737, qui traque depuis la haute altitude',
    'Submarine hunter built on a Boeing 737, hunting from high altitude',
    '/assets/airplanes/p8-poseidon.jpg',
    E'## Genèse\nLe **P-3 Orion** vole depuis 1962 et ses cellules sont fatiguées. La marine américaine hésite entre un nouveau turbopropulseur, économique en patrouille basse, et un biréacteur civil, plus rapide et surtout **déjà amorti** par des milliers d''exemplaires en ligne. Boeing propose son 737, dont la logistique existe dans le monde entier. Le calcul est autant industriel que tactique.\n\n## Conception\nUn 737-800 à l''aile de 737-900, renforcé et doté d''une soute à armement ventrale. La rupture est doctrinale : là où le P-3 descendait à cent cinquante mètres pour écouter la mer, le P-8 reste à **neuf mille mètres**, largue ses bouées acoustiques en chute libre guidée et exploite leurs signaux à distance. Il économise ainsi le carburant, la fatigue de cellule et l''usure des équipages. Le détecteur d''anomalies magnétiques, jugé inutile à cette altitude, a été supprimé.\n\n## Carrière opérationnelle\nIl surveille l''Atlantique Nord face au retour des sous-marins russes, la mer de Chine méridionale, et il a cherché le vol MH370 dans l''océan Indien. Le Royaume-Uni, resté **neuf ans sans patrouilleur maritime** après l''annulation du Nimrod MRA4, en a acquis neuf. Huit pays l''exploitent aujourd''hui.\n\n## Place dans l''histoire\nCent quatre-vingts exemplaires livrés, production en cours. Il a remplacé le **P-3 Orion** dans presque toutes les marines occidentales et impose une manière nouvelle de traquer : haute, rapide, dépendante des capteurs largués plutôt que de la proximité. Son concurrent direct est le **Kawasaki P-1** japonais, seul patrouilleur moderne conçu de zéro plutôt que dérivé d''un avion de ligne.',
    E'## Genesis\nThe **P-3 Orion** had flown since 1962 and its airframes were tired. The US Navy hesitated between a new turboprop, economical on low patrol, and a civil twinjet, faster and above all **already amortised** by thousands of aircraft in service. Boeing proposed its 737, whose support exists worldwide. The calculation was as industrial as it was tactical.\n\n## Design\nA 737-800 with the wing of a 737-900, strengthened and fitted with a ventral weapons bay. The break is doctrinal: where the P-3 descended to a hundred and fifty metres to listen to the sea, the P-8 stays at **nine thousand metres**, releases its sonobuoys in guided free fall and works their signals from a distance. It thus saves fuel, airframe fatigue and crew wear. The magnetic anomaly detector, judged useless at that height, has been deleted.\n\n## Operational career\nIt watches the North Atlantic against the return of Russian submarines, the South China Sea, and it searched for flight MH370 in the Indian Ocean. The United Kingdom, left **nine years without a maritime patroller** after the Nimrod MRA4 cancellation, acquired nine. Eight countries operate it today.\n\n## Place in history\nOne hundred and eighty delivered, production continuing. It has replaced the **P-3 Orion** in almost every Western navy and imposes a new way of hunting: high, fast, dependent on dropped sensors rather than on proximity. Its direct competitor is Japan''s **Kawasaki P-1**, the only modern patroller designed from scratch rather than derived from an airliner.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2000-01-01',
    '2009-04-25',
    '2013-11-29',
    907.0,
    8300.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM armement WHERE name = 'Mk 46')),
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM armement WHERE name = 'Mk 82'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 39.47,
  wingspan          = 37.64,
  height            = 12.83,
  wing_area         = 125.0,
  empty_weight      = 62730,
  mtow              = 85820,
  service_ceiling   = 12500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2222,
  crew              = 9,

  -- Strate 2 : motorisation
  engine_name       = 'CFM International CFM56-7B27A',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 121.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2009,
  production_end    = NULL,
  units_built       = 180,
  unit_cost_usd     = 125000000,
  unit_cost_year    = 2020,
  operators_count   = 8,
  variants          = E'- **P-8A** : version de l''US Navy, la plus nombreuse\n- **P-8I Neptune** : version indienne, à électronique partiellement nationale\n- **Poseidon MRA1** : version britannique, qui a rendu à la RAF la patrouille maritime perdue en 2010\n- Exploité par l''**Australie**, la Norvège, la Corée du Sud, la Nouvelle-Zélande et l''Allemagne\n- Largue ses bouées acoustiques depuis **9 000 m**, là où le P-3 descendait au ras des flots',
  variants_en       = E'- **P-8A** : the US Navy version, the most numerous\n- **P-8I Neptune** : Indian version with partly national electronics\n- **Poseidon MRA1** : British version, restoring the maritime patrol the RAF lost in 2010\n- Operated by **Australia**, Norway, South Korea, New Zealand and Germany\n- Drops its sonobuoys from **9,000 m**, where the P-3 came down to the waves',

  -- Strate 4 : qualitatif
  nickname          = 'Poseidon',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_P-8_Poseidon',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_P-8_Poseidon',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Balon Greyjoy',
  image_licence     = 'CC0'
WHERE name = 'P-8 Poseidon';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'P-8 Poseidon';
