-- Iliouchine Il-102
--
-- Photo : IŁ-102 NTW 3 95 1.jpg
--   licence Public domain — Piotr Butowski
--   https://commons.wikimedia.org/wiki/File:IŁ-102_NTW_3_95_1.jpg

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
    'Iliouchine Il-102',
    'Ilyushin Il-102',
    'Iliouchine Il-102',
    'Ilyushin Il-102',
    'Le dernier chtourmovik d''Iliouchine, avion d''attaque blindé à tourelle de queue face au Su-25',
    'Ilyushin''s last shturmovik, an armoured attack jet with a tail turret, beaten by the Su-25',
    '/assets/airplanes/il102.jpg',
    E'## Genèse\nEn 1967, l''armée de l''air soviétique définit le programme d''un **chtourmovik** à réaction, un avion d''attaque au sol blindé. Tandis que **Soukhoï** dessine un monoplace entièrement nouveau, le futur **Su-25**, **Iliouchine** propose une version modifiée de son **Il-40** de 1953, désignée **Il-42** : un biplace doté d''une tourelle arrière télécommandée. Les militaires rejettent le projet. Iliouchine décide pourtant de poursuivre le développement sur ses propres fonds et rebaptise le programme **Il-102**.\n\n## Conception\nL''Il-102 est un monoplan à aile basse, à flèche modérée de 30°, propulsé par deux turboréacteurs double flux **Klimov RD-33I** de 51 kN, version sans postcombustion du moteur du **MiG-29**. Sa singularité est une tourelle de queue armée d''un canon **GSh-23L** de 23 mm, commandée à distance par un mitrailleur assis dans un poste au-dessus du bord de fuite : une disposition qu''aucun avion d''attaque n''avait connue depuis les **Il-2** et **Il-10** de la Seconde Guerre mondiale, ses ancêtres directs dans l''esprit. Postes d''équipage, moteurs et réservoirs sont blindés contre les tirs venus du sol. Un canon **GSh-30-2** de 30 mm sous le fuselage et jusqu''à 7 200 kg de charges, en soutes d''aile et sur huit points d''emport, complètent l''armement.\n\n## Essais\nLe premier prototype vole le 25 septembre 1982 ; une seconde cellule est construite pour les essais statiques. L''appareil accomplit 250 vols d''essai avant d''être immobilisé en 1984, à l''expiration du potentiel de ses moteurs, et son développement s''arrête là. Il atteint 950 km/h et peut convoyer sur 3 000 km. En 1992, le prototype n° 10201 est pourtant dévoilé au public au salon **Mosaeroshow** de Joukovski, et présenté comme disponible à l''exportation.\n\n## Place dans l''histoire\nSurclassé par le Su-25, plus simple et monoplace, l''Il-102 n''a jamais été retenu pour la production. Il reste l''aboutissement de la lignée des chtourmoviks d''Iliouchine, née avec l''Il-2, et une exception en son temps, avec une défense arrière confiée à un mitrailleur. Depuis 2005, son prototype volant est exposé à l''**Institut de recherches en vol Gromov**, témoin d''une conception de l''appui aérien que l''armée soviétique avait choisi de ne pas suivre.',
    E'## Genesis\nIn 1967 the Soviet Air Forces drew up a requirement for a jet-powered **shturmovik**, an armoured ground-attack aircraft. While **Sukhoi** designed an all-new single-seater, the future **Su-25**, **Ilyushin** proposed a modified version of its 1953 **Il-40** under the designation **Il-42**: a two-seater with a remotely controlled rear gun turret. The air force rejected the design. Ilyushin nevertheless decided to continue development with its own funds and renamed the programme **Il-102**.\n\n## Design\nThe Il-102 is a low-wing monoplane with a moderate 30-degree sweep, powered by two **Klimov RD-33I** turbofans of 51 kN, non-afterburning versions of the engine of the **MiG-29**. Its most unusual feature is a tail turret with a 23 mm **GSh-23L** cannon, remotely controlled by a gunner seated in a cockpit above the wing trailing edge: an arrangement no ground-attack aircraft had used since the Second World War **Il-2** and **Il-10**, its spiritual ancestors. The crew cockpits, engines and fuel tanks were armoured against ground fire. A 30 mm **GSh-30-2** cannon under the fuselage and up to 7,200 kg of stores, in wing bomb bays and on eight pylons, completed the armament.\n\n## Testing\nThe first prototype flew on 25 September 1982; a second airframe was built for static tests. The aircraft made 250 test flights before being grounded in 1984 when its engine life expired, and development ended there. It reached 950 km/h and had a ferry range of 3,000 km. In 1992 the prototype, No. 10201, was nonetheless unveiled to the public at the **Mosaeroshow** at Zhukovsky and offered for export.\n\n## Place in history\nSurpassed by the simpler single-seat Su-25, the Il-102 was never chosen for production. It stands as the culmination of Ilyushin''s shturmovik line, which began with the Il-2, and as an exception in its day, with its rear defence entrusted to a gunner. Since 2005 its flying prototype has been displayed at the **Gromov Flight Research Institute**, a reminder of an approach to close air support that the Soviet Air Forces chose not to follow.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1967-01-01',
    '1982-09-25',
    NULL,
    950,
    3000,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-102'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-102'), (SELECT id FROM armement WHERE name = 'GSh-30-2')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-102'), (SELECT id FROM armement WHERE name = 'GSh-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-102'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-102'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.5,
  wingspan          = 16.9,
  height            = 5.08,
  wing_area         = 63.5,
  empty_weight      = 13000,
  mtow              = 22000,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Klimov RD-33I',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 51,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Il-42** : projet initial dérivé de l''Il-40, rejeté par l''armée de l''air soviétique\n- **Il-102 n° 10201** : prototype volant, 250 vols d''essai de 1982 à 1984\n- **Cellule d''essais statiques** : second exemplaire, jamais destiné au vol\n- **Tourelle de queue télécommandée** armée d''un canon GSh-23L, servie par un mitrailleur',
  variants_en       = E'- **Il-42**: initial project derived from the Il-40, rejected by the Soviet Air Forces\n- **Il-102 No. 10201**: flying prototype, 250 test flights from 1982 to 1984\n- **Static test airframe**: second example, never intended to fly\n- **Remotely controlled tail turret** with a GSh-23L cannon, manned by a gunner',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-102',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-102',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Piotr Butowski',
  image_licence     = 'Public domain'
WHERE name = 'Iliouchine Il-102';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-102';
