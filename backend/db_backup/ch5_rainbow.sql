-- CASC CH-5 Rainbow (Caihong-5)
--
-- Photo : CH-5 at Airshow China Zhuhai 2022.jpg
--   licence CC BY-SA 4.0 — Infinty 0
--   https://commons.wikimedia.org/wiki/File:CH-5_at_Airshow_China_Zhuhai_2022.jpg

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
    'CASC CH-5 Rainbow',
    'CASC CH-5 Rainbow',
    'CASC CH-5 Caihong-5 (Rainbow)',
    'CASC CH-5 Caihong-5 (Rainbow)',
    'Le drone armé lourd chinois proposé à l’export comme un MQ-9 à moitié prix',
    'China’s heavy armed drone offered for export as a half-price MQ-9',
    '/assets/airplanes/ch5-rainbow.jpg',
    E'## Genèse\nLa famille **Caihong** (« arc-en-ciel ») n''est pas née chez un avionneur mais chez un spécialiste des missiles et de l''espace : l''Académie chinoise d''aérodynamique, filiale de la **CASC** (China Aerospace Science and Technology Corporation). Ses CH-3 et CH-4, vendus au Moyen-Orient et en Afrique — l''Irak emploie les siens contre l''État islamique dès 2015 —, ont occupé dans les années 2010 le marché que les États-Unis refusaient d''ouvrir à leurs propres drones armés. Le CH-5, plus lourd, vise le segment du **MQ-9 Reaper**.\n\n## Conception\nUne architecture de drone MALE à grande aile droite de 21 mètres d''envergure et à moteur à pistons propulsif. La masse maximale dépasse trois tonnes et la charge utile atteint environ une tonne, répartie sous les ailes : le constructeur annonce jusqu''à seize missiles légers, comme le **AR-1** à guidage laser. Le CASC met en avant une endurance de l''ordre de soixante heures et un plafond d''environ neuf mille mètres, chiffres de catalogue que nulle source indépendante n''a vérifiés. Une version à moteur plus puissant a été annoncée pour monter plus haut et plus longtemps.\n\n## Carrière opérationnelle\nPremier vol en **août 2015**, présentation au salon de Zhuhai en novembre 2016, première démonstration en vol publique en 2017. Les commandes à l''export sont mal documentées : l''Algérie et l''Irak en ont commandé selon la presse spécialisée, sans que les livraisons soient toutes confirmées. Aucun emploi au combat n''est établi par des sources ouvertes à la date de rédaction.\n\n## Place dans l''histoire\nLe CH-5 illustre la stratégie d''exportation chinoise des années 2010 : des drones armés proches des modèles américains, vendus moins cher et sans les restrictions du régime de contrôle des technologies de missiles que respectent les États-Unis. Il concurrence directement le **Wing Loong II** d''AVIC, l''autre grande famille de drones armés chinois.',
    E'## Genesis\nThe **Caihong** ("rainbow") family was not born at an airframer but at a missile and space specialist: the China Academy of Aerospace Aerodynamics, a subsidiary of **CASC** (China Aerospace Science and Technology Corporation). Its CH-3 and CH-4, sold in the Middle East and Africa — Iraq used its own against the Islamic State from 2015 — filled in the 2010s the market the United States refused to open to its own armed drones. The heavier CH-5 targets the segment of the **MQ-9 Reaper**.\n\n## Design\nA MALE drone layout with a large 21-metre straight wing and a pusher piston engine. Maximum weight exceeds three tonnes and payload reaches about one tonne, carried under the wings: the manufacturer quotes up to sixteen light missiles, such as the laser-guided **AR-1**. CASC advertises an endurance of around sixty hours and a ceiling of about nine thousand metres, catalogue figures that no independent source has verified. A version with a more powerful engine has been announced to fly higher and longer.\n\n## Operational career\nFirst flight in **August 2015**, unveiled at the Zhuhai air show in November 2016, first public flight demonstration in 2017. Export orders are poorly documented: Algeria and Iraq have ordered it according to the specialist press, though not all deliveries are confirmed. No combat use had been established by open sources at the time of writing.\n\n## Place in history\nThe CH-5 illustrates China''s export strategy of the 2010s: armed drones close to American designs, sold more cheaply and without the restrictions of the Missile Technology Control Regime that the United States observes. It competes directly with AVIC''s **Wing Loong II**, the other great family of Chinese armed drones.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    NULL,
    '2015-08-01',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'CASC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'CASC CH-5 Rainbow'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'CASC CH-5 Rainbow'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'CASC CH-5 Rainbow'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'CASC CH-5 Rainbow'), (SELECT id FROM armement WHERE name = 'AR-1'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'CASC CH-5 Rainbow'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'CASC CH-5 Rainbow'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = 21.0,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 3300,
  service_ceiling   = 9000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = NULL,
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **CH-3 / CH-4** : prédécesseurs plus légers, largement exportés\n- **CH-5** : version lourde, premier vol en **août 2015**\n- Version remotorisée annoncée pour un plafond et une endurance accrus\n- Jusqu''à **seize missiles légers** annoncés sous voilure\n\n*Les performances publiées sont celles du constructeur ; plusieurs caractéristiques restent non publiées.*',
  variants_en       = E'- **CH-3 / CH-4** : lighter predecessors, widely exported\n- **CH-5** : heavy version, first flight in **August 2015**\n- Re-engined version announced for greater ceiling and endurance\n- Up to **sixteen light missiles** quoted under the wings\n\n*Published performance figures are the manufacturer''s; several characteristics remain unpublished.*',

  -- Strate 4 : qualitatif
  nickname          = 'Caihong',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/CASC_Rainbow',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/CASC_Rainbow',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Infinty 0',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'CASC CH-5 Rainbow';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'CASC CH-5 Rainbow';
