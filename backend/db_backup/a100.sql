-- Beriev A-100
--
-- Photo : А-100.jpg
--   licence CC BY-SA 4.0 — Trolyambus
--   https://commons.wikimedia.org/wiki/File:%D0%90-100.jpg

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
    'Beriev A-100',
    'Beriev A-100',
    'Beriev A-100',
    'Beriev A-100',
    'Le successeur de l''A-50, un radar actif sous radôme tournant, freiné par les sanctions',
    'The A-50''s successor, an active radar under a rotating dome, slowed by sanctions',
    '/assets/airplanes/a100.jpg',
    E'## Genèse\nLes **Beriev A-50** et A-50U assurent le guet aérien des forces russes, et il leur faut un successeur. Le contrat de développement est signé en 2006 avec la **Vega Radio Engineering Corporation** ; le projet est aussi connu sous le nom d''**Izdeliye PM**. Plutôt que de repartir d''une feuille blanche, Beriev conserve la formule éprouvée de l''A-50 mais la transpose sur l''**Il-76MD-90A**, version modernisée du cargo d''Iliouchine.\n\n## Conception\nL''A-100 ressemble beaucoup à son prédécesseur : l''antenne principale loge dans un **radôme rotatif** monté sur deux mâts au-dessus du fuselage. La nouveauté est à l''intérieur. Le radar **Vega Premier** est une antenne active à balayage électronique en élévation, tandis que la rotation du dôme assure le balayage en azimut ; un tour toutes les cinq secondes améliore le suivi des cibles rapides. Il doit détecter des avions à plus de 600 km et des navires à près de 400 km. L''avion reçoit aussi une nouvelle suite de guerre électronique, une nouvelle navigation, des liaisons par satellite, et quatre réacteurs **PS-90A-76** de 142 kN, 15 % plus puissants que les D-30KP de l''Il-76.\n\n## Essais\nUn laboratoire volant, l''**A-100LL**, bâti sur une cellule d''A-50, vole le 21 avril 2017 pour éprouver les systèmes. L''A-100 proprement dit effectue son premier vol le 18 novembre 2017, puis vole pour la première fois radar en marche le 9 février 2022. Les livraisons, annoncées en 2020 pour 2024, glissent : les sanctions imposées à la Russie retardent le programme. Le 25 novembre 2025, l''Ukraine affirme avoir détruit l''A-100LL, des images satellites montrant l''avion calciné ; il ne portait plus d''électronique, transférée sur l''A-100.\n\n## Place dans l''histoire\nL''A-100 doit d''abord renforcer la flotte d''**A-50** et d''A-50U, puis la remplacer : c''est l''héritier direct de la lignée soviétique de guet aérien sur cellule d''Il-76. Il marie la formule classique du dôme tournant à une antenne active, là où des contemporains comme l''**IAI G550 CAEW** israélien ont renoncé à toute pièce tournante. Faute de livraisons en série, son entrée en service reste suspendue aux retards industriels du programme.',
    E'## Genesis\nThe **Beriev A-50** and A-50U provide airborne early warning for Russian forces, and they need a successor. The development contract was signed in 2006 with the **Vega Radio Engineering Corporation**; the project is also known as **Izdeliye PM**. Rather than start from scratch, Beriev kept the proven A-50 formula but transferred it to the **Il-76MD-90A**, a modernised version of the Ilyushin freighter.\n\n## Design\nThe A-100 looks much like its predecessor: the main antenna sits in a **rotodome** mounted on two struts above the fuselage. What is new lies inside. The **Vega Premier** radar is an active array with electronic scanning in elevation, while the dome''s rotation provides azimuth scanning; one revolution every five seconds improves tracking of fast targets. It is to detect aircraft beyond 600 km and warships at nearly 400 km. The aircraft also receives a new electronic warfare suite, new navigation, satellite links, and four 142 kN **PS-90A-76** engines, 15% more powerful than the Il-76''s D-30KP.\n\n## Testing\nA flying laboratory, the **A-100LL**, built on an A-50 airframe, flew on 21 April 2017 to prove the systems. The A-100 itself made its first flight on 18 November 2017, then flew with its radar switched on for the first time on 9 February 2022. Deliveries, announced in 2020 for 2024, slipped: sanctions on Russia delayed the programme. On 25 November 2025 Ukraine claimed to have destroyed the A-100LL, satellite images showing the burnt-out aircraft; it no longer carried electronics, which had been moved to the A-100.\n\n## Place in history\nThe A-100 is first to reinforce the fleet of **A-50** and A-50U aircraft, then to replace it: it is the direct heir of the Soviet line of airborne early warning on the Il-76 airframe. It marries the classic rotating-dome formula to an active array, whereas contemporaries such as Israel''s **IAI G550 CAEW** have done away with moving parts altogether. With no production deliveries yet, its entry into service still hangs on the programme''s industrial delays.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '2006-01-01',
    '2017-11-18',
    NULL,
    900,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BER'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev A-100'), (SELECT id FROM tech WHERE name = 'Radôme rotatif')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-100'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-100'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-100'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev A-100'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 46.59,
  wingspan          = 50.5,
  height            = 14.76,
  wing_area         = 300,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Aviadvigatel PS-90A-76',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 142.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **A-100LL** : laboratoire volant sur cellule d''A-50, premier vol le 21 avril 2017, déclaré détruit par l''Ukraine en novembre 2025\n- **A-100** : prototype sur Il-76MD-90A, premier vol le 18 novembre 2017, premier vol radar en marche le 9 février 2022\n- **Radar Vega Premier** : antenne active à balayage électronique en élévation, sous un dôme tournant en cinq secondes\n- **Motorisation PS-90A-76** : 142 kN par réacteur, 15 % de plus que le D-30KP de l''Il-76',
  variants_en       = E'- **A-100LL**: flying laboratory on an A-50 airframe, first flight on 21 April 2017, claimed destroyed by Ukraine in November 2025\n- **A-100**: prototype on the Il-76MD-90A, first flight on 18 November 2017, first flight with radar on 9 February 2022\n- **Vega Premier radar**: active array with electronic scanning in elevation, under a dome turning once every five seconds\n- **PS-90A-76 engines**: 142 kN each, 15% more than the Il-76''s D-30KP',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beriev_A-100',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beriev_A-100',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Trolyambus',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Beriev A-100';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beriev A-100';
