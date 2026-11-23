-- Scottish Aviation Pioneer CC.1
--
-- Photo : Scottish Aviation Pioneer.jpg
--   licence CC BY-SA 4.0 — AntanO
--   https://commons.wikimedia.org/wiki/File:Scottish_Aviation_Pioneer.jpg

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
    'Scottish Aviation Pioneer',
    'Scottish Aviation Pioneer',
    'Scottish Aviation Pioneer CC.1',
    'Scottish Aviation Pioneer CC.1',
    'Le monomoteur écossais qui décollait en 69 m pour évacuer les blessés de la jungle malaise',
    'The Scottish single-engined aircraft that took off in 69 m to evacuate casualties from the Malayan jungle',
    '/assets/airplanes/scottish-aviation-pioneer.jpg',
    E'## Genèse\nLe Pioneer naît d''une commande du ministère de l''Air britannique, la spécification **A.4/45**, qui réclame un avion léger de liaison. **Scottish Aviation**, installée à Prestwick, propose un monoplan triplace à aile haute et cabine fermée, motorisé par un **de Havilland Gipsy Queen** de 240 ch. Quatre prototypes sont commandés sous le nom de « Prestwick Pioneer », deux seulement sont achevés, et le premier vole en novembre 1947. Ses performances sont décevantes : la Royal Air Force ne le commande pas.\n\n## Conception\nScottish Aviation se tourne alors vers une version civile, le **Pioneer II**, en remplaçant le moteur par un **Alvis Leonides** de 520 ch, plus de deux fois plus puissant. L''appareil ainsi transformé vole le 5 mai 1950 et démontre d''excellentes performances de décollage court. Les avions de série reçoivent des becs de bord d''attaque sur toute l''envergure et de grands volets de type Fowler : il leur suffit de 69 m pour décoller et de 60 m pour se poser, et ils ne décrochent, moteur en marche et volets sortis, qu''à 58 km/h. La cabine reçoit un pilote et jusqu''à quatre passagers.\n\n## Carrière opérationnelle\nConvaincue cette fois, la RAF le commande sous le nom de **Pioneer CC.1**. Le premier exemplaire livré, le 11 août 1953, n''est autre que le prototype de 1947, remotorisé. Capable d''opérer depuis des pistes très courtes et non préparées, le Pioneer sert intensivement à l''évacuation des blessés pendant l''**insurrection malaise**, notamment au No. 267 Squadron basé à Kuala Lumpur de 1954 à 1958, puis à **Aden**, où le No. 78 Squadron l''utilise à Khormaksar, et à Chypre. La RAF en reçoit 40 ; l''aviation de Ceylan en achète quatre, celle de Malaisie neuf, et l''aviation du sultan d''Oman reprend quatre appareils de la RAF de 1959 à 1962.\n\n## Place dans l''histoire\nLe Pioneer reste en service en petit nombre jusqu''en 1969, notamment au No. 209 Squadron de Seletar. Construit à 59 exemplaires, il donne naissance au **Twin Pioneer** bimoteur. Il montre qu''un moteur puissant et une aile soigneusement hypersustentée suffisent à transformer un avion de liaison raté en outil d''évacuation sanitaire de premier ordre. Des exemplaires sont conservés au RAF Museum, à Ratmalana au Sri Lanka et à Kuala Lumpur.',
    E'## Genesis\nThe Pioneer stemmed from a British Air Ministry requirement, Specification **A.4/45**, calling for a light communication aircraft. Prestwick-based **Scottish Aviation** offered a three-seat high-wing cabin monoplane powered by a 240 hp **de Havilland Gipsy Queen**. Four prototypes were ordered as the ''Prestwick Pioneer'', only two were completed, and the first flew in November 1947. Its performance was disappointing: the Royal Air Force did not order it.\n\n## Design\nScottish Aviation then turned to a civil version, the **Pioneer II**, replacing the engine with a 520 hp **Alvis Leonides**, more than twice as powerful. The converted aircraft flew on 5 May 1950 and showed excellent short take-off performance. Production aircraft received full-span leading-edge slats and large Fowler flaps: they needed just 69 m to take off and 60 m to land, and with power on and flaps down they did not stall until 58 km/h. The cabin held a pilot and up to four passengers.\n\n## Operational career\nConvinced this time, the RAF ordered it as the **Pioneer CC.1**. The first aircraft delivered, on 11 August 1953, was none other than the 1947 prototype, re-engined. Able to operate from very short, unprepared strips, the Pioneer was used extensively for casualty evacuation during the **Malayan Emergency**, notably with No. 267 Squadron at Kuala Lumpur from 1954 to 1958, then in **Aden**, where No. 78 Squadron flew it from Khormaksar, and in Cyprus. The RAF received 40; the Royal Ceylon Air Force bought four, the Royal Malayan Air Force nine, and the Sultan of Oman''s Air Force took over four ex-RAF aircraft from 1959 to 1962.\n\n## Place in history\nThe Pioneer remained in service in small numbers until 1969, notably with No. 209 Squadron at Seletar. Built in 59 examples, it gave rise to the twin-engined **Twin Pioneer**. It showed that a powerful engine and a carefully designed high-lift wing could turn a failed communication aircraft into a first-rate casualty evacuation tool. Examples survive at the RAF Museum, at Ratmalana in Sri Lanka and in Kuala Lumpur.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1945-01-01',
    '1947-11-05',
    '1953-08-11',
    261,
    680,
    (SELECT id FROM manufacturer WHERE code = 'SAL'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Pioneer'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Pioneer'), (SELECT id FROM tech WHERE name = 'Hypersustentation ADAC'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Pioneer'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Scottish Aviation Pioneer'), (SELECT id FROM wars WHERE name = 'Insurrection malaise'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.46,
  wingspan          = 15.16,
  height            = 3.12,
  wing_area         = 36,
  empty_weight      = 1740,
  mtow              = 2631,
  service_ceiling   = 7000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Alvis Leonides 502/4 (520 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 59,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **Prestwick Pioneer (Pioneer I)** : prototype à moteur Gipsy Queen de 240 ch, premier vol en novembre 1947\n- **Pioneer II** : version civile à moteur Alvis Leonides de 520 ch, premier vol le 5 mai 1950\n- **Pioneer CC.1** : version militaire d''évacuation sanitaire et de liaison de la RAF, 40 exemplaires\n- Développé en **Twin Pioneer** bimoteur',
  variants_en       = E'- **Prestwick Pioneer (Pioneer I)**: prototype with a 240 hp Gipsy Queen, first flight in November 1947\n- **Pioneer II**: civil version with a 520 hp Alvis Leonides, first flight on 5 May 1950\n- **Pioneer CC.1**: RAF casualty evacuation and communication version, 40 aircraft\n- Developed into the twin-engined **Twin Pioneer**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Scottish_Aviation_Pioneer',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'AntanO',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Scottish Aviation Pioneer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Scottish Aviation Pioneer';
