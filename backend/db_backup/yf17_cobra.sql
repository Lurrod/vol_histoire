-- Northrop YF-17 Cobra
--
-- Photo : YF-17 Cobra refueled by KC-97L.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3AYF-17_Cobra_refueled_by_KC-97L.jpg

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
    'YF-17 Cobra',
    'YF-17 Cobra',
    'Northrop YF-17 Cobra',
    'Northrop YF-17 Cobra',
    'Battu par le F-16, devenu le F/A-18 : le perdant le plus rentable de l’histoire',
    'Beaten by the F-16, became the F/A-18: history’s most profitable loser',
    '/assets/airplanes/yf17-cobra.jpg',
    E'## Genèse\nLes leçons du Vietnam ont donné naissance à une école : celle du chasseur léger, agile et bon marché, opposée au F-15 lourd et coûteux. En 1972, l''Air Force lance la compétition **Lightweight Fighter** et retient deux concurrents : le YF-16 monomoteur de General Dynamics, et le **YF-17 bimoteur** de Northrop, dérivé de son projet de vente à l''export P-530 Cobra.\n\n## Conception\nLe trait distinctif du YF-17 tient à ses **extensions d''emplanture** — ces prolongements du bord d''attaque le long du fuselage qui, à forte incidence, génèrent des tourbillons collant l''écoulement à l''aile. L''appareil vole ainsi sous contrôle à 63 degrés d''incidence. Deux réacteurs YJ101 lui donnent un rapport poussée/poids supérieur à un, et une survivabilité que le monomoteur n''a pas.\n\n## Carrière opérationnelle\nAucune. Deux cent quatre-vingt-huit vols en 1974 et 1975. En janvier 1975, l''Air Force choisit le **F-16** : moins cher à l''achat, moins cher à l''heure de vol, et partageant son moteur avec le F-15. Northrop a perdu la plus grosse commande de chasse de la décennie.\n\n## Place dans l''histoire\nDeux exemplaires — et la plus belle revanche de l''histoire aéronautique. L''US Navy, qui refusait un monomoteur au-dessus de l''océan, reprend le YF-17, l''associe à McDonnell Douglas, le renforce et le navalise : c''est le **F/A-18 Hornet**, produit à plus de deux mille exemplaires et toujours en service sous la forme du **Super Hornet**.',
    E'## Genesis\nThe lessons of Vietnam had produced a school of thought: the light, agile, cheap fighter, against the heavy and expensive F-15. In 1972 the Air Force launched the **Lightweight Fighter** competition and selected two contenders: General Dynamics'' single-engined YF-16, and Northrop''s **twin-engined YF-17**, derived from its P-530 Cobra export project.\n\n## Design\nThe YF-17''s distinguishing feature is its **leading-edge root extensions** — those forward extensions along the fuselage which, at high angles of attack, generate vortices that keep the flow attached to the wing. The aircraft flies under control at 63 degrees of incidence. Two YJ101 engines give it a thrust-to-weight ratio above one, and a survivability the single-engined design lacks.\n\n## Operational career\nNone. Two hundred and eighty-eight flights in 1974 and 1975. In January 1975 the Air Force chose the **F-16**: cheaper to buy, cheaper per flight hour, and sharing its engine with the F-15. Northrop had lost the biggest fighter order of the decade.\n\n## Place in history\nTwo built — and the finest revenge in aviation history. The US Navy, which refused a single engine over the ocean, took the YF-17, paired it with McDonnell Douglas, strengthened it and navalised it: this is the **F/A-18 Hornet**, built in more than two thousand examples and still in service as the **Super Hornet**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1971-01-01',
    '1974-06-09',
    NULL,
    1915.0,
    4810.0,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'YF-17 Cobra'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'YF-17 Cobra'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'YF-17 Cobra'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'YF-17 Cobra'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'YF-17 Cobra'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'YF-17 Cobra'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.6,
  wingspan          = 10.67,
  height            = 4.42,
  wing_area         = 32.5,
  empty_weight      = 9530,
  mtow              = 10430,
  service_ceiling   = 15240,
  climb_rate        = 254.0,
  g_limit_pos       = 9.4,
  g_limit_neg       = NULL,
  combat_radius     = 1000,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric YJ101-GE-100',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 41.4,
  thrust_wet        = 66.7,

  -- Strate 3 : production & service
  production_start  = 1972,
  production_end    = 1974,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **YF-17** : deux prototypes, deux cent quatre-vingt-huit vols en 1974 et 1975\n- Opposé au **YF-16** de General Dynamics dans la compétition **Lightweight Fighter**\n- Perd en janvier 1975 : le F-16 monomoteur est moins cher à l''achat et à l''entretien\n- Repris par McDonnell Douglas et navalisé : devient le **F/A-18 Hornet**\n- **Extensions d''emplanture** (LERX) qui génèrent des tourbillons portants à forte incidence',
  variants_en       = E'- **YF-17** : two prototypes, two hundred and eighty-eight flights in 1974 and 1975\n- Faced General Dynamics'' **YF-16** in the **Lightweight Fighter** competition\n- Lost in January 1975: the single-engined F-16 was cheaper to buy and to run\n- Taken up by McDonnell Douglas and navalised: became the **F/A-18 Hornet**\n- **Leading-edge root extensions** generating lifting vortices at high angles of attack',

  -- Strate 4 : qualitatif
  nickname          = 'Cobra',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_YF-17',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_YF-17',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'YF-17 Cobra';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'YF-17 Cobra';
