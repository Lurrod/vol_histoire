-- FMA IA 58 Pucará
--
-- Photo : FMA IA 58 Pucará (27979253005).jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany, Germany
--   https://commons.wikimedia.org/wiki/File%3AFMA_IA_58_Pucar%C3%A1_%2827979253005%29.jpg

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
    'FMA IA 58 Pucará',
    'FMA IA 58 Pucará',
    'FMA IA 58 Pucará',
    'FMA IA 58 Pucará',
    'Avion de contre-insurrection argentin, engagé aux Malouines',
    'Argentine counter-insurgency aircraft, committed in the Falklands',
    '/assets/airplanes/ia58-pucara.jpg',
    E'## Genèse\nL''Argentine cherche à la fin des années 1960 un appareil de contre-insurrection adapté à son territoire : distances immenses, terrains sommaires, altitude. Plutôt que d''importer, la **Fábrica Militar de Aviones** de Córdoba, active depuis 1927, conçoit son propre appareil — le seul avion de combat entièrement argentin à être entré en service.\n\n## Conception\nDeux turbopropulseurs Astazou, un train renforcé pour l''herbe, et un fuselage étroit dont le nez plonge fortement pour dégager la vue vers l''avant et le bas. L''équipage de deux est assis en tandem sur des sièges éjectables **zéro-zéro**, utilisables à l''arrêt au sol. Le Pucará décolle en moins de **400 mètres**.\n\n## Carrière opérationnelle\nAux **Malouines** en 1982, vingt-quatre Pucará sont déployés sur l''archipel. Leur lenteur les rend vulnérables aux Sea Harrier et aux missiles portables, et la plupart sont détruits au sol ou capturés. Un seul obtient une victoire : l''abattage d''un hélicoptère Scout britannique — la seule victoire aérienne argentine de la guerre attribuée à un avion à hélice.\n\n## Place dans l''histoire\nCent dix exemplaires, exportés en Uruguay, en Colombie et au Sri Lanka. Le Pucará est le témoin d''une ambition industrielle sud-américaine largement oubliée : dans les années 1970, l''Argentine concevait et produisait seule un avion de combat, ce que peu de pays de sa taille ont tenté.',
    E'## Genesis\nIn the late 1960s Argentina sought a counter-insurgency aircraft suited to its territory: vast distances, rough strips, altitude. Rather than import, the **Fábrica Militar de Aviones** at Córdoba, active since 1927, designed its own — the only entirely Argentine combat aircraft to enter service.\n\n## Design\nTwo Astazou turboprops, strengthened gear for grass, and a narrow fuselage whose nose droops sharply to clear the view forward and down. The crew of two sit in tandem on **zero-zero** ejection seats, usable stationary on the ground. The Pucará takes off in under **400 metres**.\n\n## Operational career\nIn the **Falklands** in 1982, twenty-four Pucarás were deployed to the islands. Their slowness made them vulnerable to Sea Harriers and man-portable missiles, and most were destroyed on the ground or captured. One scored a victory: the downing of a British Scout helicopter — the only Argentine aerial victory of the war credited to a propeller aircraft.\n\n## Place in history\nOne hundred and ten built, exported to Uruguay, Colombia and Sri Lanka. The Pucará testifies to a largely forgotten South American industrial ambition: in the 1970s Argentina designed and built a combat aircraft alone, something few countries its size have attempted.',
    (SELECT id FROM countries WHERE code = 'ARG'),
    '1966-01-01',
    '1969-08-20',
    '1976-05-01',
    500.0,
    3710.0,
    (SELECT id FROM manufacturer WHERE code = 'FMA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'FMA IA 58 Pucará'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'FMA IA 58 Pucará'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'FMA IA 58 Pucará'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'FMA IA 58 Pucará'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'FMA IA 58 Pucará'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'FMA IA 58 Pucará'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'FMA IA 58 Pucará'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'FMA IA 58 Pucará'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'FMA IA 58 Pucará'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.25,
  wingspan          = 14.5,
  height            = 5.36,
  wing_area         = 30.3,
  empty_weight      = 4020,
  mtow              = 6800,
  service_ceiling   = 10000,
  climb_rate        = 18,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 350,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Turbomeca Astazou XVIG',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1974,
  production_end    = 1990,
  units_built       = 110,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **IA 58A** : version de série, deux canons de 20 mm et quatre mitrailleuses\n- **IA 58B / C** : projets d''évolution à canons de 30 mm, restés prototypes\n- **IA 66** : version à turbopropulseurs Garrett\n- Nommé d''après les **pucará**, forteresses de pierre précolombiennes des Andes',
  variants_en       = E'- **IA 58A** : production version with two 20 mm cannon and four machine guns\n- **IA 58B / C** : proposed 30 mm gun evolutions, remained prototypes\n- **IA 66** : version with Garrett turboprops\n- Named after the **pucará**, the pre-Columbian stone fortresses of the Andes',

  -- Strate 4 : qualitatif
  nickname          = 'Pucará',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/FMA_IA_58_Pucar%C3%A1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/FMA_IA_58_Pucar%C3%A1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clemens Vasters from Viersen, Germany, Germany',
  image_licence     = 'CC BY 2.0'
WHERE name = 'FMA IA 58 Pucará';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'FMA IA 58 Pucará';
