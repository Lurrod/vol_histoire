-- Northrop / McDonnell Douglas YF-23 Black Widow II
--
-- Photo : Northrop-McDonnell Douglas YF-23 Black Widow II.jpg
--   licence CC BY 4.0 — Logan Rickert
--   https://commons.wikimedia.org/wiki/File%3ANorthrop-McDonnell_Douglas_YF-23_Black_Widow_II.jpg

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
    'YF-23 Black Widow II',
    'YF-23 Black Widow II',
    'Northrop / McDonnell Douglas YF-23 Black Widow II',
    'Northrop / McDonnell Douglas YF-23 Black Widow II',
    'Plus furtif et plus rapide que le F-22, et pourtant écarté',
    'Stealthier and faster than the F-22, and passed over all the same',
    '/assets/airplanes/yf23.jpg',
    E'## Genèse\nLe programme **ATF** cherche en 1986 le chasseur qui remplacera le F-15 : furtif, capable de croiser en supersonique sans postcombustion, et de vaincre le Su-27. Deux équipes sont retenues pour construire des prototypes — Lockheed avec le YF-22, Northrop associé à McDonnell Douglas avec le YF-23. C''est le plus grand marché militaire de la fin du siècle.\n\n## Conception\nNorthrop pousse la furtivité et la vitesse plus loin que son concurrent. L''empennage se réduit à **deux dérives très inclinées** faisant office de profondeur, les tuyères débouchent dans des gouttières refroidies creusées dans le fuselage arrière pour masquer la signature infrarouge, et la voilure en losange est dessinée pour aligner tous les bords. Le YF-23 dépasse le YF-22 en supercroisière et en discrétion. Il renonce en revanche à la **poussée vectorielle** et donc à l''agilité extrême aux basses vitesses.\n\n## Carrière opérationnelle\nAucune. Le 23 avril 1991, l''US Air Force retient le YF-22. Les raisons officielles ne portent pas sur les performances : Lockheed a présenté un dossier de production et de coûts jugé plus crédible, et Northrop sortait des difficultés du programme B-2. L''agilité démontrée par le YF-22, qui a tiré des missiles en essais quand le YF-23 ne l''a jamais fait, a pesé aussi.\n\n## Place dans l''histoire\nDeux exemplaires, cinquante heures de vol chacun, et un débat qui n''a jamais cessé chez les ingénieurs : le meilleur avion a-t-il perdu ? Le **F-22 Raptor** a été produit à cent quatre-vingt-sept exemplaires puis arrêté ; le YF-23 reste, pour beaucoup, la démonstration que le choix d''un programme d''armement n''est jamais seulement technique.',
    E'## Genesis\nThe **ATF** programme set out in 1986 to find the fighter that would replace the F-15: stealthy, able to cruise supersonically without afterburner, and to defeat the Su-27. Two teams were selected to build prototypes — Lockheed with the YF-22, Northrop partnered with McDonnell Douglas with the YF-23. It was the largest military contract of the late century.\n\n## Design\nNorthrop pushed stealth and speed further than its rival. The tail is reduced to **two sharply canted fins** doubling as elevators, the exhausts vent into cooled troughs cut into the rear fuselage to mask the infrared signature, and the diamond wing is drawn to align every edge. The YF-23 bettered the YF-22 in supercruise and in stealth. It gave up **thrust vectoring**, however, and with it extreme low-speed agility.\n\n## Operational career\nNone. On 23 April 1991 the US Air Force chose the YF-22. The official reasons did not concern performance: Lockheed presented a production and cost case judged more credible, and Northrop was emerging from the troubles of the B-2 programme. The agility demonstrated by the YF-22, which fired missiles in testing when the YF-23 never did, also weighed.\n\n## Place in history\nTwo aircraft, fifty flight hours each, and a debate that has never ended among engineers: did the better aircraft lose? The **F-22 Raptor** was built in one hundred and eighty-seven examples and then stopped; for many, the YF-23 remains the demonstration that choosing a weapons programme is never purely technical.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1986-10-01',
    '1990-08-27',
    NULL,
    2655.0,
    4200.0,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'YF-23 Black Widow II'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'YF-23 Black Widow II'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'YF-23 Black Widow II'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'YF-23 Black Widow II'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'YF-23 Black Widow II'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'YF-23 Black Widow II'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.54,
  wingspan          = 13.3,
  height            = 4.24,
  wing_area         = 87.8,
  empty_weight      = 16800,
  mtow              = 29000,
  service_ceiling   = 19800,
  climb_rate        = NULL,
  g_limit_pos       = 7.0,
  g_limit_neg       = NULL,
  combat_radius     = 1200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney YF119-PW-100',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 105.0,
  thrust_wet        = 156.0,

  -- Strate 3 : production & service
  production_start  = 1989,
  production_end    = 1990,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **PAV-1 « Spider »** : premier prototype, réacteurs Pratt & Whitney YF119\n- **PAV-2 « Gray Ghost »** : second prototype, réacteurs General Electric YF120\n- **YF-23 supercroisière** : atteint Mach 1,6 sans postcombustion, mieux que le YF-22\n- **NATF-23** : projet de version embarquée pour l''US Navy, abandonné avec le programme\n- Les deux prototypes existent toujours, exposés à Dayton et à Torrance',
  variants_en       = E'- **PAV-1 “Spider”** : first prototype, Pratt & Whitney YF119 engines\n- **PAV-2 “Gray Ghost”** : second prototype, General Electric YF120 engines\n- **YF-23 supercruise** : reached Mach 1.6 without afterburner, bettering the YF-22\n- **NATF-23** : proposed carrier version for the US Navy, abandoned with the programme\n- Both prototypes survive, displayed at Dayton and Torrance',

  -- Strate 4 : qualitatif
  nickname          = 'Black Widow II',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_YF-23',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_YF-23',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Logan Rickert',
  image_licence     = 'CC BY 4.0'
WHERE name = 'YF-23 Black Widow II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'tres_elevee' WHERE name = 'YF-23 Black Widow II';
