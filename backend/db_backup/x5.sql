-- Bell X-5
--
-- Photo : Bell X-5 Wings Sweep (E52-810).jpg
--   licence Public domain — NASA Armstrong Flight Research Center / NASA
--   https://commons.wikimedia.org/wiki/File:Bell_X-5_Wings_Sweep_(E52-810).jpg

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
    'Bell X-5',
    'Bell X-5',
    'Bell X-5',
    'Bell X-5',
    'Premier avion capable de changer la flèche de ses ailes en vol, ancêtre de toutes les géométries variables',
    'The first aircraft able to change the sweep of its wings in flight, ancestor of every swing-wing',
    '/assets/airplanes/bell-x5.jpg',
    E'## Genèse\nEn avril 1945, les troupes américaines s''emparent à Oberammergau du prototype inachevé du **Messerschmitt P.1101**, un chasseur dont la flèche des ailes pouvait être réglée au sol à 30, 40 ou 45°, pour les seuls essais. Endommagé pendant le transport, il finit à l''usine **Bell** de Buffalo, où les ingénieurs l''étudient de près. L''équipe du chef designer **Robert J. Woods** propose alors un appareil semblable en apparence, mais dont la flèche se modifierait en vol.\n\n## Conception\nLe X-5 est bien plus complexe que son modèle allemand. Un **vérin à vis** entraîné par des moteurs électriques déplace l''articulation des ailes le long de courts rails horizontaux, et des freins à disque les bloquent dans trois positions : 20°, 40° et 60°. Le passage de l''extension complète à la flèche maximale prend moins de 30 secondes, et le recul de l''articulation compense en partie le déplacement du centre de gravité et du centre de poussée. Mais l''empennage est mal placé : dans certaines positions d''ailes, l''avion peut entrer dans une vrille irrécupérable.\n\n## Essais\nDeux X-5 sont construits. Ils volent pour la première fois le 20 juin et le 10 décembre 1951 et accomplissent près de 200 vols, jusqu''à Mach 0,9 et 12 000 m d''altitude. En octobre 1953, le second appareil ne sort pas d''une vrille en flèche de 60° et s''écrase à Edwards, tuant son pilote de l''Air Force, **Raymond Popson**. Ces défauts font aussi abandonner le projet d''en tirer un chasseur tactique bon marché pour l''OTAN. Le survivant poursuit les essais jusqu''en 1955, puis sert d''avion d''accompagnement jusqu''en 1958.\n\n## Place dans l''histoire\nMalgré son instabilité, le X-5 a démontré l''intérêt d''une aile à flèche variable pour un avion appelé à voler dans une large gamme de vitesses. L''idée sera reprise avec une articulation placée à l''extérieur du fuselage plutôt qu''à l''intérieur, sur le **F-111**, le **F-14 Tomcat**, le **MiG-23**, le **Su-24**, le **Tornado** ou le **B-1 Lancer**. L''exemplaire survivant est exposé depuis mars 1958 au musée national de l''US Air Force, à Dayton.',
    E'## Genesis\nIn April 1945 American troops captured the unfinished prototype of the **Messerschmitt P.1101** at Oberammergau, a fighter whose wing sweep could be set on the ground to 30, 40 or 45 degrees, for testing only. Damaged in transit, it ended up at the **Bell** factory in Buffalo, where engineers studied it closely. The team of chief designer **Robert J. Woods** then proposed a similar-looking aircraft whose sweep could be changed in flight.\n\n## Design\nThe X-5 was far more complex than its German model. A **jackscrew** driven by electric motors moved the wing hinge along short horizontal rails, and disc brakes locked the wings in three positions: 20, 40 and 60 degrees. Going from full extension to full sweep took less than 30 seconds, and the movement of the hinge partly compensated for the shift in the centre of gravity and centre of pressure. But the tail was poorly placed: in some wing positions the aircraft could enter an unrecoverable spin.\n\n## Testing\nTwo X-5s were built. They first flew on 20 June and 10 December 1951 and made almost 200 flights, up to Mach 0.9 and 12,000 m. In October 1953 the second aircraft failed to recover from a spin at 60 degrees of sweep and crashed at Edwards, killing its Air Force pilot, **Raymond Popson**. These flaws also killed a plan to turn it into a low-cost tactical fighter for NATO. The survivor continued testing until 1955, then served as a chase plane until 1958.\n\n## Place in history\nDespite its instability, the X-5 demonstrated the value of a variable-sweep wing for an aircraft meant to fly across a wide range of speeds. The idea was taken up again with an outboard rather than inboard pivot, on the **F-111**, the **F-14 Tomcat**, the **MiG-23**, the **Su-24**, the **Tornado** and the **B-1 Lancer**. The surviving aircraft has been displayed since March 1958 at the National Museum of the US Air Force in Dayton.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1951-06-20',
    NULL,
    1135,
    1210,
    (SELECT id FROM manufacturer WHERE code = 'BEL'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell X-5'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell X-5'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.16,
  wingspan          = 10.21,
  height            = 3.66,
  wing_area         = 16.3,
  empty_weight      = 2880,
  mtow              = 4479,
  service_ceiling   = 12800,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J35-A-17A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 21.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **50-1838** : premier exemplaire, achevé le 15 février 1951, premier vol le 20 juin 1951, avion d''accompagnement jusqu''en 1958, conservé à Dayton\n- **50-1839** : second exemplaire, premier vol le 10 décembre 1951, détruit en vrille en octobre 1953\n- **Trois positions de flèche** : 20°, 40° et 60°, envergure ramenée de 10,21 m à 6,32 m en flèche maximale\n- **Chasseur tactique pour l''OTAN** : version d''arme à bas coût envisagée par l''US Air Force, abandonnée à cause des vrilles',
  variants_en       = E'- **50-1838**: first aircraft, completed on 15 February 1951, first flight on 20 June 1951, chase plane until 1958, preserved at Dayton\n- **50-1839**: second aircraft, first flight on 10 December 1951, destroyed in a spin in October 1953\n- **Three sweep positions**: 20, 40 and 60 degrees, span reduced from 10.21 m to 6.32 m at full sweep\n- **Tactical fighter for NATO**: low-cost combat version considered by the US Air Force, dropped because of the spin problems',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bell_X-5',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bell_X-5',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA Armstrong Flight Research Center',
  image_licence     = 'Public domain'
WHERE name = 'Bell X-5';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bell X-5';
