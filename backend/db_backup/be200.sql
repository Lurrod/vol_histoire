-- Beriev Be-200 Altaïr
--
-- Photo : RA-21512 Beriev Be-200 16.jpg
--   licence CC BY-SA 4.0 — New York-air
--   https://commons.wikimedia.org/wiki/File%3ARA-21512_Beriev_Be-200_16.jpg

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
    'Beriev Be-200',
    'Beriev Be-200',
    'Beriev Be-200 Altaïr',
    'Beriev Be-200 Altair',
    'Le seul hydravion à réaction produit en série',
    'The only jet-powered flying boat in series production',
    '/assets/airplanes/be200.jpg',
    E'## Genèse\nBeriev construit des hydravions depuis 1934 et achève en 1986 l''**A-40 Albatros**, le plus gros hydravion à réaction jamais volé, destiné à la lutte anti-sous-marine. La chute de l''URSS en arrête la production à six exemplaires. Le bureau propose alors une version réduite, civile, pour un besoin que la Russie a en abondance : les **feux de forêt**.\n\n## Conception\nUne coque de bateau, une aile haute en flèche, deux réacteurs **D-436** montés au-dessus de l''aile pour rester hors des embruns. L''appareil se pose sur l''eau, roule à quelques dizaines de nœuds en ouvrant ses écopes, et embarque **douze tonnes d''eau en quatorze secondes** sans s''arrêter. Il peut recommencer toutes les quinze minutes si le lac est proche.\n\n## Carrière opérationnelle\nDix-sept exemplaires. Le ministère russe des Situations d''urgence en est le principal opérateur ; l''**Italie**, la **Grèce**, le **Portugal**, Israël et l''**Algérie** l''ont affrété ou acheté lors de saisons d''incendies exceptionnelles. Les sanctions de 2022 ont interrompu les livraisons de moteurs ukrainiens, gelant la production.\n\n## Place dans l''histoire\nDix-sept exemplaires. Le Be-200 est **le seul hydravion à réaction produit en série au monde** — le japonais **US-2** est à hélices, le chinois AG600 aussi. Il ferme, pour l''instant, quatre-vingt-dix ans d''hydravions Beriev, dont ce catalogue compte trois appareils.',
    E'## Genesis\nBeriev has built flying boats since 1934 and completed in 1986 the **A-40 Albatros**, the largest jet flying boat ever flown, intended for anti-submarine work. The fall of the USSR stopped production at six aircraft. The bureau then offered a smaller, civil version for a need Russia has in abundance: **forest fires**.\n\n## Design\nA boat hull, a swept high wing, two **D-436** engines mounted above the wing to stay clear of spray. The aircraft alights on water, runs at a few tens of knots with its scoops open, and takes aboard **twelve tonnes of water in fourteen seconds** without stopping. It can repeat this every fifteen minutes if the lake is near.\n\n## Operational career\nSeventeen built. The Russian Emergency Situations Ministry is the main operator; **Italy**, **Greece**, **Portugal**, Israel and **Algeria** have chartered or bought it during exceptional fire seasons. The 2022 sanctions cut off Ukrainian engine deliveries, freezing production.\n\n## Place in history\nSeventeen built. The Be-200 is **the only jet-powered flying boat in series production in the world** — Japan''s **US-2** is propeller-driven, as is China''s AG600. It closes, for now, ninety years of Beriev flying boats, of which this catalogue holds three.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1990-01-01',
    '1998-09-24',
    '2003-07-31',
    700.0,
    3300.0,
    (SELECT id FROM manufacturer WHERE code = 'BER'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev Be-200'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-200'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev Be-200'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-200'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-200'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 32.05,
  wingspan          = 32.78,
  height            = 8.9,
  wing_area         = 117.44,
  empty_weight      = 27600,
  mtow              = 41000,
  service_ceiling   = 8000,
  climb_rate        = 13.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1200,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Progress D-436TP',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 73.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1998,
  production_end    = NULL,
  units_built       = 17,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **Be-200ChS / ES** : version de lutte contre l''incendie et de secours, la plus produite\n- **Be-200P** : version de patrouille maritime, proposée sans client à ce jour\n- Écope **douze tonnes d''eau en quatorze secondes** en effleurant un plan d''eau\n- Dérivé de l''hydravion militaire **A-40 Albatros**, resté à six exemplaires\n- Loué par l''**Italie**, la **Grèce**, le **Portugal** et l''**Algérie** pour les feux de forêt',
  variants_en       = E'- **Be-200ChS / ES** : firefighting and rescue version, the most produced\n- **Be-200P** : maritime patrol version, so far without a customer\n- Scoops **twelve tonnes of water in fourteen seconds** skimming a body of water\n- Derived from the military **A-40 Albatros** flying boat, built in only six examples\n- Chartered by **Italy**, **Greece**, **Portugal** and **Algeria** for forest fires',

  -- Strate 4 : qualitatif
  nickname          = 'Altaïr',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beriev_Be-200',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beriev_Be-200',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'New York-air',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Beriev Be-200';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beriev Be-200';
