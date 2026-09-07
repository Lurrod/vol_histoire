-- Saab GlobalEye
--
-- Photo : Globaleye (53063401761).jpg
--   licence CC BY-SA 2.0 — Airwolfhound from Hertfordshire, UK
--   https://commons.wikimedia.org/wiki/File%3AGlobaleye_%2853063401761%29.jpg

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
    'Saab GlobalEye',
    'Saab GlobalEye',
    'Saab GlobalEye',
    'Saab GlobalEye',
    'Guet aérien suédois surveillant simultanément le ciel, la mer et le sol',
    'Swedish early warning aircraft watching air, sea and ground at once',
    '/assets/airplanes/saab-globaleye.jpg',
    E'## Genèse\nUn avion de guet aérien coûte cher parce qu''il est gros : l''**E-3 Sentry** est un Boeing 707 de cent cinquante tonnes servi par vingt personnes. Saab prend le problème à l''envers en montant son radar **Erieye** sur des cellules d''affaires, bien plus économiques à l''heure de vol. Le GlobalEye est l''aboutissement de cette démarche, engagée dès les années 1990 avec le Saab 340.\n\n## Conception\nLe radar n''est pas dans une soucoupe tournante mais dans une **poutre dorsale fixe**, à antenne active balayant électroniquement de part et d''autre. L''absence de rotation supprime l''usure mécanique et permet de concentrer l''énergie sur un secteur d''intérêt. Le GlobalEye ajoute un radar de surface maritime et un capteur optronique : un seul appareil suit **cent cinquante cibles aériennes, des navires et des véhicules au sol** en même temps, avec cinq opérateurs.\n\n## Carrière opérationnelle\nLes **Émirats arabes unis**, premier client, l''exploitent depuis 2020 sur le golfe Persique. La **Suède** l''a commandé en 2022 dans le contexte de son adhésion à l''OTAN, et le **Danemark** en 2024. L''OTAN l''a évalué pour succéder à sa flotte d''E-3, dont le retrait est prévu en 2035.\n\n## Place dans l''histoire\nHuit exemplaires livrés à ce jour. Son intérêt n''est pas la performance brute — un E-3 voit plus loin et dirige davantage — mais le **rapport entre la capacité et le coût d''exploitation** : un GlobalEye vole pour une fraction du prix horaire d''un quadriréacteur. Il ouvre le guet aérien à des pays qui n''y avaient pas accès, comme le **Beriev A-50** et l''E-3 l''avaient réservé aux deux grands.',
    E'## Genesis\nAn airborne early warning aircraft is expensive because it is large: the **E-3 Sentry** is a hundred-and-fifty-tonne Boeing 707 crewed by twenty. Saab turned the problem around by mounting its **Erieye** radar on business jet airframes, far cheaper by the flying hour. GlobalEye is the culmination of that approach, begun in the 1990s with the Saab 340.\n\n## Design\nThe radar sits not in a rotating saucer but in a **fixed dorsal beam**, an active array scanning electronically to either side. The absence of rotation removes mechanical wear and allows energy to be concentrated on a sector of interest. GlobalEye adds a maritime surface radar and an electro-optical sensor: a single aircraft tracks **a hundred and fifty air targets, ships and ground vehicles** at once, with five operators.\n\n## Operational career\nThe **United Arab Emirates**, the first customer, have flown it over the Persian Gulf since 2020. **Sweden** ordered it in 2022 in the context of its NATO accession, and **Denmark** in 2024. NATO has evaluated it to succeed its E-3 fleet, whose retirement is planned for 2035.\n\n## Place in history\nEight delivered so far. Its interest is not raw performance — an E-3 sees further and directs more — but the **ratio of capability to operating cost**: a GlobalEye flies for a fraction of a four-engined aircraft''s hourly price. It opens airborne early warning to countries that had no access to it, where the **Beriev A-50** and the E-3 had reserved it for the two great powers.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    '2015-01-01',
    '2018-03-14',
    '2020-04-29',
    900.0,
    7400.0,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.3,
  wingspan          = 28.5,
  height            = 7.6,
  wing_area         = 105.6,
  empty_weight      = 25000,
  mtow              = 42400,
  service_ceiling   = 12500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3000,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce BR710A2-20',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 65.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2016,
  production_end    = NULL,
  units_built       = 8,
  unit_cost_usd     = 250000000,
  unit_cost_year    = 2022,
  operators_count   = 3,
  variants          = E'- **GlobalEye** : version de série, bâtie sur un Bombardier Global 6000\n- **Erieye ER** : le radar lui-même, en poutre dorsale, portée étendue à 550 km\n- Commandé par les **Émirats arabes unis**, la Suède et le Danemark\n- Surveille **simultanément** l''air, la surface maritime et les mouvements au sol\n- Antenne fixe à balayage électronique : pas de rotation, donc pas d''usure mécanique',
  variants_en       = E'- **GlobalEye** : production version, built on a Bombardier Global 6000\n- **Erieye ER** : the radar itself, in a dorsal beam, range extended to 550 km\n- Ordered by the **United Arab Emirates**, Sweden and Denmark\n- Watches air, sea surface and ground movement **simultaneously**\n- Fixed electronically scanned array: no rotation, therefore no mechanical wear',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Saab_GlobalEye',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saab_GlobalEye',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Airwolfhound from Hertfordshire, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Saab GlobalEye';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saab GlobalEye';
