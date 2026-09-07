-- Lockheed A-12 Oxcart
--
-- Photo : A12-flying.jpg
--   licence Public domain — U.S.Air Force
--   https://commons.wikimedia.org/wiki/File%3AA12-flying.jpg

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
    'Lockheed A-12',
    'Lockheed A-12',
    'Lockheed A-12 Oxcart',
    'Lockheed A-12 Oxcart',
    'L’espion monoplace de la CIA, plus rapide que le SR-71 qui l’a remplacé',
    'The CIA’s single-seat spyplane, faster than the SR-71 that replaced it',
    '/assets/airplanes/a12-oxcart.jpg',
    E'## Genèse\nAprès la chute du U-2 de Gary Powers en mai 1960, la CIA a besoin d''un appareil que rien ne puisse rattraper. Le cahier des charges tient en trois nombres : **Mach 3,2**, **vingt-huit mille mètres**, et une surface équivalente radar aussi faible que possible. Kelly Johnson et la Skunk Works de Lockheed s''y attellent sous le nom de code **Oxcart**.\n\n## Conception\nÀ Mach 3,2, le frottement de l''air porte la peau à plus de trois cents degrés : l''aluminium fond, il faut du **titane**. Or le principal producteur mondial est l''Union soviétique — la CIA en achète par sociétés-écrans. Les bords d''attaque en matériau composite et les dérives inclinées vers l''intérieur constituent la première tentative sérieuse de réduction de signature radar de l''histoire.\n\n## Carrière opérationnelle\nQuinze exemplaires. Vingt-neuf missions réelles entre 1967 et 1968 depuis Kadena, au-dessus du **Nord-Vietnam** et de la **Corée du Nord** — dont le survol du navire espion *Pueblo* capturé. Aucun n''est abattu, bien que des missiles soient tirés. Six exemplaires sont perdus sur accident, deux pilotes tués.\n\n## Place dans l''histoire\nQuinze exemplaires, retirés en 1968 après dix-huit mois d''opérations. Le programme est annulé au profit du **SR-71**, biplace et plus polyvalent, que l''Air Force préfère et qui volera vingt-deux ans. L''A-12 reste pourtant **plus rapide et plus haut** que son successeur, et le seul appareil opérationnel de la CIA à avoir volé à Mach 3.',
    E'## Genesis\nAfter Gary Powers''s U-2 was shot down in May 1960, the CIA needed an aircraft nothing could catch. The requirement came down to three numbers: **Mach 3.2**, **twenty-eight thousand metres**, and as small a radar cross-section as possible. Kelly Johnson and Lockheed''s Skunk Works took it on under the codename **Oxcart**.\n\n## Design\nAt Mach 3.2 skin friction raises the surface above three hundred degrees: aluminium melts, so **titanium** is required. The world''s main producer was the Soviet Union — the CIA bought it through front companies. The composite leading edges and inward-canted fins are the first serious attempt at radar signature reduction in history.\n\n## Operational career\nFifteen built. Twenty-nine real missions between 1967 and 1968 from Kadena, over **North Vietnam** and **North Korea** — including an overflight of the captured spy ship *Pueblo*. None was shot down, though missiles were fired. Six were lost in accidents, two pilots killed.\n\n## Place in history\nFifteen built, retired in 1968 after eighteen months of operations. The programme was cancelled in favour of the **SR-71**, two-seat and more versatile, which the Air Force preferred and which would fly for twenty-two years. Yet the A-12 remains **faster and higher** than its successor, and the only operational CIA aircraft ever to fly at Mach 3.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1959-08-29',
    '1962-04-26',
    '1967-05-31',
    3560.0,
    4020.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed A-12'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Lockheed A-12'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Lockheed A-12'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed A-12'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed A-12'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'Lockheed A-12'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 31.26,
  wingspan          = 16.97,
  height            = 5.64,
  wing_area         = 170.0,
  empty_weight      = 24580,
  mtow              = 53000,
  service_ceiling   = 28900,
  climb_rate        = 60.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2000,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J58',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion et statoréacteur',
  engine_type_en    = 'Afterburning turbojet with ramjet bypass',
  thrust_dry        = 93.4,
  thrust_wet        = 144.6,

  -- Strate 3 : production & service
  production_start  = 1962,
  production_end    = 1964,
  units_built       = 15,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **A-12** : version de reconnaissance de la **CIA**, monoplace, treize exemplaires\n- **M-21** : version porteuse du drone **D-21**, deux exemplaires\n- **YF-12** : intercepteur biplace à missiles AIM-47, trois exemplaires\n- **SR-71** : dérivé biplace de l''US Air Force, plus lourd donc un peu plus lent\n- Titane acheté à l''**URSS** par sociétés-écrans : elle a fourni le métal de son espion',
  variants_en       = E'- **A-12** : **CIA** reconnaissance version, single-seat, thirteen built\n- **M-21** : mothership version for the **D-21** drone, two built\n- **YF-12** : two-seat interceptor with AIM-47 missiles, three built\n- **SR-71** : two-seat US Air Force derivative, heavier and so slightly slower\n- Titanium bought from the **USSR** through front companies: it supplied its spy''s metal',

  -- Strate 4 : qualitatif
  nickname          = 'Oxcart',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_A-12',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_A-12',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S.Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed A-12';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'moderee' WHERE name = 'Lockheed A-12';
