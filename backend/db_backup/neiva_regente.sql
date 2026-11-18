-- Neiva U-42 / L-42 Regente
--
-- Photo : Neiva Regente (8141394375).jpg
--   licence CC BY-SA 3.0 — Aeroprints.com
--   https://commons.wikimedia.org/wiki/File:Neiva_Regente_(8141394375).jpg

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
    'Neiva Regente',
    'Neiva Regente',
    'Neiva U-42 / L-42 Regente',
    'Neiva U-42 / L-42 Regente',
    'L''utilitaire et l''avion d''observation conçus au Brésil pour la Força Aérea Brasileira',
    'The utility and observation aircraft designed in Brazil for the Brazilian Air Force',
    '/assets/airplanes/neiva-regente.jpg',
    E'## Genèse\nEn 1959, l''industriel brésilien **Indústria Aeronáutica Neiva** lance l''étude d''un utilitaire léger quadriplace : un monoplan à aile haute, cabine fermée et train fixe. Le prototype, baptisé **Regente 360C**, vole le 7 septembre 1961 avec un moteur Continental O-300 de 145 ch. Le projet intéresse la **Força Aérea Brasileira**, qui le commande en série à condition qu''il reçoive un moteur plus puissant.\n\n## Conception\nLa version militaire adopte un quatre-cylindres à plat **Lycoming O-360-A1D** de 180 ch entraînant une hélice bipale Hartzell à vitesse constante. Le Regente est un avion compact, de 7 m de long et 9 m d''envergure, qui pèse 640 kg à vide et peut emporter un pilote et trois passagers à plus de 200 km/h, sur près de 930 km. Pour l''observation, Neiva dérive un triplace, le **Regente 420L** : son cône arrière est abaissé pour dégager la vue vers l''arrière, son moteur Continental IO-360D développe 210 ch, et des points d''emport sous voilure lui permettent d''emporter des bombes légères ou des roquettes.\n\n## Carrière opérationnelle\nL''armée de l''air brésilienne reçoit quatre-vingts Regente utilitaires, désignés d''abord **U-42**, puis **C-42**, et employés à la liaison et au transport léger, notamment depuis la base aérienne de Santa Cruz. Le prototype de la version d''observation vole en janvier 1967 sous le nom de **YL-42**, et quarante exemplaires de série entrent en service sous la désignation **L-42**, après avoir porté un temps celles de L-8 et de L-20. Le Zimbabwe figure aussi parmi les utilisateurs militaires du Regente.\n\n## Place dans l''histoire\nAvec 120 appareils militaires et deux exemplaires de la version civile **Lanceiro**, dont le programme s''arrête lorsque Neiva se rapproche d''**Embraer**, le Regente reste une production modeste. Il marque pourtant une étape : un avion de conception brésilienne, produit en série au Brésil pour l''armée de l''air brésilienne de 1963 à 1975, décliné à la fois en utilitaire de liaison et en avion d''observation armé à partir d''une même cellule.',
    E'## Genesis\nIn 1959 the Brazilian manufacturer **Indústria Aeronáutica Neiva** began designing a four-seat light utility aircraft: a high-wing cabin monoplane with fixed landing gear. The prototype, named **Regente 360C**, flew on 7 September 1961 with a 145 hp Continental O-300. The project caught the interest of the **Brazilian Air Force**, which ordered it into production on condition that it received a more powerful engine.\n\n## Design\nThe military version adopted a 180 hp **Lycoming O-360-A1D** flat-four driving a two-blade Hartzell constant-speed propeller. The Regente is a compact aircraft, 7 m long with a 9 m span, weighing 640 kg empty and able to carry a pilot and three passengers at over 200 km/h for nearly 930 km. For observation, Neiva derived a three-seater, the **Regente 420L**: its rear fuselage was lowered to improve the rearward view, its Continental IO-360D produced 210 hp, and underwing hardpoints let it carry light bombs or rockets.\n\n## Operational career\nThe Brazilian Air Force received eighty utility Regentes, first designated **U-42**, then **C-42**, and used for liaison and light transport, notably from Santa Cruz air base. The prototype of the observation version flew in January 1967 as the **YL-42**, and forty production aircraft entered service as the **L-42**, having briefly carried the designations L-8 and L-20. Zimbabwe was also among the Regente''s military users.\n\n## Place in history\nWith 120 military aircraft and two examples of the civil **Lanceiro**, whose programme ended when Neiva became involved with **Embraer**, the Regente remained a modest production run. Yet it marks a milestone: an aircraft designed in Brazil and series-built there for the Brazilian Air Force from 1963 to 1975, produced both as a liaison utility aircraft and as an armed observation aircraft from the same airframe.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1959-01-01',
    '1961-09-07',
    '1963-01-01',
    220,
    928,
    (SELECT id FROM manufacturer WHERE code = 'NEI'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Neiva Regente'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Neiva Regente'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.04,
  wingspan          = 9.13,
  height            = 2.93,
  wing_area         = 13.45,
  empty_weight      = 640,
  mtow              = 1040,
  service_ceiling   = 3600,
  climb_rate        = 3.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming O-360-A1D (180 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1975,
  units_built       = 120,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Regente 360C** : prototype à moteur Continental O-300 de 145 ch, premier vol le 7 septembre 1961\n- **U-42 / C-42** : version utilitaire de l''armée de l''air brésilienne, moteur Lycoming O-360 de 180 ch, 80 exemplaires\n- **Regente 420L (YL-42 / L-42)** : triplace d''observation à cône arrière abaissé et moteur de 210 ch, 40 exemplaires\n- **Lanceiro** : version civile quadriplace, deux exemplaires',
  variants_en       = E'- **Regente 360C**: prototype with a 145 hp Continental O-300, first flight on 7 September 1961\n- **U-42 / C-42**: Brazilian Air Force utility version, 180 hp Lycoming O-360, 80 built\n- **Regente 420L (YL-42 / L-42)**: three-seat observation aircraft with lowered rear fuselage and 210 hp engine, 40 built\n- **Lanceiro**: four-seat civil version, two built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Neiva_Regente',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Aeroprints.com',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Neiva Regente';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Neiva Regente';
