-- Yakovlev Yak-40 (Codling)
--
-- Photo : Jakowlew Jak-40 045 Siły Powietrzne RP (3469911996).jpg
--   licence CC BY 2.0 — Kuba Bożanowski from Warsaw, Poland
--   https://commons.wikimedia.org/wiki/File:Jakowlew_Jak-40_045_Si%C5%82y_Powietrzne_RP_(3469911996).jpg

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
    'Yakovlev Yak-40',
    'Yakovlev Yak-40',
    'Yakovlev Yak-40 (Codling)',
    'Yakovlev Yak-40 (Codling)',
    'Triréacteur régional soviétique des terrains en herbe, devenu avion de liaison et d''État de plus de vingt armées',
    'Soviet grass-strip regional trijet that became a liaison and VIP aircraft for more than twenty armed forces',
    '/assets/airplanes/yakovlev-yak40.jpg',
    E'## Genèse\nAu début des années 1960, Aeroflot dessert ses grandes lignes en avions à réaction ou à turbopropulseurs, mais ses liaisons locales, souvent au départ de terrains en herbe, reposent encore sur des Il-12, Il-14 et Li-2 à pistons. Le bureau **Yakovlev** reçoit la mission de les remplacer par un avion à turbines. La vitesse importe peu : il faut surtout opérer sûrement depuis des aérodromes mal équipés, sur des pistes non revêtues de moins de 700 mètres et par mauvais temps. Après avoir étudié turbopropulseurs et même décollage vertical, Yakovlev retient un **triréacteur à aile droite** de 20 à 25 places.\n\n## Conception\nLes trois réacteurs à double flux Ivtchenko **AI-25** de 14,7 kN sont groupés à l''arrière, deux sur les flancs et un dans le fuselage, alimenté par une entrée d''air dorsale en S. Un groupe auxiliaire permet de démarrer sans aucune aide au sol, et les passagers montent par un escalier ventral à l''arrière. L''aile non effilée, à grands volets à fente, compte sur sa faible charge alaire pour décoller court ; une haute dérive en flèche de 50° porte l''empennage en T. Le Yak-40 est le premier avion de ligne soviétique conçu selon les normes de navigabilité occidentales.\n\n## Carrière opérationnelle\nLe prototype vole le **21 octobre 1966** ; construit à Saratov de 1967 à 1981 à plus de 1 000 exemplaires, l''avion entre en service chez Aeroflot le 30 septembre 1968. Il sert aussi d''avion militaire et d''État : de la Pologne à Cuba, de la Tchécoslovaquie à la Syrie, plus d''une vingtaine de forces armées l''emploient pour la liaison et le transport de personnalités ; la Corée du Nord en reçoit onze en 1980 pour son dirigeant suprême. Des conversions militaires en font aussi une plate-forme d''essais et de renseignement : le **Yak-40-25** reçoit le nez d''un MiG-25R et une installation ELINT SRS-4A, l''Akva des nacelles de brouillage, le Kalibrovshchik une forêt d''antennes, le REO un carénage ventral de détection infrarouge.\n\n## Place dans l''histoire\nLe Yak-40 a été l''épine dorsale des liaisons locales d''Aeroflot, qui desservait avec lui 276 destinations intérieures en 1980, et un succès à l''exportation : premier avion soviétique certifié en Italie et en Allemagne de l''Ouest, il est présenté dans 75 pays. Dans les armées, sa robustesse en fait un avion de liaison et d''État très répandu. Sa carrière militaire s''éteint lentement : 17 exemplaires au plus volent encore sous uniforme en novembre 2012, et le recensement des forces aériennes mondiales pour 2026 n''en compte plus aucun.',
    E'## Genesis\nIn the early 1960s Aeroflot flew its trunk routes with jets or turboprops, but its local services, often from grass airfields, still relied on piston-engined Il-12s, Il-14s and Li-2s. The **Yakovlev** bureau was given the task of replacing them with a turbine-powered aircraft. Speed mattered little: above all it had to operate safely from poorly equipped airfields, on unpaved runways shorter than 700 metres and in bad weather. After studying turboprops and even vertical take-off designs, Yakovlev settled on a **straight-winged trijet** carrying 20 to 25 passengers.\n\n## Design\nThe three 14.7 kN Ivchenko **AI-25** turbofans are grouped at the rear, two on the sides and one in the fuselage, fed by a dorsal S-duct intake. An auxiliary power unit allows start-up without any ground support, and passengers board by a ventral airstair at the rear. The unswept wing, with large slotted flaps, relies on its low wing loading for short take-offs; a tall fin swept at 50° carries the T-tail. The Yak-40 was the first Soviet airliner designed to Western airworthiness requirements.\n\n## Operational career\nThe prototype flew on **21 October 1966**; built at Saratov from 1967 to 1981 in more than 1,000 examples, the aircraft entered Aeroflot service on 30 September 1968. It also served as a military and state aircraft: from Poland to Cuba, from Czechoslovakia to Syria, more than twenty armed forces used it for liaison and VIP transport; North Korea received eleven in 1980 for its Supreme Leader. Military conversions also turned it into a test and intelligence platform: the **Yak-40-25** received the nose of a MiG-25R and an SRS-4A ELINT installation, the Akva underwing jammer pods, the Kalibrovshchik a forest of antennas and the REO a ventral infrared linescan canoe.\n\n## Place in history\nThe Yak-40 was the backbone of Aeroflot''s local services, flying to 276 domestic destinations in 1980, and an export success: the first Soviet aircraft certified in Italy and West Germany, it was demonstrated in 75 countries. In the armed forces its ruggedness made it a widespread liaison and VIP aircraft. Its military career faded slowly: no more than 17 were still flying in uniform in November 2012, and the World Air Forces count for 2026 no longer lists a single one.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '1966-10-21',
    '1968-09-30',
    550,
    1800,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yakovlev Yak-40'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yakovlev Yak-40'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.36,
  wingspan          = 25.0,
  height            = 6.5,
  wing_area         = 70.0,
  empty_weight      = 9400,
  mtow              = 15500,
  service_ceiling   = 8000,
  climb_rate        = 8.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Ivtchenko AI-25',
  engine_count      = 3,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 14.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1967,
  production_end    = 1981,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 25,
  variants          = E'- **Yak-40** : version de série, triréacteur de 24 à 32 places, avion de liaison et de transport de personnalités des armées\n- **Yak-40K** : version cargo et mixte à grande porte de fret, produite de 1975 à 1981\n- **Yak-40-25** : conversion militaire avec le nez d''un MiG-25R et une installation ELINT SRS-4A\n- **Yak-40 Akva, Kalibrovshchik, REO, Fobos** : conversions militaires d''essais et de renseignement (brouilleurs, antennes ELINT, détection infrarouge, dômes d''observation)\n- **Yak-40V / Yak-40EC** : versions d''exportation',
  variants_en       = E'- **Yak-40**: production version, 24 to 32-seat trijet, military liaison and VIP transport\n- **Yak-40K**: cargo and combi version with a large freight door, built from 1975 to 1981\n- **Yak-40-25**: military conversion with the nose of a MiG-25R and an SRS-4A ELINT installation\n- **Yak-40 Akva, Kalibrovshchik, REO, Fobos**: military test and intelligence conversions (jammers, ELINT antennas, infrared linescan, observation domes)\n- **Yak-40V / Yak-40EC**: export versions',

  -- Strate 4 : qualitatif
  nickname          = 'Codling',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-40',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-40',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Kuba Bożanowski',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Yakovlev Yak-40';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yakovlev Yak-40';
