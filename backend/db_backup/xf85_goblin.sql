-- McDonnell XF-85 Goblin
--
-- Photo : McDonnell XF-85 Goblin USAF.jpg
--   licence Public domain — U.S. Air Force photo
--   https://commons.wikimedia.org/wiki/File:McDonnell_XF-85_Goblin_USAF.jpg

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
    'McDonnell XF-85 Goblin',
    'McDonnell XF-85 Goblin',
    'McDonnell XF-85 Goblin',
    'McDonnell XF-85 Goblin',
    'Chasseur parasite en forme d''œuf, conçu pour vivre dans la soute d''un bombardier et s''y raccrocher en vol',
    'An egg-shaped parasite fighter, designed to live in a bomber''s bay and hook back on in flight',
    '/assets/airplanes/xf85-goblin.jpg',
    E'## Genèse\nPendant la guerre, les bombardiers américains étaient escortés par des P-47 et des P-51, mais aucun chasseur ne peut suivre le rayon d''action des futurs **Northrop XB-35** et **Convair B-36**. Le ravitaillement en vol paraît encore risqué, et un chasseur à long rayon d''action coûterait cher. Les United States Army Air Forces retiennent donc l''idée d''un chasseur parasite, emporté par le bombardier lui-même. **McDonnell**, seul industriel à répondre à l''appel d''offres de décembre 1942 puis à ses révisions, présente le 19 mars 1945 son **Model 27D**, dessiné par l''équipe d''**Herman D. Barkey**.\n\n## Conception\nLe Goblin mesure 4,52 m de long : un fuselage en forme d''œuf, trois dérives en fourche, un empennage à fort dièdre et des ailes en flèche de 37° qui se replient pour tenir dans une soute. Il n''a pas de train d''atterrissage ; un crochet escamotable dans le nez sert à l''accrocher à un trapèze sous le bombardier, qui le largue et le récupère en vol. Le pilote dispose malgré tout d''un siège éjectable, et quatre mitrailleuses de 12,7 mm sont prévues. L''US Air Force envisage des B-36 porteurs de trois ou quatre Goblin au lieu de bombes.\n\n## Essais\nFaute de B-36 disponible, les essais se font sous un **EB-29B** baptisé Monstro, dans la soute duquel le Goblin reste à moitié exposé. Le 23 août 1948, **Edwin Schoch** est largué à 6 000 m et vole dix minutes, mais la turbulence du bombardier rend le raccrochage très délicat : au quatrième essai, il heurte le trapèze, perd sa verrière et doit se poser sur le ventre à Muroc. Le premier raccrochage réussit le 14 octobre 1948. Sur sept vols libres, totalisant 2 h 19 min, trois seulement se terminent par un raccrochage, les autres par un atterrissage forcé. Schoch reste le seul pilote à l''avoir jamais piloté.\n\n## Place dans l''histoire\nL''US Air Force annule le programme le 24 octobre 1949 : le Goblin est moins performant que les chasseurs à réaction qu''il aurait affrontés, le raccrochage exige une habileté hors du commun, et le ravitaillement en vol des chasseurs classiques devient praticable. L''idée du chasseur parasite survit dans les projets Tip Tow, Tom-Tom et **FICON**, qui reprend les leçons du Goblin pour un trapèze affiné. Les deux prototypes sont exposés, à Dayton et dans le Nebraska.',
    E'## Genesis\nDuring the war American bombers were escorted by P-47s and P-51s, but no fighter could match the range of the future **Northrop XB-35** and **Convair B-36**. Aerial refuelling still seemed risky, and a long-range fighter would be expensive. The United States Army Air Forces therefore chose the idea of a parasite fighter, carried by the bomber itself. **McDonnell**, the only company to answer the December 1942 request and its later revisions, submitted its **Model 27D** on 19 March 1945, designed by the team of **Herman D. Barkey**.\n\n## Design\nThe Goblin was 4.52 m long: an egg-shaped fuselage, three forked fins, a tailplane with marked dihedral and 37-degree swept wings that folded to fit in a bomb bay. It had no landing gear; a retractable hook in the nose attached it to a trapeze under the bomber, which launched and recovered it in flight. The pilot still had an ejection seat, and four 12.7 mm machine guns were planned. The US Air Force considered B-36 carriers with three or four Goblins instead of bombs.\n\n## Testing\nWith no B-36 available, tests were flown under an **EB-29B** named Monstro, in whose bay the Goblin remained half exposed. On 23 August 1948 **Edwin Schoch** was released at 6,000 m and flew for ten minutes, but turbulence from the bomber made hooking up very difficult: on the fourth attempt he struck the trapeze, lost his canopy and had to belly-land at Muroc. The first successful hook-up came on 14 October 1948. Of seven free flights, totalling 2 hours 19 minutes, only three ended in a hook-up, the others in forced landings. Schoch remained the only pilot ever to fly it.\n\n## Place in history\nThe US Air Force cancelled the programme on 24 October 1949: the Goblin was outperformed by the jet fighters it would have faced, hooking up demanded exceptional skill, and aerial refuelling of conventional fighters was becoming practical. The parasite fighter idea lived on in the Tip Tow, Tom-Tom and **FICON** projects, the last of which drew on the Goblin''s lessons for a refined trapeze. Both prototypes are on display, at Dayton and in Nebraska.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-03-19',
    '1948-08-23',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell XF-85 Goblin'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell XF-85 Goblin'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell XF-85 Goblin'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'McDonnell XF-85 Goblin'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 4.52,
  wingspan          = 6.43,
  height            = 2.51,
  wing_area         = 8.4,
  empty_weight      = 1696,
  mtow              = 2540,
  service_ceiling   = 14630,
  climb_rate        = 64,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse XJ34-WE-22',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 13.3,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Model 27** : premier projet, chasseur à moitié exposé sous le bombardier, refusé pour sa traînée\n- **Model 27D / XP-85** : version redessinée et repliable, désignée XF-85 Goblin en juin 1948\n- **46-523** : premier prototype, endommagé par une chute de grue en soufflerie, exposé au musée de l''US Air Force à Dayton\n- **46-524** : second prototype, auteur des premiers vols, exposé sous l''aile d''un B-36 au Strategic Air and Space Museum\n- **P-85 de série** : 30 exemplaires envisagés, plus d''une centaine si les essais étaient concluants, jamais commandés',
  variants_en       = E'- **Model 27**: first design, a fighter carried half exposed under the bomber, rejected for its drag\n- **Model 27D / XP-85**: redesigned folding version, renamed XF-85 Goblin in June 1948\n- **46-523**: first prototype, damaged when dropped from a crane during wind tunnel tests, displayed at the US Air Force museum in Dayton\n- **46-524**: second prototype, which made the first flights, displayed under the wing of a B-36 at the Strategic Air and Space Museum\n- **Production P-85**: 30 aircraft planned, over a hundred if testing succeeded, never ordered',

  -- Strate 4 : qualitatif
  nickname          = 'Goblin',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_XF-85_Goblin',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_XF-85_Goblin',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'McDonnell XF-85 Goblin';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'McDonnell XF-85 Goblin';
