-- de Havilland Canada DHC-4 Caribou (C-7)
--
-- Photo : DHC C-7A Caribou '39-756 - KN' (11634633534).jpg
--   licence CC BY 2.0 — FotoSleuth
--   https://commons.wikimedia.org/wiki/File%3ADe_Havilland_Canada_DHC-4_Caribou_%2826953044062%29.jpg

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
    'DHC-4 Caribou',
    'DHC-4 Caribou',
    'de Havilland Canada DHC-4 Caribou (C-7)',
    'de Havilland Canada DHC-4 Caribou (C-7)',
    'Avion de brousse militarisé, capable de se poser en 300 mètres',
    'Militarised bush aircraft, able to land in 300 metres',
    '/assets/airplanes/dhc4-caribou.jpg',
    E'## Genèse\nDe Havilland Canada s''est fait une spécialité de l''**avion de brousse** : desservir le Grand Nord canadien impose de décoller court, de se poser sur n''importe quoi et de tomber en panne le moins possible. L''US Army, qui cherche un appareil capable de ravitailler ses unités avancées sans dépendre de l''Air Force, y voit exactement ce qu''il lui faut et en commande cent cinquante-neuf.\n\n## Conception\nAile haute de très grande surface, volets sur toute l''envergure, empennage relevé très haut pour dégager la rampe arrière. Les deux moteurs en étoile sont anciens mais increvables et se réparent sans atelier. Le résultat est spectaculaire : **deux cent vingt mètres au décollage**, trois cents à l''atterrissage, pour quatre tonnes de fret — un C-130 en demande trois fois plus.\n\n## Carrière opérationnelle\nLe **Vietnam** est son théâtre : les Caribou ravitaillent les camps des forces spéciales taillés dans la jungle, sur des bandes que rien d''autre ne peut utiliser. En 1967, un accord interarmées transfère toute la flotte de l''armée de terre à l''US Air Force — la même logique qui avait désarmé l''OV-1 Mohawk. L''Australie l''exploite jusqu''en 2009, quarante-cinq ans durant.\n\n## Place dans l''histoire\nTrois cent sept exemplaires, vingt pays. Il a défini une catégorie qui n''existait pas : le transport tactique **à décollage et atterrissage courts**, entre l''hélicoptère et le C-130. Son successeur, le DHC-5 Buffalo, poussera la formule plus loin, mais aucun appareil moderne n''a retrouvé ce rapport entre la charge utile et la longueur de piste.',
    E'## Genesis\nDe Havilland Canada had made a speciality of the **bush aircraft**: serving the Canadian Far North means taking off short, landing on anything and breaking down as little as possible. The US Army, looking for an aircraft able to resupply its forward units without depending on the Air Force, saw exactly what it needed and ordered a hundred and fifty-nine.\n\n## Design\nA high wing of very large area, full-span flaps, and a tail set high to clear the rear ramp. The two radial engines are old but unbreakable and can be repaired without a workshop. The result is spectacular: **two hundred and twenty metres to take off**, three hundred to land, with four tonnes of freight — a C-130 needs three times as much.\n\n## Operational career\n**Vietnam** was its theatre: Caribous resupplied special forces camps cut out of the jungle, on strips nothing else could use. In 1967 an inter-service agreement transferred the whole fleet from the Army to the US Air Force — the same logic that had disarmed the OV-1 Mohawk. Australia flew it until 2009, forty-five years in all.\n\n## Place in history\nThree hundred and seven built, twenty countries. It defined a category that did not exist: **short take-off and landing** tactical transport, between the helicopter and the C-130. Its successor, the DHC-5 Buffalo, pushed the formula further, but no modern aircraft has matched that ratio of payload to runway length.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1956-01-01',
    '1958-07-30',
    '1961-01-01',
    348.0,
    2100.0,
    (SELECT id FROM manufacturer WHERE code = 'DHC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 22.13,
  wingspan          = 29.15,
  height            = 9.7,
  wing_area         = 84.7,
  empty_weight      = 8283,
  mtow              = 12930,
  service_ceiling   = 7560,
  climb_rate        = 6.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 390,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2000-7M2',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1958,
  production_end    = 1973,
  units_built       = 307,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 20,
  variants          = E'- **CV-2 / C-7 Caribou** : désignations successives dans l''armée américaine\n- **CC-108** : version canadienne, employée en Nouvelle-Guinée et au Congo\n- **DHC-5 Buffalo** : successeur à turbopropulseurs, plus puissant\n- Transféré de l''**armée de terre à l''US Air Force** en 1967, par accord interarmées\n- Décolle en **220 m** et se pose en 300 : performances d''avion de brousse pour 4 tonnes de fret',
  variants_en       = E'- **CV-2 / C-7 Caribou** : successive designations in American service\n- **CC-108** : Canadian version, used in New Guinea and the Congo\n- **DHC-5 Buffalo** : turboprop successor, more powerful\n- Transferred from the **Army to the US Air Force** in 1967 by inter-service agreement\n- Takes off in **220 m** and lands in 300: bush aircraft performance with 4 tonnes of freight',

  -- Strate 4 : qualitatif
  nickname          = 'Wallaby',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Canada_DHC-4_Caribou',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Canada_DHC-4_Caribou',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Weston, Spalding, Lincs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'DHC-4 Caribou';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'DHC-4 Caribou';
