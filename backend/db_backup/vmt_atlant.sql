-- Miassichtchev VM-T Atlant (3M-T)
--
-- Photo : VM-T Atlant at MAKS 2005.jpg
--   licence GFDL 1.2 — Dmitry Pichugin
--   https://commons.wikimedia.org/wiki/File:VM-T_Atlant_at_MAKS_2005.jpg

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
    'Myasishchev VM-T Atlant',
    'Myasishchev VM-T Atlant',
    'Miassichtchev VM-T Atlant (3M-T)',
    'Myasishchev VM-T Atlant (3M-T)',
    'Un bombardier stratégique reconverti pour porter sur son dos la navette Bourane et la fusée Energia',
    'A strategic bomber converted to carry the Buran shuttle and parts of the Energia rocket on its back',
    '/assets/airplanes/vmt-atlant.jpg',
    E'## Genèse\nEn 1978, le programme spatial soviétique bute sur un problème de logistique : comment acheminer jusqu''au cosmodrome de **Baïkonour** les éléments géants de la fusée **Energia** et de la navette **Bourane** ? Le bureau **Miassichtchev** est chargé de le résoudre. Plutôt que de concevoir un avion neuf, ses ingénieurs reprennent un vieux **3M**, version modifiée du bombardier **M-4 Molot**, pour en faire un transporteur stratégique : le VM-T, pour « Vladimir Miassichtchev – Transport », baptisé **Atlant**.\n\n## Conception\nLa charge voyage sur le dos de l''avion, dans de grands conteneurs profilés. Pour maîtriser un fardeau jusqu''à deux fois plus large que le fuselage, l''empennage d''origine cède la place à des plans horizontaux à dièdre portant à leurs extrémités de grandes dérives rectangulaires, et un nouveau système de commandes compense la masse ajoutée. Quatre turboréacteurs **VD-7MD** de 105,5 kN propulsent l''ensemble, qui pèse 139 tonnes au décollage sans conteneur et jusqu''à 187 tonnes avec la navette. Quatre configurations sont prévues : 0GT pour Bourane sans dérive ni équipements, 1GT pour le réservoir d''hydrogène d''Energia, 2GT pour le compartiment moteur, la case à équipements et le réservoir d''oxygène liquide de l''étage central, 3GT pour les protections des deux précédentes.\n\n## Carrière opérationnelle\nL''Atlant vole pour la première fois en 1981 et effectue son premier vol chargé en janvier 1982. Sa tâche principale consiste à convoyer les propulseurs d''Energia de leur usine jusqu''à Baïkonour ; à plusieurs reprises, il transporte aussi sur son dos la navette Bourane, encore inachevée. L''exercice est exigeant : il croise à 580 km/h, franchit 3 565 km et réclame 3 500 m de piste pour décoller avec le conteneur 1GT.\n\n## Place dans l''histoire\nDeux Atlant ont été construits. En 1989, l''**Antonov An-225 Mriya** prend leur relève. Le premier, RF-01502, est conservé à Joukovski par le TsAGI et l''Institut de recherches en vol Gromov ; le second, RA-01402, sur la base de Diaguilevo, à Riazan. L''Atlant reste l''exemple d''un vieux bombardier stratégique reconverti en déménageur du programme spatial soviétique.',
    E'## Genesis\nIn 1978 the Soviet space programme faced a logistics problem: how to move the giant components of the **Energia** rocket and the **Buran** shuttle to the **Baikonur** Cosmodrome? The **Myasishchev** bureau was asked to solve it. Rather than design a new aircraft, its engineers took an old **3M**, a modified **M-4 Molot** bomber, and turned it into a strategic airlifter: the VM-T, for ''Vladimir Myasishchev – Transport'', named **Atlant**.\n\n## Design\nThe payload rode on the aircraft''s back in large streamlined containers. To handle loads up to twice the diameter of the fuselage, the original tail gave way to dihedral horizontal stabilisers carrying large rectangular end-plate fins, and a new control system compensated for the added weight. Four **VD-7MD** turbojets of 105.5 kN powered the aircraft, which weighed 139 tonnes at take-off without a container and up to 187 tonnes with the shuttle. Four configurations were planned: 0GT for Buran without its tail and equipment, 1GT for Energia''s hydrogen tank, 2GT for the engine section, instrument section and liquid oxygen tank of the core stage, and 3GT for the protective covers of the previous two.\n\n## Operational career\nThe Atlant first flew in 1981 and made its first flight with cargo in January 1982. Its main task was to ferry Energia rocket boosters from their factory to Baikonur; on several occasions it also carried the still incomplete Buran shuttle piggyback. It was demanding work: the aircraft cruised at 580 km/h, had a range of 3,565 km and needed a 3,500 m take-off run with the 1GT container.\n\n## Place in history\nTwo Atlants were built. In 1989 the **Antonov An-225 Mriya** took over their task. The first, RF-01502, is kept at Zhukovsky by TsAGI and the Gromov Flight Research Institute; the second, RA-01402, at Dyagilevo air base in Ryazan. The Atlant remains an example of an old strategic bomber converted into a removal van for the Soviet space programme.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1978-01-01',
    '1981-01-01',
    '1982-01-01',
    NULL,
    3565,
    (SELECT id FROM manufacturer WHERE code = 'MYA'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev VM-T Atlant'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev VM-T Atlant'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 51.23,
  wingspan          = 53.14,
  height            = NULL,
  wing_area         = 351.78,
  empty_weight      = 81200,
  mtow              = 187000,
  service_ceiling   = 10200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Dobrynin VD-7MD',
  engine_count      = 4,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 105.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **VM-T Atlant (3M-T)** : deux bombardiers 3M transformés, RF-01502 et RA-01402\n- **Conteneur 0GT** : navette Bourane sans dérive ni équipements, 45,3 t\n- **Conteneur 1GT** : réservoir d''hydrogène d''Energia, 31,5 t pour 44,46 m de long\n- **Conteneur 2GT** : compartiment moteur, case à équipements et réservoir d''oxygène de l''étage central, 30 t\n- **Conteneur 3GT** : protections des charges 1GT et 2GT, 15 t',
  variants_en       = E'- **VM-T Atlant (3M-T)**: two converted 3M bombers, RF-01502 and RA-01402\n- **0GT container**: Buran shuttle without tail and equipment, 45.3 t\n- **1GT container**: Energia hydrogen tank, 31.5 t and 44.46 m long\n- **2GT container**: engine section, instrument section and oxygen tank of the core stage, 30 t\n- **3GT container**: protective covers for the 1GT and 2GT payloads, 15 t',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Miassichtchev_VM-T',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Myasishchev_VM-T',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Dmitry Pichugin',
  image_licence     = 'GFDL 1.2'
WHERE name = 'Myasishchev VM-T Atlant';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Myasishchev VM-T Atlant';
