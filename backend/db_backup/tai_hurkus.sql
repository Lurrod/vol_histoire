-- TAI Hürkuş
--
-- Photo : TAI Hurkus at Paris Air Show 2017 (1).jpg
--   licence CC BY-SA 4.0 — Ibex73
--   https://commons.wikimedia.org/wiki/File%3ATAI_Hurkus_at_Paris_Air_Show_2017_%281%29.jpg

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
    'TAI Hürkuş',
    'TAI Hürkuş',
    'TAI Hürkuş',
    'TAI Hürkuş',
    'Le premier avion certifié conçu en Turquie',
    'The first certified aircraft designed in Turkey',
    '/assets/airplanes/tai-hurkus.jpg',
    E'## Genèse\nLa Turquie assemble sous licence des F-16 depuis 1987 et construit des drones depuis 2004, mais n''a jamais conçu et certifié un avion habité. En 2006, **TAI** lance le Hürkuş avec un objectif explicite : obtenir une **certification européenne EASA**, ce qu''aucun appareil turc n''a jamais eu.\n\n## Conception\nUn turbopropulseur **PT6A** de mille six cents chevaux, deux places en tandem, sièges éjectables zéro-zéro et cockpit tout-écran. La formule est celle du **Pilatus PC-21** et de l''**Embraer Super Tucano**, sans prétention à l''originalité. L''ambition n''est pas technique : elle est administrative et industrielle — franchir le processus de certification de bout en bout.\n\n## Carrière opérationnelle\nUne cinquantaine d''exemplaires. La certification EASA est obtenue en **2016**, dix ans après le lancement. La force aérienne turque le met en service en 2018 ; le **Niger** en achète douze en 2021 dans sa version armée Hürkuş-C, engagée contre les groupes armés du Sahel.\n\n## Place dans l''histoire\nCinquante exemplaires. Le Hürkuş est **le premier avion habité conçu, certifié et exporté par la Turquie**. Il ouvre une filière que le **TAI Kaan**, chasseur de cinquième génération dont ce catalogue tient déjà la fiche, entend prolonger — passage direct de l''école au chasseur furtif, sans étape intermédiaire.',
    E'## Genesis\nTurkey has assembled F-16s under licence since 1987 and built drones since 2004, but had never designed and certified a manned aircraft. In 2006 **TAI** launched the Hürkuş with an explicit goal: obtain **European EASA certification**, which no Turkish aircraft had ever held.\n\n## Design\nA sixteen-hundred-horsepower **PT6A** turboprop, two seats in tandem, zero-zero ejection seats and a glass cockpit. The formula is that of the **Pilatus PC-21** and the **Embraer Super Tucano**, with no claim to originality. The ambition is not technical: it is administrative and industrial — to go through the certification process from end to end.\n\n## Operational career\nSome fifty built. EASA certification came in **2016**, ten years after launch. The Turkish air force put it in service in 2018; **Niger** bought twelve in 2021 in the armed Hürkuş-C version, used against armed groups in the Sahel.\n\n## Place in history\nFifty built. The Hürkuş is **the first manned aircraft designed, certified and exported by Turkey**. It opens a line the **TAI Kaan**, a fifth-generation fighter already in this catalogue, intends to extend — a direct step from trainer to stealth fighter, with nothing in between.',
    (SELECT id FROM countries WHERE code = 'TUR'),
    '2006-03-01',
    '2013-08-29',
    '2018-01-01',
    574.0,
    1478.0,
    (SELECT id FROM manufacturer WHERE code = 'TAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Hürkuş'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Hürkuş'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'TAI Hürkuş'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Hürkuş'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'TAI Hürkuş'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'TAI Hürkuş'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.17,
  wingspan          = 9.96,
  height            = 3.75,
  wing_area         = 15.0,
  empty_weight      = 1900,
  mtow              = 3100,
  service_ceiling   = 10577,
  climb_rate        = 20.0,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.5,
  combat_radius     = 650,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-68T',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2013,
  production_end    = NULL,
  units_built       = 55,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Hürkuş-A** : version certifiée **EASA**, la première pour un appareil turc\n- **Hürkuş-B** : version militaire d''entraînement à cockpit tout-écran\n- **Hürkuş-C** : version armée d''appui léger, sept points d''emport\n- Nommé d''après **Vecihi Hürkuş**, pionnier turc du premier avion national en 1923\n- Vendu au **Niger** en 2021 : première exportation d''un avion habité turc',
  variants_en       = E'- **Hürkuş-A** : **EASA**-certified version, a first for a Turkish aircraft\n- **Hürkuş-B** : military training version with a glass cockpit\n- **Hürkuş-C** : armed light attack version, seven hardpoints\n- Named after **Vecihi Hürkuş**, the Turkish pioneer of the first national aircraft in 1923\n- Sold to **Niger** in 2021: the first export of a manned Turkish aircraft',

  -- Strate 4 : qualitatif
  nickname          = 'Hürkuş',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/TAI_Hürkuş',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/TAI_Hürkuş',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ibex73',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'TAI Hürkuş';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'TAI Hürkuş';
