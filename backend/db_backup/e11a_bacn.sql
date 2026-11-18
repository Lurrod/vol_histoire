-- Bombardier E-11A BACN (Global 6000)
--
-- Photo : Battlefield Airborne Communications Node E-11A aircraft at Hanscom Air Force Base, June 2021.JPG
--   licence Public domain — U.S. Air Force photo by Mark Herlihy
--   https://commons.wikimedia.org/wiki/File:Battlefield_Airborne_Communications_Node_E-11A_aircraft_at_Hanscom_Air_Force_Base,_June_2021.JPG

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
    'Bombardier E-11A',
    'Bombardier E-11A',
    'Bombardier E-11A BACN (Global 6000)',
    'Bombardier E-11A BACN (Global 6000)',
    'Global 6000 de l''US Air Force devenu relais de communications volant au-dessus du champ de bataille afghan',
    'US Air Force Global 6000 turned into a flying communications relay over the Afghan battlefield',
    '/assets/airplanes/bombardier-e11a.jpg',
    E'## Genèse\nAprès avoir racheté Canadair et son Challenger 600 en 1986, **Bombardier** étudie un avion d''affaires capable d''emporter huit passagers sur 12 000 km. Présenté en octobre 1991 et lancé en décembre 1993, le **Global Express** vole pour la première fois le 13 octobre 1996 à Toronto et entre en service en juillet 1999. Son autonomie, son plafond de 15 500 m et ses quatorze heures d''endurance attirent vite les militaires : la Royal Air Force en tire le **Sentinel R1**, la Suède et les Émirats le **GlobalEye**. L''US Air Force, elle, y cherche un relais de communications pour ses opérations en Afghanistan.\n\n## Conception\nL''E-11A est un **Global 6000**, version modernisée du Global Express, que **Northrop Grumman** équipe du **Battlefield Airborne Communications Node** (BACN), un nœud de communications aéroporté au-dessus du champ de bataille. L''avion garde sa voilure supercritique à 35° de flèche, ses winglets et ses deux turbosoufflantes Rolls-Royce BR710 de 65,6 kN pilotées par FADEC. Un carénage sur le dos du fuselage abriterait le **Multi-Role Tactical Common Data Link** de Northrop Grumman, une suite de télécommunications en bandes Ka et Ku qui fait office de routeur et de serveur volants là où aucune infrastructure n''existe. Deux pilotes forment l''équipage.\n\n## Carrière opérationnelle\nL''USAF réceptionne en juillet 2011 le premier des quatre Global 6000 équipés du BACN, sous la désignation **E-11A**. Le 27 janvier 2020, l''un d''eux s''écrase dans la province de Ghazni, en Afghanistan, à la suite d''une panne de réacteur et d''erreurs de pilotage : ses deux membres d''équipage sont tués. En février 2021, l''Air Force annonce vouloir six appareils de plus d''ici 2026 ; le 1er juin 2021, un contrat de 464,8 millions de dollars en confie la livraison à **Learjet**, et le dernier est livré le 10 septembre 2025.\n\n## Place dans l''histoire\nL''E-11A ouvre la voie à une famille de Global militaires américains. L''US Army commande en décembre 2023 un Global 6500 de renseignement électronique, le **ME-11B HADES**, successeur du RC-12 Guardrail, livré en novembre 2024. Ailleurs, la cellule porte le radar de guet du GlobalEye, l''écoute allemande **Pegasus**, qui remplace l''Eurohawk, et le Phoenix choisi par la Corée du Sud en 2025 : un avion d''affaires conçu pour relier New York à Tokyo est devenu un porteur de capteurs recherché par une dizaine de forces aériennes.',
    E'## Genesis\nAfter buying Canadair and its Challenger 600 in 1986, **Bombardier** studied a business jet able to carry eight passengers over 12,000 km. Unveiled in October 1991 and launched in December 1993, the **Global Express** first flew on 13 October 1996 in Toronto and entered service in July 1999. Its range, its 15,500 m ceiling and its fourteen-hour endurance soon attracted the military: the Royal Air Force derived the **Sentinel R1** from it, Sweden and the Emirates the **GlobalEye**. The US Air Force wanted a communications relay for its operations in Afghanistan.\n\n## Design\nThe E-11A is a **Global 6000**, the modernised version of the Global Express, fitted by **Northrop Grumman** with the **Battlefield Airborne Communications Node** (BACN), an airborne communications hub above the battlefield. The aircraft keeps its 35-degree swept supercritical wing, its winglets and its two 65.6 kN Rolls-Royce BR710 turbofans controlled by FADEC. A fairing on top of the fuselage reportedly houses Northrop Grumman''s **Multi-Role Tactical Common Data Link**, a Ka- and Ku-band telecommunications suite that acts as a flying wireless router and server where no infrastructure exists. Two pilots make up the crew.\n\n## Operational career\nThe USAF took delivery in July 2011 of the first of four BACN-equipped Global 6000s, designated **E-11A**. On 27 January 2020 one of them crashed in Ghazni province, Afghanistan, after an engine failure and pilot errors, killing both crew members. In February 2021 the Air Force announced it wanted six more aircraft by 2026; on 1 June 2021 a $464.8 million contract gave their delivery to **Learjet**, and the last was handed over on 10 September 2025.\n\n## Place in history\nThe E-11A paved the way for a family of American military Globals. In December 2023 the US Army ordered a Global 6500 electronic intelligence aircraft, the **ME-11B HADES**, successor to the RC-12 Guardrail, delivered in November 2024. Elsewhere the airframe carries the GlobalEye''s surveillance radar, Germany''s **Pegasus** signals intelligence system replacing the Eurohawk, and the Phoenix chosen by South Korea in 2025: a business jet designed to link New York and Tokyo has become a sensor carrier sought by around ten air forces.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    NULL,
    '1996-10-13',
    '2011-07-01',
    945,
    11112,
    (SELECT id FROM manufacturer WHERE code = 'BOM'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bombardier E-11A'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Bombardier E-11A'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Bombardier E-11A'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bombardier E-11A'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Bombardier E-11A'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.3,
  wingspan          = 28.65,
  height            = 7.77,
  wing_area         = 94.9,
  empty_weight      = 23691,
  mtow              = 45132,
  service_ceiling   = 15545,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce BR700-710A2-20',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 65.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Global Express** : avion d''affaires de base, premier vol le 13 octobre 1996, mis en service en juillet 1999\n- **E-11A (BACN)** : Global 6000 équipé par Northrop Grumman du Battlefield Airborne Communications Node, premier exemplaire livré en juillet 2011\n- **E-11A (contrat de 2021)** : six appareils supplémentaires commandés à Learjet pour 464,8 millions de dollars, dernier livré le 10 septembre 2025\n- **ME-11B HADES** : Global 6500 de renseignement électronique de l''US Army, successeur du RC-12 Guardrail, livré en novembre 2024\n- **Sentinel R1 et GlobalEye** : dérivés militaires étrangers, surveillance du sol pour la RAF et guet aérien pour les Émirats et la Suède',
  variants_en       = E'- **Global Express**: baseline business jet, first flight on 13 October 1996, entered service in July 1999\n- **E-11A (BACN)**: Global 6000 fitted by Northrop Grumman with the Battlefield Airborne Communications Node, first delivered in July 2011\n- **E-11A (2021 contract)**: six more aircraft ordered from Learjet for $464.8 million, the last delivered on 10 September 2025\n- **ME-11B HADES**: US Army Global 6500 electronic intelligence aircraft, successor to the RC-12 Guardrail, delivered in November 2024\n- **Sentinel R1 and GlobalEye**: foreign military derivatives, ground surveillance for the RAF and airborne early warning for the Emirates and Sweden',

  -- Strate 4 : qualitatif
  nickname          = 'BACN',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bombardier_Global_Express',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bombardier_Global_Express',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mark Herlihy, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Bombardier E-11A';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bombardier E-11A';
