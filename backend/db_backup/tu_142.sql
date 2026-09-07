-- Tupolev Tu-142 Bear-F
--
-- Photo : Tu-142M-1982-DN-SN-82-10842-DPLS.jpg
--   licence CC BY 2.0 — Sergiy Kadulin from Kyiv, Ukraine
--   https://commons.wikimedia.org/wiki/File%3ANational_Aviation_Museum_%28Tupolev_Tu-142%29.jpg

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
    'Tu-142',
    'Tu-142',
    'Tupolev Tu-142 Bear-F',
    'Tupolev Tu-142 Bear-F',
    'Patrouilleur anti-sous-marin à très long rayon d’action, dérivé du Tu-95',
    'Very long-range anti-submarine patrol aircraft, derived from the Tu-95',
    '/assets/airplanes/tu142.jpg',
    E'## Genèse\nDans les années 1960, les sous-marins nucléaires américains patrouillent hors de portée de tout appareil soviétique. La marine réclame un patrouilleur capable de tenir l''Atlantique Nord et le Pacifique depuis ses propres bases. Tupolev reprend la cellule du **Tu-95**, seul appareil disponible avec une telle autonomie.\n\n## Conception\nLe fuselage est allongé, l''aile redessinée pour le vol prolongé à basse altitude, et le train renforcé pour les terrains sommaires. La soute reçoit bouées acoustiques, torpilles et charges. Les quatre **NK-12**, les turbopropulseurs les plus puissants jamais construits, entraînent des hélices contrarotatives dont les pales dépassent la vitesse du son en bout : le Tu-142 est l''un des avions les plus bruyants du monde, détectable au sonar depuis un sous-marin.\n\n## Carrière opérationnelle\nCinquante ans de patrouilles au-dessus de l''Atlantique, de l''Arctique et du Pacifique, et d''innombrables interceptions par des chasseurs de l''OTAN — le Bear est le sujet le plus photographié de la guerre froide aérienne. L''**Inde** l''a exploité de 1988 à 2017 depuis sa base de Rajali.\n\n## Place dans l''histoire\nToujours en service dans la marine russe, plus de cinquante ans après son premier vol et soixante-dix ans après celui de la cellule d''origine. Aucune autre lignée d''avions de combat n''a duré aussi longtemps.',
    E'## Genesis\nIn the 1960s American nuclear submarines patrolled beyond the reach of any Soviet aircraft. The navy demanded a patrol aircraft able to cover the North Atlantic and the Pacific from its own bases. Tupolev reused the **Tu-95** airframe, the only one available with such range.\n\n## Design\nThe fuselage was lengthened, the wing redesigned for sustained low-level flight, and the gear strengthened for rough fields. The bay took sonobuoys, torpedoes and depth charges. The four **NK-12s**, the most powerful turboprops ever built, drive contra-rotating propellers whose blade tips exceed the speed of sound: the Tu-142 is one of the loudest aircraft in the world, detectable on sonar from a submarine.\n\n## Operational career\nFifty years of patrols over the Atlantic, the Arctic and the Pacific, and countless interceptions by NATO fighters — the Bear is the most photographed subject of the Cold War in the air. **India** operated it from 1988 to 2017 from its Rajali base.\n\n## Place in history\nStill in Russian naval service more than fifty years after its first flight and seventy after that of the original airframe. No other line of combat aircraft has lasted as long.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1963-01-01',
    '1968-06-18',
    '1972-12-01',
    855.0,
    12000.0,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-142'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Tu-142'), (SELECT id FROM tech WHERE name = 'Réacteur Kuznetsov NK-12')),
((SELECT id FROM airplanes WHERE name = 'Tu-142'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-142'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Tu-142'), (SELECT id FROM armement WHERE name = 'APR-3')),
((SELECT id FROM airplanes WHERE name = 'Tu-142'), (SELECT id FROM armement WHERE name = 'Kh-35'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-142'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-142'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-142'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 53.08,
  wingspan          = 50.04,
  height            = 12.12,
  wing_area         = 289.9,
  empty_weight      = 91800,
  mtow              = 185000,
  service_ceiling   = 13500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 6500,
  crew              = 9,

  -- Strate 2 : motorisation
  engine_name       = 'Kuznetsov NK-12MP',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur à hélices contrarotatives',
  engine_type_en    = 'Contra-rotating turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1968,
  production_end    = 1994,
  units_built       = 100,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Tu-142M / MK** : versions successives à électronique de détection améliorée\n- **Tu-142MR** : relais de communication très basse fréquence avec les sous-marins lance-engins\n- **Tu-142MK-E** : version d''exportation livrée à l''**Inde**, retirée en 2017',
  variants_en       = E'- **Tu-142M / MK** : successive versions with improved detection electronics\n- **Tu-142MR** : very low frequency communications relay with ballistic missile submarines\n- **Tu-142MK-E** : export version delivered to **India**, retired in 2017',

  -- Strate 4 : qualitatif
  nickname          = 'Bear-F',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tupolev_Tu-142',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tupolev_Tu-142',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Tu-142';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tu-142';
