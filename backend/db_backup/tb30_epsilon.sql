-- SOCATA TB-30 Epsilon
--
-- Photo : Socata TB 30 Epsilon (French Air Force).jpg
--   licence CC BY-SA 4.0 — 123-photos
--   https://commons.wikimedia.org/wiki/File%3ASocata_TB_30_Epsilon_%28French_Air_Force%29.jpg

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
    'SOCATA TB-30 Epsilon',
    'SOCATA TB-30 Epsilon',
    'SOCATA TB-30 Epsilon',
    'SOCATA TB-30 Epsilon',
    'Trente ans d’école élémentaire pour tous les pilotes français',
    'Thirty years of elementary training for every French pilot',
    '/assets/airplanes/tb30-epsilon.jpg',
    E'## Genèse\nL''armée de l''air française forme depuis 1958 ses élèves sur **Fouga Magister**, un avion à réaction. Le coût de l''heure de vol devient intenable dans les années 1970, et l''analyse conclut que les premières heures peuvent se faire sur hélice sans perte pédagogique. SOCATA, filiale d''Aérospatiale spécialisée dans l''aviation légère, propose l''Epsilon.\n\n## Conception\nDeux places **en tandem** — et non côte à côte, choix délibéré : l''élève doit s''habituer à voler seul dans un cockpit étroit, comme sur un chasseur. Un Lycoming de trois cents chevaux, une aile contrainte à près de sept g et un manche à balai central plutôt qu''un volant. Tout est fait pour que le passage à l''**Alpha Jet** ne soit pas une rupture.\n\n## Carrière opérationnelle\nCent soixante-douze exemplaires. De 1984 à **2016**, tous les pilotes de l''armée de l''air française commencent sur Epsilon à Salon-de-Provence. Le **Portugal** en achète dix-huit, le **Togo** quatre en version armée — engagés lors des troubles intérieurs de 1986.\n\n## Place dans l''histoire\nCent soixante-douze exemplaires et trente-deux ans de service. L''Epsilon ferme une époque : depuis 2016, la formation élémentaire française est **externalisée** à un prestataire civil volant sur Grob allemands. C''est le dernier avion-école conçu et produit en France.',
    E'## Genesis\nThe French air force had trained its students on the **Fouga Magister**, a jet, since 1958. The hourly cost became untenable in the 1970s, and analysis concluded that the first hours could be flown on a propeller aircraft without pedagogical loss. SOCATA, an Aérospatiale subsidiary specialising in light aviation, offered the Epsilon.\n\n## Design\nTwo seats **in tandem** — not side by side, a deliberate choice: the pupil must get used to flying alone in a narrow cockpit, as in a fighter. A three-hundred-horsepower Lycoming, a wing stressed to nearly seven g and a centre stick rather than a yoke. Everything is arranged so that the step up to the **Alpha Jet** is not a break.\n\n## Operational career\nOne hundred and seventy-two built. From 1984 to **2016** every French air force pilot began on the Epsilon at Salon-de-Provence. **Portugal** bought eighteen and **Togo** four in armed form — used during the internal unrest of 1986.\n\n## Place in history\nOne hundred and seventy-two built and thirty-two years of service. The Epsilon closes an era: since 2016 French elementary training has been **contracted out** to a civil provider flying German Grobs. It is the last trainer designed and built in France.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1978-01-01',
    '1979-12-22',
    '1984-07-01',
    358.0,
    1250.0,
    (SELECT id FROM manufacturer WHERE code = 'SOC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'SOCATA TB-30 Epsilon'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'SOCATA TB-30 Epsilon'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'SOCATA TB-30 Epsilon'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'SOCATA TB-30 Epsilon'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.59,
  wingspan          = 7.92,
  height            = 2.66,
  wing_area         = 9.0,
  empty_weight      = 932,
  mtow              = 1250,
  service_ceiling   = 7000,
  climb_rate        = 9.3,
  g_limit_pos       = 6.7,
  g_limit_neg       = -3.35,
  combat_radius     = 450,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming AEIO-540-L1B5D',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1983,
  production_end    = 1989,
  units_built       = 172,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **TB-30B Epsilon** : version française, cent cinquante exemplaires\n- **TB-30 armé** : version d''appui léger, exportée au **Togo** et au **Portugal**\n- **TB-31 Oméga** : version à turbopropulseur, prototype unique sans suite\n- Places en **tandem** sous une verrière unique, pour préparer au chasseur\n- Retiré en **2016**, remplacé par le **Grob G 120** allemand loué à un prestataire',
  variants_en       = E'- **TB-30B Epsilon** : French version, one hundred and fifty aircraft\n- **Armed TB-30** : light attack version, exported to **Togo** and **Portugal**\n- **TB-31 Oméga** : turboprop version, a single prototype with no sequel\n- **Tandem** seating under a single canopy, to prepare for the fighter\n- Retired in **2016**, replaced by the German **Grob G 120** leased from a contractor',

  -- Strate 4 : qualitatif
  nickname          = 'Epsilon',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/SOCATA_TB_30_Epsilon',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/SOCATA_TB_30_Epsilon',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '123-photos',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'SOCATA TB-30 Epsilon';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'SOCATA TB-30 Epsilon';
