-- Hawker Sea Hawk
--
-- Photo : HAWKER SEA HAWK FGA.6 WV908 crop.jpg
--   licence CC BY 2.0 — Smudge 9000 from North Kent Coast, England
--   https://commons.wikimedia.org/wiki/File%3AHAWKER_SEA_HAWK_FGA.6_WV908_crop.jpg

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
    'Hawker Sea Hawk',
    'Hawker Sea Hawk',
    'Hawker Sea Hawk',
    'Hawker Sea Hawk',
    'Premier chasseur à réaction embarqué de la Royal Navy',
    'The Royal Navy’s first carrier-borne jet fighter',
    '/assets/airplanes/sea-hawk.jpg',
    E'## Genèse\nHawker propose en 1944 une version à réaction de son Fury à hélice. La Royal Air Force n''en veut pas — elle attend le Hunter. La **Fleet Air Arm**, elle, cherche son premier chasseur à réaction embarqué et reprend le projet, qui entre en service neuf ans après le premier vol du prototype.\n\n## Conception\nAile droite et fuselage large abritant le réacteur Nene, dont les gaz sortent par **deux tuyères latérales** de part et d''autre du fuselage plutôt que par une tuyère arrière unique. Cette disposition inhabituelle libère l''arrière pour les réservoirs et raccourcit les conduits. L''appareil est réputé d''une douceur de pilotage exceptionnelle.\n\n## Carrière opérationnelle\nBaptême du feu à **Suez** en 1956, où les Sea Hawk britanniques attaquent les aérodromes égyptiens. Les Pays-Bas et l''Allemagne l''utilisent ensuite ; l''**Inde** l''engage en 1971 contre le Pakistan depuis le porte-avions Vikrant, avec un bilan remarquable et aucune perte au combat.\n\n## Place dans l''histoire\nCinq cent quarante-deux exemplaires, et une longévité indienne qui le mène jusqu''en 1983 — trente ans après sa mise en service. Il ouvre la lignée des chasseurs embarqués britanniques que prolongeront le **Scimitar** puis le Sea Vixen.',
    E'## Genesis\nIn 1944 Hawker proposed a jet version of its piston-engined Fury. The Royal Air Force did not want it — it was waiting for the Hunter. The **Fleet Air Arm**, however, was looking for its first carrier-borne jet and took the design up; it entered service nine years after the prototype first flew.\n\n## Design\nA straight wing and a wide fuselage housing the Nene engine, whose gases exit through **two side nozzles** either side of the fuselage rather than a single rear pipe. That unusual arrangement frees the rear for fuel and shortens the ducts. The aircraft was famed for exceptionally smooth handling.\n\n## Operational career\nFirst combat at **Suez** in 1956, where British Sea Hawks attacked Egyptian airfields. The Netherlands and Germany flew it afterwards; **India** committed it in 1971 against Pakistan from the carrier Vikrant, with a remarkable record and no combat losses.\n\n## Place in history\nFive hundred and forty-two built, and an Indian career running to 1983 — thirty years after entering service. It opened the line of British carrier fighters continued by the **Scimitar** and then the Sea Vixen.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1944-01-01',
    '1947-09-02',
    '1953-03-01',
    969.0,
    1191.0,
    (SELECT id FROM manufacturer WHERE code = 'HS'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.09,
  wingspan          = 11.89,
  height            = 2.79,
  wing_area         = 25.83,
  empty_weight      = 4208,
  mtow              = 7355,
  service_ceiling   = 13560,
  climb_rate        = 27,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 460,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Nene 103',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 23.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1961,
  units_built       = 542,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **Sea Hawk F.1 / F.2** : chasseurs purs, versions initiales\n- **Sea Hawk FGA.4 / FGA.6** : chasseur-bombardier, version principale\n- **Sea Hawk Mk 100 / 101** : versions allemandes tout-temps\n- L''**Inde** l''a exploité depuis le porte-avions Vikrant jusqu''en 1983',
  variants_en       = E'- **Sea Hawk F.1 / F.2** : pure fighters, initial versions\n- **Sea Hawk FGA.4 / FGA.6** : fighter-bomber, the main version\n- **Sea Hawk Mk 100 / 101** : German all-weather versions\n- **India** flew it from the carrier Vikrant until 1983',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hawker_Sea_Hawk',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hawker_Sea_Hawk',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Smudge 9000 from North Kent Coast, England',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Hawker Sea Hawk';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Hawker Sea Hawk';
