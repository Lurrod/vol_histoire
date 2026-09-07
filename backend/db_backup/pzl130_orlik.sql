-- PZL-130 Orlik
--
-- Photo : PZL-130TC-2 Orlik 030 (11842110614).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File%3APZL-130TC-2_Orlik_030_%2811842110614%29.jpg

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
    'PZL-130 Orlik',
    'PZL-130 Orlik',
    'PZL-130 Orlik',
    'PZL-130 Orlik',
    'Conçu sous le pacte de Varsovie, motorisé par l’Ouest après 1989',
    'Designed under the Warsaw Pact, Western-engined after 1989',
    '/assets/airplanes/pzl130-orlik.jpg',
    E'## Genèse\nEn 1981, la Pologne est encore membre du pacte de Varsovie et son école de base, le **TS-11 Iskra**, a vingt ans. PZL Warszawa-Okęcie lance l''Orlik en visant un objectif précis : reproduire au sol le comportement d''un chasseur à réaction avec la consommation d''un avion à hélice, la même idée que le PC-7 suisse au même moment.\n\n## Conception\nUn turbopropulseur, deux places en tandem, une aile courte et une verrière haute. La première version reçoit un moteur **Vedeneïev M-14** soviétique, seul disponible dans le bloc. Après 1989, tout change : la Pologne se tourne vers l''Ouest et remotorise l''appareil avec un **PT6 canadien**, doublant presque la puissance et transformant les performances.\n\n## Carrière opérationnelle\nQuarante-huit exemplaires, un seul opérateur. L''Orlik entre en service en 1994 — treize ans après le début du programme, retard imputable au changement de régime autant qu''à la technique. Il devient la monture de la patrouille acrobatique nationale, dont il porte le nom, et forme les pilotes polonais aux côtés de l''Iskra qu''il devait remplacer.\n\n## Place dans l''histoire\nQuarante-huit exemplaires. Sa trajectoire est celle de la Pologne : un appareil commencé sous le pacte de Varsovie, achevé dans l''OTAN, avec un moteur canadien à la place d''un moteur soviétique. Il forme aujourd''hui les pilotes qui voleront sur **F-16** et **FA-50**.',
    E'## Genesis\nIn 1981 Poland was still a Warsaw Pact member and its basic trainer, the **TS-11 Iskra**, was twenty years old. PZL Warszawa-Okęcie launched the Orlik with a precise goal: reproduce the handling of a jet fighter with the fuel consumption of a propeller aircraft, the same idea as the Swiss PC-7 at the same moment.\n\n## Design\nA turboprop, two seats in tandem, a short wing and a high canopy. The first version received a Soviet **Vedeneyev M-14**, the only engine available in the bloc. After 1989 everything changed: Poland turned west and re-engined the aircraft with a **Canadian PT6**, nearly doubling the power and transforming its performance.\n\n## Operational career\nForty-eight built, a single operator. The Orlik entered service in 1994 — thirteen years after the programme began, a delay owed to the change of regime as much as to engineering. It became the mount of the national display team, which bears its name, and trains Polish pilots alongside the Iskra it was meant to replace.\n\n## Place in history\nForty-eight built. Its trajectory is Poland''s: an aircraft begun under the Warsaw Pact, completed inside NATO, with a Canadian engine in place of a Soviet one. It now trains the pilots who will fly **F-16s** and **FA-50s**.',
    (SELECT id FROM countries WHERE code = 'POL'),
    '1981-01-01',
    '1984-10-12',
    '1994-01-01',
    501.0,
    1200.0,
    (SELECT id FROM manufacturer WHERE code = 'PZLW'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL-130 Orlik'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL-130 Orlik'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.0,
  wingspan          = 9.0,
  height            = 3.53,
  wing_area         = 12.9,
  empty_weight      = 1600,
  mtow              = 2700,
  service_ceiling   = 10060,
  climb_rate        = 15.0,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-25C',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1985,
  production_end    = NULL,
  units_built       = 48,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **PZL-130TB** : version d''origine, à moteur soviétique **Vedeneïev M-14**\n- **PZL-130TC-I / TC-II** : remotorisation en **PT6 canadien** après 1989\n- *Orlik* signifie « **aiglon** » en polonais\n- Monture de la patrouille acrobatique **Zespół Akrobacyjny Orlik** depuis 1998\n- Devait remplacer le **TS-11 Iskra** : l''Iskra a tenu jusqu''en 2021, plus longtemps que prévu',
  variants_en       = E'- **PZL-130TB** : original version, with a Soviet **Vedeneyev M-14** engine\n- **PZL-130TC-I / TC-II** : re-engined with a **Canadian PT6** after 1989\n- *Orlik* means ''**eaglet**'' in Polish\n- Mount of the **Zespół Akrobacyjny Orlik** display team since 1998\n- Was to replace the **TS-11 Iskra**: the Iskra lasted until 2021, longer than planned',

  -- Strate 4 : qualitatif
  nickname          = 'Orlik',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/PZL-130_Orlik',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/PZL-130_Orlik',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'PZL-130 Orlik';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'PZL-130 Orlik';
