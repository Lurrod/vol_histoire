-- Baykar Bayraktar Akıncı
--
-- Photo : BayraktarAkıncı Teknofest2019 (3).jpg
--   licence CC BY-SA 4.0 — CeeGee
--   https://commons.wikimedia.org/wiki/File:BayraktarAk%C4%B1nc%C4%B1_Teknofest2019_(3).jpg

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
    'Bayraktar Akıncı',
    'Bayraktar Akıncı',
    'Baykar Bayraktar Akıncı',
    'Baykar Bayraktar Akıncı',
    'Six tonnes et deux turbopropulseurs : la Turquie passe du drone tactique au drone lourd',
    'Six tonnes and two turboprops: Turkey moves from tactical to heavy drones',
    '/assets/airplanes/bayraktar-akinci.jpg',
    E'## Genèse\nLe **Bayraktar TB2** a fait la réputation de Baykar, mais il reste un drone tactique : 700 kg au décollage, un moteur à pistons, des munitions de 22 kg. Pour aller plus haut, plus loin et frapper plus lourd, l''entreprise dessine un appareil d''une autre catégorie. Les premières images circulent en juin 2018 ; le premier vol a lieu le 6 décembre 2019 sur la base de Çorlu, en Thrace.\n\n## Conception\nSix tonnes au décollage — huit fois le TB2 —, vingt mètres d''envergure et deux turbopropulseurs : des **AI-450** ukrainiens de 450 ch sur la version A, des moteurs de 750 puis 850 ch sur les versions B et C. La charge utile dépasse 1 500 kg, répartie entre la soute et huit points d''emport. Radar **AESA** MURAD, radar à synthèse d''ouverture, guerre électronique, double liaison satellite : l''Akıncı emporte bombes guidées, missiles de croisière et, depuis peu, missiles air-air. Ses premiers tirs, en avril 2021, emploient trois variantes de la munition **MAM-L** de Roketsan.\n\n## Carrière opérationnelle\nLes trois premiers entrent en service le 29 août 2021 ; en juillet, un vol d''essai a duré 25 h 46 sur 7 507 km, à plus de 11 500 m. Engagé contre le PKK dans le nord de l''Irak, il survole aussi la zone du séisme de février 2023 et localise en mai 2024 l''épave de l''hélicoptère du président iranien Raïssi. Exporté dans une dizaine de pays — Azerbaïdjan, Pakistan, Arabie saoudite, Maroc, Éthiopie, Soudan, Mali —, il connaît ses premières pertes : un appareil malien est abattu par la défense aérienne algérienne en 2025, et au Soudan, un Akıncı aurait abattu un autre Akıncı en mars 2026.\n\n## Place dans l''histoire\nPlus d''une centaine d''exemplaires en quatre ans. L''Akıncı fait entrer l''industrie turque dans la catégorie du **MQ-9 Reaper**. La fiche du **TB2** le cite déjà comme sa plateforme lourde ; son successeur, le **Kızılelma** à réaction, vole depuis 2022.',
    E'## Genesis\nThe **Bayraktar TB2** made Baykar''s name, but it remains a tactical drone: 700 kg at take-off, a piston engine, 22 kg munitions. To fly higher and further and strike harder, the company designed an aircraft of another class. The first images appeared in June 2018; the first flight took place on 6 December 2019 at Çorlu air base, in Thrace.\n\n## Design\nSix tonnes at take-off — eight times the TB2 —, a twenty-metre span and two turboprops: Ukrainian 450 hp **AI-450s** on the A version, 750 and then 850 hp engines on the B and C versions. The payload exceeds 1,500 kg, split between an internal bay and eight hardpoints. A MURAD **AESA** radar, synthetic-aperture radar, electronic warfare, dual satellite links: the Akıncı carries guided bombs, cruise missiles and, more recently, air-to-air missiles. Its first firing trials, in April 2021, used three variants of Roketsan''s **MAM-L** munition.\n\n## Operational career\nThe first three entered service on 29 August 2021; in July a test flight had lasted 25 h 46 min over 7,507 km, at more than 11,500 m. Used against the PKK in northern Iraq, it also flew over the zone of the February 2023 earthquake and in May 2024 located the wreck of Iranian president Raisi''s helicopter. Exported to some ten countries — Azerbaijan, Pakistan, Saudi Arabia, Morocco, Ethiopia, Sudan, Mali —, it has suffered its first losses: a Malian aircraft was shot down by Algerian air defences in 2025, and in Sudan one Akıncı reportedly shot down another in March 2026.\n\n## Place in history\nMore than a hundred built in four years. The Akıncı brings Turkish industry into the class of the **MQ-9 Reaper**. The **TB2** entry already cites it as its heavy platform; its successor, the jet-powered **Kızılelma**, has been flying since 2022.',
    (SELECT id FROM countries WHERE code = 'TUR'),
    NULL,
    '2019-12-06',
    '2021-08-29',
    361.0,
    7500.0,
    (SELECT id FROM manufacturer WHERE code = 'BAY'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar Akıncı'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar Akıncı'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar Akıncı'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar Akıncı'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar Akıncı'), (SELECT id FROM armement WHERE name = 'MAM-L'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar Akıncı'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar Akıncı'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar Akıncı'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.2,
  wingspan          = 20.0,
  height            = 4.1,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 6000,
  service_ceiling   = 13716,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko-Progress AI-450T (version A)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2021,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 11,
  variants          = E'- **Akıncı A** : version initiale, deux turbopropulseurs **AI-450T** de 450 ch\n- **Akıncı B** : moteurs de 750 ch, premier vol en mars 2022, monté à plus de 13 700 m\n- **Akıncı C** : moteurs de 850 ch, premier vol en février 2024\n- **Charge utile** de plus de 1 500 kg, huit points d''emport, munitions **MAM-L** et missiles de croisière\n- Plateforme lourde de la famille du **Bayraktar TB2**, avant le **Kızılelma** à réaction\n\n*Aucun équipage embarqué : l''appareil est piloté depuis une station au sol.*',
  variants_en       = E'- **Akıncı A** : initial version, two 450 hp **AI-450T** turboprops\n- **Akıncı B** : 750 hp engines, first flight in March 2022, climbed above 13,700 m\n- **Akıncı C** : 850 hp engines, first flight in February 2024\n- **Payload** of more than 1,500 kg, eight hardpoints, **MAM-L** munitions and cruise missiles\n- Heavy platform of the **Bayraktar TB2** family, ahead of the jet-powered **Kızılelma**\n\n*No onboard crew: the aircraft is flown from a ground station.*',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Baykar_Bayraktar_Akıncı',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Baykar_Bayraktar_Akıncı',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'CeeGee',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Bayraktar Akıncı';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bayraktar Akıncı';
