-- Beechcraft C-12 Huron
--
-- Photo : C-12 Huron in flight.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:C-12_Huron_in_flight.jpg

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
    'Beechcraft C-12 Huron',
    'Beechcraft C-12 Huron',
    'Beechcraft C-12 Huron',
    'Beechcraft C-12 Huron',
    'Super King Air militarisé, utilitaire des quatre armes américaines devenu avion espion en Irak et en Afghanistan',
    'Militarised Super King Air, utility aircraft of four US services that became a spy plane over Iraq and Afghanistan',
    '/assets/airplanes/c12-huron.jpg',
    E'## Genèse\nEn 1969, Beechcraft dérive de son **King Air 100** le **Super King Air 200**, plus puissant et doté d''un empennage en T. L''US Army et l''US Air Force cherchent alors un avion de transport léger déjà existant, dans le prolongement des **U-21 Ute** : Beech propose son Super King Air avec de simples changements d''équipement et obtient un premier contrat de 34 appareils. Désignés d''abord U-25A, les premiers C-12A entrent en service dans l''Army en 1974 comme avions de liaison et de transport de personnel.\n\n## Conception\nLe C-12 est un Super King Air 200 pris sur étagère : biturbopropulseur pressurisé à aile droite, empennage en T et moteurs Pratt & Whitney Canada **PT6A**. Au fil des commandes, la famille s''étend : porte cargo de 1,32 m pour l''UC-12B de la Navy, train renforcé pour terrains sommaires sur le C-12D, version de 19 places, le C-12J, tirée du Beechcraft 1900. Les versions de renseignement poussent la cellule plus loin : les RC-12 **Guardrail** reçoivent des PT6A-67 de 1 200 ch, l''empennage du 1900 et une masse au décollage portée à 7,3 t pour emporter leurs capteurs d''écoute électronique.\n\n## Carrière opérationnelle\nL''Army emploie ses Huron au soutien de ses unités et des ambassades, l''Air Force aux liaisons entre bases et la Navy, qui commande 64 UC-12B jusqu''en 1982, à la logistique entre ses stations aéronavales ; ses TC-12B forment des pilotes multimoteurs jusqu''au 16 mai 2017. Pendant la **guerre froide**, des RC-12 recueillent des renseignements sur l''Allemagne de l''Est. Le 10 juin 2009, le **MC-12W Liberty**, un King Air 350 bardé de capteurs, effectue sa première mission en Irak : en 79 000 sorties et 400 000 heures au-dessus de l''Irak et de l''Afghanistan, il aide à tuer ou capturer plus de 8 000 combattants selon l''Air Force, avant de céder sa place au MQ-9 Reaper en 2015.\n\n## Place dans l''histoire\nPlus de cinquante ans après son entrée en service, le C-12 reste l''utilitaire à tout faire des forces américaines, des liaisons d''ambassade à la surveillance du champ de bataille, et sert aussi en Argentine, au Canada, en Grèce, en Israël, au Pakistan et aux Philippines. Le Marine Corps prévoit de remplacer ses UC-12F et M par des UC-12W, tirés du King Air 350, d''ici 2032. L''Army, qui aligne encore 116 King Air en janvier 2025, annonce le 11 décembre 2025 le retrait de sa flotte de surveillance Guardrail.',
    E'## Genesis\nIn 1969 Beechcraft derived the **Super King Air 200** from its **King Air 100**, with more power and a T-tail. The US Army and US Air Force were then looking for an existing light transport to follow the **U-21 Ute**: Beech offered its Super King Air with minor equipment changes and won a first contract for 34 aircraft. Initially designated U-25A, the first C-12As entered Army service in 1974 as liaison and personnel transports.\n\n## Design\nThe C-12 is an off-the-shelf Super King Air 200: a pressurised twin turboprop with a straight wing, T-tail and Pratt & Whitney Canada **PT6A** engines. Order after order, the family grew: a 1.32 m cargo door for the Navy''s UC-12B, rough-field landing gear on the C-12D, and a 19-seat version, the C-12J, based on the Beechcraft 1900. The intelligence versions pushed the airframe further: the RC-12 **Guardrail** aircraft received 1,200 shp PT6A-67s, the 1900''s tail and a take-off weight raised to 7.3 t to carry their signals intelligence sensors.\n\n## Operational career\nThe Army used its Hurons to support its units and embassies, the Air Force for liaison between bases and the Navy, which ordered 64 UC-12Bs up to 1982, for logistics between its air stations; its TC-12Bs trained multi-engine pilots until 16 May 2017. During the **Cold War**, RC-12s gathered intelligence on East Germany. On 10 June 2009 the **MC-12W Liberty**, a sensor-laden King Air 350, flew its first combat mission over Iraq: in 79,000 sorties and 400,000 hours over Iraq and Afghanistan it helped kill or capture more than 8,000 fighters according to the Air Force, before giving way to the MQ-9 Reaper in 2015.\n\n## Place in history\nMore than fifty years after entering service, the C-12 remains the US forces'' all-purpose utility aircraft, from embassy liaison to battlefield surveillance, and also serves in Argentina, Canada, Greece, Israel, Pakistan and the Philippines. The Marine Corps plans to replace its UC-12Fs and Ms with King Air 350-based UC-12Ws by 2032. The Army, which still had 116 King Airs in January 2025, announced on 11 December 2025 the retirement of its Guardrail surveillance fleet.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1969-01-01',
    NULL,
    '1974-01-01',
    535,
    2690,
    (SELECT id FROM manufacturer WHERE code = 'BEE'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft C-12 Huron'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft C-12 Huron'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Beechcraft C-12 Huron'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft C-12 Huron'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Beechcraft C-12 Huron'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'Beechcraft C-12 Huron'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.34,
  wingspan          = 16.61,
  height            = 4.6,
  wing_area         = 28.1,
  empty_weight      = 3518,
  mtow              = 5670,
  service_ceiling   = 10700,
  climb_rate        = 12.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-42 (850 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1974,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 7,
  variants          = E'- **C-12A / C-12C** : liaison et transport d''attachés pour l''Army et l''Air Force, 60 C-12A pour l''Army et 30 pour l''USAF, puis 14 C-12C neufs à PT6A-41\n- **UC-12B / TC-12B** : version de la Navy et du Marine Corps à porte cargo, 66 construites ; 20 converties en écoles multimoteurs\n- **C-12D / C-12F** : porte cargo agrandie et train pour terrains sommaires, puis version de soutien opérationnel louée par l''USAF à partir de 1984\n- **RC-12 Guardrail (D, H, K, N, P, Q, X)** : écoute électronique de l''Army, jusqu''à des PT6A-67 de 1 200 ch et 7,3 t au décollage\n- **C-12J** : version de 19 places tirée du Beechcraft 1900C, six construites\n- **MC-12W Liberty** : King Air 350 de renseignement, surveillance et reconnaissance de l''USAF, 42 appareils engagés en Irak et en Afghanistan',
  variants_en       = E'- **C-12A / C-12C**: liaison and attaché transport for the Army and Air Force, 60 C-12As for the Army and 30 for the USAF, then 14 new-build PT6A-41 C-12Cs\n- **UC-12B / TC-12B**: Navy and Marine Corps version with a cargo door, 66 built; 20 converted into multi-engine trainers\n- **C-12D / C-12F**: enlarged cargo door and rough-field gear, then an operational support version leased by the USAF from 1984\n- **RC-12 Guardrail (D, H, K, N, P, Q, X)**: Army signals intelligence, up to 1,200 shp PT6A-67s and 7.3 t take-off weight\n- **C-12J**: 19-seat version based on the Beechcraft 1900C, six built\n- **MC-12W Liberty**: USAF intelligence, surveillance and reconnaissance King Air 350, 42 aircraft flown over Iraq and Afghanistan',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beechcraft_C-12_Huron',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beechcraft_C-12_Huron',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Beechcraft C-12 Huron';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beechcraft C-12 Huron';
