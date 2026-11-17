-- Antonov An-24 (Coke)
--
-- Photo : An-24 Hungary (19982675254).jpg
--   licence CC BY-SA 2.0 — Rob Schleiffert from Holland
--   https://commons.wikimedia.org/wiki/File:An-24_Hungary_(19982675254).jpg

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
    'Antonov An-24',
    'Antonov An-24',
    'Antonov An-24 (Coke)',
    'Antonov An-24 (Coke)',
    'Le bimoteur rustique des pistes sommaires, souche des An-26, An-30, An-32 et du Y-7 chinois',
    'The rugged twin for rough strips, ancestor of the An-26, An-30, An-32 and the Chinese Y-7',
    '/assets/airplanes/an24.jpg',
    E'## Genèse\nEn 1957, **Aeroflot** réclame un bimoteur d''au moins 32 places pour remplacer ses **Li-2**, **Il-12** et **Il-14** vieillissants. Le bureau **Antonov**, à Kiev, conçoit l''An-24 pour les liaisons courtes et moyennes au départ de terrains sommaires et d''aéroports isolés. Le premier prototype vole le 20 décembre 1959 ; le premier modèle de série est approuvé le 19 août 1961 et ouvre la ligne Kiev-Kherson le 31 octobre 1962.\n\n## Conception\nL''aile haute met moteurs et hélices à l''abri des projections, le rapport puissance-masse dépasse celui de bien des concurrents, et l''avion, robuste, se contente d''un minimum de moyens au sol. Deux turbopropulseurs **Ivtchenko AI-24** entraînent des hélices quadripales. Les versions se succèdent : An-24B de 52 places, An-24V d''exportation, puis An-24RV doté d''un petit réacteur d''appoint dans la nacelle droite. Les militaires reçoivent l''**An-24T**, transport tactique à trappe de chargement ventrale et treuil, conçu pour amener troupes aéroportées et fantassins vers les bases du front ; l''An-24RT y ajoute le réacteur d''appoint.\n\n## Carrière opérationnelle\nAu-delà du transport, la cellule se prête à une foule de missions : reconnaissance des glaces, recherche et sauvetage, relais de communications, poste de commandement aéroporté (An-24ShT), formation des navigateurs, reconnaissance nucléaire, biologique et chimique (An-24RR). Les 17 premiers An-24 de série finissent à Cuba, comme transports de l''armée de l''air cubaine. Au début des années 1990, la Corée du Nord installe un radar Topaz sur au moins un exemplaire pour s''offrir une détection aérienne rudimentaire. Les forces aériennes russes, ukrainiennes et cambodgiennes, ainsi que l''aéronavale russe, l''utilisent encore.\n\n## Place dans l''histoire\nConstruit à Kiev (985 exemplaires), Oulan-Oude (180) et Irkoutsk (197 An-24T) jusqu''en 1978, l''An-24 est la souche de toute une famille : l''**An-30** de cartographie aérienne, l''**An-26** de transport tactique à rampe arrière et l''**An-32**, plus puissant. En Chine, **Xi''an** en tire sous licence le **Y-7**, puis le MA60. En 2023, 93 An-24 étaient encore en service dans le monde, surtout dans la Communauté des États indépendants et en Afrique.',
    E'## Genesis\nIn 1957 **Aeroflot** asked for a twin of at least 32 seats to replace its ageing **Li-2**, **Il-12** and **Il-14** fleet. The **Antonov** bureau in Kyiv designed the An-24 for short and medium routes from rough strips and remote airports. The first prototype flew on 20 December 1959; the first production model was approved on 19 August 1961 and opened the Kyiv-Kherson route on 31 October 1962.\n\n## Design\nThe high wing protected engines and propellers from debris, the power-to-weight ratio was better than that of many rivals, and the rugged aircraft needed minimal ground support. Two **Ivchenko AI-24** turboprops drove four-bladed propellers. Versions followed one another: the 52-seat An-24B, the An-24V for export, then the An-24RV with a small booster jet in the starboard nacelle. The military received the **An-24T**, a tactical transport with a ventral loading hatch and a cargo winch, designed to carry airborne troops and infantry to frontline bases; the An-24RT added the booster jet.\n\n## Operational career\nBeyond transport, the airframe lent itself to many roles: ice reconnaissance, search and rescue, communications relay, airborne command post (An-24ShT), navigator training, and nuclear, biological and chemical reconnaissance (An-24RR). The first 17 production An-24s ended up in Cuba as transports for the Cuban Air Force. In the early 1990s North Korea fitted a Topaz radar to at least one example to gain a rudimentary airborne early warning capability. The Russian, Ukrainian and Cambodian air forces, as well as Russian Naval Aviation, still use it.\n\n## Place in history\nBuilt in Kyiv (985 examples), Ulan-Ude (180) and Irkutsk (197 An-24Ts) until 1978, the An-24 founded a whole family: the **An-30** aerial survey aircraft, the **An-26** tactical transport with a rear ramp and the more powerful **An-32**. In China, **Xi''an** built it under licence as the **Y-7**, which led to the MA60. In 2023, 93 An-24s were still in service worldwide, mostly in the Commonwealth of Independent States and Africa.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1957-01-01',
    '1959-12-20',
    '1962-10-31',
    485,
    2400,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-24'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-24'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-24'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.53,
  wingspan          = 29.2,
  height            = 8.32,
  wing_area         = 74.98,
  empty_weight      = 13300,
  mtow              = 21000,
  service_ceiling   = 8400,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-24A (2 550 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1959,
  production_end    = 1978,
  units_built       = 1362,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **An-24 / An-24A / An-24B** : versions de ligne de 44 à 52 places\n- **An-24V / An-24RV** : versions d''exportation, la seconde avec réacteur d''appoint dans la nacelle droite\n- **An-24T / An-24RT** : transport tactique militaire à trappe ventrale et treuil, 197 construits à Irkoutsk\n- **An-24ShT** : poste de commandement aéroporté tactique\n- **An-24RR** : reconnaissance nucléaire, biologique et chimique à nacelles de prélèvement',
  variants_en       = E'- **An-24 / An-24A / An-24B**: airliner versions with 44 to 52 seats\n- **An-24V / An-24RV**: export versions, the latter with a booster jet in the starboard nacelle\n- **An-24T / An-24RT**: military tactical transport with ventral hatch and winch, 197 built at Irkutsk\n- **An-24ShT**: tactical airborne command post\n- **An-24RR**: nuclear, biological and chemical reconnaissance with sampling pods',

  -- Strate 4 : qualitatif
  nickname          = 'Coke',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-24',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-24',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Schleiffert',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Antonov An-24';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-24';
