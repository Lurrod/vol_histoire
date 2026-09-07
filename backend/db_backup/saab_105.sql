-- Saab 105
--
-- Photo : Saab 105OE 10.jpg
--   licence CC BY-SA 2.0 — Matt Morgan
--   https://commons.wikimedia.org/wiki/File%3ASaab_105OE_10.jpg

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
    'Saab 105',
    'Saab 105',
    'Saab 105',
    'Saab 105',
    'Entraîneur et appareil d’attaque légère suédois à sièges côte à côte',
    'Swedish side-by-side trainer and light attack aircraft',
    '/assets/airplanes/saab-105.jpg',
    E'## Genèse\nLe Saab 105 est né d''un projet **civil** : un petit biréacteur d''affaires à cinq places, développé sur fonds propres à la fin des années 1950. Aucun client civil ne se présente. L''armée de l''air suédoise, elle, y voit le remplaçant de ses entraîneurs à hélice et commande 150 appareils.\n\n## Conception\nAile haute, deux petits réacteurs, et surtout des sièges **côte à côte** — inhabituel pour un entraîneur militaire, mais hérité du projet civil et jugé excellent pour l''instruction. Les sièges arrière du projet d''origine sont remplaçables par des sièges éjectables, ce qui permet aussi le transport de liaison.\n\n## Carrière opérationnelle\nCinquante-trois ans de service en Suède, où il assure aussi bien la formation que l''attaque légère et la reconnaissance, dans la logique nationale de dispersion en temps de guerre. L''**Autriche** en acquiert 40, remotorisés, qui tiennent la police du ciel autrichienne jusqu''en 2020.\n\n## Place dans l''histoire\nC''est le seul appareil de la Flygvapnet à avoir été conçu d''abord pour le marché civil. Sa longévité et sa polyvalence illustrent, à petite échelle, la même doctrine que le Lansen ou le Viggen : une cellule, plusieurs métiers, une industrie nationale complète.',
    E'## Genesis\nThe Saab 105 began as a **civil** project: a small five-seat business twinjet, privately developed in the late 1950s. No civil customer appeared. The Swedish Air Force, however, saw in it the replacement for its piston trainers and ordered 150 aircraft.\n\n## Design\nA high wing, two small engines, and above all **side-by-side** seating — unusual for a military trainer, but inherited from the civil project and judged excellent for instruction. The rear seats of the original design can be swapped for ejection seats, which also allows liaison transport.\n\n## Operational career\nFifty-three years of Swedish service, covering training, light attack and reconnaissance alike, in keeping with the national doctrine of wartime dispersal. **Austria** acquired 40 re-engined aircraft, which held Austrian air policing until 2020.\n\n## Place in history\nIt is the only Flygvapnet aircraft originally designed for the civil market. Its longevity and versatility illustrate, on a small scale, the same doctrine as the Lansen or the Viggen: one airframe, several trades, a complete national industry.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    '1960-01-01',
    '1963-06-29',
    '1967-01-01',
    970.0,
    1400.0,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 105'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'Saab 105'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 105'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Saab 105'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Saab 105'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 105'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Saab 105'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Saab 105'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 105'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.5,
  wingspan          = 9.5,
  height            = 2.7,
  wing_area         = 16.3,
  empty_weight      = 2510,
  mtow              = 6500,
  service_ceiling   = 13500,
  climb_rate        = 55,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Turbomeca Aubisque',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 7.3,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1972,
  units_built       = 192,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Sk 60** : désignation suédoise de l''entraîneur\n- **Sk 60B / C** : versions d''attaque légère et de reconnaissance\n- **Saab 105OE** : version autrichienne à moteurs General Electric J85, retirée en 2020\n- Projet civil d''origine : un avion d''affaires à cinq places, jamais commercialisé',
  variants_en       = E'- **Sk 60** : Swedish trainer designation\n- **Sk 60B / C** : light attack and reconnaissance versions\n- **Saab 105OE** : Austrian version with General Electric J85 engines, retired in 2020\n- Original civil project: a five-seat business aircraft, never marketed',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Saab_105',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saab_105',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Matt Morgan',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Saab 105';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saab 105';
