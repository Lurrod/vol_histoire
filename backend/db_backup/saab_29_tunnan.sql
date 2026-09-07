-- Saab 29 Tunnan
--
-- Photo : Saab J 29F Tunnan 29670 SE-DXB på uppvisning i Karlstad 2025 (cropped).jpg
--   licence CC BY-SA 4.0 — TunaFish Spotting
--   https://commons.wikimedia.org/wiki/File%3ASaab_J_29F_Tunnan_29670_SE-DXB_p%C3%A5_uppvisning_i_Karlstad_2025_%28cropped%29.jpg

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
    'Saab 29 Tunnan',
    'Saab 29 Tunnan',
    'Saab 29 Tunnan',
    'Saab 29 Tunnan',
    'Premier chasseur à aile en flèche d’Europe occidentale',
    'First swept-wing fighter in Western Europe',
    '/assets/airplanes/saab-29-tunnan.jpg',
    E'## Genèse\nSaab travaille depuis 1945 sur un chasseur à aile droite quand un ingénieur suédois rapporte de Suisse un dossier allemand sur l''**aile en flèche**. Le projet est repris à zéro. Le Tunnan vole en 1948 — avant le Hawker Hunter, avant le Dassault Ouragan, avant tout autre chasseur à flèche d''Europe occidentale.\n\n## Conception\nLe fuselage court et large autour du réacteur Ghost lui vaut son surnom : *Flygande Tunnan*, le tonneau volant. La silhouette est ingrate mais l''aérodynamique est saine : en 1954 un S 29C bat le **record du monde de vitesse sur circuit fermé** de 500 km, à 977 km/h.\n\n## Carrière opérationnelle\nEn 1961, la Suède envoie neuf Tunnan au **Congo** sous mandat des Nations unies — la seule fois de son histoire moderne où l''aviation suédoise a combattu. Ils y détruisent l''aviation katangaise au sol et appuient les troupes onusiennes, sans perdre un appareil au combat.\n\n## Place dans l''histoire\nSix cent soixante et un exemplaires pour un pays de sept millions d''habitants. Le Tunnan ouvre la lignée suédoise — **Lansen**, Draken, Viggen, Gripen — et prouve qu''une industrie nationale complète reste possible à cette échelle, principe que la Suède n''a jamais abandonné depuis.',
    E'## Genesis\nSaab had been working since 1945 on a straight-wing fighter when a Swedish engineer brought back from Switzerland a German file on the **swept wing**. The project restarted from scratch. The Tunnan flew in 1948 — before the Hawker Hunter, before the Dassault Ouragan, before any other swept-wing fighter in Western Europe.\n\n## Design\nThe short, wide fuselage around the Ghost engine earned it its nickname: *Flygande Tunnan*, the flying barrel. The shape is ungainly but the aerodynamics are sound: in 1954 an S 29C took the **world speed record over a 500 km closed circuit** at 977 km/h.\n\n## Operational career\nIn 1961 Sweden sent nine Tunnans to the **Congo** under a United Nations mandate — the only time in its modern history that Swedish aviation has fought. They destroyed the Katangese air force on the ground and supported UN troops without losing an aircraft in combat.\n\n## Place in history\nSix hundred and sixty-one built for a country of seven million people. The Tunnan opened the Swedish line — **Lansen**, Draken, Viggen, Gripen — and proved that a complete national industry remains possible at that scale, a principle Sweden has never abandoned since.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    '1945-01-01',
    '1948-09-01',
    '1951-05-01',
    1060.0,
    1100.0,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'), (SELECT id FROM armement WHERE name = 'Bofors 135 mm')),
((SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.23,
  wingspan          = 11.0,
  height            = 3.75,
  wing_area         = 24.0,
  empty_weight      = 4845,
  mtow              = 8375,
  service_ceiling   = 15500,
  climb_rate        = 32,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Svenska Flygmotor RM2B (de Havilland Ghost)',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 27.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1950,
  production_end    = 1956,
  units_built       = 661,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **J 29B** : chasseur de série, capacité carburant accrue\n- **A 29B** : version d''attaque au sol, celle engagée au Congo\n- **S 29C** : reconnaissance photographique, détentrice d''un record du monde de vitesse en 1955\n- **J 29F** : version finale, aile à dent de chien et missiles infrarouges',
  variants_en       = E'- **J 29B** : production fighter with increased fuel capacity\n- **A 29B** : ground attack version, the one committed in the Congo\n- **S 29C** : photographic reconnaissance, holder of a world speed record in 1955\n- **J 29F** : final version with a dog-tooth wing and infrared missiles',

  -- Strate 4 : qualitatif
  nickname          = 'Flygande Tunnan',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Saab_29_Tunnan',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saab_29_Tunnan',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'TunaFish Spotting',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Saab 29 Tunnan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saab 29 Tunnan';
