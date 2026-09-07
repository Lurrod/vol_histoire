-- HAL HJT-36 Sitara / Yashas
--
-- Photo : S3474 HAL HJT-36 Sitra (8414598298).jpg
--   licence CC BY-SA 3.0 — Aeroprints.com
--   https://commons.wikimedia.org/wiki/File%3AS3474_HAL_HJT-36_Sitra_%288414598298%29.jpg

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
    'HAL HJT-36 Sitara',
    'HAL HJT-36 Sitara',
    'HAL HJT-36 Sitara / Yashas',
    'HAL HJT-36 Sitara / Yashas',
    'Vingt-trois ans de développement pour remplacer le Kiran',
    'Twenty-three years of development to replace the Kiran',
    '/assets/airplanes/hjt36-sitara.jpg',
    E'## Genèse\nLe **HJT-16 Kiran** forme les pilotes indiens depuis 1968 et arrive au bout de sa vie de cellule. En 1999, HAL lance son remplaçant en promettant un premier vol en trois ans et une entrée en service en 2007. Le premier vol a bien lieu en 2003. Le reste n''a pas suivi.\n\n## Conception\nDeux places en tandem, aile en flèche modérée, sièges éjectables zéro-zéro et cockpit tout-écran : l''appareil est conventionnel et sans ambition excessive. Le choix contraint est le moteur — HAL retient le russe **AL-55I**, faute d''alternative accessible, et le programme se retrouve suspendu aux retards d''un fournisseur étranger.\n\n## Carrière opérationnelle\nAucune. Huit prototypes en vingt-deux ans. Le programme accumule les difficultés : livraisons de moteurs tardives, problèmes de vrille conduisant à une refonte complète du système de commandes, redésignation en **Yashas** en 2023 pour marquer le redémarrage. L''armée de l''air indienne a entre-temps prolongé ses Kiran deux fois.\n\n## Place dans l''histoire\nHuit prototypes, zéro appareil de série. Le Sitara est le contre-exemple du **KT-1** coréen, lancé à onze ans d''intervalle avec des ambitions comparables : la Corée a livré cent quatre-vingts appareils et bâti une industrie, l''Inde attend toujours. Il illustre ce que coûte la dépendance à un moteur qu''on ne fabrique pas.',
    E'## Genesis\nThe **HJT-16 Kiran** has trained Indian pilots since 1968 and is reaching the end of its airframe life. In 1999 HAL launched its replacement, promising a first flight in three years and service entry in 2007. The first flight duly happened in 2003. The rest did not follow.\n\n## Design\nTwo seats in tandem, a moderately swept wing, zero-zero ejection seats and a glass cockpit: the aircraft is conventional and not over-ambitious. The constrained choice is the engine — HAL settled on the Russian **AL-55I** for want of an accessible alternative, and the programme found itself hostage to a foreign supplier''s delays.\n\n## Operational career\nNone. Eight prototypes in twenty-two years. The programme accumulated difficulties: late engine deliveries, spin problems leading to a complete redesign of the control system, redesignation as **Yashas** in 2023 to mark the restart. The Indian Air Force has meanwhile extended its Kirans twice.\n\n## Place in history\nEight prototypes, no production aircraft. The Sitara is the counter-example to the Korean **KT-1**, launched eleven years apart with comparable ambitions: Korea delivered a hundred and eighty aircraft and built an industry, India is still waiting. It illustrates what dependence on an engine you do not build actually costs.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '1999-01-01',
    '2003-03-07',
    NULL,
    750.0,
    1000.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HJT-36 Sitara'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'HAL HJT-36 Sitara'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HJT-36 Sitara'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.0,
  wingspan          = 9.9,
  height            = 4.4,
  wing_area         = 18.0,
  empty_weight      = 2900,
  mtow              = 4900,
  service_ceiling   = 9000,
  climb_rate        = 25.0,
  g_limit_pos       = 7.0,
  g_limit_neg       = -2.5,
  combat_radius     = 400,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'NPO Saturn AL-55I',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 17.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2003,
  production_end    = NULL,
  units_built       = 8,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **HJT-36 Sitara** : désignation d''origine, *sitara* signifiant « **étoile** » en hindi\n- **HJT-36 Yashas** : version redésignée en 2023 après refonte du système de commandes\n- Réacteur russe **AL-55I**, dont les retards de livraison ont bloqué le programme\n- Doit remplacer le **HJT-16 Kiran**, en service depuis 1968\n- Vol inaugural en **2003**, certification toujours non acquise en 2025',
  variants_en       = E'- **HJT-36 Sitara** : original designation, *sitara* meaning ''**star**'' in Hindi\n- **HJT-36 Yashas** : redesignated in 2023 after a control system redesign\n- Russian **AL-55I** engine, whose delivery delays stalled the programme\n- Intended to replace the **HJT-16 Kiran**, in service since 1968\n- First flight in **2003**, certification still not achieved as of 2025',

  -- Strate 4 : qualitatif
  nickname          = 'Sitara',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/HAL_HJT-36_Sitara',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/HAL_HJT-36_Sitara',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Aeroprints.com',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'HAL HJT-36 Sitara';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'HAL HJT-36 Sitara';
