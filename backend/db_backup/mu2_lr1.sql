-- Mitsubishi MU-2 (LR-1 et MU-2S)
--
-- Photo : JGSDF LR-1 (22003) left side view at Camp Tachikawa November 2, 2025.jpg
--   licence CC BY-SA 4.0 — Hunini
--   https://commons.wikimedia.org/wiki/File:JGSDF_LR-1_(22003)_left_side_view_at_Camp_Tachikawa_November_2,_2025.jpg

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
    'Mitsubishi LR-1',
    'Mitsubishi LR-1',
    'Mitsubishi MU-2 (LR-1 et MU-2S)',
    'Mitsubishi MU-2 (LR-1 and MU-2S)',
    'Premier avion de Mitsubishi d''après-guerre, bimoteur de liaison, de reconnaissance et de sauvetage japonais',
    'Mitsubishi''s first post-war aircraft, a Japanese liaison, reconnaissance and rescue twin',
    '/assets/airplanes/mitsubishi-lr1.jpg',
    E'## Genèse\nLe **MU-2** est le premier avion que Mitsubishi conçoit après la Seconde Guerre mondiale. Les travaux commencent en 1959 : il s''agit d''un bimoteur léger de transport à turbopropulseurs, adapté dès l''origine à des emplois civils comme militaires. Le prototype vole le **14 septembre 1963**, avec des turbopropulseurs Turbomeca Astazou, avant que les Garrett TPE331 ne deviennent la règle. Produit jusqu''en 1986 au Japon et à San Angelo, au Texas, il est construit à 704 exemplaires, l''un des plus grands succès de l''aéronautique japonaise d''après-guerre.\n\n## Conception\nL''aile haute du MU-2 cache une astuce : le gauchissement est confié à des **spoilers d''extrados** et non à des ailerons, ce qui libère tout le bord de fuite pour des volets à double fente sur toute l''envergure. L''avion associe ainsi une vitesse de croisière élevée, comparable à celle d''un biréacteur léger, à une faible vitesse d''atterrissage ; les spoilers restent efficaces même aile décrochée et suppriment le lacet inverse. Pour les forces armées japonaises, Mitsubishi livre des versions non pressurisées : le **MU-2C** et le **MU-2E**, ce dernier doté d''un radôme de nez, de réservoirs agrandis, de hublots d''observation bombés et d''une porte coulissante pour larguer des radeaux.\n\n## Carrière opérationnelle\nLes forces d''autodéfense japonaises sont les seules à avoir employé le MU-2 en première ligne. La force terrestre reçoit vingt appareils, quatre MU-2C et seize MU-2K, sous la désignation **LR-1**, pour la liaison et la reconnaissance photographique ; ils servent jusqu''en 2016 et plusieurs montent aujourd''hui la garde à l''entrée de ses bases. La force aérienne achète vingt-neuf MU-2E de recherche et sauvetage, désignés **MU-2S**, remplacés en 2008 par le BAe U-125A. Ailleurs, l''armée de l''air argentine acquiert quatre MU-2 civils pendant la guerre des Malouines comme éclaireurs et relais radio.\n\n## Place dans l''histoire\nLe MU-2 marque le retour de Mitsubishi à la conception d''avions et s''impose comme l''un des plus grands succès de l''aéronautique japonaise d''après-guerre, au point d''être assemblé jusqu''au Texas. Sa formule d''aile sans ailerons, efficace mais exigeante, lui donne une place à part parmi les bimoteurs légers. Sa carrière militaire déborde même le Japon : depuis 1987, des MU-2 pilotés sous contrat par d''anciens pilotes de l''US Air Force jouent les F-15 et les MiG-29 à Tyndall, en Floride, pour former les contrôleurs de combat aérien, et quatre MU-2F servent depuis 2009 à l''instruction au sol de l''armée de l''air néo-zélandaise.',
    E'## Genesis\nThe **MU-2** was the first aircraft Mitsubishi designed after the Second World War. Work began in 1959 on a light twin-turboprop transport, suited from the outset to both civil and military roles. The prototype flew on **14 September 1963** with Turbomeca Astazou turboprops, before the Garrett TPE331 became standard. Produced until 1986 in Japan and in San Angelo, Texas, it was built in 704 examples, one of the greatest successes of post-war Japanese aviation.\n\n## Design\nThe MU-2''s high wing hides a trick: roll control is handled by **over-wing spoilers** instead of ailerons, which frees the whole trailing edge for full-span double-slotted flaps. The aircraft thus combines a high cruise speed, comparable to a light jet, with a low landing speed; the spoilers remain effective even with the wing stalled and eliminate adverse yaw. For the Japanese armed forces Mitsubishi delivered unpressurised versions: the **MU-2C** and the **MU-2E**, the latter with a thimble nose radome, larger fuel tanks, bulged observation windows and a sliding door for dropping rafts.\n\n## Operational career\nThe Japan Self-Defense Forces are the only military operators to have flown the MU-2 in front-line service. The Ground Self-Defense Force received twenty aircraft, four MU-2Cs and sixteen MU-2Ks, designated **LR-1**, for liaison and photo-reconnaissance; they served until 2016 and several now stand as gate guardians at its bases. The Air Self-Defense Force bought twenty-nine MU-2E search and rescue aircraft, designated **MU-2S**, replaced in 2008 by the BAe U-125A. Elsewhere, the Argentine Air Force acquired four civil MU-2s during the Falklands War for pathfinding and communications relay.\n\n## Place in history\nThe MU-2 marked Mitsubishi''s return to aircraft design and became one of the greatest successes of post-war Japanese aviation, to the point of being assembled as far away as Texas. Its aileron-less wing, effective but demanding, sets it apart among light twins. Its military career even extends beyond Japan: since 1987, MU-2s flown under contract by retired US Air Force pilots have played F-15s and MiG-29s at Tyndall, Florida, to train air battle managers, and since 2009 four MU-2Fs have been used for ground training by the Royal New Zealand Air Force.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1959-01-01',
    '1963-09-14',
    NULL,
    547,
    2334,
    (SELECT id FROM manufacturer WHERE code = 'MHI'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi LR-1'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi LR-1'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi LR-1'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi LR-1'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = 11.94,
  height            = 4.17,
  wing_area         = 16.55,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = 9020,
  climb_rate        = 12.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett AiResearch TPE331',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 49,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **MU-2C (LR-1)** : version non pressurisée de liaison et de reconnaissance photographique pour la force terrestre d''autodéfense, quatre exemplaires\n- **MU-2K (LR-1)** : seize appareils complétant la dotation de la force terrestre, retirés en 2016\n- **MU-2E (MU-2S)** : recherche et sauvetage pour la force aérienne, radôme de nez, réservoirs agrandis, porte de largage de radeaux, vingt-neuf exemplaires\n- **MU-2 civils** : versions à fuselage court puis allongé (MU-2G, Marquise, Solitaire), 704 exemplaires au total',
  variants_en       = E'- **MU-2C (LR-1)**: unpressurised liaison and photo-reconnaissance version for the Ground Self-Defense Force, four built\n- **MU-2K (LR-1)**: sixteen aircraft completing the Ground Self-Defense Force fleet, retired in 2016\n- **MU-2E (MU-2S)**: search and rescue for the Air Self-Defense Force, nose radome, larger tanks, raft-dropping door, twenty-nine built\n- **Civil MU-2**: short then stretched-fuselage versions (MU-2G, Marquise, Solitaire), 704 built in all',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mitsubishi_MU-2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mitsubishi_MU-2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Hunini',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Mitsubishi LR-1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mitsubishi LR-1';
