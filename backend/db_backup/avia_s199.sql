-- Avia S-199 Mezek
--
-- Photo : Avia S-199 (Czech version Messerschmitt Bf 109G) (UF 25) pic3.JPG
--   licence CC0 — AlfvanBeem
--   https://commons.wikimedia.org/wiki/File:Avia_S-199_(Czech_version_Messerschmitt_Bf_109G)_(UF_25)_pic3.JPG

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
    'Avia S-199',
    'Avia S-199',
    'Avia S-199 Mezek',
    'Avia S-199 Mezek',
    'Messerschmitt tchécoslovaque à moteur de bombardier, premier chasseur de l''armée de l''air israélienne',
    'Czechoslovak Messerschmitt with a bomber engine, the first fighter of the Israeli Air Force',
    '/assets/airplanes/avia-s199.jpg',
    E'## Genèse\nÀ la Libération, la Tchécoslovaquie hérite d''usines qui assemblaient le **Messerschmitt Bf 109** pour la Luftwaffe, ainsi que de stocks de pièces et de plans. **Avia** reprend la fabrication du Bf 109G-10 sous le nom d''**S-99**, à Čakovice, près de Prague. Mais l''explosion d''un entrepôt à Krásné Březno détruit une grande partie des moteurs **Daimler-Benz DB 605**, et la chaîne se retrouve sans propulsion. Faute de mieux, on se tourne vers ce qui reste en quantité : le **Junkers Jumo 211F** du bombardier Heinkel He 111.\n\n## Conception\nLe S-199 garde la cellule du Bf 109G, mais reçoit le Jumo 211F et sa grosse hélice à pales larges, plus lourds et moins nerveux que l''ensemble d''origine. Le couple de l''hélice rend l''avion difficile à tenir, et l''étroite voie du train du Bf 109 transforme chaque décollage et chaque atterrissage en épreuve. Le Jumo n''autorisant pas de canon tirant à travers le moyeu, deux canons **MG 151** de 20 mm sont logés sous les ailes, ce qui pénalise encore les performances. Le synchroniseur des mitrailleuses de capot fonctionne mal : des pilotes israéliens tireront dans leur propre hélice. Les pilotes tchécoslovaques le surnomment **Mezek**, la « mule ».\n\n## Carrière opérationnelle\nLe premier vol a lieu en mars 1947 et environ 550 exemplaires sortent d''usine jusqu''en 1949. En 1948, des agents israéliens achètent 25 appareils à Prague malgré l''embargo sur les armes ; tous sauf deux sont livrés, au prix de 190 000 dollars pièce. Les quatre premiers arrivent le 20 mai 1948, six jours après la déclaration d''indépendance, et forment le premier escadron de chasse d''Israël. Le 29 mai, ils attaquent la colonne égyptienne entre Isdud et le pont d''Ad Halom, au sud de Tel-Aviv. Le 3 juin, **Modi Alon** abat deux C-47 égyptiens qui venaient de bombarder Tel-Aviv : ce sont les premières victoires aériennes de l''armée de l''air israélienne. Peu fiable, avec rarement plus de cinq avions en état de vol, le S-199 est presque retiré fin octobre ; en Tchécoslovaquie, les derniers quittent la garde de sécurité nationale en 1957.\n\n## Place dans l''histoire\nAvion de nécessité, né des restes d''une industrie de guerre, le S-199 est un mauvais chasseur qui a pourtant compté. Arrivé au moment où l''aviation israélienne n''avait rien d''autre, il a porté ses premiers combats et ses premières victoires. Paradoxe de l''après-guerre : un dérivé du chasseur de la Luftwaffe, acheté à Prague malgré l''embargo, fut le premier chasseur de l''État d''Israël. Les Israéliens l''appelaient officiellement **Sakeen**, le « couteau », mais plus souvent **Messer**.',
    E'## Genesis\nAt the liberation, Czechoslovakia inherited factories that had assembled the **Messerschmitt Bf 109** for the Luftwaffe, along with stocks of parts and drawings. **Avia** resumed building the Bf 109G-10 as the **S-99** at its Čakovice works near Prague. But an explosion at a warehouse in Krásné Březno destroyed many of the **Daimler-Benz DB 605** engines, leaving the line without power. For want of anything better, the factory turned to what remained in quantity: the **Junkers Jumo 211F** of the Heinkel He 111 bomber.\n\n## Design\nThe S-199 kept the Bf 109G airframe but received the Jumo 211F and its large paddle-bladed propeller, heavier and less responsive than the original combination. Propeller torque made the aircraft hard to control, and the Bf 109''s narrow-track undercarriage turned every take-off and landing into an ordeal. As the Jumo could not take a cannon firing through the spinner, two 20 mm **MG 151** cannon were slung under the wings, at a further cost in performance. The synchroniser of the cowl machine guns did not work as intended: some Israeli pilots shot off their own propellers. Czechoslovak pilots nicknamed it **Mezek**, the "mule".\n\n## Operational career\nThe first flight took place in March 1947 and around 550 were built up to 1949. In 1948 Israeli agents bought 25 aircraft in Prague in defiance of the arms embargo; all but two were delivered, at 190,000 dollars each. The first four arrived on 20 May 1948, six days after the declaration of independence, and formed Israel''s first fighter squadron. On 29 May they attacked the Egyptian column between Isdud and the Ad Halom bridge, south of Tel Aviv. On 3 June **Modi Alon** shot down two Egyptian C-47s that had just bombed Tel Aviv: the Israeli Air Force''s first aerial victories. Unreliable, with rarely more than five aircraft airworthy, the S-199 was largely withdrawn by the end of October; in Czechoslovakia the last left the National Security Guard in 1957.\n\n## Place in history\nAn aircraft of necessity, born from the remains of a wartime industry, the S-199 was a poor fighter that nonetheless mattered. Arriving when Israeli aviation had nothing else, it flew its first combat missions and scored its first victories. It also illustrates a post-war paradox: a derivative of the Luftwaffe''s fighter, bought in Prague despite the embargo, served as the first fighter of the State of Israel. The Israelis officially called it **Sakeen**, the "knife", but more often **Messer**.',
    (SELECT id FROM countries WHERE code = 'CSK'),
    NULL,
    '1947-03-01',
    NULL,
    598,
    860,
    (SELECT id FROM manufacturer WHERE code = 'AVIA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Avia S-199'), (SELECT id FROM armement WHERE name = 'MG 151/20')),
