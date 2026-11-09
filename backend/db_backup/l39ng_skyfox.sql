-- Aero L-39NG Skyfox
--
-- Photo : L-39NG flying low.jpg
--   licence CC BY-SA 4.0 — Admiralis-generalis-Aladeen
--   https://commons.wikimedia.org/wiki/File:L-39NG_flying_low.jpg

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
    'Aero L-39NG Skyfox',
    'Aero L-39NG Skyfox',
    'Aero Vodochody L-39NG Skyfox',
    'Aero Vodochody L-39NG Skyfox',
    'L’Albatros refait à neuf : la cellule d’un best-seller, un moteur et un poste de pilotage modernes',
    'The Albatros rebuilt: a best-seller’s airframe with a modern engine and cockpit',
    '/assets/airplanes/l39ng-skyfox.jpg',
    E'## Genèse\nL''**Aero L-39 Albatros** a formé les pilotes de chasse d''une trentaine de pays du pacte de Varsovie et au-delà ; près de trois mille exemplaires ont été construits. Au début des années 2010, des centaines restent en service mais vieillissent, et leur moteur ukrainien AI-25TL n''a plus d''avenir commercial. En juillet 2014, au salon de Farnborough, **Aero Vodochody** lance le L-39NG (*Next Generation*) : reprendre la formule éprouvée de l''Albatros avec une cellule renforcée, un moteur occidental et une avionique de chasseur moderne.\n\n## Conception\nLa silhouette reste celle de l''Albatros, mais la voilure, refaite d''une seule pièce, abandonne les réservoirs de bout d''aile. Le moteur est un turbofan américain **Williams FJ44-4M** de 16,9 kN, sans postcombustion, plus économique et plus facile à entretenir. Le poste de pilotage en tandem reçoit des écrans multifonctions et peut simuler capteurs et armements de chasseurs plus lourds. Cinq points d''emport acceptent jusqu''à 1 640 kg de charges, ce qui permet aussi l''attaque légère. Le démonstrateur L-39CW, un Albatros remotorisé, vole dès le 14 septembre 2015.\n\n## Carrière opérationnelle\nLe premier prototype du L-39NG vole le **22 décembre 2018** et l''appareil est certifié par le ministère tchèque de la Défense en 2020. Le **Vietnam** reçoit ses premiers exemplaires fin 2023 et le douzième en avril 2025. Le centre de formation de Pardubice, qui forme les pilotes militaires tchèques, est livré début 2025, la **Hongrie** à partir de mai 2025. D''autres commandes à l''export ont suivi.\n\n## Place dans l''histoire\nLe Skyfox est un pari rare : moderniser un avion de 1968 plutôt que d''en concevoir un nouveau, en misant sur la fidélité des anciens utilisateurs de l''Albatros. Il occupe le créneau de l''entraîneur subsonique économique, sous les biréacteurs comme l''**M-346 Master** et les supersoniques comme le **TAI Hürjet**, et prolonge la lignée tchécoslovaque d''avions-écoles ouverte par l''**Aero L-29 Delfín**.',
    E'## Genesis\nThe **Aero L-39 Albatros** trained the fighter pilots of some thirty countries in the Warsaw Pact and beyond; nearly three thousand were built. In the early 2010s hundreds remained in service but were ageing, and their Ukrainian AI-25TL engine had no commercial future. In July 2014, at the Farnborough air show, **Aero Vodochody** launched the L-39NG (*Next Generation*): taking the Albatros''s proven formula with a strengthened airframe, a Western engine and modern fighter avionics.\n\n## Design\nThe silhouette is still the Albatros''s, but the wing, rebuilt in one piece, gives up the wingtip tanks. The engine is an American **Williams FJ44-4M** turbofan of 16.9 kN, without afterburner, more economical and easier to maintain. The tandem cockpit receives multifunction displays and can simulate the sensors and weapons of heavier fighters. Five hardpoints accept up to 1,640 kg of stores, which also allows light attack. The L-39CW demonstrator, a re-engined Albatros, flew as early as 14 September 2015.\n\n## Operational career\nThe first L-39NG prototype flew on **22 December 2018** and the aircraft was certified by the Czech Ministry of Defence in 2020. **Vietnam** received its first examples in late 2023 and the twelfth in April 2025. The Pardubice training centre, which trains Czech military pilots, took delivery in early 2025, and **Hungary** from May 2025. Further export orders have followed.\n\n## Place in history\nThe Skyfox is a rare bet: modernising a 1968 aircraft rather than designing a new one, counting on the loyalty of former Albatros users. It occupies the niche of the economical subsonic trainer, below twin-jets such as the **M-346 Master** and supersonic designs such as the **TAI Hürjet**, and continues the Czechoslovak line of jet trainers begun by the **Aero L-29 Delfín**.',
    (SELECT id FROM countries WHERE code = 'CSK'),
    '2014-07-01',
    '2018-12-22',
    '2023-01-01',
    900.0,
    2590.0,
    (SELECT id FROM manufacturer WHERE code = 'AERO'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-39NG Skyfox'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Aero L-39NG Skyfox'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-39NG Skyfox'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Aero L-39NG Skyfox'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.83,
  wingspan          = 9.37,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = 3100,
  mtow              = 5800,
  service_ceiling   = 11500,
  climb_rate        = 23.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Williams International FJ44-4M',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 16.89,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **L-39CW** : démonstrateur, Albatros remotorisé, premier vol le **14 septembre 2015**\n- **L-39NG** : version de série, premier vol le **22 décembre 2018**\n- Voilure monobloc **sans réservoirs de bout d''aile**, contrairement à l''Albatros\n- Cinq points d''emport, jusqu''à **1 640 kg** de charges\n- Livré au **Vietnam**, au centre de formation tchèque de Pardubice et à la **Hongrie**',
  variants_en       = E'- **L-39CW** : demonstrator, a re-engined Albatros, first flight on **14 September 2015**\n- **L-39NG** : production version, first flight on **22 December 2018**\n- One-piece wing **without wingtip tanks**, unlike the Albatros\n- Five hardpoints, up to **1,640 kg** of stores\n- Delivered to **Vietnam**, the Czech Pardubice training centre and **Hungary**',

  -- Strate 4 : qualitatif
  nickname          = 'Skyfox',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aero_L-39NG',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Admiralis-generalis-Aladeen',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Aero L-39NG Skyfox';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aero L-39NG Skyfox';
