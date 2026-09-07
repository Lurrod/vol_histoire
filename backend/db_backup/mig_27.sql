-- Mikoyan-Gourevitch MiG-27
--
-- Photo : Mig-27 Flogger (14606561972).jpg
--   licence CC BY 2.0 — Ronnie Macdonald from Chelmsford and Largs, United Kingdom
--   https://commons.wikimedia.org/wiki/File%3AMig-27_Flogger_%2814606561972%29.jpg

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
    'MiG-27',
    'MiG-27',
    'Mikoyan-Gourevitch MiG-27',
    'Mikoyan-Gurevich MiG-27',
    'Dérivé d’attaque au sol du MiG-23, spécialisé et simplifié',
    'Ground-attack derivative of the MiG-23, specialised and simplified',
    '/assets/airplanes/mig27.jpg',
    E'## Genèse\nLe MiG-23BN, version d''attaque du chasseur MiG-23, traîne un héritage encombrant : un radar d''interception inutile au sol, une entrée d''air variable conçue pour Mach 2,3 dont l''attaque au sol n''a que faire. Mikoyan en tire un appareil dédié, en supprimant tout ce qui ne sert pas à frapper.\n\n## Conception\nLe nez effilé disparaît au profit d''un nez plat en **bec de canard**, offrant au pilote une vue plongeante et logeant un télémètre laser. Les entrées d''air deviennent fixes, plus simples et plus légères. La cabine et les circuits vitaux reçoivent un blindage. Le canon rotatif de 30 mm est si puissant que son tir prolongé endommage la cellule.\n\n## Carrière opérationnelle\nPilier de l''aviation d''assaut soviétique en **Afghanistan**, où sa capacité d''emport et son blindage font la différence. L''Inde en produit sous licence plus de 160 sous le nom de **Bahadur** et les engage jusqu''en 2019 ; le Sri Lanka et le Kazakhstan l''utilisent également.\n\n## Place dans l''histoire\nLe MiG-27 illustre une pratique soviétique constante : décliner une cellule de chasse en version d''attaque spécialisée plutôt que concevoir un appareil neuf. Le Su-25, conçu d''emblée pour l''appui, prendra le relais dans les missions les plus exposées.',
    E'## Genesis\nThe MiG-23BN, the attack version of the MiG-23 fighter, carried awkward baggage: an interception radar useless against the ground, and a variable intake designed for Mach 2.3 that ground attack had no use for. Mikoyan derived a dedicated aircraft from it by removing everything that did not serve striking.\n\n## Design\nThe pointed nose gave way to a flat **duck-bill** nose, giving the pilot a downward view and housing a laser rangefinder. The intakes became fixed, simpler and lighter. The cockpit and vital systems received armour. The 30 mm rotary cannon was so powerful that sustained fire damaged the airframe.\n\n## Operational career\nA mainstay of Soviet assault aviation in **Afghanistan**, where its payload and armour made the difference. India licence-built more than 160 as the **Bahadur** and flew them until 2019; Sri Lanka and Kazakhstan also operated the type.\n\n## Place in history\nThe MiG-27 illustrates a constant Soviet practice: derive a specialised attack version from a fighter airframe rather than design a new aircraft. The Su-25, designed from the start for close support, took over the most exposed missions.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1967-01-01',
    '1972-08-17',
    '1975-01-01',
    1885.0,
    2500.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM tech WHERE name = 'Pod désignateur laser'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM armement WHERE name = 'GSh-6-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM armement WHERE name = 'Kh-25ML')),
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM armement WHERE name = 'Kh-29L')),
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM armement WHERE name = 'R-60')),
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM armement WHERE name = 'S-24'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'MiG-27'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.08,
  wingspan          = 13.97,
  height            = 5.0,
  wing_area         = 37.35,
  empty_weight      = 11908,
  mtow              = 20670,
  service_ceiling   = 14000,
  climb_rate        = 200,
  g_limit_pos       = 7.0,
  g_limit_neg       = NULL,
  combat_radius     = 780,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Tumansky R-29B-300',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 78.5,
  thrust_wet        = 112.8,

  -- Strate 3 : production & service
  production_start  = 1973,
  production_end    = 1994,
  units_built       = 1075,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **MiG-27** : version initiale, canon GSh-6-30\n- **MiG-27K Kaïra** : désignation laser et télévision, la plus capable\n- **MiG-27M / D** : avionique intermédiaire, largement exportée\n- **HAL Bahadur** : production sous licence indienne, retirée en 2019',
  variants_en       = E'- **MiG-27** : initial version with GSh-6-30 gun\n- **MiG-27K Kaira** : laser and television designation, the most capable\n- **MiG-27M / D** : intermediate avionics, widely exported\n- **HAL Bahadur** : Indian licence production, retired in 2019',

  -- Strate 4 : qualitatif
  nickname          = 'Flogger-D',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_MiG-27',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mikoyan-Gurevich_MiG-27',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ronnie Macdonald from Chelmsford and Largs, United Kingdom',
  image_licence     = 'CC BY 2.0'
WHERE name = 'MiG-27';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MiG-27';