((SELECT id FROM airplanes WHERE name = 'Avia S-199'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avia S-199'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Avia S-199'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Avia S-199'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Avia S-199'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.94,
  wingspan          = 9.92,
  height            = 2.59,
  wing_area         = 16.5,
  empty_weight      = 2860,
  mtow              = 3736,
  service_ceiling   = NULL,
  climb_rate        = 13.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Junkers Jumo 211F (1 350 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en V',
  engine_type_en    = 'V engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 1949,
  units_built       = 559,
  unit_cost_usd     = 190000,
  unit_cost_year    = 1948,
  operators_count   = 2,
  variants          = E'- **S-99** : Bf 109G-10 assemblé après-guerre avec le moteur DB 605 d''origine, 21 exemplaires\n- **CS-99** : biplace d''entraînement dérivé du Bf 109G-12, 23 exemplaires\n- **S-199** : version principale à moteur Junkers Jumo 211F, 559 exemplaires\n- **CS-199** : biplace d''entraînement reconstruit à partir du S-199\n- **D-199** : version de reconnaissance',
  variants_en       = E'- **S-99**: Bf 109G-10 assembled after the war with the original DB 605 engine, 21 built\n- **CS-99**: two-seat trainer derived from the Bf 109G-12, 23 built\n- **S-199**: main version with the Junkers Jumo 211F engine, 559 built\n- **CS-199**: two-seat trainer rebuilt from the S-199\n- **D-199**: reconnaissance version',

  -- Strate 4 : qualitatif
  nickname          = 'Mezek',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Avia_S-199',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Avia_S-199',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'AlfvanBeem',
  image_licence     = 'CC0'
WHERE name = 'Avia S-199';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Avia S-199';
