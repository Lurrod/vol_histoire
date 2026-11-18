-- Northrop M2-F2
--
-- Photo : Northrop M2-F2.jpg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File:Northrop_M2-F2.jpg

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
    'Northrop M2-F2',
    'Northrop M2-F2',
    'Northrop M2-F2',
    'Northrop M2-F2',
    'Premier corps portant lourd de la NASA, « baignoire volante » larguée d''un B-52, célèbre pour son accident de 1967',
    'NASA''s first heavyweight lifting body, a ''flying bathtub'' dropped from a B-52, famous for its 1967 crash',
    '/assets/airplanes/northrop-m2f2.jpg',
    E'## Genèse\nLe succès du **M2-F1**, un prototype de bois remorqué par une voiture puis par un avion à Dryden, conduit la **NASA** à commander deux corps portants « lourds » tirés des études de ses centres d''**Ames** et de **Langley** : le M2-F2 et le **HL-10**, tous deux confiés à **Northrop**. Le contrat, de 1,8 million de dollars pour les deux, est passé en juin 1964, et la fabrication demande dix-neuf mois. « M » signifie « manned » (piloté) et « F » « flight » (version de vol). Il s''agit de prouver qu''un engin sans ailes, dessiné pour la rentrée atmosphérique, peut être piloté jusqu''à un atterrissage sûr.\n\n## Conception\nLe M2-F2 est tout en aluminium et perd les petites gouvernes extérieures de son devancier, qui n''auraient pas résisté à l''échauffement d''une rentrée. Sa forme de demi-cône à dos plat, terminée par deux petites dérives, lui vaut le surnom de « baignoire volante » ; un nez vitré donne au pilote la vue sur la piste. Un système d''augmentation de la stabilité aide à tenir cet engin trapu, peu stable en roulis, et quatre fusées à peroxyde d''hydrogène, de 1,8 kN au total, soutiennent l''arrondi. Pour équilibrer le moteur-fusée **XLR11** prévu à l''arrière, le poste est fait d''acier épais riveté.\n\n## Essais\nAprès un premier vol captif sous le **B-52** le 23 mars 1966, **Milton Thompson** effectue le premier vol libre le 12 juillet : largué à 13 700 m, il atteint environ 720 km/h. En seize vols planés, jusqu''en mai 1967, le moteur n''est jamais allumé ; Thompson, **Bruce Peterson**, **Don Sorlie** et **Jerry Gentry** se relaient aux commandes. Le 10 mai 1967, au seizième, Peterson est pris dans une oscillation induite par le pilote, l''engin manquant d''autorité en roulis ; distrait par un hélicoptère de secours, il dérive vers une zone du lac asséché sans repères. Le M2-F2 touche le sol avant que son train soit verrouillé et fait six tonneaux. Le poste blindé sauve Peterson, qui perd toutefois l''usage de l''œil droit.\n\n## Place dans l''histoire\nReconstruit à Dryden, l''appareil devient le **M2-F3**, doté d''une troisième dérive centrale qui corrige ses défauts de contrôle latéral. Premier des corps portants lourds à configuration de rentrée, le M2-F2 a répondu à nombre des questions de fond que posaient ces engins. Il est resté le seul accident grave de tout le programme des corps portants de la NASA. Les images de cet accident ont été reprises en 1973 par la série télévisée **L''Homme qui valait trois milliards**, même si certains plans du générique montrent en réalité le **HL-10** largué de son B-52.',
    E'## Genesis\nThe success of the **M2-F1**, a wooden prototype towed by a car and then by an aircraft at Dryden, led **NASA** to order two heavyweight lifting bodies based on studies at its **Ames** and **Langley** centres: the M2-F2 and the **HL-10**, both built by **Northrop**. The $1.8 million contract for the pair was placed in June 1964, and construction took nineteen months. The ''M'' stood for ''manned'' and the ''F'' for ''flight'' version. The aim was to prove that a wingless craft, shaped for atmospheric re-entry, could be flown to a safe landing.\n\n## Design\nThe M2-F2 was all aluminium and lost the small outboard control surfaces of its predecessor, which would not have survived the heating of a re-entry. Its half-cone shape with a flat top, ending in two small fins, earned it the nickname ''flying bathtub''; a glazed nose gave the pilot a view of the runway. A stability augmentation system helped tame this stubby craft, weak in roll, and four hydrogen peroxide rockets, 1.8 kN in all, assisted the landing flare. To balance the **XLR11** rocket engine planned at the rear, the cockpit was made of thick riveted steel.\n\n## Testing\nAfter a first captive flight under the **B-52** on 23 March 1966, **Milton Thompson** made the first free flight on 12 July: dropped at 13,700 m, he reached about 720 km/h. In sixteen glide flights, up to May 1967, the engine was never lit; Thompson, **Bruce Peterson**, **Don Sorlie** and **Jerry Gentry** took turns at the controls. On 10 May 1967, on the sixteenth, Peterson ran into a pilot-induced oscillation, the craft lacking roll authority; distracted by a rescue helicopter, he drifted towards an unmarked part of the lakebed. The M2-F2 hit the ground before its gear was locked and rolled over six times. The armoured cockpit saved Peterson, though he lost the sight of his right eye.\n\n## Place in history\nRebuilt at Dryden, the aircraft became the **M2-F3**, with a third, central fin that cured its lateral control problems. The first heavyweight lifting body in an entry configuration, the M2-F2 answered many of the generic questions these craft raised. It remained the only serious accident of NASA''s whole lifting body programme. Footage of the crash was used in 1973 in the television series **The Six Million Dollar Man**, although some shots in the opening credits actually show the **HL-10** being released from its B-52.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1964-06-01',
    '1966-07-12',
    NULL,
    750,
    16,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop M2-F2'), (SELECT id FROM tech WHERE name = 'Corps portant')),
((SELECT id FROM airplanes WHERE name = 'Northrop M2-F2'), (SELECT id FROM tech WHERE name = 'Moteur-fusée'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop M2-F2'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 6.76,
  wingspan          = 2.95,
  height            = 2.9,
  wing_area         = 14.9,
  empty_weight      = 2096,
  mtow              = 3395,
  service_ceiling   = 13716,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Reaction Motors XLR11',
  engine_count      = 1,
  engine_type       = 'Moteur-fusée à ergols liquides',
  engine_type_en    = 'Liquid-fuel rocket engine',
  thrust_dry        = 35.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **M2-F1** : devancier léger en bois, remorqué, dont le succès a lancé le programme\n- **M2-F2 (NASA 803)** : exemplaire unique, deux dérives, 16 vols planés de juillet 1966 à mai 1967\n- **M2-F3** : le M2-F2 reconstruit à Dryden après l''accident, avec une troisième dérive centrale',
  variants_en       = E'- **M2-F1**: lightweight towed wooden predecessor, whose success launched the programme\n- **M2-F2 (NASA 803)**: sole example, two fins, 16 glide flights from July 1966 to May 1967\n- **M2-F3**: the M2-F2 rebuilt at Dryden after the crash, with a third central fin',

  -- Strate 4 : qualitatif
  nickname          = 'Baignoire volante',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_M2-F2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_M2-F2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'Northrop M2-F2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Northrop M2-F2';
