-- Yakovlev Yak-141 Freestyle
--
-- Photo : Yakovlev Yak-141 in Museum of technique 2016-08-16.JPG
--   licence CC BY-SA 4.0 — Mike1979 Russia
--   https://commons.wikimedia.org/wiki/File%3AYakovlev_Yak-141_in_Museum_of_technique_2016-08-16.JPG

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
    'Yak-141',
    'Yak-141',
    'Yakovlev Yak-141 Freestyle',
    'Yakovlev Yak-141 Freestyle',
    'Premier avion supersonique à décollage vertical, abandonné en 1991',
    'First supersonic VTOL aircraft, abandoned in 1991',
    '/assets/airplanes/yak141-freestyle.jpg',
    E'## Genèse\nLe Yak-38 avait déçu sur tous les plans. Yakovlev reprend le problème à zéro pour donner aux porte-aéronefs soviétiques un appareil réellement capable : supersonique, armé, et doté d''un rayon d''action décent. Le cahier des charges est le plus ambitieux jamais posé pour un avion à décollage vertical.\n\n## Conception\nL''architecture reste à trois moteurs, mais le réacteur principal reçoit une **tuyère orientable sur 95°**, articulée en trois segments — la pièce la plus difficile du programme. L''appareil emporte un canon de 30 mm, des missiles air-air modernes et des armes antinavires. Il franchit Mach 1,4 en palier, ce qu''aucun appareil à décollage vertical n''avait fait.\n\n## Carrière opérationnelle\nIl n''y en a pas. En avril 1991, le Yak-141 bat quatre records mondiaux. Six mois plus tard, un appareil s''écrase à l''appontage sur l''**Amiral Gorchkov** ; le pilote s''éjecte. L''URSS disparaît dans la foulée et le financement avec elle. Le programme s''arrête en 1991, deux prototypes seulement ayant volé.\n\n## Place dans l''histoire\nEn 1995, Yakovlev vend ses données de tuyère orientable à **Lockheed Martin**, alors engagé dans le programme JSF. Le système de sustentation du **F-35B** en descend directement. Le Yak-141 est donc l''ancêtre technique d''un appareil qu''il n''a jamais affronté.',
    E'## Genesis\nThe Yak-38 had disappointed on every count. Yakovlev restarted from scratch to give Soviet aviation cruisers a genuinely capable aircraft: supersonic, armed, and with a decent radius. The specification was the most ambitious ever written for a vertical take-off aircraft.\n\n## Design\nThe three-engine architecture remained, but the main engine received a **nozzle vectoring through 95°**, articulated in three segments — the hardest part of the programme. The aircraft carried a 30 mm gun, modern air-to-air missiles and anti-ship weapons. It exceeded Mach 1.4 in level flight, which no VTOL aircraft had ever done.\n\n## Operational career\nThere was none. In April 1991 the Yak-141 set four world records. Six months later one aircraft crashed on landing aboard the **Admiral Gorshkov**; the pilot ejected. The USSR dissolved shortly afterwards and the funding with it. The programme stopped in 1991 with only two prototypes having flown.\n\n## Place in history\nIn 1995 Yakovlev sold its vectoring nozzle data to **Lockheed Martin**, then engaged in the JSF programme. The **F-35B** lift system descends directly from it. The Yak-141 is thus the technical ancestor of an aircraft it never faced.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1975-01-01',
    '1987-03-09',
    NULL,
    1800.0,
    2100.0,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-141'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'Yak-141'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Yak-141'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-141'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Yak-141'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'Yak-141'), (SELECT id FROM armement WHERE name = 'R-77')),
((SELECT id FROM airplanes WHERE name = 'Yak-141'), (SELECT id FROM armement WHERE name = 'Kh-31A'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-141'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Yak-141'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Yak-141'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 18.3,
  wingspan          = 10.1,
  height            = 5.0,
  wing_area         = 31.7,
  empty_weight      = 11650,
  mtow              = 19500,
  service_ceiling   = 15500,
  climb_rate        = 250,
  g_limit_pos       = 7.0,
  g_limit_neg       = NULL,
  combat_radius     = 690,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Soyuz R-79V-300 + 2 × Rybinsk RD-41',
  engine_count      = 3,
  engine_type       = 'Turboréacteurs de sustentation et de propulsion à tuyère orientable',
  engine_type_en    = 'Lift and vectoring lift-cruise turbojets',
  thrust_dry        = 108.0,
  thrust_wet        = 152.0,

  -- Strate 3 : production & service
  production_start  = 1987,
  production_end    = 1991,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Yak-41M** : désignation soviétique du programme\n- Quatre cellules construites, deux seulement en état de vol\n- Programme arrêté en 1991 faute de financement ; les données de la tuyère orientable seront vendues à **Lockheed Martin** en 1995',
  variants_en       = E'- **Yak-41M** : Soviet designation of the programme\n- Four airframes built, only two flightworthy\n- Programme stopped in 1991 for lack of funding; the vectoring nozzle data were sold to **Lockheed Martin** in 1995',

  -- Strate 4 : qualitatif
  nickname          = 'Freestyle',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-141',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-141',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mike1979 Russia',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Yak-141';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-141';
