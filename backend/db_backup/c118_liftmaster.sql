-- Douglas C-118 Liftmaster
--
-- Photo : Douglas VC-118B in flight colour.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Douglas_VC-118B_in_flight_colour.jpg

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
    'Douglas C-118 Liftmaster',
    'Douglas C-118 Liftmaster',
    'Douglas C-118 Liftmaster',
    'Douglas C-118 Liftmaster',
    'Le DC-6 en uniforme, cargo du MATS et dernier avion présidentiel américain à hélices',
    'The DC-6 in uniform, MATS freighter and the last propeller-driven US presidential aircraft',
    '/assets/airplanes/c118-liftmaster.jpg',
    E'## Genèse\nEn 1944, les United States Army Air Forces commandent sous le nom de **XC-112** une version allongée, pressurisée et plus puissante du **C-54 Skymaster**. Quand le prototype XC-112A vole, le 15 février 1946, la guerre est finie et le besoin militaire a disparu. **Douglas** transforme alors le projet en long-courrier civil, le **DC-6**, conçu pour concurrencer le Lockheed Constellation. C''est par le chemin inverse que l''avion revient à l''uniforme : le Liftmaster est la version militaire du DC-6A cargo, et les armées le redécouvrent pendant la guerre de Corée.\n\n## Conception\nLe DC-6 reprend la formule du DC-4 avec un fuselage pressurisé allongé et quatre moteurs en étoile **Pratt & Whitney R-2800 Double Wasp** à injection d''eau, munis d''hélices réversibles. Le DC-6A, encore rallongé de 1,5 m, reçoit un plancher renforcé et deux portes cargo sur le flanc gauche, de part et d''autre de l''aile ; la porte arrière intègre un élévateur de 1,8 tonne. Il emporte 12,8 tonnes de fret. La version de la Navy, le R6D, adopte des R-2800-CB-17 de 2 500 ch, ensuite montés sur le DC-6B civil pour ses vols intercontinentaux.\n\n## Carrière opérationnelle\nL''US Air Force et l''US Navy commandent 167 appareils : 101 C-118A, 65 R6D-1 et un VC-118. Ce dernier, un DC-6 à fuselage court baptisé *Independence*, est le premier avion présidentiel de **Harry Truman**, de 1947 à 1953. Un VC-118A sert d''Air Force One à **John F. Kennedy** jusqu''en 1962, puis d''appareil de réserve : c''est le dernier avion à hélices de la flotte présidentielle. En 1962, les R6D de la Navy deviennent à leur tour des C-118. Le Liftmaster transporte aussi la troupe : c''est à bord de l''un d''eux qu''**Elvis Presley** rentre d''Allemagne après son service militaire.\n\n## Place dans l''histoire\nLa famille DC-6 compte 704 exemplaires, et le DC-6B passe pour l''aboutissement des avions de ligne à pistons, par sa robustesse et sa fiabilité. Plus d''une vingtaine de forces aériennes l''ont employé ; en France, de 1966 à 1977, des DC-6 soutiennent les essais nucléaires du Pacifique depuis Tahiti. L''Independence de Truman est exposé à Dayton et le VC-118A de Kennedy à Tucson. Plus simple et plus économique que le DC-7 qui l''a suivi, le DC-6 lui a survécu : quelques-uns volent encore en Alaska au XXIe siècle.',
    E'## Genesis\nIn 1944 the United States Army Air Forces ordered, as the **XC-112**, a lengthened, pressurised and more powerful version of the **C-54 Skymaster**. By the time the XC-112A prototype flew on 15 February 1946, the war was over and the military requirement had gone. **Douglas** then turned the project into a long-range airliner, the **DC-6**, designed to compete with the Lockheed Constellation. The aircraft returned to uniform by the opposite route: the Liftmaster is the military version of the DC-6A freighter, which the services rediscovered during the Korean War.\n\n## Design\nThe DC-6 took the DC-4 formula with a lengthened pressurised fuselage and four water-injected **Pratt & Whitney R-2800 Double Wasp** radials with reversing propellers. The DC-6A, stretched by a further 1.5 m, received a strengthened floor and two cargo doors on the left side, fore and aft of the wing; the rear door included a 1.8-tonne lift. It carried 12.8 tonnes of freight. The Navy version, the R6D, used 2,500 hp R-2800-CB-17s, later fitted to the civil DC-6B for its intercontinental flights.\n\n## Operational career\nThe US Air Force and US Navy ordered 167 aircraft: 101 C-118As, 65 R6D-1s and one VC-118. The latter, a short-fuselage DC-6 named *Independence*, was **Harry Truman**''s first presidential aircraft, from 1947 to 1953. A VC-118A served as **John F. Kennedy**''s Air Force One until 1962, then as the backup aircraft: it was the last propeller-driven aircraft in the presidential fleet. In 1962 the Navy''s R6Ds became C-118s in turn. The Liftmaster also carried troops: **Elvis Presley** flew home from Germany aboard one after his military service.\n\n## Place in history\nThe DC-6 family numbered 704 aircraft, and the DC-6B is regarded as the culmination of the piston-engined airliner for its ruggedness and reliability. More than twenty air forces used it; in France, from 1966 to 1977, DC-6s supported the Pacific nuclear tests from Tahiti. Truman''s Independence is on display at Dayton and Kennedy''s VC-118A at Tucson. Simpler and more economical than the DC-7 that followed it, the DC-6 outlived it: a few were still flying in Alaska in the 21st century.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-01-01',
    '1946-02-15',
    '1947-01-01',
    NULL,
    7995,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-118 Liftmaster'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-118 Liftmaster'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 32.18,
  wingspan          = 35.81,
  height            = 8.66,
  wing_area         = 135.9,
  empty_weight      = 20803,
  mtow              = 48625,
  service_ceiling   = 6675,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-CB16 Double Wasp (2 400 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 167,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 25,
  variants          = E'- **XC-112A** : prototype militaire du DC-6, premier vol le 15 février 1946, puis YC-112A\n- **VC-118** : DC-6 à fuselage court aménagé pour Truman, baptisé *Independence*\n- **C-118A** : DC-6A de l''US Air Force, 101 exemplaires ; **VC-118A** pour le transport d''autorités\n- **R6D-1** : DC-6A de l''US Navy, 65 exemplaires, devenus **C-118B** en 1962\n- **R6D-1Z** : quatre R6D-1 aménagés en transports d''état-major, devenus **VC-118B**',
  variants_en       = E'- **XC-112A**: military prototype of the DC-6, first flight on 15 February 1946, later YC-112A\n- **VC-118**: short-fuselage DC-6 fitted out for Truman, named *Independence*\n- **C-118A**: US Air Force DC-6A, 101 built; **VC-118A** for VIP transport\n- **R6D-1**: US Navy DC-6A, 65 built, redesignated **C-118B** in 1962\n- **R6D-1Z**: four R6D-1s converted as staff transports, redesignated **VC-118B**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_DC-6',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_DC-6',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Douglas C-118 Liftmaster';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Douglas C-118 Liftmaster';
