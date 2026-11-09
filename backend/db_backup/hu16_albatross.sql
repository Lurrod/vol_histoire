-- Grumman HU-16 Albatross
--
-- Photo : Grumman UF-1 Albatross USN in flight 1950s.jpeg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Grumman_UF-1_Albatross_USN_in_flight_1950s.jpeg

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
    'HU-16 Albatross',
    'HU-16 Albatross',
    'Grumman HU-16 Albatross',
    'Grumman HU-16 Albatross',
    'L’amphibie qui allait chercher les équipages abattus jusque dans les eaux ennemies',
    'The amphibian that fetched downed crews from enemy waters',
    '/assets/airplanes/hu16-albatross.jpg',
    E'## Genèse\nGrumman tire l''Albatross de son petit amphibie civil **Mallard** pour répondre à un besoin de l''US Navy : un hydravion utilitaire capable de se poser en pleine mer, sur une piste ou, muni de skis, sur la neige et la glace. Le prototype XJR2F-1 vole le 24 octobre 1947. L''US Air Force, qui cherche un appareil pour récupérer ses équipages tombés en mer, l''adopte dès 1949 sous la désignation SA-16.\n\n## Conception\nUne coque profonde à redan, des flotteurs sous les ailes, un train tricycle escamotable : l''Albatross se pose sur l''eau comme sur une piste. Deux moteurs en étoile **Wright R-1820 Cyclone** de 1 425 ch sont placés haut sur une aile droite, loin des embruns. La version HU-16B reçoit une aile allongée d''environ cinq mètres et un empennage agrandi, qui améliorent nettement les performances sur un seul moteur.\n\n## Carrière opérationnelle\nEn **Corée**, les SA-16 du service de sauvetage de l''US Air Force vont chercher les pilotes abattus jusque dans les eaux contrôlées par l''adversaire. Au **Vietnam**, les HU-16B récupèrent des équipages tombés dans le golfe du Tonkin avant d''être relayés par les hélicoptères de sauvetage. Quatre cent soixante-six exemplaires sont construits de 1949 à 1961 et plus d''une vingtaine de pays les emploient, des garde-côtes américains à la Grèce, qui en fait un patrouilleur anti-sous-marin jusqu''en 1995. En 1973, un HU-16B porte à 10 023 m le record d''altitude des amphibies bimoteurs.\n\n## Place dans l''histoire\nL''Albatross est l''aboutissement de la lignée d''amphibies Grumman et l''un des derniers hydravions militaires américains. Robuste et simple, capable de se poser là où aucun avion ni hélicoptère de son époque ne pouvait aller, il a fait du sauvetage en mer une mission à part entière. Le **ShinMaywa US-1A** japonais et le **Beriev Be-12** soviétique perpétuent ensuite la formule de l''amphibie militaire.',
    E'## Genesis\nGrumman derived the Albatross from its small civil **Mallard** amphibian to meet a US Navy need: a utility flying boat able to land on the open sea, on a runway or, fitted with skis, on snow and ice. The XJR2F-1 prototype flew on 24 October 1947. The US Air Force, looking for an aircraft to recover crews downed at sea, adopted it in 1949 as the SA-16.\n\n## Design\nA deep stepped hull, floats under the wings, a retractable tricycle undercarriage: the Albatross lands on water as readily as on a runway. Two **Wright R-1820 Cyclone** radial engines of 1,425 hp sit high on a straight wing, clear of the spray. The HU-16B version received a wing lengthened by about five metres and an enlarged tail, markedly improving single-engine performance.\n\n## Operational career\nOver **Korea**, the SA-16s of the US Air Force rescue service went to fetch downed pilots even from waters held by the enemy. In **Vietnam**, HU-16Bs picked up crews downed in the Gulf of Tonkin before rescue helicopters took over. Four hundred and sixty-six were built between 1949 and 1961 and more than twenty countries used them, from the US Coast Guard to Greece, which flew it as an anti-submarine patrol aircraft until 1995. In 1973 an HU-16B raised the altitude record for twin-engined amphibians to 10,023 m.\n\n## Place in history\nThe Albatross is the culmination of Grumman''s line of amphibians and one of the last American military flying boats. Rugged and simple, able to land where no aircraft or helicopter of its time could go, it made rescue at sea a mission in its own right. The Japanese **ShinMaywa US-1A** and the Soviet **Beriev Be-12** later carried the military amphibian formula forward.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1947-10-24',
    '1949-01-01',
    380.0,
    4587.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HU-16 Albatross'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'HU-16 Albatross'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HU-16 Albatross'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'HU-16 Albatross'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'HU-16 Albatross'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'HU-16 Albatross'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'HU-16 Albatross'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'HU-16 Albatross'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.15,
  wingspan          = 29.46,
  height            = 7.87,
  wing_area         = 96.2,
  empty_weight      = 10380,
  mtow              = 17010,
  service_ceiling   = 6550,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-1820-76A Cyclone 9',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1961,
  units_built       = 466,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **SA-16A / UF-1** : premières versions de série de l''US Air Force et de l''US Navy\n- **HU-16B** : aile allongée et empennage agrandi, désignation unifiée de 1962\n- **HU-16E** : version des garde-côtes américains, utilisée jusqu''au début des années 1980\n- **HU-16B ASW** : version anti-sous-marine d''exportation, notamment pour la Norvège et la Grèce\n- Record d''altitude des amphibies bimoteurs : **10 023 m** en 1973',
  variants_en       = E'- **SA-16A / UF-1** : first production versions for the US Air Force and US Navy\n- **HU-16B** : lengthened wing and enlarged tail, unified 1962 designation\n- **HU-16E** : US Coast Guard version, flown into the early 1980s\n- **HU-16B ASW** : export anti-submarine version, notably for Norway and Greece\n- Twin-engined amphibian altitude record: **10,023 m** in 1973',

  -- Strate 4 : qualitatif
  nickname          = 'Albatross',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_HU-16_Albatross',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_HU-16_Albatross',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'HU-16 Albatross';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'HU-16 Albatross';
