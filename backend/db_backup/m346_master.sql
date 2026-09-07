-- Leonardo M-346 Master
--
-- Photo : Aermacchi M-346 (code MT55219) arrives RIAT Fairford 13July2017.jpg
--   licence Public domain — Myself ( Adrian Pingstone ).
--   https://commons.wikimedia.org/wiki/File%3AAermacchi_M-346_%28code_MT55219%29_arrives_RIAT_Fairford_13July2017.jpg

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
    'M-346 Master',
    'M-346 Master',
    'Leonardo M-346 Master',
    'Leonardo M-346 Master',
    'Entraîneur avancé européen, né d’une coopération avec Yakovlev',
    'European advanced trainer, born of a partnership with Yakovlev',
    '/assets/airplanes/m346-master.jpg',
    E'## Genèse\nEn 1993, l''italien Aermacchi et le russe Yakovlev s''associent pour concevoir un entraîneur avancé commun. La coopération dure sept ans puis se sépare en 2000 : chacun repart avec les plans. Deux appareils très proches en sortent — le **Yak-130** russe et le **M-346** italien, aujourd''hui concurrents sur les mêmes marchés.\n\n## Conception\nAile à emplanture prolongée offrant une portance stable jusqu''à **35° d''incidence**, commandes de vol entièrement électriques sans secours mécanique, et surtout un système embarqué capable de simuler en vol un radar, des menaces et des tirs adverses inexistants. L''élève s''entraîne à un combat qui n''a pas lieu, à une fraction du coût d''un chasseur réel.\n\n## Carrière opérationnelle\nAdopté par l''Italie, Israël, Singapour, la Pologne, la Grèce, le Qatar, le Turkménistan et l''Autriche. L''**International Flight Training School** de Decimomannu, montée par Leonardo avec l''armée de l''air italienne, forme sur M-346 des pilotes de plusieurs pays, dont ceux destinés au F-35.\n\n## Place dans l''histoire\nLe M-346 marque le moment où l''entraînement avancé bascule dans la simulation embarquée : ce n''est plus la cellule qui compte, mais ce qu''elle sait faire croire au pilote. Ce modèle est repris par le T-7A américain et le futur système de formation britannique.',
    E'## Genesis\nIn 1993 Italy’s Aermacchi and Russia’s Yakovlev teamed up to design a common advanced trainer. The partnership lasted seven years and split in 2000: each side left with the drawings. Two very similar aircraft emerged — the Russian **Yak-130** and the Italian **M-346**, today competitors in the same markets.\n\n## Design\nA wing with extended root leading edges giving stable lift to **35° angle of attack**, fully fly-by-wire controls with no mechanical reversion, and above all an embedded system able to simulate in flight a radar, threats and enemy fire that do not exist. The student trains against a battle that is not happening, at a fraction of a real fighter’s cost.\n\n## Operational career\nAdopted by Italy, Israel, Singapore, Poland, Greece, Qatar, Turkmenistan and Austria. The **International Flight Training School** at Decimomannu, set up by Leonardo with the Italian Air Force, trains pilots from several countries on the M-346, including those destined for the F-35.\n\n## Place in history\nThe M-346 marks the point where advanced training shifted to embedded simulation: what matters is no longer the airframe but what it can make the pilot believe. That model has been taken up by the American T-7A and the future British training system.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1993-01-01',
    '2004-07-15',
    '2011-11-01',
    1092.0,
    2722.0,
    (SELECT id FROM manufacturer WHERE code = 'LEO'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'M-346 Master'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'M-346 Master'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé')),
((SELECT id FROM airplanes WHERE name = 'M-346 Master'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'M-346 Master'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'M-346 Master'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'M-346 Master'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'M-346 Master'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'M-346 Master'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.49,
  wingspan          = 9.72,
  height            = 4.76,
  wing_area         = 23.52,
  empty_weight      = 4610,
  mtow              = 9600,
  service_ceiling   = 13715,
  climb_rate        = 107,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = 1000,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Honeywell F124-GA-200',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 27.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2010,
  production_end    = NULL,
  units_built       = 120,
  unit_cost_usd     = 30000000,
  unit_cost_year    = 2019,
  operators_count   = 8,
  variants          = E'- **M-346 Master** : version d''entraînement avancé\n- **M-346FA** : version d''attaque légère à radar Grifo-346\n- **M-346FT** : configuration mixte entraînement et combat\n- **Yak-130** : jumeau russe, issu du même projet initial avant séparation en 2000',
  variants_en       = E'- **M-346 Master** : advanced training version\n- **M-346FA** : light attack version with Grifo-346 radar\n- **M-346FT** : combined training and combat configuration\n- **Yak-130** : Russian twin, from the same initial project before the 2000 split',

  -- Strate 4 : qualitatif
  nickname          = 'Master',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Alenia_Aermacchi_M-346_Master',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Leonardo_M-346_Master',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Myself ( Adrian Pingstone ).',
  image_licence     = 'Public domain'
WHERE name = 'M-346 Master';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'M-346 Master';
