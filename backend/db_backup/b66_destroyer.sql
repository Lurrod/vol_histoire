-- Douglas B-66 Destroyer
--
-- Photo : Douglas RB-66C Destroyer in flight (SN 54-450) over Edwards AFB Calif on Feb 19 1957 061102-F-1234P-035.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Douglas_RB-66C_Destroyer_in_flight_(SN_54-450)_over_Edwards_AFB_Calif_on_Feb_19_1957_061102-F-1234P-035.jpg

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
    'B-66 Destroyer',
    'B-66 Destroyer',
    'Douglas B-66 Destroyer',
    'Douglas B-66 Destroyer',
    'Une « simple » version terrestre de l’A-3, devenue un avion presque entièrement nouveau',
    'A “simple” land-based A-3 that became an almost entirely new aircraft',
    '/assets/airplanes/b66-destroyer.jpg',
    E'## Genèse\nAu début des années 1950, l''US Air Force, qui avait jugé irréalistes les performances annoncées de l''**A-3 Skywarrior** de la Navy, constate qu''elles sont réelles. La guerre de Corée réclame un bombardier tactique à réaction pour remplacer le **A-26 Invader**, et l''A-3, déjà payé par la Marine, paraît la solution la plus rapide. En juin 1952, Douglas reçoit une commande sans prototype : il suffira, pense-t-on, de retirer les équipements navals.\n\n## Conception\nIl n''en est rien. L''Air Force veut voler bas, quand l''A-3 avait été conçu pour la haute altitude, et multiplie les exigences : fuselage et voilure redessinés, réacteurs **Allison J71** à la place des J57, train, circuits hydrauliques et poste d''équipage revus. Les historiens Bill Gunston et Peter Gilchrist jugeront la plupart de ces changements inutiles. Une différence pèse pourtant : le B-66 reçoit les **sièges éjectables** que l''A-3 n''a jamais eus. Une tourelle de queue télécommandée arme deux canons de 20 mm.\n\n## Carrière opérationnelle\nPremier vol le 28 juin 1954. L''Air Force réduit vite la version bombardier — 72 B-66B seulement — au profit de la reconnaissance photographique de nuit, puis du renseignement électronique : le RB-66C emporte sept hommes, dont quatre opérateurs, et plusieurs surveillent Cuba pendant la crise des missiles de 1962. Le 10 mars 1964, un RB-66C égaré au-dessus de l''Allemagne de l''Est est abattu par un MiG-19 ; l''équipage s''éjecte. Au **Vietnam**, les EB-66 non armés brouillent les radars nord-vietnamiens pour couvrir les raids des **F-105 Thunderchief** et localisent les sites de missiles. Les derniers sont retirés en 1975.\n\n## Place dans l''histoire\nDeux cent quatre-vingt-quatorze exemplaires. La fiche de l''A-3 le présente comme une version terrestre ; c''est en réalité un avion presque entièrement nouveau, et l''exemple souvent cité d''une modification qui coûte autant qu''un programme neuf. Le bombardier a été une impasse, la plateforme de guerre électronique une réussite.',
    E'## Genesis\nIn the early 1950s the US Air Force, which had dismissed the claimed performance of the Navy''s **A-3 Skywarrior** as unrealistic, found that it was real. The Korean War called for a tactical jet bomber to replace the **A-26 Invader**, and the A-3, already paid for by the Navy, looked like the quickest answer. In June 1952 Douglas received an order with no prototype: it would be enough, everyone thought, to strip out the naval equipment.\n\n## Design\nNothing of the sort. The Air Force wanted to fly low, whereas the A-3 had been designed for high altitude, and its demands multiplied: redrawn fuselage and wing, **Allison J71** engines in place of the J57s, revised undercarriage, hydraulics and crew station. Historians Bill Gunston and Peter Gilchrist would judge most of these changes unnecessary. One difference did matter: the B-66 received the **ejection seats** the A-3 never had. A remotely controlled tail turret carried two 20 mm cannon.\n\n## Operational career\nFirst flight on 28 June 1954. The Air Force quickly cut back the bomber version — only 72 B-66Bs — in favour of night photographic reconnaissance and then electronic intelligence: the RB-66C carried seven men, four of them operators, and several watched Cuba during the 1962 missile crisis. On 10 March 1964 an RB-66C that had strayed over East Germany was shot down by a MiG-19; the crew ejected. Over **Vietnam**, unarmed EB-66s jammed North Vietnamese radars to cover **F-105 Thunderchief** raids and located missile sites. The last were retired in 1975.\n\n## Place in history\nTwo hundred and ninety-four built. The A-3 entry presents it as a land-based version; it was in fact an almost entirely new aircraft, and the often-cited example of a modification that costs as much as a new programme. The bomber was a dead end, the electronic warfare platform a success.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1952-06-01',
    '1954-06-28',
    '1956-01-01',
    1015.0,
    3974.0,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-66 Destroyer'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'B-66 Destroyer'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'B-66 Destroyer'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-66 Destroyer'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'B-66 Destroyer'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-66 Destroyer'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'B-66 Destroyer'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'B-66 Destroyer'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'B-66 Destroyer'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'B-66 Destroyer'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 22.91,
  wingspan          = 22.1,
  height            = 7.19,
  wing_area         = 72.46,
  empty_weight      = 19300,
  mtow              = 37648,
  service_ceiling   = 12009,
  climb_rate        = 25.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J71-A-13',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = NULL,
  units_built       = 294,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **RB-66A / RB-66B** : reconnaissance photographique de nuit, la seconde étant la version la plus produite\n- **B-66B** : bombardier tactique, 72 exemplaires seulement\n- **RB-66C / EB-66C** : renseignement et brouillage électroniques, 36 exemplaires, sept hommes d''équipage\n- **WB-66D** : reconnaissance météorologique ; deux exemplaires transformés en **X-21** d''études de flux laminaire\n- **EB-66E** : brouilleur converti à partir du B-66B, engagé au Vietnam',
  variants_en       = E'- **RB-66A / RB-66B** : night photographic reconnaissance, the latter being the most produced version\n- **B-66B** : tactical bomber, only 72 built\n- **RB-66C / EB-66C** : electronic intelligence and jamming, 36 built, seven crew\n- **WB-66D** : weather reconnaissance; two converted into **X-21** laminar-flow research aircraft\n- **EB-66E** : jammer converted from the B-66B, used over Vietnam',

  -- Strate 4 : qualitatif
  nickname          = 'Destroyer',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_B-66',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_B-66_Destroyer',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'B-66 Destroyer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'B-66 Destroyer';
