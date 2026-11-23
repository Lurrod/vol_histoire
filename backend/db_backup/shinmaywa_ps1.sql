-- Shin Meiwa PS-1
--
-- Photo : PS-1 (13779941653).jpg
--   licence CC BY-SA 2.0 — Rob Schleiffert from Holland
--   https://commons.wikimedia.org/wiki/File:PS-1_(13779941653).jpg

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
    'ShinMaywa PS-1',
    'ShinMaywa PS-1',
    'Shin Meiwa PS-1',
    'Shin Meiwa PS-1',
    'Hydravion chasseur de sous-marins qui se posait en pleine mer, douze fois par mission, pour tremper son sonar',
    'A submarine-hunting flying boat that alighted on the open sea a dozen times per mission to dip its sonar',
    '/assets/airplanes/shinmaywa-ps1.jpg',
    E'## Genèse\nInterdite d''aviation en 1945, l''ancienne firme d''hydravions **Kawanishi** devient **ShinMeiwa** et se tourne vers les machines lourdes. Au début des années 1950, un comité dirigé par l''ingénieur **Shizo Kikuhara** se fixe un but ambitieux : un hydravion capable de se poser sur une mer formée sans souffrir des vagues ni des embruns. En 1961, la firme propose ce concept à l''Agence de défense japonaise pour la lutte anti-sous-marine, avec l''appui de l''US Navy, désireuse de voir le Japon surveiller les sous-marins soviétiques du Pacifique. L''US Navy fournit un **HU-16 Albatross**, transformé en banc d''essai **UF-XS**, qui vole à partir de 1962.\n\n## Conception\nEn 1966, la force maritime d''autodéfense commande deux prototypes **PS-X** ; le premier vole le 5 octobre 1967. En 1968, dans le canal de Kii, l''un d''eux amerrit dans des creux de quatre mètres, au-delà de l''objectif de trois. Le secret tient au **contrôle de la couche limite**, alimenté par une turbine à gaz indépendante logée dans la coque, au souffle des quatre turbopropulseurs dirigé sur l''aile et à un dispositif qui écarte les gerbes d''eau. À 36 000 kg, il décolle ou amerrit sur 220 m d''eau sans vent. Le PS-1 est un pur hydravion à coque, qui n''emporte qu''un train de halage pour sortir de l''eau. Dix hommes servent à bord.\n\n## Carrière opérationnelle\nCommandés à vingt et un exemplaires en 1969, les PS-1 entrent en service de 1971 à 1978 et forment à partir de 1973 la **Fleet Air Wing 31**. Ils emportent torpilles à autodirecteur, grenades sous-marines et roquettes **Zuni** de 127 mm, sans aucune arme défensive, ainsi que vingt bouées acoustiques et un sonar trempé. Celui-ci impose de se poser : une patrouille type couvre des centaines de kilomètres carrés d''océan et amerrit douze à seize fois. Le prix est lourd : quatre accidents mortels entre 1977 et 1984. En 1976, un exemplaire est converti en bombardier d''eau de 7 350 litres.\n\n## Place dans l''histoire\nDans les années 1980, la marine japonaise remplace le PS-1 par le **P-3 Orion**, avion terrestre ; les derniers sont retirés en 1989. Le programme, contesté pour le coût unitaire élevé d''une petite série, a pourtant donné au Japon un savoir-faire unique. La version amphibie de sauvetage qui en dérive, le **US-1A**, et son successeur le **US-2** en sont l''héritage direct. Le seul PS-1 exposé, le 5813 d''Iwakuni, est menacé de démolition depuis novembre 2026.',
    E'## Genesis\nBanned from aviation in 1945, the former flying boat maker **Kawanishi** became **ShinMeiwa** and turned to heavy machinery. In the early 1950s a committee led by engineer **Shizo Kikuhara** set itself an ambitious goal: a seaplane able to land on a rough sea without suffering from the waves and spray. In 1961 the company offered the concept to the Japan Defense Agency for anti-submarine warfare, with the backing of the US Navy, keen to see Japan track Soviet submarines in the Pacific. The US Navy supplied an **HU-16 Albatross**, converted into the **UF-XS** testbed, which flew from 1962.\n\n## Design\nIn 1966 the Maritime Self-Defense Force ordered two **PS-X** prototypes; the first flew on 5 October 1967. In 1968, in the Kii Channel, one of them alighted amid four-metre waves, beyond its three-metre design goal. The secret lay in **boundary layer control**, powered by an independent gas turbine housed in the hull, in the slipstream of the four turboprops directed over the wing and in a system that suppressed spray. At 36,000 kg it could take off or alight within 220 m of water with no wind. The PS-1 was a pure flying boat, carrying only beaching gear to come ashore. Ten men served aboard.\n\n## Operational career\nOrdered as a batch of twenty-one in 1969, the PS-1s entered service from 1971 to 1978 and from 1973 formed **Fleet Air Wing 31**. They carried homing torpedoes, depth charges and 127 mm **Zuni** rockets, with no defensive weapons at all, as well as twenty sonobuoys and a dipping sonar. The sonar required a landing: a typical patrol covered hundreds of square miles of ocean and alighted twelve to sixteen times. The price was high: four fatal accidents between 1977 and 1984. In 1976 one aircraft was converted into a 7,350-litre water bomber.\n\n## Place in history\nIn the 1980s the Japanese navy replaced the PS-1 with the land-based **P-3 Orion**; the last ones were retired in 1989. The programme, criticised for the high unit cost of a small production run, nevertheless gave Japan unique expertise. The amphibious rescue version derived from it, the **US-1A**, and its successor the **US-2** are its direct legacy. The only PS-1 on display, 5813 at Iwakuni, has faced demolition since November 2026.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1966-01-01',
    '1967-10-05',
    '1971-01-01',
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'SHM'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'ShinMaywa PS-1'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion')),
((SELECT id FROM airplanes WHERE name = 'ShinMaywa PS-1'), (SELECT id FROM tech WHERE name = 'Aile soufflée')),
((SELECT id FROM airplanes WHERE name = 'ShinMaywa PS-1'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'ShinMaywa PS-1'), (SELECT id FROM armement WHERE name = 'Zuni 127 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'ShinMaywa PS-1'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'ShinMaywa PS-1'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 10,

  -- Strate 2 : motorisation
  engine_name       = 'Ishikawajima-Harima / General Electric T64',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 23,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **UF-XS** : HU-16 Albatross de l''US Navy transformé en banc d''essai, contrôle de la couche limite et moteurs supplémentaires, vols à partir de 1962\n- **PS-X** : deux prototypes commandés en 1966, premier vol le 5 octobre 1967\n- **PS-1** : version de série de lutte anti-sous-marine, vingt et un livrés de 1971 à 1978, retirée en 1989\n- **PS-1 bombardier d''eau** : un exemplaire converti en 1976, citerne de 7 350 litres\n- **US-1 / US-1A** : version amphibie de recherche et sauvetage qui en dérive, premier vol le 15 octobre 1974',
  variants_en       = E'- **UF-XS**: US Navy HU-16 Albatross converted into a testbed, with boundary layer control and additional engines, flown from 1962\n- **PS-X**: two prototypes ordered in 1966, first flight on 5 October 1967\n- **PS-1**: production anti-submarine version, twenty-one delivered from 1971 to 1978, retired in 1989\n- **PS-1 water bomber**: one aircraft converted in 1976, with a 7,350-litre tank\n- **US-1 / US-1A**: amphibious search and rescue version derived from it, first flight on 15 October 1974',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Shin_Meiwa_US-1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Shin_Meiwa_US-1A',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Schleiffert',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'ShinMaywa PS-1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'ShinMaywa PS-1';
