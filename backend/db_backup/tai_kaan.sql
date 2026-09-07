-- TAI TF Kaan
--
-- Photo : IMG-TAI-TFX.jpg
--   licence CC BY-SA 4.0 — Dimir
--   https://commons.wikimedia.org/wiki/File%3AIMG-TAI-TFX.jpg

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
    'TAI Kaan',
    'TAI Kaan',
    'TAI TF Kaan',
    'TAI TF Kaan',
    'Chasseur furtif turc de cinquième génération, premier vol en 2024',
    'Turkish fifth-generation stealth fighter, first flight in 2024',
    '/assets/airplanes/tai-kaan.jpg',
    E'## Genèse\nEn 2019, la Turquie est **exclue du programme F-35** après l''achat de systèmes antiaériens russes S-400, alors qu''elle en produisait des composants et avait commandé cent appareils. Le programme TF-X, lancé en 2016 comme complément, devient du jour au lendemain la seule voie d''accès du pays à un chasseur de cinquième génération.\n\n## Conception\nBimoteur de vingt et une tonnes, soutes internes, entrées d''air sans dérivateur de couche limite, double dérive inclinée. L''assistance britannique de **BAE Systems** a porté sur la conception aérodynamique et la certification. Les premiers appareils volent avec des F110 américains ; un moteur national, le TF-35000, est développé en parallèle et conditionne l''autonomie réelle du programme.\n\n## Carrière opérationnelle\nPremier vol le **21 février 2024**, huit ans après le lancement. Les essais se poursuivent ; la mise en service est visée pour 2030, avec un objectif affiché de plus de deux cents appareils. L''**Indonésie** a signé en 2025 pour quarante-huit exemplaires, premier contrat à l''export.\n\n## Place dans l''histoire\nLe Kaan illustre le même mécanisme que le **KF-21** coréen : un refus américain de transfert technologique produit, à dix ans de distance, un concurrent. Il fait de la Turquie le neuvième pays à avoir fait voler un chasseur de conception nationale de cette génération.',
    E'## Genesis\nIn 2019 Turkey was **expelled from the F-35 programme** after buying Russian S-400 air defence systems, although it manufactured components for it and had ordered a hundred aircraft. The TF-X programme, launched in 2016 as a complement, became overnight the country’s only route to a fifth-generation fighter.\n\n## Design\nA twenty-one-tonne twin-engine design with internal bays, diverterless supersonic intakes and canted twin tails. British assistance from **BAE Systems** covered aerodynamic design and certification. The first aircraft fly with American F110s; a national engine, the TF-35000, is being developed in parallel and determines the programme’s real autonomy.\n\n## Operational career\nFirst flight on **21 February 2024**, eight years after launch. Testing continues; service entry is targeted for 2030, with a stated goal of more than two hundred aircraft. **Indonesia** signed in 2025 for forty-eight, the first export contract.\n\n## Place in history\nThe Kaan illustrates the same mechanism as Korea’s **KF-21**: an American refusal to transfer technology produces, a decade later, a competitor. It makes Turkey the ninth country to have flown a nationally designed fighter of this generation.',
    (SELECT id FROM countries WHERE code = 'TUR'),
    '2016-01-01',
    '2024-02-21',
    NULL,
    2200.0,
    3200.0,
    (SELECT id FROM manufacturer WHERE code = 'TAI'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Kaan'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'TAI Kaan'), (SELECT id FROM tech WHERE name = 'Soute à armement pressurisée')),
((SELECT id FROM airplanes WHERE name = 'TAI Kaan'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'TAI Kaan'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'TAI Kaan'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Kaan'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'TAI Kaan'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Kaan'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'TAI Kaan'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'TAI Kaan'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 21.0,
  wingspan          = 14.0,
  height            = 6.0,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 27215,
  service_ceiling   = 16764,
  climb_rate        = NULL,
  g_limit_pos       = 9.0,
  g_limit_neg       = NULL,
  combat_radius     = 1100,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F110-GE-129 (moteur national à terme)',
  engine_count      = 2,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 76.3,
  thrust_wet        = 129.0,

  -- Strate 3 : production & service
  production_start  = 2023,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Block 0** : prototypes de développement, moteurs F110 américains\n- **Block 10** : première série prévue, entrée en service visée pour 2030\n- **Block 20** : version à moteur turc **TEI TF-35000**, en développement\n\n*Programme en cours : plusieurs caractéristiques restent provisoires ou non publiées.*',
  variants_en       = E'- **Block 0** : development prototypes with American F110 engines\n- **Block 10** : first production batch, service entry targeted for 2030\n- **Block 20** : version with the Turkish **TEI TF-35000** engine, in development\n\n*Programme ongoing: several characteristics remain provisional or unpublished.*',

  -- Strate 4 : qualitatif
  nickname          = 'Kaan',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/TAI_TF-X',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/TAI_TF_Kaan',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Dimir',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'TAI Kaan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'TAI Kaan';
