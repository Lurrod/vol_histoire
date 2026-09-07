-- IAI Harop (Harpy 2)
--
-- Photo : IAI Harop, ILA 2024, Schoenefeld (ILA45472).jpg
--   licence CC BY-SA 4.0 — Matti Blume
--   https://commons.wikimedia.org/wiki/File%3AIAI_Harop%2C_ILA_2024%2C_Schoenefeld_%28ILA45472%29.jpg

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
    'IAI Harop',
    'IAI Harop',
    'IAI Harop (Harpy 2)',
    'IAI Harop (Harpy 2)',
    'Munition rôdeuse : elle patrouille six heures puis devient le missile',
    'Loitering munition: it patrols for six hours, then becomes the missile',
    '/assets/airplanes/iai-harop.jpg',
    E'## Genèse\nUn missile antiradar classique doit être tiré quand le radar émet ; s''il s''éteint, le missile est perdu. IAI renverse le problème dès 1989 avec le **Harpy** : un engin qui **patrouille** au-dessus d''une zone en attendant qu''un radar s''allume, puis pique dessus. Le Harop en est la version aboutie, avec une caméra et un opérateur.\n\n## Conception\nDeux mètres cinquante, cent trente-cinq kilogrammes, une aile delta-canard et un petit moteur rotatif. Il n''a ni train ni piste : on le lance d''un **conteneur** monté sur camion. La charge militaire de vingt-trois kilogrammes est **dans le nez** — l''appareil entier est le missile. S''il ne trouve rien, il revient et se pose au parachute, réutilisable.\n\n## Carrière opérationnelle\nSept clients connus. L''**Azerbaïdjan** l''emploie au Haut-Karabagh en 2016, puis massivement en 2020 contre les défenses arméniennes : des vidéos de piqué filmées par l''engin lui-même circulent et font, autant que les résultats, la réputation du système. L''Inde, le Maroc et l''Allemagne l''acquièrent ensuite.\n\n## Place dans l''histoire\nLe Harop a créé une catégorie : la **munition rôdeuse**, ni drone ni missile, qui a transformé les conflits des années 2020 — du Haut-Karabagh à l''Ukraine. Sa question centrale, celle du degré d''autonomie qu''on accorde à une machine dans la décision de tirer, n''a toujours pas de réponse juridique internationale.',
    E'## Genesis\nA conventional anti-radar missile must be fired while the radar is transmitting; if it shuts down, the missile is wasted. IAI reversed the problem as early as 1989 with the **Harpy**: a machine that **loiters** over an area waiting for a radar to switch on, then dives on it. The Harop is the mature version, with a camera and an operator.\n\n## Design\nTwo and a half metres, a hundred and thirty-five kilogrammes, a delta-canard wing and a small rotary engine. It has no undercarriage and needs no runway: it is launched from a **container** on a truck. The twenty-three-kilogramme warhead is **in the nose** — the whole aircraft is the missile. Finding nothing, it returns and lands by parachute, reusable.\n\n## Operational career\nSeven known customers. **Azerbaijan** used it in Nagorno-Karabakh in 2016 and then heavily in 2020 against Armenian defences: videos of the dive, filmed by the weapon itself, circulated widely and made the system''s reputation as much as its results did. India, Morocco and Germany have since bought it.\n\n## Place in history\nThe Harop created a category: the **loitering munition**, neither drone nor missile, which has transformed the conflicts of the 2020s — from Nagorno-Karabakh to Ukraine. Its central question, how much autonomy a machine is granted in the decision to fire, still has no answer in international law.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '2001-01-01',
    '2005-01-01',
    '2009-01-01',
    417.0,
    1000.0,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Harop'), (SELECT id FROM tech WHERE name = 'Aile delta-canard'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Harop'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'IAI Harop'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 2.5,
  wingspan          = 3.0,
  height            = 0.8,
  wing_area         = 2.0,
  empty_weight      = 115,
  mtow              = 135,
  service_ceiling   = 4600,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 200,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'UEL AR-731',
  engine_count      = 1,
  engine_type       = 'Moteur rotatif',
  engine_type_en    = 'Rotary engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2005,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 7,
  variants          = E'- **Harpy** : prédécesseur de 1989, autonome, dédié aux **radars** ennemis\n- **Harop** : ajoute une caméra et un **opérateur dans la boucle** avant l''impact\n- Lancée d''un **conteneur** monté sur camion ou sur navire, sans piste\n- **Six heures** de patrouille avant de piquer sur sa cible, ou de rentrer\n- Employée par l''**Azerbaïdjan** au Haut-Karabagh en 2016 puis en 2020',
  variants_en       = E'- **Harpy** : the 1989 predecessor, fully autonomous, aimed at enemy **radars**\n- **Harop** : adds a camera and an **operator in the loop** before impact\n- Launched from a **container** on a truck or a ship, needing no runway\n- **Six hours** of patrol before diving on its target, or returning\n- Used by **Azerbaijan** in Nagorno-Karabakh in 2016 and again in 2020',

  -- Strate 4 : qualitatif
  nickname          = 'Harpy 2',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/IAI_Harop',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAI_Harop',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Matti Blume',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'IAI Harop';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'IAI Harop';
