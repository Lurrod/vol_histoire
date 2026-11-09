-- TAI Hürjet
--
-- Photo : TAI Hürjet Teknofest 2023.jpg
--   licence CC BY 3.0 — tolgaozbekcom
--   https://commons.wikimedia.org/wiki/File:TAI_H%C3%BCrjet_Teknofest_2023.jpg

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
    'TAI Hürjet',
    'TAI Hürjet',
    'TAI Hürjet',
    'TAI Hürjet',
    'L’entraîneur supersonique turc, appelé à remplacer le T-38 et à préparer les pilotes du Kaan',
    'Turkey’s supersonic trainer, set to replace the T-38 and prepare Kaan pilots',
    '/assets/airplanes/tai-hurjet.jpg',
    E'## Genèse\nL''aviation turque forme ses pilotes de chasse sur des **T-38 Talon** livrés à partir de la fin des années 1970 et modernisés en T-38M. Pour les remplacer, et pour préparer le passage à des chasseurs de nouvelle génération comme le **TAI Kaan**, **TAI** (Turkish Aerospace Industries) lance en juillet 2017, sur ses fonds propres, un entraîneur avancé à réaction ; le projet est approuvé officiellement le 14 août 2017. Il complète le turbopropulseur **TAI Hürkuş**, destiné aux premières phases de formation ; les deux noms partagent la racine *hür*, « libre » en turc.\n\n## Conception\nUn monoréacteur biplace en tandem de 13,6 mètres, à commandes de vol électriques, propulsé par un **General Electric F404** de 53 kN à sec et 78,7 kN avec postcombustion, le moteur du T-50 sud-coréen. TAI annonce une vitesse de Mach 1,4, un plafond d''environ 13 700 mètres et un facteur de charge de +8/-3 g. L''avionique reproduit celle d''un chasseur moderne pour simuler en vol radar, capteurs et armements, afin de réduire les heures coûteuses passées sur les chasseurs eux-mêmes. Une version d''attaque légère est annoncée.\n\n## Carrière opérationnelle\nPremier vol le **25 avril 2023** à Ankara, un second prototype vole en novembre 2024. Le premier appareil de série destiné à l''aviation turque vole le 30 août 2026 ; les premières livraisons, dont une partie pour la patrouille acrobatique des Turkish Stars, sont visées pour la fin de 2026. En 2025, l''Espagne choisit le Hürjet pour remplacer ses **F-5** d''entraînement, dans un accord conclu avec Airbus.\n\n## Place dans l''histoire\nLe Hürjet est le premier avion à réaction d''entraînement conçu en Turquie, et l''un des rares entraîneurs supersoniques développés au XXIe siècle, aux côtés du **KAI T-50 Golden Eagle** et du **Boeing T-7 Red Hawk**. Il concurrence directement l''**M-346 Master** italien sur le marché de la formation avancée.',
    E'## Genesis\nThe Turkish air force trains its fighter pilots on **T-38 Talons** delivered from the late 1970s and upgraded to T-38M standard. To replace them, and to prepare the move to new-generation fighters such as the **TAI Kaan**, **TAI** (Turkish Aerospace Industries) launched in July 2017, with its own funds, an advanced jet trainer; the project was officially approved on 14 August 2017. It complements the **TAI Hürkuş** turboprop, intended for the early phases of training; both names share the root *hür*, Turkish for "free".\n\n## Design\nA single-engined tandem two-seater of 13.6 metres with fly-by-wire controls, powered by a **General Electric F404** of 53 kN dry and 78.7 kN with afterburner, the engine of the South Korean T-50. TAI quotes a speed of Mach 1.4, a ceiling of about 13,700 metres and load limits of +8/-3 g. The avionics reproduce those of a modern fighter to simulate radar, sensors and weapons in flight, reducing the costly hours spent on the fighters themselves. A light attack version has been announced.\n\n## Operational career\nFirst flight on **25 April 2023** at Ankara; a second prototype flew in November 2024. The first production aircraft for the Turkish air force flew on 30 August 2026; first deliveries, some of them for the Turkish Stars display team, are targeted for the end of 2026. In 2025 Spain chose the Hürjet to replace its training **F-5s**, in a deal concluded with Airbus.\n\n## Place in history\nThe Hürjet is the first jet trainer designed in Turkey, and one of the few supersonic trainers developed in the twenty-first century, alongside the **KAI T-50 Golden Eagle** and the **Boeing T-7 Red Hawk**. It competes directly with Italy''s **M-346 Master** in the advanced training market.',
    (SELECT id FROM countries WHERE code = 'TUR'),
    '2017-08-14',
    '2023-04-25',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'TAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Hürjet'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric F404')),
((SELECT id FROM airplanes WHERE name = 'TAI Hürjet'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'TAI Hürjet'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Hürjet'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.6,
  wingspan          = 9.5,
  height            = 4.1,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = 13700,
  climb_rate        = NULL,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F404',
  engine_count      = 1,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 53.07,
  thrust_wet        = 78.7,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Prototypes** : premier vol le **25 avril 2023**, second prototype en novembre 2024\n- **Série** : premier appareil destiné à l''aviation turque, premier vol le **30 août 2026**\n- **Attaque légère** : version armée annoncée par TAI\n- Moteur **General Electric F404**, celui du T-50 sud-coréen\n- Choisi par l''**Espagne** en 2025 pour remplacer ses **F-5** d''entraînement',
  variants_en       = E'- **Prototypes** : first flight on **25 April 2023**, second prototype in November 2024\n- **Production** : first aircraft for the Turkish air force, first flight on **30 August 2026**\n- **Light attack** : armed version announced by TAI\n- **General Electric F404** engine, that of the South Korean T-50\n- Chosen by **Spain** in 2025 to replace its training **F-5s**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/TAI_H%C3%BCrjet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/TAI_H%C3%BCrjet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'tolgaozbekcom',
  image_licence     = 'CC BY 3.0'
WHERE name = 'TAI Hürjet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'TAI Hürjet';
