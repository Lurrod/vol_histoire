-- Boulton Paul P.111
--
-- Photo : Boulton Paul P111A.JPG
--   licence CC BY-SA 4.0 — Geni
--   https://commons.wikimedia.org/wiki/File:Boulton_Paul_P111A.JPG

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
    'Boulton Paul P.111',
    'Boulton Paul P.111',
    'Boulton Paul P.111',
    'Boulton Paul P.111',
    'Delta sans queue à bouts d''aile interchangeables, si sensible que son pilote le comparait au fil du rasoir',
    'A tailless delta with swappable wingtips, so touchy its pilot likened it to flying a razor''s edge',
    '/assets/airplanes/bp-p111.jpg',
    E'## Genèse\nAu lendemain de la Seconde Guerre mondiale, les Alliés cherchent à exploiter les avancées aéronautiques allemandes, au premier rang desquelles l''aile delta, alors mal connue. L''Air Ministry émet la spécification **E.27/46**, qui demande un avion expérimental pour étudier la stabilité et la maniabilité d''une voilure delta. **Boulton Paul** y répond et confie le projet à son chef designer, **S. C. Redshaw**. Le **P.111** est conçu comme la plus petite cellule possible capable d''abriter un réacteur **Rolls-Royce Nene**, un siège éjectable **Martin-Baker** et une aile delta ; sa construction demande environ trois ans.\n\n## Conception\nLe Nene, à compresseur centrifuge, est large : le fuselage est donc trapu, alimenté par une entrée d''air ovale aplatie dans le nez. L''aile delta, mince et en flèche de 45°, est tronquée à environ 75 % du delta pur, mais deux paires d''extensions de bout d''aile permettent de varier sa forme jusqu''à un delta presque complet, sans refaire la voilure. Le roulis et le tangage passent par deux élevons, et le P.111 reçoit l''une des toutes premières commandes de vol entièrement assistées, hydrauliques. Sans empennage horizontal, il porte une dérive à pointe amovible, coiffée d''une antenne VHF et dotée d''une caméra dans son bord d''attaque.\n\n## Essais\nDémonté et convoyé par la route jusqu''à Boscombe Down, faute de piste assez longue à Pendeford, le P.111 vole le 10 octobre 1950 avec le Squadron Leader **Bob Smyth**. Son principal pilote, **Alexander « Ben » Gunn**, le juge « nerveux », « comme voler sur le fil du rasoir » : les commandes assistées n''offrent aucune sensation, le train provoque de fortes variations de compensation et l''atterrissage est rapide. Après un atterrissage train rentré, il est réparé et modifié en **P.111A** : quatre aérofreins en pétales, trappes de train revues, perche de nez et peinture jaune vif qui lui vaut le surnom de « Yellow Peril ». Il revole le 2 juillet 1953 et sert au Royal Aircraft Establishment jusqu''à son dernier vol, le 20 juin 1958.\n\n## Place dans l''histoire\nAvec l''**Avro 707**, contemporain qui préparait le Vulcan, le P.111 compte parmi les premiers avions conçus pour explorer l''aile delta sans queue. Il a volé avec ses trois configurations de bouts d''aile et a été suivi du **P.120**, son jumeau à empennage horizontal, construit pour comparer les deux formules. Après avoir servi de cellule d''instruction au Cranfield College of Aeronautics, il est exposé depuis 1975 au Midland Air Museum de Coventry.',
    E'## Genesis\nAfter the Second World War, the Allies set out to exploit German aeronautical advances, chief among them the then little-understood delta wing. The Air Ministry issued Specification **E.27/46**, calling for an experimental aircraft to study the stability and controllability of a delta planform. **Boulton Paul** answered it and gave the project to its chief designer, **S. C. Redshaw**. The **P.111** was designed as the smallest airframe able to house a **Rolls-Royce Nene** jet, a **Martin-Baker** ejection seat and a delta wing; it took about three years to build.\n\n## Design\nThe centrifugal-flow Nene was wide, so the fuselage was tubby, fed by a flattened oval nose intake. The thin delta wing, swept at 45 degrees, was cropped at about 75 per cent of a pure delta, but two pairs of tip extensions allowed its shape to be varied up to an almost complete delta without rebuilding the wing. Roll and pitch were handled by two elevons, and the P.111 had one of the very first fully powered, hydraulic flight control systems. With no tailplane, it carried a fin with a removable tip, topped by a VHF aerial and with a camera in its leading edge.\n\n## Testing\nTaken by road to Boscombe Down, as the grass strips at Pendeford were too short, the P.111 flew on 10 October 1950 with Squadron Leader **Bob Smyth**. Its main pilot, **Alexander ''Ben'' Gunn**, found it ''touchy'', ''like flying a razor''s edge'': the powered controls had no feel, the undercarriage caused large trim changes and landings were fast. After a wheels-up landing it was repaired and modified as the **P.111A**: four petal airbrakes, revised undercarriage doors, a nose probe and a bright yellow finish that earned it the nickname ''Yellow Peril''. It flew again on 2 July 1953 and served with the Royal Aircraft Establishment until its last flight on 20 June 1958.\n\n## Place in history\nAlong with the **Avro 707**, a contemporary built to prepare the Vulcan, the P.111 was among the first aircraft designed to explore the tailless delta. It flew with all three wingtip configurations and was followed by the **P.120**, its twin with a tailplane, built to compare the two layouts. After serving as an instructional airframe at the Cranfield College of Aeronautics, it has been displayed since 1975 at the Midland Air Museum in Coventry.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1946-01-01',
    '1950-10-10',
    NULL,
    1045,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boulton Paul P.111'), (SELECT id FROM tech WHERE name = 'Aile delta'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boulton Paul P.111'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.95,
  wingspan          = 7.82,
  height            = 3.81,
  wing_area         = 25.01,
  empty_weight      = 3410,
  mtow              = 4594,
  service_ceiling   = NULL,
  climb_rate        = 48,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Nene 3 RN.2',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 23.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **P.111** : version d''origine, non peinte ou argentée, commandes assistées sans sensation, premier vol le 10 octobre 1950\n- **P.111A** : reconstruit après un atterrissage train rentré, quatre aérofreins, trappes de train revues, perche de nez, livrée jaune, premier vol le 2 juillet 1953\n- **Bouts d''aile** : vol sans extension (envergure 7,82 m) ou avec l''une des deux paires d''extensions (9,07 m et 10,21 m)',
  variants_en       = E'- **P.111**: original version, unpainted or silver, powered controls without feel, first flight on 10 October 1950\n- **P.111A**: rebuilt after a wheels-up landing, four airbrakes, revised undercarriage doors, nose probe, yellow finish, first flight on 2 July 1953\n- **Wingtips**: flown without extensions (7.82 m span) or with either pair of extensions (9.07 m and 10.21 m)',

  -- Strate 4 : qualitatif
  nickname          = 'Yellow Peril',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boulton_Paul_P.111',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boulton_Paul_P.111',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Geni',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Boulton Paul P.111';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boulton Paul P.111';
