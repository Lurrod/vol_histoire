-- Yakovlev Yak-27R (Mangrove)
--
-- Photo : Yakolev Yak-27R ’14 red’ (39437445781).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Yakolev_Yak-27R_’14_red’_(39437445781).jpg

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
    'Yakovlev Yak-27',
    'Yakovlev Yak-27',
    'Yakovlev Yak-27R (Mangrove)',
    'Yakovlev Yak-27R (Mangrove)',
    'Le Yak-25 devenu supersonique, éclaireur de haute altitude des régiments soviétiques en Europe',
    'The Yak-25 turned supersonic, a high-altitude scout for Soviet reconnaissance regiments in Europe',
    '/assets/airplanes/yak27r.jpg',
    E'## Genèse\nPour prolonger sa famille de **Yak-25**, le bureau **Yakovlev** développe le prototype **Yak-121**, base d''une famille supersonique d''intercepteurs et d''avions de reconnaissance tactique : les Yak-27, que l''OTAN désigne « Flashlight-C ». Les intercepteurs **Yak-27**, armé de deux canons de 30 mm, et **Yak-27K**, armé de missiles **K-8**, atteignent ou dépassent leur cahier des charges, mais le **Soukhoï Su-9** fait mieux et leur production n''est pas autorisée. Seule la version de reconnaissance entre en série.\n\n## Conception\nLe **Yak-27R** troque le radôme et son radar contre un nez vitré qui accueille un observateur-navigateur, reçoit deux caméras et ne garde qu''un canon **NR-23**. Son aile allongée atteint 11,82 m d''envergure, et ses deux turboréacteurs **Toumanski RD-9F** le portent à environ 1 285 km/h en altitude, avec un plafond de 16 500 m et 2 380 km de distance franchissable grâce à deux réservoirs d''aile. Une variante d''interception à haute altitude, le **Yak-27V**, tirée du Yak-121 et dotée d''un moteur-fusée **Douchkine S-155**, monte à 23 000 m en essais, mais les difficultés d''entretien de la fusée font abandonner le projet. Environ 180 Yak-27R sortent de l''usine n° 292 de Saratov.\n\n## Carrière opérationnelle\nEn pleine guerre froide, le Yak-27R entre en service dans l''armée de l''air soviétique en 1960 pour remplacer l''**Il-28** de reconnaissance. Plus rapide et volant plus haut, il porte pourtant moins loin. Seuls les pilotes les plus expérimentés l''emmènent en supersonique, et ses moteurs placés bas avalent les débris des pistes sommaires du front. Il équipe des régiments de reconnaissance stationnés en Allemagne de l''Est, en Pologne, en Lettonie, en Ukraine occidentale et sur la péninsule de Kola. Face à la multiplication des missiles antiaériens en Europe, l''avion de haute altitude se révèle souvent plus limité encore que l''Il-28 qu''il devait remplacer.\n\n## Place dans l''histoire\nRetiré au début des années 1970, le Yak-27R cède la place au **Yak-28R** puis au **MiG-25R**. Il fait le lien entre le Yak-25 subsonique et le Yak-28, et illustre la vitesse à laquelle la haute altitude, refuge des avions de reconnaissance des années 1950, a perdu sa valeur face aux missiles sol-air. Un exemplaire est exposé au musée central de l''armée de l''air à Monino, deux autres en Allemagne, à Dessau et à Spire.',
    E'## Genesis\nTo extend its **Yak-25** family, the **Yakovlev** bureau developed the **Yak-121** prototype, the basis for a supersonic family of interceptors and tactical reconnaissance aircraft: the Yak-27, which NATO called ''Flashlight-C''. The **Yak-27** interceptor, armed with two 30 mm cannon, and the **Yak-27K**, armed with **K-8** missiles, met or exceeded their requirements, but the **Sukhoi Su-9** outperformed them and production was not authorised. Only the reconnaissance version entered production.\n\n## Design\nThe **Yak-27R** replaced the radome and radar with a glazed nose for an observer-navigator, gained two cameras and kept a single **NR-23** cannon. Its longer wing spanned 11.82 m, and two **Tumansky RD-9F** turbojets gave it a top speed of about 1,285 km/h at altitude, a ceiling of 16,500 m and a range of 2,380 km with two wing tanks. A high-altitude interceptor version, the **Yak-27V**, converted from the Yak-121 and fitted with a **Dushkin S-155** rocket booster, reached 23,000 m in trials, but maintenance problems with the rocket engine ended the project. About 180 Yak-27Rs were built at Plant No. 292 in Saratov.\n\n## Operational career\nAt the height of the Cold War the Yak-27R entered Soviet Air Force service in 1960 to replace the **Il-28** reconnaissance aircraft. Faster and higher-flying, it nonetheless had less range. Only the most experienced pilots flew it at supersonic speed, and its low-set engines tended to ingest debris on rough forward airstrips. It equipped reconnaissance regiments based in East Germany, Poland, Latvia, western Ukraine and on the Kola Peninsula. As anti-aircraft missiles spread across Europe, its high-altitude performance left it even more limited than the Il-28.\n\n## Place in history\nWithdrawn in the early 1970s, the Yak-27R gave way to the **Yak-28R** and then the **MiG-25R**. It bridged the subsonic Yak-25 and the Yak-28, and shows how quickly high altitude, the refuge of 1950s reconnaissance aircraft, lost its value against surface-to-air missiles. One example is displayed at the Central Air Force Museum at Monino, and two more in Germany, at Dessau and Speyer.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    NULL,
    '1960-01-01',
    1285,
    2380,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yakovlev Yak-27'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Yakovlev Yak-27'), (SELECT id FROM tech WHERE name = 'Réacteur Tumansky R-9'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Yakovlev Yak-27'), (SELECT id FROM armement WHERE name = 'NR-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yakovlev Yak-27'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yakovlev Yak-27'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 18.55,
  wingspan          = 11.82,
  height            = 4.05,
  wing_area         = 28.94,
  empty_weight      = 6983,
  mtow              = 13600,
  service_ceiling   = 16550,
  climb_rate        = 95,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Tumansky RD-9F',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = NULL,
  thrust_wet        = 37.2,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 180,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Yak-121** : prototype de la famille, issu du Yak-25\n- **Yak-27 / Yak-27K** : intercepteurs à canons de 30 mm ou à missiles K-8, non produits\n- **Yak-27V** : intercepteur de haute altitude à moteur-fusée S-155, prototype unique\n- **Yak-27R** : reconnaissance tactique à nez vitré, environ 180 exemplaires\n- **Yak-27F / Yak-27LSh** : Yak-27R modifiés, à caméras de télévision ou à atterrisseur à ski',
  variants_en       = E'- **Yak-121**: family prototype, derived from the Yak-25\n- **Yak-27 / Yak-27K**: interceptors with 30 mm cannon or K-8 missiles, not produced\n- **Yak-27V**: high-altitude interceptor with an S-155 rocket booster, single prototype\n- **Yak-27R**: glazed-nose tactical reconnaissance version, about 180 built\n- **Yak-27F / Yak-27LSh**: modified Yak-27Rs with television cameras or ski landing gear',

  -- Strate 4 : qualitatif
  nickname          = 'Mangrove',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-27',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-27',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Yakovlev Yak-27';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yakovlev Yak-27';
