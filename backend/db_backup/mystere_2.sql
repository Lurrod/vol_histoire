-- Dassault MD 452 Mystère II
--
-- Photo : Dassault Mystère IIC ‘013’ (52695271153).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Dassault_Mystère_IIC_‘013’_(52695271153).jpg

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
    'Mystère II',
    'Mystère II',
    'Dassault MD 452 Mystère II',
    'Dassault MD.452 Mystère II',
    'Ouragan à aile en flèche, premier avion français à dépasser Mach 1 et chasseur de transition vers le Mystère IV',
    'A swept-wing Ouragan, the first French aircraft past Mach 1 and an interim fighter on the road to the Mystère IV',
    '/assets/airplanes/mystere-2.jpg',
    E'## Genèse\nAprès le succès de l''**Ouragan**, **Dassault** veut un chasseur plus rapide sans repartir de zéro. En février 1950, l''avionneur obtient un contrat pour étudier une voilure mince adaptable à l''Ouragan, qui doit lui permettre d''approcher le mur du son. La flèche passe de 14 à 30 degrés, le fuselage s''allonge légèrement et l''avion reçoit les premières servocommandes construites en série en France. **Marcel Dassault** le baptise lui-même **MD 452 Mystère**, en souvenir du roman *Le Docteur Mystère* de Paul d''Ivoi qui l''avait passionné enfant. Le premier prototype vole le 23 février 1951.\n\n## Conception\nLe Mystère reste au fond un Ouragan à aile en flèche, aux empennages retouchés. Trois Mystère I sont suivis de deux Mystère IIA motorisés par le **Rolls-Royce Tay** construit sous licence par Hispano-Suiza et armés de quatre canons de 20 mm, puis de quatre Mystère IIB qui les troquent contre deux canons-revolvers **DEFA** de 30 mm. Le 28 octobre 1951, un Mystère IIA devient le premier avion français à dépasser Mach 1 en vol contrôlé, en piqué. Onze avions de présérie, les Mystère IIC, essaient ensuite le réacteur axial **SNECMA Atar 101**, dont deux exemplaires dotés de postcombustion.\n\n## Carrière opérationnelle\nL''Armée de l''air commande 150 Mystère IIC. Le premier avion de série vole en juin 1954 et est livré en octobre ; il reçoit l''Atar 101D de 29,4 kN, une dérive plus inclinée et des entrées d''air revues. La 10e escadre de chasse de Creil en est la première dotée, suivie par la 5e escadre d''Orange. La mise en œuvre est difficile : disponibilité dépassant rarement 50 %, accidents nombreux, dont celui qui tue le pilote **André Tesson** au meeting de Valenciennes en juin 1954. Le dernier exemplaire est livré en 1957, alors que l''avion est déjà relégué à l''entraînement avancé, rôle qu''il tient jusqu''en 1963. Israël, d''abord intéressé, lui préfère le Mystère IVA, et l''appareil n''est jamais engagé au combat.\n\n## Place dans l''histoire\nAvion de transition, dépassé avant même d''être opérationnel par le **Mystère IVA** qui vole déjà, le Mystère II n''en est pas moins une étape décisive. Il donne à Dassault l''expérience de la flèche et des vitesses transsoniques, et inaugure en série le réacteur Atar qui équipera toute la lignée suivante. Le **Mystère IV**, puis le **Super Mystère B2**, en descendent directement. Des prototypes et avions de présérie, seul le 013 a survécu : il est exposé au musée de Savigny-lès-Beaune, reconnaissable à sa verrière basculante unique dans la série.',
    E'## Genesis\nAfter the success of the **Ouragan**, **Dassault** wanted a faster fighter without starting from scratch. In February 1950 the firm won a contract to study a thin wing that could be fitted to the Ouragan and take it close to the speed of sound. Sweep rose from 14 to 30 degrees, the fuselage was slightly lengthened and the aircraft received the first series-built powered flying controls in France. **Marcel Dassault** named it **MD.452 Mystère** himself, after Paul d''Ivoi''s novel *Le Docteur Mystère*, which had thrilled him as a boy. The first prototype flew on 23 February 1951.\n\n## Design\nThe Mystère was essentially an Ouragan with a swept wing and revised tail surfaces. Three Mystère I prototypes were followed by two Mystère IIAs powered by the **Rolls-Royce Tay**, licence-built by Hispano-Suiza, and armed with four 20 mm cannon, then by four Mystère IIBs that traded them for two 30 mm **DEFA** revolver cannon. On 28 October 1951 a Mystère IIA became the first French aircraft to exceed Mach 1 in controlled flight, in a dive. Eleven pre-production Mystère IICs then tried out the axial-flow **SNECMA Atar 101**, two of them with an afterburner.\n\n## Operational career\nThe French Air Force ordered 150 Mystère IICs. The first production aircraft flew in June 1954 and was delivered in October, with the 29.4 kN Atar 101D, a more steeply swept fin and revised intake trunking. The 10th Fighter Wing at Creil was the first unit to receive it, followed by the 5th Wing at Orange. It proved hard to operate, with monthly availability rarely above 50 per cent and many accidents, including the one that killed **André Tesson** at the Valenciennes air show in June 1954. The last aircraft was delivered in 1957, by which time the type had already been relegated to advanced training, a role it kept until 1963. Israel, initially interested, chose the Mystère IVA instead, and the aircraft never saw combat.\n\n## Place in history\nAn interim type, overtaken before it even entered service by the **Mystère IVA**, which was already flying, the Mystère II was nonetheless a decisive step. It gave Dassault its experience of swept wings and transonic speeds, and introduced into series production the Atar engine that would power the whole family that followed. The **Mystère IV** and then the **Super Mystère B2** descend directly from it. Of the prototypes and pre-production aircraft, only number 013 survives, at the Savigny-lès-Beaune museum, recognisable by a hinged canopy unique in the series.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1950-02-01',
    '1951-02-23',
    '1954-10-01',
    1060,
    885,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mystère II'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mystère II'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mystère II'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Mystère II'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Mystère II'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.7,
  wingspan          = 13.1,
  height            = 4.26,
  wing_area         = 30.3,
  empty_weight      = 5225,
  mtow              = 7500,
  service_ceiling   = 15250,
  climb_rate        = 23,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA Atar 101D',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 29.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1957,
  units_built       = 170,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Mystère I** : trois prototypes, Ouragan à aile en flèche de 30°, dont deux à réacteur Rolls-Royce Tay 250\n- **Mystère IIA** : deux prototypes à réacteur Tay, armés de quatre canons Hispano de 20 mm\n- **Mystère IIB** : quatre prototypes armés de deux canons DEFA de 30 mm\n- **Mystère IIC** : onze avions de présérie (Atar 101C, deux en Atar 101F à postcombustion) puis 150 avions de série à Atar 101D\n- **MD 453 Mystère IIIN** : prototype biplace de chasse de nuit à entrées d''air latérales, premier vol le 18 juillet 1952',
  variants_en       = E'- **Mystère I**: three prototypes, an Ouragan with a 30° swept wing, two of them powered by the Rolls-Royce Tay 250\n- **Mystère IIA**: two Tay-powered prototypes armed with four 20 mm Hispano cannon\n- **Mystère IIB**: four prototypes armed with two 30 mm DEFA cannon\n- **Mystère IIC**: eleven pre-production aircraft (Atar 101C, two with the afterburning Atar 101F), then 150 production aircraft with the Atar 101D\n- **MD.453 Mystère IIIN**: two-seat night-fighter prototype with lateral intakes, first flown on 18 July 1952',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_Mystère_II',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_Mystère',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Mystère II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mystère II';
