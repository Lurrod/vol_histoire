-- CASA C-212 Aviocar
--
-- Photo : CASA 212-100 Aviocar ‘16508’ (53857138188).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3ACASA_212-100_Aviocar_%E2%80%9816508%E2%80%99_%2853857138188%29.jpg

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
    'CASA C-212 Aviocar',
    'CASA C-212 Aviocar',
    'CASA C-212 Aviocar',
    'CASA C-212 Aviocar',
    'Le camion volant espagnol, vendu à plus de quarante pays',
    'The Spanish flying truck, sold to more than forty countries',
    '/assets/airplanes/c212-aviocar.jpg',
    E'## Genèse\nL''Espagne de 1968 exploite encore des **Junkers Ju 52** construits sous licence trente ans plus tôt, et des DC-3 de la même génération. CASA reçoit une commande simple : les remplacer par quelque chose de moderne, mais qui coûte le même prix à l''heure de vol — c''est-à-dire presque rien.\n\n## Conception\nLa réponse est un appareil dépouillé : train **fixe**, cabine non pressurisée, structure métallique conventionnelle, deux turbopropulseurs **TPE331**. Il n''y a rien à rentrer, rien à réguler, presque rien à régler. La rampe arrière permet le largage et le chargement de véhicules légers, et l''appareil se pose sur huit cents mètres de terre.\n\n## Carrière opérationnelle\nQuatre cent soixante-dix-huit exemplaires, **plus de quarante pays**, et une production ouverte de 1971 à 2013 — quarante-deux ans. Il transporte, largue, photographie, patrouille au-dessus de la mer, forme des parachutistes et évacue des blessés, du Chili à l''Angola en passant par l''Indonésie qui l''assemble sous licence.\n\n## Place dans l''histoire\nQuatre cent soixante-dix-huit exemplaires. L''Aviocar a fait de CASA un constructeur exportateur, ce qui a rendu possible la coentreprise du **CN-235** avec l''Indonésie, puis l''entrée de l''entreprise dans **Airbus**. Le C-212 est aussi, avec le **C-101 Aviojet**, l''un des deux seuls appareils espagnols à succès international.',
    E'## Genesis\nSpain in 1968 was still flying **Junkers Ju 52s** licence-built thirty years earlier, and DC-3s of the same generation. CASA received a simple order: replace them with something modern that costs the same per flight hour — that is, almost nothing.\n\n## Design\nThe answer is a stripped-down aircraft: **fixed** gear, unpressurised cabin, conventional metal structure, two **TPE331** turboprops. There is nothing to retract, nothing to regulate, almost nothing to adjust. The rear ramp allows airdrops and the loading of light vehicles, and the aircraft lands on eight hundred metres of dirt.\n\n## Operational career\nFour hundred and seventy-eight built, **more than forty countries**, and a production run open from 1971 to 2013 — forty-two years. It carries, drops, photographs, patrols over the sea, trains paratroopers and evacuates casualties, from Chile to Angola by way of Indonesia, which assembles it under licence.\n\n## Place in history\nFour hundred and seventy-eight built. The Aviocar made CASA an exporting manufacturer, which made possible the **CN-235** joint venture with Indonesia and then the firm''s entry into **Airbus**. The C-212 is also, with the **C-101 Aviojet**, one of only two internationally successful Spanish aircraft.',
    (SELECT id FROM countries WHERE code = 'ESP'),
    '1968-01-01',
    '1971-03-26',
    '1974-05-01',
    370.0,
    1811.0,
    (SELECT id FROM manufacturer WHERE code = 'CASA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.15,
  wingspan          = 20.28,
  height            = 6.6,
  wing_area         = 41.0,
  empty_weight      = 3780,
  mtow              = 8100,
  service_ceiling   = 7925,
  climb_rate        = 8.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 700,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Honeywell TPE331-12JR',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1971,
  production_end    = 2013,
  units_built       = 478,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 40,
  variants          = E'- **C-212-100 à -400** : quatre générations successives sur quarante-deux ans\n- **C-212 MPA Patrullero** : patrouille maritime, à radar de nez\n- **TC-12 / D.3** : versions espagnoles de transport et de photographie\n- Assemblé sous licence en **Indonésie** par IPTN, à plus de cent exemplaires\n- Train **fixe** et fuselage non pressurisé : simplicité assumée, entretien minimal',
  variants_en       = E'- **C-212-100 to -400** : four successive generations over forty-two years\n- **C-212 MPA Patrullero** : maritime patrol, with a nose radar\n- **TC-12 / D.3** : Spanish transport and photographic versions\n- Licence-assembled in **Indonesia** by IPTN, more than a hundred aircraft\n- **Fixed** undercarriage and unpressurised fuselage: deliberate simplicity, minimal upkeep',

  -- Strate 4 : qualitatif
  nickname          = 'Aviocar',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/CASA_C-212_Aviocar',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/CASA_C-212_Aviocar',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'CASA C-212 Aviocar';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'CASA C-212 Aviocar';
