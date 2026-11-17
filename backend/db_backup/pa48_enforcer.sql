-- Piper PA-48 Enforcer
--
-- Photo : Piper PA48 Enforcer USAF.jpg
--   licence Public domain — USAF Museum
--   https://commons.wikimedia.org/wiki/File:Piper_PA48_Enforcer_USAF.jpg

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
    'Piper PA-48 Enforcer',
    'Piper PA-48 Enforcer',
    'Piper PA-48 Enforcer',
    'Piper PA-48 Enforcer',
    'Un Mustang de la Seconde Guerre mondiale réinventé en avion de contre-guérilla, refusé deux fois par l''US Air Force',
    'A Second World War Mustang reinvented as a counter-insurgency aircraft, twice turned down by the USAF',
    '/assets/airplanes/pa48-enforcer.jpg',
    E'## Genèse\nEn 1968, **David Lindsay**, patron de **Cavalier Aircraft**, qui remet à neuf des P-51 Mustang, entreprend d''en tirer un avion de contre-insurrection. Son **Turbo Mustang III** associe une cellule de Mustang II à un turbopropulseur Rolls-Royce Dart et à un blindage céramique Bristol protégeant moteur, structure et pilote. Malgré de nombreuses démarches, ni l''armée américaine ni aucun client étranger ne l''achète. Faute de moyens industriels, Lindsay vend fin 1970 le projet, rebaptisé **Enforcer**, à **Piper Aircraft**, et ferme Cavalier en 1971 pour s''y consacrer.\n\n## Conception\nEn 1971, Piper transforme profondément deux Mustang existants autour d''un turbopropulseur **Lycoming T55** : un monoplace, le PE-1, et un biplace à double commande, le PE-2. Les deux **PA-48** construits plus tard ne partagent plus que 10 % de leur structure avec le P-51 : plus longs et plus grands, ils perdent la prise d''air ventrale caractéristique du Mustang, et l''échappement de la turbine sort par une grosse tubulure sur le flanc gauche du nez. Le **Lycoming YT55-L-9** de 2 445 ch entraîne une hélice quadripale ; dix points d''emport reçoivent jusqu''à 2 580 kg de charges, et l''aile porte des réservoirs en bout.\n\n## Essais\nLe premier Enforcer vole le 29 avril 1971. Le PE-2 est perdu au large de la Floride le 12 juillet 1971, victime d''un flottement causé par un compensateur de profondeur modifié. L''appareil restant se comporte bien lors de l''évaluation **Pave Coin** de 1971-1972, pilotée par l''US Air Force, mais aucune commande ne suit. Après huit ans de pressions de Piper et de Lindsay sur le Congrès, le budget de la défense de 1979 accorde 11,9 millions de dollars pour deux nouveaux prototypes et une nouvelle évaluation. Les deux PA-48, immatriculés N481PE et N482PE, sont testés en 1983 et 1984 à Eglin et à Edwards : ils remplissent leur rôle, mais l''Air Force refuse encore de les acheter.\n\n## Place dans l''histoire\nJamais intégré à l''inventaire de l''US Air Force, l''Enforcer n''a reçu ni désignation militaire ni numéro de série. Il reste l''ultime développement du **P-51 Mustang**, et l''une des tentatives les plus obstinées d''imposer un avion de contre-guérilla à hélice à une armée de l''air qui n''en voulait pas. Des quatre prototypes, deux survivent : le N482PE, restauré, est exposé au musée des essais en vol d''Edwards depuis 2014, le N481PE au Pima Air and Space Museum.',
    E'## Genesis\nIn 1968 **David Lindsay**, head of **Cavalier Aircraft**, which rebuilt P-51 Mustangs, set out to turn one into a counter-insurgency aircraft. His **Turbo Mustang III** combined a Mustang II airframe with a Rolls-Royce Dart turboprop and Bristol ceramic armour protecting engine, structure and pilot. Despite many sales attempts, neither the US military nor any foreign customer bought it. Lacking manufacturing capacity, Lindsay sold the project, renamed **Enforcer**, to **Piper Aircraft** in late 1970, and closed Cavalier in 1971 to devote himself to it.\n\n## Design\nIn 1971 Piper heavily rebuilt two existing Mustangs around a **Lycoming T55** turboprop: a single-seater, the PE-1, and a dual-control two-seater, the PE-2. The two **PA-48s** built later shared less than 10% of their structure with the P-51: longer and larger, they lost the Mustang''s characteristic belly scoop, and the turbine exhaust left through a large pipe on the left side of the nose. The 2,445 hp **Lycoming YT55-L-9** drives a four-blade propeller; ten hardpoints carry up to 2,580 kg of stores, and the wing has tip tanks.\n\n## Testing\nThe first Enforcer flew on 29 April 1971. The PE-2 was lost off the Florida coast on 12 July 1971 to flutter caused by a modified elevator trim tab. The remaining aircraft performed well in the 1971–1972 **Pave Coin** evaluation flown by the US Air Force, but no order followed. After eight years of lobbying of Congress by Piper and Lindsay, the 1979 defence budget granted $11.9 million for two new prototypes and a fresh evaluation. The two PA-48s, registered N481PE and N482PE, were tested in 1983 and 1984 at Eglin and Edwards: they did their job, but the Air Force again declined to buy them.\n\n## Place in history\nNever part of the US Air Force inventory, the Enforcer received neither a military designation nor a serial number. It remains the final development of the **P-51 Mustang**, and one of the most stubborn attempts to sell a propeller-driven counter-insurgency aircraft to an air force that did not want one. Of the four prototypes, two survive: N482PE, restored, has been on display at the Edwards flight test museum since 2014, and N481PE at the Pima Air and Space Museum.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1968-01-01',
    '1971-04-29',
    NULL,
    555,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'PIP'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Piper PA-48 Enforcer'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Piper PA-48 Enforcer'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Piper PA-48 Enforcer'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.41,
  wingspan          = 12.6,
  height            = 2.67,
  wing_area         = 22.8,
  empty_weight      = 3266,
  mtow              = 6350,
  service_ceiling   = 7600,
  climb_rate        = 12.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 740,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming YT55-L-9 (2 445 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Cavalier Turbo Mustang III** : prototype privé à turbopropulseur Rolls-Royce Dart et blindage céramique\n- **Enforcer PE-1** : Mustang transformé par Piper en 1971, monoplace, évalué lors de Pave Coin\n- **Enforcer PE-2** : biplace à double commande, perdu le 12 juillet 1971\n- **PA-48 Enforcer** : deux prototypes quasi neufs (N481PE et N482PE), évalués en 1983-1984',
  variants_en       = E'- **Cavalier Turbo Mustang III**: private prototype with a Rolls-Royce Dart turboprop and ceramic armour\n- **Enforcer PE-1**: Mustang rebuilt by Piper in 1971, single-seat, evaluated in Pave Coin\n- **Enforcer PE-2**: dual-control two-seater, lost on 12 July 1971\n- **PA-48 Enforcer**: two almost new prototypes (N481PE and N482PE), evaluated in 1983–1984',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Piper_PA-48_Enforcer',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Piper_PA-48_Enforcer',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'National Museum of the U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Piper PA-48 Enforcer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Piper PA-48 Enforcer';
